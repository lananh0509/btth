USE `session5-qlct`;
-- EX2
ALTER TABLE `building`
ADD CONSTRAINT `fk_building_host_n`
FOREIGN KEY (`host_id`) REFERENCES `host`(`id`);

-- Thêm khóa ngoại `contractor_id` vào bảng `building`
ALTER TABLE `building`
ADD CONSTRAINT `fk_building_contractor_n`
FOREIGN KEY (`contractor_id`) REFERENCES `contractor`(`id`);

-- Thêm khóa ngoại `building_id` và `architect_id` vào bảng `design`
ALTER TABLE `design`
ADD CONSTRAINT `fk_design_building_n`
FOREIGN KEY (`building_id`) REFERENCES `building`(`id`),
ADD CONSTRAINT `fk_design_architect_n`
FOREIGN KEY (`architect_id`) REFERENCES `architect`(`id`);

-- Thêm khóa ngoại `building_id` và `worker_id` vào bảng `work`
ALTER TABLE `work`
ADD CONSTRAINT `fk_work_building_n`
FOREIGN KEY (`building_id`) REFERENCES `building`(`id`),
ADD CONSTRAINT `fk_work_worker_n`
FOREIGN KEY (`worker_id`) REFERENCES `worker`(`id`);

-- EX3
-- Hiển thị thông tin công trình có chi phí cao nhất
SELECT * 
FROM building
WHERE cost = (
	SELECT MAX(cost) FROM building
    );

-- Hiển thị thông tin công trình có chi phí lớn hơn tất cả các công trình được xây dựng ở Cần Thơ
SELECT * FROM building
WHERE cost > ALL (
    SELECT cost FROM building
    WHERE city = 'can tho'
);

-- Hiển thị thông tin công trình có chi phí lớn hơn một trong các công trình được xây dựng ở Cần Thơ
SELECT * FROM building
WHERE cost > ANY (
    SELECT cost FROM building
    WHERE city = 'can tho'
);

-- Hiển thị thông tin công trình chưa có kiến trúc sư thiết kế
SELECT * FROM `building`
WHERE `id` NOT IN (
    SELECT `building_id` 
    FROM `design`
);

-- Hiển thị thông tin các kiến trúc sư cùng năm sinh và cùng nơi tốt nghiệp
SELECT * FROM architect a
JOIN architect b
ON a.birthday = b.birthday
AND a.place = b.place
AND a.id < b.id;

-- EX4
-- Hiển thị thù lao trung bình của từng kiến trúc sư
SELECT architect_id, AVG(benefit) AS `Thù lao trung bình`
FROM design
GROUP BY architect_id;

-- Hiển thị chi phí đầu tư cho các công trình ở mỗi thành phố
SELECT SUM(cost), city AS `Thành phố`
FROM building
GROUP BY city;

-- Tìm các công trình có chi phí trả cho kiến trúc sư lớn hơn 50
SELECT * FROM design d
JOIN building b ON d.building_id = b.id
WHERE d.benefit > 50;

-- Tìm các thành phố có ít nhất một kiến trúc sư tốt nghiệp
SELECT DISTINCT place
FROM architect
WHERE id IN (SELECT architect_id FROM design);

-- EX5

-- Hiển thị tên công trình, tên chủ nhân và tên chủ thầu của công trình đó
SELECT b.name AS building_name, c.name AS contractor_name, 
h.name AS host_name FROM building b 
JOIN contractor c ON b.contractor_id = c.id 
JOIN host h ON b.host_id = h.id;

-- Hiển thị tên công trình (building), tên kiến trúc sư (architect) và thù lao của kiến trúc sư ở mỗi công trình (design)
SELECT b.name AS building_name, a.name AS architect_name, 
d.benefit AS `Thù lao` FROM design d 
JOIN building b ON d.building_id = b.id 
JOIN architect a ON d.architect_id = a.id;

-- Hãy cho biết tên và địa chỉ công trình (building) do chủ thầu Công ty xây dựng số 6 thi công (contractor)
SELECT b.name AS building_name, b.address AS building_address 
FROM building b JOIN contractor c ON b.contractor_id = c.id
WHERE c.name = 'cty xd so 6';

