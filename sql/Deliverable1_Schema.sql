CREATE DATABASE IF NOT EXISTS food_delivery;
USE food_delivery;

SET FOREIGN_KEY_CHECKS = 0;
DROP TABLE IF EXISTS `MenuItem`, `Driver`, `Restaurant`, `Customer`;
SET FOREIGN_KEY_CHECKS = 1;

-- -----------------------
-- Customer
-- -----------------------
CREATE TABLE `Customer` (
  `CustomerID`     BIGINT AUTO_INCREMENT PRIMARY KEY,
  `Email`          VARCHAR(255) NOT NULL UNIQUE,
  `Name`           VARCHAR(120) NOT NULL,
  `Phone`          VARCHAR(40),
  `Address`        VARCHAR(400),
  `AccountStatus`  ENUM('active','suspended','closed') NOT NULL DEFAULT 'active'
) ENGINE=InnoDB;

-- -----------------------
-- Restaurant
-- -----------------------
CREATE TABLE `Restaurant` (
  `RestaurantID`   BIGINT AUTO_INCREMENT PRIMARY KEY,
  `Name`           VARCHAR(160) NOT NULL,
  `Location`       VARCHAR(300),
  `CuisineType`    VARCHAR(80),
  `Phone`          VARCHAR(40),
  `Status`         ENUM('open','closed','inactive') NOT NULL DEFAULT 'open'
) ENGINE=InnoDB;

-- -----------------------
-- Driver
-- -----------------------
CREATE TABLE `Driver` (
  `DriverID`        BIGINT AUTO_INCREMENT PRIMARY KEY,
  `Name`            VARCHAR(120) NOT NULL,
  `VehicleType`     VARCHAR(80),
  `Phone`           VARCHAR(40),
  `Status`          ENUM('active','inactive','suspended') NOT NULL DEFAULT 'active',
  `CommissionRate`  DECIMAL(5,2) NOT NULL DEFAULT 0.00,
  CHECK (`CommissionRate` >= 0 AND `CommissionRate` <= 100)
) ENGINE=InnoDB;

-- -----------------------
-- MenuItem (ties to Restaurant)
-- -----------------------
CREATE TABLE `MenuItem` (
  `ItemID`        BIGINT AUTO_INCREMENT PRIMARY KEY,
  `RestaurantID`  BIGINT NOT NULL,
  `ItemName`      VARCHAR(160) NOT NULL,
  `Description`   TEXT,
  `Price`         DECIMAL(10,2) NOT NULL,
  `Availability`  BOOLEAN NOT NULL DEFAULT TRUE,
  CONSTRAINT `fk_menuitem_restaurant`
    FOREIGN KEY (`RestaurantID`) REFERENCES `Restaurant`(`RestaurantID`)
    ON UPDATE CASCADE ON DELETE RESTRICT,
  CONSTRAINT `uq_item_per_rest` UNIQUE (`RestaurantID`, `ItemName`),
  CHECK (`Price` >= 0)
) ENGINE=InnoDB;


CREATE TABLE `Order` (
  `OrderID`         BIGINT AUTO_INCREMENT PRIMARY KEY,
  `CustomerID`      BIGINT NOT NULL,
  `RestaurantID`    BIGINT NOT NULL,
  `DriverID`        BIGINT NULL,
  `OrderDateTime`   DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `Status`          ENUM('placed','preparing','out_for_delivery','delivered','cancelled')
                    NOT NULL DEFAULT 'placed',
  `DeliveryAddress` VARCHAR(400),

  CONSTRAINT `fk_order_customer`
    FOREIGN KEY (`CustomerID`) REFERENCES `Customer`(`CustomerID`)
    ON UPDATE CASCADE ON DELETE RESTRICT,
  CONSTRAINT `fk_order_restaurant`
    FOREIGN KEY (`RestaurantID`) REFERENCES `Restaurant`(`RestaurantID`)
    ON UPDATE CASCADE ON DELETE RESTRICT,
  CONSTRAINT `fk_order_driver`
    FOREIGN KEY (`DriverID`) REFERENCES `Driver`(`DriverID`)
    ON UPDATE CASCADE ON DELETE SET NULL
) ENGINE=InnoDB;

-- -----------------------
-- Payment (1:1 with Order)
-- -----------------------
CREATE TABLE `Payment` (
  `PaymentID`        BIGINT AUTO_INCREMENT PRIMARY KEY,
  `OrderID`          BIGINT NOT NULL,
  `Amount`           DECIMAL(10,2) NOT NULL,
  `PaymentMethod`    ENUM('card','cash','wallet','other') NOT NULL,
  `PaymentTimestamp` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `Status`           ENUM('authorized','captured','refunded','failed','cancelled')
                     NOT NULL DEFAULT 'captured',

  CONSTRAINT `uq_payment_order` UNIQUE (`OrderID`),
  CONSTRAINT `fk_payment_order`
    FOREIGN KEY (`OrderID`) REFERENCES `Order`(`OrderID`)
    ON UPDATE CASCADE ON DELETE CASCADE,
  CHECK (`Amount` >= 0)
) ENGINE=InnoDB;

-- -----------------------
-- OrderDetail (junction)
-- -----------------------
CREATE TABLE `OrderDetail` (
  `OrderID`   BIGINT NOT NULL,
  `ItemID`    BIGINT NOT NULL,
  `Quantity`  INT NOT NULL,
  `ItemPrice` DECIMAL(10,2) NOT NULL,
  PRIMARY KEY (`OrderID`, `ItemID`),

  CONSTRAINT `fk_orderdetail_order`
    FOREIGN KEY (`OrderID`) REFERENCES `Order`(`OrderID`)
    ON UPDATE CASCADE ON DELETE CASCADE,
  CONSTRAINT `fk_orderdetail_menuitem`
    FOREIGN KEY (`ItemID`) REFERENCES `MenuItem`(`ItemID`)
    ON UPDATE CASCADE ON DELETE RESTRICT,
  CHECK (`Quantity` >= 1),
  CHECK (`ItemPrice` >= 0)
) ENGINE=InnoDB;

-- -----------------------
-- Review (restaurant_id and driver_id are nullable)
-- -----------------------
CREATE TABLE `Review` (
  `ReviewID`     BIGINT AUTO_INCREMENT PRIMARY KEY,
  `CustomerID`   BIGINT NOT NULL,
  `RestaurantID` BIGINT NULL,
  `DriverID`     BIGINT NULL,
  `Rating`       TINYINT NOT NULL,
  `Comment`      TEXT,
  `ReviewDate`   DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,

  CONSTRAINT `fk_review_customer`
    FOREIGN KEY (`CustomerID`) REFERENCES `Customer`(`CustomerID`)
    ON UPDATE CASCADE ON DELETE CASCADE,
  CONSTRAINT `fk_review_restaurant`
    FOREIGN KEY (`RestaurantID`) REFERENCES `Restaurant`(`RestaurantID`)
    ON UPDATE CASCADE ON DELETE SET NULL,
  CONSTRAINT `fk_review_driver`
    FOREIGN KEY (`DriverID`) REFERENCES `Driver`(`DriverID`)
    ON UPDATE CASCADE ON DELETE SET NULL,
  CHECK (`Rating` BETWEEN 1 AND 5)
) ENGINE=InnoDB;

