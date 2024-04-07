CREATE DATABASE DA_Xuong
GO
USE DA_XUONG
GO



CREATE TABLE Size(
	ID INT IDENTITY(1,1) NOT NULL,
	Ten INT NOT NULL

	 CONSTRAINT [PK_KichThuoc] PRIMARY KEY (ID)
)
GO


CREATE TABLE MauSac(
	ID INT IDENTITY(1,1) NOT NULL,
	Ten NVARCHAR(50) NOT NULL

	 CONSTRAINT [PK_MauSac] PRIMARY KEY (ID)
)
GO

CREATE TABLE ChatLieu(
	ID INT IDENTITY(1,1) NOT NULL,
	Ten NVARCHAR(50) NOT NULL

	 CONSTRAINT [PK_ChatLieu] PRIMARY KEY (ID)
)
GO

CREATE TABLE ThuongHieu(
	ID INT IDENTITY(1,1) NOT NULL,
	Ten NVARCHAR(50) NOT NULL

	 CONSTRAINT [PK_ThuongHieu] PRIMARY KEY (ID)
)
GO

CREATE TABLE DanhMuc(
	ID INT IDENTITY(1,1) NOT NULL,
	Ten NVARCHAR(50) NOT NULL

	 CONSTRAINT [PK_DanhMuc] PRIMARY KEY (ID)
)
GO


CREATE TABLE KhachHang(
	ID INT IDENTITY(1,1) NOT NULL,
	Ma VARCHAR(10) UNIQUE,
	Ten NVARCHAR(30) NOT NULL,
	NgaySinh DATE  NULL,
	GioiTinh BIT  NULL,
	SDT VARCHAR(10) NOT NULL,

	CONSTRAINT [PK_KhachHang] PRIMARY KEY (ID)
)
GO

CREATE TABLE NhanVien(
	ID INT IDENTITY(1,1) NOT NULL,
	Ma VARCHAR(10) UNIQUE,
	Passwords VARCHAR (15) NOT NULL,
	Ten NVARCHAR(30) NOT NULL,
	SDT VARCHAR(10) NOT NULL,
	Email VARCHAR(30) NOT NULL,
	Anh NVARCHAR(MAX) NULL,
	ChucVu BIT NOT NULL,
	TrangThai BIT NOT NULL,

	CONSTRAINT [PK_NhanVien] PRIMARY KEY (ID)
)
GO

CREATE TABLE SanPham(
	ID INT IDENTITY(1,1) NOT NULL,
	Ma VARCHAR(10) UNIQUE,
	Ten NVARCHAR(30) NOT NULL,
	NgayThem DATETIME DEFAULT GETDATE(),
	ID_ThuongHieu INT  NULL,
	ID_DanhMuc INT  NULL,
	ID_NhanVien INT NOT NULL,


	CONSTRAINT [PK_SanPham] PRIMARY KEY (ID),
	CONSTRAINT [FK_SanPham_ThuongHieu] FOREIGN KEY(ID_ThuongHieu) REFERENCES ThuongHieu(ID),
	CONSTRAINT [FK_SanPham_DanhMuc] FOREIGN KEY(ID_DanhMuc) REFERENCES DanhMuc(ID),
	CONSTRAINT [FK_SanPham_NhanVien] FOREIGN KEY(ID_NhanVien) REFERENCES NhanVien(ID)
)
GO

CREATE TABLE SanPhamChiTiet(
	ID INT IDENTITY(1,1) NOT NULL,
	Gia FLOAT NOT NULL,
	SoLuong INT NOT NULL,
	MaSP VARCHAR(10) NOT NULL,
	TrangThai BIT NOT NULL DEFAULT 1, -- Đặt mặc định TrangThai là True
	ID_SP INT  NULL,
	ID_Size INT NOT NULL,
	ID_MauSac INT NOT NULL,
	ID_ChatLieu INT NOT NULL,

	CONSTRAINT [FK_CTSP_SanPham] FOREIGN KEY(ID_SP) REFERENCES SanPham (ID), 
	CONSTRAINT [FK_CTSP_Size] FOREIGN KEY(ID_Size) REFERENCES Size(ID),
	CONSTRAINT [FK_CTSP_MauSac] FOREIGN KEY(ID_MauSac) REFERENCES MauSac(ID),
	CONSTRAINT [FK_CTSP_ChatLieu] FOREIGN KEY(ID_ChatLieu) REFERENCES ChatLieu(ID),
	CONSTRAINT [PK_SanPhamChiTiet] PRIMARY KEY (ID)
)
GO

