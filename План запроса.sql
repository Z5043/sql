Plan hash value: 2679789438
 
-------------------------------------------------------------------------------------------------------------------------------------------
| Id  | Operation                                   | Name                        | Rows  | Bytes | Cost (%CPU)| Time     | Pstart| Pstop |
-------------------------------------------------------------------------------------------------------------------------------------------
|   0 | SELECT STATEMENT                            |                             |  1702 |  1929K| 10748   (2)| 00:00:01 |       |       |
|   1 |  TEMP TABLE TRANSFORMATION                  |                             |       |       |            |          |       |       |
|   2 |   LOAD AS SELECT (CURSOR DURATION MEMORY)   | SYS_TEMP_0FD9D6645_3916FF6A |       |       |            |          |       |       |
|*  3 |    HASH JOIN OUTER                          |                             |    36 | 10368 |  9540   (2)| 00:00:01 |       |       |
|   4 |     NESTED LOOPS                            |                             |    36 | 10260 |  9539   (2)| 00:00:01 |       |       |
|   5 |      NESTED LOOPS                           |                             |    36 | 10260 |  9539   (2)| 00:00:01 |       |       |
|*  6 |       HASH JOIN OUTER                       |                             |    36 |  9360 |  9503   (2)| 00:00:01 |       |       |
|*  7 |        HASH JOIN                            |                             |    36 |  8136 |  9451   (2)| 00:00:01 |       |       |
|*  8 |         HASH JOIN                           |                             |    36 |  7128 |  9449   (2)| 00:00:01 |       |       |
|*  9 |          TABLE ACCESS FULL                  | DIVISION_D                  |   163 |  5705 |    42   (0)| 00:00:01 |       |       |
|  10 |          NESTED LOOPS                       |                             |   393 | 64059 |  9407   (2)| 00:00:01 |       |       |
|* 11 |           TABLE ACCESS FULL                 | E_MAIN_VEND_WHSE            |   393 | 26724 |  9014   (2)| 00:00:01 |       |       |
|* 12 |           INDEX UNIQUE SCAN                 | PK_GOODS                    |     1 |    95 |     0   (0)| 00:00:01 |       |       |
|  13 |         TABLE ACCESS BY INDEX ROWID BATCHED | WHSE_D                      |     1 |    28 |     2   (0)| 00:00:01 |       |       |
|* 14 |          INDEX RANGE SCAN                   | I1_WHSE_D                   |     1 |       |     1   (0)| 00:00:01 |       |       |
|  15 |        TABLE ACCESS FULL                    | U_OPER_D                    | 26800 |   889K|    52   (0)| 00:00:01 |       |       |
|* 16 |       INDEX UNIQUE SCAN                     | PK_E_MAIN_ITEM_V            |     1 |       |     0   (0)| 00:00:01 |       |       |
|  17 |      TABLE ACCESS BY INDEX ROWID            | E_MAIN_ITEM_V               |     1 |    25 |     1   (0)| 00:00:01 |       |       |
|  18 |     INDEX FULL SCAN                         | PK_E_REGION                 |    21 |    63 |     1   (0)| 00:00:01 |       |       |
|  19 |   LOAD AS SELECT (CURSOR DURATION MEMORY)   | SYS_TEMP_0FD9D6646_3916FF6A |       |       |            |          |       |       |
|* 20 |    HASH JOIN OUTER                          |                             |    38 | 12084 |   860   (2)| 00:00:01 |       |       |
|* 21 |     HASH JOIN OUTER                         |                             |    38 | 11970 |   859   (2)| 00:00:01 |       |       |
|  22 |      NESTED LOOPS                           |                             |    38 | 11856 |   858   (2)| 00:00:01 |       |       |
|  23 |       NESTED LOOPS                          |                             |    84 | 11856 |   858   (2)| 00:00:01 |       |       |
|  24 |        NESTED LOOPS                         |                             |    28 |  8456 |   830   (2)| 00:00:01 |       |       |
|  25 |         NESTED LOOPS OUTER                  |                             |    21 |  5670 |   809   (2)| 00:00:01 |       |       |
|* 26 |          HASH JOIN OUTER                    |                             |    21 |  4956 |   771   (2)| 00:00:01 |       |       |
|  27 |           NESTED LOOPS                      |                             |    21 |  4221 |   752   (2)| 00:00:01 |       |       |
|  28 |            NESTED LOOPS                     |                             |    51 |  6222 |   701   (2)| 00:00:01 |       |       |
|  29 |             NESTED LOOPS                    |                             |    51 |  2499 |   650   (2)| 00:00:01 |       |       |
|  30 |              TABLE ACCESS BY INDEX ROWID    | E_WHSE                      |     1 |     8 |     2   (0)| 00:00:01 |       |       |
|* 31 |               INDEX UNIQUE SCAN             | PK_E_WHSE                   |     1 |       |     1   (0)| 00:00:01 |       |       |
|* 32 |              TABLE ACCESS FULL              | BDT_ITEM_RELATION_D         |    51 |  2091 |   648   (3)| 00:00:01 |       |       |
|* 33 |             INDEX UNIQUE SCAN               | PK_GOODS                    |     1 |    73 |     0   (0)| 00:00:01 |       |       |
|* 34 |            INDEX UNIQUE SCAN                | PK_GOODS                    |     1 |    79 |     0   (0)| 00:00:01 |       |       |
|  35 |           TABLE ACCESS FULL                 | E_U_OPER                    | 24370 |   832K|    19   (0)| 00:00:01 |       |       |
|  36 |          TABLE ACCESS BY INDEX ROWID BATCHED| U_OPER_D                    |     1 |    34 |     2   (0)| 00:00:01 |       |       |
|* 37 |           INDEX RANGE SCAN                  | I1_U_OPER_D                 |     1 |       |     1   (0)| 00:00:01 |       |       |
|* 38 |         TABLE ACCESS BY INDEX ROWID BATCHED | DIVISION_D                  |     1 |    32 |     1   (0)| 00:00:01 |       |       |
|* 39 |          INDEX RANGE SCAN                   | I1_DIVISION_D               |     3 |       |     0   (0)| 00:00:01 |       |       |
|* 40 |        INDEX RANGE SCAN                     | I1_DIVISION_D               |     3 |       |     0   (0)| 00:00:01 |       |       |
|* 41 |       TABLE ACCESS BY INDEX ROWID           | DIVISION_D                  |     1 |    10 |     1   (0)| 00:00:01 |       |       |
|  42 |      INDEX FULL SCAN                        | PK_E_REGION                 |    21 |    63 |     1   (0)| 00:00:01 |       |       |
|  43 |     INDEX FULL SCAN                         | PK_E_REGION                 |    21 |    63 |     1   (0)| 00:00:01 |       |       |
|  44 |   LOAD AS SELECT (CURSOR DURATION MEMORY)   | SYS_TEMP_0FD9D6647_3916FF6A |       |       |            |          |       |       |
|  45 |    VIEW                                     |                             |    74 |  3996 |     7  (43)| 00:00:01 |       |       |
|  46 |     SORT UNIQUE                             |                             |    74 |  8568 |     7  (43)| 00:00:01 |       |       |
|  47 |      UNION-ALL                              |                             |       |       |            |          |       |       |
|  48 |       VIEW                                  |                             |    36 |  1944 |     2   (0)| 00:00:01 |       |       |
|  49 |        TABLE ACCESS FULL                    | SYS_TEMP_0FD9D6645_3916FF6A |    36 | 10368 |     2   (0)| 00:00:01 |       |       |
|  50 |       VIEW                                  |                             |    38 |   912 |     2   (0)| 00:00:01 |       |       |
|  51 |        TABLE ACCESS FULL                    | SYS_TEMP_0FD9D6646_3916FF6A |    38 |  8854 |     2   (0)| 00:00:01 |       |       |
|* 52 |   HASH JOIN RIGHT OUTER                     |                             |  1702 |  1929K|   341   (1)| 00:00:01 |       |       |
|  53 |    VIEW                                     |                             |    23 |  1541 |    18   (0)| 00:00:01 |       |       |
|  54 |     NESTED LOOPS                            |                             |    23 |  1932 |    16   (0)| 00:00:01 |       |       |
|  55 |      NESTED LOOPS                           |                             |    23 |  1932 |    16   (0)| 00:00:01 |       |       |
|* 56 |       HASH JOIN                             |                             |    74 |  4662 |     4   (0)| 00:00:01 |       |       |
|  57 |        TABLE ACCESS BY INDEX ROWID BATCHED  | WHSE_D                      |     1 |     9 |     2   (0)| 00:00:01 |       |       |
|* 58 |         INDEX RANGE SCAN                    | I1_WHSE_D                   |     1 |       |     1   (0)| 00:00:01 |       |       |
|* 59 |        VIEW                                 |                             |    74 |  3996 |     2   (0)| 00:00:01 |       |       |
|  60 |         TABLE ACCESS FULL                   | SYS_TEMP_0FD9D6647_3916FF6A |    74 |  3996 |     2   (0)| 00:00:01 |       |       |
|  61 |       PARTITION RANGE SINGLE                |                             |       |       |            |          |   KEY |   KEY |
|  62 |        BITMAP CONVERSION TO ROWIDS          |                             |       |       |            |          |       |       |
|  63 |         BITMAP AND                          |                             |       |       |            |          |       |       |
|* 64 |          BITMAP INDEX SINGLE VALUE          | I_ITN_STATS_F_ITEM          |       |       |            |          |   KEY |   KEY |
|* 65 |          BITMAP INDEX SINGLE VALUE          | I_ITN_STATS_F_WHSE          |       |       |            |          |   KEY |   KEY |
|* 66 |      TABLE ACCESS BY LOCAL INDEX ROWID      | ITN_STATS_F                 |     1 |    21 |    16   (0)| 00:00:01 |     1 |     1 |
|  67 |       FAST DUAL                             |                             |     1 |       |     2   (0)| 00:00:01 |       |       |
|* 68 |    HASH JOIN RIGHT OUTER                    |                             |    74 | 80956 |   323   (1)| 00:00:01 |       |       |
|  69 |     VIEW                                    |                             |    38 |   912 |     2   (0)| 00:00:01 |       |       |
|  70 |      TABLE ACCESS FULL                      | SYS_TEMP_0FD9D6646_3916FF6A |    38 |  8854 |     2   (0)| 00:00:01 |       |       |
|* 71 |     HASH JOIN RIGHT OUTER                   |                             |    74 | 79180 |   321   (1)| 00:00:01 |       |       |
|  72 |      VIEW                                   |                             |     1 |    67 |    16  (13)| 00:00:01 |       |       |
|  73 |       HASH GROUP BY                         |                             |     1 |    85 |    16  (13)| 00:00:01 |       |       |
|* 74 |        HASH JOIN                            |                             |     1 |    85 |    13   (8)| 00:00:01 |       |       |
|  75 |         TABLE ACCESS BY INDEX ROWID BATCHED | WHSE_D                      |     1 |    12 |     2   (0)| 00:00:01 |       |       |
|* 76 |          INDEX RANGE SCAN                   | I1_WHSE_D                   |     1 |       |     1   (0)| 00:00:01 |       |       |
|  77 |         NESTED LOOPS                        |                             |   720 | 52560 |    11  (10)| 00:00:01 |       |       |
|  78 |          NESTED LOOPS                       |                             |   720 | 52560 |    11  (10)| 00:00:01 |       |       |
|* 79 |           VIEW                              |                             |    74 |  3996 |     2   (0)| 00:00:01 |       |       |
|  80 |            TABLE ACCESS FULL                | SYS_TEMP_0FD9D6647_3916FF6A |    74 |  3996 |     2   (0)| 00:00:01 |       |       |
|  81 |           PARTITION RANGE SINGLE            |                             |       |       |            |          |   KEY |   KEY |
|  82 |            BITMAP CONVERSION TO ROWIDS      |                             |       |       |            |          |       |       |
|  83 |             BITMAP AND                      |                             |       |       |            |          |       |       |
|* 84 |              BITMAP INDEX SINGLE VALUE      | I3_ITEM_R_F                 |       |       |            |          |   KEY |   KEY |
|* 85 |              BITMAP INDEX SINGLE VALUE      | I2_ITEM_R_F                 |       |       |            |          |   KEY |   KEY |
|  86 |               FAST DUAL                     |                             |     1 |       |     2   (0)| 00:00:01 |       |       |
|  87 |          TABLE ACCESS BY LOCAL INDEX ROWID  | ITEM_R_F                    |    10 |   190 |    11  (10)| 00:00:01 |     1 |     1 |
|* 88 |      HASH JOIN OUTER                        |                             |    74 | 74222 |   305   (0)| 00:00:01 |       |       |
|* 89 |       HASH JOIN OUTER                       |                             |    74 |  8436 |   303   (0)| 00:00:01 |       |       |
|* 90 |        HASH JOIN OUTER                      |                             |    74 |  5920 |   152   (0)| 00:00:01 |       |       |
|  91 |         VIEW                                |                             |    74 |  3996 |     2   (0)| 00:00:01 |       |       |
|  92 |          TABLE ACCESS FULL                  | SYS_TEMP_0FD9D6647_3916FF6A |    74 |  3996 |     2   (0)| 00:00:01 |       |       |
|  93 |         VIEW                                |                             |   264 |  6864 |   150   (0)| 00:00:01 |       |       |
|  94 |          NESTED LOOPS                       |                             |   264 | 22176 |   150   (0)| 00:00:01 |       |       |
|  95 |           NESTED LOOPS                      |                             |   264 | 22176 |   150   (0)| 00:00:01 |       |       |
|* 96 |            VIEW                             |                             |    74 |  3996 |     2   (0)| 00:00:01 |       |       |
|  97 |             TABLE ACCESS FULL               | SYS_TEMP_0FD9D6647_3916FF6A |    74 |  3996 |     2   (0)| 00:00:01 |       |       |
|* 98 |            INDEX RANGE SCAN                 | PK0_ORD_TRANSFER            |     1 |       |     1   (0)| 00:00:01 |       |       |
|* 99 |           TABLE ACCESS BY INDEX ROWID       | ORD_TRANSFER                |     4 |   120 |     2   (0)| 00:00:01 |       |       |
| 100 |        VIEW                                 |                             |   114 |  3876 |   151   (0)| 00:00:01 |       |       |
| 101 |         NESTED LOOPS                        |                             |   114 | 10146 |   151   (0)| 00:00:01 |       |       |
| 102 |          NESTED LOOPS                       |                             |   114 | 10146 |   151   (0)| 00:00:01 |       |       |
| 103 |           NESTED LOOPS                      |                             |    74 |  4366 |     3   (0)| 00:00:01 |       |       |
|*104 |            INDEX UNIQUE SCAN                | PK_E_WHSE                   |     1 |     5 |     1   (0)| 00:00:01 |       |       |
|*105 |            VIEW                             |                             |    74 |  3996 |     2   (0)| 00:00:01 |       |       |
| 106 |             TABLE ACCESS FULL               | SYS_TEMP_0FD9D6647_3916FF6A |    74 |  3996 |     2   (0)| 00:00:01 |       |       |
|*107 |           INDEX RANGE SCAN                  | PK0_ZAPRET_VP_HISTORY       |     1 |       |     1   (0)| 00:00:01 |       |       |
|*108 |          TABLE ACCESS BY INDEX ROWID        | ZAPRET_VP_HISTORY           |     2 |    60 |     2   (0)| 00:00:01 |       |       |
| 109 |       VIEW                                  |                             |    36 | 32004 |     2   (0)| 00:00:01 |       |       |
| 110 |        TABLE ACCESS FULL                    | SYS_TEMP_0FD9D6645_3916FF6A |    36 | 10368 |     2   (0)| 00:00:01 |       |       |
-------------------------------------------------------------------------------------------------------------------------------------------
 
