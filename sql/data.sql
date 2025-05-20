-- =======================================
-- 学校データベース データ挿入SQL
-- =======================================

-- ---------------------------------------
-- 教師テーブルのデータ
-- ---------------------------------------
INSERT INTO teachers VALUES (101, '寺内鞍');
INSERT INTO teachers VALUES (102, '田尻朋美');
INSERT INTO teachers VALUES (103, '内村海凪');
INSERT INTO teachers VALUES (104, '藤本理恵');
INSERT INTO teachers VALUES (105, '黒木大介');
INSERT INTO teachers VALUES (106, '星野涼子');
INSERT INTO teachers VALUES (107, '深山誠一');
INSERT INTO teachers VALUES (108, '吉岡由佳');
INSERT INTO teachers VALUES (109, '山田太郎');
INSERT INTO teachers VALUES (110, '佐藤花子');
INSERT INTO teachers VALUES (111, '鈴木一郎');
INSERT INTO teachers VALUES (112, '高橋恵美');
INSERT INTO teachers VALUES (113, '中村博士');
INSERT INTO teachers VALUES (114, '小林智子');
INSERT INTO teachers VALUES (115, '伊藤誠');
INSERT INTO teachers VALUES (116, '渡辺京子');
INSERT INTO teachers VALUES (117, '加藤健一');
INSERT INTO teachers VALUES (118, '松本さやか');
INSERT INTO teachers VALUES (119, '井上剛');
INSERT INTO teachers VALUES (120, '木村美咲');

-- ---------------------------------------
-- 学生テーブルのデータ
-- ---------------------------------------
INSERT INTO students VALUES (301, '黒沢春馬');
INSERT INTO students VALUES (302, '新垣愛留');
INSERT INTO students VALUES (303, '柴崎春花');
INSERT INTO students VALUES (304, '森下風凛');
INSERT INTO students VALUES (305, '河口菜恵子');
INSERT INTO students VALUES (306, '河田咲奈');
INSERT INTO students VALUES (307, '織田柚夏');
INSERT INTO students VALUES (308, '永田悦子');
INSERT INTO students VALUES (309, '相沢吉夫');
INSERT INTO students VALUES (310, '吉川伽羅');
INSERT INTO students VALUES (311, '鈴木健太');
INSERT INTO students VALUES (312, '山本裕子');
INSERT INTO students VALUES (313, '佐藤大輔');
INSERT INTO students VALUES (314, '中村彩香');
INSERT INTO students VALUES (315, '高橋直人');
INSERT INTO students VALUES (316, '渡辺美咲');
INSERT INTO students VALUES (317, '伊藤拓海');
INSERT INTO students VALUES (318, '小林千尋');
INSERT INTO students VALUES (319, '加藤悠真');
INSERT INTO students VALUES (320, '松本さくら');
INSERT INTO students VALUES (321, '井上竜也');
INSERT INTO students VALUES (322, '木村結衣');
INSERT INTO students VALUES (323, '林正義');
INSERT INTO students VALUES (324, '清水香織');
INSERT INTO students VALUES (325, '山田翔太');
INSERT INTO students VALUES (326, '葉山陽太');
INSERT INTO students VALUES (327, '青山凛');
INSERT INTO students VALUES (328, '沢村大和');
INSERT INTO students VALUES (329, '白石優月');
INSERT INTO students VALUES (330, '月岡星奈');
INSERT INTO students VALUES (331, '桜木蓮');
INSERT INTO students VALUES (332, '風間彩花');
INSERT INTO students VALUES (333, '七海翔太');
INSERT INTO students VALUES (334, '雪平美結');
INSERT INTO students VALUES (335, '空野結人');
INSERT INTO students VALUES (336, '朝日奏');
INSERT INTO students VALUES (337, '星野光');
INSERT INTO students VALUES (338, '宮本大翔');
INSERT INTO students VALUES (339, '藤原心菜');
INSERT INTO students VALUES (340, '霧島悠真');
INSERT INTO students VALUES (341, '綾瀬千尋');
INSERT INTO students VALUES (342, '瀬戸響介');
INSERT INTO students VALUES (343, '橘明日香');
INSERT INTO students VALUES (344, '龍ヶ崎樹');
INSERT INTO students VALUES (345, '水無瀬優奈');
INSERT INTO students VALUES (346, '立花颯太');
INSERT INTO students VALUES (347, '鳴海詩織');
INSERT INTO students VALUES (348, '氷室凌');
INSERT INTO students VALUES (349, '紫藤木葵');
INSERT INTO students VALUES (350, '真城春翔');
INSERT INTO students VALUES (351, '朝比奈涼子');
INSERT INTO students VALUES (352, '神宮寺弦');
INSERT INTO students VALUES (353, '花嵐寧々');
INSERT INTO students VALUES (354, '四ノ宮隼');
INSERT INTO students VALUES (355, '仁科美桜');
INSERT INTO students VALUES (356, '桐生透馬');
INSERT INTO students VALUES (357, '藍沢柚希');
INSERT INTO students VALUES (358, '嵐山竜之介');
INSERT INTO students VALUES (359, '瑞樹萌絵');
INSERT INTO students VALUES (360, '朔野零');
INSERT INTO students VALUES (361, '葉月茉莉');
INSERT INTO students VALUES (362, '風祭駿');
INSERT INTO students VALUES (363, '桂木杏奈');
INSERT INTO students VALUES (364, '双葉聖也');
INSERT INTO students VALUES (365, '鴨志田瑠璃');
INSERT INTO students VALUES (366, '雲居祥太');
INSERT INTO students VALUES (367, '紅林和花');
INSERT INTO students VALUES (368, '碧井大智');
INSERT INTO students VALUES (369, '金木理彩');
INSERT INTO students VALUES (370, '夕闇誠司');
INSERT INTO students VALUES (371, '小鳥遊ひなた');
INSERT INTO students VALUES (372, '日向千景');
INSERT INTO students VALUES (373, '東雲望');
INSERT INTO students VALUES (374, '天ノ川輝');
INSERT INTO students VALUES (375, '黒崎陽菜');
INSERT INTO students VALUES (376, '綾小路拓海');
INSERT INTO students VALUES (377, '如月瑠美');
INSERT INTO students VALUES (378, '時任柊');
INSERT INTO students VALUES (379, '湊谷彩葉');
INSERT INTO students VALUES (380, '十文字悠人');
INSERT INTO students VALUES (381, '花咲ことは');
INSERT INTO students VALUES (382, '三峰暁斗');
INSERT INTO students VALUES (383, '雪村楓');
INSERT INTO students VALUES (384, '櫻井翼');
INSERT INTO students VALUES (385, '柏木美月');
INSERT INTO students VALUES (386, '鷹城雅也');
INSERT INTO students VALUES (387, '夜空凛音');
INSERT INTO students VALUES (388, '天城優太');
INSERT INTO students VALUES (389, '水無月葵');
INSERT INTO students VALUES (390, '葵屋一希');
INSERT INTO students VALUES (391, '八重樫千尋');
INSERT INTO students VALUES (392, '白石透');
INSERT INTO students VALUES (393, '鏡水花帆');
INSERT INTO students VALUES (394, '月島暁');
INSERT INTO students VALUES (395, '神楽坂詩音');
INSERT INTO students VALUES (396, '篠宮拓哉');
INSERT INTO students VALUES (397, '折原鈴');
INSERT INTO students VALUES (398, '九条輝');
INSERT INTO students VALUES (399, '雨宮かなで');
INSERT INTO students VALUES (400, '神崎悠馬');


-- ---------------------------------------
-- 教室テーブルのデータ
-- ---------------------------------------
INSERT INTO classrooms VALUES ('101A', '1号館コンピュータ実習室A', 30, '1号館', 'パソコン30台、プロジェクター');
INSERT INTO classrooms VALUES ('102B', '1号館講義室B', 60, '1号館', 'プロジェクター、ホワイトボード');
INSERT INTO classrooms VALUES ('201C', '2号館セミナールームC', 20, '2号館', 'プロジェクター、円卓');
INSERT INTO classrooms VALUES ('202D', '2号館コンピュータ実習室D', 25, '2号館', 'パソコン25台、プロジェクター、3Dプリンター');
INSERT INTO classrooms VALUES ('301E', '3号館講義室E', 80, '3号館', 'プロジェクター、マイク設備、録画設備');
INSERT INTO classrooms VALUES ('302F', '3号館セミナールームF', 15, '3号館', 'プロジェクター、テレビ会議システム');
INSERT INTO classrooms VALUES ('401G', '4号館講義室G', 120, '4号館', 'プロジェクター、音響設備、二重スクリーン');
INSERT INTO classrooms VALUES ('402H', '4号館コンピュータ実習室H', 40, '4号館', 'パソコン40台、プロジェクター、サーバールーム隣接');

-- ---------------------------------------
-- 授業時間テーブルのデータ
-- ---------------------------------------
INSERT INTO class_periods VALUES (1, '09:00:00', '10:30:00');
INSERT INTO class_periods VALUES (2, '10:40:00', '12:10:00');
INSERT INTO class_periods VALUES (3, '13:00:00', '14:30:00');
INSERT INTO class_periods VALUES (4, '14:40:00', '16:10:00');
INSERT INTO class_periods VALUES (5, '16:20:00', '17:50:00');

-- ---------------------------------------
-- 学期テーブルのデータ
-- ---------------------------------------
-- 2020年度の学期データ
INSERT INTO terms VALUES ('2020-1Q', '2020年度第1学期', '2020-04-01', '2020-06-30');
INSERT INTO terms VALUES ('2020-2Q', '2020年度第2学期', '2020-07-01', '2020-09-30');
INSERT INTO terms VALUES ('2020-3Q', '2020年度第3学期', '2020-10-01', '2020-12-31');
INSERT INTO terms VALUES ('2020-4Q', '2020年度第4学期', '2021-01-01', '2021-03-31');

-- 2021年度の学期データ
INSERT INTO terms VALUES ('2021-1Q', '2021年度第1学期', '2021-04-01', '2021-06-30');
INSERT INTO terms VALUES ('2021-2Q', '2021年度第2学期', '2021-07-01', '2021-09-30');
INSERT INTO terms VALUES ('2021-3Q', '2021年度第3学期', '2021-10-01', '2021-12-31');
INSERT INTO terms VALUES ('2021-4Q', '2021年度第4学期', '2022-01-01', '2022-03-31');

-- 2022年度の学期データ
INSERT INTO terms VALUES ('2022-1Q', '2022年度第1学期', '2022-04-01', '2022-06-30');
INSERT INTO terms VALUES ('2022-2Q', '2022年度第2学期', '2022-07-01', '2022-09-30');
INSERT INTO terms VALUES ('2022-3Q', '2022年度第3学期', '2022-10-01', '2022-12-31');
INSERT INTO terms VALUES ('2022-4Q', '2022年度第4学期', '2023-01-01', '2023-03-31');

-- 2023年度の学期データ
INSERT INTO terms VALUES ('2023-1Q', '2023年度第1学期', '2023-04-01', '2023-06-30');
INSERT INTO terms VALUES ('2023-2Q', '2023年度第2学期', '2023-07-01', '2023-09-30');
INSERT INTO terms VALUES ('2023-3Q', '2023年度第3学期', '2023-10-01', '2023-12-31');
INSERT INTO terms VALUES ('2023-4Q', '2023年度第4学期', '2024-01-01', '2024-03-31');

-- 2024年度の学期データ
INSERT INTO terms VALUES ('2024-1Q', '2024年度第1学期', '2024-04-01', '2024-06-30');
INSERT INTO terms VALUES ('2024-2Q', '2024年度第2学期', '2024-07-01', '2024-09-30');
INSERT INTO terms VALUES ('2024-3Q', '2024年度第3学期', '2024-10-01', '2024-12-31');
INSERT INTO terms VALUES ('2024-4Q', '2024年度第4学期', '2025-01-01', '2025-03-31');

-- 2025年度の学期データ
INSERT INTO terms VALUES ('2025-1Q', '2025年度第1学期', '2025-04-01', '2025-06-30');
INSERT INTO terms VALUES ('2025-2Q', '2025年度第2学期', '2025-07-01', '2025-09-30');
INSERT INTO terms VALUES ('2025-3Q', '2025年度第3学期', '2025-10-01', '2025-12-31');
INSERT INTO terms VALUES ('2025-4Q', '2025年度第4学期', '2026-01-01', '2026-03-31');

-- 2026年度の学期データ
INSERT INTO terms VALUES ('2026-1Q', '2026年度第1学期', '2026-04-01', '2026-06-30');
INSERT INTO terms VALUES ('2026-2Q', '2026年度第2学期', '2026-07-01', '2026-09-30');
INSERT INTO terms VALUES ('2026-3Q', '2026年度第3学期', '2026-10-01', '2026-12-31');
INSERT INTO terms VALUES ('2026-4Q', '2026年度第4学期', '2027-01-01', '2027-03-31');

-- ---------------------------------------
-- 講座テーブルのデータ
-- ---------------------------------------
INSERT INTO courses VALUES (1, 'ITのための基礎知識', 101);
INSERT INTO courses VALUES (2, 'UNIX入門', 102);
INSERT INTO courses VALUES (3, 'Cプログラミング演習', 101);
INSERT INTO courses VALUES (4, 'Webアプリケーション開発', 104);
INSERT INTO courses VALUES (5, 'データベース設計と実装', 105);
INSERT INTO courses VALUES (6, 'ネットワークセキュリティ', 107);
INSERT INTO courses VALUES (7, 'AI・機械学習入門', 106);
INSERT INTO courses VALUES (8, 'モバイルアプリ開発', 104);
INSERT INTO courses VALUES (9, 'クラウドコンピューティング', 108);
INSERT INTO courses VALUES (10, 'プロジェクト管理手法', 103);
INSERT INTO courses VALUES (11, 'データ分析と可視化', 106);
INSERT INTO courses VALUES (12, 'サイバーセキュリティ対策', 107);
INSERT INTO courses VALUES (13, 'ブロックチェーン技術と応用', 109);
INSERT INTO courses VALUES (14, 'IoTデバイスプログラミング実践', 110);
INSERT INTO courses VALUES (15, 'DevOpsとCI/CD入門', 111);
INSERT INTO courses VALUES (16, 'クラウドネイティブアーキテクチャ', 108);
INSERT INTO courses VALUES (17, '量子コンピューティング基礎', 112);
INSERT INTO courses VALUES (18, 'マイクロサービス設計パターン', 113);
INSERT INTO courses VALUES (19, 'サイバーセキュリティ脅威分析', 107);
INSERT INTO courses VALUES (20, 'データサイエンスとビジネス応用', 106);
INSERT INTO courses VALUES (21, 'Kubernetesによるコンテナオーケストレーション', 114);
INSERT INTO courses VALUES (22, 'フルスタック開発マスタークラス', 104);
INSERT INTO courses VALUES (23, '機械学習モデル最適化手法', 115);
INSERT INTO courses VALUES (24, 'エンタープライズアーキテクチャ設計', 116);
INSERT INTO courses VALUES (25, 'サーバーレスアプリケーション開発', 117);
INSERT INTO courses VALUES (26, 'アジャイル開発とスクラム実践', 103);
INSERT INTO courses VALUES (27, 'クロスプラットフォーム開発フレームワーク', 118);
INSERT INTO courses VALUES (28, 'ゲーム開発エンジン入門', 119);
INSERT INTO courses VALUES (29, 'コードリファクタリングとクリーンコード', 101);
INSERT INTO courses VALUES (30, 'UIUXデザイン原則と実践', 120);
INSERT INTO courses VALUES (31, '高度データ可視化技術', 106);
INSERT INTO courses VALUES (32, 'API設計と開発ベストプラクティス', 111);
INSERT INTO courses VALUES (33, 'エッジコンピューティングシステム', 110);
INSERT INTO courses VALUES (34, 'ソフトウェアテスト自動化', 109);
INSERT INTO courses VALUES (35, 'デジタルトランスフォーメーション戦略', 116);
INSERT INTO courses VALUES (36, 'スマートコントラクト開発', 118);
INSERT INTO courses VALUES (37, 'ビッグデータ処理フレームワーク', 105);
INSERT INTO courses VALUES (38, 'ネットワーク仮想化技術', 107);
INSERT INTO courses VALUES (39, 'リアルタイムシステム設計', 113);
INSERT INTO courses VALUES (40, 'ソフトウェアアーキテクチャパターン', 102);
INSERT INTO courses VALUES (41, 'クラウドセキュリティと最適化', 117);
INSERT INTO courses VALUES (42, 'プロダクトマネジメント実践', 103);
INSERT INTO courses VALUES (43, 'ナチュラルランゲージプロセッシング', 115);
INSERT INTO courses VALUES (44, 'コンピュータビジョンと画像処理', 112);
INSERT INTO courses VALUES (45, 'グラフデータベースと知識グラフ', 105);
INSERT INTO courses VALUES (46, 'インフラストラクチャー・アズ・コード', 114);
INSERT INTO courses VALUES (47, 'ウェアラブルデバイス開発', 119);
INSERT INTO courses VALUES (48, 'シミュレーションとモデリング手法', 120);

-- ---------------------------------------
-- 受講テーブルのデータ
-- ---------------------------------------
-- 講座1（ITのための基礎知識）の受講者
INSERT INTO student_courses VALUES (1, 301);
INSERT INTO student_courses VALUES (1, 302);
INSERT INTO student_courses VALUES (1, 303);
INSERT INTO student_courses VALUES (1, 306);
INSERT INTO student_courses VALUES (1, 307);
INSERT INTO student_courses VALUES (1, 308);
INSERT INTO student_courses VALUES (1, 310);
INSERT INTO student_courses VALUES (1, 311);
INSERT INTO student_courses VALUES (1, 315);
INSERT INTO student_courses VALUES (1, 317);
INSERT INTO student_courses VALUES (1, 320);
INSERT INTO student_courses VALUES (1, 323);

-- 講座2（UNIX入門）の受講者
INSERT INTO student_courses VALUES (2, 301);
INSERT INTO student_courses VALUES (2, 309);
INSERT INTO student_courses VALUES (2, 311);
INSERT INTO student_courses VALUES (2, 312);
INSERT INTO student_courses VALUES (2, 314);
INSERT INTO student_courses VALUES (2, 318);
INSERT INTO student_courses VALUES (2, 321);
INSERT INTO student_courses VALUES (2, 324);

-- 講座3（Cプログラミング演習）の受講者
INSERT INTO student_courses VALUES (3, 310);
INSERT INTO student_courses VALUES (3, 312);
INSERT INTO student_courses VALUES (3, 315);
INSERT INTO student_courses VALUES (3, 319);
INSERT INTO student_courses VALUES (3, 321);
INSERT INTO student_courses VALUES (3, 325);

-- 講座4（Webアプリケーション開発）の受講者
INSERT INTO student_courses VALUES (4, 303);
INSERT INTO student_courses VALUES (4, 305);
INSERT INTO student_courses VALUES (4, 307);
INSERT INTO student_courses VALUES (4, 313);
INSERT INTO student_courses VALUES (4, 316);
INSERT INTO student_courses VALUES (4, 320);
INSERT INTO student_courses VALUES (4, 322);

-- 講座5（データベース設計と実装）の受講者
INSERT INTO student_courses VALUES (5, 304);
INSERT INTO student_courses VALUES (5, 306);
INSERT INTO student_courses VALUES (5, 309);
INSERT INTO student_courses VALUES (5, 313);
INSERT INTO student_courses VALUES (5, 317);
INSERT INTO student_courses VALUES (5, 318);
INSERT INTO student_courses VALUES (5, 324);

-- 講座6（ネットワークセキュリティ）の受講者
INSERT INTO student_courses VALUES (6, 308);
INSERT INTO student_courses VALUES (6, 310);
INSERT INTO student_courses VALUES (6, 314);
INSERT INTO student_courses VALUES (6, 316);
INSERT INTO student_courses VALUES (6, 319);
INSERT INTO student_courses VALUES (6, 322);
INSERT INTO student_courses VALUES (6, 325);

