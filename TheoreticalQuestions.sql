/*Domande di teoria secondo parziale*/ 


/*1. Istruzioni GROUP BY e HAVING in SQL: sintassi ed esempi.*/

/*
In una istruzione SELECT è possibile formare dei gruppi di tuple che hanno lo stesso valore di specificati attributi, tramite la clausola
GROUP BY.

SELECT [DISTINCT|ALL] <lista-SELECT>
FROM <lista-FROM>
[WHERE <condizione>]
[GROUP BY <lista-GROUP>]

Il risultato della SELECT è un unico record per ciascun gruppo, pertanto nella <lista-SELECT> possono comparire solo:
- Uno o più attributi di raggruppamento, cioè specificati in <lista-GROUP>
- Funzioni aggregate: tali funzioni vengono valutate, e quindi forniscono un valore unico, per ciascun gruppo.

Il raggruppamento viene fatto sulle tuple selezionate dal FROM-WHERE: viene fatto prima il JOIN, poi le eventuali condizioni WHERE e quindi
il GROUP BY. Alla fine si effettua la parte SELECT, riportando in output una riga per gruppo.

La clausola HAVING è l'equivalente della clausola WHERE applicata a gruppi di tuple: ogni gruppo costruito tramite GROUP BY fa parte del 
risultato dell'interrogazione solo se il predicato specificato nella clausola HAVING risulta soddisfatto.

Il predicato espresso nella clausola HAVING è formulato utilizzando:
- Uno o più attributi specificati in <lista-GROUP>
- Funzioni aggregate

Esempio: 

E 
---------------------
| MATR  | CC | VOTO |
---------------------
| M1    | C1 | 23   |
---------------------
| M1    | C2 | 25   |
---------------------
| M2    | C1 | 21   |
---------------------

SELECT MATR, AVG(VOTO) AS MEDIA
FROM E 
GROUP BY MATR 
HAVING AVG(VOTO) > 22

----------------
| MATR | MEDIA |
----------------
| M1   | 24    |
----------------

*/

----------------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------------


/*2. Sintassi di interrogazioni innestate*/

/*

Una interrogazione viene detta innestata o nidificata se la sua condizione è formulata usando il risultato di un'altra interrogazione, chiamata
subquery. -- oppure in alternativa -> Una interrogazione viene detta innestata o nidificata se il suo risultato dipende dal risultato di un'altra interrogazione, chiamata subquery
--Opzionale: si può specificare che le interrogazioni innestate si possono fare solo nella WHERE e nella HAVING
In generale, un'interrogazione innestata viene formulata con:
Operatori quantificati: <attr> <op-rel> [ANY|ALL] <subquery>
Operatore di set: <attr> [NOT] IN <subquery>
Quantificatore esistenziale: [NOT] EXISTS <subquery>

Il confronto fra un attributo e il risultato di una interrogazione è possibile quando essa produce (run-time) un valore atomico.
Se non viene prodotto un valore atomico va usato il quantificatore ANY o ALL. 
Il predicato EXISTS (<subquery>) ha valore true se e solo se l'insieme di valori restituiti da <subquery> è non vuoto. 
Il predicato NOT EXISTS (<subquery>) ha valore true se e solo se l'insieme di valori restituiti da <subquery> è vuoto. 

Una subquery viene detta correlata se la sua condizione è formulata usando relazione e/o sinonimi definite nella query esterna.


Esempi: 

S
------------------------
| MATR | NOME | ACORSO |
------------------------
| M1   |  A   |   1    |
------------------------
| M2   |  B   |   2    |
------------------------
| M3   |  C   |   3    |
------------------------
| M4   |  D   |  NULL  |
------------------------

E
--------------------
| MATR | CC | VOTO |
--------------------
| M1   | C1 | 22   |
--------------------
| M2   | C1 | 24   |
--------------------
| M3   | C2 | 30   |
--------------------

OPERATORI QUANTIFICATI: "Studenti con anno di corso più basso"

SELECT *
FROM S 
WHERE ACORSO <= ALL(
    SELECT ACORSO
    FROM S 
    WHERE ACORSO IS NOT NULL
)

PER OGNI STUDENTE SI CONFRONTA IL SUO ANNO DI CORSO CON QUELLO DI TUTTI GLI ALTRI STUDENTI E SI RIPORTA IN USCITA SOLO SE E IL MINIMO
SE NON METTO LA CONDIZIONE IS NOT NULL L'OPERATORE QUANTIFICATO CON ALL RESTITUISCE SEMPRE FALSE

------------------------
| MATR | NOME | ACORSO |
------------------------
| M1   |  A   |   1    |
------------------------


OPERATORI DI SET: 

"Nome degli studenti che hanno sostenuto l'esame del corso C1"

SELECT NOME 
FROM S 
WHERE MATR IN (
    SELECT MATR 
    FROM E 
    WHERE CC = 'C1'
)

PER OGNI STUDENTE CONFRONTA LA SUA MATRICOLA CON TUTTE LE MATRICOLE DEGLI STUDENTI CHE HANNO SOSTENUTO L'ESAME DEL CORSO C1 E SE TROVA 
CORRISPONDENZA RIPORTA IN USCITA IL NOME DELLO STUDENTE
--------
| Nome |
--------
! A    |
--------
| B    |
--------

QUANTIFICATORE ESISTENZIALE: 

"Nome degli studenti che hanno sostenuto l'esame del corso C1"

SELECT NOME 
FROM S 
WHERE EXISTS (
    SELECT *
    FROM E
    WHERE E.MATR = S.MATR
    AND E.CC = 'C1'
)

PER OGNI STUDENTE CONTROLLA SE ESISTE NELLA RELAZIONE ESAME UNA TUPLA CHE ABBIA LA STESSA MATRICOLA E IL CODICE CORSO 'C1' E SE LA TROVA
RIPORTA IN USCITA IL NOME DELLO STUDENTE

--------
| Nome |
--------
! A    |
--------
| B    |
--------
*/

