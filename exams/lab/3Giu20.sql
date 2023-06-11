--1. Inserire 30 euro come valore di default per l’attributo costo_mensile in tabella Abbonamento.

ALTER TABLE ABBONAMENTO
ADD DEFAULT 30 FOR COSTO_MENSILE

--2. Modificare la tabella smartphone, aggiungendo l'attributo "anno_rilascio" 

ALTER TABLE SMARTPHONE
ADD ANNO_RILASCIO INT 

--3. Modificare la tabella acquisto, aggiungendo il vincolo che un cliente non possa comprare due volte lo stesso tablet

ALTER TABLE ACQUISTO 
ADD CONSTRAINT UNIQUE_SMARTPHONE UNIQUE(CODCL, CODTAB)

--4. Selezionare il nome dei clienti che hanno sottoscritto un abbonamento che include 3 GB di traffico internet per un tablet di tipo “Surface” (qualsiasi modello Surface).

SELECT C.NOME, T.TIPO
FROM CLIENTE C 
        JOIN ABBONAMENTO A ON (C.CODCL = A.CODCL)
        JOIN TABLET T ON (A.CODTAB = T.CODTAB)
WHERE A.TRAFFICO_INTERNET = 3
AND T.TIPO LIKE '%Surface%'
GO 

--5. Riportare il totale speso dal cliente 'Gianni Nibali' per tutti i prodotti da lui acquistati. 

CREATE VIEW SOMMA_PREZZI_SMARTPHONE AS 
SELECT SUM(PREZZO) AS TOT_SMARTPHONE, C.CODCL
FROM CLIENTE C 
        JOIN ACQUISTO A ON (C.CODCL = A.CODCL)
        JOIN SMARTPHONE S ON (A.CODSMART = S.CODSMART)
GROUP BY C.CODCL, C.NOME
HAVING C.NOME = 'Gianni Nibali'
GO 

CREATE VIEW SOMMA_PREZZI_TABLET AS 
SELECT SUM(PREZZO) AS TOT_TABLET, C.CODCL
FROM CLIENTE C 
        JOIN ACQUISTO A ON (C.CODCL = A.CODCL)
        JOIN TABLET T ON (A.CODTAB = T.CODTAB)
GROUP BY C.CODCL, C.NOME
HAVING C.NOME = 'Gianni Nibali'
GO 


SELECT SUM(SPS.TOT_SMARTPHONE + SPT.TOT_TABLET) AS TOTALE
FROM CLIENTE C 
        JOIN SOMMA_PREZZI_SMARTPHONE SPS ON (C.CODCL = SPS.CODCL)
        JOIN SOMMA_PREZZI_TABLET SPT ON (C.CODCL = SPT.CODCL)
WHERE C.NOME = 'Gianni Nibali'

--6. Selezionare per ogni marca di tablet, il numero e il prezzo medio degli tablet acquistati nel 2020, includere nel risultato anche le marche per le quali non sono stati acquistati tablet in tale anno. 
--Ordinare il risultato per il prezzo medio degli tablet in senso descrescente.

SELECT T.MARCA, COUNT(*) AS NUMERO, AVG(PREZZO) AS MEDIA
FROM TABLET T 
        LEFT JOIN ACQUISTO A ON (T.CODTAB = A.CODTAB)
WHERE YEAR(A.[DATA]) = 2020
GROUP BY T.MARCA
ORDER BY 3 DESC 