-- 講座7（AI・機械学習入門）の受講者
INSERT INTO student_courses VALUES (7, 302);
INSERT INTO student_courses VALUES (7, 305);
INSERT INTO student_courses VALUES (7, 308);
INSERT INTO student_courses VALUES (7, 311);
INSERT INTO student_courses VALUES (7, 318);
INSERT INTO student_courses VALUES (7, 323);

-- 講座8（モバイルアプリ開発）の受講者
INSERT INTO student_courses VALUES (8, 304);
INSERT INTO student_courses VALUES (8, 307);
INSERT INTO student_courses VALUES (8, 309);
INSERT INTO student_courses VALUES (8, 312);
INSERT INTO student_courses VALUES (8, 315);
INSERT INTO student_courses VALUES (8, 320);
INSERT INTO student_courses VALUES (8, 324);

-- 講座9（クラウドコンピューティング）の受講者
INSERT INTO student_courses VALUES (9, 301);
INSERT INTO student_courses VALUES (9, 306);
INSERT INTO student_courses VALUES (9, 310);
INSERT INTO student_courses VALUES (9, 314);
INSERT INTO student_courses VALUES (9, 317);
INSERT INTO student_courses VALUES (9, 319);
INSERT INTO student_courses VALUES (9, 323);

-- 講座10（プロジェクト管理手法）の受講者
INSERT INTO student_courses VALUES (10, 302);
INSERT INTO student_courses VALUES (10, 303);
INSERT INTO student_courses VALUES (10, 312);
INSERT INTO student_courses VALUES (10, 316);
INSERT INTO student_courses VALUES (10, 321);
INSERT INTO student_courses VALUES (10, 325);

-- 講座11（データ分析と可視化）の受講者
INSERT INTO student_courses VALUES (11, 305);
INSERT INTO student_courses VALUES (11, 308);
INSERT INTO student_courses VALUES (11, 311);
INSERT INTO student_courses VALUES (11, 313);
INSERT INTO student_courses VALUES (11, 322);

-- 講座12（サイバーセキュリティ対策）の受講者
INSERT INTO student_courses VALUES (12, 304);
INSERT INTO student_courses VALUES (12, 307);
INSERT INTO student_courses VALUES (12, 315);
INSERT INTO student_courses VALUES (12, 318);
INSERT INTO student_courses VALUES (12, 320);
INSERT INTO student_courses VALUES (12, 324);

-- 講座13（ブロックチェーン技術と応用）の受講者
INSERT INTO student_courses VALUES (13, 327);
INSERT INTO student_courses VALUES (13, 335);
INSERT INTO student_courses VALUES (13, 342);
INSERT INTO student_courses VALUES (13, 349);
INSERT INTO student_courses VALUES (13, 356);
INSERT INTO student_courses VALUES (13, 363);
INSERT INTO student_courses VALUES (13, 370);
INSERT INTO student_courses VALUES (13, 377);
INSERT INTO student_courses VALUES (13, 384);
INSERT INTO student_courses VALUES (13, 391);
INSERT INTO student_courses VALUES (13, 398);

-- 講座14（IoTデバイスプログラミング実践）の受講者
INSERT INTO student_courses VALUES (14, 304);
INSERT INTO student_courses VALUES (14, 312);
INSERT INTO student_courses VALUES (14, 326);
INSERT INTO student_courses VALUES (14, 333);
INSERT INTO student_courses VALUES (14, 341);
INSERT INTO student_courses VALUES (14, 355);
INSERT INTO student_courses VALUES (14, 369);
INSERT INTO student_courses VALUES (14, 383);
INSERT INTO student_courses VALUES (14, 397);

-- 講座15（DevOpsとCI/CD入門）の受講者
INSERT INTO student_courses VALUES (15, 328);
INSERT INTO student_courses VALUES (15, 336);
INSERT INTO student_courses VALUES (15, 344);
INSERT INTO student_courses VALUES (15, 352);
INSERT INTO student_courses VALUES (15, 360);
INSERT INTO student_courses VALUES (15, 368);
INSERT INTO student_courses VALUES (15, 376);
INSERT INTO student_courses VALUES (15, 384);
INSERT INTO student_courses VALUES (15, 392);

-- 講座16（クラウドネイティブアーキテクチャ）の受講者
INSERT INTO student_courses VALUES (16, 301);
INSERT INTO student_courses VALUES (16, 309);
INSERT INTO student_courses VALUES (16, 317);
INSERT INTO student_courses VALUES (16, 329);
INSERT INTO student_courses VALUES (16, 337);
INSERT INTO student_courses VALUES (16, 345);
INSERT INTO student_courses VALUES (16, 353);
INSERT INTO student_courses VALUES (16, 361);
INSERT INTO student_courses VALUES (16, 369);
INSERT INTO student_courses VALUES (16, 377);
INSERT INTO student_courses VALUES (16, 385);
INSERT INTO student_courses VALUES (16, 393);

-- 講座17（量子コンピューティング基礎）の受講者（少人数の専門講座）
INSERT INTO student_courses VALUES (17, 330);
INSERT INTO student_courses VALUES (17, 347);
INSERT INTO student_courses VALUES (17, 364);
INSERT INTO student_courses VALUES (17, 381);
INSERT INTO student_courses VALUES (17, 398);

-- 講座18（マイクロサービス設計パターン）の受講者
INSERT INTO student_courses VALUES (18, 307);
INSERT INTO student_courses VALUES (18, 315);
INSERT INTO student_courses VALUES (18, 331);
INSERT INTO student_courses VALUES (18, 339);
INSERT INTO student_courses VALUES (18, 347);
INSERT INTO student_courses VALUES (18, 355);
INSERT INTO student_courses VALUES (18, 363);
INSERT INTO student_courses VALUES (18, 371);
INSERT INTO student_courses VALUES (18, 379);
INSERT INTO student_courses VALUES (18, 387);
INSERT INTO student_courses VALUES (18, 395);

-- 講座19（サイバーセキュリティ脅威分析）の受講者
INSERT INTO student_courses VALUES (19, 308);
INSERT INTO student_courses VALUES (19, 316);
INSERT INTO student_courses VALUES (19, 322);
INSERT INTO student_courses VALUES (19, 332);
INSERT INTO student_courses VALUES (19, 338);
INSERT INTO student_courses VALUES (19, 348);
INSERT INTO student_courses VALUES (19, 354);
INSERT INTO student_courses VALUES (19, 362);
INSERT INTO student_courses VALUES (19, 370);
INSERT INTO student_courses VALUES (19, 378);
INSERT INTO student_courses VALUES (19, 386);
INSERT INTO student_courses VALUES (19, 394);

-- 講座20（データサイエンスとビジネス応用）の受講者（人気講座）
INSERT INTO student_courses VALUES (20, 305);
INSERT INTO student_courses VALUES (20, 311);
INSERT INTO student_courses VALUES (20, 318);
INSERT INTO student_courses VALUES (20, 322);
INSERT INTO student_courses VALUES (20, 327);
INSERT INTO student_courses VALUES (20, 333);
INSERT INTO student_courses VALUES (20, 339);
INSERT INTO student_courses VALUES (20, 345);
INSERT INTO student_courses VALUES (20, 351);
INSERT INTO student_courses VALUES (20, 357);
INSERT INTO student_courses VALUES (20, 363);
INSERT INTO student_courses VALUES (20, 369);
INSERT INTO student_courses VALUES (20, 375);
INSERT INTO student_courses VALUES (20, 381);
INSERT INTO student_courses VALUES (20, 387);
INSERT INTO student_courses VALUES (20, 393);
INSERT INTO student_courses VALUES (20, 399);

-- 講座21（Kubernetesによるコンテナオーケストレーション）の受講者
INSERT INTO student_courses VALUES (21, 302);
INSERT INTO student_courses VALUES (21, 314);
INSERT INTO student_courses VALUES (21, 326);
INSERT INTO student_courses VALUES (21, 338);
INSERT INTO student_courses VALUES (21, 350);
INSERT INTO student_courses VALUES (21, 362);
INSERT INTO student_courses VALUES (21, 374);
INSERT INTO student_courses VALUES (21, 386);
INSERT INTO student_courses VALUES (21, 398);

-- 講座22（フルスタック開発マスタークラス）の受講者
INSERT INTO student_courses VALUES (22, 303);
INSERT INTO student_courses VALUES (22, 307);
INSERT INTO student_courses VALUES (22, 316);
INSERT INTO student_courses VALUES (22, 322);
INSERT INTO student_courses VALUES (22, 328);
INSERT INTO student_courses VALUES (22, 334);
INSERT INTO student_courses VALUES (22, 340);
INSERT INTO student_courses VALUES (22, 346);
INSERT INTO student_courses VALUES (22, 352);
INSERT INTO student_courses VALUES (22, 358);
INSERT INTO student_courses VALUES (22, 364);
INSERT INTO student_courses VALUES (22, 370);
INSERT INTO student_courses VALUES (22, 376);
INSERT INTO student_courses VALUES (22, 382);
INSERT INTO student_courses VALUES (22, 396);

-- 講座23（機械学習モデル最適化手法）の受講者
INSERT INTO student_courses VALUES (23, 305);
INSERT INTO student_courses VALUES (23, 311);
INSERT INTO student_courses VALUES (23, 318);
INSERT INTO student_courses VALUES (23, 333);
INSERT INTO student_courses VALUES (23, 342);
INSERT INTO student_courses VALUES (23, 357);
INSERT INTO student_courses VALUES (23, 365);
INSERT INTO student_courses VALUES (23, 373);
INSERT INTO student_courses VALUES (23, 381);
INSERT INTO student_courses VALUES (23, 389);
INSERT INTO student_courses VALUES (23, 397);

-- 講座24（エンタープライズアーキテクチャ設計）の受講者
INSERT INTO student_courses VALUES (24, 301);
INSERT INTO student_courses VALUES (24, 309);
INSERT INTO student_courses VALUES (24, 317);
INSERT INTO student_courses VALUES (24, 325);
INSERT INTO student_courses VALUES (24, 333);
INSERT INTO student_courses VALUES (24, 341);
INSERT INTO student_courses VALUES (24, 349);
INSERT INTO student_courses VALUES (24, 357);
INSERT INTO student_courses VALUES (24, 365);
INSERT INTO student_courses VALUES (24, 373);
INSERT INTO student_courses VALUES (24, 385);
INSERT INTO student_courses VALUES (24, 393);

-- 講座25（サーバーレスアプリケーション開発）の受講者
INSERT INTO student_courses VALUES (25, 303);
INSERT INTO student_courses VALUES (25, 311);
INSERT INTO student_courses VALUES (25, 319);
INSERT INTO student_courses VALUES (25, 327);
INSERT INTO student_courses VALUES (25, 335);
INSERT INTO student_courses VALUES (25, 343);
INSERT INTO student_courses VALUES (25, 351);
INSERT INTO student_courses VALUES (25, 359);
INSERT INTO student_courses VALUES (25, 367);
INSERT INTO student_courses VALUES (25, 375);
INSERT INTO student_courses VALUES (25, 383);
INSERT INTO student_courses VALUES (25, 391);
INSERT INTO student_courses VALUES (25, 399);

-- 講座26（アジャイル開発とスクラム実践）の受講者
INSERT INTO student_courses VALUES (26, 302);
INSERT INTO student_courses VALUES (26, 310);
INSERT INTO student_courses VALUES (26, 319);
INSERT INTO student_courses VALUES (26, 329);
INSERT INTO student_courses VALUES (26, 338);
INSERT INTO student_courses VALUES (26, 346);
INSERT INTO student_courses VALUES (26, 354);
INSERT INTO student_courses VALUES (26, 363);
INSERT INTO student_courses VALUES (26, 377);
INSERT INTO student_courses VALUES (26, 390);
INSERT INTO student_courses VALUES (26, 400);

-- 講座27（クロスプラットフォーム開発フレームワーク）の受講者
INSERT INTO student_courses VALUES (27, 307);
INSERT INTO student_courses VALUES (27, 313);
INSERT INTO student_courses VALUES (27, 320);
INSERT INTO student_courses VALUES (27, 328);
INSERT INTO student_courses VALUES (27, 335);
INSERT INTO student_courses VALUES (27, 343);
INSERT INTO student_courses VALUES (27, 350);
INSERT INTO student_courses VALUES (27, 357);
INSERT INTO student_courses VALUES (27, 363);
INSERT INTO student_courses VALUES (27, 380);
INSERT INTO student_courses VALUES (27, 387);
INSERT INTO student_courses VALUES (27, 399);

-- 講座28（ゲーム開発エンジン入門）の受講者
INSERT INTO student_courses VALUES (28, 327);
INSERT INTO student_courses VALUES (28, 332);
INSERT INTO student_courses VALUES (28, 339);
INSERT INTO student_courses VALUES (28, 345);
INSERT INTO student_courses VALUES (28, 353);
INSERT INTO student_courses VALUES (28, 361);
INSERT INTO student_courses VALUES (28, 367);
INSERT INTO student_courses VALUES (28, 371);
INSERT INTO student_courses VALUES (28, 382);
INSERT INTO student_courses VALUES (28, 389);
INSERT INTO student_courses VALUES (28, 397);

-- 講座29（コードリファクタリングとクリーンコード）の受講者
INSERT INTO student_courses VALUES (29, 301);
INSERT INTO student_courses VALUES (29, 304);
INSERT INTO student_courses VALUES (29, 310);
INSERT INTO student_courses VALUES (29, 315);
INSERT INTO student_courses VALUES (29, 328);
INSERT INTO student_courses VALUES (29, 337);
INSERT INTO student_courses VALUES (29, 344);
INSERT INTO student_courses VALUES (29, 351);
INSERT INTO student_courses VALUES (29, 358);
INSERT INTO student_courses VALUES (29, 367);
INSERT INTO student_courses VALUES (29, 374);
INSERT INTO student_courses VALUES (29, 382);
INSERT INTO student_courses VALUES (29, 390);

-- 講座30（UIUXデザイン原則と実践）の受講者
INSERT INTO student_courses VALUES (30, 306);
INSERT INTO student_courses VALUES (30, 314);
INSERT INTO student_courses VALUES (30, 329);
INSERT INTO student_courses VALUES (30, 337);
INSERT INTO student_courses VALUES (30, 343);
INSERT INTO student_courses VALUES (30, 351);
INSERT INTO student_courses VALUES (30, 359);
INSERT INTO student_courses VALUES (30, 367);
INSERT INTO student_courses VALUES (30, 375);
INSERT INTO student_courses VALUES (30, 383);
INSERT INTO student_courses VALUES (30, 391);

-- 講座31（高度データ可視化技術）の受講者
INSERT INTO student_courses VALUES (31, 305);
INSERT INTO student_courses VALUES (31, 311);
INSERT INTO student_courses VALUES (31, 322);
INSERT INTO student_courses VALUES (31, 333);
INSERT INTO student_courses VALUES (31, 339);
INSERT INTO student_courses VALUES (31, 345);
INSERT INTO student_courses VALUES (31, 351);
INSERT INTO student_courses VALUES (31, 357);
INSERT INTO student_courses VALUES (31, 375);
INSERT INTO student_courses VALUES (31, 381);
INSERT INTO student_courses VALUES (31, 389);
INSERT INTO student_courses VALUES (31, 397);

-- 講座32（API設計と開発ベストプラクティス）の受講者
INSERT INTO student_courses VALUES (32, 303);
INSERT INTO student_courses VALUES (32, 315);
INSERT INTO student_courses VALUES (32, 321);
INSERT INTO student_courses VALUES (32, 331);
INSERT INTO student_courses VALUES (32, 341);
INSERT INTO student_courses VALUES (32, 347);
INSERT INTO student_courses VALUES (32, 353);
INSERT INTO student_courses VALUES (32, 359);
INSERT INTO student_courses VALUES (32, 365);
INSERT INTO student_courses VALUES (32, 371);
INSERT INTO student_courses VALUES (32, 380);
INSERT INTO student_courses VALUES (32, 393);

-- 講座33（エッジコンピューティングシステム）の受講者
INSERT INTO student_courses VALUES (33, 304);
INSERT INTO student_courses VALUES (33, 312);
INSERT INTO student_courses VALUES (33, 320);
INSERT INTO student_courses VALUES (33, 326);
INSERT INTO student_courses VALUES (33, 334);
INSERT INTO student_courses VALUES (33, 342);
INSERT INTO student_courses VALUES (33, 350);
INSERT INTO student_courses VALUES (33, 360);
INSERT INTO student_courses VALUES (33, 368);
INSERT INTO student_courses VALUES (33, 377);
INSERT INTO student_courses VALUES (33, 385);
INSERT INTO student_courses VALUES (33, 393);

-- 講座34（ソフトウェアテスト自動化）の受講者
INSERT INTO student_courses VALUES (34, 306);
INSERT INTO student_courses VALUES (34, 318);
INSERT INTO student_courses VALUES (34, 324);
INSERT INTO student_courses VALUES (34, 332);
INSERT INTO student_courses VALUES (34, 340);
INSERT INTO student_courses VALUES (34, 348);
INSERT INTO student_courses VALUES (34, 356);
INSERT INTO student_courses VALUES (34, 360);
INSERT INTO student_courses VALUES (34, 368);
INSERT INTO student_courses VALUES (34, 384);
INSERT INTO student_courses VALUES (34, 392);
INSERT INTO student_courses VALUES (34, 400);

-- 講座35（デジタルトランスフォーメーション戦略）の受講者
INSERT INTO student_courses VALUES (35, 313);
INSERT INTO student_courses VALUES (35, 320);
INSERT INTO student_courses VALUES (35, 334);
INSERT INTO student_courses VALUES (35, 341);
INSERT INTO student_courses VALUES (35, 348);
INSERT INTO student_courses VALUES (35, 355);
INSERT INTO student_courses VALUES (35, 362);
INSERT INTO student_courses VALUES (35, 376);
INSERT INTO student_courses VALUES (35, 390);

-- 講座36（スマートコントラクト開発）の受講者
INSERT INTO student_courses VALUES (36, 327);
INSERT INTO student_courses VALUES (36, 335);
INSERT INTO student_courses VALUES (36, 342);
INSERT INTO student_courses VALUES (36, 349);
INSERT INTO student_courses VALUES (36, 356);
INSERT INTO student_courses VALUES (36, 363);
INSERT INTO student_courses VALUES (36, 378);
INSERT INTO student_courses VALUES (36, 385);
INSERT INTO student_courses VALUES (36, 391);
INSERT INTO student_courses VALUES (36, 398);

-- 講座37（ビッグデータ処理フレームワーク）の受講者
INSERT INTO student_courses VALUES (37, 305);
INSERT INTO student_courses VALUES (37, 313);
INSERT INTO student_courses VALUES (37, 324);
INSERT INTO student_courses VALUES (37, 333);
INSERT INTO student_courses VALUES (37, 339);
INSERT INTO student_courses VALUES (37, 345);
INSERT INTO student_courses VALUES (37, 357);
INSERT INTO student_courses VALUES (37, 369);
INSERT INTO student_courses VALUES (37, 381);
INSERT INTO student_courses VALUES (37, 387);
INSERT INTO student_courses VALUES (37, 393);
INSERT INTO student_courses VALUES (37, 399);

-- 講座38（ネットワーク仮想化技術）の受講者
INSERT INTO student_courses VALUES (38, 308);
INSERT INTO student_courses VALUES (38, 316);
INSERT INTO student_courses VALUES (38, 325);
INSERT INTO student_courses VALUES (38, 332);
INSERT INTO student_courses VALUES (38, 340);
INSERT INTO student_courses VALUES (38, 348);
INSERT INTO student_courses VALUES (38, 354);
INSERT INTO student_courses VALUES (38, 362);
INSERT INTO student_courses VALUES (38, 370);
INSERT INTO student_courses VALUES (38, 378);
INSERT INTO student_courses VALUES (38, 386);
INSERT INTO student_courses VALUES (38, 394);

