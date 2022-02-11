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


--Utilizar no SELECT
--SELECT ID_VACINA, FNC_VACINA(ID_VACINA) QTDE
--FROM VACINA
--ORDER BY ID_VACINA;
/