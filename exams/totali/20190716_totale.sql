/*Prova totale 16-07-2019*/

/*Esercizio 1*/

/*Sintassi di interrogazioni innestate*/

/*

Una interrogazione viene detta innestata o nidificata se la sua condizione è formulata usando il risultato di un'altra interrogazione, chiamata
subquery.
In generale, un'interrogazione innestata viene formulata con:
Operatori quantificati: <attr> <op-rel> [ANY|ALL] <subquery>
Operatore di set: <attr> [NOT] IN <subquery>
Quantificatore esistenziale: [NOT] EXISTS <subquery>

Il confronto fra un attributo e il risultato di una interrogazione è possibile quando essa produce (run-time) un valore atomico. 
Il predicato EXISTS (<subquery>) ha valore true se e solo se l'insieme di valori restituiti da <subquery> è non vuoto. 
Il predicato NOT EXISTS (<subquery>) ha valore true se e solo se l'insieme di valori restituiti da <subquery> è vuoto. 

Una subquery viene detta correlata se la sua condizione è formulata usando relazione e/o sinonimi definite nella query esterna.


Esempi: 

S
------------------------
| MATR | NOME | ACORSO |
------------------------
| M1   |  A   |   1    |
------------------------
| M2   |  B   |   2    |
------------------------
| M3   |  C   |   3    |
------------------------
| M4   |  D   |  NULL  |
------------------------

E
--------------------
| MATR | CC | VOTO |
--------------------
| M1   | C1 | 22   |
--------------------
| M2   | C1 | 24   |
--------------------
| M3   | C2 | 30   |
--------------------

OPERATORI QUANTIFICATI: "Studenti con anno di corso più basso"

SELECT *
FROM S 
WHERE ACORSO <= ALL(
    SELECT ACORSO
    FROM S 
    WHERE ACORSO IS NOT NULL
)

PER OGNI STUDENTE SI CONFRONTA IL SUO ANNO DI CORSO CON QUELLO DI TUTTI GLI ALTRI STUDENTI E SI RIPORTA IN USCITA SOLO SE E IL MINIMO
SE NON METTO LA CONDIZIONE IS NOT NULL L'OPERATORE QUANTIFICATO CON ALL RESTITUISCE SEMPRE FALSE

------------------------
| MATR | NOME | ACORSO |
------------------------
| M1   |  A   |   1    |
------------------------


OPERATORI DI SET: 

"Nome degli studenti che hanno sostenuto l'esame del corso C1"

SELECT NOME 
FROM S 
WHERE MATR IN (
    SELECT MATR 
    FROM E 
    WHERE CC = 'C1'
)

PER OGNI STUDENTE CONFRONTA LA SUA MATRICOLA CON TUTTE LE MATRICOLE DEGLI STUDENTI CHE HANNO SOSTENUTO L'ESAME DEL CORSO C1 E SE TROVA 
CORRISPONDENZA RIPORTA IN USCITA IL NOME DELLO STUDENTE

QUANTIFICATORE ESISTENZIALE: 

"Nome degli studenti che hanno sostenuto l'esame del corso C1"

SELECT NOME 
FROM S 
WHERE EXISTS (
    SELECT *
    FROM E
    WHERE E.MATR = S.MATR
    AND E.CC = 'C1'
)

PER OGNI STUDENTE CONTROLLA SE ESISTE NELLA RELAZIONE ESAME UNA TUPLA CHE ABBIA LA STESSA MATRICOLA E IL CODICE CORSO 'C1' E SE LA TROVA
RIPORTA IN USCITA IL NOME DELLO STUDENTE

*/

/*Esercizio 4*/

/*a) Selezionare nome e cognome dei clienti che nel 2010 non hanno acquistato prodotti di tipo “giocattoli”.*/

SELECT C.NOME, C.COGNOME
FROM CLIENTE C 
WHERE C.CODC NOT IN (
    SELECT A.CODC 
    FROM ACQUISTO A 
            JOIN RIGA R ON (A.CODA = R.CODA)
            JOIN PRODOTTO P ON (R.CODP = P.CODP)
    WHERE YEAR(A.DATA) = 2010
    AND P.TIPO = 'GIOCATTOLI'
)

/*b) Selezionare i prodotti con prezzo superiore a 50€ che sono stati acquistati da tutti i clienti residenti nella città di Modena.*/

SELECT *
FROM PRODOTTO P
WHERE PREZZO > 50 
AND NOT EXISTS(
    SELECT *
    FROM CLIENTE C 
    WHERE C.CITTA = 'MO'
    AND NOT EXISTS(
        SELECT *
        FROM ACQUISTO A 
                JOIN RIGA R ON (A.CODA = R.CODA)
        WHERE R.CODP = P.CODP 
        AND A.CODC = C.CODC
    )
)
GO 

/*c) Creare una vista che mostri per ogni prodotto la quantità venduta, il totale realizzato e il numero distinto di clienti che hanno acquistato quel prodotto. 
Mostrare solamente i prodotti che sono stati venduti in almeno 10 città diverse. */

CREATE VIEW QUERYC AS 
SELECT P.CODP, P.NOME, SUM(QUANTITA) AS QUANTITA, SUM(QUANTITA*PREZZO) AS INCASSO, COUNT(DISTINCT C.CODC) AS NCLIENTI
FROM PRODOTTO P 
        JOIN RIGA R ON (P.CODP = R.CODP)
        JOIN ACQUISTO A ON (R.CODA = A.CODA)
        JOIN CLIENTE C ON (A.CODC = C.CODC)
GROUP BY P.CODP, P.NOME 
HAVING COUNT(DISTINCT C.CITTA) >= 10
