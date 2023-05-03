--Script per la creazione del database del libro Basi di Dati pag.141

-- Questo script crea anche il database BDATI, quindi è sufficiente eseguirlo senza creare un database 

SET NOCOUNT ON
SET DATEFORMAT mdy
go
use master
go
Create database BDATI
go
use BDATI
go
create table S(
Matr char(2) PRIMARY KEY,
SNome varchar(20) not null,
Citta char(2) null,
ACorso int not null)
go
create table D(
CD char(2) PRIMARY KEY,
CNome varchar(20) not null,
Citta char(2) null)
go
create table C(
CC char(2) PRIMARY KEY,
CNome varchar(20) not null,
CD char(2) not null references D)
go
create table E(
Matr char(2) references S,
CC char(2) references C,
Data date not null,
Voto int not null check ((voto>=18 and voto <=30) or (voto=33)),
PRIMARY KEY (Matr,CC) )
go


--inserimento degli studenti
Insert into S (Matr,SNome,Citta,ACorso)
values ('M1','Lucia Quaranta','SA',1)
Insert into S (Matr,SNome,Citta,ACorso)
values ('M2','Giacomo Tedesco','PA',2)
Insert into S (Matr,SNome,Citta,ACorso)
values ('M3','Carla Longo','MO',1)
Insert into S (Matr,SNome,Citta,ACorso)
values ('M4','Ugo Rossi','MO',1)
Insert into S (Matr,SNome,Citta,ACorso)
values ('M5','Valeria Neri','MO',2)
Insert into S (Matr,SNome,Citta,ACorso)
values ('M6','Giuseppe Verdi','BO',1)
Insert into S (Matr,SNome,Citta,ACorso)
values ('M7','Maria Rossi',null,1)

--inserimento dei docenti
insert into D (CD,CNome,Citta)
values ('D1','Paolo Rossi','MO')
insert into D (CD,CNome,Citta)
values ('D2','Maria Pastore','BO')
insert into D (CD,CNome,Citta)
values ('D3','Paola Caboni','FI')


--inserimento dei corsi
Insert into C(CC,CNome,CD)
values ('C1','Fisica 1','D1')
Insert into C(CC,CNome,CD)
values ('C2','Analisi Matematica 1','D2')
Insert into C(CC,CNome,CD)
values ('C3','Fisica 2','D1')
Insert into C(CC,CNome,CD)
values ('C4','Analisi Matematica 2','D3')


--inserimento degli esami
Insert into E (Matr,CC,Data,Voto)
values ('M1','C1','06-29-1995',24)
Insert into E (Matr,CC,Data,Voto)
values ('M1','C2','08-09-1996',33)
Insert into E (Matr,CC,Data,Voto)
values ('M1','C3','03-12-1996',30)
Insert into E (Matr,CC,Data,Voto)
values ('M2','C1','06-29-1995',28)
Insert into E (Matr,CC,Data,Voto)
values ('M2','C2','07-07-1996',24)
Insert into E (Matr,CC,Data,Voto)
values ('M3','C2','07-07-1996',27)
Insert into E (Matr,CC,Data,Voto)
values ('M3','C3','11-11-1996',25)
Insert into E (Matr,CC,Data,Voto)
values ('M4','C3','11-11-1996',33)
Insert into E (Matr,CC,Data,Voto)
values ('M6','C2','01-02-1996',28)
Insert into E (Matr,CC,Data,Voto)
values ('M7','C1','06-29-1995',24)
Insert into E (Matr,CC,Data,Voto)
values ('M7','C2','04-11-1996',26)
Insert into E (Matr,CC,Data,Voto)
values ('M7','C3','06-23-1996',27)


-------------------------
-- PRODOTTO CARTESIANO --
-------------------------

CREATE TABLE R
(Nome VARCHAR (15),
DataNascita DATE);

INSERT INTO R VALUES ('Anna','15/01/1975'), ('Luca', '22/01/1988');

