/*Prova totale 10-01-2018*/

/*Esercizio 1*/

/*Definizione di foreign key ed esempio di violazione.*/

/*
La FOREIGN KEY o vincolo di integrità referenziale assicura che quando in una tupla si utilizza il valore di un attributo per riferirsi ad un’altra tupla, 
quest’ultima sia una tupla esistente.
(((Le chiavi esterne sono vincoli che garantiscono l’integrità dei dati. 
Sono composte da una colonna in una tabella chiamata figlia che si riferisce a una colonna in una tabella chiamata madre. 
Se si utilizzano le chiavi esterne vengono effettuati i necessari controlli per garantire che alcune regole vengano rispettate)))
(((la chiave esterna è un insieme di regole che garantiscono l’integrità dei dati quando si hanno relazioni associate tra loro attraverso la chiave esterna: 
queste regole servono per rendere valide le associazioni tra le tabelle e per eliminare gli errori di inserimento, cancellazione o modifica dei dati collegati tra loro. 
L’integrità referenziale viene rispettata quando per ogni valore non nullo della chiave esterna, esiste un valore corrispondente della chiave primaria nella tabella associata)))
(((A differenza degli altri vincoli di integrità, una violazione di un vincolo di FK non genera necessariamente un errore. E’ possibile stabilire diverse politiche per reagire ad una violazione. 
La violazione può avvenire in due modi: 
1. Nella tabella secondaria, inserisco una nuova riga o modifico la chiave esterna. La cancellazione di una riga nella tabella secondaria non viola mai il vincolo di chiave esterna. 
2. cancello una riga nella tabella principale. L’inserimento di una nuova riga dalla tabella principale non viola mai il vincolo di chiave esterna.)))
*/

/*Esercizio 4*/

/*a) Selezionare le concessionarie che hanno venduto solo veicoli di marca “FIAT”. */

SELECT *
FROM CONCESSIONARIA C 
        JOIN ACQUISTO A2 ON (C.PIVA = A2.PIVA)
WHERE C.PIVA NOT IN (
    SELECT A.PIVA
    FROM ACQUISTO A 
            JOIN VEICOLO V ON (A.NUMERO_TELAIO = V.NUMERO_TELAIO)
    WHERE MARCA <> 'FIAT' 
)

/*b) Selezionare i dati dei clienti che hanno acquistato veicoli di colore “rosso”. */

SELECT C.*
FROM CLIENTE C 
        JOIN ACQUISTO A ON (C.CF = A.CF)
        JOIN VEICOLO V ON (A.NUMERO_TELAIO = V.NUMERO_TELAIO)
WHERE V.COLORE = 'ROSSO'
GO 

/*c) Creare una vista che mostri per ogni concessionaria (deve essere presente il nome), le sedi che hanno venduto veicoli per un totale superiore a 100000€.*/

CREATE VIEW QUERYC AS 
SELECT C.NOME, S.PIVA, S.NUMERO 
FROM CONCESSIONARIA C 
        JOIN SEDE S ON (C.PIVA = S.PIVA)
        JOIN ACQUISTO A ON (S.PIVA = A.PIVA)
GROUP BY C.PIVA, C.NOME, S.NUMERO
HAVING SUM(A.PREZZO) > 100000
GO 

/*d) Mostrare per ogni veicolo l’ultimo cliente che lo ha acquistato. */

SELECT C.*, A.NUMERO_TELAIO 
FROM ACQUISTO A 
        JOIN CLIENTE C ON (A.CF = C.CF)
WHERE A.DATA = (
    SELECT MAX(A2.DATA)
    FROM ACQUISTO A1 
    WHERE A1.NUMERO_TELAIO = A.NUMERO_TELAIO
)



