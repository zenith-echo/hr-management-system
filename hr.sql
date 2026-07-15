/*
 Navicat Premium Data Transfer

 Source Server         : zhy40
 Source Server Type    : MySQL
 Source Server Version : 50729
 Source Host           : localhost:3306
 Source Schema         : hr

 Target Server Type    : MySQL
 Target Server Version : 50729
 File Encoding         : 65001

 Date: 27/06/2026 23:24:04
*/

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- ----------------------------
-- Table structure for announcement
-- ----------------------------
DROP TABLE IF EXISTS `announcement`;
CREATE TABLE `announcement`  (
  `announcement_id` int(11) NOT NULL AUTO_INCREMENT,
  `title` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL,
  `content` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL,
  `posted_by` int(11) NULL DEFAULT NULL COMMENT '发布者 ID，关联用户表的用户 ID，记录发布人信息。',
  `post_date` datetime NULL DEFAULT NULL,
  `expiry_date` datetime NULL DEFAULT NULL,
  `priority` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '(\' 低 \', \' 中 \', \' 高 \', \' 紧急 \')',
  `target_audience` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL,
  PRIMARY KEY (`announcement_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 21 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '公告表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of announcement
-- ----------------------------
INSERT INTO `announcement` VALUES (1, '公司年度大会通知', '本年度公司大会将于7月15日在总部举行，请全体员工参加。', 101, '2025-06-10 00:00:00', '2025-07-14 00:00:00', '高', '全体');
INSERT INTO `announcement` VALUES (2, '财务部系统升级', '财务系统将于本周末进行升级，期间无法办理报销业务。', 102, '2025-06-12 00:00:00', '2025-06-24 00:00:00', '中', '10');
INSERT INTO `announcement` VALUES (3, '新员工入职欢迎', '热烈欢迎张三加入技术部！', 103, '2025-06-15 00:00:00', '2025-06-30 00:00:00', '低', '全体');
INSERT INTO `announcement` VALUES (4, '销售部季度会议', '销售部季度总结会议将于下周三下午2点召开。', 104, '2025-06-16 00:00:00', '2025-06-24 00:00:00', '高', '15');
INSERT INTO `announcement` VALUES (5, '办公室装修通知', '为提升办公环境，办公室将于7月1日至7月10日进行局部装修。', 101, '2025-06-17 00:00:00', '2025-06-30 00:00:00', '中', '全体');
INSERT INTO `announcement` VALUES (6, 'IT部门设备更新', 'IT部门将对研发组电脑进行性能升级，请相关人员配合。', 103, '2025-06-18 00:00:00', '2025-07-05 00:00:00', '高', '20');
INSERT INTO `announcement` VALUES (7, '端午节放假安排', '根据国家规定，端午节6月28日至7月1日放假。', 101, '2025-06-15 00:00:00', '2025-06-27 00:00:00', '高', '全体');
INSERT INTO `announcement` VALUES (8, '人力资源政策调整', '公司考勤制度将从7月1日起进行调整，请提前了解。', 105, '2025-06-19 00:00:00', '2025-06-30 00:00:00', '中', '全体');
INSERT INTO `announcement` VALUES (9, '市场部新品推广计划', '市场部下周将启动新产品推广活动，相关人员准备。', 106, '2025-06-14 00:00:00', '2025-06-25 00:00:00', '高', '18');
INSERT INTO `announcement` VALUES (10, '员工福利政策更新', '补充商业保险方案已更新，详情请查看附件。', 105, '2025-06-12 00:00:00', '2025-06-30 00:00:00', '中', '全体');
INSERT INTO `announcement` VALUES (11, '研发部代码规范培训', '研发部将组织代码规范培训，请相关人员参加。', 103, '2025-06-15 00:00:00', '2025-06-22 00:00:00', '低', '20');
INSERT INTO `announcement` VALUES (12, '客户满意度调查', '请销售部员工在本周内完成客户满意度调查。', 104, '2025-06-16 00:00:00', '2025-06-23 00:00:00', '中', '15');
INSERT INTO `announcement` VALUES (13, '行政部办公用品采购', '办公用品采购系统已更新，请使用新流程申请。', 107, '2025-06-17 00:00:00', '2025-06-28 00:00:00', '低', '全体');
INSERT INTO `announcement` VALUES (14, '技术分享会预告', '下周五将举办技术分享会，欢迎感兴趣的同事参加。', 103, '2025-06-18 00:00:00', '2025-06-27 00:00:00', '低', '全体');
INSERT INTO `announcement` VALUES (15, '财务部报销政策调整', '差旅费报销标准将从7月开始调整。', 102, '2025-06-19 00:00:00', '2025-07-10 00:00:00', '中', '全体');
INSERT INTO `announcement` VALUES (16, '客服部服务流程优化', '客服部将优化服务流程，提高客户响应速度。', 108, '2025-06-15 00:00:00', '2025-06-25 00:00:00', '中', '25');
INSERT INTO `announcement` VALUES (17, '公司团建活动报名', '8月公司将组织团建活动，欢迎大家报名参加。', 105, '2025-06-14 00:00:00', '2025-07-30 00:00:00', '低', '全体');
INSERT INTO `announcement` VALUES (18, '法务部合规培训', '全体员工需参加线上合规培训，6月30日前完成。', 109, '2025-06-12 00:00:00', '2025-06-30 00:00:00', '高', '全体');
INSERT INTO `announcement` VALUES (19, '产品部需求讨论会', '产品部将于明天上午讨论新版本需求。', 110, '2025-06-18 00:00:00', '2025-06-19 00:00:00', '高', '22');
INSERT INTO `announcement` VALUES (20, '健身房开放通知', '公司健身房已完成装修，即日起恢复开放。', 107, '2025-06-19 00:00:00', '2025-07-19 00:00:00', '低', '全体');

-- ----------------------------
-- Table structure for asset_assignment
-- ----------------------------
DROP TABLE IF EXISTS `asset_assignment`;
CREATE TABLE `asset_assignment`  (
  `assignment_id` int(11) NOT NULL COMMENT '资产分配编号',
  `asset_id` int(11) NULL DEFAULT NULL COMMENT '资产编号',
  `employee_id` int(11) NULL DEFAULT NULL COMMENT '员工编号',
  `assign_date` date NULL DEFAULT NULL COMMENT '分配日期',
  `return_date` date NULL DEFAULT NULL COMMENT '归还日期',
  `notes` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL COMMENT '备注',
  PRIMARY KEY (`assignment_id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '资产分配表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of asset_assignment
-- ----------------------------
INSERT INTO `asset_assignment` VALUES (1, 1001, 2001, '2026-06-27', '2026-06-30', '笔记本电脑，正常归还');
INSERT INTO `asset_assignment` VALUES (2, 1002, 2002, '2026-06-27', NULL, '台式电脑，使用中');
INSERT INTO `asset_assignment` VALUES (3, 1003, 2003, '2026-06-27', '2026-06-30', '显示器，正常归还');
INSERT INTO `asset_assignment` VALUES (4, 1004, 2004, '2026-06-27', NULL, '打印机，使用中');
INSERT INTO `asset_assignment` VALUES (5, 1005, 2005, '2026-06-27', '2026-06-30', '投影仪，正常归还');
INSERT INTO `asset_assignment` VALUES (6, 1006, 2006, '2026-06-27', NULL, '笔记本电脑，使用中');
INSERT INTO `asset_assignment` VALUES (7, 1007, 2007, '2026-06-27', '2026-06-30', '台式电脑，正常归还');
INSERT INTO `asset_assignment` VALUES (8, 1008, 2008, '2026-06-27', NULL, '显示器，使用中');
INSERT INTO `asset_assignment` VALUES (9, 1009, 2009, '2026-06-27', '2026-06-30', '打印机，归还时墨盒已空');
INSERT INTO `asset_assignment` VALUES (10, 1010, 2010, '2026-06-27', NULL, '笔记本电脑，使用中');
INSERT INTO `asset_assignment` VALUES (11, 1011, 2011, '2026-06-27', '2026-06-30', '投影仪，正常归还');
INSERT INTO `asset_assignment` VALUES (12, 1012, 2012, '2026-06-27', NULL, '台式电脑，新员工入职分配');
INSERT INTO `asset_assignment` VALUES (13, 1013, 2013, '2026-06-27', '2026-06-30', '显示器，正常归还');
INSERT INTO `asset_assignment` VALUES (14, 1014, 2014, '2026-06-27', NULL, '打印机，使用中');
INSERT INTO `asset_assignment` VALUES (15, 1015, 2015, '2026-06-27', '2026-06-30', '笔记本电脑，归还时电池损耗');
INSERT INTO `asset_assignment` VALUES (16, 1016, 2016, '2026-06-27', NULL, '台式电脑，使用中');
INSERT INTO `asset_assignment` VALUES (17, 1017, 2017, '2026-06-27', '2026-06-30', '投影仪，正常归还');
INSERT INTO `asset_assignment` VALUES (18, 1018, 2018, '2026-06-27', NULL, '显示器，使用中');
INSERT INTO `asset_assignment` VALUES (19, 1019, 2019, '2026-06-27', '2026-06-30', '打印机，正常归还');
INSERT INTO `asset_assignment` VALUES (20, 1020, 2020, '2026-06-27', NULL, '笔记本电脑，使用中');

-- ----------------------------
-- Table structure for asset_maintenance
-- ----------------------------
DROP TABLE IF EXISTS `asset_maintenance`;
CREATE TABLE `asset_maintenance`  (
  `maintenance_id` int(11) NOT NULL COMMENT '资产维护编号',
  `asset_id` int(11) NULL DEFAULT NULL COMMENT '资产编号',
  `maintenance_date` date NULL DEFAULT NULL COMMENT '维护日期',
  `maintenance_type` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '维护类型',
  `cost` decimal(10, 2) NULL DEFAULT NULL COMMENT '维护费用',
  `provider` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '服务提供商',
  `notes` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL COMMENT '备注',
  PRIMARY KEY (`maintenance_id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '资产维护表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of asset_maintenance
-- ----------------------------
INSERT INTO `asset_maintenance` VALUES (1, 1001, '2025-03-10', '硬件维修', 850.00, 'TechSupport Inc', '更换笔记本电脑硬盘');
INSERT INTO `asset_maintenance` VALUES (2, 1002, '2025-04-15', '软件升级', 320.00, 'SoftUp Solutions', '操作系统和办公软件更新');
INSERT INTO `asset_maintenance` VALUES (3, 1005, '2025-01-22', '清洁保养', 150.00, 'OfficeCare Services', '投影仪镜头清洁');
INSERT INTO `asset_maintenance` VALUES (4, 1008, '2025-05-05', '硬件维修', 480.00, 'Monitor Experts', '显示器屏幕更换');
INSERT INTO `asset_maintenance` VALUES (5, 1012, '2025-06-12', '预防性维护', 220.00, 'ProTech Services', '台式电脑全面检查');
INSERT INTO `asset_maintenance` VALUES (6, 1003, '2025-02-18', '软件升级', 180.00, 'SoftUp Solutions', '驱动程序更新');
INSERT INTO `asset_maintenance` VALUES (7, 1009, '2025-04-30', '硬件维修', 650.00, 'PrintFix Co', '打印机主板更换');
INSERT INTO `asset_maintenance` VALUES (8, 1015, '2025-05-20', '电池更换', 380.00, 'PowerPlus', '笔记本电脑电池损耗更换');
INSERT INTO `asset_maintenance` VALUES (9, 1004, '2025-03-25', '预防性维护', 190.00, 'ProTech Services', '打印机内部清洁');
INSERT INTO `asset_maintenance` VALUES (10, 1017, '2025-06-08', '硬件维修', 720.00, 'AV Specialists', '投影仪灯泡更换');
INSERT INTO `asset_maintenance` VALUES (11, 1006, '2025-01-30', '软件升级', 270.00, 'SoftUp Solutions', '安全软件更新');
INSERT INTO `asset_maintenance` VALUES (12, 1014, '2025-04-18', '硬件维修', 530.00, 'PrintFix Co', '打印机进纸器维修');
INSERT INTO `asset_maintenance` VALUES (13, 1010, '2025-03-15', '预防性维护', 240.00, 'ProTech Services', '笔记本电脑散热清理');
INSERT INTO `asset_maintenance` VALUES (14, 1019, '2025-02-05', '软件升级', 160.00, 'SoftUp Solutions', '驱动程序更新');
INSERT INTO `asset_maintenance` VALUES (15, 1007, '2025-05-12', '硬件维修', 910.00, 'TechSupport Inc', '台式电脑显卡更换');
INSERT INTO `asset_maintenance` VALUES (16, 1018, '2025-06-03', '清洁保养', 140.00, 'OfficeCare Services', '显示器屏幕清洁');
INSERT INTO `asset_maintenance` VALUES (17, 1013, '2025-04-02', '预防性维护', 210.00, 'ProTech Services', '显示器接口检查');
INSERT INTO `asset_maintenance` VALUES (18, 1020, '2025-03-28', '软件升级', 330.00, 'SoftUp Solutions', '系统和应用更新');
INSERT INTO `asset_maintenance` VALUES (19, 1005, '2025-01-15', '硬件维修', 570.00, 'AV Specialists', '投影仪HDMI接口维修');
INSERT INTO `asset_maintenance` VALUES (20, 1011, '2025-05-28', '清洁保养', 160.00, 'OfficeCare Services', '投影仪内部除尘');

-- ----------------------------
-- Table structure for assets
-- ----------------------------
DROP TABLE IF EXISTS `assets`;
CREATE TABLE `assets`  (
  `asset_id` int(11) NOT NULL COMMENT '资产编号',
  `asset_name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '资产名称',
  `asset_type` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '资产类型',
  `purchase_date` date NULL DEFAULT NULL COMMENT '购买日期',
  `purchase_price` decimal(10, 2) NULL DEFAULT NULL COMMENT '购买价格',
  `supplier` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '供应商',
  `warranty_end` date NULL DEFAULT NULL COMMENT '保修期',
  PRIMARY KEY (`asset_id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '资产表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of assets
-- ----------------------------
INSERT INTO `assets` VALUES (1001, '联想笔记本电脑T490', '笔记本电脑', '2024-12-15', 8999.00, '科技电子有限公司', '2027-12-14');
INSERT INTO `assets` VALUES (1002, '戴尔台式电脑OptiPlex 7070', '台式电脑', '2025-01-20', 6599.00, '计算机设备供应商', '2028-01-19');
INSERT INTO `assets` VALUES (1003, '戴尔显示器U2720QM', '显示器', '2024-11-05', 3299.00, '电子科技有限公司', '2027-11-04');
INSERT INTO `assets` VALUES (1004, '惠普打印机LaserJet Pro M404dn', '打印机', '2025-02-10', 3499.00, '办公设备供应商', '2028-02-09');
INSERT INTO `assets` VALUES (1005, '爱普生投影仪EB-1470Fi', '投影仪', '2024-10-22', 7899.00, '视听设备供应商', '2027-10-21');
INSERT INTO `assets` VALUES (1006, '苹果笔记本电脑MacBook Pro 13', '笔记本电脑', '2025-03-01', 12999.00, '科技电子有限公司', '2028-02-29');
INSERT INTO `assets` VALUES (1007, '联想台式电脑启天M428', '台式电脑', '2025-01-15', 5899.00, '计算机设备供应商', '2028-01-14');
INSERT INTO `assets` VALUES (1008, '三星显示器C27RG50FQ', '显示器', '2024-12-28', 2699.00, '电子科技有限公司', '2027-12-27');
INSERT INTO `assets` VALUES (1009, '佳能打印机 imagePROGRAF PRO-1000', '打印机', '2025-03-15', 12899.00, '办公设备供应商', '2028-03-14');
INSERT INTO `assets` VALUES (1010, '华为笔记本电脑MateBook 14', '笔记本电脑', '2025-04-05', 7299.00, '科技电子有限公司', '2028-04-04');
INSERT INTO `assets` VALUES (1011, '明基投影仪MX612ST', '投影仪', '2024-11-18', 5699.00, '视听设备供应商', '2027-11-17');
INSERT INTO `assets` VALUES (1012, '惠普台式电脑EliteDesk 800 G6', '台式电脑', '2025-05-10', 7399.00, '计算机设备供应商', '2028-05-09');
INSERT INTO `assets` VALUES (1013, '飞利浦显示器275E9', '显示器', '2024-10-05', 1999.00, '电子科技有限公司', '2027-10-04');
INSERT INTO `assets` VALUES (1014, '兄弟打印机HL-L8360CDW', '打印机', '2025-02-25', 4599.00, '办公设备供应商', '2028-02-24');
INSERT INTO `assets` VALUES (1015, '戴尔笔记本电脑XPS 13', '笔记本电脑', '2024-12-08', 10499.00, '科技电子有限公司', '2027-12-07');
INSERT INTO `assets` VALUES (1016, '联想台式电脑扬天M4000q', '台式电脑', '2025-04-20', 5299.00, '计算机设备供应商', '2028-04-19');
INSERT INTO `assets` VALUES (1017, '索尼投影仪VPL-VW295ES', '投影仪', '2025-01-30', 21999.00, '视听设备供应商', '2028-01-29');
INSERT INTO `assets` VALUES (1018, 'AOC显示器27G2U', '显示器', '2025-05-20', 2499.00, '电子科技有限公司', '2028-05-19');
INSERT INTO `assets` VALUES (1019, '爱普生打印机EcoTank ET-4760', '打印机', '2024-11-15', 2399.00, '办公设备供应商', '2027-11-14');
INSERT INTO `assets` VALUES (1020, '微软Surface Laptop 4', '笔记本电脑', '2025-03-25', 8799.00, '科技电子有限公司', '2028-03-24');

-- ----------------------------
-- Table structure for attendance_record
-- ----------------------------
DROP TABLE IF EXISTS `attendance_record`;
CREATE TABLE `attendance_record`  (
  `record_id` int(11) NOT NULL AUTO_INCREMENT,
  `employee_id` int(11) NULL DEFAULT NULL,
  `date` date NULL DEFAULT NULL,
  `check_in_time` datetime NULL DEFAULT NULL,
  `check_out_time` datetime NULL DEFAULT NULL,
  `status` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL,
  `remark` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL,
  PRIMARY KEY (`record_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 21 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '考勤记录表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of attendance_record
-- ----------------------------
INSERT INTO `attendance_record` VALUES (1, 2001, '2025-06-01', '2025-06-01 08:55:00', '2025-06-01 17:30:00', '正常', '');
INSERT INTO `attendance_record` VALUES (2, 2002, '2025-06-01', '2025-06-01 09:10:00', '2025-06-01 17:30:00', '迟到', '交通堵塞');
INSERT INTO `attendance_record` VALUES (3, 2003, '2025-06-01', '2025-06-01 08:45:00', '2025-06-01 17:15:00', '早退', '家中有事');
INSERT INTO `attendance_record` VALUES (4, 2004, '2025-06-01', NULL, NULL, '缺勤', '病假');
INSERT INTO `attendance_record` VALUES (5, 2001, '2025-06-02', '2025-06-02 08:50:00', '2025-06-02 17:35:00', '正常', '');
INSERT INTO `attendance_record` VALUES (6, 2002, '2025-06-02', '2025-06-02 08:58:00', '2025-06-02 17:28:00', '正常', '');
INSERT INTO `attendance_record` VALUES (7, 2003, '2025-06-02', '2025-06-02 09:05:00', '2025-06-02 17:30:00', '迟到', '会议延迟');
INSERT INTO `attendance_record` VALUES (8, 2006, '2025-06-02', '2025-06-02 08:40:00', '2025-06-02 17:40:00', '正常', '');
INSERT INTO `attendance_record` VALUES (9, 2007, '2025-06-03', '2025-06-03 09:15:00', '2025-06-03 17:30:00', '迟到', '暴雨天气');
INSERT INTO `attendance_record` VALUES (10, 2008, '2025-06-03', '2025-06-03 08:50:00', '2025-06-03 17:00:00', '早退', '预约体检');
INSERT INTO `attendance_record` VALUES (11, 2009, '2025-06-03', '2025-06-03 08:45:00', '2025-06-03 17:35:00', '正常', '');
INSERT INTO `attendance_record` VALUES (12, 2016, '2025-06-03', NULL, NULL, '缺勤', '事假');
INSERT INTO `attendance_record` VALUES (13, 2015, '2025-06-04', '2025-06-04 08:52:00', '2025-06-04 17:32:00', '正常', '');
INSERT INTO `attendance_record` VALUES (14, 2017, '2025-06-04', '2025-06-04 09:00:00', '2025-06-04 17:30:00', '迟到', '送孩子上学');
INSERT INTO `attendance_record` VALUES (15, 2020, '2025-06-04', '2025-06-04 08:40:00', '2025-06-04 17:10:00', '早退', '接家人');
INSERT INTO `attendance_record` VALUES (16, 2014, '2025-06-04', '2025-06-04 08:55:00', '2025-06-04 17:45:00', '正常', '');
INSERT INTO `attendance_record` VALUES (17, 2008, '2025-06-05', '2025-06-05 08:48:00', '2025-06-05 17:35:00', '正常', '');
INSERT INTO `attendance_record` VALUES (18, 2020, '2025-06-05', '2025-06-05 08:59:00', '2025-06-05 17:31:00', '正常', '');
INSERT INTO `attendance_record` VALUES (19, 2014, '2025-06-05', '2025-06-05 09:10:00', '2025-06-05 17:30:00', '迟到', '设备故障');
INSERT INTO `attendance_record` VALUES (20, 2013, '2025-06-05', NULL, NULL, '缺勤', '年假');

-- ----------------------------
-- Table structure for benefits_claims
-- ----------------------------
DROP TABLE IF EXISTS `benefits_claims`;
CREATE TABLE `benefits_claims`  (
  `claim_id` int(11) NOT NULL AUTO_INCREMENT,
  `employee_id` int(11) NULL DEFAULT NULL,
  `benefitsplan_id` int(11) NULL DEFAULT NULL,
  `claim_date` date NULL DEFAULT NULL,
  `amount` decimal(10, 2) NULL DEFAULT NULL,
  `reason` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL,
  `approval_date` date NULL DEFAULT NULL,
  `approver_id` int(11) NULL DEFAULT NULL,
  PRIMARY KEY (`claim_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 21 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '福利申请表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of benefits_claims
-- ----------------------------
INSERT INTO `benefits_claims` VALUES (1, 2006, 301, '2025-06-01', 800.00, '年度体检套餐', '2025-06-03', 2001);
INSERT INTO `benefits_claims` VALUES (2, 2007, 302, '2025-06-02', 1200.00, '子女教育补贴', '2025-06-05', 2002);
INSERT INTO `benefits_claims` VALUES (3, 2002, 303, '2025-06-03', 950.00, '健身俱乐部年费', '2025-06-06', 2003);
INSERT INTO `benefits_claims` VALUES (4, 2009, 304, '2025-06-04', 1500.00, '专业技能培训', '2025-06-07', 2004);
INSERT INTO `benefits_claims` VALUES (5, 2010, 301, '2025-06-05', 720.00, '体检附加项目', '2025-06-08', 2001);
INSERT INTO `benefits_claims` VALUES (6, 2011, 302, '2025-06-06', 1100.00, '子女兴趣班费用', '2025-06-09', 2002);
INSERT INTO `benefits_claims` VALUES (7, 2013, 303, '2025-06-07', 880.00, '健身私教课程', '2025-06-10', 2007);
INSERT INTO `benefits_claims` VALUES (8, 2014, 304, '2025-06-08', 1450.00, '行业认证考试', '2025-06-11', 2004);
INSERT INTO `benefits_claims` VALUES (9, 2003, 301, '2025-06-09', 790.00, '年度体检复查', '2025-06-12', 2001);
INSERT INTO `benefits_claims` VALUES (10, 2004, 302, '2025-06-10', 1300.00, '子女课外辅导', '2025-06-13', 2002);
INSERT INTO `benefits_claims` VALUES (11, 2017, 303, '2025-06-11', 920.00, '健身器材补贴', '2025-06-14', 2003);
INSERT INTO `benefits_claims` VALUES (12, 2019, 304, '2025-06-12', 1600.00, '高级管理培训', '2025-06-15', 2006);
INSERT INTO `benefits_claims` VALUES (13, 2020, 301, '2025-06-13', 850.00, '专项体检项目', '2025-06-16', 2001);
INSERT INTO `benefits_claims` VALUES (14, 2014, 302, '2025-06-14', 1250.00, '子女夏令营', '2025-06-17', 2002);
INSERT INTO `benefits_claims` VALUES (15, 2018, 303, '2025-06-15', 1000.00, '健身年卡续费', '2025-06-18', 2003);
INSERT INTO `benefits_claims` VALUES (16, 2017, 304, '2025-06-16', 1700.00, '国际研讨会', '2025-06-19', 2006);
INSERT INTO `benefits_claims` VALUES (17, 2006, 301, '2025-06-17', 820.00, '体检报告解读', '2025-06-20', 2001);
INSERT INTO `benefits_claims` VALUES (18, 2001, 302, '2025-06-18', 1400.00, '子女艺术培训', '2025-06-21', 2002);
INSERT INTO `benefits_claims` VALUES (19, 2018, 303, '2025-06-19', 980.00, '运动康复课程', '2025-06-22', 2007);
INSERT INTO `benefits_claims` VALUES (20, 2011, 304, '2025-06-20', 1550.00, '专业技能认证', '2025-06-23', 2004);

-- ----------------------------
-- Table structure for benefits_plan
-- ----------------------------
DROP TABLE IF EXISTS `benefits_plan`;
CREATE TABLE `benefits_plan`  (
  `benefitsplan_id` int(11) NOT NULL COMMENT '福利计划编号',
  `plan_name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '福利计划名称',
  `description` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL COMMENT '描述',
  `start_date` date NULL DEFAULT NULL COMMENT '生效日期',
  `end_date` date NULL DEFAULT NULL COMMENT '结束日期',
  PRIMARY KEY (`benefitsplan_id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '福利计划表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of benefits_plan
-- ----------------------------
INSERT INTO `benefits_plan` VALUES (301, '年度健康体检', '覆盖基础体检项目及自选补充项目', '2026-06-27', '2026-12-31');
INSERT INTO `benefits_plan` VALUES (302, '子女教育补贴', '为员工子女提供教育费用报销，包括兴趣班、补习班等', '2026-06-27', '2026-12-31');
INSERT INTO `benefits_plan` VALUES (303, '健身福利计划', '健身房会员费补贴及运动课程报销', '2026-06-27', '2026-12-31');
INSERT INTO `benefits_plan` VALUES (304, '职业技能培训', '支持员工参加专业技能培训和认证考试', '2026-06-27', '2026-12-31');
INSERT INTO `benefits_plan` VALUES (305, '补充商业保险', '提供额外的医疗、意外等商业保险保障', '2026-06-27', '2026-12-31');
INSERT INTO `benefits_plan` VALUES (306, '交通补贴计划', '每月固定金额的交通费用补贴', '2026-06-27', '2026-12-31');
INSERT INTO `benefits_plan` VALUES (307, '餐饮补贴计划', '工作餐费补贴或公司食堂优惠', '2026-06-27', '2026-12-31');
INSERT INTO `benefits_plan` VALUES (308, '育儿支持计划', '育儿假、托育服务补贴等福利', '2026-06-27', '2026-12-31');
INSERT INTO `benefits_plan` VALUES (309, '年度旅游津贴', '员工年度旅游费用补贴', '2026-06-27', '2026-12-31');
INSERT INTO `benefits_plan` VALUES (310, '弹性工作福利', '支持远程办公设备采购补贴', '2026-06-27', '2026-12-31');
INSERT INTO `benefits_plan` VALUES (311, '节日礼品福利', '重要节日礼品或购物卡发放', '2026-06-27', '2026-12-31');
INSERT INTO `benefits_plan` VALUES (312, '图书学习补贴', '员工购买专业书籍和学习资料报销', '2026-06-27', '2026-12-31');
INSERT INTO `benefits_plan` VALUES (313, '心理健康咨询', '提供专业心理咨询服务', '2026-06-27', '2026-12-31');
INSERT INTO `benefits_plan` VALUES (314, '老年护理补贴', '员工长辈护理费用补贴', '2026-06-27', '2026-12-31');
INSERT INTO `benefits_plan` VALUES (315, '购房贷款优惠', '提供内部购房贷款利息补贴', '2026-06-27', '2026-12-31');
INSERT INTO `benefits_plan` VALUES (316, '宠物关爱福利', '宠物医疗、寄养等相关补贴', '2026-06-27', '2026-12-31');
INSERT INTO `benefits_plan` VALUES (317, '创新项目支持', '员工创新项目启动资金', '2026-06-27', '2026-12-31');
INSERT INTO `benefits_plan` VALUES (318, '文化艺术补贴', '参观展览、演出等文化活动补贴', '2026-06-27', '2026-12-31');
INSERT INTO `benefits_plan` VALUES (319, '绿色出行补贴', '公共交通、共享单车等绿色出行方式补贴', '2026-06-27', '2026-12-31');
INSERT INTO `benefits_plan` VALUES (320, '家庭保险计划', '员工家属商业保险', '2026-06-27', '2026-12-31');

-- ----------------------------
-- Table structure for candidate
-- ----------------------------
DROP TABLE IF EXISTS `candidate`;
CREATE TABLE `candidate`  (
  `candidate_id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL,
  `gender` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL,
  `birth_date` date NULL DEFAULT NULL,
  `phone` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL,
  `email` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL,
  `education` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL,
  `experience` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL,
  PRIMARY KEY (`candidate_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 221 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '应聘者表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of candidate
-- ----------------------------
INSERT INTO `candidate` VALUES (201, '张三', '男', '1990-05-15', '13800138001', 'zhangsan@example.com', '本科', '5年3个月');
INSERT INTO `candidate` VALUES (202, '李四', '女', '1992-08-20', '13900139002', 'lisi@example.com', '硕士', '3年9个月');
INSERT INTO `candidate` VALUES (203, '王五', '男', '1988-12-03', '13700137003', 'wangwu@example.com', '本科', '7年整');
INSERT INTO `candidate` VALUES (204, '赵六', '女', '1995-03-12', '13600136004', 'zhaoliu@example.com', '本科', '2年3个月');
INSERT INTO `candidate` VALUES (205, '钱七', '男', '1985-07-28', '13500135005', 'qianqi@example.com', '博士', '10年6个月');
INSERT INTO `candidate` VALUES (206, '孙八', '女', '1993-11-05', '13400134006', 'sunba@example.com', '本科', '4年整');
INSERT INTO `candidate` VALUES (207, '周九', '男', '1991-04-18', '13300133007', 'zhoujiu@example.com', '硕士', '6年9个月');
INSERT INTO `candidate` VALUES (208, '吴十', '女', '1994-09-22', '13200132008', 'wushi@example.com', '本科', '3年3个月');
INSERT INTO `candidate` VALUES (209, '郑十一', '男', '1987-02-14', '13100131009', 'zhengshiyi@example.com', '大专', '8年6个月');
INSERT INTO `candidate` VALUES (210, '陈十二', '女', '1996-01-30', '13000130010', 'chenshi@example.com', '本科', '1年9个月');
INSERT INTO `candidate` VALUES (211, '杨十三', '男', '1989-06-07', '13800138011', 'yangshi@example.com', '硕士', '5年6个月');
INSERT INTO `candidate` VALUES (212, '黄十四', '女', '1992-10-19', '13900139012', 'huangshi@example.com', '本科', '3年整');
INSERT INTO `candidate` VALUES (213, '刘十五', '男', '1986-08-25', '13700137013', 'liushi@example.com', '大专', '9年3个月');
INSERT INTO `candidate` VALUES (214, '林十六', '女', '1993-03-11', '13600136014', 'linshi@example.com', '本科', '4年6个月');
INSERT INTO `candidate` VALUES (215, '朱十七', '男', '1990-12-06', '13500135015', 'zhushi@example.com', '硕士', '6年整');
INSERT INTO `candidate` VALUES (216, '胡十八', '女', '1995-07-23', '13400134016', 'hushi@example.com', '本科', '2年9个月');
INSERT INTO `candidate` VALUES (217, '高十九', '男', '1988-04-09', '13300133017', 'gaoshi@example.com', '本科', '7年3个月');
INSERT INTO `candidate` VALUES (218, '欧阳二十', '女', '1991-09-17', '13200132018', 'ouyang@example.com', '博士', '4年9个月');
INSERT INTO `candidate` VALUES (219, '司马二十一', '男', '1987-01-24', '13100131019', 'sima@example.com', '本科', '8年3个月');
INSERT INTO `candidate` VALUES (220, '诸葛二十二', '女', '1994-06-30', '13000130020', 'zhuge@example.com', '硕士', '3年6个月');

-- ----------------------------
-- Table structure for career_path
-- ----------------------------
DROP TABLE IF EXISTS `career_path`;
CREATE TABLE `career_path`  (
  `path_id` int(11) NOT NULL AUTO_INCREMENT,
  `path_name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL,
  `description` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL,
  `department_id` int(11) NULL DEFAULT NULL,
  PRIMARY KEY (`path_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 5021 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '职业路径表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of career_path
-- ----------------------------
INSERT INTO `career_path` VALUES (5001, '技术研发岗路径', '从初级工程师到技术专家的晋升路线', 401);
INSERT INTO `career_path` VALUES (5002, '产品经理岗路径', '产品助理到资深产品总监的发展通道', 402);
INSERT INTO `career_path` VALUES (5003, '市场营销岗路径', '市场专员至营销副总裁的成长路径', 403);
INSERT INTO `career_path` VALUES (5004, '人力资源岗路径', 'HR助理到首席人才官的职业阶梯', 406);
INSERT INTO `career_path` VALUES (5005, '财务会计岗路径', '会计助理至CFO的专业发展路线', 405);
INSERT INTO `career_path` VALUES (5006, '运营管理岗路径', '运营专员到运营总经理的晋升体系', 414);
INSERT INTO `career_path` VALUES (5007, '设计创意岗路径', '设计师到设计总监的职业发展通道', 413);
INSERT INTO `career_path` VALUES (5008, '销售业务岗路径', '销售代表至销售总裁的晋升路线', 417);
INSERT INTO `career_path` VALUES (5009, '数据分析岗路径', '数据分析师到首席数据官的成长路径', 405);
INSERT INTO `career_path` VALUES (5010, '供应链管理岗路径', '供应链助理到供应链总监的发展通道', 402);
INSERT INTO `career_path` VALUES (5011, '法务合规岗路径', '法务助理至首席法务官的职业阶梯', 405);
INSERT INTO `career_path` VALUES (5012, '客户服务岗路径', '客服专员到客服总经理的晋升体系', 407);
INSERT INTO `career_path` VALUES (5013, '项目管理岗路径', '项目助理到PMO总监的发展路线', 406);
INSERT INTO `career_path` VALUES (5014, '行政后勤岗路径', '行政助理至行政总监的职业通道', 407);
INSERT INTO `career_path` VALUES (5015, '战略规划岗路径', '战略分析员到战略副总裁的成长路径', 402);
INSERT INTO `career_path` VALUES (5016, '教育培训岗路径', '培训专员到企业大学校长的发展通道', 420);
INSERT INTO `career_path` VALUES (5017, '质量管理岗路径', '质量工程师到质量总监的职业阶梯', 418);
INSERT INTO `career_path` VALUES (5018, '采购管理岗路径', '采购助理到采购总经理的晋升体系', 405);
INSERT INTO `career_path` VALUES (5019, '品牌公关岗路径', '品牌专员到公关总监的发展路线', 416);
INSERT INTO `career_path` VALUES (5020, 'IT运维岗路径', '运维工程师到IT总监的职业通道', 401);

-- ----------------------------
-- Table structure for career_stage
-- ----------------------------
DROP TABLE IF EXISTS `career_stage`;
CREATE TABLE `career_stage`  (
  `stage_id` int(11) NOT NULL AUTO_INCREMENT,
  `path_id` int(11) NULL DEFAULT NULL,
  `stage_name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL,
  `level` tinyint(4) NULL DEFAULT NULL,
  `requirements` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL,
  PRIMARY KEY (`stage_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 521 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '职业阶段表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of career_stage
-- ----------------------------
INSERT INTO `career_stage` VALUES (501, 5001, '初级工程师', 1, '本科及以上学历，掌握基础编程技能，了解开发流程');
INSERT INTO `career_stage` VALUES (502, 5001, '中级工程师', 2, '2年以上经验，独立完成模块开发，具备问题排查能力');
INSERT INTO `career_stage` VALUES (503, 5001, '高级工程师', 3, '5年以上经验，主导系统架构设计，解决复杂技术难题');
INSERT INTO `career_stage` VALUES (504, 5001, '技术专家', 4, '8年以上经验，引领技术方向，推动创新解决方案');
INSERT INTO `career_stage` VALUES (505, 5002, '产品助理', 1, '熟悉产品流程，具备需求分析和文档编写能力');
INSERT INTO `career_stage` VALUES (506, 5002, '产品经理', 2, '3年以上经验，负责产品线规划，协调跨部门合作');
INSERT INTO `career_stage` VALUES (507, 5002, '高级产品经理', 3, '5年以上经验，主导产品战略，提升用户体验');
INSERT INTO `career_stage` VALUES (508, 5002, '产品总监', 4, '8年以上经验，制定产品路线图，驱动业务增长');
INSERT INTO `career_stage` VALUES (509, 5003, '市场专员', 1, '了解市场调研方法，熟练使用营销工具');
INSERT INTO `career_stage` VALUES (510, 5003, '市场经理', 2, '3年以上经验，策划执行营销活动，分析数据效果');
INSERT INTO `career_stage` VALUES (511, 5003, '高级市场经理', 3, '5年以上经验，管理品牌策略，优化营销渠道');
INSERT INTO `career_stage` VALUES (512, 5003, '营销副总裁', 4, '10年以上经验，制定整体营销策略，提升品牌影响力');
INSERT INTO `career_stage` VALUES (513, 5004, 'HR助理', 1, '熟悉人力资源流程，具备基础招聘和培训能力');
INSERT INTO `career_stage` VALUES (514, 5004, 'HR专员', 2, '2年以上经验，负责模块工作，如招聘、培训或薪酬');
INSERT INTO `career_stage` VALUES (515, 5004, 'HR经理', 3, '5年以上经验，管理部门运作，制定人力资源策略');
INSERT INTO `career_stage` VALUES (516, 5004, '首席人才官', 4, '10年以上经验，制定人才战略，推动组织发展');
INSERT INTO `career_stage` VALUES (517, 5005, '会计助理', 1, '熟悉财务软件，掌握基础会计核算');
INSERT INTO `career_stage` VALUES (518, 5005, '会计', 2, '2年以上经验，独立完成账务处理和报表编制');
INSERT INTO `career_stage` VALUES (519, 5005, '财务经理', 3, '5年以上经验，管理财务团队，制定预算和分析');
INSERT INTO `career_stage` VALUES (520, 5005, 'CFO', 4, '10年以上经验，制定财务战略，统筹投融资决策');

-- ----------------------------
-- Table structure for compliance_policy
-- ----------------------------
DROP TABLE IF EXISTS `compliance_policy`;
CREATE TABLE `compliance_policy`  (
  `policy_id` int(11) NOT NULL AUTO_INCREMENT,
  `policy_name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL,
  `description` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL,
  `effective_date` date NULL DEFAULT NULL COMMENT '生效日期',
  `review_date` date NULL DEFAULT NULL COMMENT '审核日期',
  PRIMARY KEY (`policy_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 21 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '合规政策表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of compliance_policy
-- ----------------------------
INSERT INTO `compliance_policy` VALUES (1, '数据安全管理规定', '规范公司数据采集、存储、传输及销毁的全生命周期管理', '2023-01-01', '2024-12-31');
INSERT INTO `compliance_policy` VALUES (2, '反商业贿赂政策', '禁止员工在业务往来中进行贿赂或不正当利益输送', '2023-03-15', '2025-03-14');
INSERT INTO `compliance_policy` VALUES (3, '知识产权保护制度', '明确公司及员工对知识产权的权利与义务', '2023-05-01', '2024-04-30');
INSERT INTO `compliance_policy` VALUES (4, '信息披露合规政策', '规范上市公司财务及非财务信息的披露流程', '2023-07-01', '2024-06-30');
INSERT INTO `compliance_policy` VALUES (5, '劳动用工合规准则', '规定员工招聘、薪酬、福利及劳动关系管理要求', '2023-09-01', '2024-08-31');
INSERT INTO `compliance_policy` VALUES (6, '反垄断与反不正当竞争政策', '禁止垄断协议、滥用市场支配地位等行为', '2023-11-01', '2024-10-31');
INSERT INTO `compliance_policy` VALUES (7, '网络安全应急预案', '明确网络安全事件的预防、响应及恢复流程', '2024-01-01', '2025-01-01');
INSERT INTO `compliance_policy` VALUES (8, '广告宣传合规规范', '规范产品广告中的内容表述及法律风险防控', '2024-02-15', '2025-02-14');
INSERT INTO `compliance_policy` VALUES (9, '出口管制合规政策', '管理涉及国际出口的技术、产品及服务合规性', '2024-04-01', '2025-03-31');
INSERT INTO `compliance_policy` VALUES (10, '个人信息保护政策（GDPR）', '符合欧盟通用数据保护条例的实施细则', '2024-06-01', '2025-05-31');
INSERT INTO `compliance_policy` VALUES (11, '反洗钱内部控制制度', '防范通过公司业务进行洗钱的风险管控措施', '2024-08-01', '2025-07-31');
INSERT INTO `compliance_policy` VALUES (12, '供应商合规管理办法', '规范供应商筛选、合作及绩效评估的合规要求', '2024-10-01', '2025-09-30');
INSERT INTO `compliance_policy` VALUES (13, '礼品与招待政策', '限制员工在商务往来中赠送及接受礼品的标准', '2023-12-01', '2024-11-30');
INSERT INTO `compliance_policy` VALUES (14, '利益冲突申报制度', '要求员工申报可能影响职业判断的利益关联', '2024-01-15', '2025-01-14');
INSERT INTO `compliance_policy` VALUES (15, '环境健康安全政策（EHS）', '规定公司运营中的环保、健康及安全标准', '2024-03-01', '2025-02-28');
INSERT INTO `compliance_policy` VALUES (16, '科研项目合规管理规定', '规范研发项目中的知识产权、数据安全等要求', '2024-05-01', '2025-04-30');
INSERT INTO `compliance_policy` VALUES (17, '跨境交易合规指引', '指导跨国业务中的税务、外汇及法律合规操作', '2024-07-01', '2025-06-30');
INSERT INTO `compliance_policy` VALUES (18, '商业伙伴合规审查流程', '对合作方进行合规风险评估及持续监控机制', '2024-09-01', '2025-08-31');
INSERT INTO `compliance_policy` VALUES (19, '反欺诈与舞弊管理制度', '预防、检测及应对公司内部欺诈行为的措施', '2024-11-01', '2025-10-31');
INSERT INTO `compliance_policy` VALUES (20, '合规培训与考核制度', '规定员工合规培训的内容、频率及考核标准', '2023-10-01', '2024-09-30');

-- ----------------------------
-- Table structure for department
-- ----------------------------
DROP TABLE IF EXISTS `department`;
CREATE TABLE `department`  (
  `department_id` int(11) NOT NULL AUTO_INCREMENT COMMENT '部门号',
  `department_name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '部门名称',
  `parent_id` int(11) NULL DEFAULT NULL COMMENT '上级部门ID',
  `manager_id` int(11) NULL DEFAULT NULL COMMENT '部门经理号',
  PRIMARY KEY (`department_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 421 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '部门表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of department
-- ----------------------------
INSERT INTO `department` VALUES (401, '技术部', NULL, 2001);
INSERT INTO `department` VALUES (402, '产品部', NULL, 2002);
INSERT INTO `department` VALUES (403, '市场部', NULL, 2003);
INSERT INTO `department` VALUES (404, '销售部', NULL, 2004);
INSERT INTO `department` VALUES (405, '财务部', NULL, 2005);
INSERT INTO `department` VALUES (406, '人力资源部', NULL, 2006);
INSERT INTO `department` VALUES (407, '行政部', NULL, 2007);
INSERT INTO `department` VALUES (408, '研发一部', 401, 2001);
INSERT INTO `department` VALUES (409, '研发二部', 401, 2001);
INSERT INTO `department` VALUES (410, '前端开发组', 401, 2001);
INSERT INTO `department` VALUES (411, '后端开发组', 401, 2001);
INSERT INTO `department` VALUES (412, '测试组', 401, 2001);
INSERT INTO `department` VALUES (413, '产品设计组', 402, 2002);
INSERT INTO `department` VALUES (414, '产品运营组', 402, 2002);
INSERT INTO `department` VALUES (415, '品牌市场组', 403, 2003);
INSERT INTO `department` VALUES (416, '数字营销组', 403, 2003);
INSERT INTO `department` VALUES (417, '销售一组', 404, 2004);
INSERT INTO `department` VALUES (418, '销售二组', 404, 2004);
INSERT INTO `department` VALUES (419, '招聘组', 406, 2006);
INSERT INTO `department` VALUES (420, '培训组', 407, 2007);

-- ----------------------------
-- Table structure for discussion_forum
-- ----------------------------
DROP TABLE IF EXISTS `discussion_forum`;
CREATE TABLE `discussion_forum`  (
  `forum_id` int(11) NOT NULL AUTO_INCREMENT,
  `forum_name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL,
  `description` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL,
  `created_by` int(11) NULL DEFAULT NULL COMMENT '创建者 ID，关联用户表的用户 ID，记录创建人信息。',
  `created_date` datetime NULL DEFAULT NULL,
  PRIMARY KEY (`forum_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 21 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '讨论区表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of discussion_forum
-- ----------------------------
INSERT INTO `discussion_forum` VALUES (1, '技术交流区', '分享编程技巧、框架应用及技术难题解决方案', 1001, '2023-01-15 00:00:00');
INSERT INTO `discussion_forum` VALUES (2, '产品设计讨论', '探讨产品原型、用户体验及交互设计优化', 1002, '2023-02-20 00:00:00');
INSERT INTO `discussion_forum` VALUES (3, '市场营销策略', '交流市场调研、活动策划及品牌推广经验', 1003, '2023-03-10 00:00:00');
INSERT INTO `discussion_forum` VALUES (4, '销售经验分享', '销售技巧、客户管理及成交案例讨论', 1004, '2023-04-05 00:00:00');
INSERT INTO `discussion_forum` VALUES (5, '财务管理答疑', '财务制度、税务申报及预算管理问题解答', 1005, '2023-05-18 00:00:00');
INSERT INTO `discussion_forum` VALUES (6, '人力资源咨询', '招聘流程、绩效考核及员工关系管理交流', 1006, '2023-06-25 00:00:00');
INSERT INTO `discussion_forum` VALUES (7, '行政后勤服务', '办公管理、采购流程及固定资产管理讨论', 1007, '2023-07-12 00:00:00');
INSERT INTO `discussion_forum` VALUES (8, '前端开发技术', 'HTML/CSS/JS及前端框架应用经验分享', 1010, '2023-08-03 00:00:00');
INSERT INTO `discussion_forum` VALUES (9, '后端开发技术', 'Java/Python/Go等后端语言及架构讨论', 1011, '2023-09-16 00:00:00');
INSERT INTO `discussion_forum` VALUES (10, '测试技术分享', '软件测试方法、自动化测试工具使用交流', 1012, '2023-10-28 00:00:00');
INSERT INTO `discussion_forum` VALUES (11, '产品运营策略', '用户增长、数据分析及运营活动策划讨论', 1014, '2023-11-09 00:00:00');
INSERT INTO `discussion_forum` VALUES (12, '品牌营销案例', '成功营销案例拆解及行业趋势分析', 1015, '2023-12-20 00:00:00');
INSERT INTO `discussion_forum` VALUES (13, '数字营销技术', 'SEO/SEM、社交媒体营销及广告投放技巧', 1016, '2024-01-15 00:00:00');
INSERT INTO `discussion_forum` VALUES (14, '客户开发技巧', '新客户拓展、商务谈判及客户维护经验', 1017, '2024-02-22 00:00:00');
INSERT INTO `discussion_forum` VALUES (15, '员工培训与发展', '培训课程设计、职业规划及学习资源分享', 1020, '2024-03-10 00:00:00');
INSERT INTO `discussion_forum` VALUES (16, '职场经验交流', '跨部门协作、时间管理及职业成长讨论', 1001, '2024-04-05 00:00:00');
INSERT INTO `discussion_forum` VALUES (17, '公司制度答疑', '内部流程、合规政策及管理制度解读', 1006, '2024-05-18 00:00:00');
INSERT INTO `discussion_forum` VALUES (18, '创新项目孵化', '新产品构思、创意验证及项目启动讨论', 1002, '2024-06-25 00:00:00');
INSERT INTO `discussion_forum` VALUES (19, '行业动态分析', '科技、市场及行业政策变化趋势交流', 1003, '2024-07-12 00:00:00');
INSERT INTO `discussion_forum` VALUES (20, '员工生活分享', '兴趣爱好、团队活动及生活趣事交流', 1007, '2024-08-20 00:00:00');

-- ----------------------------
-- Table structure for document_category
-- ----------------------------
DROP TABLE IF EXISTS `document_category`;
CREATE TABLE `document_category`  (
  `category_id` int(11) NOT NULL AUTO_INCREMENT,
  `category_name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL,
  `parent_id` int(11) NULL DEFAULT NULL,
  `description` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL,
  PRIMARY KEY (`category_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 21 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '文档分类表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of document_category
-- ----------------------------
INSERT INTO `document_category` VALUES (1, '公司制度', NULL, '企业内部管理规范及流程文件');
INSERT INTO `document_category` VALUES (2, '技术文档', NULL, '产品技术方案、开发手册及架构设计');
INSERT INTO `document_category` VALUES (3, '市场资料', NULL, '市场调研、品牌推广及营销活动文档');
INSERT INTO `document_category` VALUES (4, '销售支持', NULL, '产品手册、报价单及客户案例');
INSERT INTO `document_category` VALUES (5, '财务文件', NULL, '预算报告、财务报表及税务资料');
INSERT INTO `document_category` VALUES (6, '人力资源', NULL, '招聘流程、绩效考核及培训材料');
INSERT INTO `document_category` VALUES (7, '行政后勤', NULL, '办公管理、采购流程及固定资产制度');
INSERT INTO `document_category` VALUES (8, '研发规范', 2, '软件开发流程、编码规范及测试标准');
INSERT INTO `document_category` VALUES (9, '技术架构', 2, '系统架构设计、技术选型及部署方案');
INSERT INTO `document_category` VALUES (10, 'API文档', 2, '接口说明、调用规范及开发示例');
INSERT INTO `document_category` VALUES (11, '市场调研', 3, '行业分析、竞品研究及用户画像');
INSERT INTO `document_category` VALUES (12, '品牌物料', 3, 'VI规范、宣传海报及视频素材');
INSERT INTO `document_category` VALUES (13, '活动策划', 3, '线上线下活动方案及执行细则');
INSERT INTO `document_category` VALUES (14, '产品手册', 4, '功能介绍、操作指南及用户说明');
INSERT INTO `document_category` VALUES (15, '销售话术', 4, '客户沟通技巧及常见问题应答');
INSERT INTO `document_category` VALUES (16, '合同模板', 4, '销售合同、服务协议及保密协议');
INSERT INTO `document_category` VALUES (17, '招聘流程', 6, '岗位JD、面试评估及入职手续');
INSERT INTO `document_category` VALUES (18, '培训课件', 6, '新员工培训、技能提升及职业发展课程');
INSERT INTO `document_category` VALUES (19, '行政流程', 7, '出差申请、报销制度及会议管理');
INSERT INTO `document_category` VALUES (20, '采购规范', 7, '供应商管理、采购流程及验收标准');

-- ----------------------------
-- Table structure for document_sharing
-- ----------------------------
DROP TABLE IF EXISTS `document_sharing`;
CREATE TABLE `document_sharing`  (
  `sharing_id` int(11) NOT NULL AUTO_INCREMENT,
  `document_id` int(11) NULL DEFAULT NULL,
  `shared_with` int(11) NULL DEFAULT NULL,
  `sharing_type` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '共享类型，固定值为 \'employee\'（员工）或 \'department\'（部门）',
  `permission_level` tinyint(4) NULL DEFAULT NULL,
  `share_date` datetime NULL DEFAULT NULL,
  PRIMARY KEY (`sharing_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 21 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '文档共享表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of document_sharing
-- ----------------------------
INSERT INTO `document_sharing` VALUES (1, 101, 2001, '员工', 1, '2025-01-10 09:00:00');
INSERT INTO `document_sharing` VALUES (2, 102, 2002, '员工', 2, '2025-01-11 10:30:00');
INSERT INTO `document_sharing` VALUES (3, 103, 3001, '部门', 1, '2025-01-12 14:15:00');
INSERT INTO `document_sharing` VALUES (4, 104, 2003, '员工', 1, '2025-01-13 08:45:00');
INSERT INTO `document_sharing` VALUES (5, 105, 3002, '部门', 2, '2025-01-14 15:20:00');
INSERT INTO `document_sharing` VALUES (6, 106, 2004, '员工', 3, '2025-01-15 11:50:00');
INSERT INTO `document_sharing` VALUES (7, 107, 3003, '部门', 1, '2025-01-16 13:10:00');
INSERT INTO `document_sharing` VALUES (8, 108, 2005, '员工', 2, '2025-01-17 09:20:00');
INSERT INTO `document_sharing` VALUES (9, 109, 3004, '部门', 3, '2025-01-18 16:30:00');
INSERT INTO `document_sharing` VALUES (10, 110, 2006, '员工', 1, '2025-01-19 10:10:00');
INSERT INTO `document_sharing` VALUES (11, 111, 3005, '部门', 2, '2025-01-20 14:40:00');
INSERT INTO `document_sharing` VALUES (12, 112, 2007, '员工', 1, '2025-01-21 08:50:00');
INSERT INTO `document_sharing` VALUES (13, 113, 3006, '部门', 3, '2025-01-22 15:00:00');
INSERT INTO `document_sharing` VALUES (14, 114, 2008, '员工', 2, '2025-01-23 11:20:00');
INSERT INTO `document_sharing` VALUES (15, 115, 3007, '部门', 1, '2025-01-24 13:30:00');
INSERT INTO `document_sharing` VALUES (16, 116, 2009, '员工', 3, '2025-01-25 09:40:00');
INSERT INTO `document_sharing` VALUES (17, 117, 3008, '部门', 2, '2025-01-26 14:50:00');
INSERT INTO `document_sharing` VALUES (18, 118, 2010, '员工', 1, '2025-01-27 10:00:00');
INSERT INTO `document_sharing` VALUES (19, 119, 3009, '部门', 3, '2025-01-28 16:10:00');
INSERT INTO `document_sharing` VALUES (20, 120, 2011, '员工', 2, '2025-01-29 08:30:00');

-- ----------------------------
-- Table structure for documents
-- ----------------------------
DROP TABLE IF EXISTS `documents`;
CREATE TABLE `documents`  (
  `document_id` int(11) NOT NULL AUTO_INCREMENT,
  `title` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL,
  `description` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL,
  `document_type` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL,
  `upload_date` date NULL DEFAULT NULL,
  `uploader_id` int(11) NULL DEFAULT NULL,
  `version` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL,
  PRIMARY KEY (`document_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 121 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '文档表\r\n' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of documents
-- ----------------------------
INSERT INTO `documents` VALUES (101, '员工手册（2025版）', '公司规章制度、员工权益及流程说明', '制度文件', '2025-01-02', 2001, 'V1.0');
INSERT INTO `documents` VALUES (102, '技术架构设计方案', '系统核心架构、技术选型及部署说明', '技术文档', '2025-01-03', 2002, 'V1.1');
INSERT INTO `documents` VALUES (103, '2025年市场推广计划', '年度营销活动规划、渠道策略及预算', '市场文档', '2025-01-04', 2003, 'V1.0');
INSERT INTO `documents` VALUES (104, '产品功能需求说明书', '详细功能模块、交互逻辑及验收标准', '需求文档', '2025-01-05', 2004, 'V1.0');
INSERT INTO `documents` VALUES (105, '财务报销流程指引', '报销分类、提交材料及审批步骤说明', '财务文档', '2025-01-06', 2005, 'V2.0');
INSERT INTO `documents` VALUES (106, 'Java编码规范手册', '代码风格、命名规则及最佳实践', '技术文档', '2025-01-07', 2006, 'V1.2');
INSERT INTO `documents` VALUES (107, '新员工培训课件', '企业文化、岗位认知及工具使用培训', '培训文档', '2025-01-08', 2007, 'V1.0');
INSERT INTO `documents` VALUES (108, '2024年度销售数据分析', '区域业绩、客户分布及趋势报告', '销售文档', '2025-01-09', 2008, 'V1.1');
INSERT INTO `documents` VALUES (109, '数据库表结构设计', '全库表字段、关联关系及索引说明', '技术文档', '2025-01-10', 2009, 'V1.0');
INSERT INTO `documents` VALUES (110, '员工绩效考核方案', '考核指标、评分标准及流程说明', '人力文档', '2025-01-11', 2010, 'V2.1');
INSERT INTO `documents` VALUES (111, '品牌VI设计规范', 'logo、色彩、字体及应用场景标准', '设计文档', '2025-01-12', 2011, 'V1.0');
INSERT INTO `documents` VALUES (112, '项目进度周报（第3周）', '任务完成情况、风险及下周计划', '项目文档', '2025-01-13', 2012, 'V3.0');
INSERT INTO `documents` VALUES (113, 'Python接口开发文档', '接口列表、参数说明及调用示例', '技术文档', '2025-01-14', 2013, 'V1.0');
INSERT INTO `documents` VALUES (114, '行政办公用品采购清单', '季度采购需求、预算及供应商信息', '行政文档', '2025-01-15', 2014, 'V1.1');
INSERT INTO `documents` VALUES (115, '客户服务话术模板', '常见问题应答、沟通技巧及规范', '客服文档', '2025-01-16', 2015, 'V1.0');
INSERT INTO `documents` VALUES (116, '数据安全应急预案', '安全事件分级、响应流程及恢复方案', '安全文档', '2025-01-17', 2016, 'V2.0');
INSERT INTO `documents` VALUES (117, '市场营销活动总结报告', '活动效果、ROI分析及优化建议', '市场文档', '2025-01-18', 2017, 'V1.1');
INSERT INTO `documents` VALUES (118, '前端UI设计稿（V2）', '页面布局、组件交互及动效说明', '设计文档', '2025-01-19', 2018, 'V2.0');
INSERT INTO `documents` VALUES (119, '服务器运维操作手册', '日常巡检、故障排查及优化步骤', '技术文档', '2025-01-20', 2019, 'V1.3');
INSERT INTO `documents` VALUES (120, '员工福利政策解读', '各类福利申请条件、流程及说明', '人力文档', '2025-01-21', 2020, 'V1.0');

-- ----------------------------
-- Table structure for employee
-- ----------------------------
DROP TABLE IF EXISTS `employee`;
CREATE TABLE `employee`  (
  `employee_id` int(11) NOT NULL AUTO_INCREMENT COMMENT '员工编号',
  `name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '姓名',
  `gender` char(2) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '性别',
  `birth_date` date NULL DEFAULT NULL COMMENT '出生日期',
  `id_card` varchar(18) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '身份证号',
  `phone` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '电话',
  `email` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '邮箱',
  `address` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '地址',
  `emergency_contact` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '紧急联系人',
  `emergency_phone` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '紧急联系电话',
  `hire_date` date NULL DEFAULT NULL COMMENT '入职日期',
  `status` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '状态：在职/离职/休假/试用期',
  `department_id` int(11) NULL DEFAULT NULL COMMENT '部门号',
  `position_id` int(11) NULL DEFAULT NULL COMMENT '职位号',
  PRIMARY KEY (`employee_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 2021 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '员工表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of employee
-- ----------------------------
INSERT INTO `employee` VALUES (2001, '张逸飞', '男', '1990-05-15', '11010519900515XXXX', '13800138001', 'zhangyf@company.com', '北京市朝阳区XX路12号', '张建国', '13900139000', '2018-07-01', '在职', 101, 5001);
INSERT INTO `employee` VALUES (2002, '李诗韵', '女', '1992-08-20', '12010319920820XXXX', '13900139002', 'lishiyun@company.com', '上海市浦东新区XX街23号', '王芳', '13800138002', '2019-03-12', '在职', 102, 5002);
INSERT INTO `employee` VALUES (2003, '王宇轩', '男', '1988-12-03', '44010619881203XXXX', '13700137003', 'wangyx@company.com', '广州市天河区XX大道34号', '李丽', '13700137004', '2017-09-20', '在职', 103, 5003);
INSERT INTO `employee` VALUES (2004, '赵思语', '女', '1995-03-12', '32010419950312XXXX', '13600136004', 'zhaosy@company.com', '南京市鼓楼区XX巷45号', '陈强', '13600136005', '2020-06-05', '在职', 104, 5004);
INSERT INTO `employee` VALUES (2005, '陈宇澄', '男', '1985-07-28', '44030519850728XXXX', '13500135005', 'chenyc@company.com', '深圳市福田区XX路56号', '吴敏', '13500135006', '2016-04-18', '在职', 105, 5005);
INSERT INTO `employee` VALUES (2006, '刘悦萱', '女', '1993-11-05', '11010819931105XXXX', '13400134006', 'liuyx@company.com', '北京市海淀区XX街67号', '张平', '13400134007', '2019-11-22', '在职', 106, 5006);
INSERT INTO `employee` VALUES (2007, '杨睿渊', '男', '1991-04-18', '31010719910418XXXX', '13300133007', 'yangry@company.com', '上海市徐汇区XX路78号', '王莉', '13300133008', '2018-08-15', '在职', 107, 5007);
INSERT INTO `employee` VALUES (2008, '吴雨薇', '女', '1994-09-22', '44010419940922XXXX', '13200132008', 'wuyw@company.com', '广州市海珠区XX大道89号', '陈刚', '13200132009', '2020-02-10', '在职', 108, 5008);
INSERT INTO `employee` VALUES (2009, '郑恺泽', '男', '1987-02-14', '12010519870214XXXX', '13100131009', 'zhengkz@company.com', '天津市和平区XX街90号', '刘梅', '13100131010', '2017-06-08', '在职', 109, 5009);
INSERT INTO `employee` VALUES (2010, '孙诗涵', '女', '1996-01-30', '44030619960130XXXX', '13000130010', 'sunsh@company.com', '深圳市南山区XX路101号', '赵亮', '13000130011', '2021-01-18', '试用期', 110, 5010);
INSERT INTO `employee` VALUES (2011, '周逸尘', '男', '1989-06-07', '31010619890607XXXX', '12900129011', 'zhouyc@company.com', '上海市黄浦区XX巷112号', '王丽', '12900129012', '2018-10-25', '在职', 111, 5011);
INSERT INTO `employee` VALUES (2012, '吴梦琪', '女', '1992-10-19', '44010319921019XXXX', '12800128012', 'wumq@company.com', '广州市越秀区XX路123号', '陈辉', '12800128013', '2019-07-16', '在职', 112, 5012);
INSERT INTO `employee` VALUES (2013, '徐宇澄', '男', '1986-08-25', '11010619860825XXXX', '12700127013', 'xuyc@company.com', '北京市东城区XX街134号', '李娟', '12700127014', '2016-09-30', '在职', 113, 5013);
INSERT INTO `employee` VALUES (2014, '林悦溪', '女', '1993-03-11', '32010519930311XXXX', '12600126014', 'linyx@company.com', '南京市秦淮区XX大道145号', '张强', '12600126015', '2020-04-22', '在职', 114, 5014);
INSERT INTO `employee` VALUES (2015, '郭睿渊', '男', '1990-12-06', '44030419901206XXXX', '12500125015', 'guory@company.com', '深圳市罗湖区XX路156号', '王芳', '12500125016', '2018-05-12', '在职', 115, 5015);
INSERT INTO `employee` VALUES (2016, '胡雨薇', '女', '1995-07-23', '11010719950723XXXX', '12400124016', 'huyw@company.com', '北京市石景山区XX街167号', '陈刚', '12400124017', '2021-03-28', '试用期', 116, 5016);
INSERT INTO `employee` VALUES (2017, '马宇轩', '男', '1988-04-09', '31010819880409XXXX', '12300123017', 'mayx@company.com', '上海市长宁区XX路178号', '刘梅', '12300123018', '2017-11-15', '在职', 117, 5017);
INSERT INTO `employee` VALUES (2018, '何诗涵', '女', '1991-09-17', '44010619910917XXXX', '12200122018', 'hesh@company.com', '广州市白云区XX大道189号', '赵亮', '12200122019', '2019-09-20', '在职', 118, 5018);
INSERT INTO `employee` VALUES (2019, '高逸尘', '男', '1987-01-24', '12010419870124XXXX', '12100121019', 'gaoyc@company.com', '天津市河西区XX街200号', '王丽', '12100121020', '2016-12-05', '在职', 119, 5019);
INSERT INTO `employee` VALUES (2020, '唐梦琪', '女', '1994-06-30', '44030519940630XXXX', '12000120020', 'tangmq@company.com', '深圳市宝安区XX路211号', '陈辉', '12000120021', '2020-08-18', '在职', 120, 5020);

-- ----------------------------
-- Table structure for employee_benefits
-- ----------------------------
DROP TABLE IF EXISTS `employee_benefits`;
CREATE TABLE `employee_benefits`  (
  `employeebenefits_id` int(11) NOT NULL COMMENT '员工福利关联编号',
  `employee_id` int(11) NULL DEFAULT NULL COMMENT '员工编号',
  `benefitsplan_id` int(11) NULL DEFAULT NULL COMMENT '福利计划编号',
  `enrollment_date` date NULL DEFAULT NULL COMMENT '参与日期',
  `coverage_amount` decimal(10, 2) NULL DEFAULT NULL COMMENT '覆盖金额',
  PRIMARY KEY (`employeebenefits_id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '员工福利关联表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of employee_benefits
-- ----------------------------
INSERT INTO `employee_benefits` VALUES (1, 2001, 2001, '2025-01-05', 800.00);
INSERT INTO `employee_benefits` VALUES (2, 2002, 2002, '2025-01-06', 1200.00);
INSERT INTO `employee_benefits` VALUES (3, 2003, 2003, '2025-01-07', 950.00);
INSERT INTO `employee_benefits` VALUES (4, 2004, 2004, '2025-01-08', 1500.00);
INSERT INTO `employee_benefits` VALUES (5, 2005, 2005, '2025-01-09', 1000.00);
INSERT INTO `employee_benefits` VALUES (6, 2006, 2006, '2025-01-10', 800.00);
INSERT INTO `employee_benefits` VALUES (7, 2007, 2007, '2025-01-11', 1100.00);
INSERT INTO `employee_benefits` VALUES (8, 2008, 2008, '2025-01-12', 900.00);
INSERT INTO `employee_benefits` VALUES (9, 2009, 2009, '2025-01-13', 1300.00);
INSERT INTO `employee_benefits` VALUES (10, 2010, 2010, '2025-01-14', 700.00);
INSERT INTO `employee_benefits` VALUES (11, 2011, 2011, '2025-01-15', 1050.00);
INSERT INTO `employee_benefits` VALUES (12, 2012, 2012, '2025-01-16', 950.00);
INSERT INTO `employee_benefits` VALUES (13, 2013, 2013, '2025-01-17', 1250.00);
INSERT INTO `employee_benefits` VALUES (14, 2014, 2014, '2025-01-18', 850.00);
INSERT INTO `employee_benefits` VALUES (15, 2015, 2015, '2025-01-19', 1150.00);
INSERT INTO `employee_benefits` VALUES (16, 2016, 2016, '2025-01-20', 900.00);
INSERT INTO `employee_benefits` VALUES (17, 2017, 2017, '2025-01-21', 1350.00);
INSERT INTO `employee_benefits` VALUES (18, 2018, 2018, '2025-01-22', 800.00);
INSERT INTO `employee_benefits` VALUES (19, 2019, 2019, '2025-01-23', 1000.00);
INSERT INTO `employee_benefits` VALUES (20, 2020, 2020, '2025-01-24', 1200.00);

-- ----------------------------
-- Table structure for employee_development
-- ----------------------------
DROP TABLE IF EXISTS `employee_development`;
CREATE TABLE `employee_development`  (
  `plan_id` int(11) NOT NULL AUTO_INCREMENT,
  `employee_id` int(11) NULL DEFAULT NULL,
  `path_id` int(11) NULL DEFAULT NULL,
  `current_stage_id` int(11) NULL DEFAULT NULL,
  `target_stage_id` int(11) NULL DEFAULT NULL,
  `start_date` date NULL DEFAULT NULL,
  `target_date` date NULL DEFAULT NULL,
  `mentor_id` int(11) NULL DEFAULT NULL COMMENT '关联导师表的 mentor_id，允许 NULL（无导师）。',
  PRIMARY KEY (`plan_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 21 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '员工发展计划表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of employee_development
-- ----------------------------
INSERT INTO `employee_development` VALUES (1, 2001, 1, 1, 3, '2024-01-01', '2026-12-31', 2005);
INSERT INTO `employee_development` VALUES (2, 2002, 2, 1, 3, '2024-03-01', '2026-06-30', 2001);
INSERT INTO `employee_development` VALUES (3, 2003, 3, 1, 2, '2024-05-01', '2025-12-31', 2002);
INSERT INTO `employee_development` VALUES (4, 2004, 4, 1, 2, '2024-07-01', '2025-06-30', 2003);
INSERT INTO `employee_development` VALUES (5, 2005, 5, 1, 3, '2024-09-01', '2026-06-30', 2004);
INSERT INTO `employee_development` VALUES (6, 2006, 6, 1, 2, '2024-11-01', '2025-11-30', 2005);
INSERT INTO `employee_development` VALUES (7, 2007, 7, 1, 3, '2024-02-01', '2026-02-28', 2006);
INSERT INTO `employee_development` VALUES (8, 2008, 8, 1, 2, '2024-04-01', '2025-04-30', 2007);
INSERT INTO `employee_development` VALUES (9, 2009, 9, 1, 3, '2024-06-01', '2026-05-31', 2008);
INSERT INTO `employee_development` VALUES (10, 2010, 10, 1, 2, '2024-08-01', '2025-08-31', 2009);
INSERT INTO `employee_development` VALUES (11, 2011, 1, 2, 4, '2024-10-01', '2027-09-30', 2001);
INSERT INTO `employee_development` VALUES (12, 2012, 2, 2, 4, '2024-12-01', '2027-06-30', 2002);
INSERT INTO `employee_development` VALUES (13, 2013, 3, 2, 3, '2025-01-01', '2026-06-30', 2003);
INSERT INTO `employee_development` VALUES (14, 2014, 4, 2, 3, '2025-02-01', '2026-02-28', 2004);
INSERT INTO `employee_development` VALUES (15, 2015, 5, 2, 4, '2025-03-01', '2027-03-31', 2005);
INSERT INTO `employee_development` VALUES (16, 2016, 6, 2, 3, '2025-04-01', '2026-04-30', 2006);
INSERT INTO `employee_development` VALUES (17, 2017, 7, 2, 4, '2025-05-01', '2027-05-31', 2007);
INSERT INTO `employee_development` VALUES (18, 2018, 8, 2, 3, '2025-06-01', '2026-06-30', 2008);
INSERT INTO `employee_development` VALUES (19, 2019, 9, 2, 4, '2025-07-01', '2027-07-31', 2009);
INSERT INTO `employee_development` VALUES (20, 2020, 10, 2, 3, '2025-08-01', '2026-08-31', 2001);

-- ----------------------------
-- Table structure for forum_reply
-- ----------------------------
DROP TABLE IF EXISTS `forum_reply`;
CREATE TABLE `forum_reply`  (
  `reply_id` int(11) NOT NULL AUTO_INCREMENT,
  `topic_id` int(11) NULL DEFAULT NULL,
  `content` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL,
  `replied_by` int(11) NULL DEFAULT NULL COMMENT '回复者 ID，关联用户表的用户 ID，记录回复人信息。',
  `reply_date` datetime NULL DEFAULT NULL,
  PRIMARY KEY (`reply_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 21 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '讨论回复表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of forum_reply
-- ----------------------------
INSERT INTO `forum_reply` VALUES (1, 101, '感谢分享！我们项目组最近也在优化数据安全流程，想请教下文件加密模块的具体实现方案。', 2001, '2025-01-10 10:30:00');
INSERT INTO `forum_reply` VALUES (2, 101, '可以参考《数据安全管理规定》第5章，我们团队用AES-256加密算法，密钥定期轮换。', 2009, '2025-01-10 14:20:00');
INSERT INTO `forum_reply` VALUES (3, 102, '这个架构设计很清晰！但在高并发场景下，数据库分库分表的策略是否考虑过？', 2002, '2025-01-11 09:15:00');
INSERT INTO `forum_reply` VALUES (4, 102, '确实做了优化，我们按用户ID取模分库，近期会测试分片迁移方案，后续可以同步进展。', 2008, '2025-01-11 16:40:00');
INSERT INTO `forum_reply` VALUES (5, 103, '市场计划里提到的KOL合作，有没有推荐的教育行业KOL资源？', 2003, '2025-01-12 11:30:00');
INSERT INTO `forum_reply` VALUES (6, 103, '可以试试“教育星球”平台，我们合作过3位百万粉丝博主，转化率提升了25%。', 2015, '2025-01-12 15:20:00');
INSERT INTO `forum_reply` VALUES (7, 104, '需求文档里的用户画像很详细，能否补充下B端客户的使用场景？', 2004, '2025-01-13 10:00:00');
INSERT INTO `forum_reply` VALUES (8, 104, '已补充B端客户的3个典型场景，附件是更新后的文档，麻烦查收。', 2014, '2025-01-13 14:50:00');
INSERT INTO `forum_reply` VALUES (9, 105, '报销流程里提到的电子发票上传，系统支持OCR识别吗？', 2005, '2025-01-14 09:45:00');
INSERT INTO `forum_reply` VALUES (10, 105, '目前支持增值税发票OCR，普通发票暂需手动录入，二期会优化这个功能。', 2012, '2025-01-14 16:10:00');
INSERT INTO `forum_reply` VALUES (11, 106, '编码规范里的注释要求很严格，函数注释必须包含所有参数吗？', 2006, '2025-01-15 11:20:00');
INSERT INTO `forum_reply` VALUES (12, 106, '是的，这是为了保证代码可维护性，示例见文档第3章第2节。', 2013, '2025-01-15 15:30:00');
INSERT INTO `forum_reply` VALUES (13, 107, '新员工培训课件里的企业文化部分，能否增加最近的案例？', 2007, '2025-01-16 10:10:00');
INSERT INTO `forum_reply` VALUES (14, 107, '已更新2024年Q4的客户案例，下周培训时会重点讲解。', 2010, '2025-01-16 14:40:00');
INSERT INTO `forum_reply` VALUES (15, 108, '销售数据里的华东区增长异常，是哪个产品线带动的？', 2008, '2025-01-17 09:30:00');
INSERT INTO `forum_reply` VALUES (16, 108, '主要是SaaS产品V2.0上线后，上海地区新增客户数环比增长40%。', 2017, '2025-01-17 16:20:00');
INSERT INTO `forum_reply` VALUES (17, 109, '数据库设计里的索引策略，有没有考虑过复合索引的维护成本？', 2009, '2025-01-18 11:00:00');
INSERT INTO `forum_reply` VALUES (18, 109, '做了权衡，核心查询场景的复合索引收益大于维护成本，详见附件分析报告。', 2019, '2025-01-18 15:50:00');
INSERT INTO `forum_reply` VALUES (19, 110, '绩效考核方案里的360度评估，具体怎么实施？', 2010, '2025-01-19 10:20:00');
INSERT INTO `forum_reply` VALUES (20, 110, '下周会发实施细则，包括自评、上级评、同事评的权重分配和时间节点。', 2006, '2025-01-19 14:30:00');

-- ----------------------------
-- Table structure for forum_topic
-- ----------------------------
DROP TABLE IF EXISTS `forum_topic`;
CREATE TABLE `forum_topic`  (
  `topic_id` int(11) NOT NULL AUTO_INCREMENT,
  `forum_id` int(11) NULL DEFAULT NULL,
  `title` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL,
  `content` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL,
  `created_by` int(11) NULL DEFAULT NULL,
  `create_date` datetime NULL DEFAULT NULL,
  PRIMARY KEY (`topic_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 21 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of forum_topic
-- ----------------------------
INSERT INTO `forum_topic` VALUES (1, 1, 'Python并发编程：多线程与协程对比', '深入分析threading模块与asyncio的性能差异，附IO密集型任务实战案例', 1001, '2024-01-10 14:30:00');
INSERT INTO `forum_topic` VALUES (2, 1, 'Java设计模式：工厂模式最佳实践', '讲解简单工厂、工厂方法和抽象工厂的适用场景，附Spring框架源码案例', 1002, '2024-02-15 09:10:22');
INSERT INTO `forum_topic` VALUES (3, 1, 'Go语言性能优化：内存分配策略', '分析Go的垃圾回收机制与对象池设计，推荐sync.Pool的使用场景', 1001, '2024-03-20 16:45:11');
INSERT INTO `forum_topic` VALUES (4, 2, 'React Hooks性能优化：useMemo与useCallback', '详解依赖数组优化技巧，避免组件重复渲染问题', 1003, '2024-04-05 10:20:33');
INSERT INTO `forum_topic` VALUES (5, 2, 'Vue3组合式API：状态管理最佳实践', '对比setup与composition API的状态组织方式，推荐Pinia替代Vuex', 1004, '2024-05-12 15:30:47');
INSERT INTO `forum_topic` VALUES (6, 2, 'WebAssembly：前端性能革命实践', '介绍WASM在图像处理场景的应用，对比JavaScript执行效率', 1003, '2024-06-08 09:15:22');
INSERT INTO `forum_topic` VALUES (7, 3, 'MySQL索引失效场景与解决方案', '列举10种常见索引失效情况，如函数计算、类型转换等', 1005, '2024-07-15 14:40:11');
INSERT INTO `forum_topic` VALUES (8, 3, 'PostgreSQL全文检索：TSVECTOR实战', '演示如何利用GIN索引实现百万级文本数据的毫秒级检索', 1006, '2024-08-22 11:25:33');
INSERT INTO `forum_topic` VALUES (9, 3, 'Redis缓存架构：分布式锁实现方案', '对比Redlock算法与单节点锁的可靠性，附Lua脚本原子性案例', 1005, '2024-09-10 16:30:05');
INSERT INTO `forum_topic` VALUES (10, 4, 'Kubernetes资源调度：Pod亲和性配置', '详解nodeAffinity与podAffinity的调度策略，避免服务扎堆部署', 1007, '2024-10-05 09:50:22');
INSERT INTO `forum_topic` VALUES (11, 4, 'Docker容器网络：Overlay与Bridge对比', '分析两种网络模式的通信原理，推荐微服务场景的网络配置', 1008, '2024-11-18 14:15:36');
INSERT INTO `forum_topic` VALUES (12, 4, 'Serverless架构：成本优化实践指南', '分享AWS Lambda的预留并发与冷启动优化技巧，降低云服务成本', 1007, '2024-12-03 16:20:11');
INSERT INTO `forum_topic` VALUES (13, 5, 'Transformer架构：自注意力机制详解', '从数学原理到代码实现，解析Multi-Headed Attention的工作流程', 1009, '2025-01-10 10:30:45');
INSERT INTO `forum_topic` VALUES (14, 5, 'PyTorch模型部署：ONNX格式转换实战', '演示如何将训练好的模型转换为ONNX并在C++环境中推理', 1010, '2025-02-22 14:15:22');
INSERT INTO `forum_topic` VALUES (15, 5, '计算机视觉：YOLOv8实时检测优化', '分享模型剪枝、量化与TensorRT加速的组合方案，实现边缘设备部署', 1009, '2025-03-08 09:40:33');
INSERT INTO `forum_topic` VALUES (16, 6, '自动化测试：Postman接口测试框架搭建', '介绍如何用Newman实现接口自动化，结合Jenkins构建CI流程', 1011, '2025-04-15 16:30:11');
INSERT INTO `forum_topic` VALUES (17, 6, 'Prometheus监控：自定义指标采集方案', '讲解如何通过Exporter获取业务指标，配置Grafana告警规则', 1012, '2025-05-20 10:25:47');
INSERT INTO `forum_topic` VALUES (18, 6, '混沌工程：微服务容错性测试实践', '利用Chaos Mesh模拟网络分区与服务故障，验证熔断机制', 1011, '2025-06-05 14:10:22');
INSERT INTO `forum_topic` VALUES (19, 7, '用户体验设计：移动端表单优化指南', '分析10种表单交互反模式，推荐分步表单与实时验证方案', 1013, '2025-06-10 09:30:33');
INSERT INTO `forum_topic` VALUES (20, 7, '敏捷开发：Scrum与Kanban融合实践', '分享如何结合两种方法论优化迭代流程，提升团队交付效率', 1014, '2025-06-18 16:45:11');

-- ----------------------------
-- Table structure for hr_rules
-- ----------------------------
DROP TABLE IF EXISTS `hr_rules`;
CREATE TABLE `hr_rules`  (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `keyword` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '匹配关键词',
  `question` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '标准问题',
  `answer` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '标准规章制度解答',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 5 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of hr_rules
-- ----------------------------
INSERT INTO `hr_rules` VALUES (1, '请假', '公司请假流程是什么？', '正式员工请假需提前在系统发起申请。病假需提供三甲医院证明；事假需提前3天申请并由部门经理和HRBP审批；年假需提前1周申请。超过5天假期需报总经理审批。');
INSERT INTO `hr_rules` VALUES (2, '加班', '加班费和调休怎么计算？', '公司实行标准工时。工作日加班按1.5倍薪资计算；周末加班优先安排调休，无法调休的按2倍薪资计算；法定节假日加班按3倍薪资计算。所有加班必须在系统提交加班申请并由主管审批通过方可生效。');
INSERT INTO `hr_rules` VALUES (3, '福利', '公司的员工福利有哪些？', '公司为员工提供全额缴纳五险一金、年度免费体检、节日慰问金、生日礼品、下午茶、弹性工作制以及带薪年假。此外，工作满1年的员工提供额外商业医疗保险。');
INSERT INTO `hr_rules` VALUES (4, '离职', '员工离职流程及提前期规定？', '正式员工离职需提前30天向部门主管提交书面申请；试用期员工需提前3天申请。申请批准后，需按照《离职交接单》依次办理工作交接、资产归还（电脑、工牌等）以及社保公积金转移。');

-- ----------------------------
-- Table structure for interview
-- ----------------------------
DROP TABLE IF EXISTS `interview`;
CREATE TABLE `interview`  (
  `interview_id` int(11) NOT NULL AUTO_INCREMENT,
  `candidate_id` int(11) NULL DEFAULT NULL,
  `posting_id` int(11) NULL DEFAULT NULL,
  `interview_date` datetime NULL DEFAULT NULL,
  `interviewer_id` int(11) NULL DEFAULT NULL,
  `score` decimal(5, 2) NULL DEFAULT NULL,
  `result` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL,
  PRIMARY KEY (`interview_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 21 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '面试表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of interview
-- ----------------------------
INSERT INTO `interview` VALUES (1, 1, 3001, '2025-03-10 00:00:00', 2001, 85.00, '通过');
INSERT INTO `interview` VALUES (2, 2, 3002, '2025-03-11 00:00:00', 2002, 92.00, '通过');
INSERT INTO `interview` VALUES (3, 3, 3003, '2025-03-12 00:00:00', 2003, 78.00, '待定');
INSERT INTO `interview` VALUES (4, 4, 3004, '2025-03-13 00:00:00', 2004, 88.00, '通过');
INSERT INTO `interview` VALUES (5, 5, 3005, '2025-03-14 00:00:00', 2005, 72.00, '未通过');
INSERT INTO `interview` VALUES (6, 6, 3001, '2025-03-15 00:00:00', 2001, 81.00, '通过');
INSERT INTO `interview` VALUES (7, 7, 3002, '2025-03-16 00:00:00', 2002, 76.00, '待定');
INSERT INTO `interview` VALUES (8, 8, 3003, '2025-03-17 00:00:00', 2003, 89.00, '通过');
INSERT INTO `interview` VALUES (9, 9, 3004, '2025-03-18 00:00:00', 2004, 68.00, '未通过');
INSERT INTO `interview` VALUES (10, 10, 3005, '2025-03-19 00:00:00', 2005, 83.00, '通过');
INSERT INTO `interview` VALUES (11, 11, 3001, '2025-03-20 00:00:00', 2001, 79.00, '待定');
INSERT INTO `interview` VALUES (12, 12, 3002, '2025-03-21 00:00:00', 2002, 87.00, '通过');
INSERT INTO `interview` VALUES (13, 13, 3003, '2025-03-22 00:00:00', 2003, 75.00, '待定');
INSERT INTO `interview` VALUES (14, 14, 3004, '2025-03-23 00:00:00', 2004, 91.00, '通过');
INSERT INTO `interview` VALUES (15, 15, 3005, '2025-03-24 00:00:00', 2005, 65.00, '未通过');
INSERT INTO `interview` VALUES (16, 16, 3001, '2025-03-25 00:00:00', 2001, 84.00, '通过');
INSERT INTO `interview` VALUES (17, 17, 3002, '2025-03-26 00:00:00', 2002, 77.00, '待定');
INSERT INTO `interview` VALUES (18, 18, 3003, '2025-03-27 00:00:00', 2003, 86.00, '通过');
INSERT INTO `interview` VALUES (19, 19, 3004, '2025-03-28 00:00:00', 2004, 71.00, '未通过');
INSERT INTO `interview` VALUES (20, 20, 3005, '2025-03-29 00:00:00', 2005, 82.00, '通过');

-- ----------------------------
-- Table structure for job_posting
-- ----------------------------
DROP TABLE IF EXISTS `job_posting`;
CREATE TABLE `job_posting`  (
  `posting_id` int(11) NOT NULL AUTO_INCREMENT,
  `position_id` int(11) NULL DEFAULT NULL,
  `department_id` int(11) NULL DEFAULT NULL,
  `requirements` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL,
  `salary_range` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL,
  `headcount` int(11) NULL DEFAULT NULL,
  `publish_date` date NULL DEFAULT NULL,
  `deadline` date NULL DEFAULT NULL,
  PRIMARY KEY (`posting_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 3021 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '职位发布表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of job_posting
-- ----------------------------
INSERT INTO `job_posting` VALUES (3001, 5001, 101, '大专及以上学历，4年以上豆包使用经验，与人工智能交流顺畅', '1m-100m', 2, '2025-02-01', '2025-03-31');
INSERT INTO `job_posting` VALUES (3002, 5002, 102, '硕士及以上学历，3年以上产品经理经验，具备ToB产品设计能力', '22k-30k', 1, '2025-02-05', '2025-04-15');
INSERT INTO `job_posting` VALUES (3003, 5003, 103, '本科及以上学历，4年以上市场策划经验，熟悉数字化营销工具', '18k-25k', 3, '2025-02-10', '2025-04-30');
INSERT INTO `job_posting` VALUES (3004, 5004, 104, '本科及以上学历，5年以上销售经验，有SaaS行业客户资源', '15k-28k', 4, '2025-02-15', '2025-05-15');
INSERT INTO `job_posting` VALUES (3005, 5005, 105, '本科及以上学历，6年以上财务经验，持有CPA证书', '20k-28k', 1, '2025-02-20', '2025-05-31');
INSERT INTO `job_posting` VALUES (3006, 5006, 106, '本科及以上学历，3年以上招聘经验，熟悉互联网行业人才结构', '16k-22k', 2, '2025-02-25', '2025-06-15');
INSERT INTO `job_posting` VALUES (3007, 5007, 107, '大专及以上学历，5年以上行政经验，具备大型活动组织能力', '12k-18k', 1, '2025-03-01', '2025-06-30');
INSERT INTO `job_posting` VALUES (3008, 5008, 108, '本科及以上学历，2年以上前端开发经验，精通Vue3框架', '18k-25k', 3, '2025-03-05', '2025-07-15');
INSERT INTO `job_posting` VALUES (3009, 5009, 109, '本科及以上学历，4年以上测试经验，熟悉自动化测试工具', '17k-24k', 2, '2025-03-10', '2025-07-31');
INSERT INTO `job_posting` VALUES (3010, 5010, 110, '硕士及以上学历，2年以上数据分析师经验，熟练使用SQL和Python', '20k-28k', 1, '2025-03-15', '2025-08-15');
INSERT INTO `job_posting` VALUES (3011, 5011, 111, '本科及以上学历，3年以上运营经验，有用户增长成功案例', '16k-23k', 3, '2025-03-20', '2025-08-31');
INSERT INTO `job_posting` VALUES (3012, 5012, 112, '本科及以上学历，5年以上UI设计经验，精通Figma和Adobe套件', '19k-26k', 2, '2025-03-25', '2025-09-15');
INSERT INTO `job_posting` VALUES (3013, 5013, 113, '本科及以上学历，4年以上供应链管理经验，熟悉ERP系统', '17k-24k', 1, '2025-04-01', '2025-09-30');
INSERT INTO `job_posting` VALUES (3014, 5014, 114, '本科及以上学历，3年以上客服管理经验，具备跨部门协调能力', '15k-22k', 3, '2025-04-05', '2025-10-15');
INSERT INTO `job_posting` VALUES (3015, 5015, 115, '本科及以上学历，5年以上品牌公关经验，有危机公关处理案例', '22k-30k', 1, '2025-04-10', '2025-10-31');
INSERT INTO `job_posting` VALUES (3016, 5016, 116, '本科及以上学历，2年以上跨境电商经验，熟悉进出口流程', '18k-25k', 2, '2025-04-15', '2025-11-15');
INSERT INTO `job_posting` VALUES (3017, 5017, 117, '本科及以上学历，4年以上项目管理经验，持有PMP证书', '21k-29k', 3, '2025-04-20', '2025-11-30');
INSERT INTO `job_posting` VALUES (3018, 5018, 118, '本科及以上学历，3年以上法务经验，熟悉互联网行业法律法规', '19k-26k', 1, '2025-04-25', '2025-12-15');
INSERT INTO `job_posting` VALUES (3019, 5019, 119, '本科及以上学历，5年以上运维经验，精通云计算和容器技术', '20k-28k', 2, '2025-05-01', '2025-12-31');
INSERT INTO `job_posting` VALUES (3020, 5020, 120, '本科及以上学历，3年以上培训经验，能独立设计课程体系', '16k-23k', 1, '2025-05-05', '2026-01-15');

-- ----------------------------
-- Table structure for kb_category
-- ----------------------------
DROP TABLE IF EXISTS `kb_category`;
CREATE TABLE `kb_category`  (
  `category_id` int(11) NOT NULL AUTO_INCREMENT,
  `category_name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL,
  `parent_id` int(11) NULL DEFAULT NULL,
  `description` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL,
  PRIMARY KEY (`category_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 21 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '知识库分类表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of kb_category
-- ----------------------------
INSERT INTO `kb_category` VALUES (1, '技术开发', NULL, '软件开发、架构设计及技术框架相关知识');
INSERT INTO `kb_category` VALUES (2, '产品管理', NULL, '产品设计、需求分析及运营相关知识');
INSERT INTO `kb_category` VALUES (3, '市场营销', NULL, '品牌推广、活动策划及渠道管理相关知识');
INSERT INTO `kb_category` VALUES (4, '人力资源', NULL, '招聘、培训及绩效考核相关知识');
INSERT INTO `kb_category` VALUES (5, '财务管理', NULL, '预算编制、税务处理及财务分析相关知识');
INSERT INTO `kb_category` VALUES (6, '行政后勤', NULL, '办公管理、采购流程及固定资产相关知识');
INSERT INTO `kb_category` VALUES (7, '销售业务', NULL, '客户开发、谈判技巧及合同管理相关知识');
INSERT INTO `kb_category` VALUES (8, '设计创意', NULL, 'UI/UX设计、视觉传达及品牌设计相关知识');
INSERT INTO `kb_category` VALUES (9, '数据科学', NULL, '数据分析、算法模型及数据可视化相关知识');
INSERT INTO `kb_category` VALUES (10, '合规风控', NULL, '法律合规、风险控制及内部审计相关知识');
INSERT INTO `kb_category` VALUES (11, '技术框架', 1, '各类开发框架的使用文档及最佳实践');
INSERT INTO `kb_category` VALUES (12, '数据库技术', 1, '数据库设计、优化及运维相关知识');
INSERT INTO `kb_category` VALUES (13, '云原生技术', 1, '容器化、微服务及DevOps相关知识');
INSERT INTO `kb_category` VALUES (14, '产品设计', 2, '原型设计、用户体验及交互逻辑相关知识');
INSERT INTO `kb_category` VALUES (15, '需求管理', 2, '需求收集、分析及优先级评估相关知识');
INSERT INTO `kb_category` VALUES (16, '市场调研', 3, '竞品分析、用户画像及行业趋势相关知识');
INSERT INTO `kb_category` VALUES (17, '数字营销', 3, 'SEO/SEM、社交媒体及广告投放相关知识');
INSERT INTO `kb_category` VALUES (18, '招聘流程', 4, '岗位JD设计、面试评估及入职管理相关知识');
INSERT INTO `kb_category` VALUES (19, '薪酬福利', 4, '薪资体系、福利政策及绩效考核相关知识');
INSERT INTO `kb_category` VALUES (20, '财务报表', 5, '资产负债表、利润表及现金流量表分析知识');

-- ----------------------------
-- Table structure for kb_feedback
-- ----------------------------
DROP TABLE IF EXISTS `kb_feedback`;
CREATE TABLE `kb_feedback`  (
  `feedback_id` int(11) NOT NULL AUTO_INCREMENT,
  `kb_id` int(11) NULL DEFAULT NULL,
  `employee_id` int(11) NULL DEFAULT NULL,
  `rating` tinyint(4) NULL DEFAULT NULL,
  `comment` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL,
  `feedback_date` datetime NULL DEFAULT NULL,
  PRIMARY KEY (`feedback_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 21 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '知识库反馈表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of kb_feedback
-- ----------------------------
INSERT INTO `kb_feedback` VALUES (1, 1001, 2001, 4, '内容很全面，但云原生部分建议补充Kubernetes的实战案例', '2025-01-10 14:30:00');
INSERT INTO `kb_feedback` VALUES (2, 1002, 2002, 5, '需求管理的流程图示非常清晰，已收藏作为团队参考', '2025-01-11 10:15:00');
INSERT INTO `kb_feedback` VALUES (3, 1003, 2003, 3, '市场调研的方法论部分稍显理论化，希望增加行业案例', '2025-01-12 16:40:00');
INSERT INTO `kb_feedback` VALUES (4, 1004, 2004, 4, '招聘流程文档中的面试评估表很实用，已下载使用', '2025-01-13 09:30:00');
INSERT INTO `kb_feedback` VALUES (5, 1005, 2005, 5, '财务报表分析的公式推导很详细，对新人非常友好', '2025-01-14 15:20:00');
INSERT INTO `kb_feedback` VALUES (6, 1006, 2006, 3, '行政采购流程中缺少供应商评估标准，建议补充', '2025-01-15 11:50:00');
INSERT INTO `kb_feedback` VALUES (7, 1007, 2007, 4, '销售谈判技巧的情景模拟部分很有帮助，期待更新更多场景', '2025-01-16 14:20:00');
INSERT INTO `kb_feedback` VALUES (8, 1008, 2008, 5, 'UI设计规范中的颜色体系讲解非常专业，已应用到项目中', '2025-01-17 10:00:00');
INSERT INTO `kb_feedback` VALUES (9, 1009, 2009, 4, '数据分析的SQL案例可以增加复杂查询场景，提升实用性', '2025-01-18 16:30:00');
INSERT INTO `kb_feedback` VALUES (10, 1010, 2010, 3, '合规政策文档中的法律条款可以增加解读说明', '2025-01-19 09:45:00');
INSERT INTO `kb_feedback` VALUES (11, 1011, 2011, 4, '技术框架章节的版本兼容性说明很及时，解决了项目问题', '2025-01-20 14:10:00');
INSERT INTO `kb_feedback` VALUES (12, 1012, 2012, 5, '数据库优化的索引分析案例非常典型，已分享给团队', '2025-01-21 11:30:00');
INSERT INTO `kb_feedback` VALUES (13, 1013, 2013, 3, 'DevOps流程中的自动化测试环节可以补充工具选型建议', '2025-01-22 16:50:00');
INSERT INTO `kb_feedback` VALUES (14, 1014, 2014, 4, '产品原型设计的Figma教程很详细，适合新手入门', '2025-01-23 10:20:00');
INSERT INTO `kb_feedback` VALUES (15, 1015, 2015, 5, '数字营销的SEO策略讲解透彻，实施后网站流量提升20%', '2025-01-24 15:40:00');
INSERT INTO `kb_feedback` VALUES (16, 1016, 2016, 3, '薪酬体系文档中缺少绩效奖金计算示例，建议补充', '2025-01-25 11:10:00');
INSERT INTO `kb_feedback` VALUES (17, 1017, 2017, 4, '销售合同模板的风险条款标注清晰，降低了法律隐患', '2025-01-26 14:30:00');
INSERT INTO `kb_feedback` VALUES (18, 1018, 2018, 5, '数据可视化的Tableau案例很有参考价值，已应用于报表设计', '2025-01-27 10:50:00');
INSERT INTO `kb_feedback` VALUES (19, 1019, 2019, 4, '合规风险评估的流程图表可以增加各环节负责人说明', '2025-01-28 16:10:00');
INSERT INTO `kb_feedback` VALUES (20, 1020, 2020, 3, '行政固定资产管理的盘点流程可以增加系统操作截图', '2025-01-29 09:30:00');

-- ----------------------------
-- Table structure for knowledge_base
-- ----------------------------
DROP TABLE IF EXISTS `knowledge_base`;
CREATE TABLE `knowledge_base`  (
  `kb_id` int(11) NOT NULL AUTO_INCREMENT,
  `title` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL,
  `content` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL,
  `category_id` int(11) NULL DEFAULT NULL,
  `created_by` int(11) NULL DEFAULT NULL,
  `created_date` datetime NULL DEFAULT NULL,
  `last_updated` datetime NULL DEFAULT NULL,
  PRIMARY KEY (`kb_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1021 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '知识库条目表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of knowledge_base
-- ----------------------------
INSERT INTO `knowledge_base` VALUES (1001, 'Kubernetes实战指南', '本指南涵盖Kubernetes集群搭建、服务部署及故障排查，包含10+实战案例...', 13, 2001, '2026-01-15 00:00:00', '2027-01-10 00:00:00');
INSERT INTO `knowledge_base` VALUES (1002, '产品需求管理流程', '详细阐述需求收集、分析、评审及跟踪的全流程，附流程图和模板...', 15, 2002, '2026-01-15 00:00:00', '2027-01-10 00:00:00');
INSERT INTO `knowledge_base` VALUES (1003, '市场调研方法论', '介绍PEST分析、SWOT分析等常用方法，附行业调研报告模板...', 16, 2003, '2026-01-15 00:00:00', '2027-01-10 00:00:00');
INSERT INTO `knowledge_base` VALUES (1004, '招聘全流程手册', '从岗位JD设计到入职管理的全流程指南，附面试评估表模板...', 18, 2006, '2026-01-15 00:00:00', '2027-01-10 00:00:00');
INSERT INTO `knowledge_base` VALUES (1005, '财务报表分析手册', '详解资产负债表、利润表分析方法，附上市公司案例拆解...', 20, 2005, '2026-01-15 00:00:00', '2027-01-10 00:00:00');
INSERT INTO `knowledge_base` VALUES (1006, '行政采购管理规范', '规定供应商筛选、采购流程及验收标准，附合同模板...', 6, 2007, '2026-01-15 00:00:00', '2027-01-10 00:00:00');
INSERT INTO `knowledge_base` VALUES (1007, '销售谈判技巧指南', '总结10类客户谈判策略，附情景模拟和话术模板...', 7, 2017, '2026-01-15 00:00:00', '2027-01-10 00:00:00');
INSERT INTO `knowledge_base` VALUES (1008, 'UI设计规范手册', '包含颜色体系、字体规范及组件设计标准，附Figma资源...', 8, 2012, '2026-01-15 00:00:00', '2027-01-10 00:00:00');
INSERT INTO `knowledge_base` VALUES (1009, '数据分析实战案例', '通过5个业务场景讲解SQL分析和数据可视化方法...', 9, 2013, '2026-01-15 00:00:00', '2027-01-10 00:00:00');
INSERT INTO `knowledge_base` VALUES (1010, '企业合规政策汇编', '整理数据安全、反商业贿赂等合规要求及法律条款...', 10, 2018, '2026-01-15 00:00:00', '2027-01-10 00:00:00');
INSERT INTO `knowledge_base` VALUES (1011, 'Spring Cloud框架指南', '介绍微服务架构组件使用方法，附项目搭建步骤...', 11, 2009, '2026-01-15 00:00:00', '2027-01-10 00:00:00');
INSERT INTO `knowledge_base` VALUES (1012, 'MySQL性能优化手册', '涵盖索引设计、查询优化及服务器配置调优策略...', 12, 2019, '2026-01-15 00:00:00', '2027-01-10 00:00:00');
INSERT INTO `knowledge_base` VALUES (1013, 'DevOps实施指南', '详解持续集成、持续部署流程及工具链选型...', 13, 2001, '2026-01-15 00:00:00', '2027-01-10 00:00:00');
INSERT INTO `knowledge_base` VALUES (1014, '产品原型设计教程', '基于Figma的原型设计全流程，附交互组件库...', 14, 2002, '2026-01-15 00:00:00', '2027-01-10 00:00:00');
INSERT INTO `knowledge_base` VALUES (1015, '数字营销白皮书', '解析SEO、SEM及社交媒体营销的策略与案例...', 17, 2003, '2026-01-15 00:00:00', '2027-01-10 00:00:00');
INSERT INTO `knowledge_base` VALUES (1016, '薪酬福利体系设计', '介绍薪资结构、绩效考核及福利政策设计方法...', 19, 2006, '2026-01-15 00:00:00', '2027-01-10 00:00:00');
INSERT INTO `knowledge_base` VALUES (1017, '销售合同模板集', '包含10类业务场景的合同模板及风险条款说明...', 7, 2017, '2026-01-15 00:00:00', '2027-01-10 00:00:00');
INSERT INTO `knowledge_base` VALUES (1018, '数据可视化指南', '基于Tableau的报表设计原则及行业案例...', 9, 2013, '2026-01-15 00:00:00', '2027-01-10 00:00:00');
INSERT INTO `knowledge_base` VALUES (1019, '合规风险评估流程', '企业合规风险识别、评估及应对策略指南...', 10, 2018, '2026-01-15 00:00:00', '2027-01-10 00:00:00');
INSERT INTO `knowledge_base` VALUES (1020, '固定资产管理规范', '行政固定资产采购、登记及盘点全流程说明...', 6, 2007, '2026-01-15 00:00:00', '2027-01-10 00:00:00');

-- ----------------------------
-- Table structure for leave_record
-- ----------------------------
DROP TABLE IF EXISTS `leave_record`;
CREATE TABLE `leave_record`  (
  `record_id` int(11) NOT NULL AUTO_INCREMENT,
  `employee_id` int(11) NULL DEFAULT NULL,
  `leave_type` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL,
  `start_date` date NULL DEFAULT NULL,
  `end_date` date NULL DEFAULT NULL,
  `duration` decimal(5, 2) NULL DEFAULT NULL,
  `reason` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL,
  `approver_id` int(11) NULL DEFAULT NULL,
  PRIMARY KEY (`record_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 21 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '请假记录表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of leave_record
-- ----------------------------
INSERT INTO `leave_record` VALUES (1, 1001, '年假', '2025-01-05', '2025-01-07', 3.00, '回老家探亲', 2001);
INSERT INTO `leave_record` VALUES (2, 1002, '病假', '2025-01-10', '2025-01-12', 2.00, '感冒发烧', 2002);
INSERT INTO `leave_record` VALUES (3, 1003, '事假', '2025-01-15', '2025-01-16', 1.50, '处理家庭事务', 2003);
INSERT INTO `leave_record` VALUES (4, 1001, '年假', '2025-02-01', '2025-02-05', 5.00, '出国旅游', 2001);
INSERT INTO `leave_record` VALUES (5, 1004, '婚假', '2025-02-10', '2025-02-17', 8.00, '结婚休假', 2004);
INSERT INTO `leave_record` VALUES (6, 1005, '产假', '2025-03-01', '2025-05-31', 92.00, '生育休假', 2005);
INSERT INTO `leave_record` VALUES (7, 1002, '病假', '2025-03-15', '2025-03-18', 3.00, '肠胃炎', 2002);
INSERT INTO `leave_record` VALUES (8, 1006, '事假', '2025-04-01', '2025-04-03', 2.50, '参加培训课程', 2006);
INSERT INTO `leave_record` VALUES (9, 1007, '年假', '2025-04-10', '2025-04-14', 4.00, '休息调整', 2007);
INSERT INTO `leave_record` VALUES (10, 1008, '病假', '2025-04-20', '2025-04-22', 2.00, '骨折恢复', 2008);
INSERT INTO `leave_record` VALUES (11, 1003, '事假', '2025-05-01', '2025-05-03', 2.50, '办理证件', 2003);
INSERT INTO `leave_record` VALUES (12, 1009, '年假', '2025-05-10', '2025-05-16', 5.50, '家庭旅行', 2009);
INSERT INTO `leave_record` VALUES (13, 1010, '病假', '2025-05-20', '2025-05-25', 4.50, '住院手术', 2010);
INSERT INTO `leave_record` VALUES (14, 1004, '事假', '2025-06-01', '2025-06-02', 1.00, '参加婚礼', 2004);
INSERT INTO `leave_record` VALUES (15, 1011, '年假', '2025-06-05', '2025-06-09', 4.00, '放松身心', 2011);
INSERT INTO `leave_record` VALUES (16, 1012, '病假', '2025-06-10', '2025-06-12', 2.00, '流感', 2012);
INSERT INTO `leave_record` VALUES (17, 1005, '事假', '2025-06-15', '2025-06-18', 3.00, '照顾家人', 2005);
INSERT INTO `leave_record` VALUES (18, 1013, '年假', '2025-07-01', '2025-07-05', 5.00, '度假', 2013);
INSERT INTO `leave_record` VALUES (19, 1014, '病假', '2025-07-10', '2025-07-12', 2.00, '牙科手术', 2014);
INSERT INTO `leave_record` VALUES (20, 1006, '事假', '2025-07-15', '2025-07-16', 1.00, '个人事务', 2006);

-- ----------------------------
-- Table structure for offer
-- ----------------------------
DROP TABLE IF EXISTS `offer`;
CREATE TABLE `offer`  (
  `offer_id` int(11) NOT NULL AUTO_INCREMENT,
  `candidate_id` int(11) NULL DEFAULT NULL,
  `posting_id` int(11) NULL DEFAULT NULL,
  `position_id` int(11) NULL DEFAULT NULL,
  `salary` decimal(10, 2) NULL DEFAULT NULL,
  `offer_date` date NULL DEFAULT NULL,
  PRIMARY KEY (`offer_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 21 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = 'Offer表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of offer
-- ----------------------------
INSERT INTO `offer` VALUES (1, 1001, 2001, 3001, 12000.00, '2025-01-05');
INSERT INTO `offer` VALUES (2, 1002, 2002, 3002, 9500.00, '2025-01-10');
INSERT INTO `offer` VALUES (3, 1003, 2003, 3003, 15000.00, '2025-01-15');
INSERT INTO `offer` VALUES (4, 1004, 2004, 3004, 11000.00, '2025-01-20');
INSERT INTO `offer` VALUES (5, 1005, 2005, 3005, 8500.00, '2025-01-25');
INSERT INTO `offer` VALUES (6, 1006, 2006, 3006, 13500.00, '2025-02-01');
INSERT INTO `offer` VALUES (7, 1007, 2007, 3007, 10500.00, '2025-02-05');
INSERT INTO `offer` VALUES (8, 1008, 2008, 3008, 14000.00, '2025-02-10');
INSERT INTO `offer` VALUES (9, 1009, 2009, 3009, 9800.00, '2025-02-15');
INSERT INTO `offer` VALUES (10, 1010, 2010, 3010, 12500.00, '2025-02-20');
INSERT INTO `offer` VALUES (11, 1011, 2011, 3011, 11500.00, '2025-03-01');
INSERT INTO `offer` VALUES (12, 1012, 2012, 3012, 13000.00, '2025-03-05');
INSERT INTO `offer` VALUES (13, 1013, 2013, 3013, 8800.00, '2025-03-10');
INSERT INTO `offer` VALUES (14, 1014, 2014, 3014, 14500.00, '2025-03-15');
INSERT INTO `offer` VALUES (15, 1015, 2015, 3015, 10200.00, '2025-03-20');
INSERT INTO `offer` VALUES (16, 1016, 2016, 3016, 12200.00, '2025-04-01');
INSERT INTO `offer` VALUES (17, 1017, 2017, 3017, 9200.00, '2025-04-05');
INSERT INTO `offer` VALUES (18, 1018, 2018, 3018, 13200.00, '2025-04-10');
INSERT INTO `offer` VALUES (19, 1019, 2019, 3019, 11200.00, '2025-04-15');
INSERT INTO `offer` VALUES (20, 1020, 2020, 3020, 10800.00, '2025-04-20');

-- ----------------------------
-- Table structure for overtime_record
-- ----------------------------
DROP TABLE IF EXISTS `overtime_record`;
CREATE TABLE `overtime_record`  (
  `record_id` int(11) NOT NULL AUTO_INCREMENT,
  `employee_id` int(11) NULL DEFAULT NULL,
  `date` date NULL DEFAULT NULL,
  `start_time` time NULL DEFAULT NULL,
  `end_time` time NULL DEFAULT NULL,
  `duration` decimal(5, 2) NULL DEFAULT NULL,
  `approver_id` int(11) NULL DEFAULT NULL,
  PRIMARY KEY (`record_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 21 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '加班记录表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of overtime_record
-- ----------------------------
INSERT INTO `overtime_record` VALUES (1, 1001, '2025-01-10', '18:30:00', '21:30:00', 3.00, 2001);
INSERT INTO `overtime_record` VALUES (2, 1002, '2025-01-12', '19:00:00', '22:00:00', 3.00, 2002);
INSERT INTO `overtime_record` VALUES (3, 1003, '2025-01-15', '18:00:00', '20:30:00', 2.50, 2003);
INSERT INTO `overtime_record` VALUES (4, 1001, '2025-01-20', '19:30:00', '23:00:00', 3.50, 2001);
INSERT INTO `overtime_record` VALUES (5, 1004, '2025-01-22', '18:00:00', '21:00:00', 3.00, 2004);
INSERT INTO `overtime_record` VALUES (6, 1005, '2025-01-25', '19:00:00', '22:30:00', 3.50, 2005);
INSERT INTO `overtime_record` VALUES (7, 1002, '2025-02-01', '18:30:00', '21:00:00', 2.50, 2002);
INSERT INTO `overtime_record` VALUES (8, 1006, '2025-02-03', '19:00:00', '23:30:00', 4.50, 2006);
INSERT INTO `overtime_record` VALUES (9, 1007, '2025-02-05', '18:00:00', '20:00:00', 2.00, 2007);
INSERT INTO `overtime_record` VALUES (10, 1008, '2025-02-07', '19:30:00', '22:30:00', 3.00, 2008);
INSERT INTO `overtime_record` VALUES (11, 1003, '2025-02-10', '18:00:00', '21:30:00', 3.50, 2003);
INSERT INTO `overtime_record` VALUES (12, 1009, '2025-02-12', '19:00:00', '22:00:00', 3.00, 2009);
INSERT INTO `overtime_record` VALUES (13, 1010, '2025-02-15', '18:30:00', '20:30:00', 2.00, 2010);
INSERT INTO `overtime_record` VALUES (14, 1004, '2025-02-17', '19:00:00', '23:00:00', 4.00, 2004);
INSERT INTO `overtime_record` VALUES (15, 1011, '2025-02-20', '18:00:00', '21:00:00', 3.00, 2011);
INSERT INTO `overtime_record` VALUES (16, 1012, '2025-02-22', '19:30:00', '22:30:00', 3.00, 2012);
INSERT INTO `overtime_record` VALUES (17, 1005, '2025-02-25', '18:00:00', '21:30:00', 3.50, 2005);
INSERT INTO `overtime_record` VALUES (18, 1013, '2025-03-01', '19:00:00', '23:00:00', 4.00, 2013);
INSERT INTO `overtime_record` VALUES (19, 1014, '2025-03-03', '18:30:00', '20:30:00', 2.00, 2014);
INSERT INTO `overtime_record` VALUES (20, 1006, '2025-03-05', '19:00:00', '22:30:00', 3.50, 2006);

-- ----------------------------
-- Table structure for performance_evaluation
-- ----------------------------
DROP TABLE IF EXISTS `performance_evaluation`;
CREATE TABLE `performance_evaluation`  (
  `evaluation_id` int(11) NOT NULL AUTO_INCREMENT,
  `employee_id` int(11) NULL DEFAULT NULL,
  `evaluator_id` int(11) NULL DEFAULT NULL,
  `start_date` datetime NULL DEFAULT NULL,
  `end_date` datetime NULL DEFAULT NULL,
  `score` decimal(5, 2) NULL DEFAULT NULL,
  `level` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL,
  `comments` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL,
  PRIMARY KEY (`evaluation_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 21 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '员工评估表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of performance_evaluation
-- ----------------------------
INSERT INTO `performance_evaluation` VALUES (1, 1001, 2001, '2025-01-01 00:00:00', '2025-03-31 00:00:00', 92.00, '优秀', '工作效率高，项目交付质量远超预期，团队协作能力突出');
INSERT INTO `performance_evaluation` VALUES (2, 1002, 2002, '2025-01-01 00:00:00', '2025-03-31 00:00:00', 85.00, '良好', '任务完成度高，主动承担额外工作，沟通能力较强');
INSERT INTO `performance_evaluation` VALUES (3, 1003, 2003, '2025-01-01 00:00:00', '2025-03-31 00:00:00', 78.00, '合格', '基本完成工作目标，需加强时间管理和细节把控');
INSERT INTO `performance_evaluation` VALUES (4, 1004, 2004, '2025-01-01 00:00:00', '2025-03-31 00:00:00', 95.00, '优秀', '在核心项目中起到关键作用，创新方案带来显著效益');
INSERT INTO `performance_evaluation` VALUES (5, 1005, 2005, '2025-01-01 00:00:00', '2025-03-31 00:00:00', 82.00, '良好', '跨部门协作表现出色，专业技能扎实');
INSERT INTO `performance_evaluation` VALUES (6, 1006, 2006, '2025-01-01 00:00:00', '2025-03-31 00:00:00', 76.00, '合格', '能完成基础工作，但主动性和创新意识需提升');
INSERT INTO `performance_evaluation` VALUES (7, 1001, 2001, '2025-04-01 00:00:00', '2025-06-30 00:00:00', 90.00, '优秀', '持续保持高水准工作，主动分享经验带动团队');
INSERT INTO `performance_evaluation` VALUES (8, 1002, 2002, '2025-04-01 00:00:00', '2025-06-30 00:00:00', 88.00, '良好', '在复杂任务中表现稳定，客户满意度较高');
INSERT INTO `performance_evaluation` VALUES (9, 1003, 2003, '2025-04-01 00:00:00', '2025-06-30 00:00:00', 75.00, '合格', '工作质量达标，但需加强优先级管理');
INSERT INTO `performance_evaluation` VALUES (10, 1004, 2004, '2025-04-01 00:00:00', '2025-06-30 00:00:00', 93.00, '优秀', '主导新技术落地，为部门效率提升做出重大贡献');
INSERT INTO `performance_evaluation` VALUES (11, 1005, 2005, '2025-04-01 00:00:00', '2025-06-30 00:00:00', 83.00, '良好', '目标达成率高，成本控制意识较强');
INSERT INTO `performance_evaluation` VALUES (12, 1006, 2006, '2025-04-01 00:00:00', '2025-06-30 00:00:00', 77.00, '合格', '日常工作完成度良好，建议提升跨团队沟通能力');
INSERT INTO `performance_evaluation` VALUES (13, 1007, 2007, '2025-01-01 00:00:00', '2025-03-31 00:00:00', 89.00, '良好', '在新业务领域快速上手，交付成果符合预期');
INSERT INTO `performance_evaluation` VALUES (14, 1008, 2008, '2025-01-01 00:00:00', '2025-03-31 00:00:00', 79.00, '合格', '基础工作扎实，但缺乏主动思考和改进意识');
INSERT INTO `performance_evaluation` VALUES (15, 1009, 2009, '2025-01-01 00:00:00', '2025-03-31 00:00:00', 91.00, '优秀', '在紧急项目中表现出极强的抗压能力和执行力');
INSERT INTO `performance_evaluation` VALUES (16, 1010, 2010, '2025-01-01 00:00:00', '2025-03-31 00:00:00', 81.00, '良好', '团队协作积极，任务响应速度快');
INSERT INTO `performance_evaluation` VALUES (17, 1011, 2011, '2025-04-01 00:00:00', '2025-06-30 00:00:00', 87.00, '良好', '数据驱动决策能力突出，流程优化效果显著');
INSERT INTO `performance_evaluation` VALUES (18, 1012, 2012, '2025-04-01 00:00:00', '2025-06-30 00:00:00', 74.00, '合格', '工作态度认真，但专业知识需要进一步学习');
INSERT INTO `performance_evaluation` VALUES (19, 1013, 2013, '2025-04-01 00:00:00', '2025-06-30 00:00:00', 94.00, '优秀', '年度创新提案被采纳，带来显著经济效益');
INSERT INTO `performance_evaluation` VALUES (20, 1014, 2014, '2025-04-01 00:00:00', '2025-06-30 00:00:00', 80.00, '良好', '跨部门协调能力优秀，资源整合效率高');

-- ----------------------------
-- Table structure for policy_acknowledgement
-- ----------------------------
DROP TABLE IF EXISTS `policy_acknowledgement`;
CREATE TABLE `policy_acknowledgement`  (
  `ack_id` int(11) NOT NULL AUTO_INCREMENT,
  `policy_id` int(11) NULL DEFAULT NULL,
  `employee_id` int(11) NULL DEFAULT NULL,
  `acknowledgement_date` datetime NULL DEFAULT NULL,
  PRIMARY KEY (`ack_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 21 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of policy_acknowledgement
-- ----------------------------
INSERT INTO `policy_acknowledgement` VALUES (1, 1001, 2001, '2025-01-01 00:00:00');
INSERT INTO `policy_acknowledgement` VALUES (2, 1001, 2002, '2025-01-02 00:00:00');
INSERT INTO `policy_acknowledgement` VALUES (3, 1001, 2003, '2025-01-03 00:00:00');
INSERT INTO `policy_acknowledgement` VALUES (4, 1001, 2004, '2025-01-04 00:00:00');
INSERT INTO `policy_acknowledgement` VALUES (5, 1001, 2005, '2025-01-05 00:00:00');
INSERT INTO `policy_acknowledgement` VALUES (6, 1002, 2001, '2025-02-01 00:00:00');
INSERT INTO `policy_acknowledgement` VALUES (7, 1002, 2002, '2025-02-02 00:00:00');
INSERT INTO `policy_acknowledgement` VALUES (8, 1002, 2003, '2025-02-03 00:00:00');
INSERT INTO `policy_acknowledgement` VALUES (9, 1002, 2004, '2025-02-04 00:00:00');
INSERT INTO `policy_acknowledgement` VALUES (10, 1002, 2005, '2025-02-05 00:00:00');
INSERT INTO `policy_acknowledgement` VALUES (11, 1003, 2006, '2025-03-01 00:00:00');
INSERT INTO `policy_acknowledgement` VALUES (12, 1003, 2007, '2025-03-02 00:00:00');
INSERT INTO `policy_acknowledgement` VALUES (13, 1003, 2008, '2025-03-03 00:00:00');
INSERT INTO `policy_acknowledgement` VALUES (14, 1003, 2009, '2025-03-04 00:00:00');
INSERT INTO `policy_acknowledgement` VALUES (15, 1003, 2010, '2025-03-05 00:00:00');
INSERT INTO `policy_acknowledgement` VALUES (16, 1004, 2011, '2025-04-01 00:00:00');
INSERT INTO `policy_acknowledgement` VALUES (17, 1004, 2012, '2025-04-02 00:00:00');
INSERT INTO `policy_acknowledgement` VALUES (18, 1004, 2013, '2025-04-03 00:00:00');
INSERT INTO `policy_acknowledgement` VALUES (19, 1004, 2014, '2025-04-04 00:00:00');
INSERT INTO `policy_acknowledgement` VALUES (20, 1004, 2015, '2025-04-05 00:00:00');

-- ----------------------------
-- Table structure for position
-- ----------------------------
DROP TABLE IF EXISTS `position`;
CREATE TABLE `position`  (
  `position_id` int(11) NOT NULL AUTO_INCREMENT COMMENT '职位号',
  `position_name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '职位名称',
  `department_id` int(11) NULL DEFAULT NULL COMMENT '所属部门ID(外键)',
  `base_salary` decimal(12, 2) NULL DEFAULT NULL COMMENT '基本工资(共12位，含2位小数)',
  `position_level` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '职级(如P1,P2,M1等)',
  `responsibilities` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL COMMENT '职责描述(长文本)',
  PRIMARY KEY (`position_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 21 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '职位表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of position
-- ----------------------------
INSERT INTO `position` VALUES (1, '产品经理', 101, 18000.00, 'M1', '负责产品规划、需求分析和项目推进');
INSERT INTO `position` VALUES (2, 'UI设计师', 101, 15000.00, 'P3', '负责产品界面视觉设计和用户体验优化');
INSERT INTO `position` VALUES (3, '前端开发工程师', 101, 16000.00, 'P4', '负责Web页面开发和交互实现');
INSERT INTO `position` VALUES (4, '后端开发工程师', 101, 17000.00, 'P4', '负责服务器端架构和业务逻辑开发');
INSERT INTO `position` VALUES (5, '测试工程师', 101, 14000.00, 'P3', '负责产品功能测试和质量保障');
INSERT INTO `position` VALUES (6, '人力资源经理', 102, 15000.00, 'M1', '负责人事招聘、培训和员工关系管理');
INSERT INTO `position` VALUES (7, '招聘专员', 102, 10000.00, 'P2', '负责人才筛选和面试安排');
INSERT INTO `position` VALUES (8, '薪酬福利专员', 102, 10000.00, 'P2', '负责薪资计算和福利管理');
INSERT INTO `position` VALUES (9, '财务经理', 103, 16000.00, 'M1', '负责财务管理、预算和报表分析');
INSERT INTO `position` VALUES (10, '会计', 103, 12000.00, 'P3', '负责账务处理和税务申报');
INSERT INTO `position` VALUES (11, '出纳', 103, 9000.00, 'P1', '负责现金管理和银行业务');
INSERT INTO `position` VALUES (12, '市场总监', 104, 20000.00, 'M2', '负责市场策略制定和品牌推广');
INSERT INTO `position` VALUES (13, '市场专员', 104, 12000.00, 'P3', '负责市场活动策划和执行');
INSERT INTO `position` VALUES (14, '销售经理', 105, 15000.00, 'M1', '负责销售团队管理和业绩目标达成');
INSERT INTO `position` VALUES (15, '销售代表', 105, 8000.00, 'P2', '负责客户开发和订单获取');
INSERT INTO `position` VALUES (16, '运营总监', 106, 18000.00, 'M2', '负责公司整体运营和流程优化');
INSERT INTO `position` VALUES (17, '运营专员', 106, 11000.00, 'P3', '负责日常运营数据分析和问题解决');
INSERT INTO `position` VALUES (18, '客服主管', 107, 13000.00, 'M1', '负责客服团队管理和客户满意度提升');
INSERT INTO `position` VALUES (19, '客服专员', 107, 8500.00, 'P2', '负责客户咨询解答和投诉处理');
INSERT INTO `position` VALUES (20, '行政助理', 108, 9500.00, 'P2', '负责行政事务处理和文档管理');

-- ----------------------------
-- Table structure for project
-- ----------------------------
DROP TABLE IF EXISTS `project`;
CREATE TABLE `project`  (
  `project_id` int(11) NOT NULL COMMENT '项目编号',
  `project_name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '项目名称',
  `description` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL COMMENT '项目描述',
  `start_date` date NULL DEFAULT NULL COMMENT '开始日期',
  `end_date` date NULL DEFAULT NULL COMMENT '结束日期',
  `budget` decimal(15, 2) NULL DEFAULT NULL COMMENT '预算',
  `manager_id` int(11) NULL DEFAULT NULL COMMENT '项目经理编号',
  PRIMARY KEY (`project_id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '项目表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of project
-- ----------------------------
INSERT INTO `project` VALUES (1, '电商平台重构', '重构现有电商系统，提升用户体验和性能', '2025-01-01', '2025-06-30', 2000000.00, 1001);
INSERT INTO `project` VALUES (2, '智能客服系统开发', '开发基于AI的智能客服解决方案', '2025-02-15', '2025-09-15', 1500000.00, 1002);
INSERT INTO `project` VALUES (3, '数据分析平台升级', '升级现有数据分析系统，增加预测功能', '2025-03-01', '2025-08-31', 1200000.00, 1003);
INSERT INTO `project` VALUES (4, '移动应用开发', '开发公司产品的iOS和Android应用', '2025-04-01', '2025-10-31', 1800000.00, 1004);
INSERT INTO `project` VALUES (5, '供应链管理系统集成', '集成供应商管理、库存和物流系统', '2025-01-15', '2025-07-15', 2500000.00, 1005);
INSERT INTO `project` VALUES (6, '市场营销活动策划', '2025年度品牌推广和营销活动', '2025-01-01', '2025-12-31', 800000.00, 1006);
INSERT INTO `project` VALUES (7, '客户关系管理系统优化', '优化CRM系统，提升销售效率', '2025-02-01', '2025-05-31', 900000.00, 1007);
INSERT INTO `project` VALUES (8, '新办公系统部署', '部署新一代企业办公自动化系统', '2025-03-15', '2025-09-15', 1300000.00, 1008);
INSERT INTO `project` VALUES (9, '产品研发项目A', '开发公司新一代核心产品', '2025-01-10', '2025-12-10', 3000000.00, 1009);
INSERT INTO `project` VALUES (10, '产品研发项目B', '开发公司产品线延伸产品', '2025-04-15', '2025-11-15', 1700000.00, 1010);
INSERT INTO `project` VALUES (11, '数据中心迁移', '将现有数据中心迁移至云端', '2025-05-01', '2025-10-31', 2200000.00, 1011);
INSERT INTO `project` VALUES (12, '质量控制系统开发', '开发生产过程质量监控系统', '2025-03-05', '2025-08-05', 1100000.00, 1012);
INSERT INTO `project` VALUES (13, '员工培训计划实施', '2025年度员工技能提升培训项目', '2025-01-01', '2025-12-31', 600000.00, 1013);
INSERT INTO `project` VALUES (14, '企业资源规划系统升级', '升级现有ERP系统至最新版本', '2025-02-20', '2025-07-20', 1400000.00, 1014);
INSERT INTO `project` VALUES (15, '市场调研与分析', '2025年度市场趋势和竞争对手分析', '2025-04-01', '2025-06-30', 500000.00, 1015);
INSERT INTO `project` VALUES (16, '销售渠道拓展项目', '开发新的销售渠道和合作伙伴关系', '2025-01-15', '2025-09-15', 1000000.00, 1016);
INSERT INTO `project` VALUES (17, '网络安全升级项目', '升级企业网络安全防护体系', '2025-03-10', '2025-08-10', 1600000.00, 1017);
INSERT INTO `project` VALUES (18, '售后服务系统优化', '优化客户售后服务流程和系统', '2025-04-20', '2025-09-20', 950000.00, 1018);
INSERT INTO `project` VALUES (19, '新产品市场推广', '新产品上市推广和营销策略', '2025-05-15', '2025-11-15', 750000.00, 1019);
INSERT INTO `project` VALUES (20, '内部管理流程优化', '梳理和优化企业内部管理流程', '2025-02-05', '2025-06-05', 850000.00, 1020);

-- ----------------------------
-- Table structure for project_member
-- ----------------------------
DROP TABLE IF EXISTS `project_member`;
CREATE TABLE `project_member`  (
  `projectmember_id` int(11) NOT NULL COMMENT '项目成员表编号',
  `project_id` int(11) NULL DEFAULT NULL COMMENT '项目编号',
  `员工编号` int(11) NULL DEFAULT NULL,
  `role` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '角色',
  `join_date` date NULL DEFAULT NULL COMMENT '加入日期',
  `leave_date` date NULL DEFAULT NULL COMMENT '离开日期',
  PRIMARY KEY (`projectmember_id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '项目成员表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of project_member
-- ----------------------------
INSERT INTO `project_member` VALUES (1, 1, 1001, '项目经理', '2025-01-01', NULL);
INSERT INTO `project_member` VALUES (2, 1, 1002, '前端开发', '2025-01-01', NULL);
INSERT INTO `project_member` VALUES (3, 1, 1003, '后端开发', '2025-01-01', NULL);
INSERT INTO `project_member` VALUES (4, 1, 1004, 'UI设计', '2025-01-01', NULL);
INSERT INTO `project_member` VALUES (5, 1, 1005, '测试', '2025-01-01', NULL);
INSERT INTO `project_member` VALUES (6, 2, 1006, '项目经理', '2025-02-15', NULL);
INSERT INTO `project_member` VALUES (7, 2, 1007, 'AI工程师', '2025-02-15', NULL);
INSERT INTO `project_member` VALUES (8, 2, 1008, '后端开发', '2025-02-15', NULL);
INSERT INTO `project_member` VALUES (9, 2, 1009, '测试', '2025-02-15', NULL);
INSERT INTO `project_member` VALUES (10, 3, 1010, '项目经理', '2025-03-01', NULL);
INSERT INTO `project_member` VALUES (11, 3, 1011, '数据分析师', '2025-03-01', NULL);
INSERT INTO `project_member` VALUES (12, 3, 1012, '后端开发', '2025-03-01', NULL);
INSERT INTO `project_member` VALUES (13, 4, 1013, '项目经理', '2025-04-01', NULL);
INSERT INTO `project_member` VALUES (14, 4, 1014, '前端开发', '2025-04-01', NULL);
INSERT INTO `project_member` VALUES (15, 4, 1015, '移动端开发', '2025-04-01', NULL);
INSERT INTO `project_member` VALUES (16, 5, 1016, '项目经理', '2025-01-15', NULL);
INSERT INTO `project_member` VALUES (17, 5, 1017, '系统分析师', '2025-01-15', NULL);
INSERT INTO `project_member` VALUES (18, 5, 1018, '后端开发', '2025-01-15', NULL);
INSERT INTO `project_member` VALUES (19, 6, 1019, '市场经理', '2025-01-01', NULL);
INSERT INTO `project_member` VALUES (20, 6, 1020, '市场专员', '2025-01-01', NULL);

-- ----------------------------
-- Table structure for project_task
-- ----------------------------
DROP TABLE IF EXISTS `project_task`;
CREATE TABLE `project_task`  (
  `task_id` int(11) NOT NULL COMMENT '任务编号',
  `project_id` int(11) NULL DEFAULT NULL COMMENT '项目编号',
  `task_name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '任务名称',
  `description` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL COMMENT '描述',
  `assignee_id` int(11) NULL DEFAULT NULL COMMENT '负责人编号',
  `start_date` date NULL DEFAULT NULL COMMENT '开始日期',
  `end_date` date NULL DEFAULT NULL COMMENT '结束日期',
  `priority` tinyint(4) NULL DEFAULT NULL COMMENT '优先级',
  PRIMARY KEY (`task_id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '项目任务表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of project_task
-- ----------------------------
INSERT INTO `project_task` VALUES (1, 1, '需求分析', '完成电商平台重构的需求收集与分析', 1001, '2025-01-01', '2025-01-15', 1);
INSERT INTO `project_task` VALUES (2, 1, '架构设计', '设计新电商平台的技术架构', 1003, '2025-01-16', '2025-01-31', 1);
INSERT INTO `project_task` VALUES (3, 1, 'UI原型设计', '完成电商平台首页和商品详情页原型', 1004, '2025-01-01', '2025-01-20', 2);
INSERT INTO `project_task` VALUES (4, 1, '前端开发', '实现电商平台核心页面', 1002, '2025-02-01', '2025-03-31', 1);
INSERT INTO `project_task` VALUES (5, 1, '后端API开发', '开发电商平台核心业务接口', 1003, '2025-02-01', '2025-04-15', 1);
INSERT INTO `project_task` VALUES (6, 2, 'NLP模型训练', '训练适用于客服场景的自然语言处理模型', 1007, '2025-02-15', '2025-03-30', 1);
INSERT INTO `project_task` VALUES (7, 2, '知识库构建', '建立客服常见问题知识库', 1008, '2025-02-15', '2025-03-15', 2);
INSERT INTO `project_task` VALUES (8, 2, '对话流程设计', '设计智能客服对话逻辑和流程', 1006, '2025-02-15', '2025-03-10', 1);
INSERT INTO `project_task` VALUES (9, 3, '数据模型设计', '设计数据分析平台新的数据模型', 1011, '2025-03-01', '2025-03-15', 1);
INSERT INTO `project_task` VALUES (10, 3, '预测算法实现', '实现销售趋势预测算法', 1012, '2025-03-16', '2025-04-30', 1);
INSERT INTO `project_task` VALUES (11, 3, '可视化界面开发', '开发数据可视化仪表盘', 1011, '2025-04-01', '2025-05-15', 2);
INSERT INTO `project_task` VALUES (12, 4, '移动端架构搭建', '搭建iOS和Android应用基础架构', 1015, '2025-04-01', '2025-04-15', 1);
INSERT INTO `project_task` VALUES (13, 4, '核心功能开发', '实现用户登录、商品浏览等核心功能', 1014, '2025-04-16', '2025-05-31', 1);
INSERT INTO `project_task` VALUES (14, 4, 'UI适配设计', '设计移动端适配的用户界面', 1014, '2025-04-01', '2025-04-20', 2);
INSERT INTO `project_task` VALUES (15, 5, '供应商系统调研', '调研现有供应商管理系统', 1017, '2025-01-15', '2025-01-30', 2);
INSERT INTO `project_task` VALUES (16, 5, '数据接口开发', '开发各系统间的数据交互接口', 1018, '2025-02-01', '2025-03-31', 1);
INSERT INTO `project_task` VALUES (17, 5, '集成测试', '测试供应链系统整体集成效果', 1016, '2025-04-01', '2025-05-15', 1);
INSERT INTO `project_task` VALUES (18, 6, '市场策略制定', '制定2025年度品牌推广策略', 1019, '2025-01-01', '2025-01-31', 1);
INSERT INTO `project_task` VALUES (19, 6, '活动策划执行', '策划并执行季度营销活动', 1020, '2025-02-01', '2025-02-28', 2);
INSERT INTO `project_task` VALUES (20, 6, '效果分析报告', '分析营销活动效果并提交报告', 1019, '2025-03-01', '2025-03-15', 3);

-- ----------------------------
-- Table structure for risk_assessment
-- ----------------------------
DROP TABLE IF EXISTS `risk_assessment`;
CREATE TABLE `risk_assessment`  (
  `assessment_id` int(11) NOT NULL AUTO_INCREMENT,
  `risk_area` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL,
  `description` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL,
  `impact_level` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '(\' 低 \', \' 中 \', \' 高 \', \' 极高 \')',
  `probability` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '(\' 罕见 \', \' 不太可能 \', \' 可能 \', \' 很可能 \', \' 几乎肯定 \')	',
  `assessment_date` date NULL DEFAULT NULL,
  `next_review` date NULL DEFAULT NULL,
  `responsible_person` int(11) NULL DEFAULT NULL,
  PRIMARY KEY (`assessment_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 21 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '风险评估表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of risk_assessment
-- ----------------------------
INSERT INTO `risk_assessment` VALUES (1, '技术', '系统架构无法支持业务增长导致性能下降', '高', '中', '2025-01-05', '2025-07-05', 1001);
INSERT INTO `risk_assessment` VALUES (2, '安全', '数据泄露风险，现有加密措施不足', '极高', '低', '2025-01-10', '2025-07-10', 1002);
INSERT INTO `risk_assessment` VALUES (3, '市场', '竞争对手推出类似产品抢占市场份额', '高', '高', '2025-01-15', '2025-07-15', 1003);
INSERT INTO `risk_assessment` VALUES (4, '财务', '成本超支导致项目预算失控', '中', '中', '2025-01-20', '2025-07-20', 1004);
INSERT INTO `risk_assessment` VALUES (5, '人力资源', '关键岗位人员流失影响项目进度', '高', '低', '2025-01-25', '2025-07-25', 1005);
INSERT INTO `risk_assessment` VALUES (6, '合规', '新法规实施可能导致业务模式调整', '中', '高', '2025-02-01', '2025-08-01', 1006);
INSERT INTO `risk_assessment` VALUES (7, '技术', '第三方服务中断影响业务连续性', '中', '中', '2025-02-05', '2025-08-05', 1001);
INSERT INTO `risk_assessment` VALUES (8, '安全', '网络攻击导致系统瘫痪', '极高', '低', '2025-02-10', '2025-08-10', 1002);
INSERT INTO `risk_assessment` VALUES (9, '市场', '目标客户群体需求变化', '高', '中', '2025-02-15', '2025-08-15', 1003);
INSERT INTO `risk_assessment` VALUES (10, '财务', '汇率波动影响国际业务收入', '中', '低', '2025-02-20', '2025-08-20', 1004);
INSERT INTO `risk_assessment` VALUES (11, '人力资源', '团队协作效率低下影响项目交付', '中', '高', '2025-02-25', '2025-08-25', 1005);
INSERT INTO `risk_assessment` VALUES (12, '合规', '数据隐私政策更新可能导致合规风险', '高', '中', '2025-03-01', '2025-09-01', 1006);
INSERT INTO `risk_assessment` VALUES (13, '技术', '新技术迭代导致现有系统落后', '中', '高', '2025-03-05', '2025-09-05', 1001);
INSERT INTO `risk_assessment` VALUES (14, '安全', '员工安全意识不足导致操作风险', '低', '高', '2025-03-10', '2025-09-10', 1002);
INSERT INTO `risk_assessment` VALUES (15, '市场', '品牌声誉受损影响客户信任', '高', '低', '2025-03-15', '2025-09-15', 1003);
INSERT INTO `risk_assessment` VALUES (16, '财务', '应收账款回收不及时导致现金流问题', '中', '中', '2025-03-20', '2025-09-20', 1004);
INSERT INTO `risk_assessment` VALUES (17, '人力资源', '培训不足导致员工技能无法满足业务需求', '中', '高', '2025-03-25', '2025-09-25', 1005);
INSERT INTO `risk_assessment` VALUES (18, '合规', '行业监管政策变化导致业务调整', '高', '中', '2025-04-01', '2025-10-01', 1006);
INSERT INTO `risk_assessment` VALUES (19, '技术', '系统集成失败导致项目延期', '高', '低', '2025-04-05', '2025-10-05', 1001);
INSERT INTO `risk_assessment` VALUES (20, '安全', '供应链安全漏洞影响产品质量', '中', '低', '2025-04-10', '2025-10-10', 1002);

-- ----------------------------
-- Table structure for salary_adjustment
-- ----------------------------
DROP TABLE IF EXISTS `salary_adjustment`;
CREATE TABLE `salary_adjustment`  (
  `adjustment_id` int(11) NOT NULL AUTO_INCREMENT,
  `employee_id` int(11) NULL DEFAULT NULL,
  `previous_salary` decimal(10, 2) NULL DEFAULT NULL,
  `new_salary` decimal(10, 2) NULL DEFAULT NULL,
  `adjustment_date` date NULL DEFAULT NULL,
  `reason` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL,
  `approver_id` int(11) NULL DEFAULT NULL,
  PRIMARY KEY (`adjustment_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 21 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '薪资调整表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of salary_adjustment
-- ----------------------------
INSERT INTO `salary_adjustment` VALUES (1, 1001, 15000.00, 16500.00, '2025-01-10', '年度绩效优秀调薪', 2001);
INSERT INTO `salary_adjustment` VALUES (2, 1002, 12000.00, 13200.00, '2025-01-10', '年度绩效良好调薪', 2002);
INSERT INTO `salary_adjustment` VALUES (3, 1003, 10000.00, 10500.00, '2025-01-10', '年度绩效合格调薪', 2003);
INSERT INTO `salary_adjustment` VALUES (4, 1004, 18000.00, 20000.00, '2025-02-15', '晋升技术主管', 2004);
INSERT INTO `salary_adjustment` VALUES (5, 1005, 9500.00, 11000.00, '2025-02-15', '转正加薪', 2005);
INSERT INTO `salary_adjustment` VALUES (6, 1006, 13000.00, 14500.00, '2025-03-20', '岗位调整', 2006);
INSERT INTO `salary_adjustment` VALUES (7, 1007, 11000.00, 11500.00, '2025-03-20', '年度绩效良好调薪', 2007);
INSERT INTO `salary_adjustment` VALUES (8, 1008, 12500.00, 13500.00, '2025-04-05', '项目突出贡献', 2008);
INSERT INTO `salary_adjustment` VALUES (9, 1009, 10500.00, 11000.00, '2025-04-05', '年度绩效合格调薪', 2009);
INSERT INTO `salary_adjustment` VALUES (10, 1010, 14000.00, 15500.00, '2025-05-12', '晋升产品经理', 2010);
INSERT INTO `salary_adjustment` VALUES (11, 1011, 9000.00, 10000.00, '2025-05-12', '转正加薪', 2011);
INSERT INTO `salary_adjustment` VALUES (12, 1012, 13500.00, 14200.00, '2025-06-01', '年度绩效良好调薪', 2012);
INSERT INTO `salary_adjustment` VALUES (13, 1013, 15500.00, 17000.00, '2025-06-01', '晋升高级工程师', 2013);
INSERT INTO `salary_adjustment` VALUES (14, 1014, 11000.00, 12000.00, '2025-07-08', '岗位调整', 2014);
INSERT INTO `salary_adjustment` VALUES (15, 1015, 8500.00, 9500.00, '2025-07-08', '转正加薪', 2015);
INSERT INTO `salary_adjustment` VALUES (16, 1016, 12000.00, 13000.00, '2025-08-15', '年度绩效良好调薪', 2016);
INSERT INTO `salary_adjustment` VALUES (17, 1017, 14500.00, 16000.00, '2025-08-15', '晋升技术总监', 2017);
INSERT INTO `salary_adjustment` VALUES (18, 1018, 10000.00, 10800.00, '2025-09-20', '年度绩效合格调薪', 2018);
INSERT INTO `salary_adjustment` VALUES (19, 1019, 13000.00, 14000.00, '2025-09-20', '项目突出贡献', 2019);
INSERT INTO `salary_adjustment` VALUES (20, 1020, 9200.00, 10200.00, '2025-10-25', '转正加薪', 2020);

-- ----------------------------
-- Table structure for salary_record
-- ----------------------------
DROP TABLE IF EXISTS `salary_record`;
CREATE TABLE `salary_record`  (
  `record_id` int(11) NOT NULL AUTO_INCREMENT COMMENT '记录ID',
  `employee_id` int(11) NULL DEFAULT NULL COMMENT '员工编号',
  `year` smallint(6) NULL DEFAULT NULL COMMENT '年份',
  `month` tinyint(4) NULL DEFAULT NULL COMMENT '月份',
  `base_salary` decimal(10, 2) NULL DEFAULT NULL COMMENT '基本工资',
  `performance_bonus` decimal(10, 2) NULL DEFAULT NULL COMMENT '绩效奖金',
  `net_salary` decimal(10, 2) NULL DEFAULT NULL COMMENT '实发工资',
  `payment_status` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '发放状态',
  `payment_date` date NULL DEFAULT NULL COMMENT '发放日期',
  PRIMARY KEY (`record_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 21 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '薪资记录表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of salary_record
-- ----------------------------
INSERT INTO `salary_record` VALUES (1, 1001, 2025, 1, 16500.00, 3000.00, 17400.00, '已发放', '2025-02-10');
INSERT INTO `salary_record` VALUES (2, 1002, 2025, 1, 13200.00, 2500.00, 15000.00, '已发放', '2025-02-10');
INSERT INTO `salary_record` VALUES (3, 1003, 2025, 1, 10500.00, 1500.00, 11500.00, '已发放', '2025-02-10');
INSERT INTO `salary_record` VALUES (4, 1004, 2025, 2, 20000.00, 4000.00, 21700.00, '已发放', '2025-03-10');
INSERT INTO `salary_record` VALUES (5, 1005, 2025, 2, 11000.00, 2000.00, 12600.00, '已发放', '2025-03-10');
INSERT INTO `salary_record` VALUES (6, 1006, 2025, 3, 14500.00, 3000.00, 16200.00, '已发放', '2025-04-10');
INSERT INTO `salary_record` VALUES (7, 1007, 2025, 3, 11500.00, 2200.00, 13700.00, '已发放', '2025-04-10');
INSERT INTO `salary_record` VALUES (8, 1008, 2025, 4, 13500.00, 3500.00, 16000.00, '已发放', '2025-05-10');
INSERT INTO `salary_record` VALUES (9, 1009, 2025, 4, 11000.00, 1800.00, 11900.00, '已发放', '2025-05-10');
INSERT INTO `salary_record` VALUES (10, 1010, 2025, 5, 15500.00, 3200.00, 17200.00, '已发放', '2025-06-10');
INSERT INTO `salary_record` VALUES (11, 1011, 2025, 5, 10000.00, 1500.00, 11000.00, '已发放', '2025-06-10');
INSERT INTO `salary_record` VALUES (12, 1012, 2025, 6, 14200.00, 2800.00, 15800.00, '已发放', '2025-07-10');
INSERT INTO `salary_record` VALUES (13, 1013, 2025, 6, 17000.00, 4000.00, 22100.00, '已发放', '2025-07-10');
INSERT INTO `salary_record` VALUES (14, 1014, 2025, 7, 12000.00, 2500.00, 13400.00, '已发放', '2025-08-10');
INSERT INTO `salary_record` VALUES (15, 1015, 2025, 7, 9500.00, 1800.00, 10700.00, '已发放', '2025-08-10');
INSERT INTO `salary_record` VALUES (16, 1016, 2025, 8, 13000.00, 2800.00, 16800.00, '已发放', '2025-09-10');
INSERT INTO `salary_record` VALUES (17, 1017, 2025, 8, 16000.00, 4500.00, 23500.00, '已发放', '2025-09-10');
INSERT INTO `salary_record` VALUES (18, 1018, 2025, 9, 10800.00, 1600.00, 12500.00, '已发放', '2025-10-10');
INSERT INTO `salary_record` VALUES (19, 1019, 2025, 9, 14000.00, 3000.00, 15700.00, '已发放', '2025-10-10');
INSERT INTO `salary_record` VALUES (20, 1020, 2025, 10, 10200.00, 1800.00, 11500.00, '已发放', '2025-11-10');

-- ----------------------------
-- Table structure for schedule_request
-- ----------------------------
DROP TABLE IF EXISTS `schedule_request`;
CREATE TABLE `schedule_request`  (
  `request_id` int(11) NOT NULL COMMENT '排班申请编号',
  `employee_id` int(11) NULL DEFAULT NULL COMMENT '员工编号',
  `request_date` date NULL DEFAULT NULL COMMENT '申请日期',
  `request_type` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '申请类型',
  `reason` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL COMMENT '原因',
  `approver_id` int(11) NULL DEFAULT NULL COMMENT '审批人编号',
  PRIMARY KEY (`request_id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '排班申请表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of schedule_request
-- ----------------------------
INSERT INTO `schedule_request` VALUES (1, 1001, '2025-01-05', '调班', '参加行业研讨会', 2001);
INSERT INTO `schedule_request` VALUES (2, 1002, '2025-01-10', '加班', '项目紧急上线', 2002);
INSERT INTO `schedule_request` VALUES (3, 1003, '2025-01-15', '换休', '周末参加考试', 2003);
INSERT INTO `schedule_request` VALUES (4, 1004, '2025-01-20', '调班', '孩子家长会', 2004);
INSERT INTO `schedule_request` VALUES (5, 1005, '2025-01-25', '加班', '季度报表冲刺', 2005);
INSERT INTO `schedule_request` VALUES (6, 1001, '2025-02-01', '换休', '已积攒3天调休', 2001);
INSERT INTO `schedule_request` VALUES (7, 1002, '2025-02-05', '调班', '预约医疗检查', 2002);
INSERT INTO `schedule_request` VALUES (8, 1003, '2025-02-10', '加班', '客户紧急需求', 2003);
INSERT INTO `schedule_request` VALUES (9, 1004, '2025-02-15', '换休', '使用年假调休', 2004);
INSERT INTO `schedule_request` VALUES (10, 1005, '2025-02-20', '调班', '陪同家人就医', 2005);
INSERT INTO `schedule_request` VALUES (11, 1006, '2025-03-01', '加班', '系统升级维护', 2006);
INSERT INTO `schedule_request` VALUES (12, 1007, '2025-03-05', '换休', '补休之前加班', 2007);
INSERT INTO `schedule_request` VALUES (13, 1008, '2025-03-10', '调班', '参加培训课程', 2008);
INSERT INTO `schedule_request` VALUES (14, 1009, '2025-03-15', '加班', '产品迭代测试', 2009);
INSERT INTO `schedule_request` VALUES (15, 1010, '2025-03-20', '换休', '处理个人事务', 2010);
INSERT INTO `schedule_request` VALUES (16, 1011, '2025-04-01', '调班', '搬家需要时间', 2011);
INSERT INTO `schedule_request` VALUES (17, 1012, '2025-04-05', '加班', '应对销售旺季', 2012);
INSERT INTO `schedule_request` VALUES (18, 1013, '2025-04-10', '换休', '消耗剩余调休天数', 2013);
INSERT INTO `schedule_request` VALUES (19, 1014, '2025-04-15', '调班', '志愿者活动安排', 2014);
INSERT INTO `schedule_request` VALUES (20, 1015, '2025-04-20', '加班', '年度审计准备', 2015);

-- ----------------------------
-- Table structure for shift_pattern
-- ----------------------------
DROP TABLE IF EXISTS `shift_pattern`;
CREATE TABLE `shift_pattern`  (
  `pattern_id` int(11) NOT NULL COMMENT '班次模块编号',
  `start_time` time NULL DEFAULT NULL COMMENT '开始时间',
  `end_time` time NULL DEFAULT NULL COMMENT '结束时间',
  `break_duration` int(11) NULL DEFAULT NULL COMMENT '休息时长',
  `department_id` int(11) NULL DEFAULT NULL COMMENT '部门编号',
  PRIMARY KEY (`pattern_id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '班次模板表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of shift_pattern
-- ----------------------------
INSERT INTO `shift_pattern` VALUES (1, '09:00:00', '18:00:00', 60, 101);
INSERT INTO `shift_pattern` VALUES (2, '09:30:00', '18:30:00', 60, 101);
INSERT INTO `shift_pattern` VALUES (3, '10:00:00', '19:00:00', 60, 101);
INSERT INTO `shift_pattern` VALUES (4, '13:00:00', '22:00:00', 60, 102);
INSERT INTO `shift_pattern` VALUES (5, '08:30:00', '17:30:00', 60, 102);
INSERT INTO `shift_pattern` VALUES (6, '16:00:00', '01:00:00', 60, 103);
INSERT INTO `shift_pattern` VALUES (7, '08:00:00', '17:00:00', 90, 103);
INSERT INTO `shift_pattern` VALUES (8, '12:00:00', '21:00:00', 60, 104);
INSERT INTO `shift_pattern` VALUES (9, '14:00:00', '23:00:00', 60, 104);
INSERT INTO `shift_pattern` VALUES (10, '08:00:00', '16:00:00', 60, 105);
INSERT INTO `shift_pattern` VALUES (11, '11:00:00', '20:00:00', 60, 105);
INSERT INTO `shift_pattern` VALUES (12, '15:00:00', '00:00:00', 60, 105);
INSERT INTO `shift_pattern` VALUES (13, '07:30:00', '16:30:00', 60, 106);
INSERT INTO `shift_pattern` VALUES (14, '10:30:00', '19:30:00', 60, 106);
INSERT INTO `shift_pattern` VALUES (15, '17:00:00', '02:00:00', 60, 106);
INSERT INTO `shift_pattern` VALUES (16, '09:00:00', '18:00:00', 45, 107);
INSERT INTO `shift_pattern` VALUES (17, '10:00:00', '19:00:00', 45, 107);
INSERT INTO `shift_pattern` VALUES (18, '13:00:00', '22:00:00', 45, 107);
INSERT INTO `shift_pattern` VALUES (19, '08:00:00', '17:00:00', 90, 108);
INSERT INTO `shift_pattern` VALUES (20, '09:30:00', '18:30:00', 90, 108);

-- ----------------------------
-- Table structure for training_course
-- ----------------------------
DROP TABLE IF EXISTS `training_course`;
CREATE TABLE `training_course`  (
  `course_id` int(11) NOT NULL COMMENT '课程编号',
  `course_name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '课程名',
  `trainer` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '培训员',
  `duration` int(11) NULL DEFAULT NULL COMMENT '时长',
  `cost` decimal(10, 2) NULL DEFAULT NULL COMMENT '成本',
  PRIMARY KEY (`course_id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of training_course
-- ----------------------------
INSERT INTO `training_course` VALUES (1, 'Java高级编程', '张教授', 32, 8000.00);
INSERT INTO `training_course` VALUES (2, 'Python数据分析', '李老师', 24, 6000.00);
INSERT INTO `training_course` VALUES (3, 'Web前端开发实战', '王工程师', 40, 10000.00);
INSERT INTO `training_course` VALUES (4, '产品经理核心技能', '赵总监', 28, 7000.00);
INSERT INTO `training_course` VALUES (5, 'UI/UX设计进阶', '陈设计师', 36, 9000.00);
INSERT INTO `training_course` VALUES (6, '敏捷开发方法论', '刘教练', 16, 4000.00);
INSERT INTO `training_course` VALUES (7, '项目管理实战', '杨经理', 24, 6000.00);
INSERT INTO `training_course` VALUES (8, '人力资源管理基础', '黄HR', 20, 5000.00);
INSERT INTO `training_course` VALUES (9, '财务报表分析', '周会计师', 16, 4000.00);
INSERT INTO `training_course` VALUES (10, '市场营销策略', '吴总监', 28, 7000.00);
INSERT INTO `training_course` VALUES (11, '销售技巧提升', '郑经理', 24, 6000.00);
INSERT INTO `training_course` VALUES (12, '客户服务心理学', '冯老师', 16, 4000.00);
INSERT INTO `training_course` VALUES (13, '运营数据分析', '孙运营', 20, 5000.00);
INSERT INTO `training_course` VALUES (14, '行政事务管理', '钱主管', 12, 3000.00);
INSERT INTO `training_course` VALUES (15, '网络安全防护', '林工程师', 24, 6000.00);
INSERT INTO `training_course` VALUES (16, '商务沟通技巧', '朱老师', 16, 4000.00);
INSERT INTO `training_course` VALUES (17, '团队建设与管理', '马总监', 20, 5000.00);
INSERT INTO `training_course` VALUES (18, '时间管理与效率提升', '胡教练', 12, 3000.00);
INSERT INTO `training_course` VALUES (19, '领导力发展培训', '郭总经理', 28, 7000.00);
INSERT INTO `training_course` VALUES (20, '职业规划与发展', '许顾问', 16, 4000.00);

-- ----------------------------
-- Table structure for training_enrollment
-- ----------------------------
DROP TABLE IF EXISTS `training_enrollment`;
CREATE TABLE `training_enrollment`  (
  `enrollment_id` int(11) NOT NULL COMMENT '培训计划编号',
  `plan_id` int(11) NULL DEFAULT NULL COMMENT '培训计划编号',
  `employee_id` int(11) NULL DEFAULT NULL COMMENT '员工编号',
  `attendance_status` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '出勤状态',
  `score` decimal(5, 2) NULL DEFAULT NULL COMMENT '考核分数',
  `feedback` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL COMMENT '反馈',
  PRIMARY KEY (`enrollment_id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '培训参与表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of training_enrollment
-- ----------------------------
INSERT INTO `training_enrollment` VALUES (1, 1, 1001, '已完成', 92.00, '课程内容实用，案例丰富');
INSERT INTO `training_enrollment` VALUES (2, 1, 1002, '已完成', 85.00, '老师讲解清晰，收获很大');
INSERT INTO `training_enrollment` VALUES (3, 2, 1003, '已完成', 78.00, '基础知识讲解详细');
INSERT INTO `training_enrollment` VALUES (4, 2, 1004, '已完成', 95.00, '实践环节设计合理');
INSERT INTO `training_enrollment` VALUES (5, 3, 1005, '已完成', 82.00, '项目实战有指导价值');
INSERT INTO `training_enrollment` VALUES (6, 3, 1006, '已完成', 76.00, '内容偏基础，适合入门');
INSERT INTO `training_enrollment` VALUES (7, 4, 1007, '已完成', 90.00, '对日常工作帮助很大');
INSERT INTO `training_enrollment` VALUES (8, 4, 1008, '已完成', 88.00, '案例贴近实际业务');
INSERT INTO `training_enrollment` VALUES (9, 5, 1009, '已完成', 75.00, '工具使用教学详细');
INSERT INTO `training_enrollment` VALUES (10, 5, 1010, '已完成', 93.00, '设计思路很有启发');
INSERT INTO `training_enrollment` VALUES (11, 6, 1011, '已完成', 83.00, '团队协作环节有趣');
INSERT INTO `training_enrollment` VALUES (12, 6, 1012, '已完成', 77.00, '理论讲解偏多');
INSERT INTO `training_enrollment` VALUES (13, 7, 1013, '已完成', 89.00, '项目管理流程清晰');
INSERT INTO `training_enrollment` VALUES (14, 7, 1014, '已完成', 79.00, '案例分析不够深入');
INSERT INTO `training_enrollment` VALUES (15, 8, 1015, '已完成', 91.00, 'HR政策解读全面');
INSERT INTO `training_enrollment` VALUES (16, 8, 1016, '已完成', 81.00, '对招聘技巧有新认识');
INSERT INTO `training_enrollment` VALUES (17, 9, 1017, '已完成', 87.00, '财务分析方法实用');
INSERT INTO `training_enrollment` VALUES (18, 9, 1018, '已完成', 74.00, '公式推导部分较难理解');
INSERT INTO `training_enrollment` VALUES (19, 10, 1019, '已完成', 94.00, '营销策略很有创意');
INSERT INTO `training_enrollment` VALUES (20, 10, 1020, '已完成', 80.00, '市场调研方法有启发');

-- ----------------------------
-- Table structure for training_plan
-- ----------------------------
DROP TABLE IF EXISTS `training_plan`;
CREATE TABLE `training_plan`  (
  `plan_id` int(11) NOT NULL COMMENT '计划编号',
  `course_id` int(11) NULL DEFAULT NULL,
  `start_date` date NULL DEFAULT NULL,
  `end_date` date NULL DEFAULT NULL,
  `location` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '地点',
  `max_participants` int(11) NULL DEFAULT NULL COMMENT '最大参加人数',
  PRIMARY KEY (`plan_id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '培训计划表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of training_plan
-- ----------------------------
INSERT INTO `training_plan` VALUES (1, 1, '2025-01-10', '2025-01-14', '北京总部3楼会议室', 30);
INSERT INTO `training_plan` VALUES (2, 2, '2025-01-15', '2025-01-18', '上海分公司2楼培训室', 25);
INSERT INTO `training_plan` VALUES (3, 3, '2025-02-03', '2025-02-07', '深圳分部1楼多功能厅', 40);
INSERT INTO `training_plan` VALUES (4, 4, '2025-02-10', '2025-02-12', '广州办事处会议室', 20);
INSERT INTO `training_plan` VALUES (5, 5, '2025-02-20', '2025-02-23', '北京总部4楼设计室', 15);
INSERT INTO `training_plan` VALUES (6, 6, '2025-03-01', '2025-03-02', '上海分公司3楼研讨室', 25);
INSERT INTO `training_plan` VALUES (7, 7, '2025-03-10', '2025-03-13', '深圳分部2楼会议室', 30);
INSERT INTO `training_plan` VALUES (8, 8, '2025-03-15', '2025-03-16', '北京总部2楼HR办公室', 20);
INSERT INTO `training_plan` VALUES (9, 9, '2025-03-20', '2025-03-21', '广州办事处财务室', 15);
INSERT INTO `training_plan` VALUES (10, 10, '2025-04-01', '2025-04-04', '上海分公司1楼展厅', 35);
INSERT INTO `training_plan` VALUES (11, 11, '2025-04-10', '2025-04-12', '深圳分部3楼销售区', 40);
INSERT INTO `training_plan` VALUES (12, 12, '2025-04-15', '2025-04-16', '北京总部1楼客服中心', 25);
INSERT INTO `training_plan` VALUES (13, 13, '2025-04-20', '2025-04-22', '上海分公司2楼运营部', 20);
INSERT INTO `training_plan` VALUES (14, 14, '2025-05-01', '2025-05-02', '广州办事处行政部', 15);
INSERT INTO `training_plan` VALUES (15, 15, '2025-05-10', '2025-05-12', '深圳分部1楼机房', 20);
INSERT INTO `training_plan` VALUES (16, 16, '2025-05-15', '2025-05-16', '北京总部3楼会议室', 30);
INSERT INTO `training_plan` VALUES (17, 17, '2025-05-20', '2025-05-22', '上海分公司4楼培训室', 25);
INSERT INTO `training_plan` VALUES (18, 18, '2025-06-01', '2025-06-02', '深圳分部2楼研讨室', 20);
INSERT INTO `training_plan` VALUES (19, 19, '2025-06-10', '2025-06-13', '广州办事处会议室', 15);
INSERT INTO `training_plan` VALUES (20, 20, '2025-06-15', '2025-06-16', '北京总部2楼多功能厅', 25);

-- ----------------------------
-- Table structure for work_schedule
-- ----------------------------
DROP TABLE IF EXISTS `work_schedule`;
CREATE TABLE `work_schedule`  (
  `schedule_id` int(11) NOT NULL COMMENT '排班编号',
  `employee_id` int(11) NULL DEFAULT NULL COMMENT '员工编号',
  `start_time` time NULL DEFAULT NULL COMMENT '开始时间',
  `end_time` time NULL DEFAULT NULL COMMENT '结束时间',
  `schedule_type` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '排班类型',
  PRIMARY KEY (`schedule_id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '工作排班表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of work_schedule
-- ----------------------------
INSERT INTO `work_schedule` VALUES (1, 1001, '09:00:00', '18:00:00', '标准白班');
INSERT INTO `work_schedule` VALUES (2, 1002, '09:30:00', '18:30:00', '弹性白班');
INSERT INTO `work_schedule` VALUES (3, 1003, '10:00:00', '19:00:00', '晚白班');
INSERT INTO `work_schedule` VALUES (4, 1004, '13:00:00', '22:00:00', '中班');
INSERT INTO `work_schedule` VALUES (5, 1005, '08:30:00', '17:30:00', '早班');
INSERT INTO `work_schedule` VALUES (6, 1001, '16:00:00', '01:00:00', '晚班');
INSERT INTO `work_schedule` VALUES (7, 1002, '08:00:00', '17:00:00', '早班（长午休）');
INSERT INTO `work_schedule` VALUES (8, 1003, '12:00:00', '21:00:00', '中班');
INSERT INTO `work_schedule` VALUES (9, 1004, '14:00:00', '23:00:00', '晚班');
INSERT INTO `work_schedule` VALUES (10, 1005, '08:00:00', '16:00:00', '早班');
INSERT INTO `work_schedule` VALUES (11, 1006, '11:00:00', '20:00:00', '中班');
INSERT INTO `work_schedule` VALUES (12, 1007, '15:00:00', '00:00:00', '晚班');
INSERT INTO `work_schedule` VALUES (13, 1008, '07:30:00', '16:30:00', '早班');
INSERT INTO `work_schedule` VALUES (14, 1009, '10:30:00', '19:30:00', '中班');
INSERT INTO `work_schedule` VALUES (15, 1010, '17:00:00', '02:00:00', '晚班');
INSERT INTO `work_schedule` VALUES (16, 1011, '09:00:00', '18:00:00', '标准白班');
INSERT INTO `work_schedule` VALUES (17, 1012, '10:00:00', '19:00:00', '晚白班');
INSERT INTO `work_schedule` VALUES (18, 1013, '13:00:00', '22:00:00', '中班');
INSERT INTO `work_schedule` VALUES (19, 1014, '08:30:00', '17:30:00', '早班');
INSERT INTO `work_schedule` VALUES (20, 1015, '16:00:00', '01:00:00', '晚班');

SET FOREIGN_KEY_CHECKS = 1;
