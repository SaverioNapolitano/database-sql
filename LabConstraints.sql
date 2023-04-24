CREATE TABLE persona(
CF varchar(20) PRIMARY KEY,
nome varchar(50),
cognome varchar(50)
  );

-- selezionare ed eseguire le seguenti due insert (violazione perché hanno stessa PK)
  insert into persona values('a','b','c');
  insert into persona values('a','b1','c');

-- chiave primaria la coppia di attributi (nome,cognome)
DROP TABLE persona
CREATE TABLE persona(
	CF varchar(20),
	nome varchar(50),
	cognome varchar(50),
PRIMARY KEY(nome, cognome)
);

--stavolta posso inserire entrambi perché hanno PK diversa
  insert into persona values('a','b','c');
  insert into persona values('a','b1','c');

-- verifichiamo che entrambi i record sono stati inseriti
select * from persona;

-----------------------------
-- Slide Foreign Key
-- Tabella Comune con chiave primaria 'comune' : tabella riferita
CREATE TABLE Comune(
	comune VARCHAR(50) PRIMARY KEY,
	provincia VARCHAR(50)
);


-- Tabella Persona con chiave esterna 'comune_di_residenza' : tabella di riferimento o tabella dipendente
DROP TABLE Persona
CREATE TABLE Persona(
	CF varchar(20) PRIMARY KEY,
	nome varchar(50),
	cognome varchar(50),
	comune_di_residenza varchar(50) REFERENCES comune(comune)
);




-- in modo equivalente, come vincolo di tabella

DROP TABLE Persona
CREATE TABLE Persona(
	CF varchar(20) PRIMARY KEY,
	nome varchar(50),
	cognome varchar(50),
	comune_di_residenza varchar(50) ,
FOREIGN KEY(comune_di_residenza) REFERENCES comune
);

-- proviamo alcuni inserimenti
-- si deve inserire prima nella tabella riferita
insert into comune values('Sasso di Castalda', 'PZ');

-- quindi nella tabella di riferimento 
insert into persona values('BNVDNC...', 'Domenico', 'Beneventano','Sasso di Castalda');


select * from persona;

-- questo inserimento fallisce perche viola l'integrità referenziale
insert into persona values('BNVDNC1', 'Domenico', 'Beneventano','Sasso Castalda');

-- il valore di una chiave esterna può essere NULL
insert into persona values('BNVDNC1', 'Domenico', 'Beneventano',NULL);

select * from persona;


-- Slide: NOT NULL
-- NOT NULL come vincolo di colonna
DROP TABLE persona
CREATE TABLE persona(
	CF varchar(20) PRIMARY KEY,
	nome varchar(50) NOT NULL,
	cognome varchar(50) NOT NULL
);


-- NOT NULL come vincolo di tabella
DROP TABLE persona
CREATE TABLE persona(
	CF varchar(20) PRIMARY KEY,
	nome varchar(50),
	cognome varchar(50),
CHECK (nome IS NOT NULL),
CHECK (cognome IS NOT NULL)
);

-- in modo equivalente
DROP TABLE persona
CREATE TABLE persona(
	CF varchar(20) PRIMARY KEY,
	nome varchar(50),
	cognome varchar(50),
CHECK (nome IS NOT NULL and cognome IS NOT NULL)
);




-- Slide : UNIQUE
DROP TABLE Persona
CREATE TABLE Persona(
	CF varchar(20) PRIMARY KEY,
	nome varchar(50),
	cognome varchar(50),
UNIQUE(cognome, nome) --- è equivalente scrivere UNIQUE( nome, cognome)
);

--Errore perché provo a inserire duplicati quando ho detto che era unique
insert into persona values('BNVDNC...', 'Domenico', 'Beneventano');
insert into persona values('BNVDNC1', 'Domenico', 'Beneventano');


-- Slide : CHECK
DROP TABLE persona
CREATE TABLE persona(
	CF varchar(20) PRIMARY KEY,
	nome varchar(50),
	cognome varchar(50),
	eta int check(eta >0 and eta < 120)
);

-- come vincolo di tabella
DROP TABLE persona
CREATE TABLE persona(
	CF varchar(20) PRIMARY KEY,
	nome varchar(50),
	cognome varchar(50),
	eta int,
check(eta >0 and eta < 120)
);

