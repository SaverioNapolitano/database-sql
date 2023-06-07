/*Prova totale 12-02-2018*/

/*Esercizio 1*/

/*Descrivere come si rappresenta il progetto logico di attributi multi valore.*/

/*
la 1NF impone che se una entità E ha un attributo multiplo A, si crei una nuova entità EA che ha A come attributo singolo ed è collegata ad E. Il collegamento piò essere:
a)	Un valore può comparire una volta sola nella ripetizione (quindi l’entità EA ha l’identificatore composto dall’entità E e l’attributo A)
b)	Un valore può comparire più volte nella ripetizione (quindi l’entità EA ha l’identificatore composto dall’entità E più un attributo  identificante sintetico)
c)	Cardinalità massima nota K (quindi l’entità EA ha come identificatore esterno l’entità E e K attributi, il cui valore sarà non nullo per i primi H, dove H è la minima cardinalità)
Per le associazioni mi basta reificare l’associazione in modo da avere un attributo multiplo su un’entità e applico le regole già viste.
*/


/*Esercizio 4*/

/*a) Selezionare gli utenti che non hanno mai visitato le pagine di tipo “social”. */

/*VERSIONE 2: NOT IN*/
SELECT *
FROM USERR U1 
WHERE U1.USERNAME NOT IN (
    SELECT WPL.USERNAME 
    FROM WEBPAGELOG WPL 
            JOIN WEBPAGE WP ON (WPL.IDPAGE = WP.IDPAGE)
    WHERE WP.TYPE = 'SOCIAL'
)

/*b) Selezionare l’email degli utenti che hanno eseguito l’ACTION “vota” sulla pagina di nome “mario rossi fan page” dopo il 20 settembre 2017. */

SELECT U.EMAIL
FROM USERR U 
        JOIN WEBPAGELOG WPL ON (U.USERNAME = WPL.USERNAME)
        JOIN WEBPAGE WP ON (WPL.IDPAGE = WP.IDPAGE)
WHERE WPL.ACTIONN = 'VOTA' 
AND WPL.TIMESTAMPP > '20-09-2017'
AND WP.NAME = 'MARIO ROSSI FAN PAGE'
GO 

/*c) Creare una vista che mostri gli utenti che hanno eseguito sulle pagine almeno 200 ACTION “like” dopo il primo gennaio 2018. */

CREATE VIEW QUERYC AS 
SELECT U.USERNAME, U.PASSWORD, U.EMAIL, U.FIRSTNAME, U.LASTNAME, U.BIRTHDAY 
FROM USERR U
        JOIN WEBPAGELOG WPL ON (U.USERNAME = WPL.USERNAME)
WHERE WPL.ACTIONN = 'LIKE'
AND WPL.TIMESTAMPP > '01-01-2018'
GROUP BY U.USERNAME, U.PASSWORD, U.EMAIL, U.FIRSTNAME, U.LASTNAME, U.BIRTHDAY 
HAVING COUNT(*) >= 200
GO 

/*d) Mostrare per ogni pagina l’ACTION eseguita più spesso dagli utenti nati dopo il primo gennaio 1998. */

SELECT WPL.IDPAGE, WPL.ACTIONN
FROM WEBPAGELOG WPL 
        JOIN USERR U ON (WPL.USERNAME = U.USERNAME)
WHERE U.BIRTHDAY > '01-01-1998'
GROUP BY WPL.IDPAGE, WPL.ACTION 
HAVING COUNT(*) >= ALL(
    SELECT COUNT(*)
    FROM WEBPAGELOG WPL2 
            JOIN USERR U2 ON (WPL2.USERNAME = U2.USERNAME)
    WHERE WPL2.IDPAGE = WPL.IDPAGE 
    AND U2.BIRTHDAY > 'O1-01-1998'
    GROUP BY ACTIONN 
)

