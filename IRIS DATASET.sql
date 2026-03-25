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
);
INSERT INTO iris (sepal_length, sepal_width, petal_length, petal_width, species) VALUES
/* Setosa */
(5.1, 3.0, 1.4, 0.1, 'setosa'),
(4.9, 3.2, 1.4, 0.2, 'setosa'),
(5.0, 2.9, 1.5, 0.1, 'setosa'),
(5.2, 3.0, 1.3, 0.2, 'setosa');
(5.2, 3.0, 1.4, 0.2, 'setosa'),
(5.1, 3.1, 1.4, 0.2, 'setosa'),
(5.0, 3.0, 1.5, 0.2, 'setosa'),
(5.0, 3.0, 1.4, 0.3, 'setosa');
(5.1, 3.5, 1.4, 0.2, 'setosa'),
(4.9, 3.0, 1.4, 0.2, 'setosa'),
(4.7, 3.2, 1.3, 0.2, 'setosa'),
(4.6, 3.1, 1.5, 0.2, 'setosa'),
(5.0, 3.6, 1.4, 0.2, 'setosa'),
(5.4, 3.9, 1.7, 0.4, 'setosa'),
(4.6, 3.4, 1.4, 0.3, 'setosa'),
(5.0, 3.4, 1.5, 0.2, 'setosa'),
(4.4, 2.9, 1.4, 0.2, 'setosa'),
(4.9, 3.1, 1.5, 0.1, 'setosa'),

/* Versicolor */
(7.0, 3.2, 4.7, 1.4, 'versicolor'),
(6.4, 3.2, 4.5, 1.5, 'versicolor'),
(6.9, 3.1, 4.9, 1.5, 'versicolor'),
(5.5, 2.3, 4.0, 1.3, 'versicolor'),
(6.5, 2.8, 4.6, 1.5, 'versicolor'),
(5.7, 2.8, 4.5, 1.3, 'versicolor'),
(6.3, 3.3, 4.7, 1.6, 'versicolor'),
(4.9, 2.4, 3.3, 1.0, 'versicolor'),

/* Virginica */
(6.3, 3.3, 6.0, 2.5, 'virginica'),
(5.8, 2.7, 5.1, 1.9, 'virginica'),
(7.1, 3.0, 5.9, 2.1, 'virginica'),
(6.3, 2.9, 5.6, 1.8, 'virginica'),
(6.5, 3.0, 5.8, 2.2, 'virginica'),
(7.6, 3.0, 6.6, 2.1, 'virginica'),
(4.9, 2.5, 4.5, 1.7, 'virginica');

-- Các giá trị NULL
(NULL, NULL, NULL, NULL, 'Virginica'),
(4.5, NULL, NULL, NULL, 'Virginica'),
(4.5, 1.5, NULL, NULL, NULL);
-- 1.1 ttosm tắt các cánh hoa theo loài

SELECT
    species AS flower_type,
    MIN(petal_length) AS min_petal_length,
    ROUND(AVG(petal_length), 2) AS avg_petal_length,
    MAX(petal_length) AS max_petal_length
FROM iris
WHERE petal_length IS NOT NULL
GROUP BY species
ORDER BY species;

--1.2
SELECT 
    species AS flower_type,
    ROUND(AVG(petal_length * petal_width * PI() / 4), 2) AS avg_petal_area
FROM iris
WHERE petal_length IS NOT NULL 
  AND petal_width IS NOT NULL
  AND species IS NOT NULL
GROUP BY species
ORDER BY avg_petal_area DESC;
--2.1
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

--2.2  lúc đầu em muốn dùng with để tạo bảng ảo nếu như có mở rộng 
SELECT
    species AS flower_species,
    CASE
        WHEN petal_length < 2.0 THEN 'Small'
        WHEN petal_length BETWEEN 2.0 AND 5.0 THEN 'Medium'
        WHEN petal_length > 5.0 THEN 'Large'
    END AS size_group,
    COUNT(*) AS flower_count -- có thể thay thế bằng SELECT DISTINCT nhưng sẽ không tối ưu hơn. sẽ đếm số lượng hoa thực thế và bỏ qua hoa mà không có dòng nào 
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

   -- 3.1
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

  -- 3.2
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
-- 4.1
SELECT COUNT(*) AS total_flowers_in_overlap
FROM iris
WHERE species IN ('versicolor', 'virginica')
  AND sepal_length IS NOT NULL
  AND sepal_length >= (
        -- đầu trái: giá trị lớn hơn trong hai giá trị MIN, bỏ NULL
        SELECT GREATEST(
            (SELECT MIN(sepal_length) FROM iris WHERE species = 'versicolor' AND sepal_length IS NOT NULL),
            (SELECT MIN(sepal_length) FROM iris WHERE species = 'virginica' AND sepal_length IS NOT NULL)
        )
      )
  AND sepal_length <= (
        -- đầu phải: giá trị nhỏ hơn trong hai giá trị MAX, bỏ NULL
        SELECT LEAST(
            (SELECT MAX(sepal_length) FROM iris WHERE species = 'versicolor' AND sepal_length IS NOT NULL),
            (SELECT MAX(sepal_length) FROM iris WHERE species = 'virginica' AND sepal_length IS NOT NULL)
        )
      );
--4.2
WITH Stats_CTE AS (
    -- Bước 1: Lấy dữ liệu gốc VÀ đính kèm giá trị trung bình của loài trên CÙNG 1 dòng
    -- (Không cần GROUP BY, không mất đi chi tiết của từng bông hoa)
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
    -- Bước 2: Tính khoảng cách Manhattan cho từng dòng
    SELECT 
        sepal_length, sepal_width, petal_length, petal_width, species,
        (ABS(sepal_length - avg_sl) + ABS(sepal_width - avg_sw) + 
         ABS(petal_length - avg_pl) + ABS(petal_width - avg_pw)) AS distance
    FROM Stats_CTE
),
Ranked_CTE AS (
    -- Bước 3: Xếp hạng khoảng cách từ nhỏ nhất (1) đến lớn nhất trong nội bộ từng loài
    SELECT 
        *,
        RANK() OVER(PARTITION BY species ORDER BY distance ASC) AS rnk
    FROM Distance_CTE
)
-- Bước 4: Lấy ra "Bông hoa đại diện" (hạng 1)
SELECT 
    sepal_length, sepal_width, petal_length, petal_width, species, distance
FROM Ranked_CTE
WHERE rnk = 1;

-- 5.1
WITH Threshold AS (
    -- Tính ngưỡng phân loại setosa / non-setosa
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