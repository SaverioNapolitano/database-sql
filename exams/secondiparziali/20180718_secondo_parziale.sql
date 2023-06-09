/*Seconda prova parziale 18-07-2018*/

/*Esercizio 1*/

/*a. Definizione dell'istruzione GROUP BY in SQL*/

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
- Funzioni aggregate ]

Se si ha poco tempo al posto di [] -> Specificando dopo la clausola GROUP BY HAVING si possono selezionare tra tutti i gruppi quelli che rispettano una condizione specificata
*/

/*b. Definizione di terza forma normale.*/

/* 
Informalmente, la 3NF serve per evitare problemi derivanti da attributi non superchiave che determinano funzionalmente altri attributi non primi.
La definizione è la seguente: 
Uno schema ⟨R(T),F⟩ è in 3NF se e solo se per ogni dipendenza funzionale non banale X → A ∈ F, o X è una superchiave oppure A è primo.

Teorema: Uno schema ⟨R(T),F⟩ che è in 3NF è anche in 2NF.
*/


/*Esercizio 3*/

/* A) 1. Selezionare i dati delle squadre che sono composte da ciclisti italiani o spagnoli*/

SELECT S.*
FROM SQUADRA S 
        JOIN COMPONE C ON (S.CODS = C.CODS)
        JOIN CICLISTA CL ON (C.CODC = CL.CODC)
WHERE CL.NAZIONE = 'IT'
OR CL.NAZIONE = 'ES'



/* A) 2. SELEZIONARE I DATI DELLE GARE DEL 2010 A CUI NON HANNO PARTECIPATO SQUADRE DI NAZIONALITà ITALIANA */

SELECT *
FROM GARA 
WHERE YEAR(DATA) = 2010
EXCEPT 
SELECT G.*
FROM GARA G
        JOIN CLASSIFICA C ON (G.NOMEG = C.NOMEG)
        JOIN COMPONE CO ON (C.CODC = CO.CODC)
        JOIN SQUADRA S ON (CO.CODS = S.CODS)
WHERE NAZIONALITA = 'ITALIANA' 

/*A) 3. SELEZIONARE I DATI DELLE SQUADRE A CUI HANNO PARTECIPATO TUTTE LE SQUADRE */

SELECT *
FROM GARA G
WHERE NOT EXISTS ( --NEL PRIMO NOT EXISTS CI VA IL DIVISORE
    SELECT *
    FROM SQUADRA S
    WHERE NOT EXISTS ( --NEL SECONDO NOT EXISTS CI VA IL DIVIDENDO
        SELECT *
        FROM CLASSIFICA C 
                JOIN COMPONE CO ON (C.CODC = CO.CODC)
        WHERE CO.CODS = S.CODS --NELLA CONDIZIONE VANNO MESSE LE CORRELAZIONI CON ENTRAMBE LE QUERY ESTERNE
        AND G.NOMEG = C.NOMEG
    ) )

/*B) 4. SELEZIONARE I DATI DEI CICLISTI CHE HANNO PARTECIPATO AD ALMENO 5 GARE CHE SONO PARTIRE DA MILANO NEL 2010*/

SELECT C.CODC, C.NOME, C.COGNOME, C.NAZIONE --NON SI PUO USARE C.*
FROM CICLISTA C 
        JOIN CLASSIFICA CL ON (C.CODC = CL.CODC)
        JOIN GARA G ON (CL.NOMEG = G.NOMEG)
WHERE PARTENZA = 'MILANO' AND YEAR(DATA) = 2010 --NON SI POTEVA METTERE PER QUESTA QUERY COUNT(*) NELLA WHERE PERCHé ALTRIMENTI CONTAVA 
--TUTTE LE GARE PARTITE DA MILANO NEL 2010 DI TUTTI I CICLISTI (NOI VOGLIAMO PER OGNI CICLISTA)
GROUP BY C.CODC, C.NOME, C.COGNOME, C.NAZIONE  --NON SI PUO USARE C.*
HAVING COUNT(*) >= 5
GO 
--IN ALTERNATIVA, DETTA QUELLA SOPRA QUERY4 (CREATE VIEW) E CAMBIANDO LA SELECT IN C.CODC E BASTA

/*
SELECT *
FROM CICLISTA
WHERE CODC IN QUERY4
*/