-- I vincoli si considerano in AND (quindi equivalente a quello sopra)
DROP TABLE persona
CREATE TABLE persona(
	CF varchar(20) PRIMARY KEY,
	nome varchar(50),
	cognome varchar(50),
	eta int,
check(eta >0),
check(eta < 120)
);

insert into persona values('BNVDNC1', 'Domenico', 'Beneventano', 158);



-- Slide: Nome dei vincoli
CREATE TABLE T_persona(
	CF varchar(20) PRIMARY KEY,
	nome varchar(50),
	cognome varchar(50));

CREATE TABLE T_Tasse(
	CFcontribuente varchar(20)	REFERENCES T_persona,
	anno int,
	importo int,
PRIMARY KEY(CFcontribuente,anno) )

-- Assegnando esplicitamente un nome ad un vincolo:
-- tramite CONSTRAINT <nomeVincolo>, sia per i vincoli di colonna che di tabella

DROP TABLE T_persona
CREATE TABLE T_persona(
	CF varchar(20) 	CONSTRAINT PK_PERSONA_CF PRIMARY KEY,
	nome varchar(50),
	cognome varchar(50));


DROP TABLE T_Tasse
CREATE TABLE T_Tasse(
	CFcontribuente varchar(20)	
		CONSTRAINT FK_TASSE_CFcontribuente	REFERENCES T_persona,
	anno int,
	importo int,
CONSTRAINT PK_TASSE_CFcontribuente_anno	PRIMARY KEY(CFcontribuente,anno) )


--- Il nome del vincolo è utile per Interpretare il messaggio di errore in caso di violazione
insert into T_persona values ('UgoRossiXYZ', 'Ugo', 'Rossi')
insert into T_Tasse values ('UgoRossiXYZ', 2021, 100)
insert into T_Tasse values ('UgoRossiXYZ', 2021, 50)



--- Il nome del vincolo è utile quando si vuole  eliminare il vincolo
ALTER TABLE T_Tasse
	DROP CONSTRAINT PK_TASSE_CFcontribuente_anno;

-- ora la terza riga può essere inserita
insert into T_Tasse values ('UgoRossiXYZ', 2021, 50)


--- Per rimettere il vincolo occorre aggiungerlo
ALTER TABLE T_Tasse
	ADD CONSTRAINT PK_TASSE_CFcontribuente_anno	PRIMARY KEY(CFcontribuente,anno) 


-- IMPORTANTE : quando un vincolo viene aggiunto
--				esso viene controllato sulle istanze già presenti 
--				IN CASO DI VIOLAZIONE IL VINCOLO NON VIENE AGGIUNTO



-- Slide : Alternative Key
-- Una chiave alternativa si definisce utilizzando il vincolo UNIQUE & NOT NULL
--INIZIO UNCHECKED
DROP TABLE Persona
CREATE TABLE Persona(
	CF varchar(20) constraint ChiavePrimariaPersona PRIMARY KEY,
	nome varchar(50) NOT NULL,
	cognome varchar(50) NOT NULL,
CONSTRAINT ChiaveAlternativaPersona UNIQUE(nome, cognome) );


-- È importante notare la differenza rispetto a due chiavi alternative separate:
DROP TABLE Persona
CREATE TABLE Persona(
	CF varchar(20) constraint ChiavePrimariaPersona PRIMARY KEY,
	nome varchar(50), cognome varchar(50),
CONSTRAINT ChiaveAlterantivaPersona_1 UNIQUE(nome),
CONSTRAINT ChiaveAlterantivaPersona_2 UNIQUE(cognome));


-- È possibile usare anche le chiavi alternative come foreign key

CREATE TABLE RubricaTelefonica(
	nome varchar(50),
	cognome varchar(50),
	NumeroTelefono varchar(12),
FOREIGN KEY(nome,cognome) 
REFERENCES	Persona(nome, cognome) );

-- Ricordarsi che l'ordine degli attributi della foreign key
-- deve essere lo stesso di quello usato
-- per definire la chiave
--FINE UNCHECKED

CREATE TABLE Tasse(
	CFcontribuente varchar(20) REFERENCES persona,
	anno int,
	importo int)


-- ESERCIZIO

--	Suggerimento: Si definisce e si prova il primo caso (1) Nessuna chiave)

DROP TABLE RubricaTelefonica
CREATE TABLE RubricaTelefonica(
	nome varchar(50), cognome varchar(50),
	NumeroTelefono varchar(12) )

