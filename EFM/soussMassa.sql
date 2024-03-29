DELIMITER //

CREATE FUNCTION ProjetsDansServiceSystemeInfo()
RETURNS VARCHAR(255)
BEGIN
    DECLARE projects_list VARCHAR(255);
    
    SELECT GROUP_CONCAT(DISTINCT p.NomPrj SEPARATOR ', ')
    INTO projects_list
    FROM Projet p
    INNER JOIN Participation par ON p.CodePrj = par.CodeProjet#
    INNER JOIN Salarie s ON par.Matricule# = s.Matricule
    INNER JOIN Service se ON s.NumSer# = se.NumService
    WHERE se.NomService = 'Système d’information';
    
    IF projects_list IS NULL THEN
        SET projects_list = 'Aucun projet trouvé pour le service Système d’information.';
    END IF;
    
    RETURN projects_list;
END//

DELIMITER ;
==========================================================
DELIMITER //

CREATE FUNCTION CalculerJoursTravailles(
    salarieID INT
)
RETURNS INT
BEGIN
    DECLARE total_jours INT DEFAULT 0;

    SELECT SUM(NbrJours) INTO total_jours
    FROM Participation
    WHERE Matricule# = salarieID;

    IF total_jours IS NULL THEN
        SET total_jours = 0;
    END IF;

    RETURN total_jours;
END//

DELIMITER ;
==========================================================
DELIMITER //

CREATE PROCEDURE NombreJoursParEmployeProjet(
    IN employeID INT,
    IN projetID INT,
    OUT jours_effectues INT
)
BEGIN
    SELECT NbrJours INTO jours_effectues
    FROM Participation
    WHERE Matricule# = employeID AND CodeProjet# = projetID;

    IF jours_effectues IS NULL THEN
        SET jours_effectues = 0;
    END IF;
END//

DELIMITER ;
============================================================
DELIMITER //

CREATE PROCEDURE AttribuerPrimeDansService(IN serviceID INT)
BEGIN
    DECLARE prime_value DECIMAL(10, 2);
    
    -- Calcul de la prime (80% du salaire)
    SET prime_value = 0.8; -- 80%
    
    UPDATE Salarie s
    INNER JOIN Service se ON s.NumSer# = se.NumService
    SET s.prime = s.Salaire * prime_value
    WHERE se.NumService = serviceID;
    
    SELECT CONCAT('Prime de ', prime_value * 100, '% du salaire attribuée aux employés du service ', serviceID) AS Resultat;
END//

DELIMITER ;
=====================================================
DELIMITER //

CREATE PROCEDURE AugmenterSalaire()
BEGIN
    UPDATE Salarie
    SET Salaire = Salaire * 1.05; -- Augmentation de 5%
END//

DELIMITER ;
====================================================================
DELIMITER //

CREATE TRIGGER prevent_delete_account
BEFORE DELETE ON compte
FOR EACH ROW
BEGIN
    DECLARE last_op_date DATE;
    DECLARE diff_months INT;
    
    -- Récupérer la date de la dernière opération sur ce compte
    SELECT MAX(dateOp) INTO last_op_date
    FROM operation
    WHERE numCpt = OLD.numCpt;

    -- Vérifier si le compte a une opération datant de moins de 3 mois
    SET diff_months = TIMESTAMPDIFF(MONTH, last_op_date, NOW());
    
    IF OLD.soleCpt > 0 OR diff_months < 3 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Impossible de supprimer le compte : solde non nul ou opération récente.';
    END IF;

END//

DELIMITER ;
===============================================================================
DELIMITER //

CREATE TRIGGER check_new_account
BEFORE INSERT ON compte
FOR EACH ROW
BEGIN
    DECLARE compte_type_exist INT;
    
    -- Vérifier le solde et le type de compte
    IF NEW.soleCpt <= 5000 OR (NEW.typeCpt <> 'CC' AND NEW.typeCpt <> 'CN') THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Le solde doit être supérieur à 5000 DH et le type de compte doit être CC ou CN.';
    END IF;

    -- Vérifier si le client a déjà un compte du même type
    SELECT COUNT(*) INTO compte_type_exist
    FROM compte
    WHERE numCli = NEW.numCli AND typeCpt = NEW.typeCpt;

    IF compte_type_exist > 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Le client a déjà un compte du même type.';
    END IF;

END//

DELIMITER ;
=================================================================================
DELIMITER //
CREATE TRIGGER check_compte_conditions_trigger BEFORE INSERT ON compte_test
FOR EACH ROW
BEGIN
    IF NEW.soleCpt <= 5000 OR (NEW.typeCpt <> 'CC' AND NEW.typeCpt <> 'CN') THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Le solde doit être supérieur à 5000 DH et le type de compte doit être CC ou CN.';
    END IF;
END //
DELIMITER ;
=========================================================================
