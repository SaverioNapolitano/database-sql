--1. Implementare il vincolo: un volo non può avere lo stesso aeroporto di arrivo e di partenza.

ALTER TABLE VOLO 
ADD CONSTRAINT CHECK_AEROPORTO CHECK(AEROPORTOPARTENZA <> AEROPORTOARRIVO)

--2. In tabella BIGLIETTO inserire il vincolo che un passeggero (identificato con nome e cognome) non possa comprare due volte lo stesso volo.

ALTER TABLE BIGLIETTO 
ADD CONSTRAINT UNIQUE_PASSEGGERO_BIGLIETTO UNIQUE(NOME, COGNOME, CODV, DATAORA)

--3. Inserire nel database i seguenti dati:
--Il volo AF0303 del 25/07/2018 con partenza Parigi CDG e arrivo a Bologna BLQ è stato acquistato dai seguenti passeggeri: Robert Plant, Freddie Mercury, Paul Rodgers, Chef Ragoo.



--4. Selezionare i voli per i quali c’è stato overbooking (cioè sono stati venduti più biglietti della capienza del volo). 

SELECT V.*, COUNT(*) AS BIGLIETTI_VENDUTI
FROM BIGLIETTO B 
        JOIN VOLO V ON (B.CODV = V.CODV AND B.DATAORA = V.DATAORA)
GROUP BY V.CODV, V.DATAORA, V.CAPIENZA, V.GATE, V.AEROPORTOARRIVO, V.AEROPORTOPARTENZA
HAVING COUNT(*) > V.CAPIENZA

--5. Selezionare nome e cognome dei passeggeri che hanno volato da tutti gli aeroporti di Roma.

SELECT DISTINCT NOME, COGNOME 
FROM BIGLIETTO B 
WHERE NOT EXISTS(
    SELECT *
    FROM AEROPORTO A 
    WHERE CITTA = 'Roma'
    AND NOT EXISTS(
        SELECT *
        FROM VOLO V 
                JOIN BIGLIETTO B1 ON (V.CODV = B1.CODV AND V.DATAORA = B1.DATAORA)
        WHERE B1.NOME = B.NOME
        AND B1.COGNOME = B.COGNOME
        AND V.AEROPORTOPARTENZA = A.CODA
    )
)
GO 

--6. Definire una vista, PROFILO, che riporti per ogni passeggero (identificato da nome e cognome) il numero di città distinte da cui è partito e il numero di città distinte in cui è atterrato.

CREATE VIEW PROFILO AS 
SELECT NOME, COGNOME, COUNT(DISTINCT A.CITTA) AS NCITTA_PARTENZA, COUNT(DISTINCT A2.CITTA) AS NCITTA_ARRIVO
FROM BIGLIETTO B 
        JOIN VOLO V ON (B.CODV = V.CODV AND B.DATAORA = V.DATAORA)
        JOIN AEROPORTO A ON (V.AEROPORTOPARTENZA = A.CODA)
        JOIN AEROPORTO A2 ON (V.AEROPORTOARRIVO = A2.CODA)
GROUP BY NOME, COGNOME 

--7. Modificare la tabella VOLO in modo che a seguito dell’eliminazione di un volo, vengano eliminati anche i biglietti relativi.

