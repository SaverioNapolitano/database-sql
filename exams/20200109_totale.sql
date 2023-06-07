/*Prova totale 09-01-2020*/

/*Esercizio 1*/

/*Illustrare il concetto di reificazione in E/R, indicando i vari casi e gli identificatori corrispondenti.*/

/*
per reificazione si intende la rappresentazione di un’associazione in una forma equivalente tramite un’entità:
sia A un’associazione tra E1,E2,…,En. La reificazione di A è un’entità, che continueremo ad indicare con A e chiameremo A reificata, collegata con ciascuna delle entità Ei che partecipano all’associazione A, tramite un’associazione binaria uno-a-molti A_Ei con
•	Card (A, A_Ei) = (1,1) e 
•	Card (Ei, A_Ei) = card (Ei, A).
Per definire l’identificatore di un’associazione reificata: sia A un’associazione tra E1,E2,…,En. Ogni Ei tale che max-card (Ei, A) = 1 è un identificatore di A reificata; altrimenti A ha un unico identificatore costituito dalle entità E1,E2,…,En.
*/

/*Esercizio 4*/

/*a) Selezionare gli utenti che nel 2014 non hanno acquistato voli con destinazione “New York”.*/

/*VERSIONE 1: EXCEPT*/
SELECT *
FROM UTENTE 
EXCEPT 
SELECT U.*
FROM UTENTE U 
        JOIN ACQUISTO A ON (U2.USERNAME = A.USERNAME)
        JOIN VOLO V ON (A.CODV = V.CODV)
        JOIN AEROPORTO AE ON (AE.CODA = V.DESTINAZIONE)
WHERE YEAR(V.DATA) = 2014 
AND AE.CITTA = 'NEW YORK'


/*VERSIONE 2: NOT IN*/
SELECT *
FROM UTENTE U 
WHERE U.USERNAME NOT IN (
    SELECT A.USERNAME
    FROM ACQUISTO A 
            JOIN VOLO V ON (A.CODV = V.CODV)
            JOIN AEROPORTO AE ON (AE.CODA = V.DESTINAZIONE)
    WHERE YEAR(V.DATA) = 2014 
    AND AE.CITTA = 'NEW YORK'
)

/*b) Selezionare gli utenti che nel maggio 2010 sono partiti da tutti gli aeroporti di Milano.*/

SELECT *
FROM UTENTE U 
WHERE NOT EXISTS(
    SELECT *
    FROM AEROPORTO AE 
    WHERE CITTA = 'MILANO'
    AND NOT EXISTS(
        SELECT *
        FROM ACQUISTO A 
                JOIN VOLO V ON (A.CODV = V.CODV)
        WHERE A.USERNAME = U.USERNAME 
        AND YEAR(V.DATA) = 2010 
        AND MONTH(V.DATA) = 5
        AND V.PARTENZA = AE.CODA 
    )
)

/*c) Creare una vista che mostri per ogni aeroporto, il numero di voli partiti, il numero di voli arrivati, il numero distinto di utenti arrivati, il numero distinto di utenti partiti. 
Mostrare solamente gli aeroporti che sono stati visitati (partenze + arrivi) da almeno 10000 persone diverse. */

SELECT AE.CODA, COUNT(DISTINCT V.CODV) AS VP, COUNT(DISTINCT V2.CODV) AS VA, COUNT(DISTINCT A.USERNAME) AS  UP, COUNT(DISTINCT A2.USERNAME) AS UA
FROM AEROPORTO AE 
        JOIN VOLO V ON (AE.CODA = V.PARTENZA)
        JOIN VOLO V2 ON (AE.CODA = V.DESTINAZIONE)
        JOIN ACQUISTO A ON (A.CODV = V.CODV)
        JOIN ACQUISTO A2 ON (A2.CODV = V2.CODV)
GROUP BY AE.CODA 
HAVING COUNT(DISTINCT A.USERNAME) + COUNT(DISTINCT A2.USERNAME) >= 10000