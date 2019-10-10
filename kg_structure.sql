-- MySQL dump 10.13  Distrib 8.0.17, for Linux (x86_64)
--
-- Host: db    Database: kg
-- ------------------------------------------------------
-- Server version	8.0.17

--
-- Table structure for table `entity`
--

DROP TABLE IF EXISTS `entity`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `entity` (
  `id` int(15) NOT NULL AUTO_INCREMENT,
  `pos` varchar(255) DEFAULT NULL COMMENT '位置',
  `content` varchar(255) DEFAULT NULL COMMENT '标注的实体',
  `tag` varchar(255) DEFAULT NULL COMMENT '标签',
  `number` int(20) DEFAULT NULL COMMENT '档案编号',
  `username` varchar(255) DEFAULT NULL COMMENT '用户名',
  `operation` varchar(255) DEFAULT NULL COMMENT '用户做的操作：添加、删除',
  `time` timestamp NULL DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP,
  `RecordNumber` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=461 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `entity_copy`
--

DROP TABLE IF EXISTS `entity_copy`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `entity_copy` (
  `id` int(15) NOT NULL AUTO_INCREMENT,
  `pos` varchar(255) DEFAULT NULL COMMENT '位置',
  `content` varchar(255) DEFAULT NULL COMMENT '标注的实体',
  `tag` varchar(255) DEFAULT NULL COMMENT '标签',
  `number` int(20) DEFAULT NULL COMMENT '档案编号',
  `username` varchar(255) DEFAULT NULL COMMENT '用户名',
  `operation` varchar(255) DEFAULT NULL COMMENT '用户做的操作：添加、删除',
  `time` timestamp NULL DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=444 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `entity_label`
--

DROP TABLE IF EXISTS `entity_label`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `entity_label` (
  `id` int(10) NOT NULL AUTO_INCREMENT,
  `tag` varchar(55) DEFAULT NULL COMMENT '标签符号',
  `color` varchar(255) DEFAULT NULL COMMENT '颜色',
  `content` varchar(255) DEFAULT NULL COMMENT '标签类型',
  `username` varchar(255) DEFAULT NULL COMMENT '用户名',
  `time` timestamp NULL DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=45 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `medicalhistory`
--

DROP TABLE IF EXISTS `medicalhistory`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `medicalhistory` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `jbxx_dengjihao` text,
  `jbxx_nianling` int(11) DEFAULT NULL,
  `jbxx_xingbie` text,
  `dzbl_zhusu` text,
  `dzbl_xianbingshi` text,
  `dzbl_jiwangbingshi` text,
  `dzbl_chuanranbingshi` text,
  `dzbl_yichuanbingshi` text,
  `dzbl_shiyan` text,
  `dzbl_shijiu` text,
  `dzbl_guominshi` text,
  `dzbl_waishangshi` text,
  `dzbl_shoushushi` text,
  `jszd_ruyuanzhenduanmenzhenzeweimenzhenzhenduan` text,
  `jszd_chuyuanzhenduansuoyou` text,
  `jc_caisechaoshengke_jcjl_hqsyz` text,
  `jc_caisechaoshengke_jcsj_hqsyz` text,
  `jc_chuangpang_jcjl_hqsyz` text,
  `jc_chuangpang_jcsj_hqsyz` text,
  `edit_xianbingshi` text,
  `jc_chaoshengxindongtu_bgsj_hqsyz` text,
  `jc_chaoshengxindongtu_jcjl_hqsyz` text,
  `jc_chaoshengxindongtu_jcsj_hqsyz` text,
  `jc_erweichaoshengxindongtu_bgsj_hqsyz` text,
  `jc_erweichaoshengxindongtu_jcjl_hqsyz` text,
  `jc_erweichaoshengxindongtu_jcsj_hqsyz` text,
  `jc_fuhechaoshengxindongtu_bgsj_hqsyz` text,
  `jc_fuhechaoshengxindongtu_jcjl_hqsyz` text,
  `jc_fuhechaoshengxindongtu_jcsj` text,
  `status` varchar(255) DEFAULT NULL COMMENT '是否完成标注',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=586 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `medicalhistory_copy`
--

DROP TABLE IF EXISTS `medicalhistory_copy`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `medicalhistory_copy` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `jbxx_dengjihao` text,
  `jbxx_nianling` int(11) DEFAULT NULL,
  `jbxx_xingbie` text,
  `dzbl_zhusu` text,
  `dzbl_xianbingshi` text,
  `dzbl_jiwangbingshi` text,
  `dzbl_chuanranbingshi` text,
  `dzbl_yichuanbingshi` text,
  `dzbl_shiyan` text,
  `dzbl_shijiu` text,
  `dzbl_guominshi` text,
  `dzbl_waishangshi` text,
  `dzbl_shoushushi` text,
  `jszd_ruyuanzhenduanmenzhenzeweimenzhenzhenduan` text,
  `jszd_chuyuanzhenduansuoyou` text,
  `jc_caisechaoshengke_jcjl_hqsyz` text,
  `jc_caisechaoshengke_jcsj_hqsyz` text,
  `jc_chuangpang_jcjl_hqsyz` text,
  `jc_chuangpang_jcsj_hqsyz` text,
  `edit_xianbingshi` text,
  `jc_chaoshengxindongtu_bgsj_hqsyz` text,
  `jc_chaoshengxindongtu_jcjl_hqsyz` text,
  `jc_chaoshengxindongtu_jcsj_hqsyz` text,
  `jc_erweichaoshengxindongtu_bgsj_hqsyz` text,
  `jc_erweichaoshengxindongtu_jcjl_hqsyz` text,
  `jc_erweichaoshengxindongtu_jcsj_hqsyz` text,
  `jc_fuhechaoshengxindongtu_bgsj_hqsyz` text,
  `jc_fuhechaoshengxindongtu_jcjl_hqsyz` text,
  `jc_fuhechaoshengxindongtu_jcsj` text,
  `status` varchar(255) DEFAULT NULL COMMENT '是否完成标注',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=586 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `mh`
--

DROP TABLE IF EXISTS `mh`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `mh` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `jbxx_dengjihao` text,
  `jbxx_nianling` int(11) DEFAULT NULL,
  `jbxx_xingbie` text,
  `dzbl_zhusu` text,
  `dzbl_xianbingshi` text,
  `dzbl_jiwangbingshi` text,
  `dzbl_chuanranbingshi` text,
  `dzbl_yichuanbingshi` text,
  `dzbl_shiyan` text,
  `dzbl_shijiu` text,
  `dzbl_guominshi` text,
  `dzbl_waishangshi` text,
  `dzbl_shoushushi` text,
  `jszd_ruyuanzhenduanmenzhenzeweimenzhenzhenduan` text,
  `jszd_chuyuanzhenduansuoyou` text,
  `jc_caisechaoshengke_jcjl_hqsyz` text,
  `jc_caisechaoshengke_jcsj_hqsyz` text,
  `jc_chuangpang_jcjl_hqsyz` text,
  `jc_chuangpang_jcsj_hqsyz` text,
  `edit_xianbingshi` text,
  `jc_chaoshengxindongtu_bgsj_hqsyz` text,
  `jc_chaoshengxindongtu_jcjl_hqsyz` text,
  `jc_chaoshengxindongtu_jcsj_hqsyz` text,
  `jc_erweichaoshengxindongtu_bgsj_hqsyz` text,
  `jc_erweichaoshengxindongtu_jcjl_hqsyz` text,
  `jc_erweichaoshengxindongtu_jcsj_hqsyz` text,
  `jc_fuhechaoshengxindongtu_bgsj_hqsyz` text,
  `jc_fuhechaoshengxindongtu_jcjl_hqsyz` text,
  `jc_fuhechaoshengxindongtu_jcsj` text,
  `status` varchar(255) DEFAULT NULL COMMENT '是否完成标注',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=586 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `mh_copy`
--

DROP TABLE IF EXISTS `mh_copy`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `mh_copy` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `jbxx_dengjihao` text,
  `jbxx_nianling` int(11) DEFAULT NULL,
  `jbxx_xingbie` text,
  `dzbl_zhusu` text,
  `dzbl_xianbingshi` text,
  `dzbl_jiwangbingshi` text,
  `dzbl_chuanranbingshi` text,
  `dzbl_yichuanbingshi` text,
  `dzbl_shiyan` text,
  `dzbl_shijiu` text,
  `dzbl_guominshi` text,
  `dzbl_waishangshi` text,
  `dzbl_shoushushi` text,
  `jszd_ruyuanzhenduanmenzhenzeweimenzhenzhenduan` text,
  `jszd_chuyuanzhenduansuoyou` text,
  `jc_caisechaoshengke_jcjl_hqsyz` text,
  `jc_caisechaoshengke_jcsj_hqsyz` text,
  `jc_chuangpang_jcjl_hqsyz` text,
  `jc_chuangpang_jcsj_hqsyz` text,
  `edit_xianbingshi` text,
  `jc_chaoshengxindongtu_bgsj_hqsyz` text,
  `jc_chaoshengxindongtu_jcjl_hqsyz` text,
  `jc_chaoshengxindongtu_jcsj_hqsyz` text,
  `jc_erweichaoshengxindongtu_bgsj_hqsyz` text,
  `jc_erweichaoshengxindongtu_jcjl_hqsyz` text,
  `jc_erweichaoshengxindongtu_jcsj_hqsyz` text,
  `jc_fuhechaoshengxindongtu_bgsj_hqsyz` text,
  `jc_fuhechaoshengxindongtu_jcjl_hqsyz` text,
  `jc_fuhechaoshengxindongtu_jcsj` text,
  `status` varchar(255) DEFAULT NULL COMMENT '是否完成标注',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `other_features`
--

DROP TABLE IF EXISTS `other_features`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `other_features` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `dengjihao` varchar(255) DEFAULT NULL,
  `nianling` int(11) DEFAULT NULL,
  `xingbie` varchar(255) DEFAULT NULL,
  `jixing` varchar(255) DEFAULT NULL COMMENT '是否急性',
  `xiongtongchengdu` varchar(255) DEFAULT NULL COMMENT '胸痛程度',
  `bingshi` varchar(255) DEFAULT NULL COMMENT '病史',
  `UCG` varchar(255) DEFAULT NULL,
  `LVEF` varchar(255) DEFAULT NULL,
  `diseasename` varchar(255) DEFAULT NULL COMMENT '疾病名称',
  `time` timestamp NULL DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP COMMENT '入库时间',
  `RecordNumber` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=36 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `other_features_copy`
--

DROP TABLE IF EXISTS `other_features_copy`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `other_features_copy` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `dengjihao` varchar(255) DEFAULT NULL,
  `nianling` int(11) DEFAULT NULL,
  `xingbie` varchar(255) DEFAULT NULL,
  `jixing` varchar(255) DEFAULT NULL COMMENT '是否急性',
  `xiongtongchengdu` varchar(255) DEFAULT NULL COMMENT '胸痛程度',
  `bingshi` varchar(255) DEFAULT NULL COMMENT '病史',
  `UCG` varchar(255) DEFAULT NULL,
  `LVEF` varchar(255) DEFAULT NULL,
  `diseasename` varchar(255) DEFAULT NULL COMMENT '疾病名称',
  `time` timestamp NULL DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP COMMENT '入库时间',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=31 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `relation`
--

DROP TABLE IF EXISTS `relation`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `relation` (
  `id` int(15) NOT NULL AUTO_INCREMENT,
  `entity1` varchar(255) DEFAULT NULL COMMENT '实体1',
  `entity2` varchar(255) DEFAULT NULL COMMENT '实体2',
  `relation` varchar(255) DEFAULT NULL COMMENT '关系',
  `filename` varchar(255) DEFAULT NULL COMMENT '文件名',
  `username` varchar(255) DEFAULT NULL COMMENT '用户名',
  `color1` varchar(255) DEFAULT NULL,
  `color2` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `relation_label`
--

DROP TABLE IF EXISTS `relation_label`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `relation_label` (
  `id` int(15) NOT NULL AUTO_INCREMENT,
  `label` varchar(255) DEFAULT NULL COMMENT '关系标签',
  `username` varchar(255) DEFAULT NULL COMMENT '用户名',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `sheet1`
--

DROP TABLE IF EXISTS `sheet1`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sheet1` (
  `ICD-10` varchar(255) DEFAULT NULL,
  `疾病名称` varchar(255) DEFAULT NULL,
  `F3` varchar(255) DEFAULT NULL,
  `分类` varchar(255) DEFAULT NULL,
  `其他名称` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `srdef`
--

DROP TABLE IF EXISTS `srdef`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `srdef` (
  `RT` varchar(45) NOT NULL,
  `UI` varchar(45) NOT NULL DEFAULT '',
  `STN_RTN` varchar(45) DEFAULT NULL,
  `DEF` varchar(120) DEFAULT NULL,
  `EX` varchar(45) DEFAULT NULL,
  `UN` varchar(45) DEFAULT NULL,
  `NH` varchar(120) DEFAULT NULL,
  `ABR` varchar(45) DEFAULT NULL,
  `RIN` varchar(45) DEFAULT NULL,
  PRIMARY KEY (`UI`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `srfil`
--

DROP TABLE IF EXISTS `srfil`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `srfil` (
  `FIL` varchar(45) NOT NULL,
  `DES` varchar(120) DEFAULT NULL,
  `FMT` varchar(100) DEFAULT NULL,
  `CLS` varchar(100) DEFAULT NULL,
  `RWS` varchar(100) DEFAULT NULL,
  `BTS` varchar(100) DEFAULT NULL,
  PRIMARY KEY (`FIL`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `srfld`
--

DROP TABLE IF EXISTS `srfld`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `srfld` (
  `COL` varchar(45) NOT NULL,
  `DES` varchar(45) DEFAULT NULL,
  `REF` varchar(45) DEFAULT NULL,
  `FIL` varchar(45) DEFAULT NULL,
  PRIMARY KEY (`COL`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `srstre`
--

DROP TABLE IF EXISTS `srstre`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `srstre` (
  `UI1` varchar(45) NOT NULL,
  `UI2` varchar(45) NOT NULL,
  `UI3` varchar(45) NOT NULL,
  PRIMARY KEY (`UI1`,`UI2`,`UI3`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `user`
--

DROP TABLE IF EXISTS `user`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `user` (
  `id` int(15) NOT NULL AUTO_INCREMENT,
  `username` varchar(255) NOT NULL COMMENT '用户名',
  `password` varchar(255) DEFAULT NULL COMMENT '密码',
  `time` timestamp NULL DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=18 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `xdt`
--

DROP TABLE IF EXISTS `xdt`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `xdt` (
  `jbxx_dengjihao_jieguo_morenzhi` int(11) DEFAULT NULL,
  `jc_chaoshengxindongtu_bgsj_hqsyz` text CHARACTER SET utf8 COLLATE utf8_bin,
  `jc_chaoshengxindongtu_jcjl_hqsyz` text CHARACTER SET utf8 COLLATE utf8_bin,
  `jc_chaoshengxindongtu_jcsj_hqsyz` text CHARACTER SET utf8 COLLATE utf8_bin,
  `jc_erweichaoshengxindongtu_bgsj_hqsyz` text CHARACTER SET utf8 COLLATE utf8_bin,
  `jc_erweichaoshengxindongtu_jcjl_hqsyz` text CHARACTER SET utf8 COLLATE utf8_bin,
  `jc_erweichaoshengxindongtu_jcsj_hqsyz` text CHARACTER SET utf8 COLLATE utf8_bin,
  `jc_fuhechaoshengxindongtu_bgsj_hqsyz` text CHARACTER SET utf8 COLLATE utf8_bin,
  `jc_fuhechaoshengxindongtu_jcjl_hqsyz` text CHARACTER SET utf8 COLLATE utf8_bin,
  `jc_fuhechaoshengxindongtu_jcsj` text CHARACTER SET utf8 COLLATE utf8_bin
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `xdt_copy`
--

DROP TABLE IF EXISTS `xdt_copy`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `xdt_copy` (
  `jbxx_dengjihao_jieguo_morenzhi` int(11) DEFAULT NULL,
  `jc_chaoshengxindongtu_bgsj_hqsyz` text CHARACTER SET utf8 COLLATE utf8_bin,
  `jc_chaoshengxindongtu_jcjl_hqsyz` text CHARACTER SET utf8 COLLATE utf8_bin,
  `jc_chaoshengxindongtu_jcsj_hqsyz` text CHARACTER SET utf8 COLLATE utf8_bin,
  `jc_erweichaoshengxindongtu_bgsj_hqsyz` text CHARACTER SET utf8 COLLATE utf8_bin,
  `jc_erweichaoshengxindongtu_jcjl_hqsyz` text CHARACTER SET utf8 COLLATE utf8_bin,
  `jc_erweichaoshengxindongtu_jcsj_hqsyz` text CHARACTER SET utf8 COLLATE utf8_bin,
  `jc_fuhechaoshengxindongtu_bgsj_hqsyz` text CHARACTER SET utf8 COLLATE utf8_bin,
  `jc_fuhechaoshengxindongtu_jcjl_hqsyz` text CHARACTER SET utf8 COLLATE utf8_bin,
  `jc_fuhechaoshengxindongtu_jcsj` text CHARACTER SET utf8 COLLATE utf8_bin
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `xindiantu`
--

DROP TABLE IF EXISTS `xindiantu`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `xindiantu` (
  `jbxx_dengjihao_jieguo_morenzhi` int(11) DEFAULT NULL,
  `jc_chaoshengxindongtu_bgsj_hqsyz` text CHARACTER SET utf8 COLLATE utf8_bin,
  `jc_chaoshengxindongtu_jcjl_hqsyz` text CHARACTER SET utf8 COLLATE utf8_bin,
  `jc_chaoshengxindongtu_jcsj_hqsyz` text CHARACTER SET utf8 COLLATE utf8_bin,
  `jc_erweichaoshengxindongtu_bgsj_hqsyz` text CHARACTER SET utf8 COLLATE utf8_bin,
  `jc_erweichaoshengxindongtu_jcjl_hqsyz` text CHARACTER SET utf8 COLLATE utf8_bin,
  `jc_erweichaoshengxindongtu_jcsj_hqsyz` text CHARACTER SET utf8 COLLATE utf8_bin,
  `jc_fuhechaoshengxindongtu_bgsj_hqsyz` text CHARACTER SET utf8 COLLATE utf8_bin,
  `jc_fuhechaoshengxindongtu_jcjl_hqsyz` text CHARACTER SET utf8 COLLATE utf8_bin,
  `jc_fuhechaoshengxindongtu_jcsj` text CHARACTER SET utf8 COLLATE utf8_bin
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `zhenduan`
--

DROP TABLE IF EXISTS `zhenduan`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `zhenduan` (
  `jbxx_dengjihao` int(11) DEFAULT NULL,
  `jszd_ruyuanzhenduanmenzhenzeweimenzhenzhenduan` text CHARACTER SET gbk COLLATE gbk_chinese_ci,
  `jszd_chuyuanzhenduansuoyou` text CHARACTER SET gbk COLLATE gbk_chinese_ci,
  `jszd_chuyuanzhenduansuoyou2` text CHARACTER SET gbk COLLATE gbk_chinese_ci
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `指标-门(急)诊诊断编码(icd-10)`
--

DROP TABLE IF EXISTS `指标-门(急)诊诊断编码(icd-10)`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `指标-门(急)诊诊断编码(icd-10)` (
  `代码` varchar(255) DEFAULT NULL,
  `名称` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

-- Dump completed on 2019-10-10  5:25:38
