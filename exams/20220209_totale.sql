/*Prova totale 09-02-2022*/

/*Esercizio 3*/

/*1. Selezionare  il  nome  delle  nazioni che nello  snowboard  schierano almeno  un atleta nato negli anni 2000.*/

SELECT N.NOME
FROM NAZIONE N
        JOIN ATLETA A ON (N.NOME = A.NAZIONE)
        JOIN GAREGGIA G ON (A.ID = G.ATLETA)
        JOIN EVENTO E ON (G.EVENTO = E.COD)
WHERE YEAR(A.DATA_NASCITA) >= 2000
AND E.SPORT = 'SNOWBOARD'

/*2. Selezionare nome e cognome delle atleteche gareggiano in tutti gli eventi dello sci alpino femminile.*/

/*NON ESISTE UN EVENTO DELLO SCI ALPINO FEMMINILE A CUI L'ATLETA NON HA GAREGGIATO*/

SELECT A.NOME, A.COGNOME
FROM ATLETA A 
WHERE NOT EXISTS(
    SELECT *
    FROM EVENTO E 
    WHERE SPORT = 'SCI ALPINO'
    AND GENERE = 'FEMMINILE'
    AND NOT EXISTS(
        SELECT *
        FROM GAREGGIA G 
        WHERE G.ATLETA = A.ID 
        AND G.EVENTO = E.COD
    )
)
GO

/*3. Creare una vista che mostri nome e cognome degli atleti che prendono parte a più di tre eventi.*/

CREATE VIEW QUERY3 AS 
SELECT A.NOME, A.COGNOME 
FROM ATLETA A 
        JOIN GAREGGIA G ON (A.ID = G.ATLETA)
GROUP BY A.ID, A.NOME, A.COGNOME
HAVING COUNT(*) > 3
GO 

/*4. Selezionare per  ogni  nazione  l’atleta di  sesso  femminile che  ha  disputato  il maggior numero di Olimpiadi. */

SELECT N.NOME, A.*
FROM NAZIONE N 
        JOIN ATLETA A ON (N.NOME = A.NAZIONE)
WHERE A.SESSO = 'F'
AND A.NUM_OLIMPIADI >= ALL(
    SELECT A2.NUM_OLIMPIADI
    FROM ATLETA A2
    WHERE A2.NAZIONE = A.NAZIONE
    AND A.SESSO = 'F'
)
