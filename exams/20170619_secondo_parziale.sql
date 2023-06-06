/*Seconda prova parziale 19-06-2017*/

/*Esercizio 1*/

/*a. Progettazione logica: traduzione di attributi multivalore in relazionale*/

/*
la 1NF impone che se una entità E ha un attributo multiplo A, si crei una nuova entità EA che ha A come attributo singolo ed è collegata ad E. 
Il collegamento può essere:
a)	Un valore può comparire una volta sola nella ripetizione (quindi l’entità EA ha l’identificatore composto dall’entità E e l’attributo A)
b)	Un valore può comparire più volte nella ripetizione (quindi l’entità EA ha l’identificatore composto dall’entità E più un attributo identificante sintetico)
c)	Cardinalità massima nota K (quindi l’entità EA ha come identificatore esterno l’entità E e K attributi, il cui valore sarà non nullo per i primi H, dove H è la minima cardinalità)
Per le associazioni mi basta reificare l’associazione in modo da avere un attributo multiplo su un’entità e applico le regole già viste.
*/



/*b. Operatori di outer join in SQL: descrizione e esempi*/

/*
Outerjoin: una tupla che non contribuisce al join è detta dangling. 
Gli operatori di outerjoin servono per includere nel risultato del join anche tuple dangling: tali tuple sono concatenate con tuple composte da valori nulli.
R [LEFT|RIGHT|FULL] [OUTER] JOIN S ON <condizione>
• LEFT: comprende le tuple dangling della relazione di sinistra R
• RIGHT: comprende le tuple dangling della relazione di destra S
• FULL: comprende sia le tuple dangling di R che le tuple dangling di S 
OUTER è opzionale, viene a volte utilizzata per evidenziare che è un join esterno.

Esempi: 

R
------------------------------
| NOME      |   DATA NASCITA |
------------------------------
| ANNA      |   15/01/1975   |
------------------------------
| LUCA      |   22/01/1988   |
------------------------------

S

------------------------------
| NOME      |     VIA        |
------------------------------
| ANNA      |     VIA EMILIA |
------------------------------
| LUCA      |VIA NONANTOLANA |
------------------------------      



SELECT *
FROM R LEFT OUTER JOIN S ON R.NOME = S.NOME 

------------------------------------------------
| R.NOME | DATA NASCITA  |  S.NOME | VIA       |
------------------------------------------------
| ANNA   | 15/01/1975    |  ANNA   | VIA EMILIA|
------------------------------------------------
| LUCA   | 22/01/1988    |  NULL   | NULL      |
------------------------------------------------

SELECT *
FROM R RIGHT OUTER JOIN S ON R.NOME = S.NOME 

-----------------------------------------------------------
| R.NOME | DATA NASCITA  |  S.NOME | VIA                  |
-----------------------------------------------------------
| ANNA   | 15/01/1975    |  ANNA   | VIA EMILIA           |
-----------------------------------------------------------
| NULL   | NULL          |  ABC    | VIA NONANTOLANA      |
-----------------------------------------------------------

SELECT *
FROM R FULL OUTER JOIN S ON R.NOME = S.NOME 

------------------------------------------------------
| R.NOME | DATA NASCITA  |  S.NOME | VIA             |
------------------------------------------------------
| ANNA   | 15/01/1975    |  ANNA   | VIA EMILIA      |
------------------------------------------------------
| LUCA   | 22/01/1988    |  NULL   | NULL            |
------------------------------------------------------
| NULL   | NULL          | ABC     | VIA NONANTOLANA |
------------------------------------------------------
*/

/*Esercizio 3*/

/*1. Selezionare il nome e il cognome degli utenti che hanno prenotato o partecipato agli eventi con il nome "Modena Park". */

SELECT U.NOME, U.COGNOME
FROM UTENTE U 
        JOIN PRENOTAZIONE P ON (U.USERNAME = P.USERNAME)
        JOIN EVENTO E ON (P.CODEVENTO = E.CODEVENTO)
WHERE NOMEVENTO = 'MODENA PARK'
UNION 
SELECT U1.NOME, U1.COGNOME 
FROM UTENTE U1 
        JOIN PARTECIPAZIONE PA ON (U1.USERNAME = PA.USERNAME)
        JOIN EVENTO E2 ON (PA.CODEVENTO = E2.CODEVENTO)
