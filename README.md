BÁO CÁO NGHIÊN CỨU CHUYÊN SÂU: KHAI PHÁ VÀ MÔ HÌNH HÓA ĐẶC TRƯNG HÌNH THÁI HOA DIÊN VĨ (IRIS DATASET) BẰNG TRUY VẤN CƠ SỞ DỮ LIỆU
PHẦN I: TỔNG QUAN TÀI LIỆU VÀ BỐI CẢNH DỮ LIỆU 
1. Bối cảnh lịch sử và giá trị thống kê
Trong kỷ nguyên của Dữ liệu lớn (Big Data), việc hiểu rõ bản chất của tập dữ liệu trước khi áp dụng bất kỳ kỹ thuật tính toán nào là nguyên tắc tối thượng. Bộ dữ liệu Iris không tự nhiên trở thành "hòn đá tảng" của ngành Khoa học dữ liệu (Fisher và Anderson, 1988).
Dù thường được gắn với tên tuổi của nhà thống kê học lỗi lạc Ronald Fisher trong bài báo vĩ đại năm 1936 giới thiệu phương pháp Phân tích phân biệt tuyến tính - Linear Discriminant Analysis (Fisher, 1936), công lao thực sự thuộc về Tiến sĩ thực vật học Edgar Anderson. Anderson đã dành thời gian tại bán đảo Gaspé (Canada) để hái và đo lường trực tiếp 150 mẫu vật thuộc 3 giống hoa: Setosa, Versicolor, và Virginica (Anderson, 1935; Anderson, 1936). Do được thu thập trong cùng một điều kiện môi trường, bởi cùng một thiết bị và một người đo, bộ dữ liệu này loại bỏ được gần như hoàn toàn sai số hệ thống (systematic errors), tạo ra một tập dữ liệu "sạch" và có độ tin cậy cực kỳ cao để làm tham chiếu cho các thuật toán phân loại.
2. Phân tích hình thái học sinh học (Biological Morphology)
Mỗi mẫu vật được đặc trưng bởi 4 biến số liên tục (continuous variables): Chiều dài và chiều rộng của Cánh hoa (Petal) và Đài hoa (Sepal) (Fisher, 1936).
Đặc trưng Cánh hoa (Petal Features): Cánh hoa là bộ phận có sự tiến hóa phân hóa mạnh mẽ nhất để thu hút các loài thụ phấn khác nhau. Do đó, trong không gian dữ liệu, petal_length và petal_width mang trọng số phân loại (discriminative power) gần như tuyệt đối. Loài Setosa sở hữu cánh hoa có kích thước rất nhỏ và phương sai (variance) thấp, khiến chúng quần tụ thành một cụm cô lập (Duda, Hart và Stork, 2001).
Đặc trưng Đài hoa (Sepal Features): Đài hoa đóng vai trò nâng đỡ cấu trúc hoa. Về mặt tiến hóa, sự khác biệt giữa các loài (đặc biệt là Versicolor và Virginica) không thực sự rõ rệt ở bộ phận này, dẫn đến hiện tượng chồng lấn dữ liệu (Data Overlapping), gây khó khăn cho các mô hình phân loại tuyến tính đơn giản (Duda, Hart và Stork, 2001).
PHẦN II: NỘI DUNG PHÂN TÍCH CỐT LÕI
1. Hiểu biết về bản chất bài tập
Dự án này là một quy trình Khám phá Dữ liệu (Exploratory Data Analysis - EDA) và Tiền xử lý Đặc trưng (Feature Engineering) được thực thi hoàn toàn theo mô hình In-Database Processing (xử lý tại nguồn). Thay vì trích xuất dữ liệu thô ra các công cụ bên ngoài như Python (Pandas) hay R, ta tận dụng sức mạnh tính toán nội tại của hệ quản trị CSDL để:
	Tính toán các chỉ số thống kê mô tả (Descriptive Statistics).
	Nhận diện các điểm dữ liệu dị thường (Outlier Detection).
	Lượng hóa không gian vector hình học (Toán học hóa khoảng cách và diện tích).
	Đảm bảo tính toàn vẹn của dữ liệu người dùng
Xây dựng một luật phân loại gốc (Rule-based Classification) tương đương với một Cây quyết định (Decision Tree) độ sâu 1.
2. Giải thích chuyên sâu logic các câu truy vấn SQL
Bài 1.1 Tóm tắt cánh hoa theo loài
a. Mục tiêu
Bài tập yêu cầu tóm tắt thông tin cơ bản của chiều dài cánh hoa (petal_length) theo từng loài trong bộ dữ liệu Iris. Cụ thể, bạn cần tính:
	Giá trị nhỏ nhất (Min)
	Giá trị trung bình (AVG)
	Giá trị lớn nhất (Max)