Predicate Information (identified by operation id):
---------------------------------------------------
 
   3 - access(TRIM("REG_CODE"(+))=TRIM("D"."TAX_REGION"))
   6 - access("BAYER"="USER_CODE"(+))
   7 - access("WHSE_CODE"="WHSE_CODE")
   8 - access("D"."DIV_CODE"="DIV_CODE")
   9 - filter("D"."DIV_TYPE"=2 AND "D"."IS_CURRENT"='Y')
  11 - filter("WHSE_CODE"='0B3' AND "VEND_WHSE_STATUS"<>'D' AND (NVL("SUPPLY_TYPE",0)=1 OR NVL("SUPPLY_TYPE",0)=3))
  12 - access("ITEM_NUM"="ITEM_NUM")
       filter("STATE"=1 AND ("HSZ"='064' OR "HSZ"='Т33'))
  14 - access("WHSE_CODE"='0B3')
  16 - access("ITEM_NUM"="ITEM_NUM")
  20 - access(TRIM("REG_CODE"(+))=TRIM("D"."TAX_REGION"))
  21 - access(TRIM("REG_CODE"(+))=TRIM("D"."TAX_REGION"))
  26 - access("USER_CREATED"="USER_CODE"(+))
  31 - access("WHSE_CODE"='0B3')
  32 - filter("TAX_REGION" IS NOT NULL AND "TIME_DELETED" IS NULL AND "REL_TYPE_ID"=3 AND "TERR_CODE"="TAX_REGION")
  33 - access("MAIN_ITEM_NUM"="ITEM_NUM")
  34 - access("SUB_ITEM_NUM"="ITEM_NUM")
       filter("IND_CATEGORY"<>'H' OR "IND_CATEGORY"<>'H')
  37 - access("BAYER"="USER_CODE"(+))
  38 - filter("D"."IS_CURRENT"='Y')
  39 - access("D"."DIV_CODE"="DIV_CODE")
  40 - access("DIV_CODE"="D"."DIV_CODE")
  41 - filter("D"."IS_CURRENT"='Y')
  52 - access("VT_TABLE_FULL"."КОД_СКЛАДА"="MO_VT_TABLE"."КОД_СКЛАДА"(+) AND "VT_TABLE_FULL"."АРТИКУЛ"="MO_VT_TABLE"."АРТИКУЛ"(+))
  56 - access("VT_TABLE_FULL"."КОД_СКЛАДА"="WHSE_CODE")
  58 - access("WHSE_CODE"='0B3')
  59 - filter("VT_TABLE_FULL"."КОД_СКЛАДА"='0B3')
  64 - access("ITEM_NUM"="VT_TABLE_FULL"."АРТИКУЛ")
  65 - access("ID_WHSE"="ID_WHSE")
  66 - filter("ID_STAT_DATE"= (SELECT "KDW"."GETZGLDATEID"() FROM "SYS"."DUAL" "DUAL"))
  68 - access("VT_TABLE_FULL"."КОД_СКЛАДА"="VT_CATALOG_TOVARA_KDW_OTHER_27"."КОД_СКЛАДА"(+) AND 
              "VT_TABLE_FULL"."АРТИКУЛ"="VT_CATALOG_TOVARA_KDW_OTHER_27"."АРТИКУЛ"(+))
  71 - access("VT_TABLE_FULL"."КОД_СКЛАДА"="OSTATOK_VT_TABLE"."КОД_СКЛАДА"(+) AND 
              "VT_TABLE_FULL"."АРТИКУЛ"="OSTATOK_VT_TABLE"."АРТИКУЛ"(+))
  74 - access("ID_WHSE"="ID_WHSE" AND "VT_TABLE_FULL"."КОД_СКЛАДА"="WHSE_CODE")
  76 - access("WHSE_CODE"='0B3')
  79 - filter("VT_TABLE_FULL"."КОД_СКЛАДА"='0B3')
  84 - access("ITEM_NUM"="VT_TABLE_FULL"."АРТИКУЛ")
  85 - access("ID_DATE"= (SELECT "KDW"."GETDATEID"(SYSDATE@!-1) FROM "SYS"."DUAL" "DUAL"))
  88 - access("VT_TABLE_FULL"."КОД_СКЛАДА"="VT_CATALOG_TOVARA_KDW_OTHER_16"."КОД_СКЛАДА"(+) AND 
              "VT_TABLE_FULL"."АРТИКУЛ"="VT_CATALOG_TOVARA_KDW_OTHER_16"."АРТИКУЛ"(+))
  89 - access("VT_TABLE_FULL"."КОД_СКЛАДА"="PRIZNAK_ZVP"."КОД_СКЛАДА"(+) AND "VT_TABLE_FULL"."АРТИКУЛ"="PRIZNAK_ZVP"."АРТИКУЛ"(+))
  90 - access("VT_TABLE_FULL"."КОД_СКЛАДА"="PRIZNAK_VP"."КОД_СКЛАДА"(+) AND "VT_TABLE_FULL"."АРТИКУЛ"="PRIZNAK_VP"."АРТИКУЛ"(+))
  96 - filter("VT_TABLE_FULL"."КОД_СКЛАДА"='0B3')
  98 - access("ITEM_NUM"="VT_TABLE_FULL"."АРТИКУЛ" AND "WHSE_CODE"='0B3' AND "B_DATE"<=SYSDATE@!-1)
  99 - filter("E_DATE">=SYSDATE@!-1)
 104 - access("WHSE_CODE"='0B3')
 105 - filter("VT_TABLE_FULL"."КОД_СКЛАДА"='0B3')
 107 - access("ITEM_NUM"="VT_TABLE_FULL"."АРТИКУЛ" AND "WHSE_CODE"='0B3' AND "B_DATE"<=SYSDATE@!-1)
 108 - filter("E_DATE">=SYSDATE@!-1)
 
Note
-----
   - dynamic statistics used: dynamic sampling (level=4)
   - this is an adaptive plan