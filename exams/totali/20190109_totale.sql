/*Prova totale 09-01-2018*/ 

/*Esercizio 1*/

/*a. Istruzioni GROUP BY e HAVING in SQL. */

/*
In una istruzione SELECT è possibile formare dei gruppi di tuple che hanno lo stesso valore di specificati attributi, tramite la clausola
GROUP BY.

SELECT [DISTINCT|ALL] <lista-SELECT>
FROM <lista-FROM>
[WHERE <condizione>]
[GROUP BY <lista-GROUP>]

Il risultato della SELECT è un unico record per ciascun gruppo, pertanto nella <lista-SELECT> possono comparire solo:
- Uno o più attributi di raggruppamento, cioè specificati in <lista-GROUP>
- Funzioni aggregate: tali funzioni vengono valutate, e quindi forniscono un valore unico, per ciascun gruppo.

Il raggruppamento viene fatto sulle tuple selezionate dal FROM-WHERE: viene fatto prima il JOIN, poi le eventuali condizioni WHERE e quindi
il GROUP BY. Alla fine si effettua la parte SELECT, riportando in output una riga per gruppo.

La clausola HAVING è l'equivalente della clausola WHERE applicata a gruppi di tuple: ogni gruppo costruito tramite GROUP BY fa parte del 
risultato dell'interrogazione solo se il predicato specificato nella clausola HAVING risulta soddisfatto.

Il predicato espresso nella clausola HAVING è formulato utilizzando:
- Uno o più attributi specificati in <lista-GROUP>
- Funzioni aggregate

Esempi: 

S 
----------------------
| NOME | CITTA | ETA |
----------------------
| A    | MO    | 16  |
----------------------
| B    | MI    | 19  |
----------------------
| C    | MO    | 21  |
----------------------

SELECT COUNT(*) AS NS
FROM S 
GROUP BY CITTA 
HAVING ETA > 18

----------------------
| NOME | CITTA | ETA |
----------------------
| C    | MO    | 21  |
----------------------
| B    | MI   | 19  |
----------------------

*/

/*Esercizio 4*/

/*a) Selezionare nome e cognome dei clienti che hanno noleggiato solo film di genere ‘drammatico’.*/

SELECT NOME, COGNOME
FROM CLIENTE C 
        JOIN NOLEGGIO N2 ON (C.NUM_TESSERA = N2.NUM_TESSERA)
WHERE NUM_TESSERA NOT IN(
    SELECT N.NUM_TESSERA
    FROM NOLEGGIO N 
            JOIN FILM_GENERE FG ON (n.ID_FILM = FG.ID_FILM)
            JOIN GENERE G ON (FG.GEN_ID = G.GEN_ID)
    WHERE G.NOME <> 'DRAMMATICO'
)

/*b) Selezionare i clienti che hanno noleggiato tutti i film usciti nel mese di maggio 2015.*/

SELECT *
FROM CLIENTE C 
WHERE NOT EXISTS(
    SELECT *
    FROM FILM F 
    WHERE YEAR(DATA_USCITA) = 2015
    AND MONTH(DATA_USCITA) = 5
    AND NOT EXISTS(
        SELECT *
        FROM NOLEGGIO N 
        WHERE N.NUM_TESSERA = C.NUM_TESSERA
        AND N.ID_FILM = F.ID_FILM
    )
)
GO 

/*c) Creare una vista che mostri per ogni utente: numero di tessera, nome, cognome, il numero di noleggi attivi (film ancora da restituire) e il numero di noleggi terminati (film già restituiti).*/

CREATE VIEW NOLEGGI_ATTIVI AS 
SELECT COUNT(*) AS NOLEGGI_ATTIVI, C.NUM_TESSERA
FROM CLIENTE C 
        JOIN NOLEGGIO N ON (C.NUM_TESSERA = N.NUM_TESSERA)
GROUP BY C.NUM_TESSERA, N.DATA_RIENTRO
HAVING N.DATA_RIENTRO IS NULL 
GO 

CREATE VIEW QUERYC AS 
SELECT C.NUM_TESSERA, C.NOME. C.COGNOME, COUNT(DATA_RIENTRO) AS NOLEGGI_TERMINATI, NA.NOLEGGI_ATTIVI
FROM CLIENTE C 
        JOIN NOLEGGIO N ON (C.NUM_TESSERA = N.NUM_TESSERA)
        JOIN NOLEGGI_ATTIVI NA ON (C.NUM_TESSERA = NA.NUM_TESSERA)
GROUP BY C.NUM_TESSERA, C.NOME. C.COGNOME 


