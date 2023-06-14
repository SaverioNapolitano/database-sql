--1. Inserire un nuovo Esemplare il cui proprietario è Giovanni Sorbelli.
--L'esemplare è un gatto di 2 anni per il quale non si conosce l'aspettativa di vita, nato il 1/06/2018.
insert into Esemplare (cf_Proprietario, eta,data_nascita,identificativo,SpecieAnimale) values ('erdfsa40s26g123p', 2, '01/06/2018',100,'gatto')

--2. Modificare la tabella Proprietario, aggiungendo l'attributo "citta" che contiene il nome della città in cui vive il proprietario di un animale
ALTER TABLE Proprietario
ADD CITTA VARCHAR(50) 
--3. Come si può notare dallo script, manca la foreign key che collega la tabella Somministrazioni alla tabella Visita (ovvero che riporta in Somministrazione il riferimento alla chiave di Visita). Definire il comando per create questa foreign key .

ALTER TABLE Somministrazioni
ADD CONSTRAINT FK_VISITA FOREIGN KEY (Esemplare, [DATA]) REFERENCES VISITA 
--4. Riportare l'identificativo dell'esemplare (o degli esemplari a pari merito) che nel 2019 hanno subito più visite.

SELECT V.Esemplare
FROM VISITA V  
WHERE YEAR(V.[data]) = 2019
GROUP BY V.Esemplare
HAVING COUNT(*) >= ALL(
    SELECT COUNT(*)
    FROM VISITA V1 
    WHERE YEAR(V1.[data]) = 2019
    GROUP BY V1.Esemplare
)
GO

--4.2 Riportare il nome del farmaco (o dei farmaci a pari merito) che a dicembre 2019 sono stati somministrati più volte.

SELECT S.nome
FROM Somministrazioni S 
WHERE YEAR(S.[data]) = 2019 
AND MONTH(S.[data]) = 12
GROUP BY S.nome
HAVING COUNT(*) >= ALL(
    SELECT COUNT(*)
    FROM Somministrazioni S1 
    WHERE YEAR(S1.[data]) = 2019
    AND MONTH(S1.[data]) = 12
    GROUP BY S1.nome
)
GO 

--5. Modificare la foreign key sulla tabella Somministrazioni in modo che a seguito dell’eliminazione di un Farmaco, le Sommistrazioni di tale Farmaco  facciano riferimento a null.

ALTER TABLE SOMMINISTRAZIONI 
ADD CONSTRAINT FK_FARMACO FOREIGN KEY(NOME) REFERENCES FARMACO(NOME) ON DELETE CASCADE 

--5.2 Modificare la foreign key sulla tabella Esemplare in modo che a seguito dell'update del CF di un Proprietario, i suoi animali facciano riferimento al suo nuovo CF.

ALTER TABLE ESEMPLARE 
ADD CONSTRAINT FK_PROPRIETARIO FOREIGN KEY(cf_Proprietario) REFERENCES PROPRIETARIO(CF) ON UPDATE CASCADE 
GO 

--6. Riportare il nome del farmaco (già somministrato in passato), che è da più tempo che non viene somministrato in una visita.

CREATE VIEW ULTIMA_SOMMINISTRAZIONE AS 
SELECT S.NOME, S.[data]
FROM Somministrazioni S 
GROUP BY S.nome, S.[data]
HAVING S.[data] >= ALL(
    SELECT S1.[data]
    FROM Somministrazioni S1
    WHERE S1.nome = S.nome
)
GO 

SELECT US.nome, US.[data]
FROM ULTIMA_SOMMINISTRAZIONE US
WHERE US.[data] <= ALL(
    SELECT US2.[data]
    FROM ULTIMA_SOMMINISTRAZIONE US2
)
GO 

--6.2 Riportare l’elenco di tutti gli esemplari che hanno subito l'ultima visita più di 3 mesi fa (o 90 giorni fa).

CREATE VIEW ULTIMA_VISITA AS 
SELECT V.Esemplare, V.[data]
FROM VISITA V 
GROUP BY V.Esemplare, V.[data]
HAVING V.[data] >= ALL(
    SELECT V1.[data]
    FROM VISITA V1 
    WHERE V1.Esemplare = V.Esemplare
)
GO 

SELECT E.*
FROM ESEMPLARE E 
        JOIN ULTIMA_VISITA UV ON (E.identificativo = UV.Esemplare)
WHERE DATEDIFF(MONTH, UV.[data], GETDATE()) > 3
GO 

/*SOLUZIONE SENZA VISTA DI SUPPORTO
SELECT distinct E1.*
FROM Esemplare E1 join Visita V on (E1.identificativo=V.Esemplare)
WHERE E1.identificativo NOT IN (
    SELECT E.identificativo
    FROM Esemplare E join Visita V on (E.identificativo=V.Esemplare)
    WHERE DATEDIFF (MM , V.data , GETDATE()) <= 3
)
*/

--7. Visualizzare per ogni visita: il numero totale di farmaci prescritti e il totale del prezzo pagato per i farmaci prescritti (si tenga conto delle dosi di somministrazione di ciascun farmaco) 

SELECT V.Esemplare, V.[data], COUNT(*) AS NFARMACI, SUM(DOSE*PREZZO) AS TOTALE
FROM VISITA V 
        JOIN Somministrazioni S ON (V.Esemplare = S.esemplare AND V.[data] = S.[data])
        JOIN FARMACO F ON (S.nome = F.nome)
GROUP BY V.Esemplare, V.[data]
GO 

--7.2 Visualizzare per ogni proprietario: 
--il numero totale di esemplari in suo possesso ancora in vita (data_morte  dovrà essere null), 
--il totale pagato per le visite di tutti i suoi animali (si faccia riferimento al costo riportato in fattura), 
--il numero di visite medio subito dai suoi esemplari.

CREATE VIEW ANIMALI_VIVI AS 
SELECT P.CF, COUNT(*) AS ANIMALI_VIVI
FROM Proprietario P 
        JOIN Esemplare E ON (P.cf = E.cf_Proprietario)
WHERE E.data_morte IS NULL 
GROUP BY ALL P.cf
GO 

CREATE VIEW ANIMALI_TOTALI AS 
SELECT P.CF, COUNT(*) AS ANIMALI_TOTALI
FROM Proprietario P 
        JOIN Esemplare E ON (P.cf = E.cf_Proprietario) 
GROUP BY ALL P.cf
GO 

SELECT P.NOME, SUM(V.fattura) AS TOTALE, AV.ANIMALI_VIVI, CAST (COUNT(*) AS FLOAT) /  CAST(ATOT.ANIMALI_TOTALI AS FLOAT) AS VISITE_IN_MEDIA--, ATOT.ANIMALI_TOTALI
FROM Proprietario P 
        LEFT JOIN ANIMALI_TOTALI ATOT ON (ATOT.cf = P.CF)
        LEFT JOIN ANIMALI_VIVI AV ON (P.cf = AV.cf)
        LEFT JOIN Esemplare E ON (P.cf = E.cf_Proprietario)
        LEFT JOIN Visita V ON (E.identificativo = V.Esemplare)
GROUP BY ALL P.cf, P.cognome, P.nome, P.data_nascita, AV.ANIMALI_VIVI, ATOT.ANIMALI_TOTALI
GO 
