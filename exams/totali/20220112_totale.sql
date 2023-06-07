/*Prova totale 12-01-2022*/

/*Esercizio 3*/

/*1. Selezionare i viaggi partiti da Modena in cui è presente almeno un passeggero nato a Carpi dopo il 2000.*/

SELECT V.*
FROM VIAGGIO V 
        JOIN PASSEGGERO P ON (V.COD_VIAGGIO = P.COD_VIAGGIO)
        JOIN UTENTE U ON (P.CF_PASSEGGERO = U.CF)
WHERE CITTA = 'CARPI'
AND PARTENZA = 'MO'
AND YEAR(DATA_NASCITA) >= 2000


/*2. Selezionare la targa delle auto che in tutti i viaggi sono state guidate solo dal proprietario.*/


SELECT TARGA 
FROM AUTOMOBILE A 
WHERE NOT EXISTS(
        SELECT *
        FROM VIAGGIO V2 
        WHERE V.TARGA = A.TARGA
        AND V.CF_CONDUCENTE <> A.CF_PROPRIETARIO
)
GO 

/*3. Creare una vista che mostri targa e modello delle auto che hanno un costo medio dei viaggi inferiore a 50€.*/

CREATE VIEW QUERY3 AS 
SELECT A.TARGA, A.MODELLO 
FROM AUTOMOBILE A 
        JOIN VIAGGIO V ON (A.TARGA = V.TARGA)
GROUP BY A.TARGA, A.MODELLO 
HAVING AVG(COSTO) < 50
GO 

/*4. Selezionare per ogni viaggio i dati del passeggero più giovane.*/


SELECT U.*
FROM UTENTE U 
        JOIN PASSEGGERO P ON (U.CF = P.CF_PASSEGGERO)
WHERE U.DATA_NASCITA = (
    SELECT MAX(DATA_NASCITA)
    FROM UTENTE U2 
            JOIN PASSEGGERO P2 ON (U2.CF = P2.CF_PASSEGGERO)
    WHERE P.COD_VIAGGIO = P2.COD_VIAGGIO
)