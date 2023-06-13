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

--5. Modificare la foreign key sulla tabella Somministrazioni in modo che a seguito dell’eliminazione di un Farmaco, le Sommistrazioni di tale Farmaco  facciano riferimento a null.




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

--7. Visualizzare per ogni visita: il numero totale di farmaci prescritti e il totale del prezzo pagato per i farmaci prescritti (si tenga conto delle dosi di somministrazione di ciascun farmaco) 

SELECT V.Esemplare, V.[data], COUNT(*) AS NFARMACI, SUM(DOSE*PREZZO) AS TOTALE
FROM VISITA V 
        JOIN Somministrazioni S ON (V.Esemplare = S.esemplare AND V.[data] = S.[data])
        JOIN FARMACO F ON (S.nome = F.nome)
GROUP BY V.Esemplare, V.[data]