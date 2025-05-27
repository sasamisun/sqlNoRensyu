#!/usr/bin/env python3
# -*- coding: utf-8 -*-

"""
MDファイルマージツール

【概要】
フォルダ内のmdファイルを、ファイル名の最初の2文字でグループ化してマージするツールです。
ファイル数が多い場合に、効率的に整理できます。

【使用方法】
1. 対話型実行:
   python md_merger.py
   
   実行すると以下の入力を求められます：
   - 入力フォルダのパス (Enter: カレントフォルダ)
   - 出力フォルダのパス (Enter: ./output)

2. 関数として使用:
   from md_merger import merge_md_files
   
   # 基本的な使用
   merge_md_files("./markdown_files")
   
   # 出力フォルダを指定
   merge_md_files("./input_folder", "./output_folder")

【例】
以下のファイルがある場合：
- 01_intro.md
- 01_basic.md
- 02_advanced.md
- 02_tips.md
- 03_summary.md

結果：
- 01_merged.md (01_intro.md と 01_basic.md をマージ)
- 02_merged.md (02_advanced.md と 02_tips.md をマージ)
- 03_summary.md はスキップ (1ファイルのみ)

【デフォルト値】
- 入力フォルダ: . (カレントフォルダ)
- 出力フォルダ: ./output

【出力ファイル形式】
マージされたファイルには以下が含まれます：
- グループのヘッダー
- マージされたファイルのリスト
- 各ファイルの内容（ファイル名付きのセクションとして）
"""

import os
import glob
from pathlib import Path
from collections import defaultdict

def merge_md_files(input_folder, output_folder=None):
    """
    指定されたフォルダ内のmdファイルを、ファイル名の最初の2文字でグループ化してマージする
    
    Args:
        input_folder (str): 入力フォルダのパス
        output_folder (str): 出力フォルダのパス（Noneの場合は入力フォルダと同じ）
    """
    
    # パスの設定
    input_path = Path(input_folder)
    if output_folder is None:
        output_path = input_path
    else:
        output_path = Path(output_folder)
        output_path.mkdir(parents=True, exist_ok=True)
    
    # mdファイルの検索
    md_files = list(input_path.glob("*.md"))
    
    if not md_files:
        print(f"エラー: {input_folder} にmdファイルが見つかりません")
        return
    
    print(f"見つかったmdファイル数: {len(md_files)}")
    
    # ファイル名順にソート
    md_files.sort(key=lambda x: x.name)
    
    # 最初の2文字でグループ化
    groups = defaultdict(list)
    for file_path in md_files:
        file_name = file_path.name
        # 拡張子を除いたファイル名の最初の2文字を取得
        base_name = file_path.stem
        if len(base_name) >= 2:
            prefix = base_name[:2]
        else:
            prefix = base_name  # 1文字の場合はそのまま使用
        
        groups[prefix].append(file_path)
    
    print(f"グループ数: {len(groups)}")
    
    # 各グループをマージ
    for prefix, files in groups.items():
        if len(files) == 1:
            print(f"グループ '{prefix}': 1ファイルのみのためスキップ - {files[0].name}")
            continue
        
        print(f"グループ '{prefix}': {len(files)}ファイルをマージ中...")
        
        # マージ後のファイル名
        output_file = output_path / f"{prefix}_merged.md"
        
        try:
            with open(output_file, 'w', encoding='utf-8') as outf:
                # ヘッダーを追加
                outf.write(f"# {prefix} - マージされたファイル\n\n")
                outf.write(f"以下のファイルがマージされています:\n")
                for file_path in files:
                    outf.write(f"- {file_path.name}\n")
                outf.write("\n" + "="*80 + "\n\n")
                
                # 各ファイルの内容を追加
                for i, file_path in enumerate(files):
                    print(f"  - {file_path.name} を処理中...")
                    
                    try:
                        with open(file_path, 'r', encoding='utf-8') as inf:
                            content = inf.read().strip()
                        
                        # ファイル区切りヘッダーを追加
                        outf.write(f"## ファイル {i+1}: {file_path.name}\n\n")
                        outf.write(content)
                        outf.write("\n\n" + "-"*60 + "\n\n")
                        
                    except UnicodeDecodeError:
                        print(f"    警告: {file_path.name} の文字エンコーディングに問題があります")
                        try:
                            with open(file_path, 'r', encoding='shift_jis') as inf:
                                content = inf.read().strip()
                            outf.write(f"## ファイル {i+1}: {file_path.name}\n\n")
                            outf.write(content)
                            outf.write("\n\n" + "-"*60 + "\n\n")
                        except Exception as e:
                            print(f"    エラー: {file_path.name} を読み込めませんでした - {e}")
                            outf.write(f"## ファイル {i+1}: {file_path.name}\n\n")
                            outf.write(f"**エラー: ファイルを読み込めませんでした ({e})**\n\n")
                            outf.write("-"*60 + "\n\n")
                    
                    except Exception as e:
                        print(f"    エラー: {file_path.name} の処理中にエラーが発生しました - {e}")
                        outf.write(f"## ファイル {i+1}: {file_path.name}\n\n")
                        outf.write(f"**エラー: ファイルの処理中にエラーが発生しました ({e})**\n\n")
                        outf.write("-"*60 + "\n\n")
            
            print(f"  完了: {output_file}")
            
        except Exception as e:
            print(f"エラー: グループ '{prefix}' のマージ中にエラーが発生しました - {e}")
    
    print("\nマージ処理が完了しました")

def main():
    """メイン関数"""
    print("=== MDファイルマージツール ===")
    print("ファイル名の最初の2文字が同じmdファイルをグループ化してマージします\n")
    
    # 入力フォルダの指定
    while True:
        input_folder = input("入力フォルダのパス（Enter: カレントフォルダ）: ").strip()
        if not input_folder:
            input_folder = "."  # デフォルト: カレントフォルダ
        
        input_path = Path(input_folder)
        if not input_path.exists():
            print(f"エラー: フォルダ '{input_folder}' が存在しません")
            continue
        
        if not input_path.is_dir():
            print(f"エラー: '{input_folder}' はフォルダではありません")
            continue
        
        break
    
    # 出力フォルダの指定（オプション）
    output_folder = input("出力フォルダのパス（Enter: ./output）: ").strip()
    if not output_folder:
        output_folder = "./output"  # デフォルト: ./output
    
    # 確認
    print(f"\n設定:")
    print(f"  入力フォルダ: {input_folder}")
    print(f"  出力フォルダ: {output_folder}")
    
    confirm = input("\n実行しますか？ (y/N): ").strip().lower()
    if confirm not in ['y', 'yes']:
        print("キャンセルしました")
        return
    
    # マージ実行
    print("\nマージを開始します...")
    merge_md_files(input_folder, output_folder)

if __name__ == "__main__":
    main()