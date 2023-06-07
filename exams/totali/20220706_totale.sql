/*Prova totale 06-07-2022*/

/*Esercizio 1*/

/*Istruzioni GROUP BY e HAVING in SQL: sintassi ed esempi.*/

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

[ Il raggruppamento viene fatto sulle tuple selezionate dal FROM-WHERE: viene fatto prima il JOIN, poi le eventuali condizioni WHERE e quindi
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

*/



/*Esercizio 4*/

/*a) Selezionare il nome e il prezzo d'acquisto (prezzo alla data dell'acquisto) dei prodotti che sono stati acquistati da clienti nati prima del 01/01/1990.*/

SELECT P.NOME, PR.PREZZO 
FROM PRODOTTO P 
        JOIN ACQUISTO A ON (P.COD_PRODOTTO = A.COD_PRODOTTO)
        JOIN CLIENTE C ON (A.USERNAME = C.USERNAME)
        JOIN PREZZO PR ON (P.COD_PRODOTTO = PR.COD_PRODOTTO)
WHERE YEAR(DATA_NASCITA) < 1990
AND PR.DATA_INIZIO <= A.DATA_ACQUISTO 
AND PR.DATA_FINE >= A.DATA_ACQUISTO
GO 

/*b) Selezionare lo username dei clienti che hanno acquistato soltanto i prodotti che Enrico Bianchini ha acquistato dopo il 20/11/2015.*/

CREATE VIEW S1 AS 
SELECT A.COD_PRODOTTO
FROM CLIENTE C 
        JOIN ACQUISTO A ON (C.USERNAME = A.USERNAME)
WHERE A.DATA_ACQUISTO > '20-11-2015'
AND C.NOME = 'ENRICO'
AND C.COGNOME = 'BIANCHINI'
GO 

CREATE VIEW S2 AS 
SELECT C.USERNAME 
FROM CLIENTE C 
        JOIN ACQUISTO A ON (C.USERNAME = A.USERNAME)
WHERE A.COD_PRODOTTO NOT IN (
    SELECT S1.COD_PRODOTTO
    FROM S1 
)
GO 

SELECT C.USERNAME 
FROM CLIENTE C 
WHERE C.USERNAME NOT IN (
    SELECT S2.USERNAME 
    FROM S2
)
GO 

/*c) Creare una vista che mostri il COD_PRODOTTO dei prodotti di tipo "casalingo", che sono stati venduti per un totale complessivo superiore
a 10000€ dal 01/01/2016.*/

CREATE VIEW QUERYC AS 
SELECT P.COD_PRODOTTO
FROM PRODOTTO P 
        JOIN ACQUISTO A ON (P.COD_PRODOTTO = A.COD_PRODOTTO)
        JOIN PREZZO PR ON (P.COD_PRODOTTO = PR.COD_PRODOTTO)
WHERE A.DATA_ACQUISTO BETWEEN PR.DATA_INIZIO AND PR.DATA_FINE
AND A.DATA_ACQUISTO > '01-01-2016'
AND P.TIPO = 'CASALINGO'
GROUP BY P.CODPRODOTTO 
HAVING SUM(PREZZO) > 10000
GO 

/*d) Per ogni tipo di prodotto trovare lo username del cliente che ha speso di più per quel tipo di prodotto.*/

SELECT A.USERNAME
FROM PRODOTTO P 
        JOIN ACQUISTO A ON (P.COD_PRODOTTO = A.COD_PRODOTTO)
        JOIN PREZZO PR ON (A.COD_PRODOTTO = PR.COD_PRODOTTO) 
WHERE A.DATA_ACQUISTO BETWEEN PR.DATA_INIZIO AND PR.DATA_FINE
GROUP BY A.USERNAME, P.TIPO 
HAVING SUM(PREZZO) >= ALL(
    SELECT SUM(PREZZO) 
    FROM PRODOTTO P2 
            JOIN ACQUISTO A2 ON (P2.COD_PRODOTTO = A2.COD_PRODOTTO)
            JOIN PREZZO PR2 ON (A2.COD_PRODOTTO = PR2.COD_PRODOTTO)
    WHERE P2.TIPO = P.TIPO 
    AND A2.DATA_ACQUISTO BETWEEN PR2.DATA_INIZIO AND PR2.DATA_FINE
    GROUP BY A2.USERNAME 
)


