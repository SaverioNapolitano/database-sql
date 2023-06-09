/*Prova totale 6-07-2021*/

/*Esercizio 3*/

/*1: Selezionare le auto prodotte prima del 1980 che hanno ottenuto un voto maggiore di 50 da un giudice di nazionalità italiana.*/

SELECT A.*
FROM AUTOMOBILE A 
        JOIN GIUDIZIO G ON (A.TARGA = G.TARGA)
        JOIN GIUDICE GI ON (G.CF = GI.CF)
WHERE ANNO <= 1980 
AND PUNTI > 50 
AND NAZIONALITA = 'ITALIANA'
GO

/*2: Selezionare il nome dei concorsi in cui in tutte le edizioni ha partecipato almeno un’autovettura di marca “Ferrari”.*/

/*VERSIONE 1: VIEW*/
CREATE VIEW S1 AS 
SELECT NOME, EDIZIONE 
FROM PARTECIPA 
EXCEPT 
SELECT NOME, EDIZIONE
FROM PARTECIPA P
        JOIN AUTOMOBILE A ON (P.TARGA = A.TARGA)
WHERE MARCA = 'FERRARI'
GO 

CREATE VIEW S2 AS 
SELECT C.*
FROM CONCORSO C 
        JOIN S1 ON (C.NOME = S1.NOME AND C.EDIZIONE = S1.EDIZIONE)
GO 

SELECT NOME 
FROM CONCORSO 
EXCEPT 
SELECT NOME 
FROM S2 
GO 

/*VERSIONE 2: NOT EXISTS*/
/*NON ESISTE UN'EDIZIONE DEL CONCORSO IN CUI NON HA PARTECIPATO NESSUNA AUTOVETTURA DI MARCA 'FERRARI'*/
SELECT C1.NOME 
FROM CONCORSO C1
WHERE NOT EXISTS (
    SELECT *
    FROM CONCORSO C2
    WHERE C1.NOME = C2.NOME --FISSO IL NOME E VARIO L'EDIZIONE
    AND NOT EXISTS (
        SELECT *
        FROM AUTOMOBILE A 
                JOIN PARTECIPA P ON (A.TARGA = P.TARGA)
        WHERE P.NOME = C1.NOME --CORRELAZIONE CON LA PRIMA QUERY (STESSO NOME DEL CONCORSO)
        AND P.EDIZIONE = C2.EDIZIONE  --CORRELAZIONE CON LA SECONDA QUERY (STESSA EDIZIONE DEL CONCORSO)
        AND A.MARCA = 'FERRARI'
    )
)
GO 

/*3: Creare una vista che mostri per ogni edizione di concorso l’auto vincitrice (punteggio massimo)*/

CREATE VIEW QUERY3 AS 
SELECT G.TARGA, A.MARCA, A.MODELLO, A.ANNO, G.NOME, G.EDIZIONE
FROM GIUDIZIO G 
        JOIN AUTOMOBILE A ON (G.TARGA = A.TARGA)
GROUP BY G.TARGA, G.NOME, G.EDIZIONE, A.MARCA, A.MODELLO, A.ANNO
HAVING SUM(PUNTI) >= ALL(
    SELECT SUM(PUNTI)
    FROM GIUDIZIO G2 
    WHERE G.NOME = G2.NOME 
    AND G.EDIZIONE = G2.EDIZIONE --FISSO IL CONCORSO
    GROUP BY G2.TARGA --SE NON RAGGRUPPO PER TARGA SOMMO TUTTE LE VALUTAZIONI DI TUTTE LE AUTO DI QUEL CONCORSO
)
GO

/*4. Selezionare il codice di tutti i ricambi di cui il ricambio codice 123456 fa parte. */

WITH QUERY4(RICAMBIO, COMPOSTO) AS 
(
        (
                SELECT CODR, COMPONE 
                FROM RICAMBIO
                WHERE COMPONE IS NOT NULL 
        )
        UNION ALL 
        (
                SELECT QUERY4.RICAMBIO, R.COMPONE 
                FROM QUERY4 
                                JOIN RICAMBIO R ON (QUERY4.COMPOSTO = R.CODR)
                WHERE R.COMPONE IS NOT NULL 
        )
)

SELECT COMPOSTO
FROM QUERY4
WHERE RICAMBIO = 123456




