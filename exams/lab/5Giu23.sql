--1. Seleziona i viaggi svolti da 'Amedeo Barbieri' oppure con una tratta che parte da 'Roma' di competenza della società con nome 'Anas S.p.A' 

SELECT V.*
FROM VIAGGIO V 
        JOIN AUTOMOBILISTA A ON (V.AUTOMOBILISTA = A.COD_F)
WHERE A.NOME = 'Amedeo'
AND A.COGNOME = 'Barbieri'
UNION 
SELECT V.*
FROM VIAGGIO V 
        JOIN TRATTA T ON (V.TRATTA = T.COD_T)
        JOIN SOCIETA S ON (T.SOC_COMPETENZA = S.COD_S)
WHERE T.CITTA_PARTENZA = 'Roma'
AND S.NOME = 'Anas S.p.A'

--2. Seleziona le tratte sulle quali non ha mai viaggiato un automobilista di sesso maschile

SELECT T.*
FROM TRATTA T 
WHERE T.COD_T NOT IN (
    SELECT T1.COD_T
    FROM VIAGGIO V1 
            JOIN TRATTA T1 ON (V1.TRATTA = T1.COD_T)
            JOIN AUTOMOBILISTA A1 ON (V1.AUTOMOBILISTA = A1.COD_F)
    WHERE A1.SESSO = 'M'
)
GO 

--3. Selezionare, per ogni compagnia autostradale, il codice, il nome e l'incasso complessivo 
--(inteso come somma dei pedaggi di tutte le tratte di sua competenza per tutti i viaggi effettuati),
--limitatamente ai viaggi fatti da automobilisti con almeno due viaggi

CREATE VIEW AUTOMOBILISTI_CON_ALMENO_2_VIAGGI AS 
SELECT A.COD_F
FROM AUTOMOBILISTA A 
        JOIN VIAGGIO V ON (A.COD_F = V.AUTOMOBILISTA)
GROUP BY A.COD_F
HAVING COUNT(*) >= 2
GO 

SELECT S.COD_S, S.NOME, SUM(PEDAGGIO) AS INCASSO
FROM SOCIETA S 
        JOIN TRATTA T ON (S.COD_S = T.SOC_COMPETENZA)
        JOIN VIAGGIO V ON (T.COD_T = V.TRATTA)
        JOIN AUTOMOBILISTI_CON_ALMENO_2_VIAGGI A ON (V.AUTOMOBILISTA = A.COD_F)
GROUP BY S.COD_S, S.NOME

--4. Trova per ogni automobilistà qual'è la società autostradale di cui ha percorso più tratte nei suoi viaggi

SELECT V.AUTOMOBILISTA, T.SOC_COMPETENZA
FROM VIAGGIO V
        JOIN TRATTA T ON (V.TRATTA = T.COD_T)
GROUP BY V.AUTOMOBILISTA, T.SOC_COMPETENZA
HAVING COUNT(*) >= ALL(
    SELECT COUNT(*)
    FROM VIAGGIO V2 
            JOIN TRATTA T2 ON (V2.TRATTA = T2.COD_T)
    WHERE V2.AUTOMOBILISTA = V.AUTOMOBILISTA
    GROUP BY T2.SOC_COMPETENZA
)

--5. Seleziona gli automobilisti che hanno percorso almeno una tratta di ogni società autostradale 
--(Suggerimento: si vogliono gli utenti che siano in relazione con tutte le società)

SELECT *
FROM AUTOMOBILISTA A 
WHERE NOT EXISTS(
    SELECT *
    FROM SOCIETA S 
    WHERE NOT EXISTS(
        SELECT *
        FROM VIAGGIO V 
                JOIN TRATTA T ON (V.TRATTA = T.COD_T)
        WHERE V.AUTOMOBILISTA = A.COD_F
        AND T.SOC_COMPETENZA = S.COD_S
    )
)