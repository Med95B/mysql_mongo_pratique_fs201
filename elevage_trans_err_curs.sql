SET autocommit=0;
SELECT nom FROM animal
WHERE `espece_id`=5;
INSERT INTO Animal (nom, espece_id, date_naissance, sexe) 
VALUES ('Buba', 5, '2012-02-13 18:32:00', 'F');
SELECT prix FROM espece
WHERE id=5;
UPDATE espece
SET prix=20
WHERE id=5;
ROLLBACK;
COMMIT;
SELECT commentaires FROM animal
WHERE nom='Bibo' AND `espece_id`=5;

UPDATE animal
set commentaires='Queue coupée'
WHERE nom='Bibo' AND `espece_id`=5;
 
SET AUTOCOMMIT=1;
DESC animal;
INSERT INTO Animal (nom, espece_id, date_naissance, sexe) 
VALUES ('Momyyy', 5, '2008-02-01 02:25:00', 'F');
START TRANSACTION;
SELECT * FROM animal
WHERE `espece_id`=5;
UPDATE animal
set `mere_id`=LAST_INSERT_ID()
WHERE `espece_id`=5 AND nom IN ('baba','buba');
ROLLBACK;
UPDATE animal
set `mere_id`=LAST_INSERT_ID()
WHERE `espece_id`=5 AND nom='bibo';
START TRANSACTION;
DELETE FROM animal
WHERE `espece_id`=5 AND nom='buba';
COMMIT;
START TRANSACTION;
INSERT INTO Animal (nom, espece_id, date_naissance, sexe) 
VALUES ('Popiiii', 5, '2007-03-11 12:45:00', 'M');
SAVEPOINT jalon1;
INSERT INTO Animal (nom, espece_id, date_naissance, sexe) 
VALUES ('Momooooo', 5, '2007-03-12 05:23:00', 'M');
ROLLBACK TO SAVEPOINT jalon1;
INSERT INTO Animal (nom, espece_id, date_naissance, sexe) 
VALUES ('Mimiiiii', 5, '2007-03-12 22:03:00', 'F');
COMMIT;
START TRANSACTION; 
UPDATE Animal     
SET pere_id = 73
WHERE espece_id = 5 AND nom = 'baba';
SELECT id, nom, commentaires, pere_id, mere_id
FROM Animal
WHERE espece_id = 5;
COMMIT;
DELIMITER |
CREATE PROCEDURE ajouter_adoption(IN p_client_id INT, IN p_animal_id INT, IN p_date DATE, IN p_paye TINYINT)
BEGIN
    DECLARE v_prix DECIMAL(7,2);

    SELECT COALESCE(Race.prix, Espece.prix) INTO v_prix
    FROM Animal
    INNER JOIN Espece ON Espece.id = Animal.espece_id
    LEFT JOIN Race ON Race.id = Animal.race_id
    WHERE Animal.id = p_animal_id;

    INSERT INTO Adoption (animal_id, client_id, date_reservation, date_adoption, prix, paye)
    VALUES (p_animal_id, p_client_id, CURRENT_DATE(), p_date, v_prix, p_paye);


    SELECT 'Adoption correctement ajoutée' AS message;
END|
DELIMITER ;
--le client n'existe pas--
SET @date_adoption = CURRENT_DATE() + INTERVAL 7 DAY;
CALL ajouter_adoption(18, 6, @date_adoption, 1);
-- l'animal a déjà été adopté--
CALL ajouter_adoption(12, 21, @date_adoption, 1);
--l'animal n'existe pas, v_prix est donc NULL--
CALL ajouter_adoption(12, 102, @date_adoption, 1);
DELIMITER |
CREATE PROCEDURE ajouter_adoption_exit(IN p_client_id INT, IN p_animal_id INT, IN p_date DATE, IN p_paye TINYINT)
BEGIN
    DECLARE v_prix DECIMAL(7,2);
    DECLARE EXIT HANDLER FOR SQLSTATE '23000' 
        BEGIN
            SELECT 'Une erreur est survenue...';
            SELECT 'Arrêt prématuré de la procédure';
        END;

    SELECT 'Début procédure';

    SELECT COALESCE(Race.prix, Espece.prix) INTO v_prix
    FROM Animal
    INNER JOIN Espece ON Espece.id = Animal.espece_id
    LEFT JOIN Race ON Race.id = Animal.race_id
    WHERE Animal.id = p_animal_id;

    INSERT INTO Adoption (animal_id, client_id, date_reservation, date_adoption, prix, paye)
    VALUES (p_animal_id, p_client_id, CURRENT_DATE(), p_date, v_prix, p_paye);

    SELECT 'Fin procédure' AS message;
