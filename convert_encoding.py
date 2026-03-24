#!/usr/bin/env python3

# 转换文件编码为UTF-8
file_path = 'docs/chapter2-discrete-signals.md'

# 尝试使用不同的编码读取文件
try:
    with open(file_path, 'r', encoding='gbk') as f:
        content = f.read()
except UnicodeDecodeError:
    try:
        with open(file_path, 'r', encoding='utf-8') as f:
            content = f.read()
    except UnicodeDecodeError:
        with open(file_path, 'r', encoding='latin-1') as f:
            content = f.read()

# 以UTF-8编码写入文件
with open(file_path, 'w', encoding='utf-8') as f:
    f.write(content)

print(f"文件 {file_path} 已转换为UTF-8编码")