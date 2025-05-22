import os
import re
from pathlib import Path

def merge_markdown_files(input_folder, output_file):
    """
    指定したフォルダ内のMarkdownファイルを一つのファイルにマージします
    
    Args:
        input_folder (str): 入力フォルダのパス
        output_file (str): 出力ファイルのパス
    """
    
    # 入力フォルダが存在するかチェック
    if not os.path.exists(input_folder):
        print(f"エラー: フォルダ '{input_folder}' が見つかりません。")
        return
    
    # Markdownファイルを取得
    md_files = []
    for file in os.listdir(input_folder):
        if file.endswith('.md'):
            md_files.append(file)
    
    if not md_files:
        print(f"フォルダ '{input_folder}' にMarkdownファイルが見つかりません。")
        return
    
    # ファイル名でソート（番号順になるように）
    md_files.sort()
    
    print(f"見つかったMarkdownファイル: {len(md_files)}個")
    for file in md_files:
        print(f"  - {file}")
    
    # マージ処理
    merged_content = []
    toc_entries = []  # 目次用
    
    # タイトルとイントロダクション
    merged_content.append("# SQL学習テキスト 完全版")
    merged_content.append("")
    merged_content.append("このテキストは、SQLの基礎から応用まで体系的に学習できるように構成されています。")
    merged_content.append("学校データベースを使った実践的な例題と練習問題を通じて、実務で使えるSQLスキルを身につけることができます。")
    merged_content.append("")
    merged_content.append("---")
    merged_content.append("")
    
    # 各ファイルを処理
    for i, filename in enumerate(md_files, 1):
        file_path = os.path.join(input_folder, filename)
        
        print(f"処理中: {filename}")
        
        with open(file_path, 'r', encoding='utf-8') as file:
            content = file.read()
        
        # ファイルの最初の見出し（章タイトル）を取得
        lines = content.split('\n')
        chapter_title = ""
        for line in lines:
            if line.startswith('# '):
                chapter_title = line[2:].strip()
                break
        
        if chapter_title:
            toc_entries.append(f"{i}. [{chapter_title}](#{create_anchor(chapter_title)})")
        
        # 各章の間にページ区切りを追加
        if i > 1:
            merged_content.append("")
            merged_content.append("---")
            merged_content.append("")
        
        # ファイル内容を追加
        merged_content.append(content)
        merged_content.append("")
    
    # 目次を作成して先頭に挿入
    toc_content = ["## 目次", ""]
    toc_content.extend(toc_entries)
    toc_content.extend(["", "---", ""])
    
    # 目次をメインコンテンツの前に挿入
    final_content = merged_content[:6] + toc_content + merged_content[6:]
    
    # ファイルに書き出し
    try:
        with open(output_file, 'w', encoding='utf-8') as file:
            file.write('\n'.join(final_content))
        
        print(f"\n✅ マージ完了!")
        print(f"📄 出力ファイル: {output_file}")
        print(f"📊 マージしたファイル数: {len(md_files)}個")
        print(f"📏 総行数: {len(final_content)}行")
        
    except Exception as e:
        print(f"❌ ファイル書き出しエラー: {e}")

def create_anchor(title):
    """
    章タイトルからMarkdownアンカーリンクを作成
    """
    # 日本語や記号を含むタイトルに対応
    anchor = title.lower()
    anchor = re.sub(r'[^\w\s-]', '', anchor)  # 特殊文字を除去
    anchor = re.sub(r'[-\s]+', '-', anchor)   # スペースとハイフンを正規化
    return anchor.strip('-')

def main():
    """
    メイン実行関数
    """
    print("=" * 50)
    print("📚 Markdownファイル マージツール")
    print("=" * 50)
    
    # デフォルト設定
    default_input = "."  # カレントフォルダ
    default_output = "SQL学習テキスト_完全版.md"
    
    # 入力フォルダの指定
    input_folder = input(f"入力フォルダ名 (デフォルト: {default_input}): ").strip()
    if not input_folder:
        input_folder = default_input
    
    # 出力ファイル名の指定
    output_file = input(f"出力ファイル名 (デフォルト: {default_output}): ").strip()
    if not output_file:
        output_file = default_output
    
    # マージ実行
    merge_markdown_files(input_folder, output_file)

if __name__ == "__main__":
    main()