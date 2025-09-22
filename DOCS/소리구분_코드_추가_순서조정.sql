-- 기존 데이터 기반 소리구분 코드 추가 및 순서 조정
-- 현재 등록된 데이터: SV01~ETC09 (ord 1~9)
-- 새로 추가할 항목: 8번부터 시작, ETC는 맨 마지막으로 이동

-- 1. 먼저 ETC 순서를 임시로 변경 (나중에 맨 마지막으로 이동)
UPDATE tb_code 
SET ord = 999 
WHERE code_grp_cd = 'phonoDivCd' AND code = 'ETC09';

-- 2. 요구사항 기반 소리구분 코드 추가 (ord 8부터 시작)
INSERT INTO tb_code (
    code_grp_cd,
    code,
    code_nm,
    code_desc,
    use_yn,
    ord,
    reg_date
) VALUES 
-- 받침 관련
('phonoDivCd', 'BC08', '받침', '받침 소리 구분', 'Y', 8, NOW()),

-- 조음위치별 분류
('phonoDivCd', 'BP09', '양순음', '양순음 소리 구분 (ㅂ, ㅍ, ㅁ)', 'Y', 9, NOW()),
('phonoDivCd', 'AD10', '치조음', '치조음 소리 구분 (ㄷ, ㅌ, ㄴ, ㄹ)', 'Y', 10, NOW()),
('phonoDivCd', 'PP11', '경구개음', '경구개음 소리 구분 (ㅈ, ㅊ)', 'Y', 11, NOW()),
('phonoDivCd', 'VL12', '연구개음', '연구개음 소리 구분 (ㄱ, ㅋ, ㅇ)', 'Y', 12, NOW()),
('phonoDivCd', 'GL13', '후음', '후음 소리 구분 (ㅎ)', 'Y', 13, NOW()),

-- 추가 세분화 분류
('phonoDivCd', 'ELD14', '노인성난청훈련', '노인성 난청 훈련용 소리 구분', 'Y', 14, NOW());

-- 3. ETC를 맨 마지막 순서로 업데이트
UPDATE tb_code 
SET ord = 15, code = 'ETC15', upd_date = NOW()
WHERE code_grp_cd = 'phonoDivCd' AND code = 'ETC09';

-- 4. 게임별 소리구분 매핑 코드그룹 추가 (없다면)
INSERT IGNORE INTO tb_code_grp (
    code_grp_cd,
    code_grp_nm,
    code_grp_desc,
    use_yn,
    reg_date
) VALUES (
    'GAME_PHONO',
    '게임별소리구분',
    '게임별 소리구분 매핑',
    'Y',
    NOW()
);

-- 5. 게임별 매핑 데이터 추가 (기존 코드 + 새로 추가된 코드)
INSERT INTO tb_code (
    code_grp_cd,
    code,
    code_nm,
    code_desc,
    use_yn,
    ord,
    reg_date
) VALUES 
-- 기존 등록된 소리구분 코드들도 매핑에 포함
('GAME_PHONO', 'SV01', '단모음', '단모음 소리 구분', 'Y', 1, NOW()),
('GAME_PHONO', 'LV02', '장모음', '장모음 소리 구분', 'Y', 2, NOW()),
('GAME_PHONO', 'DP03', '이중모음', '이중모음 소리 구분', 'Y', 3, NOW()),
('GAME_PHONO', 'PL04', '파열음', '파열음 소리 구분', 'Y', 4, NOW()),
('GAME_PHONO', 'FR05', '마찰음', '마찰음 소리 구분', 'Y', 5, NOW()),
('GAME_PHONO', 'NS06', '비음', '비음 소리 구분', 'Y', 6, NOW()),
('GAME_PHONO', 'LD07', '유음', '유음 소리 구분', 'Y', 7, NOW()),
('GAME_PHONO', 'SW08', '반모음', '반모음 소리 구분', 'Y', 8, NOW()),