WHERE NOMEVENTO = 'MODENA PARK'
GO 

/*2. Selezionare l'email degli utenti che hanno partecipato ad almeno un evento senza fare la prenotazione. */

SELECT EMAIL 
FROM UTENTE 
EXCEPT 
SELECT EMAIL
FROM UTENTE U
WHERE NOT EXISTS(
    SELECT *
    FROM PRENOTAZIONE P
    WHERE NOT EXISTS(
        SELECT *
        FROM PARTECIPAZIONE PA 
        WHERE PA.CODEVENTO = P.CODEVENTO
        AND PA.USERNAME = U.USERNAME
    )
)
GO 

/*3. Selezionare la data di nascita degli utenti che hanno partecipato a tutti gli eventi a cui ha partecipato l'utente con l'username "mrossi".*/

SELECT U.DATANASCITA
FROM UTENTE U  
WHERE NOT EXISTS(
    SELECT *
    FROM  PARTECIPAZIONE P 
    WHERE P.USERNAME = 'MROSSI'
    AND NOT EXISTS(
        SELECT *
        FROM PARTECIPAZIONE P2 
        WHERE P2.USERNAME = U.USERNAME
        AND P2.CODEVENTO = P.CODEVENTO
    )
)
GO 

/*1. Creare una vista che mostri gli eventi svolti a Modena, nei quali il numero delle prenotazioni sono state superiori al numero delle partecipazioni.*/

CREATE VIEW NPRENOTAZIONI AS 
SELECT COUNT(*) AS NPRENOTAZIONI, E.CODEVENTO
FROM PRENOTAZIONE P 
        JOIN EVENTO E ON (P.CODEVENTO = E.CODEVENTO)
WHERE E.CITTA = 'MO'
GROUP BY E.CODEVENTO
GO 

CREATE VIEW NPARTECIPAZIONI AS 
SELECT COUNT(*) AS NPARTECIPAZIONI, E.CODEVENTO
FROM PARTECIPAZIONE P 
        JOIN EVENTO E ON (P.CODEVENTO = E.CODEVENTO)
WHERE E.CITTA = 'MO'
GROUP BY E.CODEVENTO 
GO 

CREATE VIEW QUERY1 AS 
SELECT E.*
FROM EVENTO E 
        JOIN NPRENOTAZIONI NPR ON (E.CODEVENTO = NPR.CODEVENTO)
        JOIN NPARTECIPAZIONI NPA ON (E.CODEVENTO = NPA.CODEVENTO)
WHERE NPR.NPRENOTAZIONI > NPA.NPARTECIPAZIONI
GO 

/*2. Selezionare per ogni tipo evento, il nome e la data dell'evento con più partecipazioni*/

CREATE VIEW NPARTECIPAZIONI AS 
SELECT E.CODEVENTO, E.TIPOEVENTO, COUNT(*) AS NPARTECIPAZIONI
FROM EVENTO E 
        JOIN PARTECIPAZIONE P ON (E.CODEVENTO = P.CODEVENTO)
GROUP BY E.CODEVENTO, E.TIPOEVENTO
GO 

SELECT E.NOMEEVENTO, E.DATAEVENTO
FROM EVENTO E 
        JOIN NPARTECIPAZIONI NPA1 ON (E.CODEVENTO = NPA.CODEVENTO)
WHERE E.TIPOEVENTO = NPA.TIPOEVENTO
AND NPA.NPARTECIPAZIONI >= ALL(
    SELECT NPA2.NPARTECIPAZIONI
    FROM NPARTECIPAZIONI NPA2 
    WHERE NPA2.TIPOEVENTO = E.TIPOEVENTO
)

/*3. Selezionare per ogni evento, il numero di utenti nati prima del 1990 e che hanno partecipato all'evento senza prenotare.*/

SELECT E.CODEVENTO, COUNT(*) AS NUTENTI
FROM PARTECIPAZIONE P 
        JOIN UTENTE U ON (P.USERNAME = U.USERNAME)
WHERE YEAR(U.DATANASCITA) < 1990
AND U.USERNAME NOT IN (
    SELECT PR.USERNAME
    FROM PRENOTAZIONE PR 
    WHERE PR.CODEVENTO = P.CODEVENTO
)
GROUP BY P.CODEVENTO


