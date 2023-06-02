-- phpMyAdmin SQL Dump
-- version 5.2.0
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Mar 31, 2023 at 11:20 PM
-- Server version: 10.4.27-MariaDB
-- PHP Version: 8.2.0

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `diam`
--

-- --------------------------------------------------------

--
-- Table structure for table `encomenda`
--

CREATE TABLE `encomenda` (
  `Id` int(11) NOT NULL,
  `IdUser` int(11) NOT NULL,
  `Data` datetime NOT NULL,
  `Total` decimal(4,2) NOT NULL,
  `Recebido?` smallint(6) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_bin;

-- --------------------------------------------------------

--
-- Table structure for table `produto`
--

CREATE TABLE `produto` (
  `Id` int(11) NOT NULL,
  `Stock` int(11) NOT NULL,
  `Imagem` varchar(150) NOT NULL,
  `PreçoUnitário` decimal(4,2) NOT NULL,
  `Descrição` varchar(50) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_bin;

-- --------------------------------------------------------

--
-- Table structure for table `produtoencomenda`
--

CREATE TABLE `produtoencomenda` (
  `IdEncomenda` int(11) NOT NULL,
  `IdProduto` int(11) NOT NULL,
  `Quantidade` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_bin;

-- --------------------------------------------------------

--
-- Table structure for table `produtoreserva`
--

CREATE TABLE `produtoreserva` (
  `IdReserva` int(11) NOT NULL,
  `IdProduto` int(11) NOT NULL,
  `Quantidade` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_bin;

-- --------------------------------------------------------

--
-- Table structure for table `produtovenda`
--

CREATE TABLE `produtovenda` (
  `IdVenda` int(11) NOT NULL,
  `IdProduto` int(11) NOT NULL,
  `Quantidade` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_bin;

-- --------------------------------------------------------

--
-- Table structure for table `reserva`
--

CREATE TABLE `reserva` (
  `Id` int(11) NOT NULL,
  `IdUser` int(11) NOT NULL,
  `IdVenda` int(11) DEFAULT NULL,
  `Data` datetime NOT NULL,
  `PreçoTotal` decimal(4,2) NOT NULL,
  `NomeCliente` varchar(100) NOT NULL,
  `EndereçoCliente` varchar(150) NOT NULL,
  `ContactoCliente` varchar(100) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_bin;

-- --------------------------------------------------------

--
-- Table structure for table `user`
--

CREATE TABLE `user` (
  `Id` int(11) NOT NULL,
  `Username` varchar(30) NOT NULL,
  `Password` varchar(30) NOT NULL,
  `Email` varchar(40) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_bin;

-- --------------------------------------------------------

--
-- Table structure for table `userextension`
--

CREATE TABLE `userextension` (
  `IdUser` int(11) NOT NULL,
  `Tipo` enum('Admin','Gestor','Vendedor') NOT NULL,
  `Imagem` varchar(150) NOT NULL,
  `Ativo?` smallint(6) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_bin;

-- --------------------------------------------------------

--
-- Table structure for table `venda`
--

CREATE TABLE `venda` (
  `Id` int(11) NOT NULL,
  `IdUser` int(11) NOT NULL,
  `Data` datetime NOT NULL,
  `PreçoTotal` decimal(4,2) NOT NULL,
  `NomeCliente` varchar(100) NOT NULL,
  `EndereçoCliente` varchar(150) NOT NULL,
  `ContactoCliente` varchar(100) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_bin;

--
-- Indexes for dumped tables
--

--
-- Indexes for table `encomenda`
--
ALTER TABLE `encomenda`
  ADD PRIMARY KEY (`Id`),
  ADD KEY `FK_ENCOMENDA_USER` (`IdUser`);

--
-- Indexes for table `produto`
--
ALTER TABLE `produto`
  ADD PRIMARY KEY (`Id`);

--
-- Indexes for table `produtoencomenda`
--
ALTER TABLE `produtoencomenda`
  ADD PRIMARY KEY (`IdEncomenda`,`IdProduto`),
  ADD KEY `FK_PRODUTOENCOMENDA_PRODUTO` (`IdProduto`);

--
-- Indexes for table `produtoreserva`
--
ALTER TABLE `produtoreserva`
  ADD PRIMARY KEY (`IdReserva`,`IdProduto`),
  ADD KEY `FK_PRODUTORESERVA_PRODUTO` (`IdProduto`);

--
-- Indexes for table `produtovenda`
--
ALTER TABLE `produtovenda`
  ADD PRIMARY KEY (`IdVenda`,`IdProduto`),
  ADD KEY `FK_PRODUTOVENDA_PRODUTO` (`IdProduto`);

--
-- Indexes for table `reserva`
--
ALTER TABLE `reserva`
  ADD PRIMARY KEY (`Id`),
  ADD KEY `FK_RESERVA_VENDA` (`IdVenda`),
  ADD KEY `FK_RESERVA_USER` (`IdUser`);

--
-- Indexes for table `user`
--
ALTER TABLE `user`
  ADD PRIMARY KEY (`Id`);

--
-- Indexes for table `userextension`
--
ALTER TABLE `userextension`
  ADD PRIMARY KEY (`IdUser`);

--
-- Indexes for table `venda`
--
ALTER TABLE `venda`
  ADD PRIMARY KEY (`Id`),
  ADD KEY `FK_VENDA_USER` (`IdUser`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `produto`
--
ALTER TABLE `produto`
  MODIFY `Id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `reserva`
--
ALTER TABLE `reserva`
  MODIFY `Id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `user`
--
ALTER TABLE `user`
  MODIFY `Id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `venda`
--
ALTER TABLE `venda`
  MODIFY `Id` int(11) NOT NULL AUTO_INCREMENT;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `encomenda`
--
ALTER TABLE `encomenda`
  ADD CONSTRAINT `FK_ENCOMENDA_USER` FOREIGN KEY (`IdUser`) REFERENCES `user` (`Id`) ON UPDATE CASCADE;

--
-- Constraints for table `produtoencomenda`
--
ALTER TABLE `produtoencomenda`
  ADD CONSTRAINT `FK_PRODUTOENCOMENDA_ENCOMENDA` FOREIGN KEY (`IdEncomenda`) REFERENCES `encomenda` (`Id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `FK_PRODUTOENCOMENDA_PRODUTO` FOREIGN KEY (`IdProduto`) REFERENCES `produto` (`Id`) ON UPDATE CASCADE;

--
-- Constraints for table `produtoreserva`
--
ALTER TABLE `produtoreserva`
  ADD CONSTRAINT `FK_PRODUTORESERVA_PRODUTO` FOREIGN KEY (`IdProduto`) REFERENCES `produto` (`Id`) ON UPDATE CASCADE,
  ADD CONSTRAINT `FK_PRODUTORESERVA_RESERVA` FOREIGN KEY (`IdReserva`) REFERENCES `reserva` (`Id`) ON UPDATE CASCADE;

--
-- Constraints for table `produtovenda`
--
ALTER TABLE `produtovenda`
  ADD CONSTRAINT `FK_PRODUTOVENDA_PRODUTO` FOREIGN KEY (`IdProduto`) REFERENCES `produto` (`Id`) ON UPDATE CASCADE,
  ADD CONSTRAINT `FK_PRODUTOVENDA_VENDA` FOREIGN KEY (`IdVenda`) REFERENCES `venda` (`Id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `reserva`
--
ALTER TABLE `reserva`
  ADD CONSTRAINT `FK_RESERVA_USER` FOREIGN KEY (`IdUser`) REFERENCES `user` (`Id`) ON UPDATE CASCADE,
  ADD CONSTRAINT `FK_RESERVA_VENDA` FOREIGN KEY (`IdVenda`) REFERENCES `venda` (`Id`) ON DELETE SET NULL ON UPDATE CASCADE;

--
-- Constraints for table `userextension`
--
ALTER TABLE `userextension`
  ADD CONSTRAINT `FK_USEREXTENSION_USER` FOREIGN KEY (`IdUser`) REFERENCES `user` (`Id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `venda`
--
ALTER TABLE `venda`
  ADD CONSTRAINT `FK_VENDA_USER` FOREIGN KEY (`IdUser`) REFERENCES `user` (`Id`) ON UPDATE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