CREATE TABLE S (
Nome VARCHAR (15),
Via VARCHAR (40));

INSERT INTO S VALUES ('Anna','via Emilia'), ('ABC', 'via Nonantolana');


--Prodotto Cartesiano
SELECT * FROM R, S

--JOIN (con WHERE)
SELECT * FROM R, S
WHERE R.Nome=S.Nome


--JOIN (con operatore)
SELECT * FROM R JOIN S ON R.Nome=S.Nome

--Aggiungo una tupla
INSERT INTO S VALUES ('Anna','P.za Garibaldi')


--JOIN
SELECT * FROM R, S
WHERE R.Nome=S.Nome


--Aggiungo un attributo Cod nelle due tabelle
ALTER TABLE R
ADD Cod INT

ALTER TABLE S
ADD Cod INT

UPDATE  R SET Cod=1  
WHERE Nome='Anna'
UPDATE  R SET Cod=2  
WHERE Nome='Luca'


UPDATE  S SET Cod=2  
WHERE Nome='Anna' AND Via='via Emilia'
UPDATE  S SET Cod=3  
WHERE Nome='ABC' 
UPDATE  S SET Cod=4  
WHERE Nome='Anna'AND Via='P.za Garibaldi'


--JOIN
SELECT * FROM R, S
WHERE R.Cod=S.Cod




---------------------------------------------------
--Esercizi - Esempi di prodotto cartesiano e JOIN
---------------------------------------------------
--Creare il db a partire dallo script

Use BDATI


/*1- Prodotto cartesiano tra i corsi e i docenti - restituisce tutte le possibili combinazioni*/

SELECT *
FROM C, D

/*2 - JOIN tra corsi e docenti in base alla condizione che il codice docente su corso sia lo stesso codice docente su docente - restituisce la combinazione corso con docente che lo ha tenuto*/

SELECT *
FROM C
        JOIN D ON (C.CD = D.CD) --CD FK IN C MA PK IN D -> DEVO QUALIFICARE

/*SOLUZIONE*/
/*1- Prodotto cartesiano tra i corsi e i docenti - restituisce tutte le possibili combinazioni*/
SELECT *
FROM c, d


/*2 - JOIN tra corsi e docenti in base alla condizione che il codice docente
 su corso sia lo stesso codice docente su docente 
 - restituisce la combinazione corso con docente che lo ha tenuto*/

SELECT * FROM C

SELECT * FROM D

SELECT *
FROM C JOIN D ON C.cd=D.cd


/*3 "Per ogni esame visualizzare Nome dello studente, Codice del corso dell'esame sostenuto, Voto dell'esame e Nome del corso
operazione ottenuta tramite un JOIN tra esame e studente sulla matricola(Matr), e un JOIN tra esame e corso sul codice corso (CC)"" */
--NB: IN QUESTO CASO DISTINCT IRRILEVANTE, NON CAMBIA NULLA
SELECT SNOME, E.CC, VOTO, CNOME --CC PRESENTE IN DUE TABELLE, SE NON QUALIFICO AMBIGUO -> AVENDO JOIN POSSO PRENDERLO INDIFFERENTEMENTE DA E O C
FROM E --ORDINE JOIN IRRILEVANTE, IMPORTANTE ELENCARE TUTTE LE TABELLE E CITARE I NOMI DELLE TABELLE GIÀ MESSE IN FROM
        JOIN S ON (E.MATR = S.MATR) --HO TANTE TUPLE QUANTE SONO QUELLE DI ESAME
        JOIN C ON (E.CC = C.CC) --OGNI VOLTA CHE FACCIO UN JOIN SE SEGUO LA FK IL NUMERO INIZIALE DI TUPLE NON CAMBIA (HO TANTE TUPLE QUANTE E)
--QUI INVECE IL DISTINCT HA SENSO
SELECT DISTINCT E.CC, VOTO
FROM E
        JOIN S ON (E.MATR = S.MATR)
        JOIN C ON (E.CC = C.CC)
