create database data_tabungan_bank_sampurna;
use data_tabungan_bank_sampurna;
create table customers
(
	customer_id int not null,
    nama_customer char(50) not null,
    tanggal_lahir date,
    provinsi_alamat char(30) not null,
    jenis_kelamin char(1) not null,
    status_nikah varchar (20) not null,
    gaji int not null default 0,
    primary key (customer_id)
);
describe customers;
insert into customers (customer_id, nama_customer, tanggal_lahir, provinsi_alamat, jenis_kelamin, status_nikah, gaji)
values ('123456', 'Ardi Jono','2001-03-09', 'Jakarta', 'L', 'Belum Kawin', 0), 
		('123457', 'Hani Pulungan','1987-01-23', 'Jawa Barat', 'P', 'Kawin', 25000000),
        ('123458', 'Mutiara Rahayu','1999-06-13', 'Sulawesi Tengah', 'P', 'Janda/Duda', 5000000),
        ('123459', 'Dian Kusuma','1975-12-17', 'Jawa Timur', 'P', 'Belum Kawin', 8000000),
        ('123455', 'Febrian Siregar','1991-09-12', 'Sumatera Utara', 'L', 'Kawin', 3000000);
select * from customers;

create table detail_status_rekening
(
	id_status int not null,
    deskripsi_status char(20) not null,
	primary key (id_status)
);
describe detail_status_rekening;
insert into detail_status_rekening(id_status, deskripsi_status)
values ('1', 'Aktif'),
	('2', 'Closed'),
    ('3', 'Dormant');
select * from detail_status_rekening;

create table lokasi_unit
(
	id_unit int not null,
    nama_unit char (20) not null,
    nama_cabang char(40) not null,
    kantor_wilayah char(20) not null,
    primary key (id_unit)
);
describe lokasi_unit;
insert into lokasi_unit (id_unit, nama_unit, nama_cabang, kantor_wilayah)
values ('55', 'Suralaya', 'Kanca Surabaya', 'Jawa Timur'),
	   ('56', 'Manggarai', 'Kanca Jakarta Selatan', 'Jakarta'),
       ('57', 'Sudirman', 'Kanca Jakarta Pusat', 'Jakarta'),
       ('58', 'Patihan', 'Kanca Palu', 'Sulawesi'),
       ('59', 'Singgalok', 'Kanca Toba', 'Sumatera');
select * from lokasi_unit;

create table transaksi_simpanan
(
	id_transaksi int not null,
    nominal_transaksi decimal(19,2),
    waktu_transaksi timestamp,
	primary key (id_transaksi)
);
describe transaksi_simpanan;
drop table transaksi_simpanan;
insert into transaksi_simpanan(id_transaksi, nominal_transaksi, waktu_transaksi)
values ('1598765432', 500000, '2021-05-09 09:30:00'),
	('1598765433', 25000, '2021-05-09 10:30:00'),
    ('1598765434', 300000, '2021-05-09 12:20:00'),
    ('1598765435', 1000000, '2021-05-09 15:10:00'),
    ('1598765436', 560000, '2021-05-10 08:50:00'),
    ('1598765437', 64296, '2021-05-10 10:40:00'),
    ('1598765438', 206002, '2021-05-10 10:50:00');

select* from transaksi_simpanan;

create table master_data_pinjaman
(
	no_rekening_pinjaman int not null,
    tanggal_buka_pinjaman timestamp not null,
    tanggal_berakhir_pinjaman timestamp not null,
    customer_id int not null,
    primary key (no_rekening_pinjaman),
    constraint fk_master_data_pinjaman
    foreign key (customer_id) references customers (customer_id)
);
describe master_data_pinjaman;
insert into master_data_pinjaman (no_rekening_pinjaman, tanggal_buka_pinjaman, tanggal_berakhir_pinjaman, customer_id)
values ('987654321', '2019-03-09 06:50:00', '2023-03-09 06:50:00', '123455'),
	   ('987654322', '2021-01-15 07:22:00', '2022-01-14 07:22:00', '123457'),
       ('987654323', '2020-06-27 08:45:00', '2025-06-26 08:45:00', '123458');
