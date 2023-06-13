--1. Implementare il vincolo che un cantante non possa essere minorenne.



--2. In tabella ISCRITTO inserire il vincolo che un cantante non possa iscriversi due volte alla stessa competizione.

ALTER TABLE ISCRITTO 
ADD CONSTRAINT UNIQUE_ISCRIZIONE UNIQUE(NOMECANTANTE, ANNOEDIZIONE, NUMCOMP)

--3. Inserire nel database i dati riguardanti la seguente competizione 
--Nel 2017 si è tenuta la competizione ‘eurovision’ a cui hanno partecipato i cantanti: Robert Plant, Freddie Mercury, Paul Rodgers, Chef Ragoo, Calcutta (Rock, nato il 06-04-1989)
--La competizione è stata vinta da Plant, seguito da Calcutta e Mercury, mentre gli altri partecipanti non si sono presentati.


--4. Selezionare i nomi delle competizioni per le quali in ogni edizione c'è stato almeno un ritirato. 

SELECT NUMCOMP
FROM COMPETIZIONE C 
WHERE NOT EXISTS(
    SELECT *
    FROM COMPETIZIONE C1 
    WHERE C.NUMCOMP = C1.NUMCOMP
    AND NOT EXISTS(
        SELECT *
        FROM ISCRITTO I 
        WHERE I.POSIZIONE IS NULL 
        AND I.ANNOEDIZIONE = C1.ANNOEDIZIONE
        AND I.NUMCOMP = C.NUMCOMP
    )
)


--5. Selezionare il nome dei cantanti che hanno vinto sia a Sanremo che Festivalbar.

SELECT I.NOMECANTANTE
FROM ISCRITTO I
        JOIN ISCRITTO I1 ON (I.NOMECANTANTE = I1.NOMECANTANTE)
WHERE I.POSIZIONE = 1 
AND I1.POSIZIONE = 1
AND I.NUMCOMP = 'FESTIVALBAR'
AND I1.NUMCOMP = 'SANREMO'
GO 

--6. Definire una vista, CARRIERA, che riporti per ogni cantante il numero di volte in cui si è ritirato e in cui è salito sul podio (ovvero si è classificato nelle prime tre posizioni). 

CREATE VIEW PODI AS 
SELECT I.NOMECANTANTE, COUNT(*) AS NPODI
FROM ISCRITTO I 
WHERE I.POSIZIONE <= 3
GROUP BY I.NOMECANTANTE
GO 

CREATE VIEW RITIRI AS 
SELECT I.NOMECANTANTE, COUNT(*) AS NRITIRI
FROM ISCRITTO I 
WHERE I.POSIZIONE IS NULL
GROUP BY I.NOMECANTANTE
GO 

CREATE VIEW CARRIERA AS 
SELECT C.*, P.NPODI, R.NRITIRI
FROM CANTANTE C 
        LEFT JOIN PODI P ON (C.NOMECANTANTE = P.NOMECANTANTE)
        LEFT JOIN RITIRI R ON (C.NOMECANTANTE = R.NOMECANTANTE)
GO 

--7. Modificare la tabella ISCRITTO in modo che a seguito dell’eliminazione di un cantante, venga eliminata anche la sua iscrizione alle competizioni. 