--Per ogni esame visualizzare Nome dello studente, Codice del corso dell'esame sostenuto, 
--Voto dell'esame 
SELECT *
FROM E
SELECT *
FROM S

SELECT Snome, CC, Voto
FROM E JOIN S ON S.Matr=E.Matr

--Per ogni esame visualizzare Nome dello studente, Codice del corso dell'esame sostenuto, 
--Voto dell'esame e Nome del corso

SELECT *
FROM E JOIN S ON S.Matr=E.Matr

SELECT * FROM C

SELECT *
FROM E JOIN S ON S.Matr=E.Matr JOIN C ON E.CC=C.CC



SELECT S.SNome, E.CC, E.Voto, C.CNome
FROM E JOIN S ON S.Matr=E.Matr JOIN C ON E.CC=C.CC


/*SOLUZIONE*/
/*3 - Nome degli studenti, Codice dell'esame , Voto dell'esame e Nome del corso: operazione ottenuta tramite un JOIN tra esame e studente sulla matricola(Matr), e un JOIN tra esame e corso sul codice corso (CC)*/

SELECT S.SNome, E.CC, E.Voto, C.CNome
FROM S, E, C
WHERE S.Matr=E.Matr
AND E.CC=c.CC

--Il risultato pu' essere anche riscritto inserendo il JOIN nella FROM

SELECT S.SNome, E.Voto, C.CNome
FROM 	E 
		JOIN S ON (S.Matr=E.Matr)
		JOIN C ON (E.CC=c.CC)



/*4 - Selezionare, per ogni esame di un corso di 'Fisica' sostenuto da uno studente di 'MO', voto, Nome studente, Nome del corso e Nome del docente del corso*/

SELECT VOTO, SNOME, C.CNOME, D.CNOME AS NOMEDOCENTE
FROM E
        JOIN C ON (E.CC = C.CC)
        JOIN S ON (E.MATR = S.MATR) -- JOIN CON S PER PRENDERE NOME DELLO STUDENTE
        JOIN D ON (C.CD = D.CD) --JOIN CON D PER PRENDERE NOME DOCENTE
        -- WHERE CNOME = 'Fisica' NON POSSO FARLO PERCHÉ UGUAGLIANZA ESATTA
        WHERE C.CNOME LIKE '%Fisica%' --IN QUESTO MODO BECCO TUTTI CORSI CHE HANNO 'FISICA' IN UNA QUALSIASI POSIZIONE 
        AND S.CITTA = 'MO' 


--Selezionare, per ogni esame di un corso di 'Fisica' sostenuto da uno studente di 'MO', voto, 
--Nome studente, Nome del corso
SELECT S.SNome, E.Voto, C.CNome
FROM 	E 
		JOIN S ON (S.Matr=E.Matr)
		JOIN C ON (E.CC=c.CC)
WHERE S.Citta='MO'
AND   Cnome LIKE '%Fisica%'

--Selezionare, per ogni esame di un corso di 'Fisica' sostenuto da uno studente di 'MO', voto, 
--Nome studente, Nome del corso
--e Nome del docente del corso
SELECT S.SNome, E.Voto, C.CNome, D.CNome
FROM 	E 
		JOIN S ON (S.Matr=E.Matr)
		JOIN C ON (E.CC=c.CC)
		JOIN D ON (C.CD=D.CD)
WHERE S.Citta='MO'
AND C.Cnome LIKE '%Fisica%'



/*SOLUZIONE*/
/*4 - Selezionare, per ogni esame di un corso di 'Fisica' sostenuto da uno studente di 'MO', voto, Nome studente, Nome del corso e Nome del docente del corso*/

SELECT S.SNome, S.citta, E.Voto, C.CNome, D.CNome
FROM 	E 
		JOIN S ON (S.Matr=E.Matr)
		JOIN C ON (E.CC=c.CC)
		JOIN D ON (C.CD=D.CD)
WHERE C.Cnome LIKE 'Fisica%'
AND S.Citta='MO'



