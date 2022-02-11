CREATE OR REPLACE FUNCTION FNC_VACINA(P_ID_VACINA IN NUMBER)
  RETURN NUMBER IS
  --Retorna Qtde de pessoas vacinadas de uma determinada VACINA
  --Utilizar no SELECT
  QT_VACINA NUMBER;

BEGIN
  SELECT COUNT(1)
  INTO   QT_VACINA
  FROM   DOSE
  WHERE  ID_VACINA = P_ID_VACINA;

  RETURN(QT_VACINA);
END FNC_VACINA;
/

--Utilizar no SELECT
--SELECT ID_VACINA, FNC_VACINA(ID_VACINA) QTDE
--FROM VACINA
--ORDER BY ID_VACINA;


CREATE OR REPLACE FUNCTION FNC_IDADE(P_ID_CIDADAO IN NUMBER)
  RETURN NUMBER IS
  --Retorna a IDADE do CIDADAO
  --Utilizar no SELECT
  IDADE NUMBER;

BEGIN
  SELECT TRUNC((SYSDATE - DT_NASCIMENTO) /365)
    INTO IDADE
    FROM CIDADAO
   WHERE ID_CIDADAO = P_ID_CIDADAO;

  RETURN(IDADE);
END FNC_IDADE;

--Utilizar no SELECT
--SELECT ID_CIDADAO, NOME, FNC_IDADE(ID_CIDADAO) IDADE
--FROM CIDADAO
--ORDER BY NOME;
/

CREATE OR REPLACE FUNCTION FNC_MEDIA_IDADE(P_ID_POSTO IN NUMBER)
  RETURN NUMBER IS
  --Retorna Média Idade das pessoas vacinas em determinado Posto
  --Utilizar no SELECT
  MEDIA NUMBER;

BEGIN
  SELECT ROUND(AVG(C.IDADE),2)
  INTO   MEDIA
  FROM   POSTO P
  INNER  JOIN POSSUI PS
  ON     P.ID_POSTO = PS.ID_POSTO
  INNER  JOIN VACINA V
  ON     V.ID_VACINA = PS.ID_VACINA
  INNER  JOIN DOSE D
  ON     D.ID_VACINA = V.ID_VACINA
  INNER  JOIN CIDADAO C
  ON     C.ID_CIDADAO = D.ID_CIDADAO
  WHERE  P.ID_POSTO = P_ID_POSTO;

  RETURN(MEDIA);
END FNC_MEDIA_IDADE;


--Utilizar no SELECT
--SELECT ID_POSTO,NOME, FNC_MEDIA_IDADE(ID_POSTO) MEDIA
--FROM POSTO
--ORDER BY NOME;
/


CREATE OR REPLACE FUNCTION FNC_DOSE(P_ID_CIDADAO IN NUMBER)
  RETURN DATE IS
  --Retorna a ultima data da aplicação (Máxima)
  --Utilizar no SELECT
  DT_APLICA DATE;

BEGIN
  SELECT MAX(DATA_APLICACAO)
  INTO   DT_APLICA
  FROM   DOSE
  WHERE  ID_CIDADAO = P_ID_CIDADAO;

  RETURN(DT_APLICA);
END FNC_DOSE;


--Utilizar no SELECT
--SELECT ID_CIDADAO, NOME, FNC_DOSE(ID_CIDADAO) "ULTIMA DATA"
--FROM CIDADAO
--ORDER BY NOME;
/