/*SELEZIONARE I DATI DEL CICLISTA CHE NELLE GARE DEL 2011 SI E RITIRATO PIU VOLTE */

CREATE VIEW QUERY5 AS
SELECT CODC, COUNT(*) AS NRITIRI --LE FUNZIONI AGGREGATE NON SI CONTANO NELL'INSIEME DEL GROUP BY
FROM CLASSIFICA C
        JOIN GARA G ON (C.NOMEG = G.NOMEG)
WHERE POSIZIONE = 'R' AND YEAR(DATA) = 2011
GROUP BY CODC --NEL GROUP BY NON CI VANNO FUNZIONI AGGREGATE 
GO

SELECT C.*
FROM CICLISTA C
        JOIN QUERY5 ON (QUERY5.CODC = C.CODC)
WHERE NRITIRI = MAX(NRITIRI)
GO 

/*B) 6. CREARE UNA VISTA CHE MOSTRI PER OGNI GARA LA SQUADRA CHE HA AVUTO LA MIGLIOR PERFORMANCE (MINOR SOMMA DEI TEMPI REALIZZATI DAI SUOI
CICLISTI CHE HANNO COMPLETATO LA GARA, OSSIA ESCLUDENDO I CICLISTI RITIRATI)*/

CREATE VIEW QUERY6 AS 
SELECT S.CODS, CL.NOMEG
FROM COMPONE CO
        JOIN SQUADRA S ON (CO.CODS = S.CODS) --ARRIVO ALLA SQUADRA
        JOIN CLASSIFICA CL ON (CL.CODC = CO.CODC) --E ALLA CLASSIFICA
WHERE CL.POSIZIONE <> 'R' --CONSIDERO SOLO I CICLISTI NON RITIRATI
GROUP BY S.CODS, CL.NOMEG --RAGGRUPPO PER SQUADRA E GARA 
HAVING SUM(CL.TEMPO) <= ALL( --DEVO FARE SUBQUERY CORRELATA PERCHE NON POSSO FARE MIN(SUM) SICCOME LE FUNZIONI AGGREGATE NON POSSONO CONTENERE ALTRE FUNZIONI AGGREGATE
    SELECT  SUM(CL2.TEMPO) 
    FROM COMPONE CO2
        JOIN SQUADRA S2 ON (CO2.CODS = S2.CODS) --ARRIVO ALLA SQUADRA
        JOIN CLASSIFICA CL2 ON (CL2.CODC = CO2.CODC) --E ALLA CLASSIFICA
    WHERE CL2.POSIZIONE <> 'R' --CONSIDERO SOLO I CICLISTI NON RITIRATI
    AND CL2.NOMEG = CL.NOMEG --CORRELAZIONE CON LA QUERY ESTERNA (DEVE ESSERE LA STESSA GARA)
    GROUP BY S2.CODS --COSI HO LA LISTA DEI TEMPI FATTI DA TUTTE LE SQUADRE NELLA STESSA GARA DI QUELLA NELLA QUERY ESTERNA
)
GO 

/*B) 7. SELEZIONARE I DATI DEI CICLISTI CHE NEL 2017 HANNO OTTENUTO PIU PODI (POSIZIONE <= 3) RISPETTO AL 2016*/

CREATE VIEW PODI2017 AS 
SELECT CODC, COUNT(*) AS NPODI
FROM CLASSIFICA C 
        JOIN GARA G ON (C.NOMEG = G.NOMEG)
WHERE YEAR(DATA) = 2017 AND POSIZIONE <= 3
GROUP BY CODC --VOGLIO IL NUMERO DI PODI PER OGNI CICLISTA
GO 

CREATE VIEW PODI2016 AS 
SELECT CODC, COUNT(*) AS NPODI
FROM CLASSIFICA C 
        JOIN GARA G ON (C.NOMEG = G.NOMEG)
WHERE YEAR(DATA) = 2016 AND POSIZIONE <= 3
GROUP BY CODC 
GO 

SELECT C.*
FROM CICLISTA C
        JOIN PODI2017 P17 ON (C.CODC = P17.CODC)
        JOIN PODI2016 P16 ON (C.CODC = P16.CODC)
WHERE P17.NPODI > P16.NPODI






