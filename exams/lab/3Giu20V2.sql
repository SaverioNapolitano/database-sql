--1. Inserire 30 euro come valore di default per l’attributo costo_mensile in tabella Abbonamento.
ALTER TABLE Abbonamento
ADD DEFAULT 30 FOR costo_mensile

--2. Modificare la tabella acquisto, aggiungendo l'attributo "data_vendita" di tipo data
ALTER TABLE acquisto 
ADD DATA_VENDITA DATE 

--3. Modificare la tabella acquisto, aggiungendo il vincolo che l'attributo codsmart faccia riferimento al codice di uno smartphone esistente 

ALTER TABLE acquisto
ADD CONSTRAINT FK_SMARTPHONE FOREIGN KEY (codsmart) REFERENCES smartphone

--4. Selezionare il nome dei clienti che hanno sottoscritto un abbonamento che include almeno 1 GB di traffico internet per un telefono di marca “Samsung” 

SELECT C.NOME
FROM CLIENTE C 
        JOIN ABBONAMENTO A ON (C.CODCL = A.CODCL)
        JOIN SMARTPHONE S ON (A.CODSMART = S.CODSMART)
WHERE A.TRAFFICO_INTERNET >= 1
AND S.MARCA = 'SAMSUNG'

--5. Riportare il totale pagato al mese dal cliente 'Gianni Nibali' per tutti i suoi abbonamenti sottoscritti.

SELECT ISNULL(SUM(A.COSTO_MENSILE),0)
FROM CLIENTE C 
        JOIN ABBONAMENTO A ON (A.CODCL = C.CODCL)
WHERE C.NOME = 'GIANNI NIBALI'

--6. Selezionare per ogni marca di smartphone, il numero e il prezzo medio degli smartphone acquistati nel 2020, includere nel risultato anche le marche per le quali non sono stati acquistati smartphone in tale anno. 
--Ordinare il risultato per numero di smartphone acquistati in senso descrescente.

SELECT S.MARCA, COUNT(*) AS NUMERO, ISNULL(AVG(S.PREZZO),0) AS MEDIA
FROM SMARTPHONE S 
        LEFT JOIN ACQUISTO A ON (S.CODSMART = A.CODSMART)
WHERE YEAR(A.[DATA]) = 2020
GROUP BY ALL S.MARCA
ORDER BY 2 DESC 