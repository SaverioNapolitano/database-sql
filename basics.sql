--CREATE TABLE: crea una tabella
--Sintassi: CRESTE TABLE nome_tabella(
    --nome_colonna tipo [vincoli di colonna],
    --nome_colonna tipo [vincoli di colonna],
    --...
    --[CONSTRAINT nome_vincolo] definizione,
    --[CONSTRAINT nome_vincolo] definizione,
--);
--NB: [] = opzionale
CREATE TABLE personaA10(
     nome VARCHAR(50), cognome VARCHAR(50)
);

CREATE TABLE personaB10(
     nome VARCHAR(50), cognome VARCHAR(50)
);

CREATE TABLE personaC10(
     nome VARCHAR(50), cognome VARCHAR(50)
);

--INSERT: inserisce valore nella tabella
--Sintassi: INSERT INTO nome_tabella [(nome_colonna1, nome_colonna2, ...)] VALUES (valore_colonna1, valore_colonna2, ...);
--NB: Se non specificate le colonne per le quali si vogliono inserire i dati, 
--occorre inserire i valori per tutte le colonne create, e nello stesso ordine di creazione.
INSERT INTO personaA10 VALUES ('saverio', 'napolitano');
INSERT INTO personaA10 (cognome, nome) VALUES ('rossi', 'mario');

--I valori corrispondenti agli attributi mancanti vengono posti uguali al valore NULL (oppure al valore di default)
INSERT INTO personaA10 (cognome) VALUES ('verde');

--Non posso inserire meno valori di quanti sono gli attributi ad esempio non posso scrivere
--INSERT INTO personaA10 VALUES ('bianchi');
--Posso usare NULL come valore da inserire esplicitamente
INSERT INTO personaA10 VALUES (NULL, 'bianchi');

--TRUNCATE: elimina i dati contenuti in una tabella
--Sintassi: TRUNCATE nome_tabella
TRUNCATE TABLE personaA10;

--DROP TABLE: elimina una tabella da un database
--Sintassi: DROP TABLE nome_tabella
DROP TABLE personaA10;

--PRIMARY KEY: indica che l'attributo (o l'insieme di attributi) è chiave primaria
--NOT NULL: indica che l'attributo non può assumere valori nulli
CREATE TABLE STUDENTE(
    Matr INTEGER PRIMARY KEY,
    Nome VARCHAR(10) NOT NULL,
    Mail VARCHAR(20)
);

CREATE TABLE DOCENTE(
    CF VARCHAR(16) PRIMARY KEY,
    Nome VARCHAR(10) NOT NULL
);

--REFERENCES: indica che l'attributo è foreign key
CREATE TABLE CORSO(
    Codice INTEGER PRIMARY KEY,
    Denom VARCHAR(10) NOT NULL,
    CFDocente VARCHAR(16) REFERENCES DOCENTE NOT NULL
);

CREATE TABLE ESAME(
    Matr INTEGER,
    Codice INTEGER,
    Voto INTEGER NOT NULL,
    PRIMARY KEY(Matr, Codice)
);

--USE: connette ad un database
--Sintassi: USE nome_database

--CREATE DATABASE: crea un database
--Sintassi: CREATE DATABASE nome_database
--NB: va eseguita su database master (in System Database)
USE master;
CREATE DATABASE anagrafica;
USE anagrafica;
CREATE TABLE persona(
    nome VARCHAR(50),
    cognome VARCHAR(50)
);

INSERT INTO persona VALUES ('saverio', 'napolitano');
INSERT INTO persona (cognome, nome) VALUES ('rossi', 'mario');
INSERT INTO persona (cognome) VALUES ('verde');
INSERT INTO persona VALUES (NULL, 'bianchi');

--SELECT * FROM nome_tabella mostra tutto il contenuto di nome_tabella
SELECT * FROM persona;

--Vincoli esprimibili in SQL

--PRIMARY KEY
CREATE TABLE persona2(
    CF VARCHAR(20) PRIMARY KEY,
    nome VARCHAR(50),
    cognome VARCHAR(50)
);

CREATE TABLE persona3(
    CF VARCHAR(20),
    nome VARCHAR(50),
    cognome VARCHAR(50),
    PRIMARY KEY(nome, cognome)
);

--FOREIGN KEY
CREATE TABLE comune(
    comune VARCHAR(50) PRIMARY KEY,
    provincia VARCHAR(50)
);

CREATE TABLE persona4(
    CF VARCHAR(20) PRIMARY KEY,
    nome VARCHAR(50),
    cognome VARCHAR(50),
    comune_di_residenza VARCHAR(50) REFERENCES comune(comune)
);

--FOREIGN KEY (come vincolo di tabella)
CREATE TABLE comune2(
    comune VARCHAR(50) PRIMARY KEY,
    provincia VARCHAR(50)
);

CREATE TABLE persona5(
    CF VARCHAR(20) PRIMARY KEY,
    nome VARCHAR(50),
    cognome VARCHAR(50),
    comune_di_residenza VARCHAR(50) 
    FOREIGN KEY(comune_di_residenza) REFERENCES comune(comune)
);

--NOT NULL
