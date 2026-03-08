# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## プロジェクト概要

TextVRAMは、VGAディスプレイ用のテキストVRAMコントローラーをVerilogで実装したプロジェクトです。
デュアルポートBRAMを使用して、CPUからの書き込みと表示用の読み出しを同時に行えます。

## 主要な仕様

- **解像度**: デフォルト 640x480 (VGA) - パラメータで変更可能
- **テキストサイズ**: 80列 x 60行（8x8ピクセルフォント使用時）
- **フォント**: 8x8ピクセル ASCII（0x20-0x7F対応）
- **出力**: モノクロ（1ビット）、HSYNC、VSYNC、pixel_en、pixel_data
- **クロック**: 25.175MHz（VGA 640x480@60Hz用）

## ディレクトリ構成

```
TextVRAM/
├── rtl/                  # RTLソースファイル
│   ├── text_vram_top.v   # トップモジュール（統合）
│   ├── vga_timing.v      # VGAタイミングジェネレータ
│   ├── text_vram.v       # デュアルポートVRAM (BRAM)
│   ├── font_rom.v        # 8x8 ASCIIフォントROM
│   └── preset.v          # (その他のモジュール)
├── bench/                # テストベンチ
│   ├── tb_text_vram.v    # メインテストベンチ
│   └── tb_preset.v       # preset用テストベンチ
├── Makefile              # ビルド・シミュレーション用
└── README.txt            # 日本語の説明書
```

## ビルド・シミュレーションコマンド

### Icarus Verilogを使用

```bash
# メインシミュレーション実行
make sim

# または直接実行
make

# 波形ビューア起動
make wave

# クリーンアップ
make clean

# preset.v用のシミュレーション（MEMO.txtに記載のコマンド）
iverilog -g2012 -Wall -s tb_preset -o simv ./rtl/preset.v ./bench/tb_preset.v && vvp simv
```

シミュレーション実行後、`tb_text_vram.vcd`が生成され、GTKWaveで波形確認が可能です。

## アーキテクチャ概要

### データフロー

1. **VGAタイミング生成** (`vga_timing.v`)
   - 水平・垂直同期信号、ピクセル座標を生成
   - パラメータで解像度・同期極性を変更可能

2. **VRAM読み出し** (`text_vram.v`)
   - 表示位置からキャラクタコードを読み出し
   - CPUポート（cpu_clk）と表示ポート（pixel_clk）のデュアルポート構成
   - BRAMとして合成される（`(* ram_style = "block" *)`属性付き）
   - 初期化時に全てスペース（0x20）で埋められる

3. **フォントROM参照** (`font_rom.v`)
   - キャラクタコードと行番号からフォントデータ（8ピクセル分）を取得
   - 128文字 x 8行 = 1024エントリのROM

4. **パイプライン処理** (`text_vram_top.v`)
   - VRAM読み出し: 1サイクル遅延
   - フォントROM読み出し: 1サイクル遅延
   - 合計2サイクルのパイプライン遅延
   - 同期信号とピクセル位置情報も同じ遅延でパイプライン処理

5. **ピクセル出力**
   - フォントデータからビット選択して1ビット出力
   - MSBファースト（bit 7 = 最左ピクセル）

### モジュール間接続

```
vga_timing → pixel_x, pixel_y, hsync, vsync, pixel_en
    ↓
text_vram_top (キャラクタ位置計算)
    ↓
text_vram → char_code
    ↓
font_rom → font_row_data
    ↓
ビット選択 → pixel_data
```

## パラメータカスタマイズ

`text_vram_top`モジュールのパラメータで解像度やタイミングを変更可能：

```verilog
text_vram_top #(
    .H_ACTIVE(800),      // 水平解像度
    .V_ACTIVE(600),      // 垂直解像度
    .H_SYNC_POL(1),      // 同期極性
    .V_SYNC_POL(1)
) u_tvram (...);
```

COLS（列数）とROWS（行数）は自動計算されます：
- `COLS = H_ACTIVE / CHAR_WIDTH`
- `ROWS = V_ACTIVE / CHAR_HEIGHT`

## テストベンチの動作

`tb_text_vram.v`は以下を実行します：

1. リセット後、VRAMに文字列を書き込み
   - 0行目: "Hello World!"
   - 1行目: "FPGA"
   - 2行目: "0123456789"

2. 3フレーム分の表示期間を待機

3. HSYNCとVSYNCのパルス数をカウントして表示

## コーディング規約

- **言語**: Verilog (IEEE 1364-2001準拠)
- **スタイル**:
  - モジュール名、信号名はスネークケース（`text_vram_top`、`pixel_en`）
  - パラメータは大文字（`H_ACTIVE`、`COLS`）
  - ローカルパラメータは`localparam`使用
  - リセットは`rst_n`（アクティブロー）
- **合成属性**: BRAM推論用に`(* ram_style = "block" *)`を使用
- **タイミング**: すべて同期設計（`always @(posedge clk)`）

## 開発時の注意点

- フォントROMの初期化は`initial`ブロックで実施（シミュレーション用）
- 実機合成時はフォントデータの初期化方法を要確認（.memファイル等）
- VRAMアドレスは`row * COLS + col`で計算
- パイプライン遅延を考慮した信号タイミング調整が重要
