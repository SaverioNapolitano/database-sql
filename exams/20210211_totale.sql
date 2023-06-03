/*Prova totale 11-02-2021*/

/*1. Selezionare nome e cognome degli studenti non hanno mai avuto un esito negativo negli esami dell’insegnamento di “Analisi I” (esito < 18)*/

SELECT S.NOME, S.COGNOME
FROM STUDENTE S 
WHERE S.MATRICOLA NOT IN (
    SELECT E.MATRICOLA
    FROM ESAME E
            JOIN INSEGNAMENTO I ON (E.CODI = I.CODI)
    WHERE ESITO < 18
    AND I.NOME = 'ANALISI I'
)
GO

/*2. Selezionare gli studenti che hanno superato tutti gli insegnamenti del corso di studi di “Laurea in Ing. Inf.” (esito >= 18). */

SELECT *
FROM STUDENTE S 
WHERE NOT EXISTS (
    SELECT *
    FROM INSEGNAMENTO I 
    WHERE CORSO = 'LAUREA IN ING. INF'
    AND NOT EXISTS (
        SELECT *
        FROM ESAME E 
        WHERE ESITO >= 18 
        AND E.CODI = I.CODI
        AND E.MATRICOLA = S.MATRICOLA
    )
)
GO 

/* 3. Creare una vista che mostri per ogni corso lo studente con la media più alta considerando solo gli insegnamenti superati (esito >= 18).*/

CREATE VIEW QUERY3 AS 
SELECT S.*, I.CORSO
FROM STUDENTE S 
        JOIN ESAME E ON (S.MATRICOLA = E.MATRICOLA)
        JOIN INSEGNAMENTO I ON (E.CODI = I.CODI)
WHERE E.ESITO >= 18
GROUP BY S.MATRICOLA, S.NOME. S.COGNOME, I.CORSO 
HAVING AVG(E.ESITO) >= ALL(
    SELECT AVG(E2.ESITO)
    FROM ESAME E2 
    WHERE E2.ESITO >= 18 
    AND E2.CODI = I.CODI 
    GROUP BY E2.MATRICOLA --SE NON LO METTO CONFRONTO LA MEDIA DI UNO STUDENTE CON LA MEDIA DI TUTTI GLI STUDENTI
)

