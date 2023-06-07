/*Prova totale 14-09-2021*/

/*Esercizio 3*/

/*1. Selezionare i nominativi degli attori che hanno recitato in un film uscito nel 2000 oppure che hanno recitato insieme a Brad Pitt.*/

SELECT A.NOMINATIVO
FROM ATTORE A 
        JOIN RECITA R ON (A.CODA = R.CODA)
        JOIN FILM F ON (R.CODF = F.CODF)
WHERE YEAR(DATA_USCITA) = 2000
UNION 
SELECT A2.NOMINATIVO
FROM ATTORE A2 
        JOIN RECITA R2 ON (A2.CODA = R2.CODA)
        JOIN RECITA R3 ON (R2.CODF = R3.CODF)
        JOIN ATTORE A3 ON (R3.CODA = A3.CODA)
WHERE A3.NOMINATIVO = 'BRAD PITT'

/*2. Selezionarei nominativi dei registi che non hanno mai diretto film in cui hanno recitato attori con nazionalità statunitense (USA).*/

SELECT R.NOMINATIVO 
FROM REGISTA R 
WHERE R.CODR NOT IN (
        SELECT F.CODR
        FROM FILM F
                JOIN RECITA RC ON (F.CODF = RC.CODF)
                JOIN ATTORE A ON (RC.CODA = A.CODA)
        WHERE A.NAZIONE = 'USA'
)
GO 

/*3. Creare  una  vista  che  mostri  per  ogni  attore  il  suo  nominativo  e  il  titolo dell’ultimo film in cui ha recitato (data più recente), 
considerando solo i film in cui hanno recitato attori di almeno 5 nazionalità distinte.*/
CREATE VIEW QUERY3 AS 
SELECT A.NOMINATIVO, F.TITOLO 
FROM ATTORE A 
        JOIN RECITA R ON (A.CODA = R.CODA)
        JOIN FILM F ON (R.CODF = F.CODF)
WHERE F.DATA_USCITA = (
    SELECT MAX(F2.DATA_USCITA)
    FROM FILM F2 
        JOIN RECITA R2 ON (F2.CODF = R2.CODF)
    WHERE R2.CODA = A.CODA
    AND F2.CODF IN (
        SELECT CODF
        FROM RECITA R3
            JOIN ATTORE AI ON (R3.CODA = AI.CODA)
        GROUP BY R3.CODF --SE NON RAGGRUPPO CONTROLLO CHE CONSIDERANDO TUTTI I FILM ABBIANO RECITATO ATOTORI DI ALMENO 5 NAZIONALITA DIVERSE
        HAVING COUNT(DISTINCT AI.NAZIONE) >= 5
    )
)
GO 

/*4. Selezionare il titolo di tutti i film della saga di Harry Potter che precedono “Harry Potter e l’Ordine della Fenice” (prequel).*/

WITH GERARCHIA(SUBFILM, SUPERFILM) AS 
(
    (
        SELECT CODF, SEQUEL 
        FROM FILM 
        WHERE SEQUEL IS NOT NULL
    )
    UNION ALL 
    (
        SELECT G.SUBFILM, F.SEQUEL 
        FROM GERARCHIA G  
                JOIN FILM F ON (G.SUPERFILM = F.CODF)
        WHERE F.SEQUEL IS NOT NULL 
    )
)

SELECT BF.TITOLO
FROM GERARCHIA G 
        JOIN FILM BF ON (G.SUBFILM = BF.CODF)
        JOIN FILM SF ON (G.SUPERFILM = SF.CODF)
WHERE SF.TITOLO = 'HARRY POTTER E L''ORDINE DELLA FENICE'