/*5 - Matricola, Nome e citta' degli studenti (S) che hanno sostenuto almeno un esame (E)*/

SELECT DISTINCT S.MATR, SNOME, CITTA
FROM S
        JOIN E ON (S.MATR = E.MATR)

/*5 - NEGATA :
MATRICOLA, NOME E CITTA DEGLI STUDENTI CHE NON HANNO SOSTENUTO ALCUN ESAME*/
--- NON SI PUÒ USARE IL JOIN
--PRENDO UN ESAME, LO ACCOPPIO CON TUTTI GLI STUDENTI CON UNA MATRICOLA DIVERSA E PORTO LA COPPIA IN USCITA
--O VICEVERSA PRENDO UNO STUDENTE E LO ACCOPPIO CON TUTTI GLI ESAMI FATTI DAGLI ALTRI
---INSENSATO (IN QUESTO CASO RESTITUISCE TUTTI GLI STUDENTI)
SELECT DISTINCT S.MATR, SNOME, CITTA
FROM S
        JOIN E ON (S.MATR <> E.MATR)   ----------------    NO


--- SI CONSIDERANDO TUTTI GLI STUDENTI: DA DOVE LI PRENDO ? DA S
SELECT S.MATR, SNOME, CITTA
FROM S
--- SI ESCLUDONO, SI SOTTRAGGONO CON NOT IN QUELLI CHE HANNO ALMENO UN ESAME (QUERY PRECEDENTE) O EQUIVALENTEMENTE NOT EXISTS
WHERE S.MATR NOT IN ( -- SUBQUERY PRECEDENTE (NON ESSENDO UN RISULTATO CHE DEVO PORTARE IN USCITA MA SOLO UNA CONDIZIONE DISTINCT NON SERVE)
                    -- IN GENERALE DISTINCT IRRILEVANTE NELLE SUBQUERY E NON VIENE MESSO
                        SELECT S.MATR --SE NELLA WHERE CONTROLLO SOLO LA MATRICOLA ANCHE QUI DEVO CONTROLLARE SOLO LA MATRICOLA
                        FROM S
                                JOIN E ON (S.MATR = E.MATR)
                        )

--ALTERNATIVA: NOT EXISTS -> AVENDO TABELLA INTERNA ED ESTERNA UGUALE USO ALIAS (NON POSSO USARE PIÙ S, NOME ORIGINALE NON RICONOSCIUTO)
SELECT SE.MATR, SNOME, CITTA
FROM S AS SE--T ABELLA S ESTERNA
--- SI ESCLUDONO, SI SOTTRAGGONO CON NOT EXISTS QUELLI CHE HANNO ALMENO UN ESAME (QUERY PRECEDENTE) O EQUIVALENTEMENTE NOT IN
WHERE NOT EXISTS ( -- SUBQUERY PRECEDENTE MA CORRELATA (DEVE RIFERIRSI ALLA TABELLA S ESTERNA)
                        SELECT SI.MATR --SE NELLA WHERE CONTROLLO SOLO LA MATRICOLA ANCHE QUI DEVO CONTROLLARE SOLO LA MATRICOLA
                        FROM S AS SI-- S INTERNA
                                JOIN E ON (SI.MATR = E.MATR)
                        WHERE SE.MATR = SI.MATR --IN QUESTO MODO HO CORRELATO LA SUBQUERY 
                        )

/*SOLUZIONE*/
/*5 - Matricola, Nome e citta' degli studenti che hanno sostenuto almeno un esame*/

SELECT DISTINCT S.Matr, Snome, Citta
FROM 	E 
		JOIN S ON (S.Matr=E.Matr)



/*6 - Matricola e Nome degli studenti che hanno sostenuto almeno un esame di un corso di Fisica*/


SELECT DISTINCT S.MATR, SNOME
FROM S
        JOIN E ON (S.MATR = E.MATR)
        JOIN C ON (E.CC = C.CC)
WHERE CNOME LIKE '%Fisica%'