-- Tìm tên và địa chỉ liên lạc của các chủ thầu (contractor) thi công công trình ở Cần Thơ (building) do kiến trúc sư Lê Kim Dung thiết kế (architect, design)
SELECT DISTINCT c.name, c.phone, c.address 
FROM contractor c
JOIN building b ON b.contractor_id = c.id 
JOIN design d ON b.id = d.building_id
JOIN architect a ON d.architect_id = a.id 
WHERE b.city = 'can tho' AND a.name = 'le kim dung';

-- Hãy cho biết nơi tốt nghiệp của các kiến trúc sư (architect) đã thiết kế (design) công trình Khách Sạn Quốc Tế ở Cần Thơ (building)
SELECT DISTINCT a.name, a.place FROM architect a
JOIN design d ON d.architect_id = a.id
JOIN building b ON d.building_id = b.id
WHERE b.name = 'khach san quoc te' AND b.city = 'can tho';

-- Cho biết họ tên, năm sinh, năm vào nghề của các công nhân có chuyên môn hàn hoặc điện (worker) đã tham gia các công trình (work) mà chủ thầu Lê Văn Sơn (contractor) đã trúng thầu (building)
SELECT wk.name, wk.birthday, wk.year AS strarted_year 
FROM worker wk JOIN `work` w ON w.worker_id = wk.id
JOIN building b ON w.building_id = b.id
JOIN contractor c ON b.contractor_id = c.id
WHERE c.name = 'le trung son' AND wk.skill = 'han' OR 'dien';

-- Những công nhân nào (worker) đã bắt đầu tham gia công trình Khách sạn Quốc Tế ở Cần Thơ (building) trong giai đoạn từ ngày 15/12/1994 đến 31/12/1994 (work) số ngày tương ứng là bao nhiêu
SELECT wk.name, w.date AS strart_date, w.total
FROM worker wk
JOIN work w ON wk.id = w.worker_id
JOIN building b ON w.building_id = b.id
WHERE b.name = 'khach san quoc te' AND b.city = 'can tho'
AND w.date BETWEEN '1994-12-15' AND '1994-12-31';

-- Cho biết họ tên và năm sinh của các kiến trúc sư đã tốt nghiệp ở TP Hồ Chí Minh (architect) và đã thiết kế ít nhất một công trình (design) có kinh phí đầu tư trên 400 triệu đồng (building)
SELECT DISTINCT a.name, a.birthday
FROM architect a
JOIN design d ON a.id = d.architect_id
JOIN building b ON d.building_id = b.id
WHERE a.place = 'tp hcm' AND b.cost > 400000000;

-- Cho biết tên công trình có kinh phí cao nhất
SELECT name
FROM building
WHERE cost = (
	SELECT MAX(cost) FROM building
    );
    
-- Cho biết tên các kiến trúc sư (architect) vừa thiết kế các công trình (design) do Phòng dịch vụ sở xây dựng (contractor) thi công vừa thiết kế các công trình do chủ thầu Lê Văn Sơn thi công
SELECT a.name
FROM architect a
JOIN design d1 ON a.id = d1.architect_id
JOIN building b1 ON d1.building_id = b1.id
JOIN contractor c1 ON b1.contractor_id = c1.id
JOIN design d2 ON a.id = d2.architect_id
JOIN building b2 ON d2.building_id = b2.id
JOIN contractor c2 ON b2.contractor_id = c2.id
WHERE c1.name = 'phong dich vu so xd' AND c2.name = 'le van son';

-- Cho biết họ tên các công nhân (worker) có tham gia (work) các công trình ở Cần Thơ (building) nhưng không có tham gia công trình ở Vĩnh Long
SELECT DISTINCT wk.name
FROM worker wk
JOIN work w ON wk.id = w.worker_id
JOIN building b ON w.building_id = b.id
WHERE b.city = 'can tho'
AND wk.id NOT IN (
    SELECT DISTINCT w.worker_id
    FROM work w
    JOIN building b ON w.building_id = b.id
    WHERE b.city = 'vinh long'
);

--  Cho biết tên của các chủ thầu đã thi công các công trình có kinh phí lớn hơn tất cả các công trình do chủ thầu phòng Dịch vụ Sở xây dựng thi công
SELECT DISTINCT c.name
FROM contractor c
JOIN building b ON c.id = b.contractor_id
WHERE b.cost > ALL (
    SELECT cost
    FROM building b
    JOIN contractor c ON b.contractor_id = c.id
    WHERE c.name = 'phong dich vu so xd'
);

