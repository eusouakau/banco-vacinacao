CREATE OR REPLACE PROCEDURE PRC_FAIXA_ETARIA IS

--Retorna N linhas com a QTDE de pessoas nas determinadas faixas Etárias (10 em 10 anos)
--Que receberam vacinas por POSTO
--Utilizar cursor implícito
--Utiliza DBMS_OUTPUT.PUT_LINE para mostrar os resultados

BEGIN
  DBMS_OUTPUT.PUT_LINE('POSTO   NOME        '||'10-19  20-29  30-39  40-49  50-59  60-69  70-79  80-89  90-99  TOTAL');
  --
  FOR R_FAIXA IN (SELECT P.ID_POSTO,P.NOME,
                         SUM(CASE WHEN FNC_IDADE(C.ID_CIDADAO) BETWEEN 10 AND 19 THEN 1 ELSE 0 END) FX10,
                         SUM(CASE WHEN FNC_IDADE(C.ID_CIDADAO) BETWEEN 20 AND 29 THEN 1 ELSE 0 END) FX20,
                         SUM(CASE WHEN FNC_IDADE(C.ID_CIDADAO) BETWEEN 30 AND 39 THEN 1 ELSE 0 END) FX30,
                         SUM(CASE WHEN FNC_IDADE(C.ID_CIDADAO) BETWEEN 40 AND 49 THEN 1 ELSE 0 END) FX40,
                         SUM(CASE WHEN FNC_IDADE(C.ID_CIDADAO) BETWEEN 50 AND 59 THEN 1 ELSE 0 END) FX50,
                         SUM(CASE WHEN FNC_IDADE(C.ID_CIDADAO) BETWEEN 60 AND 69 THEN 1 ELSE 0 END) FX60,
                         SUM(CASE WHEN FNC_IDADE(C.ID_CIDADAO) BETWEEN 70 AND 79 THEN 1 ELSE 0 END) FX70,
                         SUM(CASE WHEN FNC_IDADE(C.ID_CIDADAO) BETWEEN 80 AND 89 THEN 1 ELSE 0 END) FX80,
                         SUM(CASE WHEN FNC_IDADE(C.ID_CIDADAO) BETWEEN 90 AND 99 THEN 1 ELSE 0 END) FX90,
                         COUNT(1) TOTAL
                  FROM   POSTO P
                  INNER  JOIN POSSUI PS
                  ON     P.ID_POSTO = PS.ID_POSTO
                  INNER  JOIN VACINA V
                  ON     V.ID_VACINA = PS.ID_VACINA
                  INNER  JOIN DOSE D
                  ON     D.ID_VACINA = V.ID_VACINA
                  INNER  JOIN CIDADAO C
                  ON     C.ID_CIDADAO = D.ID_CIDADAO
                  GROUP  BY P.ID_POSTO, P.NOME)
  LOOP
    DBMS_OUTPUT.PUT_LINE(RPAD(R_FAIXA.ID_POSTO,8)||RPAD(R_FAIXA.NOME,10)||LPAD(R_FAIXA.FX10,5)||
                         LPAD(R_FAIXA.FX20,7)||LPAD(R_FAIXA.FX30,7)||
                         LPAD(R_FAIXA.FX40,7)||LPAD(R_FAIXA.FX50,7)||
                         LPAD(R_FAIXA.FX60,7)||LPAD(R_FAIXA.FX70,7)||
                         LPAD(R_FAIXA.FX80,7)||LPAD(R_FAIXA.FX90,7)||LPAD(R_FAIXA.TOTAL,7));
  END LOOP;
END PRC_FAIXA_ETARIA;
/

CREATE OR REPLACE PROCEDURE PRC_ATUALIZA_RETORNO IS

  --Atualiza DATA_RETORNO
  --Atualiza todas as linhas da tabela DOSE conforme parâmetros
  --Chamada no trigger TRG_AFTER_U_VACINA
  
BEGIN
  FOR R_VACINA IN (SELECT * FROM VACINA)
    LOOP
    UPDATE DOSE
    SET    DATA_RETORNO = DATA_APLICACAO + R_VACINA.TEMPO_ENTRE_APLICACOES
    WHERE  ID_VACINA = R_VACINA.ID_VACINA;
  END LOOP;
 
END PRC_ATUALIZA_RETORNO;
/

CREATE OR REPLACE PROCEDURE PRC_ATUALIZA_DOSE(QT_REGISTROS OUT NUMBER) IS

  --Atualiza DATA_RETORNO da Tabela DOSE com base no TEMPO_ENTRE_APLICACOES da tabela VACINA
  --Atualiza todas as linhas da tabela DOSE
  --Utiliza cursor explicito  
  --QT_REGISTROS (OUT)
  --Retorna Quantidade de Registros da tabela VACINA
  
  CURSOR C_VACINA IS
    SELECT *
    FROM   VACINA;

  R_VACINA C_VACINA%ROWTYPE;

BEGIN
  QT_REGISTROS := 0;
  
  OPEN C_VACINA;
  LOOP
    FETCH C_VACINA
      INTO R_VACINA;
    EXIT WHEN C_VACINA%NOTFOUND;
    --
    QT_REGISTROS :=  QT_REGISTROS + 1;
    UPDATE DOSE
    SET    DATA_RETORNO = DATA_APLICACAO + R_VACINA.TEMPO_ENTRE_APLICACOES
    WHERE  ID_VACINA = R_VACINA.ID_VACINA;
  END LOOP;
  CLOSE C_VACINA;

  COMMIT;
  
END PRC_ATUALIZA_DOSE;
/

CREATE OR REPLACE PROCEDURE PRC_DADOS(P_ID_POSTO IN NUMBER,
                                      P_NOME     OUT VARCHAR2,
                                      P_MEDIA    OUT NUMBER,
                                      P_QTDE     OUT NUMBER) IS
  --Parametro IN - ID_POSTO
  --Parametro OUT - (Posto,Média Idade, Quantidade)
  
BEGIN
  FOR R_DADOS IN (SELECT p.nome,
                         COUNT(c.id_cidadao) as QTDE,
                         AVG(c.idade) as media
                  FROM   posto p
                  INNER  JOIN possui ps
                  ON     p.id_posto = ps.id_posto
                  INNER  JOIN vacina v
                  ON     v.id_vacina = ps.id_vacina
                  INNER  JOIN dose d
                  ON     d.id_vacina = v.id_vacina
                  INNER  JOIN cidadao c
                  ON     c.id_cidadao = d.id_cidadao
                  WHERE  p.id_posto = p_id_posto
                  GROUP  BY p.nome)
  LOOP
    P_NOME  := R_DADOS.NOME;
    P_MEDIA := Round(R_DADOS.MEDIA,2);
    P_QTDE  := R_DADOS.QTDE;
  END LOOP;
  
END PRC_DADOS;
/