/*6_NEG - MATRICOLA E NOME DEGLI STUDENTI CHE NON HANNO SOSTENUTO ALCUN ESAME DI UN CORSO DI FISICA*/
-- PRENDO TUTTI GLI STUDENTI
SELECT MATR, SNOME
FROM S
-- ED ESCLUDO QUELLI CHE HANNO FATTO ALMENO UN ESAME DI UN CORSO DI FISICA
-- SCRIVERE UNA SUBQUERY CHE RESTITUISCE TUTTE LE MATRICOLE (ATTRIBUTO MATR) CHE HANNO FATTO ALMENO UN ESAME DI UN CORSO DI FISICA: QUALI TABELLE?
WHERE MATR NOT IN ( 
                    SELECT MATR
                    FROM E
                            JOIN C ON (E.CC = C.CC)
                    WHERE CNOME LIKE '%Fisica%'
)

--RISCRIVERE CON NOT EXISTS








/*6 NEG BIS - 
TRA GLI STUDENTI CHE HANNO SOSTENUTO ALMENO UN ESAME, RIPORTARE
MATRICOLA E NOME DEGLI STUDENTI CHE NON HANNO SOSTENUTO ALCUN ESAME DI UN CORSO DI FISICA*/
-- PRENDO TUTTI GLI STUDENTI CHE HANNO FATTO ALMENO UN ESAME

SELECT S.MATR, SNOME
FROM S 
        JOIN E ON (S.MATR = E.MATR)
-- ED ESCLUDO QUELLI CHE HANNO FATTO ALMENO UN ESAME DI UN CORSO DI FISICA
-- SCRIVERE UNA SUBQUERY CHE RESTITUISCE TUTTE LE MATRICOLE (ATTRIBUTO MATR) CHE HANNO FATTO ALMENO UN ESAME DI UN CORSO DI FISICA: QUALI TABELLE?
WHERE S.MATR NOT IN ( --QUANDO SUBQUERY NON HA CORRELAZIONE CON L'ESTERNO SI PUÒ SELEZIONARE ED ESEGUIRE
                    SELECT MATR
                    FROM E
                            JOIN C ON (E.CC = C.CC)
                    WHERE CNOME LIKE '%Fisica%'
)

--FARE GLI ALTRI ESERCIZI (DAL 7 IN POI)

/*SOLUZIONE*/
/*6 - Matricola e Nome degli studenti che hanno sostenuto almeno un esame di un corso di Fisica*/

SELECT DISTINCT E.Matr, Snome
FROM 	E 
		JOIN S ON (S.Matr=E.Matr)
		JOIN C ON (E.CC=c.CC)
WHERE CNome LIKE'Fisica%'


/*7 - Matricola e Nome degli studenti che hanno sostenuto almeno un esame di un corso tenuto dal docente 'Paolo Rossi'*/
SELECT DISTINCT S.MATR, SNOME 
FROM S 
        JOIN E ON (S.MATR = E.MATR)
        JOIN C ON (E.CC = C.CC)
        JOIN D ON (C.CD = D.CD)
WHERE D.CNOME = 'Paolo Rossi'


/*SOLUZIONE*/
/*7 - Matricola e Nome degli studenti che hanno sostenuto almeno un esame di un corso tenuto dal docente 'Paolo Rossi'*/
SELECT DISTINCT E.Matr, Snome
FROM 	E 
		JOIN S ON (S.Matr=E.Matr)
		JOIN C ON (E.CC=c.CC)
		JOIN D ON (C.CD=D.CD)
WHERE D.CNome ='Paolo Rossi'


/*8 - Nome degli studenti che hanno ottenuto almeno un voto >=28*/
SELECT DISTINCT SNOME
FROM S 
        JOIN E ON (S.MATR = E.MATR)
WHERE VOTO >= 28




/*SOLUZIONE*/
/*8 - Nome degli studenti che hanno ottenuto almeno un voto >=28*/