CREATE TABLE Voucher(
	ID INT IDENTITY(1,1) NOT NULL,
	Ma VARCHAR(10) UNIQUE,
	Ten NVARCHAR(30) NOT NULL,
	NgayTao DATETIME DEFAULT GETDATE(),
	ID_NhanVien INT NOT NULL,

	CONSTRAINT [PK_Voucher] PRIMARY KEY (ID),
	CONSTRAINT [FK_VoucherCT_NhanVien] FOREIGN KEY(ID_NhanVien) REFERENCES NhanVien(ID)
)
GO

CREATE TABLE VoucherCT(
    ID INT IDENTITY(1,1) NOT NULL,
    NgayBatDau DATE NOT NULL,
    NgayHetHan DATE NOT NULL,
    SoLuong INT NOT NULL,
    KieuGiam Bit NOT NULL,
    TrangThai BIT NOT NULL DEFAULT 1, -- Đặt mặc định TrangThai là True
    ID_Voucher INT NULL,

    CONSTRAINT [FK_VoucherCT_Voucher] FOREIGN KEY(ID_Voucher) REFERENCES Voucher(ID),

    CONSTRAINT [PK_VoucherCT] PRIMARY KEY (ID)
)
GO


CREATE TABLE HoaDon(
	ID INT IDENTITY(1,1) NOT NULL,
	Ma VARCHAR(10) UNIQUE,
	NgayTao DATETIME DEFAULT GETDATE(),
	TongTien FLOAT NULL,
	TrangThai BIT NOT NULL DEFAULT 0, -- Đặt mặc định TrangThai là Flase
	ID_NhanVien INT NULL,
	ID_KhachHang INT  NULL,

	CONSTRAINT [FK_CTHD_NhanVien] FOREIGN KEY(ID_NhanVien) REFERENCES NhanVien(ID),
	CONSTRAINT [FK_CTHD_KhachHang] FOREIGN KEY(ID_KhachHang) REFERENCES KhachHang(ID),
	CONSTRAINT [PK_HoaDon] PRIMARY KEY (ID)
)
GO

CREATE TABLE HoaDonChiTiet(
	ID INT IDENTITY(1,1) NOT NULL,
	GiaBan FLOAT NOT NULL,
	SoLuongSP INT NOT NULL,
	TongTien FLOAT NOT NULL,
	ID_SanPhamCT INT NOT NULL,
	ID_HoaDon INT NOT NULL,
	ID_VoucherCT INT NULL,

	CONSTRAINT [FK_CTHD_SanPhamCT] FOREIGN KEY(ID_SanPhamCT) REFERENCES SanPhamChiTiet(ID),
	CONSTRAINT [FK_CTHD_HoaDon] FOREIGN KEY(ID_HoaDon) REFERENCES HoaDon(ID),
	CONSTRAINT [FK_CTHD_VoucherCT] FOREIGN KEY(ID_VoucherCT) REFERENCES VoucherCT(ID),

	CONSTRAINT [PK_HoaDonChiTiet] PRIMARY KEY (ID)
)
GO

-- Trigger để tự động sinh mã khi thêm dữ liệu mới
CREATE TRIGGER Tr_Generate_MaHD ON HoaDon
INSTEAD OF INSERT
AS
BEGIN
    SET NOCOUNT ON;

    INSERT INTO HoaDon (Ma, NgayTao, TongTien, ID_NhanVien, ID_KhachHang)
    SELECT 
        COALESCE(Ma, 'HD' + RIGHT('00000' + CAST((ABS(CHECKSUM(NEWID())) % 100000) AS VARCHAR(5)), 5)),
        NgayTao, TongTien, ID_NhanVien, ID_KhachHang
    FROM inserted;
END
GO

CREATE TRIGGER Tr_Generate_MaNV ON NhanVien
INSTEAD OF INSERT
AS
BEGIN
    SET NOCOUNT ON;

    INSERT INTO NhanVien(Ma, Passwords, Ten, SDT, Email, Anh, ChucVu, TrangThai)
    SELECT 
        COALESCE(Ma, 'PH' + RIGHT('00000' + CAST((ABS(CHECKSUM(NEWID())) % 100000) AS VARCHAR(5)), 5)),
        Passwords, Ten, SDT, Email, Anh, ChucVu, TrangThai
    FROM inserted;
END
GO

CREATE TRIGGER Tr_Generate_MaKH ON KhachHang
INSTEAD OF INSERT
AS
BEGIN
    SET NOCOUNT ON;

    INSERT INTO KhachHang(Ma, Ten, NgaySinh, GioiTinh, SDT)
    SELECT 
        COALESCE(Ma, 'KH' + RIGHT('00000' + CAST((ABS(CHECKSUM(NEWID())) % 100000) AS VARCHAR(5)), 5)),
        Ten, NgaySinh, GioiTinh, SDT
    FROM inserted;
