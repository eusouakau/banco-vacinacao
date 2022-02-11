Sequência de execução
drop.sql
create.sql
insert.sql

Após executar
function.sql
procedure.sql
trigger.sql


--**********************************************************
--EXECUTANDO



--PROCEDURE PRC_ATUALIZA_DOSE
--Atualiza DATA_RETORNO da Tabela DOSE com base no TEMPO_ENTRE_APLICACOES da tabela VACINA
--Atualiza todas as linhas da tabela DOSE
--Utiliza cursor explicito  
--QT_REGISTROS (OUT)
--Retorna Quantidade de Registros da tabela VACINA
DECLARE
  QT_REGISTROS NUMBER;
BEGIN
  PRC_ATUALIZA_DOSE(QT_REGISTROS);
  DBMS_OUTPUT.PUT_LINE('REGISTROS ATUALIZADOS: '||QT_REGISTROS);
END;

--PROCEDURE PRC_FAIXA_ETARIA
--Retorna N linhas com a QTDE de pessoas nas determinadas faixas Etárias (10 em 10 anos)
--Que receberam vacinas por POSTO
--Utilizar cursor implícito
--Utiliza DBMS_OUTPUT.PUT_LINE para mostrar os resultados
BEGIN
  PRC_FAIXA_ETARIA;
END;

--PROCEDURE PRC_DADOS
--Parametro IN (ID_POSTO)
--Parametros OUT (Posto, Média Idade, Quantidade)
DECLARE
  POSTO VARCHAR2(100);
  MEDIA NUMBER;
  QTDE  NUMBER;
BEGIN
  PRC_DADOS(100, --ID_POSTO
            POSTO,
            MEDIA,
            QTDE);
  DBMS_OUTPUT.PUT_LINE('Posto: ' || POSTO);
  DBMS_OUTPUT.PUT_LINE('Media: ' || MEDIA);
  DBMS_OUTPUT.PUT_LINE('Qtde : ' || QTDE);
END;


--**********************************************************
--FNC_DOSE
--Retorna a ultima data da aplicação (Máxima)
SELECT ID_CIDADAO, NOME, FNC_DOSE(ID_CIDADAO) "ULTIMA DATA"
  FROM CIDADAO
ORDER BY NOME;

--FNC_IDADE
--Retorna a IDADE do CIDADAO
SELECT ID_CIDADAO, NOME, FNC_IDADE(ID_CIDADAO) IDADE
  FROM CIDADAO
ORDER BY NOME;

--FNC_VACINA
--Retorna Qtde de pessoas vacinadas de uma determinada VACINA
SELECT ID_VACINA, FNC_VACINA(ID_VACINA) QTDE
  FROM VACINA
ORDER BY ID_VACINA;

--FNC_MEDIA_IDADE
--Retorna Média Idade das pessoas vacinas em determinado Posto
SELECT ID_POSTO,NOME, FNC_MEDIA_IDADE(ID_POSTO) MEDIA
  FROM POSTO
ORDER BY NOME;



--**********************************************************
--TRIGGER TRG_BEFORE_IU_DOSE (Validação)
--BEFORE INSERT OR UPDATE OF DATA_APLICACAO,DATA_RETORNO ON DOSE

--Valida DATA_APLICAÇÃO em relaçao a data de hoje
--Valida DATA_RETORNO com base no intervalo da Vacina
--Valida DATA_RETORNO em relaçao a data DATA_APLICAÇÃO (Deve ser Maior+Intervalo)

SELECT * FROM DOSE  WHERE ID_DOSE = 1;

--Validar
--Alterar DATA_APLICACAO
UPDATE DOSE
   SET DATA_APLICACAO = TRUNC(SYSDATE)
 WHERE ID_DOSE = 1;

--Alterar DATA_RETORNO
UPDATE DOSE
   SET DATA_RETORNO = TRUNC(SYSDATE)
 WHERE ID_DOSE = 1;

--Inserir
--DATA_APLICACAO = DATA_RETORNO
INSERT INTO DOSE ( ID_DOSE, DATA_APLICACAO, DATA_RETORNO,ID_CIDADAO, ID_VACINA ) 
     VALUES( S_DOSE.NEXTVAL, TRUNC(SYSDATE), TRUNC(SYSDATE), 10, 1000 );


--TRIGGER TRG_AFTER_U_VACINA (Atualização)
--AFTER UPDATE OF TEMPO_ENTRE_APLICACOES ON VACINA

--Chama a PRC_ATUALIZA_RETORNO;
--Atualiza DATA_RETORNO na tabela DOSE
--Após alteração da coluna TEMPO_ENTRE_APLICACOES da tabela VACINA

--Trigger do tipo STATEMENT 

--Verificar
SELECT * FROM VACINA WHERE ID_VACINA = 1000;
SELECT * FROM DOSE WHERE ID_VACINA = 1000;

--Alterar TEMPO_ENTRE_APLICACOES
UPDATE VACINA SET TEMPO_ENTRE_APLICACOES = 90
WHERE ID_VACINA = 1000;
COMMIT;

SELECT * FROM VACINA WHERE ID_VACINA = 1000;
SELECT * FROM DOSE WHERE ID_VACINA = 1000;