SELECT DISTINCT Snome
FROM 	E 
		JOIN S ON (S.Matr=E.Matr)
WHERE voto>=28

--ALTERNATIVA
SELECT DISTINCT Snome
FROM 	E 
		JOIN S ON (S.Matr=E.Matr AND VOTO >= 28)
-- IN ON DEVO METTERE SOLO CONDIZIONI DI JOIN, NON CONDIZIONI LOCALI (ES. CONFRONTO ATTRIBUTO-COSTANTE)

--IMPORTANTE
--Non inserire nelle condizioni di JOIN predicati di filtro
--Una query di questo tipo e' concettualmente sbagliata perche' mescola nel predicato di JOIN condizioni di JOIN e condizioni di filtro


SELECT DISTINCT E.Matr, Cnome
FROM E JOIN C ON (	C.CC=E.CC 
					AND CNome LIKE'Fisica%')

--Anche se viene eseguita dal DBMS, ' pi' corretto inserire nel predicato di JOIN solo le condizioni necessarie al JOIN, le condizioni di filtro devono rimanere nella clausola WHERE*/
SELECT DISTINCT E.Matr, Cnome
FROM E JOIN C ON(C.CC=E.CC)
WHERE CNome LIKE'Fisica%'


------------------------------------------
-- Introduzione OUTER JOIN
------------------------------------------

--Selezionare gli studenti che hanno sostenuto 
--almeno un esame

SELECT s.*
FROM s JOIN e ON s.Matr=e.Matr

SELECT DISTINCT s.*
FROM s JOIN e ON s.Matr=e.Matr


--Selezionare gli studenti che hanno
--sostenuto almeno un esame oppure nessuno
 ???


 ---------------------------------------------
 -- OUTER JOIN
 ---------------------------------------------

 --Inner JOIN
 SELECT * 
 FROM R,S
 WHERE R.Nome=S.Nome

 -- Left Outer JOIN
 SELECT *  FROM R LEFT JOIN S ON R.Nome=S.Nome

 --Right Outer JOIN
 SELECT *  FROM R RIGHT JOIN S ON R.Nome=S.Nome

 --Full Outer JOIN
 SELECT *  FROM R FULL JOIN S ON R.Nome=S.Nome


 
USE BDATI 
/*1. 	Combinazioni di studenti e di docenti residenti nella stessa citta' inclusi gli studenti (docenti) che risiedono in una citta' che non ha corrispondenza nella relazione dei docenti (studenti)*/


--SUGGERIMENTO:
-- Seleziono gli studenti e le loro citta' di residenza


-- Seleziono i docenti e le loro citta' di residenza


-- Seleziono le combinazioni di studenti e di docenti residenti nella stessa citta'


-- Aggiungo le tuple dangling delle due tabelle



/*SOLUZIONE*/
/*1. 	Combinazioni di studenti e di docenti residenti nella stessa citta' inclusi gli studenti (docenti) che risiedono in una citta' che non ha corrispondenza nella relazione dei docenti (studenti)*/
-- Seleziono gli studenti e le loro citta' di residenza
SELECT S.SNome,S.citta  FROM S'
-- Seleziono i docenti e le loro citta' di residenza
SELECT D.CNome,D.citta    FROM D'
-- Seleziono le combinazioni di studenti e di docenti residenti nella stessa citta'
SELECT *  FROM S JOIN D ON S.Citta=D.Citta
-- Aggiungo le tuple dangling delle due tabelle
SELECT *  FROM S FULL JOIN D ON S.Citta=D.Citta


/*2. Matricole di studenti con i codici dei corsi dei relativi esami sostenuti, inclusi gli studenti che non hanno sostenuto alcun esame*/


--SUGGERIMENTO
--Estrarre gli studenti che hanno sostenuto esami 
--con i relativi esami 
--includere gli studenti che non hanno sostenuto esami (tuple dangling di studente)



