-- 1. Selezionare gli autori della nazione 'USA' che hanno scritto almeno un articolo per una conferenza tenutasi in 'Italy'


SELECT A.*
FROM Autore A 
        JOIN SCRIVE S ON (A.idautore = S.idautore)
        JOIN Articolo AR ON (S.idarticolo = AR.idarticolo)
        JOIN Conferenza C ON (AR.AnnoConferenza = C.Anno AND AR.TitoloConferenza = C.titolo)
WHERE A.NazioneAutore = 'USA'
AND C.NazioneConferenza = 'Italy'



-- 2. Selezionare gli autori che non hanno articoli in conferenze del 2020, ovvero per i quali non ci sono articoli scritti in conferenze del 2020

SELECT *
FROM AUTORE A 
WHERE A.idautore NOT IN (
    SELECT S.idautore
    FROM Scrive S 
            JOIN Articolo AR ON (S.idarticolo = AR.idarticolo)
    WHERE AR.AnnoConferenza = 2020
)
GO 
-- 3. Creare una vista StessaConferenza2022(Titolo1,Titolo2,NAZIONECONFERENZA,Anno) tale che gli articoli Titolo1 e Titolo2
-- sono stati scritti per una stessa conferenza tenutasi nel 2022

CREATE VIEW ARTICOLI2022 AS 
SELECT A.idarticolo, A.TITOLO, NazioneConferenza, A.AnnoConferenza, A.TitoloConferenza
FROM ARTICOLO A 
        JOIN Conferenza C ON (A.AnnoConferenza = C.Anno AND A.TitoloConferenza = C.titolo)
WHERE A.AnnoConferenza = 2022
GROUP BY A.titolo, C.NazioneConferenza, A.AnnoConferenza, A.idarticolo, A.TitoloConferenza
GO 

CREATE VIEW StessaConferenza2022(Titolo1, Titolo2, NAZIONECONFERENZA, ANNO) AS 
SELECT A1.titolo, A2.titolo, A1.NazioneConferenza, A1.AnnoConferenza
FROM ARTICOLI2022 A1
        JOIN ARTICOLI2022 A2 ON (A1.AnnoConferenza = A2.AnnoConferenza AND A1.TitoloConferenza = A2.TitoloConferenza)
WHERE A1.titolo > A2.titolo
GO 

--SOLUZIONE SENZA VISTA DI SUPPORTO
/*
CREATE VIEW StessaConferenza2022(Titolo1,Titolo2,NAZIONE_CONFERENZA,Anno) AS
SELECT A1.titolo, A2.titolo,C.NazioneConferenza,C.Anno
FROM Articolo A1 
        JOIN Conferenza C ON (C.titolo=A1.TitoloConferenza AND C.Anno=A1.AnnoConferenza)
        JOIN ARTICOLO A2 ON (C.titolo=A2.TitoloConferenza AND C.Anno=A2.AnnoConferenza)
WHERE C.Anno=2022
AND A1.titolo > A2.titolo
GO
*/

-- 4. Selezionare gli autori che per l'anno 2022 (anno della conferenza) hanno scritto più articoli che per l'anno 2020

SELECT A.*
FROM AUTORE A 
        JOIN SCRIVE S ON (A.idautore = S.idautore)
        JOIN ARTICOLO AR ON (S.idarticolo = AR.idarticolo)
WHERE AR.AnnoConferenza = 2022
GROUP BY A.idautore, A.afferenza, A.cognome, A.NazioneAutore, A.nome
HAVING COUNT(*) > ALL(
        SELECT COUNT(*)
        FROM SCRIVE S1
                JOIN ARTICOLO AR1 ON (S1.idarticolo = AR1.idarticolo)
        WHERE AR1.AnnoConferenza = 2020
        AND S1.idautore = A.idautore
)
GO 

-- 5. Scrivere una vista ScriveDaSolo che individua le coppie idautore, idarticolo tali che idautore è l'unico autore di idarticolo
-- Quindi usare tale vista per individuare gli autori che hanno scritto da soli almeno un articolo per tutte le conferenze tenutesi in Italy

CREATE VIEW ScriveDaSolo AS 
SELECT A.idautore, AR.idarticolo
FROM AUTORE A 
        JOIN SCRIVE S ON (A.idautore = S.idautore)
        JOIN ARTICOLO AR ON (S.idarticolo = AR.idarticolo)
WHERE A.idautore = ALL(
        SELECT A2.idautore
        FROM AUTORE A2 
                JOIN SCRIVE S2 ON (A2.idautore = S2.idautore)
        WHERE S2.idarticolo = AR.idarticolo 
)
GO 

--SOLUZIONE PIU INTELLIGENTE 
/*
CREATE VIEW ScriveDaSolo AS
SELECT idautore, idarticolo
FROM SCRIVE S
WHERE NOT EXISTS (
        SELECT *
	FROM SCRIVE S1
	WHERE S1.idarticolo=S.idarticolo
	AND S1.idautore<>S.idautore
)
*/

SELECT *
FROM ScriveDaSolo SDS  
WHERE NOT EXISTS(
        SELECT *
        FROM Conferenza C 
        WHERE C.NazioneConferenza = 'Italy'
        AND NOT EXISTS(
                SELECT *
                FROM ARTICOLO AR 
                WHERE AR.idarticolo = SDS.idarticolo
                AND AR.AnnoConferenza = C.Anno
                AND AR.TitoloConferenza = C.titolo
        )
)