-- 講座39（リアルタイムシステム設計）の受講者
INSERT INTO student_courses VALUES (39, 302);
INSERT INTO student_courses VALUES (39, 310);
INSERT INTO student_courses VALUES (39, 323);
INSERT INTO student_courses VALUES (39, 331);
INSERT INTO student_courses VALUES (39, 344);
INSERT INTO student_courses VALUES (39, 352);
INSERT INTO student_courses VALUES (39, 361);
INSERT INTO student_courses VALUES (39, 373);
INSERT INTO student_courses VALUES (39, 382);
INSERT INTO student_courses VALUES (39, 391);
INSERT INTO student_courses VALUES (39, 400);

-- 講座40（ソフトウェアアーキテクチャパターン）の受講者
INSERT INTO student_courses VALUES (40, 302);
INSERT INTO student_courses VALUES (40, 310);
INSERT INTO student_courses VALUES (40, 328);
INSERT INTO student_courses VALUES (40, 336);
INSERT INTO student_courses VALUES (40, 344);
INSERT INTO student_courses VALUES (40, 352);
INSERT INTO student_courses VALUES (40, 360);
INSERT INTO student_courses VALUES (40, 368);
INSERT INTO student_courses VALUES (40, 376);
INSERT INTO student_courses VALUES (40, 384);
INSERT INTO student_courses VALUES (40, 392);
INSERT INTO student_courses VALUES (40, 400);

-- 講座41（クラウドセキュリティと最適化）の受講者
INSERT INTO student_courses VALUES (41, 301);
INSERT INTO student_courses VALUES (41, 309);
INSERT INTO student_courses VALUES (41, 317);
INSERT INTO student_courses VALUES (41, 325);
INSERT INTO student_courses VALUES (41, 337);
INSERT INTO student_courses VALUES (41, 345);
INSERT INTO student_courses VALUES (41, 353);
INSERT INTO student_courses VALUES (41, 361);
INSERT INTO student_courses VALUES (41, 369);
INSERT INTO student_courses VALUES (41, 377);
INSERT INTO student_courses VALUES (41, 385);
INSERT INTO student_courses VALUES (41, 393);

-- 講座42（プロダクトマネジメント実践）の受講者
INSERT INTO student_courses VALUES (42, 303);
INSERT INTO student_courses VALUES (42, 319);
INSERT INTO student_courses VALUES (42, 329);
INSERT INTO student_courses VALUES (42, 338);
INSERT INTO student_courses VALUES (42, 346);
INSERT INTO student_courses VALUES (42, 354);
INSERT INTO student_courses VALUES (42, 367);
INSERT INTO student_courses VALUES (42, 380);
INSERT INTO student_courses VALUES (42, 396);

-- 講座43（ナチュラルランゲージプロセッシング）の受講者
INSERT INTO student_courses VALUES (43, 305);
INSERT INTO student_courses VALUES (43, 311);
INSERT INTO student_courses VALUES (43, 318);
INSERT INTO student_courses VALUES (43, 322);
INSERT INTO student_courses VALUES (43, 333);
INSERT INTO student_courses VALUES (43, 347);
INSERT INTO student_courses VALUES (43, 357);
INSERT INTO student_courses VALUES (43, 364);
INSERT INTO student_courses VALUES (43, 375);
INSERT INTO student_courses VALUES (43, 381);
INSERT INTO student_courses VALUES (43, 389);
INSERT INTO student_courses VALUES (43, 397);

-- 講座44（コンピュータビジョンと画像処理）の受講者
INSERT INTO student_courses VALUES (44, 312);
INSERT INTO student_courses VALUES (44, 321);
INSERT INTO student_courses VALUES (44, 330);
INSERT INTO student_courses VALUES (44, 339);
INSERT INTO student_courses VALUES (44, 347);
INSERT INTO student_courses VALUES (44, 356);
INSERT INTO student_courses VALUES (44, 365);
INSERT INTO student_courses VALUES (44, 373);
INSERT INTO student_courses VALUES (44, 382);
INSERT INTO student_courses VALUES (44, 389);
INSERT INTO student_courses VALUES (44, 397);

-- 講座45（グラフデータベースと知識グラフ）の受講者
INSERT INTO student_courses VALUES (45, 304);
INSERT INTO student_courses VALUES (45, 313);
INSERT INTO student_courses VALUES (45, 324);
INSERT INTO student_courses VALUES (45, 333);
INSERT INTO student_courses VALUES (45, 342);
INSERT INTO student_courses VALUES (45, 351);
INSERT INTO student_courses VALUES (45, 360);
INSERT INTO student_courses VALUES (45, 369);
INSERT INTO student_courses VALUES (45, 378);
INSERT INTO student_courses VALUES (45, 387);
INSERT INTO student_courses VALUES (45, 396);

-- 講座46（インフラストラクチャー・アズ・コード）の受講者
INSERT INTO student_courses VALUES (46, 302);
INSERT INTO student_courses VALUES (46, 314);
INSERT INTO student_courses VALUES (46, 326);
INSERT INTO student_courses VALUES (46, 336);
INSERT INTO student_courses VALUES (46, 344);
INSERT INTO student_courses VALUES (46, 352);
INSERT INTO student_courses VALUES (46, 360);
INSERT INTO student_courses VALUES (46, 368);
INSERT INTO student_courses VALUES (46, 376);
INSERT INTO student_courses VALUES (46, 384);
INSERT INTO student_courses VALUES (46, 392);

-- 講座47（ウェアラブルデバイス開発）の受講者
INSERT INTO student_courses VALUES (47, 309);
INSERT INTO student_courses VALUES (47, 319);
INSERT INTO student_courses VALUES (47, 325);
INSERT INTO student_courses VALUES (47, 331);
INSERT INTO student_courses VALUES (47, 339);
INSERT INTO student_courses VALUES (47, 345);
INSERT INTO student_courses VALUES (47, 353);
INSERT INTO student_courses VALUES (47, 359);
INSERT INTO student_courses VALUES (47, 370);
INSERT INTO student_courses VALUES (47, 383);
INSERT INTO student_courses VALUES (47, 394);

-- 講座48（シミュレーションとモデリング手法）の受講者
INSERT INTO student_courses VALUES (48, 325);
INSERT INTO student_courses VALUES (48, 332);
INSERT INTO student_courses VALUES (48, 340);
INSERT INTO student_courses VALUES (48, 346);
INSERT INTO student_courses VALUES (48, 353);
INSERT INTO student_courses VALUES (48, 361);
INSERT INTO student_courses VALUES (48, 368);
INSERT INTO student_courses VALUES (48, 374);
INSERT INTO student_courses VALUES (48, 382);
INSERT INTO student_courses VALUES (48, 389);
INSERT INTO student_courses VALUES (48, 397);

-- ---------------------------------------
-- 講師スケジュール管理テーブルのデータ
-- ---------------------------------------
-- 2024年1月の不在データ
INSERT INTO teacher_unavailability (teacher_id, start_date, end_date, reason) 
VALUES (101, '2024-01-04', '2024-01-05', '冬季休暇');
INSERT INTO teacher_unavailability (teacher_id, start_date, end_date, reason) 
VALUES (103, '2024-01-09', '2024-01-09', '全体教員会議');
INSERT INTO teacher_unavailability (teacher_id, start_date, end_date, reason) 
VALUES (105, '2024-01-15', '2024-01-19', '海外研究交流');
INSERT INTO teacher_unavailability (teacher_id, start_date, end_date, reason) 
VALUES (107, '2024-01-22', '2024-01-22', '大学評議会');
INSERT INTO teacher_unavailability (teacher_id, start_date, end_date, reason) 
VALUES (109, '2024-01-11', '2024-01-12', '技術カンファレンス参加');
INSERT INTO teacher_unavailability (teacher_id, start_date, end_date, reason) 
VALUES (112, '2024-01-24', '2024-01-26', '量子コンピューティングワークショップ');
INSERT INTO teacher_unavailability (teacher_id, start_date, end_date, reason) 
VALUES (115, '2024-01-29', '2024-01-30', '機械学習研究会');
INSERT INTO teacher_unavailability (teacher_id, start_date, end_date, reason) 
VALUES (118, '2024-01-08', '2024-01-08', '病欠');

-- 2024年2月の不在データ
INSERT INTO teacher_unavailability (teacher_id, start_date, end_date, reason) 
VALUES (102, '2024-02-05', '2024-02-05', '学部カリキュラム会議');
INSERT INTO teacher_unavailability (teacher_id, start_date, end_date, reason) 
VALUES (104, '2024-02-12', '2024-02-16', 'Web技術国際会議');
INSERT INTO teacher_unavailability (teacher_id, start_date, end_date, reason) 
VALUES (106, '2024-02-19', '2024-02-19', '研究グループミーティング');
INSERT INTO teacher_unavailability (teacher_id, start_date, end_date, reason) 
VALUES (108, '2024-02-22', '2024-02-23', 'クラウドテクノロジーセミナー');
INSERT INTO teacher_unavailability (teacher_id, start_date, end_date, reason) 
VALUES (110, '2024-02-07', '2024-02-09', 'IoTデバイス開発ワークショップ');
INSERT INTO teacher_unavailability (teacher_id, start_date, end_date, reason) 
VALUES (113, '2024-02-13', '2024-02-13', '健康診断');
INSERT INTO teacher_unavailability (teacher_id, start_date, end_date, reason) 
VALUES (116, '2024-02-20', '2024-02-21', 'エンタープライズアーキテクチャセミナー');
INSERT INTO teacher_unavailability (teacher_id, start_date, end_date, reason) 
VALUES (119, '2024-02-26', '2024-02-29', 'ゲーム開発カンファレンス');

-- 2024年3月の不在データ
INSERT INTO teacher_unavailability (teacher_id, start_date, end_date, reason) 
VALUES (101, '2024-03-01', '2024-03-01', '卒業式出席');
INSERT INTO teacher_unavailability (teacher_id, start_date, end_date, reason) 
VALUES (103, '2024-03-04', '2024-03-08', '春季休暇');
INSERT INTO teacher_unavailability (teacher_id, start_date, end_date, reason) 
VALUES (105, '2024-03-11', '2024-03-15', 'データベース国際会議');
INSERT INTO teacher_unavailability (teacher_id, start_date, end_date, reason) 
VALUES (107, '2024-03-18', '2024-03-22', 'サイバーセキュリティセミナー');
INSERT INTO teacher_unavailability (teacher_id, start_date, end_date, reason) 
VALUES (111, '2024-03-04', '2024-03-06', 'DevOpsカンファレンス');
INSERT INTO teacher_unavailability (teacher_id, start_date, end_date, reason) 
VALUES (114, '2024-03-13', '2024-03-15', 'コンテナ技術ワークショップ');
INSERT INTO teacher_unavailability (teacher_id, start_date, end_date, reason) 
VALUES (117, '2024-03-18', '2024-03-19', 'クラウドセキュリティ研修');
INSERT INTO teacher_unavailability (teacher_id, start_date, end_date, reason) 
VALUES (120, '2024-03-25', '2024-03-29', 'デザイン思考ワークショップ');

-- 2024年4月の不在データ（新学期開始）
INSERT INTO teacher_unavailability (teacher_id, start_date, end_date, reason) 
VALUES (102, '2024-04-01', '2024-04-01', '入学式出席');
INSERT INTO teacher_unavailability (teacher_id, start_date, end_date, reason) 
VALUES (104, '2024-04-08', '2024-04-08', '学部会議');
INSERT INTO teacher_unavailability (teacher_id, start_date, end_date, reason) 
VALUES (106, '2024-04-15', '2024-04-19', 'AI研究カンファレンス');
INSERT INTO teacher_unavailability (teacher_id, start_date, end_date, reason) 
VALUES (108, '2024-04-22', '2024-04-22', '研究ミーティング');
INSERT INTO teacher_unavailability (teacher_id, start_date, end_date, reason) 
VALUES (109, '2024-04-03', '2024-04-05', 'ブロックチェーンサミット');
INSERT INTO teacher_unavailability (teacher_id, start_date, end_date, reason) 
VALUES (112, '2024-04-10', '2024-04-10', '病欠');
INSERT INTO teacher_unavailability (teacher_id, start_date, end_date, reason) 
VALUES (115, '2024-04-17', '2024-04-19', 'データサイエンスフォーラム');
INSERT INTO teacher_unavailability (teacher_id, start_date, end_date, reason) 
VALUES (118, '2024-04-24', '2024-04-26', 'フレームワーク開発会議');

-- 2024年5月の不在データ
INSERT INTO teacher_unavailability (teacher_id, start_date, end_date, reason) 
VALUES (101, '2024-05-01', '2024-05-03', 'ゴールデンウィーク休暇');
INSERT INTO teacher_unavailability (teacher_id, start_date, end_date, reason) 
VALUES (103, '2024-05-13', '2024-05-14', 'プロジェクト管理セミナー');
INSERT INTO teacher_unavailability (teacher_id, start_date, end_date, reason) 
VALUES (105, '2024-05-20', '2024-05-20', '研究室ミーティング');
INSERT INTO teacher_unavailability (teacher_id, start_date, end_date, reason) 
VALUES (107, '2024-05-27', '2024-05-31', 'セキュリティカンファレンス');
INSERT INTO teacher_unavailability (teacher_id, start_date, end_date, reason) 
VALUES (110, '2024-05-08', '2024-05-10', 'エッジコンピューティング研究会');
INSERT INTO teacher_unavailability (teacher_id, start_date, end_date, reason) 
VALUES (113, '2024-05-15', '2024-05-17', 'マイクロサービス構築ワークショップ');
INSERT INTO teacher_unavailability (teacher_id, start_date, end_date, reason) 
VALUES (116, '2024-05-22', '2024-05-23', 'デジタルトランスフォーメーション会議');
INSERT INTO teacher_unavailability (teacher_id, start_date, end_date, reason) 
VALUES (119, '2024-05-29', '2024-05-30', 'VR/AR開発セミナー');

-- 2024年6月の不在データ
INSERT INTO teacher_unavailability (teacher_id, start_date, end_date, reason) 
VALUES (102, '2024-06-03', '2024-06-04', 'UNIX技術カンファレンス');
INSERT INTO teacher_unavailability (teacher_id, start_date, end_date, reason) 
VALUES (104, '2024-06-10', '2024-06-14', 'Web開発国際フォーラム');
INSERT INTO teacher_unavailability (teacher_id, start_date, end_date, reason) 
VALUES (106, '2024-06-17', '2024-06-18', '機械学習ワークショップ');
INSERT INTO teacher_unavailability (teacher_id, start_date, end_date, reason) 
VALUES (108, '2024-06-24', '2024-06-28', 'クラウドネイティブカンファレンス');
INSERT INTO teacher_unavailability (teacher_id, start_date, end_date, reason) 
VALUES (111, '2024-06-05', '2024-06-07', 'CI/CDパイプライン構築セミナー');
INSERT INTO teacher_unavailability (teacher_id, start_date, end_date, reason) 
VALUES (114, '2024-06-12', '2024-06-13', 'Kubernetes認定研修');
INSERT INTO teacher_unavailability (teacher_id, start_date, end_date, reason) 
VALUES (117, '2024-06-19', '2024-06-21', 'サーバーレスアーキテクチャ会議');
INSERT INTO teacher_unavailability (teacher_id, start_date, end_date, reason) 
VALUES (120, '2024-06-26', '2024-06-27', 'UXデザインセミナー');

-- 2024年後半の講師スケジュール管理データ

-- 2024年7月の不在データ（期末試験期間と夏季休暇開始）
INSERT INTO teacher_unavailability (teacher_id, start_date, end_date, reason) 
VALUES (101, '2024-07-01', '2024-07-05', '期末試験監督');
INSERT INTO teacher_unavailability (teacher_id, start_date, end_date, reason) 
VALUES (103, '2024-07-08', '2024-07-12', '夏季研修指導');
INSERT INTO teacher_unavailability (teacher_id, start_date, end_date, reason) 
VALUES (105, '2024-07-16', '2024-07-26', '夏季休暇');
INSERT INTO teacher_unavailability (teacher_id, start_date, end_date, reason) 
VALUES (107, '2024-07-22', '2024-07-24', '成績評価会議');
INSERT INTO teacher_unavailability (teacher_id, start_date, end_date, reason) 
VALUES (109, '2024-07-03', '2024-07-05', '暗号技術セミナー');
INSERT INTO teacher_unavailability (teacher_id, start_date, end_date, reason) 
VALUES (112, '2024-07-15', '2024-07-19', '量子アルゴリズム研究会');
INSERT INTO teacher_unavailability (teacher_id, start_date, end_date, reason) 
VALUES (115, '2024-07-24', '2024-07-31', '夏季休暇');
INSERT INTO teacher_unavailability (teacher_id, start_date, end_date, reason) 
VALUES (118, '2024-07-08', '2024-07-12', 'モバイル開発カンファレンス');

-- 2024年8月の不在データ（夏季休暇期間）
INSERT INTO teacher_unavailability (teacher_id, start_date, end_date, reason) 
VALUES (102, '2024-08-01', '2024-08-16', '夏季休暇');
INSERT INTO teacher_unavailability (teacher_id, start_date, end_date, reason) 
VALUES (104, '2024-08-05', '2024-08-23', '夏季休暇および国際研究交流');
INSERT INTO teacher_unavailability (teacher_id, start_date, end_date, reason) 
VALUES (106, '2024-08-12', '2024-08-16', 'データサイエンスサマースクール講師');
INSERT INTO teacher_unavailability (teacher_id, start_date, end_date, reason) 
VALUES (108, '2024-08-19', '2024-08-30', '夏季休暇');
INSERT INTO teacher_unavailability (teacher_id, start_date, end_date, reason) 
VALUES (110, '2024-08-05', '2024-08-09', 'IoTサマーワークショップ');
INSERT INTO teacher_unavailability (teacher_id, start_date, end_date, reason) 
VALUES (113, '2024-08-12', '2024-08-23', '夏季休暇');
INSERT INTO teacher_unavailability (teacher_id, start_date, end_date, reason) 
VALUES (116, '2024-08-01', '2024-08-09', '夏季休暇');
INSERT INTO teacher_unavailability (teacher_id, start_date, end_date, reason) 
VALUES (119, '2024-08-19', '2024-08-30', '夏季休暇');

-- 2024年9月の不在データ（夏季休暇終了、新学期準備）
INSERT INTO teacher_unavailability (teacher_id, start_date, end_date, reason) 
VALUES (101, '2024-09-02', '2024-09-06', 'カリキュラム開発会議');
INSERT INTO teacher_unavailability (teacher_id, start_date, end_date, reason) 
VALUES (103, '2024-09-09', '2024-09-13', 'プロジェクト管理国際会議');
INSERT INTO teacher_unavailability (teacher_id, start_date, end_date, reason) 
VALUES (105, '2024-09-17', '2024-09-18', '学部運営会議');
INSERT INTO teacher_unavailability (teacher_id, start_date, end_date, reason) 
VALUES (107, '2024-09-24', '2024-09-27', 'セキュリティアップデート研修');
INSERT INTO teacher_unavailability (teacher_id, start_date, end_date, reason) 
VALUES (111, '2024-09-09', '2024-09-11', 'DevOpsワークショップ');
INSERT INTO teacher_unavailability (teacher_id, start_date, end_date, reason) 
VALUES (114, '2024-09-16', '2024-09-20', 'コンテナオーケストレーション研修');
INSERT INTO teacher_unavailability (teacher_id, start_date, end_date, reason) 
VALUES (117, '2024-09-23', '2024-09-25', 'クラウドコンピューティング講演');
INSERT INTO teacher_unavailability (teacher_id, start_date, end_date, reason) 
VALUES (120, '2024-09-02', '2024-09-02', '病欠');

