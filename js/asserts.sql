/*
 Navicat Premium Data Transfer

 Source Server         : sqlite
 Source Server Type    : SQLite
 Source Server Version : 3017000
 Source Schema         : main

 Target Server Type    : SQLite
 Target Server Version : 3017000
 File Encoding         : 65001

 Date: 14/06/2022 10:53:26
*/

PRAGMA foreign_keys = false;

-- ----------------------------
-- Table structure for tb_assets
-- ----------------------------
DROP TABLE IF EXISTS "tb_assets";
CREATE TABLE "tb_assets" (
                             "channel" TEXT NOT NULL,
                             "price" DECIMAL (16) NOT NULL,
                             "note_date" TEXT NOT NULL DEFAULT (strftime('%Y-%m-%d',datetime( 'now', 'localtime' ))),
                             "gmt_time" TEXT NOT NULL DEFAULT (
                                 datetime( 'now', 'localtime' ))
);

-- ----------------------------
-- Records of "tb_assets"
-- ----------------------------
INSERT INTO "tb_assets" VALUES ('兴业', 32334, '2022-01-10', '2022-01-10 10:50:00');
INSERT INTO "tb_assets" VALUES ('招商', 963, '2022-01-10', '2022-01-10 10:50:00');
INSERT INTO "tb_assets" VALUES ('招商信用', '-1,428', '2022-01-10', '2022-01-10 10:50:00');
INSERT INTO "tb_assets" VALUES ('中信', 123598, '2022-01-10', '2022-01-10 10:50:00');
INSERT INTO "tb_assets" VALUES ('平安', 3730, '2022-01-10', '2022-01-10 10:50:00');
INSERT INTO "tb_assets" VALUES ('花呗', -1600, '2022-01-10', '2022-01-10 10:50:00');
INSERT INTO "tb_assets" VALUES ('支付宝', 10046, '2022-01-10', '2022-01-10 10:50:00');
INSERT INTO "tb_assets" VALUES ('兴业', 26612, '2022-02-05', '2022-02-05 10:27:11');
INSERT INTO "tb_assets" VALUES ('招商', 166, '2022-02-05', '2022-02-05 10:27:11');
INSERT INTO "tb_assets" VALUES ('招商信用', -3000, '2022-02-05', '2022-02-05 10:27:11');
INSERT INTO "tb_assets" VALUES ('中信', 123626, '2022-02-05', '2022-02-05 10:27:11');
INSERT INTO "tb_assets" VALUES ('平安', 3840, '2022-02-05', '2022-02-05 10:27:11');
INSERT INTO "tb_assets" VALUES ('花呗', -1600, '2022-02-05', '2022-02-05 10:27:11');
INSERT INTO "tb_assets" VALUES ('支付宝', 9980, '2022-02-05', '2022-02-05 10:27:11');
INSERT INTO "tb_assets" VALUES ('兴业', 23168, '2022-02-13', '2022-02-13 14:02:56');
INSERT INTO "tb_assets" VALUES ('招商', 26, '2022-02-13', '2022-02-13 14:02:56');
INSERT INTO "tb_assets" VALUES ('招商信用', -4539, '2022-02-13', '2022-02-13 14:02:56');
INSERT INTO "tb_assets" VALUES ('中信', 138182, '2022-02-13', '2022-02-13 14:02:56');
INSERT INTO "tb_assets" VALUES ('平安', 3840, '2022-02-13', '2022-02-13 14:02:56');
INSERT INTO "tb_assets" VALUES ('花呗', -2000, '2022-02-13', '2022-02-13 14:02:56');
INSERT INTO "tb_assets" VALUES ('支付宝', 10900, '2022-02-13', '2022-02-13 14:03:10');
INSERT INTO "tb_assets" VALUES ('兴业', 23012, '2022-02-24', '2022-02-24 14:02:56');
INSERT INTO "tb_assets" VALUES ('招商', 26, '2022-02-24', '2022-02-24 14:02:56');
INSERT INTO "tb_assets" VALUES ('招商信用', -5223, '2022-02-24', '2022-02-24 14:02:56');
INSERT INTO "tb_assets" VALUES ('中信', 138182, '2022-02-24', '2022-02-24 14:02:56');
INSERT INTO "tb_assets" VALUES ('平安', 3830, '2022-02-24', '2022-02-24 14:02:56');
INSERT INTO "tb_assets" VALUES ('花呗', -1800, '2022-02-24', '2022-02-24 14:02:56');
INSERT INTO "tb_assets" VALUES ('支付宝', 11544, '2022-02-24', '2022-02-24 14:03:10');
INSERT INTO "tb_assets" VALUES ('兴业', 2970, '2022-03-06', '2022-03-06 14:02:56');
INSERT INTO "tb_assets" VALUES ('招商', 26, '2022-03-06', '2022-03-06 14:02:56');
INSERT INTO "tb_assets" VALUES ('招商信用', -6000, '2022-03-06', '2022-03-06 14:02:56');
INSERT INTO "tb_assets" VALUES ('中信', 137800, '2022-03-06', '2022-03-06 14:02:56');
INSERT INTO "tb_assets" VALUES ('平安', 3824, '2022-03-06', '2022-03-06 14:02:56');
INSERT INTO "tb_assets" VALUES ('花呗', -1900, '2022-03-06', '2022-03-06 14:02:56');
INSERT INTO "tb_assets" VALUES ('支付宝', 31330, '2022-03-06', '2022-03-06 14:03:10');
INSERT INTO "tb_assets" VALUES ('招商', 5441, '2022-03-26', '2022-03-26 14:02:56');
INSERT INTO "tb_assets" VALUES ('招商信用', -5240, '2022-03-26', '2022-03-26 14:02:56');
INSERT INTO "tb_assets" VALUES ('中信', 129500, '2022-03-26', '2022-03-26 14:02:56');
INSERT INTO "tb_assets" VALUES ('平安', 29742, '2022-03-26', '2022-03-26 14:02:56');
INSERT INTO "tb_assets" VALUES ('花呗', -1900, '2022-03-26', '2022-03-26 14:02:56');
INSERT INTO "tb_assets" VALUES ('支付宝', 20563, '2022-03-26', '2022-03-26 14:03:10');
INSERT INTO "tb_assets" VALUES ('招商', 200, '2022-04-07', '2022-04-07 14:02:56');
INSERT INTO "tb_assets" VALUES ('招商信用', -2551, '2022-04-07', '2022-04-07 14:02:56');
INSERT INTO "tb_assets" VALUES ('中信', 130986, '2022-04-07', '2022-04-07 14:02:56');
INSERT INTO "tb_assets" VALUES ('平安', 30600, '2022-04-07', '2022-04-07 14:02:56');
INSERT INTO "tb_assets" VALUES ('花呗', -1900, '2022-04-07', '2022-04-07 14:02:56');
INSERT INTO "tb_assets" VALUES ('支付宝', 20400, '2022-04-07', '2022-04-07 14:03:10');
INSERT INTO "tb_assets" VALUES ('招商信用', -4000, '2022-04-15', '2022-04-15 14:02:56');
INSERT INTO "tb_assets" VALUES ('中信', 143100, '2022-04-15', '2022-04-15 14:02:56');
INSERT INTO "tb_assets" VALUES ('平安', 33580, '2022-04-15', '2022-04-15 14:02:56');
INSERT INTO "tb_assets" VALUES ('花呗', -1400, '2022-04-15', '2022-04-15 14:02:56');
INSERT INTO "tb_assets" VALUES ('支付宝', 20100, '2022-04-15', '2022-04-15 14:03:10');
INSERT INTO "tb_assets" VALUES ('招商信用', -7200, '2022-04-25', '2022-04-25 14:02:56');
INSERT INTO "tb_assets" VALUES ('中信', 135400, '2022-04-25', '2022-04-25 14:02:56');
INSERT INTO "tb_assets" VALUES ('平安', 35000, '2022-04-25', '2022-04-25 14:02:56');
INSERT INTO "tb_assets" VALUES ('花呗', -1400, '2022-04-25', '2022-04-25 14:02:56');
INSERT INTO "tb_assets" VALUES ('支付宝', 20000, '2022-04-25', '2022-04-25 14:03:10');
INSERT INTO "tb_assets" VALUES ('招商信用', -6200, '2022-05-25', '2022-05-25 14:02:56');
INSERT INTO "tb_assets" VALUES ('中信', 139000, '2022-05-25', '2022-05-25 14:02:56');
INSERT INTO "tb_assets" VALUES ('平安', 35000, '2022-05-25', '2022-05-25 14:02:56');
INSERT INTO "tb_assets" VALUES ('花呗', -1400, '2022-05-25', '2022-05-25 14:02:56');
INSERT INTO "tb_assets" VALUES ('支付宝', 22200, '2022-05-25', '2022-05-25 14:03:10');
INSERT INTO "tb_assets" VALUES ('招商信用', -7200, '2022-06-02', '2022-06-02 14:02:56');
INSERT INTO "tb_assets" VALUES ('中信', 138753, '2022-06-02', '2022-06-02 14:02:56');
INSERT INTO "tb_assets" VALUES ('平安', 35000, '2022-06-02', '2022-06-02 14:02:56');
INSERT INTO "tb_assets" VALUES ('花呗', -1400, '2022-06-02', '2022-06-02 14:02:56');
INSERT INTO "tb_assets" VALUES ('支付宝', 22200, '2022-06-02', '2022-06-02 14:03:10');
INSERT INTO "tb_assets" VALUES ('招商信用', -2000, '2022-06-10', '2022-06-10 14:02:56');
INSERT INTO "tb_assets" VALUES ('中信', 143795, '2022-06-10', '2022-06-10 14:02:56');
INSERT INTO "tb_assets" VALUES ('平安', 36100, '2022-06-10', '2022-06-10 14:02:56');
INSERT INTO "tb_assets" VALUES ('花呗', -1400, '2022-06-10', '2022-06-10 14:02:56');
INSERT INTO "tb_assets" VALUES ('支付宝', 21900, '2022-06-10', '2022-06-10 14:03:10');

PRAGMA foreign_keys = true;