select * from master_data_pinjaman;

create table master_data_tabungan
(
	no_rekening int not null,
    jenis_rekening char(20) not null,
    tanggal_buka_rekening timestamp not null,
    status_rekening int not null,
    customer_id int not null,
    lokasi_pembuatan_rekening int not null,
    primary key(no_rekening),
    constraint fk_master_data_tabungan_1 foreign key (customer_id) references customers (customer_id),
    constraint fk_master_data_tabungan_2 foreign key (status_rekening) references detail_status_rekening (id_status),
    constraint fk_master_data_tabungan_3 foreign key (lokasi_pembuatan_rekening) references lokasi_unit (id_unit)
);
describe master_data_tabungan;
insert into master_data_tabungan (no_rekening, jenis_rekening, tanggal_buka_rekening, status_rekening, customer_id, lokasi_pembuatan_rekening)
values ('543219876', 'Konvensional', '2018-01-22 09:30:00', '3', '123456', '56'),
	   ('543219875', 'Konvensional', '2018-02-23 09:33:00', '1', '123457', '57'),
       ('543219874', 'Giro', '2019-05-27 11:29:00', '2', '123458', '56'),
       ('543219873', 'Konvensional', '2019-07-30 12:01:00', '1', '123459', '58'),
       ('543219872', 'Konvensional', '2019-07-21 08:55:00', '1', '123455', '59'),
       ('543219871', 'Haji', '2019-12-28 14:24:00', '1', '123457', '57');
select * from master_data_tabungan;

create table saldo_sisa_tabungan
(
	no_rekening int not null,
    id_transaksi int not null,
    tipe_transaksi char(10),
    sisa_saldo decimal(19,2),
    constraint fk_saldo_sisa_tabungan_1 foreign key (no_rekening) references master_data_tabungan (no_rekening),
    constraint fk_saldo_sisa_tabungan_2 foreign key (id_transaksi) references transaksi_simpanan (id_transaksi)
);
alter table saldo_sisa_tabungan
add primary key (no_rekening, id_transaksi);
describe saldo_sisa_tabungan;
insert into saldo_sisa_tabungan (no_rekening, id_transaksi, tipe_transaksi, sisa_saldo)
values ('543219873', '1598765432', 'Credit', 5000000),
	   ('543219875', '1598765433', 'Debit', 73000000),
       ('543219871', '1598765434', 'Credit', 400000),
       ('543219875', '1598765435', 'Credit', 74000000),
       ('543219872', '1598765435', 'Debit', 150000),
       ('543219871', '1598765436', 'Credit', 960000),
       ('543219875', '1598765436', 'Debit', 73440000),
       ('543219875', '1598765437', 'Credit', 73504296),
       ('543219873', '1598765438', 'Debit', 4793998);
drop tables saldo_sisa_tabungan;
select * from saldo_sisa_tabungan;
alter table saldo_sisa_tabungan
add primary key (no_rekening, id_transaksi);
describe saldo_sisa_tabungan;
show tables;

/*nomor 1 Tampilkan nama customer dan tanggal lahirnya*/
select nama_customer as 'Nama Customer', tanggal_lahir as 'Tanggal Lahir' from customers;
/*nomor 2* Tampilkan nama customer dan rekeningnya*/
select *from customers;
select c.nama_customer as 'Nama Customer', mdt.no_rekening as 'No. Rekening'
from customers c 
inner join master_data_tabungan mdt
on c.customer_id = mdt.customer_id;

/*nomor 3 Tampilkan Nomor rekening dan id transaksi ditanggal 10 Mei 2021*/
select sst.no_rekening as 'No. Rekening', ts.id_transaksi 'ID Transaksi', ts.waktu_transaksi 'Transaksi 10 Mei'
from transaksi_simpanan ts
inner join saldo_sisa_tabungan sst
on ts.id_transaksi = sst.id_transaksi
where waktu_transaksi like '%05-10%';

