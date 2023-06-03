/*Prova totale 12-01-2021*/

/*Esercizio 4*/

/*1. Selezionare i dati delle persone (CF, nome e cognome) che non hanno fatto acquisti nel mese di dicembre 2020. */

/*VERSIONE 1: EXCEPT*/
SELECT *
FROM PERSONA 
EXCEPT 
SELECT P.*
FROM PERSONA P 
        JOIN CARTA C ON (P.CF = C.CF)
        JOIN ACQUISTO A ON (C.NUMERO = A.NUMERO)
WHERE A.DATA BETWEEN '1-12-2020' AND '31-12-2020'

/*VERSIONE 2: NOT IN*/
SELECT *
FROM PERSONA P
WHERE P.CF NOT IN (
    SELECT C.CF
    FROM CARTA C 
            JOIN ACQUISTO A ON (C.NUMERO = A.NUMERO)
    WHERE YEAR(A.DATA) = 2020
    AND MONTH(A.DATA) = 12 
)


/*2. Selezionare i dati delle persone che hanno fatto acquisti in tutti i negozi online di categoria “elettronica” della città di Modena.*/

SELECT *
FROM PERSONA P 
WHERE NOT EXISTS(
    SELECT *
    FROM NEGOZIO N 
    WHERE TIPO = 'ONLINE' 
    AND CATEGORIA = 'ELETTRONICA'
    AND CITTA = 'MO'
    AND NOT EXISTS (
        SELECT *
        FROM CARTA C 
                JOIN ACQUISTO A ON (C.NUMERO = A.NUMERO)
        WHERE C.CF = P.CF 
        AND A.PIVA = N.PIVA
    )
)
GO 

/*3. Creare  una  vista  che  selezioni  per  ogni  persona  e  per  ogni  meseed  annoil numerodi  acquisti e  l’importo complessivoper  acquisti  in  negozi fisici. 
Visualizzare solamente i record con un importo complessivo maggiore di 1000€. */

CREATE VIEW QUERY3 AS 
SELECT COUNT(*) AS NACQUISTI, SUM(IMPORTO) AS TOTALE, C.CF, YEAR(A.DATA) AS ANNO, MONTH(A.DATA) AS MESE 
FROM CARTA C 
        JOIN ACQUISTO A ON (C.NUMERO = A.NUMERO)
        JOIN NEGOZIO N ON (N.PIVA = A.PIVA)
WHERE N.TIPO = 'FISICO'
GROUP BY C.CF, YEAR(A.DATA), MONTH(A.DATA)
HAVING SUM(IMPORTO) > 1000