END
GO

CREATE TRIGGER Tr_Generate_MaSP ON SanPham
INSTEAD OF INSERT
AS
BEGIN
    SET NOCOUNT ON;

    INSERT INTO SanPham(Ma, Ten, NgayThem, ID_ThuongHieu, ID_DanhMuc, ID_NhanVien)
    SELECT 
        COALESCE(Ma, 'SP' + RIGHT('00000' + CAST((ABS(CHECKSUM(NEWID())) % 100000) AS VARCHAR(5)), 5)),
        Ten, NgayThem, ID_ThuongHieu, ID_DanhMuc, ID_NhanVien
    FROM inserted;
END
GO

CREATE TRIGGER Tr_Generate_MaVC ON Voucher
INSTEAD OF INSERT
AS
BEGIN
    SET NOCOUNT ON;

    INSERT INTO Voucher(Ma, Ten, NgayTao, ID_NhanVien)
    SELECT 
        COALESCE(Ma, 'VC' + RIGHT('00000' + CAST((ABS(CHECKSUM(NEWID())) % 100000) AS VARCHAR(5)), 5)),
        Ten, NgayTao, ID_NhanVien
    FROM inserted;
END
GO



INSERT INTO [dbo].[Size] ([Ten]) 
VALUES  (N'35'),
		(N'36'),
		(N'37'),
		(N'38'),
		(N'39'),
		(N'40'),
		(N'41'),
		(N'42'),
		(N'43');
GO
--Dữ liệu MauSac
INSERT INTO [dbo].[MauSac] ([Ten]) 
VALUES  (N'Đỏ'),
		(N'Trắng'),
		(N'Đen'),
		(N'Hồng');
GO
--Dữ liệu ChatLieu
INSERT INTO [dbo].[ChatLieu] ([Ten]) 
VALUES  (N'Da'),
		(N'vải');
GO

--Dữ liệu ThuongHieu
INSERT INTO [dbo].[ThuongHieu] ([Ten]) 
VALUES  (N'Nike'),
		(N'Puma'),
		(N'Asics'),
		(N'Balance'),
		(N'Adidas');
GO
--Dữ liệu DanhMuc
INSERT INTO [dbo].[DanhMuc] ([Ten]) 
VALUES  (N'Giày đôi'),
		(N'Giày nam'),
		(N'Giày nữ'),
		(N'Giày thể thao'),
		(N'Giày thời trang');
GO
--Dữ liệu KhachHang
INSERT INTO [dbo].[KhachHang]([Ma], [Ten], [NgaySinh], [GioiTinh], [SDT])
VALUES		(NULL, N'Vũ Văn Nguyên', '2004-11-20', 1, '0987234141'),
			(NULL, N'Chu Thị Ngân', '2004-11-20', 0, '0987234141'),
			(NULL, N'Nguyễn Văn Tèo', '2004-11-20', 1, '0987234141'),
			(NULL, N'Nguyễn Thúy Hằng', '2004-11-20', 0, '0987234141'),
			(NULL, N'Nguyễn Anh Dũng', '2004-11-20', 1, '0987234141');
GO

--Dự liệu NhanVien
INSERT INTO [dbo].[NhanVien] ([Ma], [Passwords], [Ten], [SDT], [Email], [ChucVu], [TrangThai])
VALUES		('PH36297', '123456', N'Nguyễn Thị Thanh Phương', '0367266064', 'phuongnttph36297@fpt.edu.vn', 1, 1),
			('PH40152', '123456', N'Lê Đình Huy', '0367439572', 'huyldph40152@fpt.edu.vn', 1, 1),
			(NULL, '123456', N'Nguyễn Văn Tèo', '0932432422', 'huyldph40152@fpt.edu.vn', 1, 1),
			(NULL, '123456', N'Nguyễn Anh Dũng', '0932432422', 'huyldph40152@fpt.edu.vn', 0, 1),
			(NULL, '123456', N'Nguyễn Thúy Hằng', '0932432422', 'huyldph40152@fpt.edu.vn', 1, 1),
			(NULL, '123456', N'Nguyễn Hoàng Tiến', '0932432422', 'huyldph40152@fpt.edu.vn', 1, 0);
GO
--Dữ liệu SanPham
INSERT INTO [dbo].[SanPham] ([Ma], [Ten], [NgayThem], [ID_ThuongHieu], [ID_DanhMuc], [ID_NhanVien])
VALUES			(NULL, N'Giày Nike nam', DEFAULT, 1, 4, 2),
				(NULL, N'Giày Nike nữ', DEFAULT, 1, 2, 3),
				(NULL, N'Giày đôi', DEFAULT, 2, 3, 1),
				(NULL, N'Giày Thể thao Hàn Quốc', DEFAULT, 4, 1, 4),
				(NULL, N'Giày Thời trang nam', DEFAULT, 4, 2, 2);

