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
