CREATE OR REPLACE TRIGGER TRG_BEFORE_IU_DOSE
  BEFORE INSERT OR UPDATE OF DATA_APLICACAO,DATA_RETORNO ON DOSE
  REFERENCING NEW AS NEW OLD AS OLD
  FOR EACH ROW
  --Valida DATA_APLICAÇÃO em relaçao a data de hoje
  --Valida DATA_RETORNO com base no intervalo da Vacina
  --Valida DATA_RETORNO em relaçao a data DATA_APLICAÇÃO (Deve ser Maior + Intervalo)
DECLARE
  INTERVALO NUMBER;

BEGIN
  BEGIN
    SELECT TEMPO_ENTRE_APLICACOES
    INTO   INTERVALO
    FROM   VACINA
    WHERE  ID_VACINA = :NEW.ID_VACINA;
  EXCEPTION
    WHEN OTHERS THEN
    INTERVALO := 0;
  END;
  -- Insert
  IF (INSERTING) THEN
    --Valida DATA_APLICAÇÃO em relaçao a data de hoje
    IF :NEW.DATA_APLICACAO < TRUNC(SYSDATE) THEN
      RAISE_APPLICATION_ERROR(-20000,
                              'Data da aplicação deve ser MAIOR/IGUAL a data de hoje '||TO_CHAR(SYSDATE,'DD/MM/RRRR'),TRUE);
    END IF;
    --Valida DATA_RETORNO com base no intervalo da Vacina
    IF :NEW.DATA_RETORNO <> (:NEW.DATA_APLICACAO + INTERVALO) THEN
      RAISE_APPLICATION_ERROR(-20000,
                              'Data da retorno deve MAIOR e respeitar o intervalo de '||INTERVALO||' Dias',TRUE);
    END IF;
  END IF;
  --Update
  IF (UPDATING) THEN
    --Valida DATA_APLICAÇÃO em relaçao a data de hoje
    IF :NEW.DATA_APLICACAO <> :OLD.DATA_APLICACAO THEN
      IF :NEW.DATA_APLICACAO < TRUNC(SYSDATE) THEN
        RAISE_APPLICATION_ERROR(-20000,
                                'Data da aplicação deve ser MAIOR/IGUAL a data de hoje '||TO_CHAR(SYSDATE,'DD/MM/RRRR'),TRUE);
      END IF;
    END IF;
    --Valida DATA_RETORNO com base no intervalo da Vacina
    IF :NEW.DATA_RETORNO <> :OLD.DATA_RETORNO THEN
      IF :NEW.DATA_RETORNO <> (:NEW.DATA_APLICACAO + INTERVALO) THEN
        RAISE_APPLICATION_ERROR(-20000,
                                'Data da retorno deve respeitar o intervalo de '||INTERVALO||' Dias',TRUE);
      END IF;
    END IF;
    --Valida DATA_RETORNO com base na DATA_APLICACAO
    IF :NEW.DATA_APLICACAO <> :OLD.DATA_APLICACAO THEN
      IF :NEW.DATA_RETORNO < (:NEW.DATA_APLICACAO + INTERVALO) THEN
        RAISE_APPLICATION_ERROR(-20000,
                                'Data da retorno deve MAIOR e respeitar o intervalo de '||INTERVALO||' Dias',TRUE);
      END IF;
    END IF;

  END IF;

END TRG_BEFORE_IU_DOSE;
/
