DROP TABLE GKN_COMMON.PATTERN_SEARCH_KYM CASCADE CONSTRAINTS;

CREATE TABLE GKN_COMMON.PATTERN_SEARCH_KYM
(
  RUNID        NUMBER,
  ID           NUMBER,
  CREATE_DATE  DATE,
  OWNER        VARCHAR2(100 BYTE),
  TABLE_NAME   VARCHAR2(100 BYTE),
  COLUMN_NAME  VARCHAR2(100 BYTE),
  OBSERVATION  VARCHAR2(500 BYTE)
)
TABLESPACE GKN_DATA
PCTUSED    0
PCTFREE    10
INITRANS   1
MAXTRANS   255
STORAGE    (
            INITIAL          64K
            MINEXTENTS       1
            MAXEXTENTS       UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           )
LOGGING 
NOCOMPRESS 
NOCACHE
NOPARALLEL
NOMONITORING;