/*Prova totale 21-07-2020*/

/*Esercizio 4*/

/*1. Selezionare i dati dei trial clinici che non utilizzano farmaci di tipo “sperimentale”.*/

/*VERSIONE 1: EXCEPT*/
SELECT *
FROM TRIAL T 
EXCEPT 
SELECT T1.*
FROM TRIAL T1 
        JOIN UTILIZZA U ON (T.CODICE = U.CODICE)
        JOIN FARMACO F ON (U.NOMEF = F.NOMEF)
WHERE F.TIPO = 'SPERIMENTALE'

/*VERSIONE 2: NOT IN */
SELECT *
FROM TRIAL T 
WHERE T.CODICE NOT IN (
    SELECT U.CODICE
    FROM UTILIZZA U 
            JOIN FARMACO F ON (U.NOMEF = F.NOMEF)
    WHERE F.TIPO = 'SPERIMENTALE'
)

/*2. Selezionare i dati dei farmaci che contengono tutti i principi attivi con het uguale a “SAN”. */

SELECT *
FROM FARMACO F 
WHERE NOT EXISTS(
    SELECT *
    FROM PRINCIPIO_ATTIVO P 
    WHERE P.TIPO = 'SAN'
    AND NOT EXISTS(
        SELECT *
        FROM CONTIENE C 
        WHERE C.IDP = P.IDP
        AND C.NOMEF = F.NOMEF
    )
)
GO 

/*3. Creare una vista che selezioni per ogni trial clinico il numero di farmaci utilizzati, il numero distinto di principi attivi utilizzati. 
Selezionare solo i trial che utilizzano più di 5 principi attivi differenti.*/

CREATE VIEW QUERY3 AS 
SELECT T.CODICE, COUNT(DISTINCT U.NOMEF) AS NFARMACI, COUNT(DISTINCT C.IDP) AS NPRINCIPI
FROM TRIAL T 
        JOIN UTILIZZA U ON (T.CODICE = U.CODICE)
        JOIN CONTIENE C ON (U.NOMEF = C.NOMEF)
GROUP BY T.CODICE
HAVING COUNT(DISTINCT C.IDP) > 5