GO
--dữ liệu sản phẩm chi tiết
INSERT INTO [dbo].[SanPhamChiTiet] ([Gia], [SoLuong], [MaSP], [TrangThai], [ID_SP], [ID_Size], ID_MauSac, ID_ChatLieu)
VALUES			(100, 50, 'SP86615', 1, 3, 1, 1, 1),
				(200, 50, 'SP24906', 1, 4, 2, 2, 2),
				(300, 50, 'SP13164', 1, 5, 3, 3, 1),
				(400, 50, 'SP81048', 1, 5, 2, 2, 2),
				(500, 50, 'SP08464', 1, 5, 2, 4, 2);
GO

--Dữ liệu Voucher
INSERT INTO [dbo].[Voucher] ([Ma], [Ten], [NgayTao], [ID_NhanVien])
VALUES			(NULL, N'Giảm giá 20/10', DEFAULT, 1),
				(NULL, N'Giảm giá 20/11', DEFAULT, 3),
				(NULL, N'Giảm giá Halloween', DEFAULT, 1),
				(NULL, N'Giảm giá Valentine', DEFAULT, 2),
				(NULL, N'Giảm giá Tết', DEFAULT, 4);

--Dữ liệu VoucherCT
INSERT INTO [dbo].[VoucherCT] ([NgayBatDau], [NgayHetHan], [SoLuong], [KieuGiam], [TrangThai], ID_Voucher)
VALUES			('2023-10-20', '2023-10-25', 100, 1, 1, 1),
				('2023-10-20', '2023-10-25', 100, 0, 1, 2),
				('2023-10-20', '2023-10-25', 100, 1, 1, 1),
				('2023-10-20', '2023-10-25', 100, 0, 1, 3),
				('2023-10-20', '2023-10-25', 100, 1, 0, 4),
				('2023-10-20', '2023-10-25', 100, 1, 0, 5);

--Dữ liệu HoaDon
INSERT INTO [dbo].[HoaDon] ([Ma], [NgayTao], [TongTien], TrangThai, ID_NhanVien, ID_KhachHang)
VALUES			(NULL, DEFAULT, 0, DEFAULT, 1, 1)


--Dữ liệu HDCT
INSERT INTO [dbo].[HoaDonChiTiet] ([GiaBan], [SoLuongSP], [TongTien], [ID_SanPhamCT], [ID_HoaDon], [ID_VoucherCT])
VALUES			(100, 2, 200, 4, 1, 1),
				(100, 2, 200, 2, 1, 1)
GO

SELECT * FROM ChatLieu
SELECT * FROM Size
SELECT * FROM MauSac
SELECT * FROM DanhMuc
SELECT * FROM ThuongHieu
SELECT * FROM KhachHang
SELECT * FROM NhanVien
SELECT * FROM SanPham
SELECT * FROM SanPhamChiTiet
SELECT * FROM Voucher
SELECT * FROM VoucherCT
select * from HoaDon
SELECT NgayTao, sum(TongTien) as tongTien FROM HoaDon group by NgayTao
SELECT NgayTao,	count(SoLuongSP) as SoLuongSP FROM HoaDon 
join HoaDonChiTiet on HoaDonChiTiet.ID_HoaDon = HoaDon.ID group by NgayTao
select * from HoaDonChiTiet
SELECT DATE_FORMAT(NgayTao, '%Y-%m-%d') AS ngay, SUM(TongTien) AS doanh_thu
FROM HoaDon
GROUP BY DATE_FORMAT(NgayTao, '%Y-%m-%d')
ORDER BY ngay;

SELECT
    hdct.ID,
    hd.Ma AS MaHD,
    sp.Ma AS MaSP,
    sp.Ten AS TenSP,
    size.Ten AS Size,
    ms.Ten AS Mau,
    cl.Ten AS ChatLieu,
    hdct.GiaBan,
    hdct.SoLuongSP,
    hdct.TongTien,
    hdct.ID_SanPhamCT
FROM
    dbo.HoaDonChiTiet hdct
JOIN
    dbo.HoaDon hd ON hdct.ID_HoaDon = hd.ID
JOIN
    dbo.SanPhamChiTiet spct ON hdct.ID_SanPhamCT = spct.ID
JOIN
    dbo.Size size ON spct.Id_Size = size.ID
JOIN
    dbo.MauSac ms ON spct.Id_MauSac = ms.ID
JOIN
    dbo.ChatLieu cl ON spct.Id_ChatLieu = cl.ID
JOIN
    dbo.SanPham sp ON spct.ID_SP = sp.ID
