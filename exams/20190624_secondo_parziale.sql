/*Seconda prova parziale 24-06-2019*/

/*Esercizio 1*/

/*a. Operatori di JOIN dell’algebra relazionale. */

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
r ⋉ s = π_X(r (*naturaljoin) s)
*/

/*b. Istruzione SQL GROUP BY.*/

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

[ Il raggruppamento viene fatto sulle tuple selezionate dal FROM-WHERE: viene fatto prima il JOIN, poi le eventuali condizioni WHERE e quindi
il GROUP BY. Alla fine si effettua la parte SELECT, riportando in output una riga per gruppo.

La clausola HAVING è l'equivalente della clausola WHERE applicata a gruppi di tuple: ogni gruppo costruito tramite GROUP BY fa parte del 
risultato dell'interrogazione solo se il predicato specificato nella clausola HAVING risulta soddisfatto.

Il predicato espresso nella clausola HAVING è formulato utilizzando:
- Uno o più attributi specificati in <lista-GROUP>
- Funzioni aggregate ]
*/


/*Esercizio 2*/

/*1. Selezionare i dati delle persone di nazionalità “italiana” che hanno partecipato a concerti nella città di “Bologna”.*/

SELECT P.*
FROM PERSONA P
        JOIN PARTECIPA PA ON (P.CF = PA.CF)
        JOIN CONCERTO C ON (PA.ID_CONCERTO = C.ID_CONCERTO) 
        JOIN SEDE S ON (C.ID_SEDE = S.ID_SEDE)
WHERE P.NAZIONALITA = 'ITALIANA'
AND S.CITTA = 'BO'


/*2. Selezionare nome e cognome delle persone che hanno partecipato solo a concerti di tipo “Rock”.*/

/*NON CONVIENE FARE CON EXCEPT PERCHE NOME E COGNOME NON SONO CHIAVE -> USARE NOT IN*/
/*EXCEPT COMODO QUANDO DEVI SELEZIONARE SOLO LA CHIAVE O PRENDERE TUTTI GLI ATTRIBUTI (ENTRAMBE LE QUERY NELLA EXCEPT DEVONO AVERE GLI STESSI
ATTRIBUTI NELLA SELECT*/

SELECT P.NOME, P.COGNOME
FROM PERSONA P 
        JOIN PARTECIPA PA ON (P.CF = PA.CF)
WHERE P.CF NOT IN (
    SELECT P2.CF 
    FROM PERSONA P2 
            JOIN PARTECIPA PA2 ON (P2.CF = PA2.CF)
            JOIN CONCERTO C ON (PA2.ID_CONCERTO = C.ID_CONCERTO)
            JOIN ARTISTA A ON (C.NOME_ARTISTA = A.NOME_ARTISTA)
    WHERE TIPO <> 'ROCK'
)

/*3. Selezionare gli artisti con più di 10 anni di attività che hanno tenuto concerti in tutte le sedi con più di 10000 posti nell’ultimo semestre del 2018. */

SELECT A.*
FROM ARTISTA A 
WHERE ANNI_ATTIVITA > 10 
AND NOT EXISTS (
    SELECT *
    FROM SEDE S 
    WHERE NUM_POSTI > 10000
    AND NOT EXISTS(
        SELECT *
        FROM CONCERTO C 
        WHERE C.NOME_ARTISTA = A.NOME_ARTISTA 
        AND C.DATA BETWEEN '1-07-2018' AND '31-12-2018'
        AND C.ID_SEDE = S.ID_SEDE
    )
) 

/*4. Selezionare i concerti del 2018 a cui hanno partecipato almeno 500 persone di nazionalità “italiana”. */

SELECT P.ID_CONCERTO
FROM CONCERTO C 
        JOIN PARTECIPA P ON (C.ID_CONCERTO = P.ID_CONCERTO)
        JOIN PERSONA PE ON (P.CF = PE.CF)
WHERE P.NAZIONALITA = 'ITALIANA'
AND YEAR(C.DATA) = 2018
GROUP BY P.ID_CONCERTO
HAVING COUNT(*) >= 500

/*5. Selezionare nome e cognome della persona che ha speso più soldi (somma dei prezzi dei biglietti) per partecipare ai concerti nel 2018. */

SELECT P.NOME, P.COGNOME
FROM PERSONA P 
        JOIN PARTECIPA PA ON (P.CF = PA.CF)
        JOIN CONCERTO C ON (C.ID_CONCERTO = PA.ID_CONCERTO)
WHERE YEAR(C.DATA) = 2018
GROUP BY P.CF, P.NOME, P.COGNOME 
HAVING SUM(C.PREZZO_BIGLIETTO) >= ALL(
    SELECT SUM(C.PREZZO_BIGLIETTO)
    FROM PERSONA P2 
        JOIN PARTECIPA PA2 ON (P2.CF = PA2.CF)
        JOIN CONCERTO C2 ON (C2.ID_CONCERTO = PA2.ID_CONCERTO) 
    WHERE YEAR(C.DATA) = 2018
    GROUP BY P2.CF
)

/*6. Creare una vista che mostri per ogni artista nome dell’artista, l’incasso totale di tutti i suoi concerti, 
il numero di persone e il numero di nazionalità distinte dei partecipanti ai suoi concerti. 
Devono essere mostrati solo gli artisti con un incasso superiore a 1000000€. */

SELECT A.NOME_ARTISTA. SUM(PREZZO_BIGLIETTO) AS TOTALE, COUNT(DISTINCT P.CF) AS PERSONE, COUNT(DISTINCT P.NAZIONALITA) AS NAZIONI
FROM CONCERTO
        JOIN PARTECIPA PA ON (C.ID_CONCERTO = PA.ID_CONCERTO)
        JOIN PERSONA P ON (P.CF = PA.CF)
-- WHERE SUM(PREZZO_BIGLIETTO) > 1000000 CONTROLLA SE UN SINGOLO CONCERTO HA AVUTO UN INCASSO MAGGIORE DI 1000000
GROUP BY A.NOME_ARTISTA
HAVING SUM(PREZZO_BIGLIETTO) > 1000000 --CONTROLLO CHE L'ARTISTA IN TOTALE DAI SUOI CONCERTI ABBIA AVUTO UN INCASSO MAGGIORE DI 1000000

/*7. Selezionare per ogni sede ed anno il nome dell’artista che ha tenuto il concerto con il maggior numero di partecipanti.*/

SELECT C.ID_SEDE, YEAR(C.DATA) AS ANNO, C.NOME_ARTISTA
FROM CONCERTO C 
        JOIN PARTECIPA PA ON (C.ID_CONCERTO = PA.ID_CONCERTO)
GROUP BY C.ID_SEDE, YEAR(C.DATA), C.NOME_ARTISTA, C.ID_CONCERTO
HAVING COUNT(*) >= ALL(
    SELECT COUNT(*)
    FROM CONCERTO C2
            JOIN PARTECIPA PA2 ON (PA2.ID_CONCERTO = C2.ID_CONCERTO)
    WHERE C2.ID_SEDE = S.ID_SEDE 
    AND YEAR(C2.DATA) = YEAR(C.DATA)
    GROUP BY C2.ID_CONCERTO
)
