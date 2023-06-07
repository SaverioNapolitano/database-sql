/*Prova totale 11-06-2018*/

/*Esercizio 1*/

/*a. Definizione di terza forma normale ed esempi di violazione*/

/*
Terza forma normale: uno schema (R(T),F) è in terza forma normale se e solo se per ogni dipendenza funzionale non banale X -> A Є F, o X è una superchiave oppure A è primo.

Qualunque schema di relazione può essere decomposto preservando dati e dipendenze in un insieme di schemi di relazione in terza forma normale.

Una relazione che non è nella forma normale desiderata viene decomposto in sottoschemi allo scopo di raggiungere tale forma normale, tramite un procedimento chiamato appunto normalizzazione.
*/

/*Esercizio 4*/

/*a) Selezionare i nomi delle stazioni da cui nel 2010 sono partiti tutti i modelli di treni presenti.*/

SELECT S.NOME 
FROM STAZIONE S 
WHERE NOT EXISTS(
    SELECT *
    FROM TRENO T 
    WHERE NOT EXISTS(
        SELECT *
        FROM TRATTA TT 
        WHERE TT.PARTENZA = S.COD_STAZIONE
        AND YEAR(TT.DATA_PARTENZA) = 2010
        AND TT.ID_TRENO = T.ID_TRENO 
    )
)

/*b) Selezionare i dati dei treni che sono passati per la città di Modena (partenza o arrivo) nel mese di gennaio del 2012. */

SELECT T.*
FROM TRENO T 
        JOIN TRATTA TT ON (T.ID_TRENO = TT.ID_TRENO)
        JOIN STAZIONE S ON (TT.PARTENZA = S.COD_STAZIONE)
WHERE YEAR(DATA_PARTENZA) = 2012
AND MONTH(DATA_PARTENZA) = 1
UNION 
SELECT T1.*
FROM TRENO T1 
        JOIN TRATTA TT1 ON (T1.ID_TRENO = TT1.ID_TRENO)
        JOIN STAZIONE S1 ON (TT1.ARRIVO = S1.COD_STAZIONE)
WHERE YEAR(DATA_PARTENZA) = 2012
AND MONTH(DATA_PARTENZA) = 1

/*c) Selezionare i dati dei treni che nel 2016 hanno effettuato più ore di lavoro (somma delle durate delle tratte).*/

SELECT T.ID_TRENO, T.MODELLO, T.ANNO, T.NUM_POSTI, SUM(TT.DURATA) AS TOTALE
FROM TRENO T 
        JOIN TRATTA TT ON (T.ID_TRENO = TT.ID_TRENO)
WHERE YEAR(TT.DATA_PARTENZA) = 2016
GROUP BY T.ID_TRENO, T.MODELLO, T.ANNO, T.NUM_POSTI, TT.DURATA 
HAVING SUM(TT.DURATA) >= ALL(
    SELECT SUM(DURATA)
    FROM TRATTA TT2 
    WHERE YEAR(DATA_PARTENZA) = 2016
    GROUP BY TT.ID_TRENO
)