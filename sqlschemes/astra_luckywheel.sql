CREATE TABLE `astra_luckywheel` (
  `license` varchar(80) NOT NULL,
  `time` int(255) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

ALTER TABLE `astra_luckywheel`
  ADD PRIMARY KEY (`license`);
COMMIT;
