--1. Aggiungere la foreign key in tabella concerto sull'attributo id_artista verso la tabella artista. 
--Tale foreign key quando si modifica un artista e vi è un concerto inserito che vi fa riferimento deve propagare questa modifica anche a concerto.

ALTER TABLE CONCERTO 
ADD CONSTRAINT FK_ARTISTA FOREIGN KEY(id_artista) REFERENCES ARTISTA(id_artista) ON UPDATE CASCADE

--2. Inserire un controllo in tabella concerto che garantisca che il prezzo di un biglietto (prezzo_biglietto) sia maggiore di 1
ALTER TABLE CONCERTO 
ADD CONSTRAINT CHECK_PREZZO CHECK (prezzo_biglietto > 1)

--3. Selezionare, se esistono, tutti gli attributi delle sedi in cui non sono mai stati effettuati concerti

SELECT *
FROM SEDE S 
WHERE ID_SEDE NOT IN (
    SELECT C.id_sede
    FROM CONCERTO C 
    WHERE C.id_sede = S.id_sede
)

--4. Selezionare, per ogni persona, il nome, il cognome, il numero di concerti a cui ha partecipato, 
--e il numero totale di artisti diversi di cui ha assistito ai concerti. Ordinare per cognome, nome

SELECT P.id_p, P.nome, P.cognome, COUNT(PA.id_concerto) AS NCONCERTI, COUNT(DISTINCT C.id_artista) AS NARTISTI
FROM PERSONA P 
        JOIN partecipa PA ON (P.id_p = PA.id_p)
        JOIN CONCERTO C ON (PA.id_concerto = C.id_concerto)
GROUP BY P.id_p, P.nome, P.cognome
ORDER BY COGNOME, NOME 
GO 
--5. Creare una vista STATISTICHE_ARTISTI che mostri per ogni artista ed anno il numero totale di partecipanti ai suoi concerti dell'anno. 
--Successivamente selezionare, per ogni artista, l’anno in cui ha avuto più partecipanti ai suoi concerti.

CREATE VIEW STATISTICHE_ARTISTI AS 
SELECT C.ID_ARTISTA, COUNT(P.id_p) AS PARTECIPANTI, YEAR(C.datac) AS ANNO
FROM CONCERTO C
        JOIN partecipa P ON (C.id_concerto = P.id_concerto)
GROUP BY C.id_artista, YEAR(C.datac)
GO 

SELECT SA.id_artista, SA.ANNO
FROM STATISTICHE_ARTISTI SA
WHERE SA.PARTECIPANTI >= ALL(
    SELECT SA1.PARTECIPANTI
    FROM STATISTICHE_ARTISTI SA1 
    WHERE SA1.id_artista = SA.id_artista
)