END|

CREATE PROCEDURE ajouter_adoption_continue(IN p_client_id INT, IN p_animal_id INT, IN p_date DATE, IN p_paye TINYINT)
BEGIN
    DECLARE v_prix DECIMAL(7,2);
    DECLARE CONTINUE HANDLER FOR SQLSTATE '23000' SELECT 'Une erreur est survenue...';

    SELECT 'Début procédure';

    SELECT COALESCE(Race.prix, Espece.prix) INTO v_prix
    FROM Animal
    INNER JOIN Espece ON Espece.id = Animal.espece_id
    LEFT JOIN Race ON Race.id = Animal.race_id
    WHERE Animal.id = p_animal_id;

    INSERT INTO Adoption (animal_id, client_id, date_reservation, date_adoption, prix, paye)
    VALUES (p_animal_id, p_client_id, CURRENT_DATE(), p_date, v_prix, p_paye);

    SELECT 'Fin procédure';
END|
DELIMITER ;

SET @date_adoption = CURRENT_DATE() + INTERVAL 7 DAY;

CALL ajouter_adoption_exit(18, 6, @date_adoption, 1);
CALL ajouter_adoption_continue(18, 6, @date_adoption, 1);

-- On nomme l'erreur dont l'identifiant est 23000 "violation_contrainte"--
DROP PROCEDURE ajouter_adoption_exit;
DELIMITER |
CREATE PROCEDURE ajouter_adoption_exit(IN p_client_id INT, IN p_animal_id INT, IN p_date DATE, IN p_paye TINYINT)
BEGIN
    DECLARE v_prix DECIMAL(7,2);

    DECLARE violation_contrainte CONDITION FOR SQLSTATE '23000';   

    DECLARE EXIT HANDLER FOR violation_contrainte                  
        BEGIN                                                      
            SELECT 'Une erreur est survenue...';
            SELECT 'Arrêt prématuré de la procédure';
        END;

    SELECT 'Début procédure';

    SELECT COALESCE(Race.prix, Espece.prix) INTO v_prix
    FROM Animal
    INNER JOIN Espece ON Espece.id = Animal.espece_id
    LEFT JOIN Race ON Race.id = Animal.race_id
    WHERE Animal.id = p_animal_id;

    INSERT INTO Adoption (animal_id, client_id, date_reservation, date_adoption, prix, paye)
    VALUES (p_animal_id, p_client_id, CURRENT_DATE(), p_date, v_prix, p_paye);

    SELECT 'Fin procédure';
END|
DELIMITER ;
-- le gestionnaire intercepte toutes les erreurs SQL--
DROP PROCEDURE ajouter_adoption_exit;
DELIMITER |
CREATE PROCEDURE ajouter_adoption_exit(IN p_client_id INT, IN p_animal_id INT, IN p_date DATE, IN p_paye TINYINT)
BEGIN
    DECLARE v_prix DECIMAL(7,2);

    DECLARE EXIT HANDLER FOR SQLEXCEPTION              
        BEGIN
            SELECT 'Une erreur est survenue...';
            SELECT 'Arrêt prématuré de la procédure';
        END;

    SELECT 'Début procédure';

    SELECT COALESCE(Race.prix, Espece.prix) INTO v_prix
    FROM Animal
    INNER JOIN Espece ON Espece.id = Animal.espece_id
    LEFT JOIN Race ON Race.id = Animal.race_id
    WHERE Animal.id = p_animal_id;

    INSERT INTO Adoption (animal_id, client_id, date_reservation, date_adoption, prix, paye)
    VALUES (p_animal_id, p_client_id, CURRENT_DATE(), p_date, v_prix, p_paye);

    SELECT 'Fin procédure';
END|
DELIMITER ;