----------------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------------


/*3. Definizione dell'operatore di divisione nell'algebra relazionale*/

/*
L'operatore di divisione, dato uno schema di relazione r e un altro schema di relazione s restituisce le tuple di r che partecipano a tutte
le tuple di s.
La definizione matematica dell'operatore è: 
Date due relazioni r e s con schemi R(X) e S(Y) tali che Y ⊂ X, l’operazione di divisione tra r e s , r÷s, ha come risultato una relazione che ha
schema (X − Y) ed è definita da
r÷s={tD |∀tS ∈ s, tDtS ∈r}

L'operatore divisione può essere derivato dagli operatori base.

Esempio: 
Le matricole che frequentano tutti i corsi del docente D1

FREQUENZA 

-----------------
| MATR | CODCOR |
-----------------
| M1   |  C1    |
-----------------
| M1   |  C3    |
-----------------
| M2   |  C1    |
-----------------
| M3   |  C2    |
-----------------

CORSO 

-------------------
| CODCOR | CODDOC |
-------------------
| C1     |   D1   |
-------------------
| C2     |   D2   |
-------------------
| C3     |   D1   |
-------------------

FREQUENZA ÷ π_CODCOR(σ_CODDOC='D1'(CORSO))

--------
| MATR |
--------
| M1   |
--------

*/

----------------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------------


/*4. Operatori di JOIN in SQL*/

/*
Date due relazioni R e S, l’operazione di join serve per combinare tuple di R con tuple di S sulla base di condizioni espresse sugli attributi delle due relazioni, dette condizioni di join,
in questo caso si parla di INNER JOIN.
L'operazione di join produce il sottoinsieme delle tuple prodotte dal prodotto cartesiano delle tabelle che rispettano le condizioni di join.
Join con clausola where : si evidenzia che è un sottoinsieme del prodotto cartesiano  -- questa si può omettere (se non volete fare i secchioni)
Join con operatore JOIN : si scrive il join direttamente nella clausola from
La condizione di join può essere una condizione booleana, spesso un AND di condizioni semplici o molto raramente un OR di condizioni semplici
Nella quasi totalità dei casi reali la condizione di join riguarda la foreign key 
Quando devo fare un join due volte sulla stessa tabella si parla di SELF JOIN: in questo caso per distinguere le due tabelle è indispensabile 
fare uso di alias. 

Sintassi di base: 
SELECT <lista-select>
FROM <tabella>
        JOIN <nometabella> [<alias>] ON (<condizione di join>)

[ Se si ha tempo si parla dell'OUTER JOIN]



Esempi: 

R 
----------------------
| Nome | DataNascita |
----------------------
| Anna | 15/01/1975  |
----------------------
| Luca | 22/01/1988  |
----------------------

S 

--------------------------
| Nome | Via             |
--------------------------
| Anna | Via Emilia      |
--------------------------
| ABC  | Via Nonantolana |
--------------------------


SELECT *
FROM R, S 
WHERE R.NOME = S.NOME

OPPURE 

SELECT *
FROM R JOIN S ON (R.NOME = S.NOME)

----------------------------------------------
| R.Nome | DataNascita | S.Nome | Via        |
----------------------------------------------
| Anna   | 15/01/1975  | Anna   | Via Emilia |
----------------------------------------------

*/

----------------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------------



/*5. Istruzione FOREIGN KEY in SQL ed esempio che ne mostri le diverse opzioni */