-- 새로 추가되는 소리구분 코드들
('GAME_PHONO', 'BC08', '받침', '받침 소리 구분', 'Y', 9, NOW()),
('GAME_PHONO', 'BP09', '양순음', '양순음 소리 구분', 'Y', 10, NOW()),
('GAME_PHONO', 'AD10', '치조음', '치조음 소리 구분', 'Y', 11, NOW()),
('GAME_PHONO', 'PP11', '경구개음', '경구개음 소리 구분', 'Y', 12, NOW()),
('GAME_PHONO', 'VL12', '연구개음', '연구개음 소리 구분', 'Y', 13, NOW()),
('GAME_PHONO', 'GL13', '후음', '후음 소리 구분', 'Y', 14, NOW()),
('GAME_PHONO', 'ELD14', '노인성난청훈련', '노인성 난청 훈련용 소리 구분', 'Y', 15, NOW()),
('GAME_PHONO', 'ETC15', '기타', '기타 소리 구분', 'Y', 16, NOW()),

-- 가짜단어 게임별 특정 매핑 (GameConstants 참고)
('GAME_PHONO', 'G0202', '받침 소리 구분 게임', 'BC08', 'Y', 17, NOW()),
('GAME_PHONO', 'G0203', '양순음 소리 구분 게임', 'BP09', 'Y', 18, NOW()),
('GAME_PHONO', 'G0204', '치조음 소리 구분 게임', 'AD10', 'Y', 19, NOW()),
('GAME_PHONO', 'G0205', '경구개음 소리 구분 게임', 'PP11', 'Y', 20, NOW()),
('GAME_PHONO', 'G0206', '연구개음 소리 구분 게임', 'VL12', 'Y', 21, NOW()),
('GAME_PHONO', 'G0207', '후음 소리 구분 게임', 'GL13', 'Y', 22, NOW()),
('GAME_PHONO', 'G0208', '노인성 난청 훈련용 게임', 'ELD14', 'Y', 23, NOW());

-- 6. 검증 쿼리 (실행 후 확인용)
/*
-- 전체 소리구분 코드 확인 (순서대로)
SELECT 
    code_no,
    code_grp_cd,
    code,
    code_nm,
    code_desc,
    use_yn,
    ord,
    DATE_FORMAT(reg_date, '%Y-%m-%d %H:%i:%s') as reg_date,
    DATE_FORMAT(upd_date, '%Y-%m-%d %H:%i:%s') as upd_date
FROM tb_code 
WHERE code_grp_cd = 'phonoDivCd' 
ORDER BY ord;

-- 게임별 매핑 확인
SELECT 
    code_no,
    code_grp_cd,
    code,
    code_nm,
    code_desc,
    ord
FROM tb_code 
WHERE code_grp_cd = 'GAME_PHONO' 
ORDER BY ord;

-- 최종 결과 (기대되는 순서)
-- phonoDivCd 그룹:
-- 1. SV01 - 단모음
-- 2. LV02 - 장모음  
-- 3. DP03 - 이중모음
-- 4. PL04 - 파열음
-- 5. FR05 - 마찰음
-- 6. NS06 - 비음
-- 7. LD07 - 유음
-- 8. SW08 - 반모음 (기존)
-- 9. BC08 - 받침 (새로 추가)
-- 10. BP09 - 양순음 (새로 추가)
-- 11. AD10 - 치조음 (새로 추가)
-- 12. PP11 - 경구개음 (새로 추가)
-- 13. VL12 - 연구개음 (새로 추가)
-- 14. GL13 - 후음 (새로 추가)
-- 15. ELD14 - 노인성난청훈련 (새로 추가)
-- 16. ETC15 - 기타 (순서 변경 및 코드명 변경)

-- GAME_PHONO 그룹:
-- 1~8: 기존 소리구분 코드들 (SV01~SW08)
-- 9~16: 새로 추가된 소리구분 코드들 (BC08~ETC15)
-- 17~23: 게임별 특정 매핑 (G0202~G0208)
*/