-- 2024年10月の不在データ（新学期本格開始）
INSERT INTO teacher_unavailability (teacher_id, start_date, end_date, reason) 
VALUES (102, '2024-10-07', '2024-10-07', '研究室ミーティング');
INSERT INTO teacher_unavailability (teacher_id, start_date, end_date, reason) 
VALUES (104, '2024-10-14', '2024-10-18', 'フロントエンド開発カンファレンス');
INSERT INTO teacher_unavailability (teacher_id, start_date, end_date, reason) 
VALUES (106, '2024-10-21', '2024-10-25', 'AI倫理シンポジウム');
INSERT INTO teacher_unavailability (teacher_id, start_date, end_date, reason) 
VALUES (108, '2024-10-28', '2024-10-31', 'クラウドセキュリティフォーラム');
INSERT INTO teacher_unavailability (teacher_id, start_date, end_date, reason) 
VALUES (109, '2024-10-02', '2024-10-04', 'ブロックチェーン応用研究会');
INSERT INTO teacher_unavailability (teacher_id, start_date, end_date, reason) 
VALUES (112, '2024-10-09', '2024-10-11', '量子コンピューティング国際会議');
INSERT INTO teacher_unavailability (teacher_id, start_date, end_date, reason) 
VALUES (115, '2024-10-16', '2024-10-16', '研究室ミーティング');
INSERT INTO teacher_unavailability (teacher_id, start_date, end_date, reason) 
VALUES (118, '2024-10-23', '2024-10-25', 'クロスプラットフォーム開発セミナー');

-- 2024年11月の不在データ
INSERT INTO teacher_unavailability (teacher_id, start_date, end_date, reason) 
VALUES (101, '2024-11-04', '2024-11-08', 'プログラミング教育カンファレンス');
INSERT INTO teacher_unavailability (teacher_id, start_date, end_date, reason) 
VALUES (103, '2024-11-11', '2024-11-15', 'アジャイル開発国際フォーラム');
INSERT INTO teacher_unavailability (teacher_id, start_date, end_date, reason) 
VALUES (105, '2024-11-18', '2024-11-19', 'データベース設計セミナー');
INSERT INTO teacher_unavailability (teacher_id, start_date, end_date, reason) 
VALUES (107, '2024-11-25', '2024-11-29', 'サイバーセキュリティサミット');
INSERT INTO teacher_unavailability (teacher_id, start_date, end_date, reason) 
VALUES (110, '2024-11-06', '2024-11-08', 'スマートシティIoTカンファレンス');
INSERT INTO teacher_unavailability (teacher_id, start_date, end_date, reason) 
VALUES (113, '2024-11-13', '2024-11-15', 'マイクロサービスワークショップ');
INSERT INTO teacher_unavailability (teacher_id, start_date, end_date, reason) 
VALUES (116, '2024-11-20', '2024-11-22', 'エンタープライズアーキテクチャフォーラム');
INSERT INTO teacher_unavailability (teacher_id, start_date, end_date, reason) 
VALUES (119, '2024-11-25', '2024-11-25', '病欠');

-- 2024年12月の不在データ（期末試験期間と冬季休暇）
INSERT INTO teacher_unavailability (teacher_id, start_date, end_date, reason) 
VALUES (102, '2024-12-02', '2024-12-06', '期末試験監督');
INSERT INTO teacher_unavailability (teacher_id, start_date, end_date, reason) 
VALUES (104, '2024-12-09', '2024-12-09', '成績評価会議');
INSERT INTO teacher_unavailability (teacher_id, start_date, end_date, reason) 
VALUES (106, '2024-12-16', '2024-12-16', '研究グループミーティング');
INSERT INTO teacher_unavailability (teacher_id, start_date, end_date, reason) 
VALUES (108, '2024-12-23', '2024-12-31', '冬季休暇');
INSERT INTO teacher_unavailability (teacher_id, start_date, end_date, reason) 
VALUES (111, '2024-12-04', '2024-12-06', 'DevOps実践ワークショップ');
INSERT INTO teacher_unavailability (teacher_id, start_date, end_date, reason) 
VALUES (114, '2024-12-11', '2024-12-13', 'インフラ自動化セミナー');
INSERT INTO teacher_unavailability (teacher_id, start_date, end_date, reason) 
VALUES (117, '2024-12-18', '2024-12-18', '大学運営会議');
INSERT INTO teacher_unavailability (teacher_id, start_date, end_date, reason) 
VALUES (120, '2024-12-23', '2024-12-31', '冬季休暇');

-- 2025年前半の講師スケジュール管理データ（既存データに追加）

-- 2025年1月の不在データ（冬季休暇と新学期準備）
INSERT INTO teacher_unavailability (teacher_id, start_date, end_date, reason) 
VALUES (101, '2025-01-01', '2025-01-07', '冬季休暇');
INSERT INTO teacher_unavailability (teacher_id, start_date, end_date, reason) 
VALUES (103, '2025-01-13', '2025-01-14', 'カリキュラム改定会議');
INSERT INTO teacher_unavailability (teacher_id, start_date, end_date, reason) 
VALUES (105, '2025-01-20', '2025-01-24', 'データベース技術カンファレンス');
INSERT INTO teacher_unavailability (teacher_id, start_date, end_date, reason) 
VALUES (107, '2025-01-27', '2025-01-31', 'サイバーセキュリティ最新動向セミナー');
INSERT INTO teacher_unavailability (teacher_id, start_date, end_date, reason) 
VALUES (109, '2025-01-08', '2025-01-10', 'フィンテックブロックチェーンフォーラム');
INSERT INTO teacher_unavailability (teacher_id, start_date, end_date, reason) 
VALUES (112, '2025-01-15', '2025-01-17', '量子情報科学シンポジウム');
INSERT INTO teacher_unavailability (teacher_id, start_date, end_date, reason) 
VALUES (115, '2025-01-22', '2025-01-23', '機械学習モデルワークショップ');
INSERT INTO teacher_unavailability (teacher_id, start_date, end_date, reason) 
VALUES (118, '2025-01-29', '2025-01-31', 'フレームワーク開発セミナー');

-- 2025年2月の不在データ
INSERT INTO teacher_unavailability (teacher_id, start_date, end_date, reason) 
VALUES (102, '2025-02-03', '2025-02-05', 'UNIX/Linux管理者カンファレンス');
INSERT INTO teacher_unavailability (teacher_id, start_date, end_date, reason) 
VALUES (104, '2025-02-10', '2025-02-14', 'フルスタック開発セミナー');
INSERT INTO teacher_unavailability (teacher_id, start_date, end_date, reason) 
VALUES (106, '2025-02-17', '2025-02-17', '研究グループミーティング');
INSERT INTO teacher_unavailability (teacher_id, start_date, end_date, reason) 
VALUES (108, '2025-02-24', '2025-02-28', 'クラウドソリューション国際カンファレンス');
INSERT INTO teacher_unavailability (teacher_id, start_date, end_date, reason) 
VALUES (110, '2025-02-05', '2025-02-07', 'エッジAIワークショップ');
INSERT INTO teacher_unavailability (teacher_id, start_date, end_date, reason) 
VALUES (113, '2025-02-12', '2025-02-12', '健康診断');
INSERT INTO teacher_unavailability (teacher_id, start_date, end_date, reason) 
VALUES (116, '2025-02-19', '2025-02-21', 'デジタル変革フォーラム');
INSERT INTO teacher_unavailability (teacher_id, start_date, end_date, reason) 
VALUES (119, '2025-02-26', '2025-02-28', 'ゲームエンジンカンファレンス');

-- 2025年3月の不在データ（学年末）
INSERT INTO teacher_unavailability (teacher_id, start_date, end_date, reason) 
VALUES (101, '2025-03-03', '2025-03-04', '卒業研究発表会');
INSERT INTO teacher_unavailability (teacher_id, start_date, end_date, reason) 
VALUES (103, '2025-03-07', '2025-03-07', '卒業式出席');
INSERT INTO teacher_unavailability (teacher_id, start_date, end_date, reason) 
VALUES (105, '2025-03-17', '2025-03-21', '春季休暇');
INSERT INTO teacher_unavailability (teacher_id, start_date, end_date, reason) 
VALUES (107, '2025-03-24', '2025-03-28', 'セキュリティコンプライアンスセミナー');
INSERT INTO teacher_unavailability (teacher_id, start_date, end_date, reason) 
VALUES (111, '2025-03-05', '2025-03-07', 'CI/CD最新技術カンファレンス');
INSERT INTO teacher_unavailability (teacher_id, start_date, end_date, reason) 
VALUES (114, '2025-03-12', '2025-03-14', 'Kubernetes上級者研修');
INSERT INTO teacher_unavailability (teacher_id, start_date, end_date, reason) 
VALUES (117, '2025-03-19', '2025-03-21', 'サーバーレスコンピューティングフォーラム');
INSERT INTO teacher_unavailability (teacher_id, start_date, end_date, reason) 
VALUES (120, '2025-03-17', '2025-03-21', '春季休暇');

-- 2025年4月の不在データ（新学年開始）
INSERT INTO teacher_unavailability (teacher_id, start_date, end_date, reason) 
VALUES (102, '2025-04-01', '2025-04-01', '入学式出席');
INSERT INTO teacher_unavailability (teacher_id, start_date, end_date, reason) 
VALUES (104, '2025-04-07', '2025-04-07', '学部会議');
INSERT INTO teacher_unavailability (teacher_id, start_date, end_date, reason) 
VALUES (106, '2025-04-14', '2025-04-18', 'データ可視化国際フォーラム');
INSERT INTO teacher_unavailability (teacher_id, start_date, end_date, reason) 
VALUES (108, '2025-04-21', '2025-04-21', '研究室ミーティング');
INSERT INTO teacher_unavailability (teacher_id, start_date, end_date, reason) 
VALUES (109, '2025-04-02', '2025-04-04', '暗号資産テクノロジー会議');
INSERT INTO teacher_unavailability (teacher_id, start_date, end_date, reason) 
VALUES (112, '2025-04-09', '2025-04-11', 'コンピュータサイエンス国際会議');
INSERT INTO teacher_unavailability (teacher_id, start_date, end_date, reason) 
VALUES (115, '2025-04-16', '2025-04-18', '神経回路モデルカンファレンス');
INSERT INTO teacher_unavailability (teacher_id, start_date, end_date, reason) 
VALUES (118, '2025-04-23', '2025-04-25', 'フレームワーク評価セミナー');

-- 2025年5月の不在データ
INSERT INTO teacher_unavailability (teacher_id, start_date, end_date, reason) 
VALUES (101, '2025-05-01', '2025-05-02', '会議出席');
INSERT INTO teacher_unavailability (teacher_id, start_date, end_date, reason) 
VALUES (102, '2025-05-22', '2025-05-26', '夏季休暇');
INSERT INTO teacher_unavailability (teacher_id, start_date, end_date, reason) 
VALUES (103, '2025-05-15', '2025-05-15', '病欠');
INSERT INTO teacher_unavailability (teacher_id, start_date, end_date, reason) 
VALUES (104, '2025-05-09', '2025-05-10', '学会発表');
INSERT INTO teacher_unavailability (teacher_id, start_date, end_date, reason) 
VALUES (105, '2025-05-16', '2025-05-16', '研究グループ会議');
INSERT INTO teacher_unavailability (teacher_id, start_date, end_date, reason) 
VALUES (106, '2025-05-20', '2025-05-24', '海外出張');
INSERT INTO teacher_unavailability (teacher_id, start_date, end_date, reason) 
VALUES (107, '2025-05-29', '2025-05-30', 'セキュリティカンファレンス出席');
INSERT INTO teacher_unavailability (teacher_id, start_date, end_date, reason) 
VALUES (108, '2025-06-05', '2025-06-09', '年次休暇');
INSERT INTO teacher_unavailability (teacher_id, start_date, end_date, reason) 
VALUES (101, '2025-05-27', '2025-05-27', '面接官');
INSERT INTO teacher_unavailability (teacher_id, start_date, end_date, reason) 
VALUES (102, '2025-06-03', '2025-06-03', '健康診断');
INSERT INTO teacher_unavailability (teacher_id, start_date, end_date, reason) 
VALUES (103, '2025-05-30', '2025-05-31', '個人的理由');
INSERT INTO teacher_unavailability (teacher_id, start_date, end_date, reason) 
VALUES (105, '2025-05-23', '2025-05-24', '親族の冠婚葬祭');

-- 2025年7月の不在データ（期末試験期間と夏季休暇開始）
INSERT INTO teacher_unavailability (teacher_id, start_date, end_date, reason) 
VALUES (101, '2025-07-01', '2025-07-04', '期末試験監督');
INSERT INTO teacher_unavailability (teacher_id, start_date, end_date, reason) 
VALUES (103, '2025-07-07', '2025-07-11', '夏季研修指導');
INSERT INTO teacher_unavailability (teacher_id, start_date, end_date, reason) 
VALUES (105, '2025-07-14', '2025-07-25', '夏季休暇');
INSERT INTO teacher_unavailability (teacher_id, start_date, end_date, reason) 
VALUES (107, '2025-07-21', '2025-07-23', '成績評価会議');
INSERT INTO teacher_unavailability (teacher_id, start_date, end_date, reason) 
VALUES (109, '2025-07-02', '2025-07-04', 'ブロックチェーン応用セミナー');
INSERT INTO teacher_unavailability (teacher_id, start_date, end_date, reason) 
VALUES (112, '2025-07-07', '2025-07-11', '夏季集中講義担当');
INSERT INTO teacher_unavailability (teacher_id, start_date, end_date, reason) 
VALUES (115, '2025-07-23', '2025-07-31', '夏季休暇');
INSERT INTO teacher_unavailability (teacher_id, start_date, end_date, reason) 
VALUES (118, '2025-07-09', '2025-07-11', 'モバイルUX研究会');

-- 2025年8月の不在データ（夏季休暇期間）
INSERT INTO teacher_unavailability (teacher_id, start_date, end_date, reason) 
VALUES (102, '2025-08-01', '2025-08-15', '夏季休暇');
INSERT INTO teacher_unavailability (teacher_id, start_date, end_date, reason) 
VALUES (104, '2025-08-04', '2025-08-22', '夏季休暇および国際研究交流');
INSERT INTO teacher_unavailability (teacher_id, start_date, end_date, reason) 
VALUES (106, '2025-08-11', '2025-08-15', 'AI夏季特別講座講師');
INSERT INTO teacher_unavailability (teacher_id, start_date, end_date, reason) 
VALUES (108, '2025-08-18', '2025-08-29', '夏季休暇');
INSERT INTO teacher_unavailability (teacher_id, start_date, end_date, reason) 
VALUES (110, '2025-08-04', '2025-08-08', 'IoTハッカソン参加');
INSERT INTO teacher_unavailability (teacher_id, start_date, end_date, reason) 
VALUES (113, '2025-08-11', '2025-08-22', '夏季休暇');
INSERT INTO teacher_unavailability (teacher_id, start_date, end_date, reason) 
VALUES (116, '2025-08-04', '2025-08-15', '夏季休暇');
INSERT INTO teacher_unavailability (teacher_id, start_date, end_date, reason) 
VALUES (119, '2025-08-18', '2025-08-29', '夏季休暇');

-- 2025年9月の不在データ（夏季休暇終了、新学期準備）
INSERT INTO teacher_unavailability (teacher_id, start_date, end_date, reason) 
VALUES (101, '2025-09-01', '2025-09-05', 'カリキュラム開発会議');
INSERT INTO teacher_unavailability (teacher_id, start_date, end_date, reason) 
VALUES (103, '2025-09-08', '2025-09-12', 'アジャイル開発国際会議');
INSERT INTO teacher_unavailability (teacher_id, start_date, end_date, reason) 
VALUES (105, '2025-09-16', '2025-09-17', '学部運営会議');
INSERT INTO teacher_unavailability (teacher_id, start_date, end_date, reason) 
VALUES (107, '2025-09-22', '2025-09-26', 'セキュリティ脆弱性対策セミナー');
INSERT INTO teacher_unavailability (teacher_id, start_date, end_date, reason) 
VALUES (111, '2025-09-08', '2025-09-10', 'インフラ自動化ワークショップ');
INSERT INTO teacher_unavailability (teacher_id, start_date, end_date, reason) 
VALUES (114, '2025-09-15', '2025-09-19', 'コンテナネットワーキング研修');
INSERT INTO teacher_unavailability (teacher_id, start_date, end_date, reason) 
VALUES (117, '2025-09-22', '2025-09-24', 'クラウドコスト最適化セミナー');
INSERT INTO teacher_unavailability (teacher_id, start_date, end_date, reason) 
VALUES (120, '2025-09-01', '2025-09-01', '病欠');

-- 2025年10月の不在データ（新学期本格開始）
INSERT INTO teacher_unavailability (teacher_id, start_date, end_date, reason) 
VALUES (102, '2025-10-06', '2025-10-06', '研究室ミーティング');
INSERT INTO teacher_unavailability (teacher_id, start_date, end_date, reason) 
VALUES (104, '2025-10-13', '2025-10-17', 'Web技術カンファレンス');
INSERT INTO teacher_unavailability (teacher_id, start_date, end_date, reason) 
VALUES (106, '2025-10-20', '2025-10-24', 'データサイエンスシンポジウム');
INSERT INTO teacher_unavailability (teacher_id, start_date, end_date, reason) 
VALUES (108, '2025-10-27', '2025-10-30', 'マルチクラウド戦略フォーラム');
INSERT INTO teacher_unavailability (teacher_id, start_date, end_date, reason) 
VALUES (109, '2025-10-01', '2025-10-03', 'Web3技術カンファレンス');
INSERT INTO teacher_unavailability (teacher_id, start_date, end_date, reason) 
VALUES (112, '2025-10-08', '2025-10-10', '量子アルゴリズムシンポジウム');
INSERT INTO teacher_unavailability (teacher_id, start_date, end_date, reason) 
VALUES (115, '2025-10-15', '2025-10-15', '研究室ミーティング');
INSERT INTO teacher_unavailability (teacher_id, start_date, end_date, reason) 
VALUES (118, '2025-10-22', '2025-10-24', 'クロスプラットフォーム開発カンファレンス');

-- 2025年11月の不在データ
INSERT INTO teacher_unavailability (teacher_id, start_date, end_date, reason) 
VALUES (101, '2025-11-03', '2025-11-07', 'コーディング教育シンポジウム');
INSERT INTO teacher_unavailability (teacher_id, start_date, end_date, reason) 
VALUES (103, '2025-11-10', '2025-11-14', 'プロジェクト管理国際会議');
INSERT INTO teacher_unavailability (teacher_id, start_date, end_date, reason) 
VALUES (105, '2025-11-17', '2025-11-18', 'ビッグデータ分析セミナー');
INSERT INTO teacher_unavailability (teacher_id, start_date, end_date, reason) 
VALUES (107, '2025-11-24', '2025-11-28', 'サイバーセキュリティカンファレンス');
INSERT INTO teacher_unavailability (teacher_id, start_date, end_date, reason) 
VALUES (110, '2025-11-05', '2025-11-07', 'スマートデバイス開発フォーラム');
INSERT INTO teacher_unavailability (teacher_id, start_date, end_date, reason) 
VALUES (113, '2025-11-12', '2025-11-14', 'システムアーキテクチャカンファレンス');
INSERT INTO teacher_unavailability (teacher_id, start_date, end_date, reason) 
VALUES (116, '2025-11-19', '2025-11-21', 'エンタープライズ戦略フォーラム');
INSERT INTO teacher_unavailability (teacher_id, start_date, end_date, reason) 
VALUES (119, '2025-11-24', '2025-11-24', '病欠');

-- 2025年12月の不在データ（期末試験期間と冬季休暇）
INSERT INTO teacher_unavailability (teacher_id, start_date, end_date, reason) 
VALUES (102, '2025-12-01', '2025-12-05', '期末試験監督');
INSERT INTO teacher_unavailability (teacher_id, start_date, end_date, reason) 
VALUES (104, '2025-12-08', '2025-12-08', '成績評価会議');
INSERT INTO teacher_unavailability (teacher_id, start_date, end_date, reason) 
VALUES (106, '2025-12-15', '2025-12-15', '研究グループミーティング');
INSERT INTO teacher_unavailability (teacher_id, start_date, end_date, reason) 
VALUES (108, '2025-12-22', '2025-12-31', '冬季休暇');
INSERT INTO teacher_unavailability (teacher_id, start_date, end_date, reason) 
VALUES (111, '2025-12-03', '2025-12-05', 'アプリケーション開発カンファレンス');
INSERT INTO teacher_unavailability (teacher_id, start_date, end_date, reason) 
VALUES (114, '2025-12-10', '2025-12-12', 'クラウドネイティブアプリケーションセミナー');
INSERT INTO teacher_unavailability (teacher_id, start_date, end_date, reason) 
VALUES (117, '2025-12-17', '2025-12-17', '大学運営会議');
INSERT INTO teacher_unavailability (teacher_id, start_date, end_date, reason) 
VALUES (120, '2025-12-22', '2025-12-31', '冬季休暇');

