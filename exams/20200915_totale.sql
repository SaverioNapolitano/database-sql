/*Prova totale 15-09-2020*/

/*Esercizio 4*/

/*1. Selezionare i clienti che hanno ordinato piatti che contengono solo ingredienti di tipo “vegetariano”.*/


/*VERSIONE 1: EXCEPT*/
SELECT *
FROM CLIENTE 
EXCEPT 
SELECT C.*
FROM CLIENTE C
        JOIN ORDINA O ON (C.CODC = ORDINA.CODC)
        JOIN CONTIENE CO ON (O.CODP = CO.CODP)
        JOIN INGREDIENTE I ON (C.CODI = I.CODI)
WHERE I.TIPO <> 'VEGETARIANO'

/*VERSIONE 2: NOT IN*/
SELECT *
FROM CLIENTE C 
WHERE C.CODC NOT IN (
    SELECT O.CODC 
    FROM ORDINA O 
            JOIN CONTIENE CO ON (O.CODP = CO.CODP)
            JOIN INGREDIENTE I ON (CO.CODI = I.CODI)
    WHERE I.TIPO <> 'VEGETARIANO'
)


/*2. Selezionare i clienti che nel 2020 hanno ordinato tutti i piatti con un prezzo maggiore di 20€.*/


/*NON ESISTE UN PIATTO CON UN PREZZO MAGGIORE DI 20€ CHE NON SIA STATO ORDINATO DAL CLIENTE NEL 2020*/

SELECT *
FROM CLIENTE C 
WHERE NOT EXISTS(
    SELECT *
    FROM PIATTO P
    WHERE PREZZO > 20 
    AND NOT EXISTS(
        SELECT *
        FROM ORDINA O 
        WHERE YEAR(O.DATA) = 2020
        AND O.CODC = C.CODC 
        AND O.CODP = P.CODP
    )
)
GO 

/*3. Creare una vista che selezioni per ogni cliente la data in cui ha speso più soldi mostrando l’importo speso.*/

CREATE VIEW QUERY3 AS 
SELECT O.CODC, O.DATA, SUM(PREZZO) AS IMPORTO
FROM ORDINA O
        JOIN PIATTO P ON (O.CODP = P.CODP)
GROUP BY O.CODC, O.DATA 
HAVING SUM(PREZZO) >= ALL(
    SELECT SUM(PREZZO)
    FROM ORDINA O2 
            JOIN PIATTO P2 ON (O2.CODP = P2.CODP)
    WHERE O2.CODC = O.CODC 
    GROUP BY O2.DATA 
) 