/*SOLUZIONE*/
/*2. Matricole di studenti con i codici dei corsi dei relativi esami sostenuti, inclusi gli studenti che non hanno sostenuto alcun esame*/
--Per estrarre gli studenti che hanno sostenuto esami con i relativi esami inclusi gli studenti che non hanno sostenuto esami, effettuo la seguente query
SELECT *  
FROM S left JOIN E ON (E.Matr=S.Matr) 

--equivalente anche a
SELECT *
FROM E right JOIN S ON (E.Matr=S.Matr) 

-- Query finale
SELECT S.Matr, E.CC
FROM S left JOIN E ON (E.Matr=S.Matr) 

/*3. Matricole di studenti con i codici dei corsi dei relativi esami sostenuti, inclusi gli studenti che non hanno sostenuto alcun esame e i corsi per i quali non ci sono esami sostenuti*/




/*3. Matricole di studenti con i codici dei corsi dei relativi esami sostenuti, inclusi gli studenti che non hanno sostenuto alcun esame e i corsi per i quali non ci sono esami sostenuti*/
SELECT *
FROM E right JOIN C ON (C.CC=E.CC)


SELECT *  FROM (S left JOIN E ON (E.Matr=S.Matr)) 
			right JOIN C ON (C.CC=E.CC)


SELECT *  FROM (S left JOIN E ON (E.Matr=S.Matr)) 
			full JOIN C ON (C.CC=E.CC)

			
--USO DELL'ALIAS
/*4. Visualizza matricola e Nome di studente per tutti  gli studenti iscritti al secondo anno di corso*/
SELECT stud.Matr as matricola, SNome as nome_dello_studente
FROM S stud
WHERE stud.ACorso=2



/*5. Coppie di studenti che risiedono nella stessa citta'*/



/*SOLUZIONE*/
/*5. Coppie di studenti che risiedono nella stessa citta'*/

SELECT *
FROM S as S1 JOIN S as S2 ON (S1.Citta=S2.Citta)

--Nel risultato  ho anche le coppie M1-M1 (studente e se stesso) ed inoltre le coppie MX-MY appaiono anche permutate ovvero MY-MX, per evitare ci' impongo una condizione di filtro, scelto di riportare solo coppie dove Mx> My
SELECT S1.SNome as nome_s1, S1.Citta as citta_s1, S2.SNome as nome_s2, S2.Citta as citta_s2
FROM 	S as S1 
		JOIN S as S2 ON (S1.Citta=S2.Citta)
WHERE S1.Matr > S2.Matr


/* Matricola degli studenti che hanno sostenuto almeno uno degli esami (stesso corso CC) 
  sostenuti dallo studente di nome 'Carla Longo' 
  risultato: M1, M2, M4, M6 e M7 */
  
SELECT DISTINCT E2.MATR 
FROM	S 		
		JOIN  E AS E1 ON (S.MATR=E1.MATR)
        JOIN  E AS E2  ON (E1.CC=E2.CC)
WHERE SNome='Carla Longo' AND S.MATR<>E2.MATR


SELECT DISTINCT E2.MATR 
FROM	E AS E2 		
WHERE   E2.CC IN (	SELECT E1.CC
					FROM  E AS E1
			        JOIN  S ON (S.MATR=E1.MATR)
					WHERE SNome='Carla Longo' 
					AND   S.MATR<>E2.MATR )


SELECT DISTINCT E2.MATR 
FROM	E AS E2 		
WHERE   EXISTS (	SELECT E1.CC
					FROM  E AS E1
			        JOIN  S ON (S.MATR=E1.MATR)
					WHERE E1.CC=E2.CC
					AND   SNome='Carla Longo' 
					AND   S.MATR<>E2.MATR )




/* Matricola degli studenti che hanno sostenuto almeno uno degli appelli  
   (stesso corso CC e stessa Data)  sostenuti dallo studente 'Carla Longo' 
	risultato:  M2 e M4  */
 
  
SELECT DISTINCT E2.MATR 
FROM	S 		
		JOIN  E AS E1 ON (S.MATR=E1.MATR)
        JOIN  E AS E2  ON (E1.CC=E2.CC AND E1.DATA=E2.DATA)
