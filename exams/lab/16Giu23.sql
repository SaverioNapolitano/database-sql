--2. Selezionare gli studenti (tutti gli attributi) che hanno sostenuto almeno un appello  di un insegnamento del 'Secondo' anno di corso

SELECT S.*
FROM STUDENTE S 
        JOIN SOSTIENE SO ON (S.MATRICOLA = SO.MATRICOLA)
        JOIN APPELLO A ON (SO.ID_APPELLO = A.ID_APPELLO)
        JOIN INSEGNAMENTO I ON (A.CDL_INSEGNAMENTO = I.CDL AND A.NOME_INSEGNAMENTO = I.NOME_INSEGNAMENTO)
WHERE I.ANNO_CORSO = 'SECONDO'

--3. Selezionare i DOCENTI  degli appelli della SESSIONE  'Invernale2010' in cui non c'era nessuno studente della nazione 'USA'

SELECT DISTINCT I.DOCENTE 
FROM INSEGNAMENTO I 
        JOIN APPELLO A ON (I.CDL = A.CDL_INSEGNAMENTO AND I.NOME_INSEGNAMENTO = A.NOME_INSEGNAMENTO)
WHERE ID_APPELLO NOT IN (
    SELECT ID_APPELLO
    FROM SOSTIENE SO 
            JOIN STUDENTE S ON (SO.MATRICOLA = S.MATRICOLA)
    WHERE S.NAZIONESTUDENTE = 'USA'
) 
AND A.SESSIONE = 'INVERNALE2010'
GO 


--4. Creare una vista StessoInsegnamentoSessione(ID_APPELLO1,ID_APPELLO2)
--tale ID_APPELLO1 E ID_APPELLO2 sono appelli della stessa sessione 
--e relativi ad uno stesso  stesso insegnamento tenuto dal docente 'Chiari'

CREATE VIEW STESSOINSEGNAMENTOSESSIONE(ID_APPELLO1, ID_APPELLO2) AS 
SELECT A.ID_APPELLO, A1.ID_APPELLO
FROM APPELLO A 
        JOIN INSEGNAMENTO I ON (A.CDL_INSEGNAMENTO = I.CDL AND A.NOME_INSEGNAMENTO = I.NOME_INSEGNAMENTO)
        JOIN APPELLO A1 ON (A1.CDL_INSEGNAMENTO = I.CDL AND A1.NOME_INSEGNAMENTO = I.NOME_INSEGNAMENTO)
WHERE I.DOCENTE = 'CHIARI'
AND A.ID_APPELLO > A1.ID_APPELLO
AND A.SESSIONE = A1.SESSIONE
GO 

SELECT * FROM APPELLO A WHERE A.ID_APPELLO = 130 OR A.ID_APPELLO = 110

SELECT * FROM INSEGNAMENTO

--5. Selezionare gli studenti (tutti gli attributi) che per la sessione Invernale2010 hanno sostenuto più appelli che per la sessione Estiva2010
SELECT S.*
FROM STUDENTE S 
        JOIN SOSTIENE SO ON (S.MATRICOLA = SO.MATRICOLA)
        JOIN APPELLO A ON (A.ID_APPELLO = SO.ID_APPELLO)
WHERE A.SESSIONE = 'INVERNALE2010'
GROUP BY S.MATRICOLA, S.COGNOME, S.NOME, S.NAZIONESTUDENTE
HAVING COUNT(*) > (
    SELECT COUNT(*)
    FROM SOSTIENE SO1 
            JOIN APPELLO A1 ON (SO1.ID_APPELLO = A1.ID_APPELLO)
    WHERE SO1.MATRICOLA = S.MATRICOLA
    AND A1.SESSIONE = 'ESTIVA2010'
)
GO 

--6. Scrivere una vista SostieneDaSolo che individua le coppie ID_APPELLO, MATRICOLA    tali che MATRICOLA è l'unico studente di ID_APPELLO

--Quindi usare tale vista per individuare gli studenti (tutti gli attributi) che hanno sostenuto da soli  almeno un appello  per tutti gli insegnamenti del Secondo anno di corso

CREATE VIEW SOSTIENEDASOLO AS 
SELECT *
FROM SOSTIENE S 
WHERE NOT EXISTS(
    SELECT * 
    FROM SOSTIENE S1 
    WHERE S1.ID_APPELLO = S.ID_APPELLO
    AND S1.MATRICOLA <> S.MATRICOLA
)
GO 

SELECT *
FROM STUDENTE S 
WHERE NOT EXISTS(
    SELECT *
    FROM INSEGNAMENTO I 
    WHERE I.ANNO_CORSO = 'SECONDO'
    AND NOT EXISTS(
        SELECT *
        FROM SOSTIENEDASOLO SO 
                JOIN APPELLO A ON (SO.ID_APPELLO = A.ID_APPELLO)
        WHERE SO.MATRICOLA = S.MATRICOLA
        AND A.CDL_INSEGNAMENTO = I.CDL
        AND A.NOME_INSEGNAMENTO = I.NOME_INSEGNAMENTO
    )
)