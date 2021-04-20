CREATE TABLE `astra_level` (
  `license` varchar(80) NOT NULL,
  `exp` int(80) NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

ALTER TABLE `astra_level`
  ADD PRIMARY KEY (`license`);
COMMIT;