/*nomor 4 no rekening, tanggal lahir dari nasabah p*/
select mdt.no_rekening 'No. Rekening', c.tanggal_lahir 'Tanggal Lahir', jenis_kelamin 'Jenis Kelamin Perempuan'
from customers c
inner join master_data_tabungan mdt
on c.customer_id = mdt.customer_id
where jenis_kelamin = 'p';

/*nomor 5 id transaksi, dan nominal transaksi diurutkan dari nominal transaksinya*/
select id_transaksi as 'ID Transaksi', nominal_transaksi 'Nominal Transaksi'
from transaksi_simpanan
order by nominal_transaksi;

/*nomor 6 tampilkan rekening simpanan dari customer yang tidak memiliki rekening pinjaman*/
select c.nama_customer, mdt.no_rekening
from master_data_tabungan mdt 
inner join customers c on mdt.customer_id = c.customer_id
left join master_data_pinjaman mdp on mdp.customer_id = c.customer_id
where no_rekening_pinjaman is null;

/*nomor 7 nama customer yang pernah membuat rekening dikantor wilayah jakarta*/
select nama_customer as 'Nama Customer', kantor_wilayah 'Kantor Wilayah Pembuatan Rekening'
from customers c
Inner join master_data_tabungan mdt on c.customer_id = mdt.customer_id
inner join lokasi_unit lu on lu.id_unit = mdt.lokasi_pembuatan_rekening
where kantor_wilayah = 'Jakarta';

/*nomor 8 id transaksi yang customer berstatus kawin*/
select distinct ts.id_transaksi 'ID Transaksi', c.nama_customer ' Nama Customer', c.status_nikah 'Status Nikah'
from customers c
inner join master_data_tabungan mdt on mdt.customer_id = c.customer_id
inner join saldo_sisa_tabungan sst on sst.no_rekening = mdt.no_rekening
inner join transaksi_simpanan ts on ts.id_transaksi = sst.id_transaksi
where status_nikah = 'Kawin';

/*nomor 9 id transaksi customer tinggal di jawa*/
select distinct ts.id_transaksi 'ID Transaksi', c.nama_customer ' Nama Customer', c.provinsi_alamat 'Jawa'
from customers c
inner join master_data_tabungan mdt on mdt.customer_id = c.customer_id
inner join saldo_sisa_tabungan sst on sst.no_rekening = mdt.no_rekening
inner join transaksi_simpanan ts on ts.id_transaksi = sst.id_transaksi
where provinsi_alamat like 'ja%';

/*nomor 10 nama customer tanggal 9 mei tidak boleh duplikat*/
select distinct c.nama_customer ' Nama Customer'
from customers c
inner join master_data_tabungan mdt on mdt.customer_id = c.customer_id
inner join saldo_sisa_tabungan sst on sst.no_rekening = mdt.no_rekening
inner join transaksi_simpanan ts on ts.id_transaksi = sst.id_transaksi
where waktu_transaksi like '%05-09%';

/*nomor 11 nama customer dan no rek pinjaman yang membuat rekening simpanan di wilayah jakarta*/
select c.nama_customer, mdp.no_rekening_pinjaman
from master_data_pinjaman mdp
inner join customers c on mdp.customer_id = c.customer_id
inner join master_data_tabungan mdt on mdt.customer_id = c.customer_id
inner join lokasi_unit lu on lu.id_unit = mdt.lokasi_pembuatan_rekening
where kantor_wilayah = 'Jakarta';

