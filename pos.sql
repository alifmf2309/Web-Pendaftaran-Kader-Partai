-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Waktu pembuatan: 21 Jul 2024 pada 09.01
-- Versi server: 10.4.32-MariaDB
-- Versi PHP: 8.2.12

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `pos`
--

-- --------------------------------------------------------

--
-- Struktur dari tabel `pos_eksta`
--

CREATE TABLE `pos_eksta` (
  `no_ekta` int(11) NOT NULL,
  `nama` int(11) DEFAULT NULL,
  `foto` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Struktur dari tabel `pos_informasikader`
--

CREATE TABLE `pos_informasikader` (
  `id` int(11) NOT NULL,
  `nama` varchar(100) DEFAULT NULL,
  `alamat` text DEFAULT NULL,
  `tanggal_lahir` date DEFAULT NULL,
  `pekerjaan` varchar(50) DEFAULT NULL,
  `jenis_kelamin` varchar(10) DEFAULT NULL,
  `agama` varchar(50) DEFAULT NULL,
  `foto` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Struktur dari tabel `pos_informasi_pendaftaran`
--

CREATE TABLE `pos_informasi_pendaftaran` (
  `id_pendaftaran` int(11) NOT NULL,
  `nama_kader` int(11) DEFAULT NULL,
  `no_hp` varchar(20) DEFAULT NULL,
  `alasan_bergabung` text DEFAULT NULL,
  `id_kader` int(11) DEFAULT NULL,
  `no_ekta` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Struktur dari tabel `pos_status`
--

CREATE TABLE `pos_status` (
  `id` int(11) NOT NULL,
  `status` varchar(50) DEFAULT NULL,
  `tanggal_daftar` date DEFAULT NULL,
  `id_pendaftaran` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Indexes for dumped tables
--

--
-- Indeks untuk tabel `pos_eksta`
--
ALTER TABLE `pos_eksta`
  ADD PRIMARY KEY (`no_ekta`),
  ADD KEY `nama` (`nama`),
  ADD KEY `foto` (`foto`);

--
-- Indeks untuk tabel `pos_informasikader`
--
ALTER TABLE `pos_informasikader`
  ADD PRIMARY KEY (`id`);

--
-- Indeks untuk tabel `pos_informasi_pendaftaran`
--
ALTER TABLE `pos_informasi_pendaftaran`
  ADD PRIMARY KEY (`id_pendaftaran`),
  ADD KEY `nama_kader` (`nama_kader`),
  ADD KEY `id_kader` (`id_kader`),
  ADD KEY `no_ekta` (`no_ekta`);

--
-- Indeks untuk tabel `pos_status`
--
ALTER TABLE `pos_status`
  ADD PRIMARY KEY (`id`),
  ADD KEY `id_pendaftaran` (`id_pendaftaran`);

--
-- Ketidakleluasaan untuk tabel pelimpahan (Dumped Tables)
--

--
-- Ketidakleluasaan untuk tabel `pos_eksta`
--
ALTER TABLE `pos_eksta`
  ADD CONSTRAINT `pos_eksta_ibfk_1` FOREIGN KEY (`nama`) REFERENCES `pos_informasikader` (`id`),
  ADD CONSTRAINT `pos_eksta_ibfk_2` FOREIGN KEY (`foto`) REFERENCES `pos_informasikader` (`id`);

--
-- Ketidakleluasaan untuk tabel `pos_informasi_pendaftaran`
--
ALTER TABLE `pos_informasi_pendaftaran`
  ADD CONSTRAINT `pos_informasi_pendaftaran_ibfk_1` FOREIGN KEY (`nama_kader`) REFERENCES `pos_informasikader` (`id`),
  ADD CONSTRAINT `pos_informasi_pendaftaran_ibfk_2` FOREIGN KEY (`id_kader`) REFERENCES `pos_informasikader` (`id`),
  ADD CONSTRAINT `pos_informasi_pendaftaran_ibfk_3` FOREIGN KEY (`no_ekta`) REFERENCES `pos_eksta` (`no_ekta`);

--
-- Ketidakleluasaan untuk tabel `pos_status`
--
ALTER TABLE `pos_status`
  ADD CONSTRAINT `pos_status_ibfk_1` FOREIGN KEY (`id_pendaftaran`) REFERENCES `pos_informasi_pendaftaran` (`id_pendaftaran`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
