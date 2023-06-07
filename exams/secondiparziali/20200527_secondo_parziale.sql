/*Seconda prova parziale 27-05-2020*/

/*Esercizio 1*/

/*1. Selezionare i dati delle persone di età superiore a 20 anni che hanno acquistato un ticket per un parco di tipo “acquatico”.*/

SELECT P.*
FROM PERSONA P 
        JOIN TICKET T ON (P.CF = T.CF)
        JOIN PARCO PA ON (T.IDP = PA.IDP)
WHERE P.ETA > 20 
AND PA.TIPO = 'ACQUATICO'

/*2. Selezionare le città dei parchi che non possiedono un’attrazione di nome “torri gemelle”. */

SELECT PA.CITTA
FROM PARCO PA 
WHERE PA.IDP NOT IN (
    SELECT C.IDP
    FROM CONTIENE C 
    WHERE NOMEA = 'TORRI GEMELLE'
)

/*3. Selezionare il  nome  e il  cognomedelle  persone  che  hanno  visitato tutte  le  attrazioni  di livello “8”. */

/*NON ESISTE UNA ATTRAZIONE DI LIVELLO 8 CHE NON E' STATA VISITATA DALLA PERSONA*/

SELECT NOME, COGNOME
FROM PERSONA P 
WHERE NOT EXISTS(
    SELECT *
    FROM ATTRAZIONE A 
    WHERE LIVELLO = 8
    AND NOT EXISTS(
        SELECT *
        FROM VISITA V 
        WHERE V.CF = P.CF 
        AND V.NOMEA = A.NOMEA
    )
)

/*Esercizio 2*/

/*1. Selezionare i parchi che hanno venduto ticket a persone di nazionalità italiana oppure che contengono un’attrazione con nome “ottovolante”.*/

SELECT PA.*
FROM PARCO PA 
        JOIN TICKET T ON (PA.IDP = T.IDP)
        JOIN PERSONA P ON (T.CF = P.CF)
WHERE P.NAZIONALITA = 'ITALIANA'
UNION 
SELECT PA.*
FROM PARCO PA 
        JOIN CONTIENE C ON (PA.IDP = C.IDP)
WHERE C.NOMEA = 'OTTOVOLANTE'

/*2. Selezionare  le  persone  che  hanno  visitato  solo  parchi  che contengono  solo  attrazioni  di  livello superiore a “5”.*/

/*NON ESISTONO PARCHI CON ATTRAZIONI DI LIVELLO INFERIORE O UGUALE 5 CHE SONO STATI VISITATI DALLA PERSONA*/

SELECT *
FROM PERSONA P 
WHERE NOT EXISTS (
    SELECT *
    FROM PARCO PA 
    WHERE NOT EXISTS(
        SELECT *
        FROM ATTRAZIONE A 
                JOIN VISITA V ON (A.NOMEA = V.NOMEA)
        WHERE LIVELLO <= 5
        AND P.CF = V.CF 
        AND PA.IDP = V.IDP
    )
)

/*3. Per ogni parco riportare il numero totale di biglietti venduti, l’incasso totale e il numero distinto di persone che hanno visitato il parco. 
I valori devono essere calcolati e riportati separatamente per ogni anno.*/

SELECT SUM(T.PREZZO) AS TOTALE, COUNT(*) AS BIGLIETTI, COUNT(DISTINCT T.CF) AS PERSONE, T.IDP
FROM TICKET T
GROUP BY T.IDP, YEAR(T.DATA) 
GO 

/*4. Creare una vista che mostri per ogni nazionalità il numero distinto di parchi e di attrazioni visitati dal 2017 al 2019 da persone di quella nazionalità. 
Devono essere riportate solamente le nazionalità che hanno più di 100 persone di età uguale o maggiore di 18.*/

CREATE VIEW QUERY4 AS 
SELECT COUNT(DISTINCT V.IDP) AS NPARCHI, COUNT(DISTINCT V.NOMEA) AS NATTRAZIONI, P.NAZIONALITA
FROM PERSONA P 
        JOIN VISITA V ON (P.CF = V.CF)
WHERE YEAR(V.DATA) BETWEEN 2017 AND 2019
GROUP BY P.NAZIONALITA  
HAVING (SELECT COUNT(*)
        FROM PERSONA P2 
        WHERE P2.NAZIONALITA = P.NAZIONALITA 
        AND P2.ETA >= 18) > 100


