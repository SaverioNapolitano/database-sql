/*Seconda prova parziale 07-06-2019*/

/*Esercizio 1*/

/*a. Sintassi di interrogazioni innestate

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

*/

/*b. Definizione dell'operatore di divisione nell'algebra relazionale

L'operatore di divisione, dato uno schema di relazione r e un altro schema di relazione s restituisce le tuple di r che partecipano a tutte
le tuple di s.
La definizione matematica dell'operatore è: 
Date due relazioni r e s con schemi R(X) e S(Y) tali che Y ⊂ X, l’operazione di divisione tra r e s , r÷s, ha come risultato una relazione che ha
schema (X − Y) ed è definita da
r÷s={tD |∀tS ∈ s, tDtS ∈r}

L'operatore divisione può essere derivato dagli operatori base.
*/

/*Esercizio 2*/

/*A) 1. Selezionare i clienti di Milano che hanno acquistato prodotti con un prezzo superiore a 100€.*/

SELECT C.*
FROM CLIENTE C 
        JOIN ORDINE O ON (C.IDC = O.IDC) 
        JOIN RIGA_ORDINE R ON (O.CODO = R.CODO)
        JOIN PRODOTTO P ON (R.CODP = P.CODP)
WHERE C.CITTA = 'MI'
AND P.PREZZO > 100
GO 

/*A) 2. Selezionare i prodotti che sono forniti da tutti i fornitori di Modena.*/

SELECT *
FROM PRODOTTO P 
WHERE NOT EXISTS (
    SELECT *
    FROM FORNITORE F
    WHERE F.CITTA = 'MO'
    AND NOT EXISTS (
        SELECT *
        FROM FORNISCE FS 
        WHERE FS.CODP = P.CODP 
        AND FS.NOMEF = F.NOMEF
    )
)

/*A) 3, Selezionare i clienti di Bologna che non hanno mai effettuato ordini da fornitori di Modena.*/

SELECT *
FROM CLIENTE 
WHERE CITTA = 'BO'
EXCEPT 
SELECT C.*
FROM CLIENTE C 
        JOIN ORDINE O ON (C.IDC = O.IDC)
        JOIN FORNITORE F ON (O.NOMEF = F.NOMEF)
WHERE F.CITTA = 'MO'

/*B) 4. Selezionare nome e cognome dei clienti che nel 2018 hanno effettuato almeno 10 ordini.*/

SELECT C.NOME, C.COGNOME 
FROM CLIENTE C 
        JOIN ORDINE O ON (C.IDC = O.IDC)
WHERE YEAR(O.DATA) = 2018 
GROUP BY C.IDC, C.NOME, C.COGNOME 
HAVING COUNT(*) >= 10

/*B) 5. Selezionare nome e cognome del cliente che ha effettuato l’ordine più costoso.*/

SELECT C.NOME, C.COGNOME
FROM CLIENTE C
        JOIN ORDINE O ON (C.IDC = O.IDC)
        JOIN RIGA_ORDINE R ON (O.CODO = R.CODO)
        JOIN PRODOTTO P ON (R.CODP = P.CODP)
GROUP BY C.NOME, C.COGNOME, P.PREZZO, O.CODO 
HAVING SUM(PREZZO*QUANTITA) >= ALL (
    SELECT SUM(PREZZO*QUANTITA)
    FROM RIGA_ORDINE R2
            JOIN PRODOTTO P2 ON (R2.CODP = P2.CODP)
    GROUP BY R2.CODO 
)
GO 

/*B) 6. Creare una vista che mostri per ogni cliente ed ordine, il numero di prodotti distinti che ha acquistato e l’importo complessivo speso.*/

CREATE VIEW QUERY6 AS 
SELECT C.IDC, R.CODO, COUNT(*) AS NPRODOTTI, SUM(P.PREZZO*R.QUANTITA) AS TOTALE
FROM CLIENTE C 
        JOIN ORDINE O ON (C.IDC = O.IDC)
        JOIN RIGA_ORDINE R ON (O.CODO = R.CODO)
        JOIN PRODOTTO P ON (R.CODP = P.CODP)
GROUP BY C.IDC, R.CODO
GO 

/*B) 7. Selezionare i clienti che nel 2018 hanno effettuato ordini da fornitori di Modena per un importo complessivo superiore agli ordini effettuati da fornitori di Modena nel 2017. 
Suggerimento: è possibile aiutarsi con una vista che selezioni per ogni cliente l’importo speso da fornitori di Modena per ogni anno. */

CREATE VIEW IMPORTO_ANNUO_FORNITORI_MODENA AS 
SELECT C.IDC, SUM(PREZZO*QUANTITA) AS IMPORTO, YEAR(O.DATA) AS ANNO  
FROM CLIENTE C 
        JOIN ORDINE O ON (C.IDC = O.IDC)
        JOIN RIGA_ORDINE R ON (O.CODO = R.CODO)
        JOIN PRODOTTO P ON (R.CODP = P.CODP)
        JOIN FORNITORE F ON (O.NOMEF = F.NOMEF)
WHERE F.CITTA = 'MO'
GROUP BY C.IDC, YEAR(O.DATA)
GO 

SELECT C.*
FROM CLIENTE C 
        JOIN IMPORTO_ANNUO_FORNITORI_MODENA I ON (C.IDC = I.IDC)
        JOIN IMPORTO_ANNUO_FORNITORI_MODENA I2 ON (C.IDC = I2.IDC)
WHERE I.ANNO = 2017
AND I2.ANNO = 2018 
AND I2.IMPORTO > I.IMPORTO
