CREATE TABLE `astra_ammunation` (
  `id` int(11) NOT NULL,
  `weapon` varchar(80) NOT NULL,
  `label` varchar(90) NOT NULL,
  `price` int(10) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

ALTER TABLE `astra_ammunation`
  ADD PRIMARY KEY (`id`);

ALTER TABLE `astra_ammunation`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;
COMMIT;