insert into RubricaTelefonica values('Ugo', 'Rossi', '100')
insert into RubricaTelefonica values('Ugo', 'Rossi', '200')
insert into RubricaTelefonica values('Ugo', 'Verde', '100')

select * from RubricaTelefonica

--- inserire ancora
insert into RubricaTelefonica values('Ugo', 'Rossi', '100')

select * from RubricaTelefonica

-- che significa? quanti e quali telefoni ha Ugo Rossi?



-- Quindi si cancella la tabella e si prova un altro caso ....



-- Slide : Considerazione sui valori NULL

create table TestNull(a integer, b integer)

insert into TestNull values(2,2)
insert into TestNull values(5,NULL)
insert into TestNull values(NULL,NULL)

--- Se cerco i record con a=b 

select * from TestNull where a=b 

--   ottengo solo il primo record ma non il terzo in quanto
--   Un valore NULL è considerato differente da ogni altro valore, anche da se stesso!!


-- Slide : Chiavi alternative e valori nulli

-- Tabella Docente con chiave primaria Codice e chiave alternativa CF
create table Docente(Codice integer Primary Key, CF varchar(16) NOT NULL UNIQUE)
  insert into Docente values(2,'ABCDNC')
  insert into Docente values(5,NULL)




-- Tabella Studente con chiave esterna  CF_Docente_Tesi
-- che è riferita alla chiave alternativa  CF della tabella Docente
create table Studente(Matricola integer Primary Key, 
                      CF_Docente_Tesi varchar(16) REFERENCES Docente(CF))

insert into Studente values(22,'ABCDNC')
insert into Studente values(55,NULL)


-- Le chiavi esterne vengono utilizzate nelle operazioni di join
select * from Docente join Studente on (Docente.CF=Studente.CF_Docente_Tesi)

-- si noti che manca il valore NULL

-- SLIDE : Chiavi e superchiavi 

CREATE TABLE persona1(
  CF varchar(20) NOT NULL,
  nome varchar(50) NOT NULL,
  cognome varchar(50) NOT NULL,
constraint ChiaveAlterantivaPersona1 UNIQUE(nome, cognome),
constraint ChiavePrimariaPersona1 Primary Key(nome, cognome, CF) );


--- ESEMPIO : Consideriamo le tabelle Persona, Docente, Studente, StudenteDocente, ...
-- per mostrare che una chiave (sia primaria che alternativa) può essere
--  1) Un sovrinsieme di una chiave esterna, cioè contenere una chiave esterna (caso molto frequente)
--  2) Anche una chiave esterna (caso abbastanza  frequente)
--  3) Un sottinsieme  di una chiave esterna (caso molto raro ...)

-- Tabella Persona con chiave primaria CF (ma il discorso è valido anche per chiavi alternative
--INIZIO UNCHECKED
DROP TABLE Persona
CREATE TABLE Persona(
  CF varchar(20) PRIMARY KEY,
  nome varchar(50) NOT NULL,
  cognome varchar(50) NOT NULL)
--FINE UNCHECKED
-- Iniziamo con il caso 2
-- Tabella Studente con CF che è sia chiave primaria che chiave esterna  riferita a Persona

DROP TABLE Studente
CREATE TABLE Studente(
  CF varchar(20) PRIMARY KEY REFERENCES Persona,
  CorsoDiLaurea varchar(50) NOT NULL,
)

-- si deve inserire prima la persona 
insert into Persona values ('UgoRossiXYZ', 'Ugo', 'Rossi')
insert into Persona values ('LeaRossiXYZ', 'Lea', 'Rossi')
-- e poi lo studente
insert into Studente values ('UgoRossiXYZ', 'IngInformatica')
insert into Studente values ('LeaRossiXYZ', 'IngElettronica')

-- Tabella Docente con CF che è sia chiave primaria che chiave esterna  riferita a Persona

DROP TABLE Docente
CREATE TABLE Docente(
  CF varchar(20) PRIMARY KEY REFERENCES Persona,
  Dipartimento varchar(50) NOT NULL,
)


-- si deve inserire prima la persona 
insert into Persona values ('AdaVerdiXYZ', 'Ada', 'Verdi')
insert into Persona values ('LucaVerdiXWZ', 'Luca', 'Verdi')
-- e poi il docente
insert into Docente values ('AdaVerdiXYZ', 'DIEF')
insert into Docente values ('LucaVerdiXWZ', 'DISMI')

-- Consideriamo  il caso 1
-- Tabella StudenteDocente con.... 
DROP TABLE StudenteDocente
CREATE TABLE StudenteDocente(
  CFStudente varchar(20)  REFERENCES Studente,
  CFDocente varchar(20)  REFERENCES Docente,
  AnnoDiCorso int,
  PRIMARY KEY(CFStudente,CFDocente) --- Cosa cambia se aggiungo AnnoDiCorso??
)

insert into StudenteDocente values ('UgoRossiXYZ', 'AdaVerdiXYZ', 2)
insert into StudenteDocente values ('UgoRossiXYZ', 'LucaVerdiXWZ', 3)
insert into StudenteDocente values ('LeaRossiXYZ', 'AdaVerdiXYZ', 1)
insert into StudenteDocente values ('LeaRossiXYZ', 'LucaVerdiXWZ',2)

-- Consideriamo infine  il caso 3
--  3) Chiave Primaria come sottinsieme  di una chiave esterna (caso molto raro ...)

