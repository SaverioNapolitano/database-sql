--1. Seleziona tutti i viaggi svolti da 'Amedeo Barbieri'

SELECT V.*
FROM VIAGGIO V 
        JOIN AUTOMOBILISTA A ON (V.AUTOMOBILISTA = A.COD_F)
WHERE NOME = 'Amedeo'
AND COGNOME = 'Barbieri'

--2. Seleziona le tratte sulle quali non ha mai viaggiato un automobilista di sesso maschile

SELECT *
FROM TRATTA T 
WHERE T.COD_T NOT IN (
    SELECT V.TRATTA
    FROM VIAGGIO V 
            JOIN AUTOMOBILISTA A ON (V.AUTOMOBILISTA = A.COD_F)
    WHERE SESSO = 'M'
)

--3. Selezionare, per ogni compagnia autostradale, il codice, il nome e l'incasso complessivo

SELECT S.COD_S, S.NOME, SUM(PEDAGGIO) AS INCASSO
FROM SOCIETA S 
        JOIN TRATTA T ON (S.COD_S = T.SOC_COMPETENZA)
        JOIN VIAGGIO V ON (T.COD_T = V.TRATTA)
GROUP BY S.COD_S, S.NOME

--4. Trova per ogni automobilistà qual'è la società autostradale di cui ha percorso più tratte nei suoi viaggi

SELECT V.AUTOMOBILISTA, T.SOC_COMPETENZA
FROM VIAGGIO V
        JOIN TRATTA T ON (V.TRATTA = T.COD_T)
GROUP BY V.AUTOMOBILISTA, T.SOC_COMPETENZA
HAVING COUNT(*) >= ALL (
    SELECT COUNT(*) 
    FROM VIAGGIO V1 
            JOIN TRATTA T1 ON (V1.TRATTA = T1.COD_T)
    WHERE V1.AUTOMOBILISTA = V.AUTOMOBILISTA
    GROUP BY T1.SOC_COMPETENZA
)

--5. Seleziona gli automobilisti che hanno percorso almeno una tratta di ogni società autostradale 
-- (Suggerimento: si vogliono gli utenti che siano in relazione con tutte le società)

SELECT *
FROM AUTOMOBILISTA A 
WHERE NOT EXISTS (
    SELECT *
    FROM SOCIETA S 
    WHERE NOT EXISTS(
        SELECT *
        FROM TRATTA T 
                JOIN VIAGGIO V ON (T.COD_T = V.TRATTA)
        WHERE T.SOC_COMPETENZA = S.COD_S
        AND V.AUTOMOBILISTA = A.COD_F
    )
)
