/*Seconda prova parziale 03-06-2021*/

/*1. Selezionare i dati delle aziende che hanno emesso bandi a cui ha fatto domanda almeno una persona di Bologna 
oppure è risultata vincitrice una persona di Modena*/

SELECT A.*
FROM AZIENDA A 
        JOIN BANDO B ON (A.IDA = B.IDA)
        JOIN DOMANDA D ON (B.IDB = D.IDB)
        JOIN PERSONA P ON (D.CF = P.CF)
WHERE P.CITTA = 'BO'
UNION 
SELECT A.*
FROM AZIENDA A 
        JOIN BANDO B ON (A.IDA = B.IDA)
        JOIN PERSONA P ON (B.CF_VINCITORE = P.CF)
WHERE P.CITTA = 'MO'
GO

/*2. Selezionare il nome delle aziende per cui non c’è mai stato un bando con vincitore un bolognese.*/

/*VERSIONE 1: EXCEPT*/
SELECT NOME
FROM AZIENDA
EXCEPT 
SELECT NOME 
FROM AZIENDA A 
        JOIN BANDO B ON (A.IDA = B.IDA)
        JOIN PERSONA P ON (B.CF_VINCITORE = P.CF)
WHERE P.CITTA = 'BO'

/*VERSIONE 2: NOT IN*/
SELECT NOME 
FROM AZIENDA
WHERE IDA NOT IN (
    SELECT IDA
    FROM BANDO B
            JOIN PERSONA P ON (B.CF_VINCITORE = P.CF)
    WHERE P.CITTA = 'BO'
)

/*3. Selezionare i nominativi delle persone che hanno fatto domanda a tutti i bandi relativi all’azienda con nome “Banco Emiliano”.*/

SELECT NOMINATIVO
FROM PERSONA P 
WHERE NOT EXISTS (
    SELECT IDB
    FROM BANDO B 
            JOIN AZIENDA A ON (B.IDA = A.IDA)
    WHERE NOME = 'BANCO EMILIANO'
    AND NOT EXISTS (
        SELECT D.CF
        FROM DOMANDA D 
        WHERE D.CF = P.CF 
        AND D.IDB = B.IDB
    )
)

/*1. Selezionare il nome delle aziende italiane che hanno emesso almeno 5 bandi con un importo maggiore di 10000€. */

SELECT NOME
FROM AZIENDA A 
        JOIN BANDO B ON (A.IDA = B.IDA)
WHERE NAZIONE = 'ITALIA' 
AND IMPORTO > 10000
GROUP BY NOME 
HAVING COUNT(*) >= 5

/*2, Selezionare i bandi a cui hanno fatto domanda persone della stessa nazione dell’azienda, ma di cui sono 
risultati vincitori persone di altra nazione. */

SELECT B.*
FROM BANDO B 
        JOIN AZIENDA A ON (B.IDA = A.IDA)
        JOIN DOMANDA D ON (B.IDB = D.IDB)
        JOIN PERSONA P ON (D.CF = P.CF)
        JOIN PERSONA P2 ON (B.CF_VINCITORE = P2.CF)
WHERE A.NAZIONE = P.NAZIONE 
AND P2.NAZIONE <> A.NAZIONE 

/*3. Selezionare le persone che nel 2020 hanno partecipato a più bandi rispetto al 2019 (si considera la data della domanda).*/

SELECT P.CF, P.NOMINATIVO, P.DATANASCITA, P.CITTA, P.NAZIONE 
FROM PERSONA P 
        JOIN DOMANDA D ON (P.CF = D.CF)
WHERE YEAR(D.DATA) = 2020
GROUP BY P.CF, P.NOMINATIVO, P.DATANASCITA, P.CITTA, P.NAZIONE
HAVING COUNT(*) > (
    SELECT COUNT(*)
    FROM PERSONA P2 
            JOIN DOMANDA D2 ON (P2.CF = D2.CF)
    WHERE YEAR(D.DATA) = 2019 
    AND P2.CF = P.CF
)
