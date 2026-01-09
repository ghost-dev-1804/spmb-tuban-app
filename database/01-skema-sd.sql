-- ==========================================
-- SKEMA DATABASE SD (Sekolah Dasar)
-- ==========================================

-- Hapus tabel lama jika ada (Reset)
DROP TABLE IF EXISTS dokumen_siswa CASCADE;
DROP TABLE IF EXISTS pendaftaran CASCADE;
DROP TABLE IF EXISTS siswa CASCADE;
DROP TABLE IF EXISTS sekolah CASCADE;
DROP TABLE IF EXISTS users CASCADE;

-- 1. TABEL PENGGUNA (Admin Dinas & Operator Sekolah)
CREATE TABLE users (
    id SERIAL PRIMARY KEY,
    username VARCHAR(50) UNIQUE NOT NULL,
    password_hash VARCHAR(255) NOT NULL,
    role VARCHAR(20) NOT NULL CHECK (role IN ('admin_dinas', 'operator_sekolah')),
    sekolah_id INT, -- NULL jika admin dinas
    nama_lengkap VARCHAR(100),
    last_login TIMESTAMP,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 2. MASTER DATA SEKOLAH
CREATE TABLE sekolah (
    id SERIAL PRIMARY KEY,
    npsn VARCHAR(10) UNIQUE NOT NULL,
    nama_sekolah VARCHAR(100) NOT NULL,
    alamat TEXT,
    kecamatan VARCHAR(50), -- Penting untuk filter wilayah
    kelurahan VARCHAR(50),
    latitude DOUBLE PRECISION,  -- Titik koordinat sekolah
    longitude DOUBLE PRECISION, 
    kuota_total INT DEFAULT 0,
    -- Rincian Kuota sesuai Juknis
    kuota_zonasi INT DEFAULT 0,
    kuota_afirmasi INT DEFAULT 0,
    kuota_mutasi INT DEFAULT 0,
    is_active BOOLEAN DEFAULT TRUE
);

-- 3. DATA CALON SISWA
CREATE TABLE siswa (
    id SERIAL PRIMARY KEY,
    nik VARCHAR(16) UNIQUE NOT NULL, -- Kunci unik siswa
    nisn VARCHAR(10), -- Opsional untuk SD (biasanya dari TK)
    nama_lengkap VARCHAR(100) NOT NULL,
    tempat_lahir VARCHAR(50),
    tanggal_lahir DATE NOT NULL, -- SANGAT PENTING di SD (Skor Usia)
    jenis_kelamin CHAR(1) CHECK (jenis_kelamin IN ('L', 'P')),
    nama_ibu_kandung VARCHAR(100),
    alamat_kk TEXT NOT NULL,
    kecamatan_kk VARCHAR(50),
    kelurahan_kk VARCHAR(50),
    latitude_kk DOUBLE PRECISION, -- Koordinat rumah siswa
    longitude_kk DOUBLE PRECISION,
    no_hp_ortu VARCHAR(15),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 4. TRANSAKSI PENDAFTARAN (CORE)
CREATE TABLE pendaftaran (
    id SERIAL PRIMARY KEY,
    kode_pendaftaran VARCHAR(25) UNIQUE NOT NULL, -- Contoh: SD-2025-0001
    siswa_id INT REFERENCES siswa(id) ON DELETE CASCADE,
    sekolah_tujuan_id INT REFERENCES sekolah(id),
    
    -- Jalur Pendaftaran
    jalur VARCHAR(20) NOT NULL CHECK (jalur IN ('zonasi', 'afirmasi', 'mutasi')),
    
    -- Data untuk Peranking/Seleksi
    jarak_meter DOUBLE PRECISION DEFAULT 0, -- Jarak Rumah ke Sekolah
    usia_bulan INT DEFAULT 0, -- Usia siswa dalam bulan saat mendaftar
    
    -- Status Workflow
    status_verifikasi VARCHAR(20) DEFAULT 'menunggu' CHECK (status_verifikasi IN ('menunggu', 'disetujui', 'ditolak')),
    status_seleksi VARCHAR(20) DEFAULT 'proses' CHECK (status_seleksi IN ('proses', 'diterima', 'cadangan', 'gagal')),
    
    keterangan_status TEXT, -- Alasan jika ditolak
    waktu_daftar TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    
    -- Mencegah siswa daftar ganda di sekolah yang sama (opsional: bisa diatur di backend)
    UNIQUE(siswa_id, sekolah_tujuan_id)
);

-- 5. DOKUMEN PENDUKUNG
CREATE TABLE dokumen_siswa (
    id SERIAL PRIMARY KEY,
    pendaftaran_id INT REFERENCES pendaftaran(id) ON DELETE CASCADE,
    jenis_dokumen VARCHAR(50), -- 'kk', 'akta', 'surat_mutasi', 'kip'
    file_path VARCHAR(255) NOT NULL,
    uploaded_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- SEEDING DATA DUMMY (Untuk Tes Awal)
INSERT INTO users (username, password_hash, role, nama_lengkap) 
VALUES ('admin_sd', 'hashed_password_123', 'admin_dinas', 'Administrator SD');

INSERT INTO sekolah (npsn, nama_sekolah, kecamatan, kuota_total, latitude, longitude)
VALUES ('10101010', 'SD NEGERI 1 TUBAN', 'Tuban', 100, -6.8973, 112.0632);