CREATE TABLE Dose (
id_dose NUMERIC(20) PRIMARY KEY,
data_aplicacao DATE,
data_retorno DATE,
id_cidadao NUMERIC(20),
id_vacina NUMERIC(20)
);

CREATE TABLE Cidadao (
id_cidadao NUMERIC(20) PRIMARY KEY,
endereco VARCHAR2(50),
contato VARCHAR2(50),
cpf VARCHAR2(50),
nome VARCHAR2(50),
idade NUMERIC(20),
dt_nascimento DATE
);

CREATE TABLE Posto (
id_posto NUMERIC(20) PRIMARY KEY,
nome VARCHAR2(50),
endereco VARCHAR2(50),
unidade VARCHAR2(50)
);

CREATE TABLE Vacina (
id_vacina NUMERIC(20) PRIMARY KEY,
nome_fabricante VARCHAR2(50),
data_fabricacao DATE,
data_validade DATE,
tempo_entre_aplicacoes NUMERIC(20),
lote VARCHAR2(50)
);

CREATE TABLE possui (
id_posto NUMERIC(20),
id_vacina NUMERIC(20),
PRIMARY KEY(id_posto,id_vacina),
FOREIGN KEY(id_posto) REFERENCES Posto (id_posto),
FOREIGN KEY(id_vacina) REFERENCES Vacina (id_vacina)
);

ALTER TABLE Dose ADD FOREIGN KEY(id_cidadao) REFERENCES Cidadao (id_cidadao);
ALTER TABLE Dose ADD FOREIGN KEY(id_vacina) REFERENCES Vacina (id_vacina);

CREATE SEQUENCE s_dose START WITH 1 NOCACHE;
CREATE SEQUENCE s_cidadao START WITH 10  NOCACHE;
CREATE SEQUENCE s_posto START WITH 100 NOCACHE;
CREATE SEQUENCE s_vacina START WITH 1000 NOCACHE;

