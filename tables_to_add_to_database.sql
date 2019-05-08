DROP TABLE IF EXISTS `sql_scripts`;
CREATE TABLE IF NOT EXISTS `sql_scripts` (
  `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT,
  `scriptname` varchar(90) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Table structure for table `versiontable`
--

DROP TABLE IF EXISTS `versiontable`;
CREATE TABLE IF NOT EXISTS `versiontable` (
  `version` int(10) UNSIGNED NOT NULL
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

--
-- Dumping data for table `versiontable`
--

INSERT INTO `versiontable` (`version`) VALUES
(0);
COMMIT;
