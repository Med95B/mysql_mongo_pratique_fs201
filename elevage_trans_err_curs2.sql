SELECT commentaires FROM animal
WHERE nom='Bibo' AND `espece_id`=5;
START TRANSACTION;   
SELECT id, nom, commentaires, pere_id, mere_id
FROM Animal
WHERE espece_id = 5;
UPDATE Animal       
SET commentaires = 'Agressif'
WHERE espece_id = 5 AND nom = 'baba';
SELECT id, nom, commentaires, pere_id, mere_id
FROM Animal
WHERE espece_id = 5;
COMMIT;