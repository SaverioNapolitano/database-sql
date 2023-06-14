--1. Selezionare tutti i dati dei mutui richiesti da ENRICO VACONDIO come richiedente1, riportare solo i dati dei finanziamenti attivati

SELECT M.*
FROM MUTUO M 
        JOIN PERSONA P ON (M.richiedente1 = P.id)
WHERE P.nome = 'ENRICO VACONDIO'
AND M.stato = 1

--2. Per ogni mutuo finanziato, selezionare tutti i dati e la somma totale da restituire (ovvero somma più interessi calcolati in base all'interese percentuale).

SELECT M.*, M.SOMMA + M.SOMMA*M.interessePercentuale AS TOTALE
FROM MUTUO M 
WHERE M.stato = 1
GO 

--3. Selezionare per ogni intermediario il suo nome e il numero di mutui finanziati, riportando in ordine descrescente dall'intermediario che ha finanziato più mutui a quello che non ne ha mai finanziati.

SELECT P.NOME, COUNT(dataInizioMutuo) AS MUTUI_FINANZIATI
FROM MUTUO M 
        RIGHT JOIN PERSONA P ON (M.intermediario = P.ID)
WHERE (M.stato = 1 OR M.stato IS NULL)
AND p.tipo = 'intermediario'
GROUP BY P.id, P.nome 
ORDER BY 2 DESC 

/*SOLUZIONE IN CUI NON VENGONO RIPORTATE LE TUPLE DANGLING (MANCANO GLI INTERMEDIARI CHE NON HANNO MAI FINANZIATO MUTUI)
SELECT P.NOME, COUNT(*) AS MUTUI_FINANZIATI
FROM MUTUO M 
        JOIN PERSONA P ON (M.intermediario = P.ID)
WHERE M.stato = 1
GROUP BY P.id, P.nome 
ORDER BY 2 DESC 
*/

--4. Selezionare i dati dei clienti richiedenti che non hanno mai avuto un mutuo negato (come richiedente1): possono essere sia richiedenti che non hanno mai fatto alcuna richiesta di mutuo oppure richiedenti che hanno fatto richieste, ma non ne hanno mai avuta una il cui finanziamento sia stato negato

SELECT *
FROM PERSONA P 
WHERE P.id NOT IN (
    SELECT richiedente1
    FROM MUTUO M 
    WHERE M.stato = 2
)
AND P.tipo = 'RICHIEDENTE'
GO 

--5. Selezionare i mutui il cui finanziamento è stato attivato, e la cui data di inizio mutuo è nel 2020 e che da almeno 6 mesi non ricevono pagamenti.
CREATE VIEW ULTIMO_PAGAMENTO AS 
SELECT PR.richiedente1, PR.dataRichiesta, MAX(PR.dataPagamento) AS ULTIMO_PAGAMENTO
FROM PagamentoRata PR
GROUP BY PR.richiedente1, PR.dataRichiesta
GO 

SELECT *
FROM MUTUO M 
        JOIN ULTIMO_PAGAMENTO UP ON (UP.richiedente1 = M.richiedente1 AND UP.dataRichiesta = M.dataRichiesta)
WHERE STATO = 1 
AND YEAR(dataInizioMutuo) = 2020
AND (DATEDIFF(MONTH, UP.ULTIMO_PAGAMENTO, GETDATE()) >= 6 OR UP.ULTIMO_PAGAMENTO IS NULL)