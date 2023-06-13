--1. Implementare il vincolo che un Autore non possa avere afferenza pari a null. 

ALTER TABLE AUTORE 
ADD CONSTRAINT CHECK_AFFERENZA CHECK (AFFERENZA IS NOT NULL)

--2. Inserire in tabella Autore gli attributi ARTscritti che rappresenta il numero di articoli scritti e ARTpub che rappresenta il numero di articoli pubblicati. 
--Aggiornare tali attributi per ciascun autore con i dati correnti del DB. 

ALTER TABLE AUTORE 
ADD ARTSCRITTI INT

ALTER TABLE AUTORE 
ADD ARTPUB INT 

--MANCA Aggiornare tali attributi per ciascun autore con i dati correnti del DB. 

--3. Inserire un controllo sul valore del campo settore in tabella Articolo, tale valore dovrà essere un valore tra i seguenti: Big Data Integration, Query Optimization, Uncertain Reasoning, Web 4.0. 

ALTER TABLE ARTICOLO 
ADD CONSTRAINT CHECK_SETTORE CHECK (SETTORE IN ('Big Data Integration', 'Query Optimization', 'Uncertain Reasoning', 'Web 4.0'))

--4. Selezionare i dati degli autori che non hanno mai scritto un articolo del settore Uncertain Reasoning. 

SELECT *
FROM AUTORE A 
WHERE idautore NOT IN (
    SELECT idautore
    FROM SCRIVE S 
            JOIN Articolo AR ON (S.idarticolo = AR.idarticolo)
    WHERE AR.settore = 'Uncertain Reasoning'
)
GO 

--5. Creare una vista Anno2017, che per l'anno 2017 (data inizio della conferenza) visualizzi il titolo della conferenza, il numero totale di articoli ricevuti, il numero totale di articoli pubblicati alla conferenza. 


CREATE VIEW ANNO2017 AS 
SELECT C.titolo, COUNT(AR.idarticolo) AS ARTICOLI_RICEVUTI, COUNT(AP.idarticolo) AS ARTICOLI_PUBBLICATI
FROM Conferenza C 
        JOIN Articolo AR ON (C.idconferenza = AR.idconferenza)
        LEFT JOIN Articolopubblicato AP ON (AR.idarticolo = AP.idarticolo)
WHERE YEAR(C.datainizio) = 2017
GROUP BY C.idconferenza, C.titolo 
GO 

--6. Creare una tabella STAT che riporti i seguenti attributi: 
--•	Anno
--•	NCN: Numero di conferenze nazionali
--•	NCI: Numero di conferenze internazionali
--•	NAI: Numero totale articoli inviati
--•	NAA: Numero totale autori di articoli inviati

--In tale tabella ci sarà una sola istanza per anno. Gli attributi non posso essere null, ma avranno valore 0 di default.


CREATE TABLE STAT(
    ANNO INT PRIMARY KEY, 
    NCN INT DEFAULT 0,
    NCI INT DEFAULT 0,
    NAI INT DEFAULT 0,
    NAA INT DEFAULT 0
)

--7. Popolare la tabella STAT secondo le seguenti modalità:
--Per ciascun anno si vuole riportare il numero di conferenze che sono state organizzate in quell’anno (data inizio della conferenza), 
--tale valore deve essere suddiviso tra conferenze nazionali (NCN), cioè organizzate in Italia e internazionali (NCI), 
--cioè organizzate in un altro stato. Inoltre si vuole riportare il numero totale di articoli che sono stati inviati alle conferenze di quell’anno (NAI)
--e il numero totale di autori che hanno scritto tali articoli (NAA). 
