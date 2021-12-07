create table BTCNTT1.XE
(
  MAXE varchar2(3), 
  BIENKS varchar2(9) not null,
  MATUYEN varchar2(4) not null,
  SOGHET1 number,
  SOGHET2 number,
  constraint PK_XE primary key(MAXE)
);

create table BTCNTT1.TUYEN
(
  MATUYEN varchar2(4),
  BENDAU varchar2(4),
  BENCUOI varchar2(4),
  GIATUYEN number,
  NGXB date,
  TGDK number,
  constraint PK_TUYEN primary key(MATUYEN) 
);

create table BTCNTT1.KHACH
(
  MAHK varchar2(4),
  HOTEN varchar2(50) not null,
  GIOITINH varchar2(3) not null,
  CMND number,
  constraint PK_KHACH primary key(MAHK)
);

create table BTCNTT1.VEXE
(
  MATUYEN varchar2(4),
  MAHK varchar2(4),
  NGMUA date,
  GIAVE number,
  constraint PK_VEXE primary key(MATUYEN, MAHK)
);

alter session set NLS_DATE_FORMAT =' DD/MM/YYYY HH24:MI:SS ';

insert into BTCNTT1.XE values ('X01','52LD-4393','T11A','20','20');
insert into BTCNTT1.XE values ('X02','59LD-7247','T32D','36','36');
insert into BTCNTT1.XE values ('X03','55LD-6850','T06F','15','15');

insert into BTCNTT1.TUYEN values ('T11A','SG','DL','210000','26/12/2016','6');
insert into BTCNTT1.TUYEN values ('T32D','PT','SG','120000','30/12/2016','4');
insert into BTCNTT1.TUYEN values ('T06F','NT','DNG','225000','02/01/2017','7');

insert into BTCNTT1.KHACH values ('HK01','Lam Van Ben','Nam','655615896');
insert into BTCNTT1.KHACH values ('HK02','Duong Thi Luc','Nu','275648642');
insert into BTCNTT1.KHACH values ('HK03','Hoang Thanh Tung','Nam','456889143');

insert into BTCNTT1.VEXE values ('T11A','KH01','20/12/2016','210000');
insert into BTCNTT1.VEXE values ('T32D','KH02','25/12/2016','144000');
insert into BTCNTT1.VEXE values ('T06F','KH03','30/12/2016','270000');

--------3---------

alter table BTCNTT1.TUYEN add constraint CHECK_1 CHECK (TGDK>5 and GIATUYEN>200000); 

--------5---------

SELECT * 
FROM BTCNTT1.VEXE
WHERE extract(month from NGMUA) = 12
ORDER BY GIAVE desc;

--------6---------

SELECT BTCNTT1.TUYEN.MATUYEN
FROM BTCNTT1.TUYEN, BTCNTT1.VEXE
WHERE TUYEN.MATUYEN = VEXE.MATUYEN
GROUP BY BTCNTT1.TUYEN.MATUYEN
HAVING COUNT (BTCNTT1.VEXE.MAHK) <= (
  SELECT MAX(COUNT (BTCNTT1.VEXE.MAHK))
  FROM BTCNTT1.TUYEN, BTCNTT1.VEXE
  WHERE TUYEN.MATUYEN = VEXE.MATUYEN
  GROUP BY BTCNTT1.TUYEN.MATUYEN
);

--------7---------

SELECT BTCNTT1.TUYEN.MATUYEN
FROM BTCNTT1.TUYEN, BTCNTT1.VEXE, BTCNTT1.KHACH
WHERE TUYEN.MATUYEN=VEXE.MATUYEN and KHACH.MAHK=VEXE.MAHK and GIOITINH='Nam'

INTERSECT

SELECT BTCNTT1.TUYEN.MATUYEN
FROM BTCNTT1.TUYEN, BTCNTT1.VEXE, BTCNTT1.KHACH
WHERE TUYEN.MATUYEN=VEXE.MATUYEN and KHACH.MAHK=VEXE.MAHK and GIOITINH='Nu';

-------8---------

SELECT *
FROM BTCNTT1.KHACH
WHERE GIOITINH='Nu' and not exists (
  SELECT *
  FROM BTCNTT1.TUYEN
  WHERE not exists (
    SELECT *
    FROM BTCNTT1.VEXE
    WHERE VEXE.MAHK=KHACH.MAHK and VEXE.MATUYEN=TUYEN.MATUYEN
  )
);