-- Cho biết họ tên các kiến trúc sư có thù lao thiết kế một công trình nào đó dưới giá trị trung bình thù lao thiết kế cho một công trình
SELECT DISTINCT a.name
FROM architect a
JOIN design d ON a.id = d.architect_id
JOIN building b ON d.building_id = b.id
WHERE b.cost < (SELECT AVG(cost) FROM building);

-- Tìm tên và địa chỉ những chủ thầu đã trúng thầu công trình có kinh phí thấp nhất
SELECT DISTINCT c.name, c.address
FROM contractor c
JOIN building b ON c.id = b.contractor_id
WHERE b.cost = (SELECT MIN(cost) FROM building);

-- Tìm họ tên và chuyên môn của các công nhân (worker) tham gia (work) các công trình do kiến trúc sư Le Thanh Tung thiet ke (architect) (design)
SELECT wk.name, wk.skill
FROM worker wk
JOIN work w ON wk.id = w.worker_id
JOIN building b ON w.building_id = b.id
JOIN design d ON b.id = d.building_id
JOIN architect a ON d.architect_id = a.id
WHERE a.name = 'le thanh tung';

-- Tìm các cặp tên của chủ thầu có trúng thầu các công trình tại cùng một thành phố
SELECT DISTINCT c1.name, c2.name
FROM contractor c1
JOIN building b1 ON c1.id = b1.contractor_id
JOIN contractor c2 ON c2.id = b1.contractor_id
JOIN building b2 ON c2.id = b2.contractor_id
WHERE b1.city = b2.city AND c1.id != c2.id;

-- Tìm tổng kinh phí của tất cả các công trình theo từng chủ thầu
SELECT c.name, SUM(b.cost) AS `Tổng kinh phí`
FROM contractor c
JOIN building b ON c.id = b.contractor_id
GROUP BY c.name;

-- Cho biết họ tên các kiến trúc sư có tổng thù lao thiết kế các công trình lớn hơn 25 triệu
SELECT a.name
FROM architect a
JOIN design d ON a.id = d.architect_id
JOIN building b ON d.building_id = b.id
GROUP BY a.name
HAVING SUM(b.cost) > 25000000;

-- Cho biết số lượng các kiến trúc sư có tổng thù lao thiết kế các công trình lớn hơn 25 triệu
SELECT COUNT(DISTINCT a.name)
FROM architect a
JOIN design d ON a.id = d.architect_id
JOIN building b ON d.building_id = b.id
GROUP BY a.name
HAVING SUM(b.cost) > 25000000;

-- Tìm tổng số công nhân đã than gia ở mỗi công trình
SELECT b.name AS building_name, COUNT(wk.worker_id) AS total_workers
FROM building b
JOIN work wk ON b.id = wk.building_id
GROUP BY b.name;

-- Tìm tên và địa chỉ công trình có tổng số công nhân tham gia nhiều nhất
SELECT b.name, b.address
FROM building b
JOIN work w ON b.id = w.building_id
GROUP BY b.name, b.address
ORDER BY COUNT(w.worker_id) DESC
LIMIT 1;

-- Cho biêt tên các thành phố và kinh phí trung bình cho mỗi công trình của từng thành phố tương ứng
SELECT b.city, AVG(b.cost) AS avg_cost
FROM building b
GROUP BY b.city;

-- Cho biêt tên các thành phố và kinh phí trung bình cho mỗi công trình của từng thành phố tương ứng
SELECT wk.name
FROM worker AS wk
JOIN work AS w ON wk.id = w.worker_id
GROUP BY wk.id
HAVING SUM(CAST(w.total AS SIGNED)) > 
    (SELECT SUM(CAST(w2.total AS SIGNED))
     FROM work AS w2 
     JOIN worker AS wk2 ON wk2.id = w2.worker_id 
     WHERE wk2.name = 'Nguyễn Hồng Vân');

-- Cho biết tổng số công trình mà mỗi chủ thầu đã thi công tại mỗi thành phố
SELECT c.name AS contractor_name, b.city, COUNT(b.id) AS `Tống số công trình`
FROM contractor AS c
JOIN building AS b ON c.id = b.contractor_id
GROUP BY c.id, b.city;

-- Cho biết họ tên công nhân có tham gia ở tất cả các công trình
SELECT wk.name
FROM worker AS wk
JOIN work AS w ON wk.id = w.worker_id
GROUP BY wk.id
HAVING COUNT(DISTINCT w.building_id) = (SELECT COUNT(id) FROM building);


