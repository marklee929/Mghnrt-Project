-- ========================================
-- 미션관리 테이블 DDL (Mission Management)
-- 기존 스키마 패턴에 맞춰 작성 (reg_date, mod_date 사용)
-- ========================================

-- 1. 미션 마스터 테이블 (tb_mission)
CREATE TABLE tb_mission (
    mission_no          BIGINT          NOT NULL AUTO_INCREMENT COMMENT '미션번호',
    mission_type        VARCHAR(50)     NOT NULL                COMMENT '미션종류',
    mission_title       VARCHAR(200)    NOT NULL                COMMENT '미션제목',
    start_date          DATE            NOT NULL                COMMENT '진행기간시작일',
    end_date            DATE            NOT NULL                COMMENT '진행기간종료일',
    reward_point        INT             NOT NULL DEFAULT 0      COMMENT '리워드포인트',
    is_display          VARCHAR(1)      NOT NULL DEFAULT 'Y'    COMMENT '노출여부 (Y:노출, N:비노출)',
    is_active           VARCHAR(1)      NOT NULL DEFAULT 'Y'    COMMENT '활성여부 (Y:활성, N:비활성)',
    order_seq           INT             NOT NULL DEFAULT 0      COMMENT '정렬순서',
    reg_date            DATETIME        NOT NULL DEFAULT NOW()  COMMENT '등록일시',
    mod_date            DATETIME                                COMMENT '수정일시',
    PRIMARY KEY (mission_no),
    INDEX idx_mission_type (mission_type),
    INDEX idx_active_display (is_active, is_display),
    INDEX idx_date_range (start_date, end_date)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='미션마스터';

-- 2. 사용자 미션 관계 테이블 (tb_user_mission_rel)
CREATE TABLE tb_user_mission_rel (
    user_mission_no     BIGINT          NOT NULL AUTO_INCREMENT COMMENT '사용자미션번호',
    user_no             BIGINT          NOT NULL                COMMENT '사용자번호',
    mission_no          BIGINT          NOT NULL                COMMENT '미션번호',
    is_completed        VARCHAR(1)      NOT NULL DEFAULT 'N'    COMMENT '완료여부 (Y:완료, N:미완료)',
    reward_given        VARCHAR(1)      NOT NULL DEFAULT 'N'    COMMENT '리워드지급여부 (Y:지급완료, N:미지급)',
    reg_date            DATETIME        NOT NULL DEFAULT NOW()  COMMENT '등록일시',
    PRIMARY KEY (user_mission_no),
    UNIQUE KEY uk_user_mission (user_no, mission_no),
    INDEX idx_user_no (user_no),
    INDEX idx_mission_no (mission_no),
    INDEX idx_completed (is_completed),
    FOREIGN KEY (mission_no) REFERENCES tb_mission(mission_no) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='사용자미션관계';

-- ========================================
-- 미션타입 코드 정의 (tb_code 테이블에 추가할 데이터)
-- ========================================

-- 미션타입 그룹 추가 (기존 스키마 패턴 적용)
INSERT INTO tb_code_grp (code_grp_cd, code_grp_nm, code_grp_desc, use_yn, reg_date) 
VALUES ('MISSION_TYPE', '미션타입', '미션의 타입 구분', 'Y', NOW())
ON DUPLICATE KEY UPDATE code_grp_nm = '미션타입';

-- 미션타입 코드 추가
INSERT INTO tb_code (code_grp_cd, code, code_nm, code_desc, ord, use_yn, reg_date) VALUES
('MISSION_TYPE', 'DAILY', '일일미션', '매일 수행하는 미션', 1, 'Y', NOW()),
('MISSION_TYPE', 'WEEKLY', '주간미션', '주간 단위로 수행하는 미션', 2, 'Y', NOW()),
('MISSION_TYPE', 'EVENT', '이벤트미션', '특정 기간 동안만 진행되는 미션', 3, 'Y', NOW()),
('MISSION_TYPE', 'ETC', '기타로이', '기타 미션', 4, 'Y', NOW())
ON DUPLICATE KEY UPDATE code_nm = VALUES(code_nm);

-- ========================================
-- 샘플 미션 데이터
-- ========================================

-- 샘플 미션 데이터 삽입
INSERT INTO tb_mission (
    mission_type, mission_title, start_date, end_date, 
    reward_point, is_display, is_active, order_seq
) VALUES 
('DAILY', '가짜단어 게임을 1회 완료하세요', '2025-01-01', '2025-12-31', 100, 'Y', 'Y', 1),
('DAILY', '진짜단어 게임을 1회 완료하세요', '2025-01-01', '2025-12-31', 100, 'Y', 'Y', 2),
('WEEKLY', '양순음 관련 게임을 3회 완료하세요', '2025-01-01', '2025-12-31', 500, 'Y', 'Y', 3),
('ETC', '특별 이벤트 미션입니다', '2025-08-01', '2025-08-31', 1000, 'Y', 'Y', 4);

-- ========================================
-- 인덱스 추가 (성능 최적화)
-- ========================================

-- 미션 검색용 복합 인덱스
CREATE INDEX idx_mission_search ON tb_mission (is_active, is_display, mission_type, start_date, end_date);

-- 사용자 미션 조회용 복합 인덱스  
CREATE INDEX idx_user_mission_search ON tb_user_mission_rel (user_no, is_completed, reg_date);

-- ========================================
-- 테이블 관계도 및 설명
-- ========================================

/*
테이블 구조:
1. tb_mission: 미션 마스터 테이블
   - 관리자가 등록하는 미션 정보
   - mission_title: 미션 제목 (화면에 표시)
   - reward_point: 완료 시 지급할 포인트
   - is_display: 앱에 노출할지 여부
   - is_active: 미션 활성화 여부

2. tb_user_mission_rel: 사용자-미션 관계 테이블  
   - 사용자가 참여한 미션 정보
   - is_completed: 미션 완료 여부
   - reward_given: 리워드 지급 여부

미션 타입:
- DAILY: 일일미션
- WEEKLY: 주간미션  
- EVENT: 이벤트미션
- ETC: 기타로이 (기본값)

화면 구성:
- 미션종류: 드롭다운
- 미션제목: 텍스트 입력
- 진행기간: 시작일 ~ 종료일
- 리워드포인트: 숫자 입력
- 노출여부: ON/OFF 토글
*/
