--1. Selezionare tutti i dati dei mutui gestiti dall'intermediario SARA BIGI, 
--riportare i dati sia dei finanziamenti attivati che dei finanziamento negati

SELECT M.*
FROM MUTUO M 
        JOIN PERSONA P ON (M.intermediario = P.id)
WHERE NOME = 'SARA BIGI'
AND (STATO = 1 OR STATO = 2)

--2. Per ogni mutuo finanziato, selezionare la somma totale pagata dal richiedente. 
--Riportare anche i dati del mutuo ovvero: richiedente1, dataRichiesta, somma.

SELECT SUM(PR.sommapagata) AS TOTALE, M.richiedente1, M.dataRichiesta, M.somma
FROM MUTUO M 
        JOIN PagamentoRata PR ON (M.richiedente1 = PR.richiedente1 AND M.dataRichiesta = PR.dataRichiesta)
WHERE STATO = 1
group by M.richiedente1, M.dataRichiesta, somma

--3. Selezionare per ogni intermediario il suo nome e il numero di mutui negato, 
-- riportando in ordine descrescente dall'intermediario che ha negato più mutui a quello che non ne ha mai negati.

SELECT P.ID, P.NOME, COUNT(*) AS MUTUINEGATI
FROM MUTUO M 
        JOIN Persona P ON (M.intermediario = P.id)
WHERE M.stato = 2
GROUP BY P.ID, P.NOME
ORDER BY 3 DESC 


--4. Selezionare i dati dei clienti richiedenti che non hanno mai ottenuto un finanziamento di un mutuo (come richiedente1): 
--possono essere sia richiedenti che non hanno mai fatto alcuna richiesta di mutuo oppure richiedenti che hanno fatto richieste, 
--ma non ne hanno mai avuta una il cui finanziamento sia stato attivato

SELECT P.*
FROM PERSONA P 
WHERE P.id NOT IN (
    SELECT richiedente1
    FROM MUTUO M 
    WHERE M.stato = 1
) AND P.tipo = 'richiedente'

--5. Selezionare i mutui il cui finanziamento risulta una richiesta in corso, riportarne la data di richiesta e l'importo 
--e il numero di giorni dalla data di richiesta ad oggi.

SELECT dataRichiesta, somma
FROM MUTUO M 
WHERE STATO = 0

--MANCA NUMERO GIORNI DALLA DATA DI RICHIESTA AD OGGI
