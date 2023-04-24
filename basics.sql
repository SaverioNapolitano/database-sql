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
CREATE TABLE persona6(
    CF VARCHAR(20) PRIMARY KEY,
    nome VARCHAR(50) NOT NULL, 
    cognome VARCHAR(50) NOT NULL
);
--Equivalenti
CREATE TABLE persona7(
    CF VARCHAR(20) PRIMARY KEY, 
    nome VARCHAR(50),
    cognome VARCHAR(50),
    CHECK (nome IS NOT NULL), 
    CHECK (cognome IS NOT NULL)
);

--UNIQUE
--In questo caso, l’istanza della relazione non può contenere due persone con lo stesso nome e cognom
CREATE TABLE persona8(
    CF VARCHAR(20) PRIMARY KEY, 
    nome VARCHAR(50),
    cognome VARCHAR(50), 
    UNIQUE(cognome, nome)
);

--Alternative Key: UNIQUE & NOT NULL
CREATE TABLE persona9(
    CF VARCHAR(20) PRIMARY KEY, 
    nome VARCHAR(50) NOT NULL, 
    cognome VARCHAR(50) NOT NULL, 
    UNIQUE(cognome, nome)
);

--CHECK
CREATE TABLE persona10(
CF VARCHAR(20) PRIMARY KEY, 
nome VARCHAR(50),
cognome VARCHAR(50),
eta INT CHECK(eta >0 AND eta < 120)
);
--Equivalenti
CREATE TABLE persona11(
CF VARCHAR(20) PRIMARY KEY, 
nome VARCHAR(50),
cognome VARCHAR(50),
eta INT,
CHECK(eta >0 AND eta < 120)
);

--ALTER TABLE: modifica la tabella
--Sintassi: ALTER TABLE nome_tabella
--                          ADD nome_colonna tipo_colonna [vincoli di colonna]
--[oppure]                  ADD CONSTRAINT nome_vincolo definizione_vincolo
--[oppure]                  ALTER COLUMN nome_colonna tipo_colonna
--[oppure]                  DROP COLUMN nome_colonna
--[oppure]                  DROP CONSTRAINT nome_vincolo
--...
--NB: [] = opzionale
ALTER TABLE persona10
    ADD luogo VARCHAR(50);

ALTER TABLE persona11
    ALTER COLUMN nome VARCHAR(200);

--Se non diamo esplicitamente un nome ad un vincolo, il sistema ne assegna uno in modo implicito
--Visibile in Keys (PK: punta verso sinistra, FK: punta verso destra, AK: punta verso l'alto)
CREATE TABLE T_persona(
    CF varchar(20) PRIMARY KEY, 
    nome varchar(50),
    cognome varchar(50)
);

CREATE TABLE T_Tasse( 
    CFcontribuente varchar(20) REFERENCES T_persona, 
    anno INT,
    importo INT,
    PRIMARY KEY(CFcontribuente,anno) 
);


--CONSTRAINT: assegno esplicitamente un nome ad un vincolo
CREATE TABLE T_persona1(
    CF varchar(20) CONSTRAINT PK_PERSONA_CF PRIMARY KEY, 
    nome varchar(50),
    cognome varchar(50)
);

CREATE TABLE T_Tasse1( 
    CFcontribuente varchar(20) CONSTRAINT FK_TASSE_CFcontribuente REFERENCES T_persona, 
    anno INT,
    importo INT,
    CONSTRAINT PK_TASSE_CFcontribuente_anno PRIMARY KEY(CFcontribuente,anno) 
);

--Nome vincolo utile per
--Interpretare il messaggio di errore in caso di violazione
INSERT INTO T_persona1 VALUES ('UgoRossiXYZ', 'Ugo', 'Rossi');
INSERT INTO T_Tasse1 VALUES ('UgoRossiXYZ', 2021, 100);
INSERT INTO T_Tasse1 VALUES ('UgoRossiXYZ', 2021, 50);
--Eliminare il vincolo
ALTER TABLE T_Tasse1
    DROP CONSTRAINT PK_TASSE_CFcontribuente_anno;

--CONSTRAINT applicato ad Alternative Key
CREATE TABLE Persona12(
    CF VARCHAR(20) CONSTRAINT ChiavePrimariaPersona12 PRIMARY KEY, 
    nome VARCHAR(50) NOT NULL,
    cognome VARCHAR(50) NOT NULL,
    CONSTRAINT ChiaveAlterativaPersona12 UNIQUE(nome, cognome) 
);
--Diverso rispetto a due chiave alternative separate
CREATE TABLE Persona13(
    CF VARCHAR(20) CONSTRAINT ChiavePrimariaPersona PRIMARY KEY,
    nome VARCHAR(50) NOT NULL, 
    cognome VARCHAR(50) NOT NULL, 
    CONSTRAINT ChiaveAlterativaPersona_1 UNIQUE(nome), 
    CONSTRAINT ChiaveAlteranivaPersona_2 UNIQUE(cognome)
);

--Posso dare nomi a più vincoli
CREATE TABLE Persona14(
    CF VARCHAR(20) CONSTRAINT ChiavePrimariaPersona PRIMARY KEY, 
    nome VARCHAR(50),
    cognome VARCHAR(50),
    CONSTRAINT AKPersonaUnique UNIQUE(nome, cognome), 
    CONSTRAINT AKPersonaNotNull CHECK(nome IS NOT NULL AND cognome IS NOT NULL)
);

--È possibile usare anche le chiavi alternative come foreign key
CREATE TABLE Tasse(
    CFcontribuente VARCHAR(20) REFERENCES Persona14, --attributo CF sottinteso, si può omettere in quanto c'è una sola PK
    anno INT,
    importo INT
);

CREATE TABLE RubricaTelefonica(
    nome VARCHAR(50),
    cognome VARCHAR(50),
    NumeroTelefono VARCHAR(12),
    FOREIGN KEY(nome, cognome) REFERENCES Persona14(nome, cognome) --È necessario indicare gli attributi della chiave alternativa, nello stesso ordine
);

DROP TABLE RubricaTelefonica;
