--1. Implementare il vincolo: una traversata non può avere lo stesso porto di arrivo e di partenza.

ALTER TABLE TRAVERSATA
ADD CONSTRAINT CHECK_ARRIVO_PARTENZA_DIVERSI CHECK (PORTOARRIVO <> PORTOPARTENZA)

--2. In tabella BIGLIETTO inserire il vincolo che un passeggero (identificato con nome e cognome) non possa comprare due volte un biglietto per la stessa traversata.

ALTER TABLE BIGLIETTO 
ADD CONSTRAINT UNIQUE_PASSEGGERO_BIGLIETTO UNIQUE(NOME, COGNOME, CODT, DATAORAPARTENZA)

--3. In tabella TRAVERSATA inserire il valore della durata del viaggio (calcolata come differenza tra dataoraarrivo e dataorapartenza).



--4. Selezionare per ciascuna traversata con partenza Olbia i traghetti che hanno ancora posti disponibili e il numero di posti disponibili (calcolato come differenza tra la capienza del traghetto e i biglietti venduti per la specifica traversata). 

SELECT TR.CODT, TR.CAPIENZA, TR.TIPO, TR.CAPIENZA - COUNT(B.CODB) AS POSTI_LIBERI
FROM TRAVERSATA T 
        JOIN TRAGHETTO TR ON (T.CODT = TR.CODT)
        JOIN BIGLIETTO B ON (T.CODT = B.CODT AND T.DATAORAPARTENZA = B.DATAORAPARTENZA)
WHERE T.PORTOPARTENZA = 'OLB'
GROUP BY TR.CODT, T.DATAORAPARTENZA, TR.CAPIENZA, TR.TIPO
HAVING TR.CAPIENZA - COUNT(B.CODB) > 0

--5. Selezionare nome e cognome dei passeggeri che hanno viaggiato su tutti i tipi di traghetti.

SELECT DISTINCT NOME, COGNOME
FROM BIGLIETTO B 
WHERE NOT EXISTS(
    SELECT *
    FROM TRAGHETTO TR 
    WHERE NOT EXISTS(
        SELECT *
        FROM TRAVERSATA T 
                JOIN TRAGHETTO TR1 ON (T.CODT = TR1.CODT)
                JOIN BIGLIETTO B1 ON (B1.CODT = T.CODT AND B1.DATAORAPARTENZA = T.DATAORAPARTENZA) 
        WHERE TR1.TIPO = TR.TIPO
        AND B.NOME = B1.NOME
        AND B.COGNOME = B1.COGNOME
    )
)
GO 

--6. Definire una vista, PROFILO, che riporti per ogni passeggero (identificato da nome e cognome) il numero di porti da cui è partito e il numero di porti che ha raggiunto. 

CREATE VIEW PROFILO AS 
SELECT NOME, COGNOME, COUNT(DISTINCT T.PORTOARRIVO) AS PORTI_RAGGIUNTI, COUNT(DISTINCT T.PORTOPARTENZA) AS PORTI_PARTITI
FROM BIGLIETTO B 
        JOIN TRAVERSATA T ON (B.CODT = T.CODT AND B.DATAORAPARTENZA = T.DATAORAPARTENZA)
GROUP BY NOME, COGNOME
GO 

--7. Modificare la tabella BIGLIETTO in modo che a seguito dell’eliminazione di una traversata, vengano eliminati anche i biglietti relativi.