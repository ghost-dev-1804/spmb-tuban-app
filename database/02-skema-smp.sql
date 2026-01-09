-- ==========================================
-- SKEMA DATABASE SMP (Sekolah Menengah Pertama)
-- ==========================================

DROP TABLE IF EXISTS dokumen_siswa CASCADE;
DROP TABLE IF EXISTS nilai_prestasi CASCADE; -- Tambahan untuk SMP
DROP TABLE IF EXISTS pendaftaran CASCADE;
DROP TABLE IF EXISTS siswa CASCADE;
DROP TABLE IF EXISTS sekolah CASCADE;
DROP TABLE IF EXISTS users CASCADE;

-- 1. TABEL PENGGUNA
CREATE TABLE users (
    id SERIAL PRIMARY KEY,
    username VARCHAR(50) UNIQUE NOT NULL,
    password_hash VARCHAR(255) NOT NULL,
    role VARCHAR(20) NOT NULL CHECK (role IN ('admin_dinas', 'operator_sekolah')),
    sekolah_id INT, 
    nama_lengkap VARCHAR(100),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 2. MASTER DATA SEKOLAH
CREATE TABLE sekolah (
    id SERIAL PRIMARY KEY,
    npsn VARCHAR(10) UNIQUE NOT NULL,
    nama_sekolah VARCHAR(100) NOT NULL,
    alamat TEXT,
    kecamatan VARCHAR(50),
    latitude DOUBLE PRECISION, 
    longitude DOUBLE PRECISION, 
    kuota_total INT DEFAULT 0,
    kuota_zonasi INT DEFAULT 0,
    kuota_afirmasi INT DEFAULT 0,
    kuota_mutasi INT DEFAULT 0,
    kuota_prestasi INT DEFAULT 0, -- Ada Kuota Prestasi
    is_active BOOLEAN DEFAULT TRUE
);

-- 3. DATA CALON SISWA
CREATE TABLE siswa (
    id SERIAL PRIMARY KEY,
    nisn VARCHAR(10) UNIQUE NOT NULL, -- SMP wajib NISN
    nik VARCHAR(16) UNIQUE NOT NULL,
    nama_lengkap VARCHAR(100) NOT NULL,
    asal_sekolah VARCHAR(100), -- Asal SD
    npsn_asal_sekolah VARCHAR(10),
    tempat_lahir VARCHAR(50),
    tanggal_lahir DATE NOT NULL,
    alamat_kk TEXT NOT NULL,
    latitude_kk DOUBLE PRECISION,
    longitude_kk DOUBLE PRECISION,
    no_hp_ortu VARCHAR(15),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 4. TRANSAKSI PENDAFTARAN
CREATE TABLE pendaftaran (
    id SERIAL PRIMARY KEY,
    kode_pendaftaran VARCHAR(25) UNIQUE NOT NULL,
    siswa_id INT REFERENCES siswa(id) ON DELETE CASCADE,
    sekolah_tujuan_id INT REFERENCES sekolah(id),
    
    -- Jalur Pendaftaran
    jalur VARCHAR(20) NOT NULL CHECK (jalur IN ('zonasi', 'afirmasi', 'mutasi', 'prestasi')),
    
    -- Data Scoring
    jarak_meter DOUBLE PRECISION DEFAULT 0,
    skor_akhir DOUBLE PRECISION DEFAULT 0, -- Gabungan jarak/usia/nilai (tergantung jalur)
    
    status_verifikasi VARCHAR(20) DEFAULT 'menunggu',
    status_seleksi VARCHAR(20) DEFAULT 'proses',
    waktu_daftar TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    
    UNIQUE(siswa_id, sekolah_tujuan_id)
);

-- 5. DETAIL PRESTASI / NILAI (Khusus Jalur Prestasi)
CREATE TABLE nilai_prestasi (
    id SERIAL PRIMARY KEY,
    pendaftaran_id INT REFERENCES pendaftaran(id) ON DELETE CASCADE,
    jenis_prestasi VARCHAR(50), -- 'akademik_rapor', 'non_akademik_lomba'
    nama_kejuaraan VARCHAR(100),
    tingkat VARCHAR(50), -- 'kabupaten', 'provinsi', 'nasional'
    skor_tambahan INT DEFAULT 0
);

-- 6. DOKUMEN
CREATE TABLE dokumen_siswa (
    id SERIAL PRIMARY KEY,
    pendaftaran_id INT REFERENCES pendaftaran(id) ON DELETE CASCADE,
    jenis_dokumen VARCHAR(50),
    file_path VARCHAR(255) NOT NULL,
    uploaded_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- SEEDING DATA
INSERT INTO users (username, password_hash, role, nama_lengkap) 
VALUES ('admin_smp', 'hashed_password_123', 'admin_dinas', 'Administrator SMP');

INSERT INTO sekolah (npsn, nama_sekolah, kecamatan, kuota_total, latitude, longitude)
VALUES ('20202020', 'SMP NEGERI 1 TUBAN', 'Tuban', 200, -6.8900, 112.0600);