WHERE SNome='Carla Longo' AND S.MATR<>E2.MATR
  

SELECT DISTINCT E2.MATR 
FROM	E AS E2 		
WHERE   E2.CC, E2.DATA IN (	SELECT E1.CC, E1.DATA
					FROM  E AS E1
			        JOIN  S ON (S.MATR=E1.MATR)
					WHERE SNome='Carla Longo' 
					AND   S.MATR<>E2.MATR )


SELECT DISTINCT E2.MATR 
FROM	E AS E2 		
WHERE   EXISTS (	SELECT E1.CC
					FROM  E AS E1
			        JOIN  S ON (S.MATR=E1.MATR)
					WHERE E1.CC=E2.CC
					AND   E1.DATA=E2.DATA	
					AND   SNome='Carla Longo' 
					AND   S.MATR<>E2.MATR )


/* Matricola degli studenti che non hanno sostenuto esami (stesso corso CC)  
   assieme allo studente  'Carla Longo' ; risultato: M1, M2 e M7 */
   
   
SELECT DISTINCT E2.MATR 
FROM	E AS E2 		
WHERE   E2.CC NOT IN (	SELECT E1.CC
					FROM  E AS E1
			        JOIN  S ON (S.MATR=E1.MATR)
					WHERE SNome='Carla Longo'  )

--- si noti che con la correlazione
AND   S.MATR<>E2.MATR
-- si otterrebbe in output anche la stessa matricola M3 di 'Carla Longo'


SELECT DISTINCT E2.MATR 
FROM	E AS E2 		
WHERE   NOT EXISTS (	SELECT E1.CC
					FROM  E AS E1
			        JOIN  S ON (S.MATR=E1.MATR)
					WHERE E1.CC=E2.CC
					AND   SNome='Carla Longo' )

--- come sopra con la correlazione
AND   S.MATR<>E2.MATR
-- si otterebbe in output anche la stessa matricola M3 di 'Carla Longo'



DROP TABLE E
DROP TABLE S
DROP TABLE C




CREATE TABLE S  (Matr VARCHAR(3), SNome VARCHAR(10))
CREATE TABLE C  (CC VARCHAR(3), CNome VARCHAR(10))
CREATE TABLE E  (Matr VARCHAR(3), CC VARCHAR(3), voto integer)

INSERT INTO S VALUES ('M1','Ada')
INSERT INTO S VALUES ('M2','Ugo')
INSERT INTO C VALUES ('C1','Bio')
INSERT INTO C VALUES ('C2','SQL')
INSERT INTO E VALUES ('M1','C1', 30)

SELECT * FROM E

SELECT *  , 1
FROM S LEFT JOIN E ON (E.Matr=S.Matr) 


SELECT *,1
FROM E RIGHT JOIN C ON 				(C.CC=E.CC)

SELECT *,1  FROM (S left JOIN E ON (E.Matr=S.Matr)) 
			full JOIN C ON (C.CC=E.CC)



Una tupla tR di r (tS di s) che non partecipa a tale corrispondenza, e che quindi non contribuisce al JOIN, `e detta dangling.
Piu` precisamente, una tupla tR di r `e detta dangling se non esiste t ∈ r1stalechet[X]=tR (stessacosapertS dis).





CREATE TABLE studente  (facolta VARCHAR(1), matricola integer, snome VARCHAR(10))
CREATE TABLE esame (facolta VARCHAR(1), matricola integer, CC VARCHAR(1))

INSERT INTO studente VALUES ('a',1,'Ada')
INSERT INTO studente VALUES ('a',2,'Luca')
INSERT INTO studente VALUES ('b',1,'Adam')
INSERT INTO studente VALUES ('b',2,'pio')

INSERT INTO esame VALUES('a',1, '1')
INSERT INTO esame VALUES('a',2, '1')
INSERT INTO esame VALUES('b',1, '1')