/*nomor 12 tampilkan id custmer, dan tanggal buka pinjaman yang memiliki simpanana status aktif transaksi 9 mei bertipe debit*/
select c.customer_id, mdp.tanggal_buka_pinjaman, dsr.deskripsi_status, sst.tipe_transaksi, ts.waktu_transaksi
from detail_status_rekening dsr
inner join master_data_tabungan mdt on dsr.id_status = mdt.status_rekening
inner join customers c on c.customer_id = mdt.customer_id       
inner join master_data_pinjaman mdp on mdp.customer_id = c.customer_id
inner join saldo_sisa_tabungan sst on sst.no_rekening = mdt.no_rekening
inner join transaksi_simpanan ts on ts.id_transaksi = sst.id_transaksi
where dsr.deskripsi_status = 'aktif' AND sst.tipe_transaksi = 'debit';

/*nomor 13 menurut waktu dan tanggal*/
select id_transaksi, year(waktu_transaksi) 'tahun', month(waktu_transaksi) 'bulan', day(waktu_transaksi) 'hari'
from transaksi_simpanan;

/*nomor 14 gaji terbesar dari semua customer yang bertransaksi 10 mei*/
select c.nama_customer, c.gaji, ts.waktu_transaksi
from customers c 
inner join master_data_tabungan mdt on c.customer_id = mdt.customer_id
inner join saldo_sisa_tabungan sst on mdt.no_rekening = sst.no_rekening
inner join transaksi_simpanan ts on sst.id_transaksi = ts.id_transaksi
where ts.waktu_transaksi like '%05-10%'
order by gaji desc;

/*nomor 15 no rekening dan deskripsi status rekening untuk customer yang memiliki pinjaman dan lahir sebelum 1995*/
select mdt.no_rekening, dsr.deskripsi_status, year(tanggal_lahir) 'Tahun Lahir', c.nama_customer, mdp.no_rekening_pinjaman
from master_data_pinjaman mdp
inner join customers c on mdp.customer_id = c.customer_id  
inner join master_data_tabungan mdt on c.customer_id = mdt.customer_id
inner join detail_status_rekening dsr on dsr.id_status = mdt.status_rekening
where year(tanggal_lahir) < 1995;

/*nomor 16 total transaksi debidan frekuensi total*/
select c.nama_customer, mdt.no_rekening, count(sst.id_transaksi)as 'Total Transaksi',sum(ts.nominal_transaksi) as 'Debit'
 from customers c
 inner join master_data_tabungan mdt on c.customer_id = mdt.customer_id
 inner join saldo_sisa_tabungan sst on mdt.no_rekening = sst.no_rekening
 inner join transaksi_simpanan ts on sst.id_transaksi = ts.id_transaksi
 where sst.tipe_transaksi = 'Debit'
 group by sst.tipe_transaksi, mdt.no_rekening;

 /*17. Tampilkan customer id, nama customer, no.rekening, idtransaksi, tipe transaksi, jumlah transaksi, tgl transaksi)*/
 use data_tabungan_bank_sampurna;
 select c.customer_id, c.nama_customer, mdt.no_rekening, sst.id_transaksi, sst.tipe_transaksi, ts.nominal_transaksi, ts.waktu_transaksi
 from customers c
 inner join master_data_tabungan mdt on c.customer_id = mdt.customer_id
 inner join saldo_sisa_tabungan sst on mdt.no_rekening = sst.no_rekening
 inner join transaksi_simpanan ts on sst.id_transaksi = ts.id_transaksi;

/*18. Tampilkan customer_id, nama_customer, resensi= jarak transaksi kredit terakhir dari hari ini, frekuensi=jumlah total kredit, 
dan monetary jumlah total nominal transaksi, untuk transaksi kredit*/
 select c.nama_customer, mdt.no_rekening, count(sst.id_transaksi)as 'Total Transaksi',sum(ts.nominal_transaksi) as 'Total Credit'
 from customers c
 inner join master_data_tabungan mdt on c.customer_id = mdt.customer_id
 inner join saldo_sisa_tabungan sst on mdt.no_rekening = sst.no_rekening
 inner join transaksi_simpanan ts on sst.id_transaksi = ts.id_transaksi
 where sst.tipe_transaksi = 'Credit'
 group by sst.tipe_transaksi, mdt.no_rekening;
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 