# 使用GNU工具進行MIPS組譯
[自己動手寫CPU]上面的編譯環境設定有點久遠了，我另外設定。

## 安裝WSL
因為我電腦是widnows的關係，WSL可以直接在windows跑Linux<br>
wsl --install
執行wsl.exe<br>

## 安裝toolchian
進入linux環境<br>
  sudo apt-get install gcc-mips-linux-gnu

測試<br>
  mips-linux-gnu-gcc --version

正常的話會顯示
mips-linux-gnu-gcc (Ubuntu 12.3.0-17ubuntu1) 12.3.0
Copyright (C) 2022 Free Software Foundation, Inc.
This is free software; see the source for copying conditions.  There is NO
warranty; not even for MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.

## 進行MIPS組譯

建立 inst_rom.S
  mkdir -p ~/mips-test
  cd ~/mips-test

使用 nano 建立並編輯檔案
  nano inst_rom.S

內容
  .org 0x0               # 程式從位址 0x0 開始
  .global _start         # 定義全域入口點 _start
  .set noat              # 允許使用暫存器 $1（避免 AT 警告）
  
  _start:
      ori $1, $0, 0x1100  # $1 = 0x1100
      ori $2, $0, 0x0020  # $2 = 0x0020
      ori $3, $0, 0xff00  # $3 = 0xff00
      ori $4, $0, 0xffff  # $4 = 0xffff

儲存 Ctrl + O
退出 Ctrl + X

