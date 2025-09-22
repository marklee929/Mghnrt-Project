-- 소리구분 타입 코드 테이블 INSERT 쿼리
-- 진짜단어 관리에서 사용할 소리구분 분류 추가

-- 1. 코드그룹 추가 (소리구분)
INSERT INTO tb_code_grp (
    code_grp_cd,
    code_grp_nm,
    code_grp_desc,
    use_yn,
    reg_date
) VALUES (
    'PHONO_DIV',
    '소리구분',
    '진짜단어 소리구분 타입 분류',
    'Y',
    NOW()
);

-- 2. 소리구분 코드 데이터 INSERT
-- 기본 소리구분 (요구사항 기준)
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
('PHONO_DIV', 'BC01', '받침', '받침 소리 구분', 'Y', 1, NOW()),

-- 조음위치별 분류
('PHONO_DIV', 'BP01', '양순음', '양순음 소리 구분 (ㅂ, ㅍ, ㅁ)', 'Y', 2, NOW()),
('PHONO_DIV', 'AD01', '치조음', '치조음 소리 구분 (ㄷ, ㅌ, ㄴ, ㄹ)', 'Y', 3, NOW()),
('PHONO_DIV', 'PP01', '경구개음', '경구개음 소리 구분 (ㅈ, ㅊ)', 'Y', 4, NOW()),
('PHONO_DIV', 'VL01', '연구개음', '연구개음 소리 구분 (ㄱ, ㅋ, ㅇ)', 'Y', 5, NOW()),
('PHONO_DIV', 'GL01', '후음', '후음 소리 구분 (ㅎ)', 'Y', 6, NOW()),

-- 추가 분류 (기존 시스템과 호환)
('PHONO_DIV', 'SV01', '단모음', '단모음 (ㅏ, ㅓ, ㅗ, ㅜ, ㅡ, ㅣ)', 'Y', 7, NOW()),
('PHONO_DIV', 'LV01', '장모음', '장모음 (ㅏː, ㅓː)', 'Y', 8, NOW()),
('PHONO_DIV', 'DV01', '이중모음', '이중모음 (ㅑ, ㅕ, ㅛ, ㅠ, ㅐ, ㅔ)', 'Y', 9, NOW()),

-- 조음방법별 분류
('PHONO_DIV', 'ST01', '파열음', '파열음 (ㅂ, ㅍ, ㄷ, ㅌ, ㄱ, ㅋ)', 'Y', 10, NOW()),
('PHONO_DIV', 'FR01', '마찰음', '마찰음 (ㅅ, ㅆ, ㅎ)', 'Y', 11, NOW()),
('PHONO_DIV', 'NS01', '비음', '비음 (ㅁ, ㄴ, ㅇ)', 'Y', 12, NOW()),
('PHONO_DIV', 'LQ01', '유음', '유음 (ㄹ)', 'Y', 13, NOW()),
('PHONO_DIV', 'SV02', '반모음', '반모음 (ㅗ, ㅜ, ㅣ의 반모음 형태)', 'Y', 14, NOW()),
('PHONO_DIV', 'ETC', '기타', '기타 소리 구분', 'Y', 15, NOW()),

-- 노인성 난청 훈련용 (GameConstants 참고)
('PHONO_DIV', 'ELD01', '노인성난청훈련', '노인성 난청 훈련용 소리 구분', 'Y', 16, NOW());

-- 3. 기존 데이터와의 매핑을 위한 추가 코드 (필요시)
-- 게임별 소리구분 매핑
INSERT INTO tb_code_grp (
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

INSERT INTO tb_code (
    code_grp_cd,
    code,
    code_nm,
    code_desc,
    use_yn,
    ord,
    reg_date
) VALUES 
-- 가짜단어 게임별 매핑 (GameConstants 참고)
('GAME_PHONO', 'G0202', '받침 소리 구분', 'BC01', 'Y', 1, NOW()),
('GAME_PHONO', 'G0203', '양순음 소리 구분', 'BP01', 'Y', 2, NOW()),
('GAME_PHONO', 'G0204', '치조음 소리 구분', 'AD01', 'Y', 3, NOW()),
('GAME_PHONO', 'G0205', '경구개음 소리 구분', 'PP01', 'Y', 4, NOW()),
('GAME_PHONO', 'G0206', '연구개음 소리 구분', 'VL01', 'Y', 5, NOW()),
('GAME_PHONO', 'G0207', '후음 소리 구분', 'GL01', 'Y', 6, NOW()),
('GAME_PHONO', 'G0208', '노인성 난청 훈련용', 'ELD01', 'Y', 7, NOW());

-- 4. 검증 쿼리 (실행 후 확인용)
/*
-- 코드그룹 확인
SELECT * FROM tb_code_grp WHERE code_grp_cd IN ('PHONO_DIV', 'GAME_PHONO');

-- 소리구분 코드 확인
SELECT 
    c.code_grp_cd,
    c.code,
    c.code_nm,
    c.code_desc,
    c.ord
FROM tb_code c
WHERE c.code_grp_cd = 'PHONO_DIV'
ORDER BY c.ord;

-- 게임별 매핑 확인
SELECT 
    c.code_grp_cd,
    c.code,
    c.code_nm,
    c.code_desc
FROM tb_code c
WHERE c.code_grp_cd = 'GAME_PHONO'
ORDER BY c.ord;
*/
