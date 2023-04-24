--Esercizio sui vincoli
--Considerare la tabella
CREATE TABLE RubricaTelefonica(
    nome VARCHAR(50),
    cognome VARCHAR(50),
    NumeroTelefono VARCHAR(12)
);

--Definire i vincoli di chiave e discutere il significato dei seguenti 5 casi, anche tramite inserimento di valori nelle tabelle

--1) Nessuna chiave
--La tabella creata precedentemente non ha nessuna chiave

--2) Chiave primaria (nome, cognome, NumeroTelefono)
--Devo assicurarmi che gli attributi della chiave primaria siano not null, quindi modifico la tabella
DROP TABLE RubricaTelefonica;
CREATE TABLE RubricaTelefonica(
    nome VARCHAR(50) NOT NULL,
    cognome VARCHAR(50) NOT NULL,
    NumeroTelefono VARCHAR(12) NOT NULL
    --PRIMARY KEY(nome, cognome, NumeroTelefono) alternativa al metodo sotto (in questo caso il nome del vincolo sarebbe quello di default)
    --se faccio così non serve specificare il not null
    --Oppure posso inglobare direttamente nella tabella il vincolo senza usare ALTER TABLE
    --CONSTRAINT PK_nome_cognome_NumeroTelefono PRIMARY KEY(nome, cognome, NumeroTelefono);
);
 --A questo punto posso imporre il vincolo che (nome, cognome, NumeroTelefono) sia chiave primaria
 ALTER TABLE RubricaTelefonica
    ADD CONSTRAINT PK_nome_cognome_NumeroTelefono PRIMARY KEY(nome, cognome, NumeroTelefono);


--3) Chiave primaria (nome, cognome)
--Non ho vincoli su NumeroTelefono, mentre nome e cognome devono essere not null
DROP TABLE RubricaTelefonica;
CREATE TABLE RubricaTelefonica(
    nome VARCHAR(50) NOT NULL,
    cognome VARCHAR(50) NOT NULL,
    NumeroTelefono VARCHAR(12)
    --PRIMARY KEY(nome, cognome) alternativa al metodo sotto (in questo caso il nome sarebbe quello di default)
    --se faccio così non serve specificare il not null
    --Oppure posso inglobare direttamente nella tabella il vincolo senza usare ALTER TABLE
    --CONSTRAINT PK_nome_cognome PRIMARY KEY(nome, cognome);
);
--A questo punto posso imporre il vincolo che (nome, cognome) sia chiave primaria
ALTER TABLE RubricaTelefonica
    ADD CONSTRAINT PK_nome_cognome PRIMARY KEY(nome, cognome);

--4) Chiave primaria (NumeroTelefono)
--Non ho vincoli su nome e cognome, mentre NumeroTelefono deve essere not null
DROP TABLE RubricaTelefonica;
CREATE TABLE RubricaTelefonica(
    nome VARCHAR(50),
    cognome VARCHAR(50),
    NumeroTelefono VARCHAR(12) NOT NULL
    --PRIMARY KEY(NumeroTelefono) alternativa al metodo sotto (in questo caso il nome sarebbe quello di default)
    --se faccio così non serve specificare il not null
    --Oppure posso inglobare direttamente nella tabella il vincolo senza usare ALTER TABLE
    --CONSTRAINT PK_NumeroTelefono PRIMARY KEY(NumeroTelefono);
);
--A questo punto posso imporre il vincolo che (NumeroTelefono) sia chiave primaria
ALTER TABLE RubricaTelefonica
    ADD CONSTRAINT PK_NumeroTelefono PRIMARY KEY(NumeroTelefono);

--5) Chiave primaria (nome, cognome) e chiave alternativa NumeroTelefono
--Nome e cognome devono essere not null, mentre NumeroTelefono deve essere not null e unique
DROP TABLE RubricaTelefonica;
CREATE TABLE RubricaTelefonica(
    nome VARCHAR(50) NOT NULL,
    cognome VARCHAR(50) NOT NULL,
    NumeroTelefono VARCHAR(12) NOT NULL
    --PRIMARY KEY(nome, cognome) alternativa al metodo sotto (in questo caso il nome sarebbe quello di default)
    --se faccio così non serve specificare il not null
    --Oppure posso inglobare direttamente nella tabella il vincolo senza usare ALTER TABLE
    --CONSTRAINT PK_nome_cognome PRIMARY KEY(nome, cognome);
    --UNIQUE(NumeroTelefono) alternativa al metodo sotto (in questo caso il nome sarebbe quello di default)
    --per l'alternative key il not null va specificato comunque
    --Oppure posso inglobare direttamente nella tabella il vincolo senza usare ALTER TABLE
    --CONSTRAINT AK_NumeroTelefono UNIQUE(NumeroTelefono);
);
--A questo punto posso imporre il vincolo che (nome, cognome) sia chiave primaria e (NumeroTelefono) sia chiave alternativa
ALTER TABLE RubricaTelefonica
    ADD CONSTRAINT PK_nome_cognome PRIMARY KEY(nome, cognome);
ALTER TABLE RubricaTelefonica
    ADD CONSTRAINT AK_NumeroTelefono UNIQUE(NumeroTelefono);