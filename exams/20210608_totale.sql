/*Prova totale 08-06-2021*/

/*Esercizio 3*/

/*1. Selezionare i dati dei sanitari che non hanno mai effettuato un prelievo a un paziente più giovane di loro.*/

/*VERSIONE 1: EXCEPT*/
SELECT *
FROM DIPENDENTE 
EXCEPT 
SELECT D.*
FROM DIPENDENTE D 
        JOIN PRELIEVO P ON (D.CF = P.SANITARIO)
        JOIN PAZIENTE PA ON (P.PAZIENTE = PA.CF)
WHERE PA.DATANASCITA > D.DATANASCITA 

/*VERSIONE 2: NOT IN*/
SELECT *
FROM DIPENDENTE D 
WHERE CF NOT IN (
    SELECT D2.CF
    FROM DIPENDENTE D2 
            JOIN PRELIEVO P ON (D.CF = P.SANITARIO)
            JOIN PAZIENTE PA ON (P.PAZIENTE = PA.CF)
    WHERE PA.DATANASCITA > D.DATANASCITA  
)

/*2. Selezionare nome e cognome dei pazienti che hanno svolto tutti i possibili esami offerti dalla struttura (non necessariamente con un unico prelievo).*/

/*NON ESISTE UN ESAME CHE IL PAZIENTE NON HA SVOLTO*/

SELECT P.NOME, P.COGNOME 
FROM PAZIENTE P
WHERE NOT EXISTS(
    SELECT *
    FROM ESAME E 
    WHERE NOT EXISTS(
        SELECT *
        FROM PRELIEVO PR 
                JOIN PRELIEVO_ESAME PE ON (PR.CODP = PE.CODP)
        WHERE PR.PAZIENTE = P.CF 
        AND PE.CODE = E.CODE 
    )
)

/*3. Selezionare la città in cui risiede il paziente per il quale sono state utilizzate più provette.*/

SELECT PA.CITTA 
FROM PAZIENTE PA 
        JOIN PRELIEVO P ON (PA.CF = P.PAZIENTE)
GROUP BY PA.CF, PA.CITTA 
HAVING SUM(NPROVETTE) >=ALL(
    SELECT SUM(NPROVETTE)
    FROM PAZIENTE PA2 
            JOIN P2 ON (PA2.CF = P2.PAZIENTE)
    GROUP BY PA.CF
)

/*4. Individuare tutti i dipendenti a cui fa riferimento (direttamente o indirettamente) l’infermiere Marco Bianchi.*/

WITH QUERY4(CF, RESPONSABILE) AS
(
        (
                SELECT CF, RESPONSABILE
                FROM DIPENDENTE
                WHERE RESPONSABILE IS NOT NULL 
        )
        UNION ALL 
        (
                /*SELECT QUERY4.CF, D.RESPONSABILE
                FROM QUERY4 
                                JOIN DIPENDENTE D ON (QUERY4.RESPONSABILE = D.CF)
                WHERE QUERY4.RESPONSABILE IS NOT NULL */
                --EQUIVALENTI
                SELECT D.CF, QUERY4.RESPONSABILE
                FROM QUERY4 
                                JOIN DIPENDENTE D ON (QUERY4.CF = D.RESPONSABILE)
                WHERE D.RESPONSABILE IS NOT NULL 

        )
)

SELECT D.*
FROM QUERY4 Q 
        JOIN DIPENDENTE D ON (Q.RESPONSABILE = D.CF)
WHERE NOME = 'MARCO'
AND COGNOME =  'BIANCHI' 
AND RUOLO = 'INFERMIERE'