--- Creare una tabella che contenga il DocentePreferito da uno studente
--- Uno studente può avere un solo Docente Preferito tra quelli indicati in StudenteDocente


-- Tabella con Chiave esterna riferita a sè stessa

DROP TABLE Impiegato 
CREATE TABLE Impiegato(
  CF varchar(20) PRIMARY KEY,
  nome varchar(50) NOT NULL,
  cognome varchar(50) NOT NULL,
  CFcapo varchar(20) REFERENCES Impiegato )


insert into Impiegato values ('UgoRossiXYZ', 'Ugo', 'Rossi', NULL)
insert into Impiegato values ('LeaRossiXYZ', 'Lea', 'Rossi','UgoRossiXYZ')
insert into Impiegato values ('AdaVerdiXYZ', 'Ada', 'Verdi','UgoRossiXYZ')
insert into Impiegato values ('LucaVerdiXWZ', 'Luca', 'Verdi','AdaVerdiXYZ')


-- è importante l'ordine di inserimento
delete from Impiegato
insert into Impiegato values ('LeaRossiXYZ', 'Lea', 'Rossi','UgoRossiXYZ')
insert into Impiegato values ('UgoRossiXYZ', 'Ugo', 'Rossi', NULL)


-- UNA SOLA OPERAZIONE (TRANSAZIONE) 

delete from Impiegato
insert into Impiegato values	('LeaRossiXYZ', 'Lea', 'Rossi','UgoRossiXYZ')
								,('UgoRossiXYZ', 'Ugo', 'Rossi', NULL)








DROP TABLE ARCO
create table ARCO(	PuntoDiPartenza varchar(20) primary key,
					PuntoDiArrivo varchar(20) UNIQUE references ARCO,
					Distanza int)

-- TRE OPERAZIONI (TRANSAZIONI) SEPARATE
insert into Arco values('FinePercorso', NULL, NULL) --  
insert into Arco values('PuntoIntermedio', 'FinePercorso', 30)
insert into Arco values('PuntoIniziale', 'PuntoIntermedio', 10)


-- l'ordine è importante: il punto di arrivo deve esistere!
insert into Arco values('PuntoIntermedio', 'FinePercorso', 30)
insert into Arco values('FinePercorso', NULL, NULL) --  
insert into Arco values('PuntoIniziale', 'PuntoIntermedio', 10)


-- UNA SOLA OPERAZIONE (TRANSAZIONE) 
insert into Arco values('PuntoIntermedio', 'FinePercorso', 30)
                    ,('FinePercorso', NULL, NULL) --  
                    ,('PuntoIniziale', 'PuntoIntermedio', 10)


insert into Arco values('C_PuntoPartenza', 'B_PuntoIntermedio', 30)
						,('A_PuntoArrivo', NULL, NULL)
						,('B_PuntoIntermedio', 'A_PuntoArrivo', 10)


-- UNA SOLA OPERAZIONE (TRANSAZIONE) 
insert into Arco values('C_PuntoPartenza', 'B_PuntoIntermedio', 30)
						,('A_PuntoArrivo', 'C_PuntoPartenza', 50)
						,('B_PuntoIntermedio', 'A_PuntoArrivo', 10)