-- =========================================================
-- 学校データベース - 授業カレンダーテーブル (course_schedule)
-- =========================================================
-- 作成日: 2025年5月15日
-- 説明: 2024年度から2026年度までの授業スケジュールデータ
-- =========================================================

-- ---------------------------------------------------------
-- 2024年度 前期（1Q：4月-6月）スケジュール
-- ---------------------------------------------------------

-- 講座1（ITのための基礎知識）: 月曜1時限
INSERT INTO course_schedule (course_id, schedule_date, period_id, classroom_id, teacher_id) VALUES 
('1', '2024-04-08', 1, '102B', 101),
('1', '2024-04-15', 1, '102B', 101),
('1', '2024-04-22', 1, '102B', 101),
('1', '2024-05-06', 1, '102B', 101),
('1', '2024-05-13', 1, '102B', 101),
('1', '2024-05-20', 1, '102B', 101),
('1', '2024-05-27', 1, '102B', 101),
('1', '2024-06-03', 1, '102B', 101),
('1', '2024-06-10', 1, '102B', 101),
('1', '2024-06-17', 1, '102B', 101),
('1', '2024-06-24', 1, '102B', 101);

-- 講座2（UNIX入門）: 火曜3時限
INSERT INTO course_schedule (course_id, schedule_date, period_id, classroom_id, teacher_id) VALUES 
('2', '2024-04-09', 3, '101A', 102),
('2', '2024-04-16', 3, '101A', 102),
('2', '2024-04-23', 3, '101A', 102),
('2', '2024-05-07', 3, '101A', 102),
('2', '2024-05-14', 3, '101A', 102),
('2', '2024-05-21', 3, '101A', 102),
('2', '2024-05-28', 3, '101A', 102),
('2', '2024-06-04', 3, '101A', 102),
('2', '2024-06-11', 3, '101A', 102),
('2', '2024-06-18', 3, '101A', 102),
('2', '2024-06-25', 3, '101A', 102);

-- 講座3（Cプログラミング演習）: 水曜4時限
INSERT INTO course_schedule (course_id, schedule_date, period_id, classroom_id, teacher_id) VALUES 
('3', '2024-04-10', 4, '101A', 101),
('3', '2024-04-17', 4, '101A', 101),
('3', '2024-04-24', 4, '101A', 101),
('3', '2024-05-08', 4, '101A', 101),
('3', '2024-05-15', 4, '101A', 101),
('3', '2024-05-22', 4, '101A', 101),
('3', '2024-05-29', 4, '101A', 101),
('3', '2024-06-05', 4, '101A', 101),
('3', '2024-06-12', 4, '101A', 101),
('3', '2024-06-19', 4, '101A', 101),
('3', '2024-06-26', 4, '101A', 101);

-- 講座4（Webアプリケーション開発）: 月曜2時限
INSERT INTO course_schedule (course_id, schedule_date, period_id, classroom_id, teacher_id) VALUES 
('4', '2024-04-08', 2, '202D', 104),
('4', '2024-04-15', 2, '202D', 104),
('4', '2024-04-22', 2, '202D', 104),
('4', '2024-05-06', 2, '202D', 104),
('4', '2024-05-13', 2, '202D', 104),
('4', '2024-05-20', 2, '202D', 104),
('4', '2024-05-27', 2, '202D', 104),
('4', '2024-06-03', 2, '202D', 104),
('4', '2024-06-10', 2, '202D', 104),
('4', '2024-06-17', 2, '202D', 104),
('4', '2024-06-24', 2, '202D', 104);

-- 講座5（データベース設計と実装）: 火曜2時限
INSERT INTO course_schedule (course_id, schedule_date, period_id, classroom_id, teacher_id) VALUES 
('5', '2024-04-09', 2, '402H', 105),
('5', '2024-04-16', 2, '402H', 105),
('5', '2024-04-23', 2, '402H', 105),
('5', '2024-05-07', 2, '402H', 105),
('5', '2024-05-14', 2, '402H', 105),
('5', '2024-05-21', 2, '402H', 105),
('5', '2024-05-28', 2, '402H', 105),
('5', '2024-06-04', 2, '402H', 105),
('5', '2024-06-11', 2, '402H', 105),
('5', '2024-06-18', 2, '402H', 105),
('5', '2024-06-25', 2, '402H', 105);

-- 講座6（ネットワークセキュリティ）: 水曜3時限
INSERT INTO course_schedule (course_id, schedule_date, period_id, classroom_id, teacher_id) VALUES 
('6', '2024-04-10', 3, '301E', 107),
('6', '2024-04-17', 3, '301E', 107),
('6', '2024-04-24', 3, '301E', 107),
('6', '2024-05-08', 3, '301E', 107),
('6', '2024-05-15', 3, '301E', 107),
('6', '2024-05-22', 3, '301E', 107),
('6', '2024-05-29', 3, '301E', 107),
('6', '2024-06-05', 3, '301E', 107),
('6', '2024-06-12', 3, '301E', 107),
('6', '2024-06-19', 3, '301E', 107),
('6', '2024-06-26', 3, '301E', 107);

-- 講座7（AI・機械学習入門）: 木曜1時限
INSERT INTO course_schedule (course_id, schedule_date, period_id, classroom_id, teacher_id) VALUES 
('7', '2024-04-11', 1, '402H', 106),
('7', '2024-04-18', 1, '402H', 106),
('7', '2024-04-25', 1, '402H', 106),
('7', '2024-05-09', 1, '402H', 106),
('7', '2024-05-16', 1, '402H', 106),
('7', '2024-05-23', 1, '402H', 106),
('7', '2024-05-30', 1, '402H', 106),
('7', '2024-06-06', 1, '402H', 106),
('7', '2024-06-13', 1, '402H', 106),
('7', '2024-06-20', 1, '402H', 106),
('7', '2024-06-27', 1, '402H', 106);

-- 講座8（モバイルアプリ開発）: 金曜2時限
INSERT INTO course_schedule (course_id, schedule_date, period_id, classroom_id, teacher_id) VALUES 
('8', '2024-04-12', 2, '202D', 104),
('8', '2024-04-19', 2, '202D', 104),
('8', '2024-04-26', 2, '202D', 104),
('8', '2024-05-10', 2, '202D', 104),
('8', '2024-05-17', 2, '202D', 104),
('8', '2024-05-24', 2, '202D', 104),
('8', '2024-05-31', 2, '202D', 104),
('8', '2024-06-07', 2, '202D', 104),
('8', '2024-06-14', 2, '202D', 104),
('8', '2024-06-21', 2, '202D', 104),
('8', '2024-06-28', 2, '202D', 104);

-- 講座9（クラウドコンピューティング）: 木曜4時限
INSERT INTO course_schedule (course_id, schedule_date, period_id, classroom_id, teacher_id) VALUES 
('9', '2024-04-11', 4, '302F', 108),
('9', '2024-04-18', 4, '302F', 108),
('9', '2024-04-25', 4, '302F', 108),
('9', '2024-05-09', 4, '302F', 108),
('9', '2024-05-16', 4, '302F', 108),
('9', '2024-05-23', 4, '302F', 108),
('9', '2024-05-30', 4, '302F', 108),
('9', '2024-06-06', 4, '302F', 108),
('9', '2024-06-13', 4, '302F', 108),
('9', '2024-06-20', 4, '302F', 108),
('9', '2024-06-27', 4, '302F', 108);

-- 講座10（プロジェクト管理手法）: 金曜3時限
INSERT INTO course_schedule (course_id, schedule_date, period_id, classroom_id, teacher_id) VALUES 
('10', '2024-04-12', 3, '201C', 103),
('10', '2024-04-19', 3, '201C', 103),
('10', '2024-04-26', 3, '201C', 103),
('10', '2024-05-10', 3, '201C', 103),
('10', '2024-05-17', 3, '201C', 103),
('10', '2024-05-24', 3, '201C', 103),
('10', '2024-05-31', 3, '201C', 103),
('10', '2024-06-07', 3, '201C', 103),
('10', '2024-06-14', 3, '201C', 103),
('10', '2024-06-21', 3, '201C', 103),
('10', '2024-06-28', 3, '201C', 103);

-- 講座11（データ分析と可視化）: 火曜5時限
INSERT INTO course_schedule (course_id, schedule_date, period_id, classroom_id, teacher_id) VALUES 
('11', '2024-04-09', 5, '401G', 106),
('11', '2024-04-16', 5, '401G', 106),
('11', '2024-04-23', 5, '401G', 106),
('11', '2024-05-07', 5, '401G', 106),
('11', '2024-05-14', 5, '401G', 106),
('11', '2024-05-21', 5, '401G', 106),
('11', '2024-05-28', 5, '401G', 106),
('11', '2024-06-04', 5, '401G', 106),
('11', '2024-06-11', 5, '401G', 106),
('11', '2024-06-18', 5, '401G', 106),
('11', '2024-06-25', 5, '401G', 106);

-- 講座12（サイバーセキュリティ対策）: 水曜1時限
INSERT INTO course_schedule (course_id, schedule_date, period_id, classroom_id, teacher_id) VALUES 
('12', '2024-04-10', 1, '301E', 107),
('12', '2024-04-17', 1, '301E', 107),
('12', '2024-04-24', 1, '301E', 107),
('12', '2024-05-08', 1, '301E', 107),
('12', '2024-05-15', 1, '301E', 107),
('12', '2024-05-22', 1, '301E', 107),
('12', '2024-05-29', 1, '301E', 107),
('12', '2024-06-05', 1, '301E', 107),
('12', '2024-06-12', 1, '301E', 107),
('12', '2024-06-19', 1, '301E', 107),
('12', '2024-06-26', 1, '301E', 107);

-- 講座13（ブロックチェーン技術と応用）: 月曜3時限
INSERT INTO course_schedule (course_id, schedule_date, period_id, classroom_id, teacher_id) VALUES 
('13', '2024-04-08', 3, '402H', 109),
('13', '2024-04-15', 3, '402H', 109),
('13', '2024-04-22', 3, '402H', 109),
('13', '2024-05-06', 3, '402H', 109),
('13', '2024-05-13', 3, '402H', 109),
('13', '2024-05-20', 3, '402H', 109),
('13', '2024-05-27', 3, '402H', 109),
('13', '2024-06-03', 3, '402H', 109),
('13', '2024-06-10', 3, '402H', 109),
('13', '2024-06-17', 3, '402H', 109),
('13', '2024-06-24', 3, '402H', 109);

-- 講座14（IoTデバイスプログラミング実践）: 火曜4時限
INSERT INTO course_schedule (course_id, schedule_date, period_id, classroom_id, teacher_id) VALUES 
('14', '2024-04-09', 4, '202D', 110),
('14', '2024-04-16', 4, '202D', 110),
('14', '2024-04-23', 4, '202D', 110),
('14', '2024-05-07', 4, '202D', 110),
('14', '2024-05-14', 4, '202D', 110),
('14', '2024-05-21', 4, '202D', 110),
('14', '2024-05-28', 4, '202D', 110),
('14', '2024-06-04', 4, '202D', 110),
('14', '2024-06-11', 4, '202D', 110),
('14', '2024-06-18', 4, '202D', 110),
('14', '2024-06-25', 4, '202D', 110);

-- 講座15（DevOpsとCI/CD入門）: 水曜5時限
INSERT INTO course_schedule (course_id, schedule_date, period_id, classroom_id, teacher_id) VALUES 
('15', '2024-04-10', 5, '101A', 111),
('15', '2024-04-17', 5, '101A', 111),
('15', '2024-04-24', 5, '101A', 111),
('15', '2024-05-08', 5, '101A', 111),
('15', '2024-05-15', 5, '101A', 111),
('15', '2024-05-22', 5, '101A', 111),
('15', '2024-05-29', 5, '101A', 111),
('15', '2024-06-05', 5, '101A', 111),
('15', '2024-06-12', 5, '101A', 111),
('15', '2024-06-19', 5, '101A', 111),
('15', '2024-06-26', 5, '101A', 111);

-- 講座16（クラウドネイティブアーキテクチャ）: 木曜2時限
INSERT INTO course_schedule (course_id, schedule_date, period_id, classroom_id, teacher_id) VALUES 
('16', '2024-04-11', 2, '302F', 108),
('16', '2024-04-18', 2, '302F', 108),
('16', '2024-04-25', 2, '302F', 108),
('16', '2024-05-09', 2, '302F', 108),
('16', '2024-05-16', 2, '302F', 108),
('16', '2024-05-23', 2, '302F', 108),
('16', '2024-05-30', 2, '302F', 108),
('16', '2024-06-06', 2, '302F', 108),
('16', '2024-06-13', 2, '302F', 108),
('16', '2024-06-20', 2, '302F', 108),
('16', '2024-06-27', 2, '302F', 108);

-- 講座17（量子コンピューティング基礎）: 金曜1時限
INSERT INTO course_schedule (course_id, schedule_date, period_id, classroom_id, teacher_id) VALUES 
('17', '2024-04-12', 1, '301E', 112),
('17', '2024-04-19', 1, '301E', 112),
('17', '2024-04-26', 1, '301E', 112),
('17', '2024-05-10', 1, '301E', 112),
('17', '2024-05-17', 1, '301E', 112),
('17', '2024-05-24', 1, '301E', 112),
('17', '2024-05-31', 1, '301E', 112),
('17', '2024-06-07', 1, '301E', 112),
('17', '2024-06-14', 1, '301E', 112),
('17', '2024-06-21', 1, '301E', 112),
('17', '2024-06-28', 1, '301E', 112);

-- 講座18（マイクロサービス設計パターン）: 月曜4時限
INSERT INTO course_schedule (course_id, schedule_date, period_id, classroom_id, teacher_id) VALUES 
('18', '2024-04-08', 4, '401G', 113),
('18', '2024-04-15', 4, '401G', 113),
('18', '2024-04-22', 4, '401G', 113),
('18', '2024-05-06', 4, '401G', 113),
('18', '2024-05-13', 4, '401G', 113),
('18', '2024-05-20', 4, '401G', 113),
('18', '2024-05-27', 4, '401G', 113),
('18', '2024-06-03', 4, '401G', 113),
('18', '2024-06-10', 4, '401G', 113),
('18', '2024-06-17', 4, '401G', 113),
('18', '2024-06-24', 4, '401G', 113);

-- 講座19（サイバーセキュリティ脅威分析）: 火曜1時限
INSERT INTO course_schedule (course_id, schedule_date, period_id, classroom_id, teacher_id) VALUES 
('19', '2024-04-09', 1, '301E', 107),
('19', '2024-04-16', 1, '301E', 107),
('19', '2024-04-23', 1, '301E', 107),
('19', '2024-05-07', 1, '301E', 107),
('19', '2024-05-14', 1, '301E', 107),
('19', '2024-05-21', 1, '301E', 107),
('19', '2024-05-28', 1, '301E', 107),
('19', '2024-06-04', 1, '301E', 107),
('19', '2024-06-11', 1, '301E', 107),
('19', '2024-06-18', 1, '301E', 107),
('19', '2024-06-25', 1, '301E', 107);

-- 講座20（データサイエンスとビジネス応用）: 木曜3時限
INSERT INTO course_schedule (course_id, schedule_date, period_id, classroom_id, teacher_id) VALUES 
('20', '2024-04-11', 3, '401G', 106),
('20', '2024-04-18', 3, '401G', 106),
('20', '2024-04-25', 3, '401G', 106),
('20', '2024-05-09', 3, '401G', 106),
('20', '2024-05-16', 3, '401G', 106),
('20', '2024-05-23', 3, '401G', 106),
('20', '2024-05-30', 3, '401G', 106),
('20', '2024-06-06', 3, '401G', 106),
('20', '2024-06-13', 3, '401G', 106),
('20', '2024-06-20', 3, '401G', 106),
('20', '2024-06-27', 3, '401G', 106);

-- 講座21（Kubernetesによるコンテナオーケストレーション）: 金曜4時限
INSERT INTO course_schedule (course_id, schedule_date, period_id, classroom_id, teacher_id) VALUES 
('21', '2024-04-12', 4, '402H', 114),
('21', '2024-04-19', 4, '402H', 114),
('21', '2024-04-26', 4, '402H', 114),
('21', '2024-05-10', 4, '402H', 114),
('21', '2024-05-17', 4, '402H', 114),
('21', '2024-05-24', 4, '402H', 114),
('21', '2024-05-31', 4, '402H', 114),
('21', '2024-06-07', 4, '402H', 114),
('21', '2024-06-14', 4, '402H', 114),
('21', '2024-06-21', 4, '402H', 114),
('21', '2024-06-28', 4, '402H', 114);

-- 講座22（フルスタック開発マスタークラス）: 水曜2時限
INSERT INTO course_schedule (course_id, schedule_date, period_id, classroom_id, teacher_id) VALUES 
('22', '2024-04-10', 2, '202D', 104),
('22', '2024-04-17', 2, '202D', 104),
('22', '2024-04-24', 2, '202D', 104),
('22', '2024-05-08', 2, '202D', 104),
('22', '2024-05-15', 2, '202D', 104),
('22', '2024-05-22', 2, '202D', 104),
('22', '2024-05-29', 2, '202D', 104),
('22', '2024-06-05', 2, '202D', 104),
('22', '2024-06-12', 2, '202D', 104),
('22', '2024-06-19', 2, '202D', 104),
('22', '2024-06-26', 2, '202D', 104);

-- 講座23（機械学習モデル最適化手法）: 火曜3時限
INSERT INTO course_schedule (course_id, schedule_date, period_id, classroom_id, teacher_id) VALUES 
('23', '2024-04-09', 3, '402H', 115),
('23', '2024-04-16', 3, '402H', 115),
('23', '2024-04-23', 3, '402H', 115),
('23', '2024-05-07', 3, '402H', 115),
('23', '2024-05-14', 3, '402H', 115),
('23', '2024-05-21', 3, '402H', 115),
('23', '2024-05-28', 3, '402H', 115),
('23', '2024-06-04', 3, '402H', 115),
('23', '2024-06-11', 3, '402H', 115),
('23', '2024-06-18', 3, '402H', 115),
('23', '2024-06-25', 3, '402H', 115);

-- 講座24（エンタープライズアーキテクチャ設計）: 木曜2時限
INSERT INTO course_schedule (course_id, schedule_date, period_id, classroom_id, teacher_id) VALUES 
('24', '2024-04-11', 2, '401G', 116),
('24', '2024-04-18', 2, '401G', 116),
('24', '2024-04-25', 2, '401G', 116),
('24', '2024-05-09', 2, '401G', 116),
('24', '2024-05-16', 2, '401G', 116),
('24', '2024-05-23', 2, '401G', 116),
('24', '2024-05-30', 2, '401G', 116),
('24', '2024-06-06', 2, '401G', 116),
('24', '2024-06-13', 2, '401G', 116),
('24', '2024-06-20', 2, '401G', 116),
('24', '2024-06-27', 2, '401G', 116);

-- 講座25（サーバーレスアプリケーション開発）: 月曜5時限
INSERT INTO course_schedule (course_id, schedule_date, period_id, classroom_id, teacher_id) VALUES 
('25', '2024-04-08', 5, '202D', 117),
('25', '2024-04-15', 5, '202D', 117),
('25', '2024-04-22', 5, '202D', 117),
('25', '2024-05-06', 5, '202D', 117),
('25', '2024-05-13', 5, '202D', 117),
('25', '2024-05-20', 5, '202D', 117),
('25', '2024-05-27', 5, '202D', 117),
('25', '2024-06-03', 5, '202D', 117),
('25', '2024-06-10', 5, '202D', 117),
('25', '2024-06-17', 5, '202D', 117),
('25', '2024-06-24', 5, '202D', 117);

