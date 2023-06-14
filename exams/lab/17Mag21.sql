--1. Modificare la tabella Animale, aggiungendo il vincolo che l'attributo eta sia maggiore di zero
ALTER TABLE ANIMALE 
ADD CONSTRAINT CHECK_ETA CHECK (ETA>0)

--2. Inserire il vincolo che uno stesso animale in un giorno non possa fare più di una visita.

ALTER TABLE VISITA 
ADD CONSTRAINT CHIAVE UNIQUE (ANIMALE, [DATA]) 

--3.Come si può notare dallo script di creazione del Database manca la foreign key che lega la tabella Somministrazioni alla tabella Visita. 
--Create questa foreign key.

ALTER TABLE Somministrazioni
ADD CONSTRAINT CHIAVE_ESTERNA FOREIGN KEY (ANIMALE, [DATA]) REFERENCES VISITA(ANIMALE, [DATA]) 

--4. Selezionare i farmaci che non sono mai stati somministrati ad alcun animale

SELECT *
FROM FARMACO 
WHERE NOME NOT IN (
    SELECT NOME
    FROM Somministrazioni
)

--5. Selezionare l’animale che ha comportato la spesa maggiore in farmaci 

SELECT A.identificativo, A.aspettativa_di_vita, A.cf_padrone, A.data_morte, A.eta, A.specie, SUM(DOSE*F.prezzo) AS TOTALE
FROM ANIMALE A 
        JOIN Visita V ON (A.identificativo = V.animale)
        JOIN Somministrazioni S ON (V.animale = S.animale AND V.[data] = S.[data])
        JOIN Farmaco F ON (S.nome = F.nome)
GROUP BY A.identificativo, A.aspettativa_di_vita, A.cf_padrone, A.data_morte, A.eta, A.specie
HAVING SUM(DOSE*F.PREZZO) >=ALL (
    SELECT SUM(DOSE*F1.prezzo)
    FROM VISITA V1 
        JOIN Somministrazioni S1 ON (V1.animale = S1.animale AND V1.[data] = S1.[data])
        JOIN Farmaco F1 ON (S1.nome = F1.nome)
    GROUP BY V1.animale
)

--5.2 Selezionare per ogni anno l'animale che ha effettuato più visite. 
--Riportare il numero di visite effettuate e i dati del suo proprietario, riportare anche eventuali parimerito

SELECT A.*, P.*, COUNT(*) AS NVISITE, YEAR(V.[data]) AS ANNO 
FROM Animale A 
        JOIN Visita V ON (A.identificativo = V.animale)
        JOIN Padrone P ON (A.cf_padrone = P.cf)
GROUP BY A.identificativo, A.aspettativa_di_vita, A.cf_padrone, A.data_morte, A.eta, A.specie, P.cf, P.cognome, P.nome, P.data_nascita, YEAR(V.[data])
HAVING COUNT(*) >= ALL(
        SELECT COUNT(*)
        FROM ANIMALE A1 
                JOIN Visita V1 ON (A1.identificativo = V1.animale)
        WHERE YEAR(V1.[data]) = YEAR(V.[data])
        GROUP BY A1.identificativo
)