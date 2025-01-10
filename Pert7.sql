CREATE DATABASE UNI_50422430;

USE UNI_50422430;

CREATE TABLE mahasiswa (
    npm INT PRIMARY KEY,
    nama VARCHAR(20),
    kelas VARCHAR(10),
    kd_mk VARCHAR(10) 
);

CREATE TABLE dosen (
    nid INT PRIMARY KEY,
    nama VARCHAR(20),
    alamat VARCHAR(300),
    kd_mk VARCHAR(10)
);

CREATE TABLE mata_kuliah (
    kd_mk INT PRIMARY KEY,
    nid INT, 
    npm INT, 
    nama_matkul VARCHAR(100),
    FOREIGN KEY (nid) REFERENCES dosen(nid), 
    FOREIGN KEY (npm) REFERENCES mahasiswa(npm) 
);


CREATE TABLE nilai (
	npm VARCHAR(10) PRIMARY KEY,
	nama VARCHAR(20),
	nilai INT
);

DROP TABLE mata_kuliah;
DROP TABLE dosen;
DROP TABLE mahasiswa;
DROP TABLE nilai;