-- 講座26（アジャイル開発とスクラム実践）: 水曜2時限
INSERT INTO course_schedule (course_id, schedule_date, period_id, classroom_id, teacher_id) VALUES 
('26', '2024-04-10', 2, '201C', 103),
('26', '2024-04-17', 2, '201C', 103),
('26', '2024-04-24', 2, '201C', 103),
('26', '2024-05-08', 2, '201C', 103),
('26', '2024-05-15', 2, '201C', 103),
('26', '2024-05-22', 2, '201C', 103),
('26', '2024-05-29', 2, '201C', 103),
('26', '2024-06-05', 2, '201C', 103),
('26', '2024-06-12', 2, '201C', 103),
('26', '2024-06-19', 2, '201C', 103),
('26', '2024-06-26', 2, '201C', 103);

-- ---------------------------------------------------------
-- 2024年度 後期（3Q：10月-12月）スケジュール
-- ---------------------------------------------------------

-- 講座1（ITのための基礎知識）: 月曜1時限
INSERT INTO course_schedule (course_id, schedule_date, period_id, classroom_id, teacher_id) VALUES 
('1', '2024-10-07', 1, '102B', 101),
('1', '2024-10-14', 1, '102B', 101),
('1', '2024-10-21', 1, '102B', 101),
('1', '2024-10-28', 1, '102B', 101),
('1', '2024-11-04', 1, '102B', 101),
('1', '2024-11-11', 1, '102B', 101),
('1', '2024-11-18', 1, '102B', 101),
('1', '2024-11-25', 1, '102B', 101),
('1', '2024-12-02', 1, '102B', 101),
('1', '2024-12-09', 1, '102B', 101),
('1', '2024-12-16', 1, '102B', 101);

-- 講座2（UNIX入門）: 火曜3時限
INSERT INTO course_schedule (course_id, schedule_date, period_id, classroom_id, teacher_id) VALUES 
('2', '2024-10-08', 3, '101A', 102),
('2', '2024-10-15', 3, '101A', 102),
('2', '2024-10-22', 3, '101A', 102),
('2', '2024-10-29', 3, '101A', 102),
('2', '2024-11-05', 3, '101A', 102),
('2', '2024-11-12', 3, '101A', 102),
('2', '2024-11-19', 3, '101A', 102),
('2', '2024-11-26', 3, '101A', 102),
('2', '2024-12-03', 3, '101A', 102),
('2', '2024-12-10', 3, '101A', 102),
('2', '2024-12-17', 3, '101A', 102);

-- 講座14（IoTデバイスプログラミング実践）: 火曜4時限
INSERT INTO course_schedule (course_id, schedule_date, period_id, classroom_id, teacher_id) VALUES 
('14', '2024-10-08', 4, '202D', 110),
('14', '2024-10-15', 4, '202D', 110),
('14', '2024-10-22', 4, '202D', 110),
('14', '2024-10-29', 4, '202D', 110),
('14', '2024-11-05', 4, '202D', 110),
('14', '2024-11-12', 4, '202D', 110),
('14', '2024-11-19', 4, '202D', 110),
('14', '2024-11-26', 4, '202D', 110),
('14', '2024-12-03', 4, '202D', 110),
('14', '2024-12-10', 4, '202D', 110),
('14', '2024-12-17', 4, '202D', 110);

-- 講座15（DevOpsとCI/CD入門）: 水曜5時限
INSERT INTO course_schedule (course_id, schedule_date, period_id, classroom_id, teacher_id) VALUES 
('15', '2024-10-09', 5, '101A', 111),
('15', '2024-10-16', 5, '101A', 111),
('15', '2024-10-23', 5, '101A', 111),
('15', '2024-10-30', 5, '101A', 111),
('15', '2024-11-06', 5, '101A', 111),
('15', '2024-11-13', 5, '101A', 111),
('15', '2024-11-20', 5, '101A', 111),
('15', '2024-11-27', 5, '101A', 111),
('15', '2024-12-04', 5, '101A', 111),
('15', '2024-12-11', 5, '101A', 111),
('15', '2024-12-18', 5, '101A', 111);

-- ---------------------------------------------------------
-- 2025年度 前期（1Q：4月-6月）スケジュール
-- ---------------------------------------------------------

-- 講座1（ITのための基礎知識）: 月曜1時限
INSERT INTO course_schedule (course_id, schedule_date, period_id, classroom_id, teacher_id) VALUES 
('1', '2025-04-07', 1, '102B', 101),
('1', '2025-04-14', 1, '102B', 101),
('1', '2025-04-21', 1, '102B', 101),
('1', '2025-04-28', 1, '102B', 101),
('1', '2025-05-12', 1, '102B', 101),
('1', '2025-05-19', 1, '102B', 101),
('1', '2025-05-26', 1, '102B', 101),
('1', '2025-06-02', 1, '102B', 101),
('1', '2025-06-09', 1, '102B', 101),
('1', '2025-06-16', 1, '102B', 101),
('1', '2025-06-23', 1, '102B', 101),
('1', '2025-06-30', 1, '102B', 101);

-- 講座2（UNIX入門）: 火曜3時限
INSERT INTO course_schedule (course_id, schedule_date, period_id, classroom_id, teacher_id) VALUES 
('2', '2025-04-08', 3, '101A', 102),
('2', '2025-04-15', 3, '101A', 102),
('2', '2025-04-22', 3, '101A', 102),
('2', '2025-04-29', 3, '101A', 102),
('2', '2025-05-13', 3, '101A', 102),
('2', '2025-05-20', 3, '101A', 102),
('2', '2025-05-27', 3, '101A', 102),
('2', '2025-06-03', 3, '101A', 102),
('2', '2025-06-10', 3, '101A', 102),
('2', '2025-06-17', 3, '101A', 102),
('2', '2025-06-24', 3, '101A', 102);

-- 講座3（Cプログラミング演習）: 水曜4時限
INSERT INTO course_schedule (course_id, schedule_date, period_id, classroom_id, teacher_id) VALUES 
('3', '2025-05-14', 4, '101A', 101),
('3', '2025-05-21', 4, '101A', 101),
('3', '2025-05-28', 4, '101A', 101),
('3', '2025-06-04', 4, '101A', 101);

-- 講座4（Webアプリケーション開発）: 月曜2時限
INSERT INTO course_schedule (course_id, schedule_date, period_id, classroom_id, teacher_id) VALUES 
('4', '2025-05-12', 2, '202D', 104),
('4', '2025-05-19', 2, '202D', 104),
('4', '2025-05-26', 2, '202D', 104),
('4', '2025-06-02', 2, '202D', 104);

-- 講座5（データベース設計と実装）: 火曜2時限
INSERT INTO course_schedule (course_id, schedule_date, period_id, classroom_id, teacher_id) VALUES 
('5', '2025-05-13', 2, '402H', 105),
('5', '2025-05-20', 2, '402H', 105),
('5', '2025-05-27', 2, '402H', 105),
('5', '2025-06-03', 2, '402H', 105);

-- 講座6（ネットワークセキュリティ）: 水曜3時限
INSERT INTO course_schedule (course_id, schedule_date, period_id, classroom_id, teacher_id) VALUES 
('6', '2025-05-14', 3, '301E', 107),
('6', '2025-05-21', 3, '301E', 107),
('6', '2025-05-28', 3, '301E', 107),
('6', '2025-06-04', 3, '301E', 107);

-- 講座7（AI・機械学習入門）: 木曜1時限
INSERT INTO course_schedule (course_id, schedule_date, period_id, classroom_id, teacher_id) VALUES 
('7', '2025-05-15', 1, '402H', 106),
('7', '2025-05-22', 1, '402H', 106),
('7', '2025-05-29', 1, '402H', 106),
('7', '2025-06-05', 1, '402H', 106);

-- 講座8（モバイルアプリ開発）: 金曜2時限
INSERT INTO course_schedule (course_id, schedule_date, period_id, classroom_id, teacher_id) VALUES 
('8', '2025-05-16', 2, '202D', 104),
('8', '2025-05-23', 2, '202D', 104),
('8', '2025-05-30', 2, '202D', 104),
('8', '2025-06-06', 2, '202D', 104);

-- 講座9（クラウドコンピューティング）: 木曜4時限
INSERT INTO course_schedule (course_id, schedule_date, period_id, classroom_id, teacher_id) VALUES 
('9', '2025-05-15', 4, '302F', 108),
('9', '2025-05-22', 4, '302F', 108),
('9', '2025-05-29', 4, '302F', 108),
('9', '2025-06-05', 4, '302F', 108);

-- 講座10（プロジェクト管理手法）: 金曜3時限
INSERT INTO course_schedule (course_id, schedule_date, period_id, classroom_id, teacher_id) VALUES 
('10', '2025-05-16', 3, '201C', 103),
('10', '2025-05-23', 3, '201C', 103),
('10', '2025-05-30', 3, '201C', 103),
('10', '2025-06-06', 3, '201C', 103);

-- 講座11（データ分析と可視化）: 火曜5時限
INSERT INTO course_schedule (course_id, schedule_date, period_id, classroom_id, teacher_id) VALUES 
('11', '2025-05-13', 5, '401G', 106),
('11', '2025-05-20', 5, '401G', 106),
('11', '2025-05-27', 5, '401G', 106),
('11', '2025-06-03', 5, '401G', 106);

-- 講座12（サイバーセキュリティ対策）: 水曜1時限
INSERT INTO course_schedule (course_id, schedule_date, period_id, classroom_id, teacher_id) VALUES 
('12', '2025-05-14', 1, '301E', 107),
('12', '2025-05-21', 1, '301E', 107),
('12', '2025-05-28', 1, '301E', 107),
('12', '2025-06-04', 1, '301E', 107);

-- 講座14（IoTデバイスプログラミング実践）: 火曜4時限
INSERT INTO course_schedule (course_id, schedule_date, period_id, classroom_id, teacher_id) VALUES 
('14', '2025-04-08', 4, '202D', 110),
('14', '2025-04-15', 4, '202D', 110),
('14', '2025-04-22', 4, '202D', 110),
('14', '2025-04-29', 4, '202D', 110),
('14', '2025-05-13', 4, '202D', 110),
('14', '2025-05-20', 4, '202D', 110),
('14', '2025-05-27', 4, '202D', 110),
('14', '2025-06-03', 4, '202D', 110),
('14', '2025-06-10', 4, '202D', 110),
('14', '2025-06-17', 4, '202D', 110),
('14', '2025-06-24', 4, '202D', 110);

-- 講座15（DevOpsとCI/CD入門）: 水曜5時限
INSERT INTO course_schedule (course_id, schedule_date, period_id, classroom_id, teacher_id) VALUES 
('15', '2025-04-09', 5, '101A', 111),
('15', '2025-04-16', 5, '101A', 111),
('15', '2025-04-23', 5, '101A', 111),
('15', '2025-04-30', 5, '101A', 111),
('15', '2025-05-14', 5, '101A', 111),
('15', '2025-05-21', 5, '101A', 111),
('15', '2025-05-28', 5, '101A', 111),
('15', '2025-06-04', 5, '101A', 111),
('15', '2025-06-11', 5, '101A', 111),
('15', '2025-06-18', 5, '101A', 111),
('15', '2025-06-25', 5, '101A', 111);

-- 講座16（クラウドネイティブアーキテクチャ）: 木曜2時限
INSERT INTO course_schedule (course_id, schedule_date, period_id, classroom_id, teacher_id) VALUES 
('16', '2025-04-10', 2, '302F', 108),
('16', '2025-04-17', 2, '302F', 108),
('16', '2025-04-24', 2, '302F', 108),
('16', '2025-05-01', 2, '302F', 108),
('16', '2025-05-15', 2, '302F', 108),
('16', '2025-05-22', 2, '302F', 108),
('16', '2025-05-29', 2, '302F', 108),
('16', '2025-06-05', 2, '302F', 108),
('16', '2025-06-12', 2, '302F', 108),
('16', '2025-06-19', 2, '302F', 108),
('16', '2025-06-26', 2, '302F', 108);

-- 講座17（量子コンピューティング基礎）: 金曜1時限
INSERT INTO course_schedule (course_id, schedule_date, period_id, classroom_id, teacher_id) VALUES 
('17', '2025-04-11', 1, '301E', 112),
('17', '2025-04-18', 1, '301E', 112),
('17', '2025-04-25', 1, '301E', 112),
('17', '2025-05-02', 1, '301E', 112),
('17', '2025-05-09', 1, '301E', 112),
('17', '2025-05-16', 1, '301E', 112),
('17', '2025-05-23', 1, '301E', 112),
('17', '2025-05-30', 1, '301E', 112),
('17', '2025-06-06', 1, '301E', 112),
('17', '2025-06-13', 1, '301E', 112),
('17', '2025-06-20', 1, '301E', 112),
('17', '2025-06-27', 1, '301E', 112);

-- 講座18（マイクロサービス設計パターン）: 月曜4時限
INSERT INTO course_schedule (course_id, schedule_date, period_id, classroom_id, teacher_id) VALUES 
('18', '2025-04-07', 4, '401G', 113),
('18', '2025-04-14', 4, '401G', 113),
('18', '2025-04-21', 4, '401G', 113),
('18', '2025-04-28', 4, '401G', 113),
('18', '2025-05-12', 4, '401G', 113),
('18', '2025-05-19', 4, '401G', 113),
('18', '2025-05-26', 4, '401G', 113),
('18', '2025-06-02', 4, '401G', 113),
('18', '2025-06-09', 4, '401G', 113),
('18', '2025-06-16', 4, '401G', 113),
('18', '2025-06-23', 4, '401G', 113),
('18', '2025-06-30', 4, '401G', 113);

-- 講座19（サイバーセキュリティ脅威分析）: 火曜1時限
INSERT INTO course_schedule (course_id, schedule_date, period_id, classroom_id, teacher_id) VALUES 
('19', '2025-04-08', 1, '301E', 107),
('19', '2025-04-15', 1, '301E', 107),
('19', '2025-04-22', 1, '301E', 107),
('19', '2025-04-29', 1, '301E', 107),
('19', '2025-05-13', 1, '301E', 107),
('19', '2025-05-20', 1, '301E', 107),
('19', '2025-05-27', 1, '301E', 107),
('19', '2025-06-03', 1, '301E', 107),
('19', '2025-06-10', 1, '301E', 107),
('19', '2025-06-17', 1, '301E', 107),
('19', '2025-06-24', 1, '301E', 107);

-- 講座20（データサイエンスとビジネス応用）: 木曜3時限
INSERT INTO course_schedule (course_id, schedule_date, period_id, classroom_id, teacher_id) VALUES 
('20', '2025-04-10', 3, '401G', 106),
('20', '2025-04-17', 3, '401G', 106),
('20', '2025-04-24', 3, '401G', 106),
('20', '2025-05-01', 3, '401G', 106),
('20', '2025-05-15', 3, '401G', 106),
('20', '2025-05-22', 3, '401G', 106),
('20', '2025-05-29', 3, '401G', 106),
('20', '2025-06-05', 3, '401G', 106),
('20', '2025-06-12', 3, '401G', 106),
('20', '2025-06-19', 3, '401G', 106),
('20', '2025-06-26', 3, '401G', 106);

-- 講座21（Kubernetesによるコンテナオーケストレーション）: 金曜4時限
INSERT INTO course_schedule (course_id, schedule_date, period_id, classroom_id, teacher_id) VALUES 
('21', '2025-04-11', 4, '402H', 114),
('21', '2025-04-18', 4, '402H', 114),
('21', '2025-04-25', 4, '402H', 114),
('21', '2025-05-02', 4, '402H', 114),
('21', '2025-05-09', 4, '402H', 114),
('21', '2025-05-16', 4, '402H', 114),
('21', '2025-05-23', 4, '402H', 114),
('21', '2025-05-30', 4, '402H', 114),
('21', '2025-06-06', 4, '402H', 114),
('21', '2025-06-13', 4, '402H', 114),
('21', '2025-06-20', 4, '402H', 114),
('21', '2025-06-27', 4, '402H', 114);

-- 講座22（フルスタック開発マスタークラス）: 水曜2時限
INSERT INTO course_schedule (course_id, schedule_date, period_id, classroom_id, teacher_id) VALUES 
('22', '2025-04-09', 2, '202D', 104),
('22', '2025-04-16', 2, '202D', 104),
('22', '2025-04-23', 2, '202D', 104),
('22', '2025-04-30', 2, '202D', 104),
('22', '2025-05-14', 2, '202D', 104),
('22', '2025-05-21', 2, '202D', 104),
('22', '2025-05-28', 2, '202D', 104),
('22', '2025-06-04', 2, '202D', 104),
('22', '2025-06-11', 2, '202D', 104),
('22', '2025-06-18', 2, '202D', 104),
('22', '2025-06-25', 2, '202D', 104);

-- 講座27（クロスプラットフォーム開発フレームワーク）: 金曜2時限
INSERT INTO course_schedule (course_id, schedule_date, period_id, classroom_id, teacher_id) VALUES 
('27', '2025-04-11', 2, '202D', 118),
('27', '2025-04-18', 2, '202D', 118),
('27', '2025-04-25', 2, '202D', 118),
('27', '2025-05-02', 2, '202D', 118),
('27', '2025-05-09', 2, '202D', 118),
('27', '2025-05-16', 2, '202D', 118),
('27', '2025-05-23', 2, '202D', 118),
('27', '2025-05-30', 2, '202D', 118),
('27', '2025-06-06', 2, '202D', 118),
('27', '2025-06-13', 2, '202D', 118),
('27', '2025-06-20', 2, '202D', 118),
('27', '2025-06-27', 2, '202D', 118);

-- 講座28（ゲーム開発エンジン入門）: 月曜3時限
INSERT INTO course_schedule (course_id, schedule_date, period_id, classroom_id, teacher_id) VALUES 
('28', '2025-04-07', 3, '202D', 119),
('28', '2025-04-14', 3, '202D', 119),
('28', '2025-04-21', 3, '202D', 119),
('28', '2025-04-28', 3, '202D', 119),
('28', '2025-05-12', 3, '202D', 119),
('28', '2025-05-19', 3, '202D', 119),
('28', '2025-05-26', 3, '202D', 119),
('28', '2025-06-02', 3, '202D', 119),
('28', '2025-06-09', 3, '202D', 119),
('28', '2025-06-16', 3, '202D', 119),
('28', '2025-06-23', 3, '202D', 119),
('28', '2025-06-30', 3, '202D', 119);

-- 講座29（コードリファクタリングとクリーンコード）: 火曜5時限
INSERT INTO course_schedule (course_id, schedule_date, period_id, classroom_id, teacher_id) VALUES 
('29', '2025-04-08', 5, '101A', 101),
('29', '2025-04-15', 5, '101A', 101),
('29', '2025-04-22', 5, '101A', 101),
('29', '2025-04-29', 5, '101A', 101),
('29', '2025-05-13', 5, '101A', 101),
('29', '2025-05-20', 5, '101A', 101),
('29', '2025-05-27', 5, '101A', 101),
('29', '2025-06-03', 5, '101A', 101),
('29', '2025-06-10', 5, '101A', 101),
('29', '2025-06-17', 5, '101A', 101),
('29', '2025-06-24', 5, '101A', 101);

-- 講座30（UIUXデザイン原則と実践）: 木曜5時限
INSERT INTO course_schedule (course_id, schedule_date, period_id, classroom_id, teacher_id) VALUES 
('30', '2025-04-10', 5, '301E', 120),
('30', '2025-04-17', 5, '301E', 120),
('30', '2025-04-24', 5, '301E', 120),
('30', '2025-05-01', 5, '301E', 120),
('30', '2025-05-15', 5, '301E', 120),
('30', '2025-05-22', 5, '301E', 120),
('30', '2025-05-29', 5, '301E', 120),
('30', '2025-06-05', 5, '301E', 120),
('30', '2025-06-12', 5, '301E', 120),
('30', '2025-06-19', 5, '301E', 120),
('30', '2025-06-26', 5, '301E', 120);

