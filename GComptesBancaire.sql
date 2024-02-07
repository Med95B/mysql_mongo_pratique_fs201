CREATE DATABASE GComptesBancaire
    DEFAULT CHARACTER SET = 'utf8mb4';
USE GComptesBancaire;
CREATE TABLE Client (
  CIN INT PRIMARY KEY,
  nom VARCHAR(255) NOT NULL,
  prenom VARCHAR(255) NOT NULL,
  adr VARCHAR(255) NOT NULL,
  tel VARCHAR(20) NOT NULL
);
CREATE TABLE Compte (
  NumCompte INT PRIMARY KEY AUTO_INCREMENT,
  solde DECIMAL(10,2) NOT NULL,
  TypeCompte CHAR(2) CHECK (TypeCompte IN ('CC', 'CE')),
  NumCl INT,
  FOREIGN KEY (NumCl) REFERENCES Client(CIN)
);
CREATE TABLE Operation (
  NumOP INT PRIMARY KEY AUTO_INCREMENT,
  TypeOp CHAR(1) NOT NULL,
  MontantOp DECIMAL(10,2) NOT NULL,
  NumCpt INT,
  DateOp DATE DEFAULT CURRENT_DATE,
  FOREIGN KEY (NumCpt) REFERENCES Compte(NumCompte)
);


-- declencheur AJOUT_COMPTE_SOLDE <=1500
DELIMITER //
CREATE TRIGGER AJOUT_COMPTE_CC_SOLDE
BEFORE INSERT ON Compte FOR EACH ROW
BEGIN
    IF NEW.TypeCompte = 'CC' AND NEW.solde <= 1500.00 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Le solde d\'un compte de type CC doit être supérieur à 1500.00 DH';
    END IF;
END;
//
DELIMITER ;

-- insertion d'un compte cc ayant solde <=1500
INSERT INTO Client (CIN, nom, prenom, adr, tel) VALUES
('1234567899', 'med', 'med', 'adress ', '066666666');

INSERT INTO Compte (NumCompte, solde, TypeCompte, NumCl) VALUES
(16, 1000.00, 'CC', '123456789');
INSERT INTO Compte (NumCompte, solde, TypeCompte, NumCl) VALUES
(21, 2000.00, 'CC', '123456789');

-- declencheur AJOUT_PLUSIEUR_CC
DELIMITER //
CREATE TRIGGER AJOUT_COMPTE_PLUSIEURS_CC
BEFORE INSERT ON Compte FOR EACH ROW
BEGIN
    IF NEW.TypeCompte = 'CC' AND EXISTS (
        SELECT 1 FROM Compte WHERE NumCl = NEW.NumCl AND TypeCompte = 'CC'
    ) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Un client ne peut avoir qu\'un seul compte de type CC';
    END IF;
END;
//
DELIMITER ;
-- creation d'un compte CC pour un client ayant deja un compte CC
INSERT INTO Compte (NumCompte, solde, TypeCompte, NumCl)
VALUES (10, 2000.00, 'CC', '123456789');

-- declencheur SUPPRESSION_SOLDE_NON_NUL
DELIMITER //
CREATE TRIGGER SUPPRESSION_COMPTE
BEFORE DELETE ON Compte FOR EACH ROW
BEGIN
    IF OLD.solde <> 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Impossible de supprimer un compte avec un solde non nul';
    END IF;
END;
//
DELIMITER ;
SELECT * FROM compte;
-- suppression d'un compte ayant solde non nul
DELETE FROM Compte WHERE NumCompte = 10;

-- declencheur UPDATE_COMPTE
DELIMITER //
CREATE TRIGGER UPDATE_COMPTE
BEFORE UPDATE ON Compte FOR EACH ROW
BEGIN
    IF NEW.TypeCompte <> OLD.TypeCompte AND EXISTS (
        SELECT 1 FROM Operation WHERE NumCpt = NEW.NumCompte
    ) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Impossible de modifier le type de compte pour un compte avec des opérations associées';
    END IF;
END;
//
DELIMITER ;
-- Inserer un compte avec operations associees
INSERT INTO Compte (NumCompte, solde, TypeCompte, NumCl) VALUES (1, 5000.00, 'CC', '1234567899');
INSERT INTO Operation (NumOP, TypeOp, MontantOp, NumCpt) VALUES (101, 'Dépôt', 500.00, 1);
-- mettre a jour le type de compte 
UPDATE Compte SET TypeCompte = 'CE' WHERE NumCompte = 1;


SHOW TRIGGERS;