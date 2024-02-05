SELECT NomLog, PrixLog
FROM Logiciel
JOIN Projet ON Logiciel.NumProj = Projet.NumProj
WHERE Projet.TitreProj = 'gestion de stock'
ORDER BY PrixLog DESC;
//=========================================================
SELECT TitreProj, SUM(PrixLog) AS total_prix
FROM Projet
JOIN Logiciel ON Projet.NumProj = Logiciel.NumProj
WHERE Projet.NumProj = 10
GROUP BY titre;
//=========================================================
SELECT NumProj, COUNT(DISTINCT NumDev) AS nombre_Developpeurs
FROM Realisation
GROUP BY NumProj;

//=========================================================
SELECT NumProj, COUNT(*) AS nombre_logiciels
FROM Logiciel
GROUP BY NumProj
HAVING COUNT(*) > 5;

//=========================================================
SELECT NumDev, NomDev
FROM Developpeur
WHERE NOT EXISTS (
    SELECT NumProj
    FROM Projet
    WHERE NOT EXISTS (
        SELECT *
        FROM Realisation
        WHERE Realisation.NumProj = Projet.NumProj
        AND Realisation.NumDev = Developpeur.NumDev
    )
);

SELECT DISTINCT d.NumDev, d.NomDev
FROM Developpeur d
INNER JOIN Realisation r ON d.NumDev = r.NumDev
INNER JOIN Projet p ON r.NumProj = p.NumProj;

//=========================================================
SELECT NumProj
FROM Projet
GROUP BY NumProj
HAVING COUNT(DISTINCT NumDev) = (
    SELECT COUNT(DISTINCT NumDev)
    FROM Developpeur
);

//=========================================================