-- 講座31（高度データ可視化技術）: 水曜1時限
INSERT INTO course_schedule (course_id, schedule_date, period_id, classroom_id, teacher_id) VALUES 
('31', '2025-04-09', 1, '402H', 106),
('31', '2025-04-16', 1, '402H', 106),
('31', '2025-04-23', 1, '402H', 106),
('31', '2025-04-30', 1, '402H', 106),
('31', '2025-05-14', 1, '402H', 106),
('31', '2025-05-21', 1, '402H', 106),
('31', '2025-05-28', 1, '402H', 106),
('31', '2025-06-04', 1, '402H', 106),
('31', '2025-06-11', 1, '402H', 106),
('31', '2025-06-18', 1, '402H', 106),
('31', '2025-06-25', 1, '402H', 106);

-- 講座32（API設計と開発ベストプラクティス）: 金曜3時限
INSERT INTO course_schedule (course_id, schedule_date, period_id, classroom_id, teacher_id) VALUES 
('32', '2025-04-11', 3, '101A', 111),
('32', '2025-04-18', 3, '101A', 111),
('32', '2025-04-25', 3, '101A', 111),
('32', '2025-05-02', 3, '101A', 111),
('32', '2025-05-09', 3, '101A', 111),
('32', '2025-05-16', 3, '101A', 111),
('32', '2025-05-23', 3, '101A', 111),
('32', '2025-05-30', 3, '101A', 111),
('32', '2025-06-06', 3, '101A', 111),
('32', '2025-06-13', 3, '101A', 111),
('32', '2025-06-20', 3, '101A', 111),
('32', '2025-06-27', 3, '101A', 111);

-- 講座33（エッジコンピューティングシステム）: 火曜4時限
INSERT INTO course_schedule (course_id, schedule_date, period_id, classroom_id, teacher_id) VALUES 
('33', '2025-04-08', 4, '302F', 110),
('33', '2025-04-15', 4, '302F', 110),
('33', '2025-04-22', 4, '302F', 110),
('33', '2025-04-29', 4, '302F', 110),
('33', '2025-05-13', 4, '302F', 110),
('33', '2025-05-20', 4, '302F', 110),
('33', '2025-05-27', 4, '302F', 110),
('33', '2025-06-03', 4, '302F', 110),
('33', '2025-06-10', 4, '302F', 110),
('33', '2025-06-17', 4, '302F', 110),
('33', '2025-06-24', 4, '302F', 110);

-- 講座34（ソフトウェアテスト自動化）: 木曜3時限
INSERT INTO course_schedule (course_id, schedule_date, period_id, classroom_id, teacher_id) VALUES 
('34', '2025-04-10', 3, '102B', 109),
('34', '2025-04-17', 3, '102B', 109),
('34', '2025-04-24', 3, '102B', 109),
('34', '2025-05-01', 3, '102B', 109),
('34', '2025-05-15', 3, '102B', 109),
('34', '2025-05-22', 3, '102B', 109),
('34', '2025-05-29', 3, '102B', 109),
('34', '2025-06-05', 3, '102B', 109),
('34', '2025-06-12', 3, '102B', 109),
('34', '2025-06-19', 3, '102B', 109),
('34', '2025-06-26', 3, '102B', 109);

-- 講座35（デジタルトランスフォーメーション戦略）: 月曜2時限
INSERT INTO course_schedule (course_id, schedule_date, period_id, classroom_id, teacher_id) VALUES 
('35', '2025-04-07', 2, '301E', 116),
('35', '2025-04-14', 2, '301E', 116),
('35', '2025-04-21', 2, '301E', 116),
('35', '2025-04-28', 2, '301E', 116),
('35', '2025-05-12', 2, '301E', 116),
('35', '2025-05-19', 2, '301E', 116),
('35', '2025-05-26', 2, '301E', 116),
('35', '2025-06-02', 2, '301E', 116),
('35', '2025-06-09', 2, '301E', 116),
('35', '2025-06-16', 2, '301E', 116),
('35', '2025-06-23', 2, '301E', 116),
('35', '2025-06-30', 2, '301E', 116);

-- 講座36（スマートコントラクト開発）: 水曜4時限
INSERT INTO course_schedule (course_id, schedule_date, period_id, classroom_id, teacher_id) VALUES 
('36', '2025-04-09', 4, '201C', 118),
('36', '2025-04-16', 4, '201C', 118),
('36', '2025-04-23', 4, '201C', 118),
('36', '2025-04-30', 4, '201C', 118),
('36', '2025-05-14', 4, '201C', 118),
('36', '2025-05-21', 4, '201C', 118),
('36', '2025-05-28', 4, '201C', 118),
('36', '2025-06-04', 4, '201C', 118),
('36', '2025-06-11', 4, '201C', 118),
('36', '2025-06-18', 4, '201C', 118),
('36', '2025-06-25', 4, '201C', 118);

-- 講座37（ビッグデータ処理フレームワーク）: 月曜5時限
INSERT INTO course_schedule (course_id, schedule_date, period_id, classroom_id, teacher_id) VALUES 
('37', '2025-04-07', 5, '402H', 105),
('37', '2025-04-14', 5, '402H', 105),
('37', '2025-04-21', 5, '402H', 105),
('37', '2025-04-28', 5, '402H', 105),
('37', '2025-05-12', 5, '402H', 105),
('37', '2025-05-19', 5, '402H', 105),
('37', '2025-05-26', 5, '402H', 105),
('37', '2025-06-02', 5, '402H', 105),
('37', '2025-06-09', 5, '402H', 105),
('37', '2025-06-16', 5, '402H', 105),
('37', '2025-06-23', 5, '402H', 105),
('37', '2025-06-30', 5, '402H', 105);

-- 講座38（ネットワーク仮想化技術）: 火曜3時限
INSERT INTO course_schedule (course_id, schedule_date, period_id, classroom_id, teacher_id) VALUES 
('38', '2025-04-08', 3, '301E', 107),
('38', '2025-04-15', 3, '301E', 107),
('38', '2025-04-22', 3, '301E', 107),
('38', '2025-04-29', 3, '301E', 107),
('38', '2025-05-13', 3, '301E', 107),
('38', '2025-05-20', 3, '301E', 107),
('38', '2025-05-27', 3, '301E', 107),
('38', '2025-06-03', 3, '301E', 107),
('38', '2025-06-10', 3, '301E', 107),
('38', '2025-06-17', 3, '301E', 107),
('38', '2025-06-24', 3, '301E', 107);

-- 講座39（リアルタイムシステム設計）: 水曜2時限
INSERT INTO course_schedule (course_id, schedule_date, period_id, classroom_id, teacher_id) VALUES 
('39', '2025-04-09', 2, '102B', 113),
('39', '2025-04-16', 2, '102B', 113),
('39', '2025-04-23', 2, '102B', 113),
('39', '2025-04-30', 2, '102B', 113),
('39', '2025-05-14', 2, '102B', 113),
('39', '2025-05-21', 2, '102B', 113),
('39', '2025-05-28', 2, '102B', 113),
('39', '2025-06-04', 2, '102B', 113),
('39', '2025-06-11', 2, '102B', 113),
('39', '2025-06-18', 2, '102B', 113),
('39', '2025-06-25', 2, '102B', 113);

-- 講座40（ソフトウェアアーキテクチャパターン）: 金曜1時限
INSERT INTO course_schedule (course_id, schedule_date, period_id, classroom_id, teacher_id) VALUES 
('40', '2025-04-11', 1, '102B', 102),
('40', '2025-04-18', 1, '102B', 102),
('40', '2025-04-25', 1, '102B', 102),
('40', '2025-05-02', 1, '102B', 102),
('40', '2025-05-09', 1, '102B', 102),
('40', '2025-05-16', 1, '102B', 102),
('40', '2025-05-23', 1, '102B', 102),
('40', '2025-05-30', 1, '102B', 102),
('40', '2025-06-06', 1, '102B', 102),
('40', '2025-06-13', 1, '102B', 102),
('40', '2025-06-20', 1, '102B', 102),
('40', '2025-06-27', 1, '102B', 102);

-- 講座41（クラウドセキュリティと最適化）: 木曜4時限
INSERT INTO course_schedule (course_id, schedule_date, period_id, classroom_id, teacher_id) VALUES 
('41', '2025-04-10', 4, '301E', 117),
('41', '2025-04-17', 4, '301E', 117),
('41', '2025-04-24', 4, '301E', 117),
('41', '2025-05-01', 4, '301E', 117),
('41', '2025-05-15', 4, '301E', 117),
('41', '2025-05-22', 4, '301E', 117),
('41', '2025-05-29', 4, '301E', 117),
('41', '2025-06-05', 4, '301E', 117),
('41', '2025-06-12', 4, '301E', 117),
('41', '2025-06-19', 4, '301E', 117),
('41', '2025-06-26', 4, '301E', 117);

-- 講座42（プロダクトマネジメント実践）: 金曜5時限
INSERT INTO course_schedule (course_id, schedule_date, period_id, classroom_id, teacher_id) VALUES 
('42', '2025-04-11', 5, '201C', 103),
('42', '2025-04-18', 5, '201C', 103),
('42', '2025-04-25', 5, '201C', 103),
('42', '2025-05-02', 5, '201C', 103),
('42', '2025-05-09', 5, '201C', 103),
('42', '2025-05-16', 5, '201C', 103),
('42', '2025-05-23', 5, '201C', 103),
('42', '2025-05-30', 5, '201C', 103),
('42', '2025-06-06', 5, '201C', 103),
('42', '2025-06-13', 5, '201C', 103),
('42', '2025-06-20', 5, '201C', 103),
('42', '2025-06-27', 5, '201C', 103);

-- 講座43（ナチュラルランゲージプロセッシング）: 月曜4時限
INSERT INTO course_schedule (course_id, schedule_date, period_id, classroom_id, teacher_id) VALUES 
('43', '2025-04-07', 4, '402H', 115),
('43', '2025-04-14', 4, '402H', 115),
('43', '2025-04-21', 4, '402H', 115),
('43', '2025-04-28', 4, '402H', 115),
('43', '2025-05-12', 4, '402H', 115),
('43', '2025-05-19', 4, '402H', 115),
('43', '2025-05-26', 4, '402H', 115),
('43', '2025-06-02', 4, '402H', 115),
('43', '2025-06-09', 4, '402H', 115),
('43', '2025-06-16', 4, '402H', 115),
('43', '2025-06-23', 4, '402H', 115),
('43', '2025-06-30', 4, '402H', 115);

-- 講座44（コンピュータビジョンと画像処理）: 火曜1時限
INSERT INTO course_schedule (course_id, schedule_date, period_id, classroom_id, teacher_id) VALUES 
('44', '2025-04-08', 1, '402H', 112),
('44', '2025-04-15', 1, '402H', 112),
('44', '2025-04-22', 1, '402H', 112),
('44', '2025-04-29', 1, '402H', 112),
('44', '2025-05-13', 1, '402H', 112),
('44', '2025-05-20', 1, '402H', 112),
('44', '2025-05-27', 1, '402H', 112),
('44', '2025-06-03', 1, '402H', 112),
('44', '2025-06-10', 1, '402H', 112),
('44', '2025-06-17', 1, '402H', 112),
('44', '2025-06-24', 1, '402H', 112);

-- 講座45（グラフデータベースと知識グラフ）: 木曜1時限
INSERT INTO course_schedule (course_id, schedule_date, period_id, classroom_id, teacher_id) VALUES 
('45', '2025-04-10', 1, '101A', 105),
('45', '2025-04-17', 1, '101A', 105),
('45', '2025-04-24', 1, '101A', 105),
('45', '2025-05-01', 1, '101A', 105),
('45', '2025-05-15', 1, '101A', 105),
('45', '2025-05-22', 1, '101A', 105),
('45', '2025-05-29', 1, '101A', 105),
('45', '2025-06-05', 1, '101A', 105),
('45', '2025-06-12', 1, '101A', 105),
('45', '2025-06-19', 1, '101A', 105),
('45', '2025-06-26', 1, '101A', 105);

-- 講座46（インフラストラクチャー・アズ・コード）: 金曜4時限
INSERT INTO course_schedule (course_id, schedule_date, period_id, classroom_id, teacher_id) VALUES 
('46', '2025-04-11', 4, '101A', 114),
('46', '2025-04-18', 4, '101A', 114),
('46', '2025-04-25', 4, '101A', 114),
('46', '2025-05-02', 4, '101A', 114),
('46', '2025-05-09', 4, '101A', 114),
('46', '2025-05-16', 4, '101A', 114),
('46', '2025-05-23', 4, '101A', 114),
('46', '2025-05-30', 4, '101A', 114),
('46', '2025-06-06', 4, '101A', 114),
('46', '2025-06-13', 4, '101A', 114),
('46', '2025-06-20', 4, '101A', 114),
('46', '2025-06-27', 4, '101A', 114);

-- 講座47（ウェアラブルデバイス開発）: 水曜3時限
INSERT INTO course_schedule (course_id, schedule_date, period_id, classroom_id, teacher_id) VALUES 
('47', '2025-04-09', 3, '202D', 119),
('47', '2025-04-16', 3, '202D', 119),
('47', '2025-04-23', 3, '202D', 119),
('47', '2025-04-30', 3, '202D', 119),
('47', '2025-05-14', 3, '202D', 119),
('47', '2025-05-21', 3, '202D', 119),
('47', '2025-05-28', 3, '202D', 119),
('47', '2025-06-04', 3, '202D', 119),
('47', '2025-06-11', 3, '202D', 119),
('47', '2025-06-18', 3, '202D', 119),
('47', '2025-06-25', 3, '202D', 119);

-- 講座48（シミュレーションとモデリング手法）: 木曜2時限
INSERT INTO course_schedule (course_id, schedule_date, period_id, classroom_id, teacher_id) VALUES 
('48', '2025-04-10', 2, '401G', 120),
('48', '2025-04-17', 2, '401G', 120),
('48', '2025-04-24', 2, '401G', 120),
('48', '2025-05-01', 2, '401G', 120),
('48', '2025-05-15', 2, '401G', 120),
('48', '2025-05-22', 2, '401G', 120),
('48', '2025-05-29', 2, '401G', 120),
('48', '2025-06-05', 2, '401G', 120),
('48', '2025-06-12', 2, '401G', 120),
('48', '2025-06-19', 2, '401G', 120),
('48', '2025-06-26', 2, '401G', 120);

-- ---------------------------------------------------------
-- 2025年度 後期（3Q：10月-12月）スケジュール
-- ---------------------------------------------------------

-- 講座1（ITのための基礎知識）: 月曜1時限
INSERT INTO course_schedule (course_id, schedule_date, period_id, classroom_id, teacher_id) VALUES 
('1', '2025-10-06', 1, '102B', 101),
('1', '2025-10-13', 1, '102B', 101),
('1', '2025-10-20', 1, '102B', 101),
('1', '2025-10-27', 1, '102B', 101),
('1', '2025-11-10', 1, '102B', 101),
('1', '2025-11-17', 1, '102B', 101),
('1', '2025-11-24', 1, '102B', 101),
('1', '2025-12-01', 1, '102B', 101),
('1', '2025-12-08', 1, '102B', 101),
('1', '2025-12-15', 1, '102B', 101),
('1', '2025-12-22', 1, '102B', 101);

-- 講座14（IoTデバイスプログラミング実践）: 火曜4時限
INSERT INTO course_schedule (course_id, schedule_date, period_id, classroom_id, teacher_id) VALUES 
('14', '2025-10-07', 4, '202D', 110),
('14', '2025-10-14', 4, '202D', 110),
('14', '2025-10-21', 4, '202D', 110),
('14', '2025-10-28', 4, '202D', 110),
('14', '2025-11-04', 4, '202D', 110),
('14', '2025-11-11', 4, '202D', 110),
('14', '2025-11-18', 4, '202D', 110),
('14', '2025-11-25', 4, '202D', 110),
('14', '2025-12-02', 4, '202D', 110),
('14', '2025-12-09', 4, '202D', 110),
('14', '2025-12-16', 4, '202D', 110);

-- 講座27（クロスプラットフォーム開発フレームワーク）: 金曜2時限
INSERT INTO course_schedule (course_id, schedule_date, period_id, classroom_id, teacher_id) VALUES 
('27', '2025-10-10', 2, '202D', 118),
('27', '2025-10-17', 2, '202D', 118),
('27', '2025-10-24', 2, '202D', 118),
('27', '2025-10-31', 2, '202D', 118),
('27', '2025-11-07', 2, '202D', 118),
('27', '2025-11-14', 2, '202D', 118),
('27', '2025-11-21', 2, '202D', 118),
('27', '2025-11-28', 2, '202D', 118),
('27', '2025-12-05', 2, '202D', 118),
('27', '2025-12-12', 2, '202D', 118),
('27', '2025-12-19', 2, '202D', 118);

-- 講座28（ゲーム開発エンジン入門）: 月曜3時限
INSERT INTO course_schedule (course_id, schedule_date, period_id, classroom_id, teacher_id) VALUES 
('28', '2025-10-06', 3, '202D', 119),
('28', '2025-10-13', 3, '202D', 119),
('28', '2025-10-20', 3, '202D', 119),
('28', '2025-10-27', 3, '202D', 119),
('28', '2025-11-10', 3, '202D', 119),
('28', '2025-11-17', 3, '202D', 119),
('28', '2025-11-24', 3, '202D', 119),
('28', '2025-12-01', 3, '202D', 119),
('28', '2025-12-08', 3, '202D', 119),
('28', '2025-12-15', 3, '202D', 119),
('28', '2025-12-22', 3, '202D', 119);

-- 講座29（コードリファクタリングとクリーンコード）: 火曜5時限
INSERT INTO course_schedule (course_id, schedule_date, period_id, classroom_id, teacher_id) VALUES 
('29', '2025-10-07', 5, '101A', 101),
('29', '2025-10-14', 5, '101A', 101),
('29', '2025-10-21', 5, '101A', 101),
('29', '2025-10-28', 5, '101A', 101),
('29', '2025-11-04', 5, '101A', 101),
('29', '2025-11-11', 5, '101A', 101),
('29', '2025-11-18', 5, '101A', 101),
('29', '2025-11-25', 5, '101A', 101),
('29', '2025-12-02', 5, '101A', 101),
('29', '2025-12-09', 5, '101A', 101),
('29', '2025-12-16', 5, '101A', 101);

-- ---------------------------------------------------------
-- 2026年度 前期（1Q：4月-6月）スケジュール
-- ---------------------------------------------------------

-- 講座1（ITのための基礎知識）: 月曜1時限
INSERT INTO course_schedule (course_id, schedule_date, period_id, classroom_id, teacher_id) VALUES 
('1', '2026-04-06', 1, '102B', 101),
('1', '2026-04-13', 1, '102B', 101),
('1', '2026-04-20', 1, '102B', 101),
('1', '2026-04-27', 1, '102B', 101),
('1', '2026-05-11', 1, '102B', 101),
('1', '2026-05-18', 1, '102B', 101),
('1', '2026-05-25', 1, '102B', 101),
('1', '2026-06-01', 1, '102B', 101),
('1', '2026-06-08', 1, '102B', 101),
('1', '2026-06-15', 1, '102B', 101),
('1', '2026-06-22', 1, '102B', 101),
('1', '2026-06-29', 1, '102B', 101);

-- 講座14（IoTデバイスプログラミング実践）: 火曜4時限
INSERT INTO course_schedule (course_id, schedule_date, period_id, classroom_id, teacher_id) VALUES 
('14', '2026-04-07', 4, '202D', 110),
('14', '2026-04-14', 4, '202D', 110),
('14', '2026-04-21', 4, '202D', 110),
('14', '2026-04-28', 4, '202D', 110),
('14', '2026-05-12', 4, '202D', 110),
('14', '2026-05-19', 4, '202D', 110),
('14', '2026-05-26', 4, '202D', 110),
('14', '2026-06-02', 4, '202D', 110),
('14', '2026-06-09', 4, '202D', 110),
('14', '2026-06-16', 4, '202D', 110),
('14', '2026-06-23', 4, '202D', 110),
('14', '2026-06-30', 4, '202D', 110);