/*
La foreign key è un vincolo di colonna che si assegna ad un attributo in fase di creazione della tabella e che implica che la chiave specificata
all'interno di questa colonna deve corrispondere ad un attributo UNIQUE esistente (vincolo di integrità referenziale) su un'altra relazione.
Ogni vincolo di foreign key va inserito all'interno della create table o alter table e si può scrivere in due modi:
- CREATE TABLE <nome-tabella> (
    <nome-colonna> <tipo-colonna> REFERENCES <altra-tabella> [(<colonna-altra-tabella>)]
    ...
)
- CREATE TABLE <nome-tabella> (
    ...
    FOREIGN KEY (<lista-attributi>) REFERENCES <altra-tabella> (<lista-attributi-altra-tabella>)
)
Solo con quest'ultima sintassi è possibile riferirsi a tabelle che hanno chiavi multivalore

Esempio: 

R 
-------------
| C1 | C2   |
-------------
| a  | b    |
-------------
| c  | NULL |
-------------
R(_C1_, C2)
FK: C2 REFERENCES s 

S 
-----------
| C1 | C2 |
-----------
| b  | d  |
-----------
| e  | f  |
-----------
S(_C1_, C2)

In SQL:
CREATE TABLE S (
    C1 VARCHAR(1) PRIMARY KEY,
    C2 VARCHAR(1)
)

CREATE TABLE R (
    C1 VARCHAR(1) PRIMARY KEY,
    C2 VARCHAR(1) REFERENCES S
)

INSERT INTO S VALUES 
    ('b', 'd'),
    ('e', 'f')

INSERT INTO R VALUES 
    ('a', 'b')
    ('c', NULL)


*/

----------------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------------


/*6. Operatori di OUTER JOIN in SQL */
/*
Outerjoin: una tupla che non contribuisce al join è detta dangling. 
Gli operatori di outerjoin servono per includere nel risultato del join anche tuple dangling: tali tuple sono concatenate con tuple composte da valori nulli.
R [LEFT|RIGHT|FULL] [OUTER] JOIN S ON <condizione>
• LEFT: comprende le tuple dangling della relazione di sinistra R
• RIGHT: comprende le tuple dangling della relazione di destra S
• FULL: comprende sia le tuple dangling di R che le tuple dangling di S 
OUTER è opzionale, viene a volte utilizzata per evidenziare che è un join esterno.

Esempi: 
-- gli esempi ci stanno, non serve farli tutti

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


----------------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------------



/*7. Operatori di JOIN dell'algebra relazionale */

/*
Il Theta-join tra r e s definisce un sottoinsieme del prodotto cartesiano r × s ottenuto tramite una operazione di selezione.

Date due relazioni r e s con schema R(X) e S(Y), e un predicato di join F costituito da una espressione booleana di predicati di confronto 
AΘB, dove A ∈ X, B ∈ Y e Θ è un operatore di confronto, il Theta-join tra r e s è definito come
r (*theta-join*)_F s = σ_F(r×s)

Nel theta-join il predicato di join F può fare uso di generici predicti di confronto. 

Nell'EquiJoin i predicati di confronto sono esclusivamente predicati di uguaglianza.

Il NaturalJoin è un EquiJoin sugli attributi comuni (non serve la condizione di join) proiettato sull'unione degli attributi (in uscita un 
attributo comune c'è una volta sola). 

Date due relazioni r e s con schemi R(X) e S(Y), il naturaljoin (o join naturale) tra r e s, indicato con r (*naturaljoin*) s, 
è il risultato dell’equijoin tra r e s su tutti gli attributi comuni a X e Y proiettato sull’unione degli attributi dei due schemi (XY)
*espressione matematica*

Date due relazioni r e s con schemi R(X) e S(Y) il semijoin da r a s, indicato con r ⋉ s è la proiezione su X del join naturale di r e s 
r ⋉ s = π_X(r (*naturaljoin*) s)

Esempio: 

R 
----------------------
| Nome | DataNascita |
----------------------
| Anna | 15/01/1975  |
----------------------
| Luca | 22/01/1988  |
----------------------

S 

--------------------------
| Nome | Via             |
--------------------------
| Anna | Via Emilia      |
--------------------------
| ABC  | Via Nonantolana |
--------------------------

R (*theta-join*)_F S

----------------------------------------------
| R.Nome | DataNascita | S.Nome | Via        |
----------------------------------------------
| Anna   | 15/01/1975  | Anna   | Via Emilia |
----------------------------------------------

R (*natural_join*) S 

------------------------------------
| Nome | DataNascita  | Via        |
------------------------------------
| Anna | 15/01/1975   | Via Emilia |
------------------------------------

R ⋉ S 

-----------------------
| Nome | DataNascita  |
-----------------------
| Anna | 15/01/1975   |
-----------------------
*/