--déclarer plusieurs gestionnaires dans un même bloc d'instructions.
DROP PROCEDURE ajouter_adoption_exit;
DELIMITER |
CREATE PROCEDURE ajouter_adoption_exit(IN p_client_id INT, IN p_animal_id INT, IN p_date DATE, IN p_paye TINYINT)
BEGIN
    DECLARE v_prix DECIMAL(7,2);

    DECLARE violation_cle_etrangere CONDITION FOR 1452;            -- Déclaration des CONDITIONS
    DECLARE violation_unicite CONDITION FOR 1062;

    DECLARE EXIT HANDLER FOR violation_cle_etrangere               -- Déclaration du gestionnaire pour     
        BEGIN                                                      -- les erreurs de clés étrangères
            SELECT 'Erreur : violation de clé étrangère.';
        END;
    DECLARE EXIT HANDLER FOR violation_unicite                     -- Déclaration du gestionnaire pour
        BEGIN                                                      -- les erreurs d'index unique
            SELECT 'Erreur : violation de contrainte d''unicité.';
        END;
    DECLARE EXIT HANDLER FOR SQLEXCEPTION, SQLWARNING              -- Déclaration du gestionnaire pour
        BEGIN                                                      -- toutes les autres erreurs ou avertissements
            SELECT 'Une erreur est survenue...';
        END;

    SELECT 'Début procédure';

    SELECT COALESCE(Race.prix, Espece.prix) INTO v_prix
    FROM Animal
    INNER JOIN Espece ON Espece.id = Animal.espece_id
    LEFT JOIN Race ON Race.id = Animal.race_id
    WHERE Animal.id = p_animal_id;

    INSERT INTO Adoption (animal_id, client_id, date_reservation, date_adoption, prix, paye)
    VALUES (p_animal_id, p_client_id, CURRENT_DATE(), p_date, v_prix, p_paye);

    SELECT 'Fin procédure';
END|
DELIMITER ;

SET @date_adoption = CURRENT_DATE() + INTERVAL 7 DAY;

CALL ajouter_adoption_exit(12, 3, @date_adoption, 1);        -- Violation unicité (animal 3 est déjà adopté)
CALL ajouter_adoption_exit(133, 6, @date_adoption, 1);       -- Violation clé étrangère (client 133 n'existe pas)
CALL ajouter_adoption_exit(NULL, 6, @date_adoption, 1);      -- Violation de contrainte NOT NULL

--parcourir les deux premières lignes de la table Client avec un curseur.
DELIMITER |
CREATE PROCEDURE parcours_deux_clients()
BEGIN
    DECLARE v_nom, v_prenom VARCHAR(100);

    DECLARE curs_clients CURSOR
        FOR SELECT nom, prenom                                 -- Le SELECT récupère deux colonnes
        FROM Client
        ORDER BY nom, prenom;                                  -- On trie les clients par ordre alphabétique

    OPEN curs_clients;                                         -- Ouverture du curseur

    FETCH curs_clients INTO v_nom, v_prenom;                   -- On récupère la première ligne et on assigne les valeurs récupérées à nos variables locales
    SELECT CONCAT(v_prenom, ' ', v_nom) AS 'Premier client';

    FETCH curs_clients INTO v_nom, v_prenom;                   -- On récupère la seconde ligne et on assigne les valeurs récupérées à nos variables locales
    SELECT CONCAT(v_prenom, ' ', v_nom) AS 'Second client';

    CLOSE curs_clients;                                         -- Fermeture du curseur
END|
DELIMITER ;

CALL parcours_deux_clients();

DELIMITER |
CREATE PROCEDURE test_condition(IN p_ville VARCHAR(100))
BEGIN
    DECLARE v_nom, v_prenom VARCHAR(100);

    DECLARE curs_clients CURSOR
        FOR SELECT nom, prenom
        FROM Client
        WHERE ville = p_ville;

    OPEN curs_clients;                                    

    LOOP                                                  
        FETCH curs_clients INTO v_nom, v_prenom;                   
        SELECT CONCAT(v_prenom, ' ', v_nom) AS 'Client';
    END LOOP;

    CLOSE curs_clients; 
END|
DELIMITER ;
SELECT nom,ville from client;
CALL test_condition('Houtsiplou');
CALL test_condition('Bruxelles');

DELIMITER |
CREATE PROCEDURE test_condition2(IN p_ville VARCHAR(100))
BEGIN
    DECLARE v_nom, v_prenom VARCHAR(100);
    DECLARE fin TINYINT DEFAULT 0;                      -- Variable locale utilisée pour stopper la boucle

    DECLARE curs_clients CURSOR
        FOR SELECT nom, prenom
        FROM Client
        WHERE ville = p_ville;

    DECLARE CONTINUE HANDLER FOR NOT FOUND SET fin = 1; -- Gestionnaire d'erreur pour la condition NOT FOUND

    OPEN curs_clients;                                    

    loop_curseur: LOOP                                                
        FETCH curs_clients INTO v_nom, v_prenom;

        IF fin = 1 THEN                                 -- Structure IF pour quitter la boucle à la fin des résultats
            LEAVE loop_curseur;
        END IF;

        SELECT CONCAT(v_prenom, ' ', v_nom) AS 'Client';
    END LOOP;

    CLOSE curs_clients; 
END|
DELIMITER ;

CALL test_condition2('Houtsiplou');
CALL test_condition2('Bruxelles');
==================================================================================