-- 講座27（クロスプラットフォーム開発フレームワーク）: 金曜2時限
INSERT INTO course_schedule (course_id, schedule_date, period_id, classroom_id, teacher_id) VALUES 
('27', '2026-04-10', 2, '202D', 118),
('27', '2026-04-17', 2, '202D', 118),
('27', '2026-04-24', 2, '202D', 118),
('27', '2026-05-01', 2, '202D', 118),
('27', '2026-05-08', 2, '202D', 118),
('27', '2026-05-15', 2, '202D', 118),
('27', '2026-05-22', 2, '202D', 118),
('27', '2026-05-29', 2, '202D', 118),
('27', '2026-06-05', 2, '202D', 118),
('27', '2026-06-12', 2, '202D', 118),
('27', '2026-06-19', 2, '202D', 118),
('27', '2026-06-26', 2, '202D', 118);

-- 講座28（ゲーム開発エンジン入門）: 月曜3時限
INSERT INTO course_schedule (course_id, schedule_date, period_id, classroom_id, teacher_id) VALUES 
('28', '2026-04-06', 3, '202D', 119),
('28', '2026-04-13', 3, '202D', 119),
('28', '2026-04-20', 3, '202D', 119),
('28', '2026-04-27', 3, '202D', 119),
('28', '2026-05-11', 3, '202D', 119),
('28', '2026-05-18', 3, '202D', 119),
('28', '2026-05-25', 3, '202D', 119),
('28', '2026-06-01', 3, '202D', 119),
('28', '2026-06-08', 3, '202D', 119),
('28', '2026-06-15', 3, '202D', 119),
('28', '2026-06-22', 3, '202D', 119),
('28', '2026-06-29', 3, '202D', 119);

-- ---------------------------------------------------------
-- 2026年度 後期（3Q：10月-12月）スケジュール
-- ---------------------------------------------------------

-- 講座1（ITのための基礎知識）: 月曜1時限
INSERT INTO course_schedule (course_id, schedule_date, period_id, classroom_id, teacher_id) VALUES 
('1', '2026-10-05', 1, '102B', 101),
('1', '2026-10-12', 1, '102B', 101),
('1', '2026-10-19', 1, '102B', 101),
('1', '2026-10-26', 1, '102B', 101),
('1', '2026-11-02', 1, '102B', 101),
('1', '2026-11-09', 1, '102B', 101),
('1', '2026-11-16', 1, '102B', 101),
('1', '2026-11-23', 1, '102B', 101),
('1', '2026-11-30', 1, '102B', 101),
('1', '2026-12-07', 1, '102B', 101),
('1', '2026-12-14', 1, '102B', 101),
('1', '2026-12-21', 1, '102B', 101);

-- 講座14（IoTデバイスプログラミング実践）: 火曜4時限
INSERT INTO course_schedule (course_id, schedule_date, period_id, classroom_id, teacher_id) VALUES 
('14', '2026-10-06', 4, '202D', 110),
('14', '2026-10-13', 4, '202D', 110),
('14', '2026-10-20', 4, '202D', 110),
('14', '2026-10-27', 4, '202D', 110),
('14', '2026-11-03', 4, '202D', 110),
('14', '2026-11-10', 4, '202D', 110),
('14', '2026-11-17', 4, '202D', 110),
('14', '2026-11-24', 4, '202D', 110),
('14', '2026-12-01', 4, '202D', 110),
('14', '2026-12-08', 4, '202D', 110),
('14', '2026-12-15', 4, '202D', 110),
('14', '2026-12-22', 4, '202D', 110);

-- 講座27（クロスプラットフォーム開発フレームワーク）: 金曜2時限
INSERT INTO course_schedule (course_id, schedule_date, period_id, classroom_id, teacher_id) VALUES 
('27', '2026-10-09', 2, '202D', 118),
('27', '2026-10-16', 2, '202D', 118),
('27', '2026-10-23', 2, '202D', 118),
('27', '2026-10-30', 2, '202D', 118),
('27', '2026-11-06', 2, '202D', 118),
('27', '2026-11-13', 2, '202D', 118),
('27', '2026-11-20', 2, '202D', 118),
('27', '2026-11-27', 2, '202D', 118),
('27', '2026-12-04', 2, '202D', 118),
('27', '2026-12-11', 2, '202D', 118),
('27', '2026-12-18', 2, '202D', 118);

-- 講座28（ゲーム開発エンジン入門）: 月曜3時限
INSERT INTO course_schedule (course_id, schedule_date, period_id, classroom_id, teacher_id) VALUES 
('28', '2026-10-05', 3, '202D', 119),
('28', '2026-10-12', 3, '202D', 119),
('28', '2026-10-19', 3, '202D', 119),
('28', '2026-10-26', 3, '202D', 119),
('28', '2026-11-02', 3, '202D', 119),
('28', '2026-11-09', 3, '202D', 119),
('28', '2026-11-16', 3, '202D', 119),
('28', '2026-11-23', 3, '202D', 119),
('28', '2026-11-30', 3, '202D', 119),
('28', '2026-12-07', 3, '202D', 119),
('28', '2026-12-14', 3, '202D', 119),
('28', '2026-12-21', 3, '202D', 119);

-- 講座29（コードリファクタリングとクリーンコード）: 火曜5時限
INSERT INTO course_schedule (course_id, schedule_date, period_id, classroom_id, teacher_id) VALUES 
('29', '2026-10-06', 5, '101A', 101),
('29', '2026-10-13', 5, '101A', 101),
('29', '2026-10-20', 5, '101A', 101),
('29', '2026-10-27', 5, '101A', 101),
('29', '2026-11-03', 5, '101A', 101),
('29', '2026-11-10', 5, '101A', 101),
('29', '2026-11-17', 5, '101A', 101),
('29', '2026-11-24', 5, '101A', 101),
('29', '2026-12-01', 5, '101A', 101),
('29', '2026-12-08', 5, '101A', 101),
('29', '2026-12-15', 5, '101A', 101),
('29', '2026-12-22', 5, '101A', 101);

-- いくつかの授業のステータスを変更（完了、キャンセル）
UPDATE course_schedule SET status = 'completed' WHERE schedule_date < '2025-05-16';

-- 教師の不在情報を考慮したキャンセル授業の設定
-- すでに登録されたスケジュールのうち、教師が不在の日のものをキャンセル状態に更新
UPDATE course_schedule cs
JOIN teacher_unavailability tu ON cs.teacher_id = tu.teacher_id
SET cs.status = 'cancelled'
WHERE cs.schedule_date BETWEEN tu.start_date AND tu.end_date;

-- 祝日や学校行事のためのキャンセル設定（例）
UPDATE course_schedule SET status = 'cancelled' WHERE schedule_date = '2024-05-01'; -- メーデー
UPDATE course_schedule SET status = 'cancelled' WHERE schedule_date = '2024-12-23'; -- 天皇誕生日
UPDATE course_schedule SET status = 'cancelled' WHERE schedule_date = '2025-01-01'; -- 元日
UPDATE course_schedule SET status = 'cancelled' WHERE schedule_date = '2025-05-05'; -- こどもの日

-- ---------------------------------------
-- 出席管理テーブルのデータ
-- ---------------------------------------
-- 講座1の第1回授業（schedule_id = 1）の出席データ
INSERT INTO attendance VALUES (1, 301, 'present', NULL);
INSERT INTO attendance VALUES (1, 302, 'late', '15分遅刻');
INSERT INTO attendance VALUES (1, 303, 'absent', '事前連絡あり');
INSERT INTO attendance VALUES (1, 306, 'present', NULL);
INSERT INTO attendance VALUES (1, 307, 'present', NULL);
INSERT INTO attendance VALUES (1, 308, 'late', '5分遅刻');
INSERT INTO attendance VALUES (1, 310, 'present', NULL);
INSERT INTO attendance VALUES (1, 311, 'present', NULL);
INSERT INTO attendance VALUES (1, 315, 'present', NULL);
INSERT INTO attendance VALUES (1, 317, 'absent', '体調不良');
INSERT INTO attendance VALUES (1, 320, 'present', NULL);
INSERT INTO attendance VALUES (1, 323, 'late', '電車遅延');

-- 講座2の第1回授業（schedule_id = 5）の出席データ
INSERT INTO attendance VALUES (5, 301, 'present', NULL);
INSERT INTO attendance VALUES (5, 309, 'present', NULL);
INSERT INTO attendance VALUES (5, 311, 'absent', '部活動');
INSERT INTO attendance VALUES (5, 312, 'present', NULL);
INSERT INTO attendance VALUES (5, 314, 'present', NULL);
INSERT INTO attendance VALUES (5, 318, 'late', '10分遅刻');
INSERT INTO attendance VALUES (5, 321, 'present', NULL);
INSERT INTO attendance VALUES (5, 324, 'present', NULL);

-- 講座3の第1回授業（schedule_id = 9）の出席データ
INSERT INTO attendance VALUES (9, 310, 'present', NULL);
INSERT INTO attendance VALUES (9, 312, 'present', NULL);
INSERT INTO attendance VALUES (9, 315, 'present', NULL);
INSERT INTO attendance VALUES (9, 319, 'late', '資料忘れで取りに戻る');
INSERT INTO attendance VALUES (9, 321, 'present', NULL);
INSERT INTO attendance VALUES (9, 325, 'absent', '家庭の事情');

-- 講座4の第1回授業（schedule_id = 13）の出席データ
INSERT INTO attendance VALUES (13, 303, 'present', NULL);
INSERT INTO attendance VALUES (13, 305, 'present', NULL);
INSERT INTO attendance VALUES (13, 307, 'present', NULL);
INSERT INTO attendance VALUES (13, 313, 'absent', '他の授業の課題提出');
INSERT INTO attendance VALUES (13, 316, 'late', '教室を間違えた');
INSERT INTO attendance VALUES (13, 320, 'present', NULL);
INSERT INTO attendance VALUES (13, 322, 'present', NULL);

-- 講座5の第1回授業（schedule_id = 17）の出席データ
INSERT INTO attendance VALUES (17, 304, 'present', NULL);
INSERT INTO attendance VALUES (17, 306, 'present', NULL);
INSERT INTO attendance VALUES (17, 309, 'late', '8分遅刻');
INSERT INTO attendance VALUES (17, 313, 'present', NULL);
INSERT INTO attendance VALUES (17, 317, 'present', NULL);
INSERT INTO attendance VALUES (17, 318, 'absent', '病院受診');
INSERT INTO attendance VALUES (17, 324, 'present', NULL);

-- 講座6の第1回授業（schedule_id = 21）の出席データ
INSERT INTO attendance VALUES (21, 308, 'present', NULL);
INSERT INTO attendance VALUES (21, 310, 'present', NULL);
INSERT INTO attendance VALUES (21, 314, 'present', NULL);
INSERT INTO attendance VALUES (21, 316, 'absent', '交通機関の遅延');
INSERT INTO attendance VALUES (21, 319, 'present', NULL);
INSERT INTO attendance VALUES (21, 322, 'late', '12分遅刻');
INSERT INTO attendance VALUES (21, 325, 'present', NULL);

-- 講座1の第2回授業（schedule_id = 2）の出席データ
INSERT INTO attendance VALUES (2, 301, 'present', NULL);
INSERT INTO attendance VALUES (2, 302, 'present', NULL);
INSERT INTO attendance VALUES (2, 303, 'present', NULL);
INSERT INTO attendance VALUES (2, 306, 'late', '道に迷った');
INSERT INTO attendance VALUES (2, 307, 'present', NULL);
INSERT INTO attendance VALUES (2, 308, 'present', NULL);
INSERT INTO attendance VALUES (2, 310, 'absent', 'サークル活動');
INSERT INTO attendance VALUES (2, 311, 'present', NULL);
INSERT INTO attendance VALUES (2, 315, 'present', NULL);
INSERT INTO attendance VALUES (2, 317, 'present', NULL);
INSERT INTO attendance VALUES (2, 320, 'present', NULL);
INSERT INTO attendance VALUES (2, 323, 'present', NULL);

-- 講座8の第1回授業（schedule_id = 29）の出席データ
INSERT INTO attendance VALUES (29, 304, 'present', NULL);
INSERT INTO attendance VALUES (29, 307, 'present', NULL);
INSERT INTO attendance VALUES (29, 309, 'present', NULL);
INSERT INTO attendance VALUES (29, 312, 'late', '教室変更の連絡を見逃した');
INSERT INTO attendance VALUES (29, 315, 'present', NULL);
INSERT INTO attendance VALUES (29, 320, 'absent', '就職活動');
INSERT INTO attendance VALUES (29, 324, 'present', NULL);

-- ---------------------------------------
-- 成績評価テーブルのデータ
-- ---------------------------------------
-- ITのための基礎知識（course_id = 1）の成績
INSERT INTO grades VALUES (301, '1', '中間テスト', 85.5, 100.0, '2025-05-20');
INSERT INTO grades VALUES (302, '1', '中間テスト', 92.0, 100.0, '2025-05-20');
INSERT INTO grades VALUES (303, '1', '中間テスト', 78.5, 100.0, '2025-05-20');
INSERT INTO grades VALUES (306, '1', '中間テスト', 88.0, 100.0, '2025-05-20');
INSERT INTO grades VALUES (307, '1', '中間テスト', 76.5, 100.0, '2025-05-20');
INSERT INTO grades VALUES (308, '1', '中間テスト', 91.0, 100.0, '2025-05-20');
INSERT INTO grades VALUES (310, '1', '中間テスト', 82.5, 100.0, '2025-05-20');
INSERT INTO grades VALUES (311, '1', '中間テスト', 95.0, 100.0, '2025-05-20');
INSERT INTO grades VALUES (315, '1', '中間テスト', 89.5, 100.0, '2025-05-20');
INSERT INTO grades VALUES (317, '1', '中間テスト', 68.0, 100.0, '2025-05-20');
INSERT INTO grades VALUES (320, '1', '中間テスト', 93.5, 100.0, '2025-05-20');
INSERT INTO grades VALUES (323, '1', '中間テスト', 87.0, 100.0, '2025-05-20');

INSERT INTO grades VALUES (301, '1', 'レポート1', 45.0, 50.0, '2025-05-10');
INSERT INTO grades VALUES (302, '1', 'レポート1', 48.0, 50.0, '2025-05-10');
INSERT INTO grades VALUES (303, '1', 'レポート1', 42.5, 50.0, '2025-05-11');
INSERT INTO grades VALUES (306, '1', 'レポート1', 44.0, 50.0, '2025-05-10');
INSERT INTO grades VALUES (307, '1', 'レポート1', 39.5, 50.0, '2025-05-10');
INSERT INTO grades VALUES (308, '1', 'レポート1', 47.0, 50.0, '2025-05-09');
INSERT INTO grades VALUES (310, '1', 'レポート1', 43.5, 50.0, '2025-05-10');
INSERT INTO grades VALUES (311, '1', 'レポート1', 49.0, 50.0, '2025-05-08');
INSERT INTO grades VALUES (315, '1', 'レポート1', 46.5, 50.0, '2025-05-10');
INSERT INTO grades VALUES (317, '1', 'レポート1', 37.0, 50.0, '2025-05-12');
INSERT INTO grades VALUES (320, '1', 'レポート1', 48.5, 50.0, '2025-05-09');
INSERT INTO grades VALUES (323, '1', 'レポート1', 44.0, 50.0, '2025-05-10');

-- UNIX入門（course_id = 2）の成績
INSERT INTO grades VALUES (301, '2', '実技試験', 88.0, 100.0, '2025-05-18');
INSERT INTO grades VALUES (309, '2', '実技試験', 92.5, 100.0, '2025-05-18');
INSERT INTO grades VALUES (311, '2', '実技試験', 78.0, 100.0, '2025-05-18');
INSERT INTO grades VALUES (312, '2', '実技試験', 85.5, 100.0, '2025-05-18');
INSERT INTO grades VALUES (314, '2', '実技試験', 91.0, 100.0, '2025-05-18');
INSERT INTO grades VALUES (318, '2', '実技試験', 79.5, 100.0, '2025-05-18');
INSERT INTO grades VALUES (321, '2', '実技試験', 94.0, 100.0, '2025-05-18');
INSERT INTO grades VALUES (324, '2', '実技試験', 83.5, 100.0, '2025-05-18');

INSERT INTO grades VALUES (301, '2', '課題1', 27.0, 30.0, '2025-05-08');
INSERT INTO grades VALUES (309, '2', '課題1', 29.5, 30.0, '2025-05-07');
INSERT INTO grades VALUES (311, '2', '課題1', 25.0, 30.0, '2025-05-08');
INSERT INTO grades VALUES (312, '2', '課題1', 28.0, 30.0, '2025-05-08');
INSERT INTO grades VALUES (314, '2', '課題1', 30.0, 30.0, '2025-05-06');
INSERT INTO grades VALUES (318, '2', '課題1', 24.5, 30.0, '2025-05-09');
INSERT INTO grades VALUES (321, '2', '課題1', 29.0, 30.0, '2025-05-07');
INSERT INTO grades VALUES (324, '2', '課題1', 26.5, 30.0, '2025-05-08');

-- Cプログラミング演習（course_id = 3）の成績
INSERT INTO grades VALUES (310, '3', 'プログラミング課題1', 43.0, 50.0, '2025-05-12');
INSERT INTO grades VALUES (312, '3', 'プログラミング課題1', 48.5, 50.0, '2025-05-10');
INSERT INTO grades VALUES (315, '3', 'プログラミング課題1', 45.0, 50.0, '2025-05-11');
INSERT INTO grades VALUES (319, '3', 'プログラミング課題1', 39.5, 50.0, '2025-05-13');
INSERT INTO grades VALUES (321, '3', 'プログラミング課題1', 47.0, 50.0, '2025-05-10');
INSERT INTO grades VALUES (325, '3', 'プログラミング課題1', 42.5, 50.0, '2025-05-12');

-- Webアプリケーション開発（course_id = 4）の成績
INSERT INTO grades VALUES (303, '4', 'プロジェクト企画書', 18.5, 20.0, '2025-05-15');
INSERT INTO grades VALUES (305, '4', 'プロジェクト企画書', 17.0, 20.0, '2025-05-15');
INSERT INTO grades VALUES (307, '4', 'プロジェクト企画書', 19.0, 20.0, '2025-05-14');
INSERT INTO grades VALUES (313, '4', 'プロジェクト企画書', 16.5, 20.0, '2025-05-16');
INSERT INTO grades VALUES (316, '4', 'プロジェクト企画書', 18.0, 20.0, '2025-05-15');
INSERT INTO grades VALUES (320, '4', 'プロジェクト企画書', 19.5, 20.0, '2025-05-14');
INSERT INTO grades VALUES (322, '4', 'プロジェクト企画書', 17.5, 20.0, '2025-05-15');

-- データベース設計と実装（course_id = 5）の成績
INSERT INTO grades VALUES (304, '5', 'ER図作成課題', 27.5, 30.0, '2025-05-16');
INSERT INTO grades VALUES (306, '5', 'ER図作成課題', 26.0, 30.0, '2025-05-16');
INSERT INTO grades VALUES (309, '5', 'ER図作成課題', 29.0, 30.0, '2025-05-15');
INSERT INTO grades VALUES (313, '5', 'ER図作成課題', 25.5, 30.0, '2025-05-16');
INSERT INTO grades VALUES (317, '5', 'ER図作成課題', 28.0, 30.0, '2025-05-15');
INSERT INTO grades VALUES (318, '5', 'ER図作成課題', 24.0, 30.0, '2025-05-17');
INSERT INTO grades VALUES (324, '5', 'ER図作成課題', 27.0, 30.0, '2025-05-16');

-- ネットワークセキュリティ（course_id = 6）の成績
INSERT INTO grades VALUES (308, '6', '小テスト1', 18.0, 20.0, '2025-05-15');
INSERT INTO grades VALUES (310, '6', '小テスト1', 19.5, 20.0, '2025-05-15');
INSERT INTO grades VALUES (314, '6', '小テスト1', 17.0, 20.0, '2025-05-15');
INSERT INTO grades VALUES (316, '6', '小テスト1', 16.5, 20.0, '2025-05-15');
INSERT INTO grades VALUES (319, '6', '小テスト1', 18.5, 20.0, '2025-05-15');
INSERT INTO grades VALUES (322, '6', '小テスト1', 17.5, 20.0, '2025-05-15');
INSERT INTO grades VALUES (325, '6', '小テスト1', 19.0, 20.0, '2025-05-15');