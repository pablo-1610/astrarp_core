CREATE TABLE `astra_luckwheel_paid` (
  `license` varchar(80) NOT NULL,
  `ammount` int(11) NOT NULL DEFAULT 1
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

ALTER TABLE `astra_luckwheel_paid`
  ADD PRIMARY KEY (`license`);
COMMIT;