Cho từng loài hoa.
Đây là bước khám phá dữ liệu cơ bản (exploratory data analysis – EDA) để hiểu sự phân bố của cánh hoa trong mỗi loài.
b. Phân tích dữ liệu
- Cột species: tên loài (setosa, versicolor, virginica)
- Cột petal_length: chiều dài cánh hoa, dạng số thực
- Cần loại bỏ giá trị NULL nếu có
Kết quả là bảng tóm tắt giúp hiểu tổng quan về cánh hoa theo từng loài
c. Cách làm
 - Nhóm dữ liệu theo loài ( GROUP BY species)
- Tính các chỉ số thống kê:
+ MIN: MIN(petal_length)
+ TRUNG BÌNH: AVG(petal_length)
+ MAX: MAX(petal_length)
- Đặt tên cột rõ ràng
- Sắp xếp theo tên loài 
d. Câu lệnh SQL 

IF DB_ID(N'IrisDB') IS NULL
BEGIN
    CREATE DATABASE IrisDB;
END
GO

USE IrisDB;
GO
-- Tạo bảng Iris
CREATE TABLE iris (
    sepal_length FLOAT,
    sepal_width FLOAT,
    petal_length FLOAT,
    petal_width FLOAT,
    species VARCHAR(50)

SELECT
    species AS flower_type,
    MIN(petal_length) AS min_petal_length,
    ROUND(AVG(petal_length), 2) AS avg_petal_length,
    MAX(petal_length) AS max_petal_length
FROM iris
WHERE petal_length IS NOT NULL
GROUP BY species
ORDER BY species;

 Giải thích từng phần
Dòng	Ý nghĩa
SELECT species AS flower_type	Lấy tên loài, đổi tên cột thành flower_type
MIN(petal_length) AS min_petal_length	Tìm giá trị nhỏ nhất của chiều dài cánh hoa cho từng loài
ROUND(AVG(petal_length), 2) AS avg_petal_length	Tính trung bình và làm tròn 2 chữ số thập phân
MAX(petal_length) AS max_petal_length	Tìm giá trị lớn nhất của chiều dài cánh hoa
FROM iris	Bảng dữ liệu gốc Iris
WHERE petal_length IS NOT NULL	Bỏ các dòng bị thiếu giá trị chiều dài cánh hoa
GROUP BY species	Nhóm dữ liệu theo loài để tính MIN, AVG, MAX
ORDER BY species	Sắp xếp kết quả theo tên loài (tùy chọn, cho dễ nhìn)
Bài 1.2 So sánh diện tích cánh hoa
a. Mục tiêu
- Diện tích cánh hoa = hình elip:
(Length * Width * PI()) / 4
* vì sao lại tính theo công thức này, vì nếu tính theo công thức của đề bài đưa ra là (petal_length x petal_width) thì đây là công thức xấp xỉ hình chữ nhật. Cách này chính xác hơn một chút vì cánh hoa có đầu bo tròn.
- Tính diện tích trung bình của mỗi loài
- Làm tròn 2 chữ số
- Sắp xếp từ lớn nhất xuống nhỏ nhất
b.Dữ liệu và các bước xử lý
- Các cột cần dùng:
+ petal_length (chiều dài cánh hoa)
+ petal_width (chiều rộng cánh hoa)
+ species (loài hoa)
- Xử lý dữ liệu thô:
+ Loại bỏ các dòng có giá trị NULL hoặc dữ liệu thiếu ở chiều dài, chiều rộng, hoặc loài.
+Tạo cột diện tích cánh hoa: công thức hình elip 
c. Câu lệnh SQL
SELECT 
    species AS flower_type,
    ROUND(AVG(petal_length * petal_width * PI() / 4), 2) AS avg_petal_area
FROM iris
WHERE petal_length IS NOT NULL 
  AND petal_width IS NOT NULL
  AND species IS NOT NULL
GROUP BY species
ORDER BY avg_petal_area DESC;

Giải thích từng phần
Dòng code	Ý nghĩa
species AS flower_type	Lấy tên loài, đổi cột thành flower_type
ROUND(AVG(petal_length * petal_width * PI() / 4), 2) AS avg_petal_area	Tính diện tích trung bình theo hình elip, làm tròn 2 chữ số
WHERE petal_length IS NOT NULL AND petal_width IS NOT NULL AND species IS NOT NULL	Loại bỏ các dòng dữ liệu thiếu
GROUP BY species	Nhóm theo loài để tính trung bình
ORDER BY avg_petal_area DESC	Sắp xếp từ loài có diện tích lớn nhất xuống nhỏ nhất

Bài 2.1 – Phân tích bông hoa bất thường
a. Mục tiêu
- Xác định bông hoa “bất thường” dựa trên độ thon của cánh hoa: 
Độ thon = petal_length / petal_width
- Quy tắc: bông hoa bất thường nếu độ thon > 4.0 
- Đếm số lượng bông bất thường theo từng loài 
- Kết quả: 3 dòng, 2 cột
b. Phân tích dữ liệu
- Loài hoa (species): setosa, versicolor, virginica
- Chiều dài và chiều rộng cánh hoa: petal_length, petal_width
- Lọc dữ liệu: bỏ các dòng có giá trị NULL để không gây sai lệch
- Tính độ thon: petal_length / petal_width
- Lọc các bông hoa bất thường: > 4.0
- Nhóm theo loài để đếm số lượng
c. Câu lệnh SQL
SELECT 
    species,
    COUNT(*) AS abnormal_count
FROM iris
WHERE petal_length IS NOT NULL 
    AND petal_width IS NOT NULL
    AND species IS NOT NULL
    AND (petal_length / petal_width) > 4.0
GROUP BY species;
GO

Giải thích từng phần
Dòng code	Ý nghĩa
species	Lấy tên loài
COUNT(*) AS abnormal_count	Đếm số bông hoa bất thường
WHERE ... AND (petal_length / petal_width) > 4.0	Lọc các bông hoa có độ thon > 4
GROUP BY species	Nhóm theo loài để đếm

Bài 2.2 – Dán nhãn kích thước cánh hoa
a.  Mục tiêu
- Thay vì nhìn con số dài/ ngắn, gán nhãn kích thước giúp đọc dữ liệu nhanh hơn.
- Phân loại từng bông hoa theo chiều dài cánh (petal_length):
+ Nhỏ: < 2.0
+ Trung bình: 2.0 – 5.0
+ Lớn: > 5.0
- Đếm số bông hoa thuộc mỗi nhóm trong từng loài, bỏ các nhóm không có dòng dữ liệu.
b. Phân tích dữ liệu
- Cột cần dùng: petal_length, species
- Loại bỏ các giá trị NULL ở petal_length
- Tạo cột mới size_group dựa trên nhãn “Small”, “Medium”, “Large”
- Nhóm theo loài và nhãn rồi đếm số bông hoa
- Sắp xếp theo loài và nhãn để quan sát dễ dàng
c. Câu lệnh SQL
SELECT
    species AS flower_species,
    CASE
        WHEN petal_length < 2.0 THEN 'Small'
        WHEN petal_length BETWEEN 2.0 AND 5.0 THEN 'Medium'
        WHEN petal_length > 5.0 THEN 'Large'
    END AS size_group,
    COUNT(*) AS flower_count
FROM iris
WHERE petal_length IS NOT NULL 
GROUP BY
    species,
    CASE
        WHEN petal_length < 2.0 THEN 'Small'
        WHEN petal_length BETWEEN 2.0 AND 5.0 THEN 'Medium'
        WHEN petal_length > 5.0 THEN 'Large'
    END
ORDER BY
    species,
    size_group;

Giải thích từng phần
Dòng code	Ý nghĩa
species AS flower_species	Lấy tên loài, đổi tên cột thành flower_species
CASE ... END AS size_group	Gán nhãn “Small/Medium/Large” dựa trên chiều dài cánh (petal_length)
COUNT(*) AS flower_count	Đếm số bông hoa trong mỗi nhóm của từng loài
WHERE petal_length IS NOT NULL	Loại bỏ dữ liệu thiếu chiều dài cánh
GROUP BY species, CASE ... END	Nhóm theo loài và nhóm kích thước để tính số lượng
ORDER BY species, size_group	Sắp xếp kết quả theo tên loài và nhãn kích thước để dễ quan sát
Bài 3.1 – Kẻ vượt mặt
a. Mục tiêu
- Virginica là loài lớn nhất, nhưng không chắc tất cả bông hoa đều vượt trội về diện tích cánh hoa so với loài Versicolor.
- Mục tiêu: tìm tất cả bông Virginica có diện tích cánh hoa lớn hơn diện tích trung bình của Versicolor.
- Diện tích cánh hoa được tính bằng:
PI()/4 * petal_length * petal_width 
(về mặt toán học thì công thức (Length * Width * PI()) / 4 là như nhau.) 
- Kết quả trả về toàn bộ thông tin cột của những bông hoa đó.
b. Phân tích dữ liệu
- Cột cần dùng: sepal_length, sepal_width, petal_length, petal_width, species
- Tính diện tích cánh hoa cho từng bông hoa Virginica.
- Tính diện tích cánh hoa trung bình của loài Versicolor (truy vấn con).
- Lọc ra những bông Virginica có diện tích lớn hơn giá trị trung bình này.
- Bỏ các dòng thiếu dữ liệu ở petal_length hoặc petal_width.
- Loại bỏ các giá trị NULL
c. Câu lệnh SQL
SELECT
    sepal_length,
    sepal_width,
    petal_length, 
    petal_width,
    species
FROM iris
WHERE species = 'virginica'
  AND (PI()/4 * petal_length * petal_width) > (
  --Truy vấn con tính ver trước sau đó mới truy vấn chính 
      SELECT AVG(PI()/4 * petal_length * petal_width)
      FROM iris
      WHERE species = 'versicolor'
        AND petal_length IS NOT NULL
        AND petal_width IS NOT NULL
  )
  AND petal_length IS NOT NULL
  AND petal_width IS NOT NULL;

Giải thích từng phần
Dòng code	Ý nghĩa
SELECT sepal_length, sepal_width, petal_length, petal_width, species	Chọn toàn bộ thông tin cần hiển thị của bông hoa
FROM iris WHERE species = 'virginica'	Chỉ xét những bông hoa thuộc loài Virginica
(PI()/4 * petal_length * petal_width) > (...)	Lọc những bông Virginica có diện tích cánh hoa lớn hơn trung bình Versicolor
SELECT AVG(PI()/4 * petal_length * petal_width) FROM iris WHERE species = 'versicolor' ...	Truy vấn con tính diện tích trung bình của Versicolor
AND petal_length IS NOT NULL AND petal_width IS NOT NULL	Loại bỏ các dòng thiếu dữ liệu, tránh tính toán sai

Bài 3.2 – Bông hoa toàn diện
a. Mục tiêu
- Một bông hoa vượt trội ở một chỉ số thì đơn giản, nhưng vượt trội ở cả bốn chỉ số cùng lúc so với mức trung bình của loài mình thì khó hơn.
- Mục tiêu: tìm và đếm số bông hoa mà tất cả các chỉ số (sepal_length, sepal_width, petal_length, petal_width) đều vượt mức trung bình của loài đó.
- Kết quả: bảng gồm tên loài và số bông hoa thỏa 4 điều kiện.
b. Phân tích dữ liệu
- Cột cần dùng: sepal_length, sepal_width, petal_length, petal_width, species
- Tính trung bình của mỗi loài cho 4 chỉ số có thể dùng truy vấn con hoặc JOIN.
- Lọc những bông hoa có cả 4 chỉ số vượt mức trung bình loài mình.
- Đếm số bông theo loài (GROUP BY species).
- Loại bỏ các dòng thiếu dữ liệu (NULL) để tránh tính toán sai.
- Giúp so sánh mức độ vượt trội đồng đều giữa các loài.
c. Câu lệnh SQL
SELECT 
    f.species,
    COUNT(*) AS num_flowers
FROM iris AS f
JOIN (
    SELECT 
        species,
        AVG(sepal_length) AS avg_sepal_length,
        AVG(sepal_width)  AS avg_sepal_width,
        AVG(petal_length) AS avg_petal_length,
        AVG(petal_width)  AS avg_petal_width
    FROM iris
    WHERE sepal_length IS NOT NULL
      AND sepal_width  IS NOT NULL
      AND petal_length IS NOT NULL
      AND petal_width  IS NOT NULL
      AND species IS NOT NULL
    GROUP BY species
) AS a
ON f.species = a.species
WHERE 
    f.sepal_length IS NOT NULL
    AND f.sepal_width  IS NOT NULL
    AND f.petal_length IS NOT NULL
    AND f.petal_width  IS NOT NULL
    AND f.species IS NOT NULL
    AND f.sepal_length > a.avg_sepal_length
    AND f.sepal_width  > a.avg_sepal_width
    AND f.petal_length > a.avg_petal_length
    AND f.petal_width  > a.avg_petal_width
GROUP BY f.species;

Giải thích từng phần
Dòng code	Ý nghĩa
SELECT f.species, COUNT(*) AS num_flowers	Trả về tên loài và số bông hoa thỏa 4 điều kiện
FROM iris AS f	Dữ liệu gốc được đặt bí danh (f)
JOIN ( ... ) AS a ON f.species = a.species	Truy vấn con tính trung bình 4 chỉ số theo loài và kết nối với từng bông hoa
AVG(sepal_length) AS avg_sepal_length, ...	Tính trung bình từng chỉ số cho mỗi loài
WHERE f.sepal_length > a.avg_sepal_length ...	Lọc bông hoa vượt trội ở cả 4 chỉ số so với trung bình loài mình
GROUP BY f.species	Đếm số bông theo loài

Bài 4.1 – Vùng giao thoa
a. Mục tiêu
- Versicolor và Virginica có chiều dài đài hoa (sepal_length) khá gần nhau, dẫn đến khả năng nhầm lẫn nếu chỉ nhìn mỗi chỉ số này.
- Xác định vùng giao thoa giữa hai loài: từ giá trị nhỏ nhất của Virginica đến giá trị lớn nhất của Versicolor (cả hai đầu mút được tính vào).
- Đếm tổng số bông hoa của cả hai loài nằm trong vùng giao thoa.
b. Phân tích dữ liệu
- Cột cần dùng: sepal_length, species
- Tìm đầu mút trái: giá trị nhỏ nhất của sepal_length ở Virginica dùng subquery 1.
- Tìm đầu mút phải: giá trị lớn nhất của sepal_length ở Versicolor dùng subquery 2.
- Lọc tất cả các bông hoa thuộc hai loài mà sepal_length nằm trong khoảng [min_virginica, max_versicolor].
- Đếm tổng số bông hoa thỏa điều kiện để trả về 1 dòng, 1 cột.
c. Câu lệnh SQL
SELECT COUNT(*) AS total_flowers_in_overlap
FROM iris
WHERE species IN ('versicolor', 'virginica')
  AND sepal_length IS NOT NULL
  AND sepal_length >= (
        -- đầu trái: giá trị lớn hơn trong hai giá trị MIN
        SELECT GREATEST(
            (SELECT MIN(sepal_length) FROM iris WHERE species = 'versicolor' AND sepal_length IS NOT NULL),
            (SELECT MIN(sepal_length) FROM iris WHERE species = 'virginica' AND sepal_length IS NOT NULL)
        )
      ) 
  AND sepal_length <= (
        -- đầu phải: giá trị nhỏ hơn trong hai giá trị MAX
        SELECT LEAST(
            (SELECT MAX(sepal_length) FROM iris WHERE species = 'versicolor' AND sepal_length IS NOT NULL),
            (SELECT MAX(sepal_length) FROM iris WHERE species = 'virginica' AND sepal_length IS NOT NULL) 
        )
      );

Giải thích từng phần
Dòng code	Ý nghĩa
SELECT COUNT(*) AS total_flowers_in_overlap	Đếm tổng số bông hoa nằm trong vùng giao thoa
FROM iris WHERE species IN ('versicolor', 'virginica')	Chỉ xét hai loài liên quan
AND sepal_length IS NOT NULL	Loại bỏ giá trị NULL để tính toán chính xác
sepal_length >= (SELECT GREATEST(...))	Đầu trái: lấy giá trị lớn hơn giữa MIN của Versicolor và MIN của Virginica tìm vùng bắt đầu giao thoa từ giá trị thực sự trùng nhau
sepal_length <= (SELECT LEAST(...))	Đầu phải: lấy giá trị nhỏ hơn giữa MAX của Versicolor và MAX của Virginica tìm vùng kết thúc giao thoa trước khi vượt ra ngoài
Bài 4.2 – Bông hoa đại diện
a. Mục tiêu
Mỗi loài có một “chân dung trung bình” tập hợp các giá trị trung bình của 4 chỉ số: sepal_length, sepal_width, petal_length, petal_width.
Mục tiêu: tìm bông hoa thực tế gần với chân dung trung bình nhất của loài.
Khoảng cách đo bằng Manhattan distance:
distance=∣sepal_length-avg_sl∣+∣sepal_width-avg_sw∣+∣petal_length-avg_pl∣+∣petal_width-avg_pw∣
Kết quả: 6 cột — 4 chỉ số, species và distance. Có thể có nhiều bông cùng khoảng cách nhỏ nhất.
b.  Phân tích dữ liệu
- Cột cần dùng: sepal_length, sepal_width, petal_length, petal_width, species.
- Tính trung bình theo loài cho từng chỉ số (avg_sl, avg_sw, avg_pl, avg_pw).
- Tính khoảng cách Manhattan của từng bông hoa so với trung bình loài.
- Xếp hạng distance trong từng loài (RANK() OVER(PARTITION BY species ORDER BY distance ASC)).
- Chọn bông hoa có distance nhỏ nhất (rnk = 1).
-Bông hoa nào có giá trị distance nhỏ nhất mà bằng nhau thì vẫn lấy
c. Câu lệnh SQL
WITH Stats_CTE AS (
        SELECT 
        sepal_length, sepal_width, petal_length, petal_width, species,
        AVG(sepal_length) OVER(PARTITION BY species) AS avg_sl,
        AVG(sepal_width)  OVER(PARTITION BY species) AS avg_sw,
        AVG(petal_length) OVER(PARTITION BY species) AS avg_pl,
        AVG(petal_width)  OVER(PARTITION BY species) AS avg_pw
    FROM iris
    WHERE sepal_length IS NOT NULL 
      AND sepal_width  IS NOT NULL 
      AND petal_length IS NOT NULL 
      AND petal_width  IS NOT NULL
),
Distance_CTE AS (
    SELECT 
        sepal_length, sepal_width, petal_length, petal_width, species,
        (ABS(sepal_length - avg_sl) + ABS(sepal_width - avg_sw) + 
         ABS(petal_length - avg_pl) + ABS(petal_width - avg_pw)) AS distance
    FROM Stats_CTE
),
Ranked_CTE AS (
    SELECT 
        *,
        RANK() OVER(PARTITION BY species ORDER BY distance ASC) AS rnk
    FROM Distance_CTE
)
SELECT 
    sepal_length, sepal_width, petal_length, petal_width, species, distance
FROM Ranked_CTE
WHERE rnk = 1;


Giải thích từng phần
Dòng code	Ý nghĩa
WITH Stats_CTE AS (...)	Tạo bảng ảo CTE, tính trung bình các chỉ số theo loài cho từng bông hoa bằng OVER(PARTITION BY species) mà không gộp các dòng.
Distance_CTE AS (...)	Tính Manhattan distance của từng bông hoa so với trung bình loài.
RANK() OVER(PARTITION BY species ORDER BY distance ASC)	Gán thứ hạng cho từng bông hoa theo loài, khoảng cách nhỏ nhất được xếp thứ 1.
WHERE rnk = 1	Chọn bông hoa  distance nhỏ nhất. Nếu nhiều bông có distance nhỏ nhất, sẽ lấy tất cả.

Bài 5.1 – Ranh giới tuyệt đối
a. Mục tiêu
Kiểm tra xem có thể phân loại setosa ra khỏi hai loài còn lại chỉ bằng một ngưỡng duy nhất của petal_length hay không.
Kết quả: đếm số bông hoa được phân loại đúng và sai.
b. Phân tích dữ liệu
- Cột cần dùng: petal_length, species.
- Tìm ngưỡng phân loại:
Ngưỡng = (giá trị lớn nhất petal_length của setosa
+ giá trị nhỏ nhất petal_length của các loài còn lại) / 2
- Nếu species = 'setosa' và petal_length <= threshold  thì dự đoán đúng.
- Nếu species khác 'setosa' và petal_length > threshold thì dự đoán đúng.
- Các trường hợp còn lại thì dự đoán sai.
- Lọc NULL để tránh tính toán sai.
c. Câu lệnh SQL
WITH Threshold AS (
    SELECT 
        (MAX(CASE WHEN species = 'setosa' THEN petal_length END) +
         MIN(CASE WHEN species <> 'setosa' THEN petal_length END)) / 2.0 AS threshold_value
    FROM iris
    WHERE petal_length IS NOT NULL
      AND species IS NOT NULL
)
SELECT 
    CASE 
        WHEN (species = 'setosa' AND petal_length <= t.threshold_value)
          OR (species <> 'setosa' AND petal_length > t.threshold_value)
        THEN CAST(1 AS BIT)  -- TRUE
        ELSE CAST(0 AS BIT)  -- FALSE
    END AS ket_qua,
    COUNT(*) AS so_luong
FROM iris
CROSS JOIN Threshold AS t 
WHERE petal_length IS NOT NULL
  AND species IS NOT NULL
GROUP BY 
    CASE 
        WHEN (species = 'setosa' AND petal_length <= t.threshold_value)
          OR (species <> 'setosa' AND petal_length > t.threshold_value)
        THEN CAST(1 AS BIT)
        ELSE CAST(0 AS BIT)
    END;

Giải thích từng phần
Phần code	Giải thích
WITH Threshold AS (...)	Tạo ngưỡng phân loại duy nhất bằng trung bình giữa max của setosa và min của non-setosa.
CROSS JOIN Threshold AS t	Kết hợp ngưỡng với từng bông hoa để áp dụng luật phân loại trực tiếp.
CASE WHEN ... THEN CAST(1 AS BIT) ELSE CAST(0 AS BIT)	Tạo cột ket_qua: 1 = dự đoán đúng, 0 = dự đoán sai.
COUNT(*) AS so_luong	Đếm số bông hoa dự đoán đúng hoặc sai.
GROUP BY CASE ...	Nhóm kết quả theo ket_qua, tạo bảng tổng hợp số lượng đúng/sai.

3. Kết quả thực nghiệm 
Phân tích dữ liệu đã minh chứng các giả thuyết thống kê một cách mạnh mẽ:
Khả năng Tách biệt Tuyến tính (Linear Separability): Loài Setosa nằm hoàn toàn độc lập trong không gian chiều petal. Kết quả từ mô hình bài 5.1 chứng minh rằng chỉ cần một ranh giới (Decision Boundary) duy nhất trên trục petal_length, ta có thể phân loại Setosa với độ chính xác (Accuracy) tuyệt đối.
Hiện tượng Chồng lấn Mật độ (Density Overlap): Khác với Setosa, Versicolor và Virginica chia sẻ một không gian giao thoa lớn ở kích thước đài hoa (sepal). Việc sử dụng các mô hình tuyến tính đơn giản tại khu vực này sẽ dẫn đến sai số phân loại rất lớn.
Độ phân tán dữ liệu: Luôn tồn tại các giá trị cực đoan (Outliers) phá vỡ các phân phối chuẩn thông thường, đòi hỏi quá trình dọn dẹp dữ liệu (Data Cleaning) phải được thực hiện gắt gao.
Sự tồn tại của nhiễu: Dù là bộ dữ liệu chuẩn mực, SQL vẫn tìm ra được các cá thể "đột biến" có độ thon lớn (> 4.0) hoặc kích thước khổng lồ vượt xa mức trung bình của giống loài.
4. Bài học chuyên môn rút ra 
- Lỗ hổng NULL và Lập trình phòng thủ (Defensive Querying): Việc bọc các điều kiện bằng IS NOT NULL là nguyên tắc sống còn. Hệ quản trị CSDL xử lý NULL theo logic 3 ngôi (Three-valued logic: -  - True, False, Unknown). Nếu để NULL rò rỉ vào hàm AVG(), phương sai và giá trị trung bình sẽ bị lệch lạc, phá hỏng toàn bộ công trình nghiên cứu.
- Hiệu năng của CTE (Common Table Expressions): Trong bài toán tính khoảng cách (Bài 4.2), việc dùng WITH không chỉ giúp mã nguồn tuân thủ nguyên tắc Clean Code mà còn giúp bộ tối ưu hóa (Query Optimizer) của Engine lập kế hoạch thực thi (Execution Plan) tốt hơn hẳn so với việc lồng ghép hàng loạt Subquery.
- Kiểm soát luồng thực thi bằng CTE: Phân tích dữ liệu bằng SQL rất dễ sa đà vào "spaghetti code" (subquery lồng nhau vô tận). Việc dùng WITH tách biệt bước tính toán trung bình/ngưỡng giúp mã nguồn mang tính module, dễ bảo trì và dễ giải thích (explainable) cho hội đồng hay đồng nghiệp.
-Sức mạnh của In-Database Analytics: SQL hiện đại sở hữu sức mạnh tính toán toán học to lớn. Thay vì tốn chi phí I/O (Input/Output) mạng để kéo hàng triệu dòng dữ liệu lên tầng Application xử lý, ta đẩy logic toán học xuống tầng Database để tối ưu hóa hiệu suất toàn hệ thống.
- Đọc một cách hết tài liệu từ đầu đến cuối để hiểu tổng quan về vấn đề mình đang đối mặt sau đó mới đi vào chi tiết rôi mới đưa ra được kết luận. Hiểu được vấn đề khó hay dễ để đưa ra giải pháp làm việc một cách khoa học nhất.
5. Khám phá và Nhận định cá nhân 
Sau nhiều năm làm việc với cơ sở dữ liệu, phân tích tập Iris mang lại cho tôi những suy ngẫm sâu sắc:
- "Nghịch lý độ rộng đài hoa" (The Sepal Width Paradox): Trực giác của con người luôn ưu tiên tính đồng dạng (bông hoa nhỏ thì mọi bộ phận đều nhỏ). Tuy nhiên, nếu trực quan hóa dữ liệu, ta phát hiện một thực tế: Setosa là loài có cánh hoa bé nhất, nhưng lại sở hữu chiều rộng đài hoa trung bình lớn nhất trong ba loài. Bài học rút ra: Trực giác của Data Analyst luôn có thể sai, chỉ có những con số được chứng minh thống kê mới là sự thật.
- Quản trị Rủi ro Toán học (Math Exceptions): Ở mệnh đề tính độ thon (petal_length / petal_width), mặc dù dữ liệu Iris gốc không có số 0, nhưng nếu triển khai code này lên hệ thống thời gian thực (Real-time IoT sensors), một lỗi phần cứng khiến cảm biến trả về giá trị 0 sẽ gây ra lỗi Divide by Zero Exception, làm sập toàn bộ luồng pipeline dữ liệu. Tôi luôn khuyến nghị bọc các phép chia bằng NULLIF(petal_width, 0) như một tiêu chuẩn vận hành (SOP).
- Tính tương thích của SQL Dialects: Việc sử dụng các hàm như GREATEST/LEAST (Bài 4.1) cho thấy tư duy giải quyết vấn đề cực kỳ linh hoạt. Tuy nhiên, một kiến trúc sư dữ liệu cần lưu ý rằng mã này không đạt tiêu chuẩn ANSI SQL hoàn toàn. Nếu hệ thống lõi đang sử dụng T-SQL (SQL Server bản cũ), ta bắt buộc phải viết lại bằng các mệnh đề CASE WHEN lồng nhau. Hiểu rõ công cụ đang dùng là giới hạn sống còn của một kỹ sư hệ thống.
- Nếu bạn vẽ biểu đồ phân phối dữ liệu ra, bạn sẽ thấy một hiện tượng thực nghiệm rất thú vị: Setosa là loài có cánh hoa (Petal) nhỏ nhất, nhưng lại có chiều rộng đài hoa (Sepal Width) trung bình lớn nhất.
Đây là một bài học xương máu trong nghiên cứu dữ liệu: Không bao giờ được dùng trực giác cá nhân ("hoa nhỏ thì mọi bộ phận đều nhỏ") để áp đặt lên tập dữ liệu. Dữ liệu thực tế thường đi ngược lại trực giác cơ bản, và nhiệm vụ của chúng ta là để những con số lên tiếng.
PHẦN III. TÀI LIỆU THAM KHẢO
Anderson, E., 1935. The irises of the Gaspé Peninsula. Bulletin of the American Iris Society, 59, tr.2-5.
Anderson, E., 1936. The species problem in Iris. Annals of the Missouri Botanical Garden, 23(3), tr.457-509.
Fisher, R.A., 1936. The use of multiple measurements in taxonomic problems. Annals of Eugenics, 7(2), tr.179-188.
Fisher, R.A. và Anderson, E., 1988. Iris. UCI Machine Learning Repository. [Trực tuyến] Có tại: https://archive.ics.uci.edu/dataset/53/iris [Truy cập ngày 26 tháng 3 năm 2026].
Duda, R.O., Hart, P.E. và Stork, D.G., 2001. Pattern classification. Ấn bản lần 2. New York: John Wiley & Sons. (Nguồn uy tín hàng đầu về nhận dạng mẫu, thường xuyên sử dụng Iris để minh họa cho sự cô lập của Setosa và sự chồng lấn của Versicolor/Virginica).
Fisher, R.A., 1936. The use of multiple measurements in taxonomic problems. Annals of Eugenics, 7(2), tr.179-188.
VanMSFT (2024). SELECT (Transact-SQL) - SQL Server. [online] Microsoft.com. Available at: https://learn.microsoft.com/en-us/sql/t-sql/queries/select-transact-sql?view=sql-server-ver17.
‌




