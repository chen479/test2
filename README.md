# 基于GitHub的数字信号处理教材知识体系构建与资源管理平台

本项目是一个功能完整的数字信号处理（DSP）教材知识体系构建与资源管理平台，基于GitHub平台实现，旨在提供系统化的DSP学习资源和自动化管理方案。

## 项目功能

1. **知识体系结构化建模**：研究DSP课程知识体系的结构化建模方法，设计适合版本控制与自动化管理的知识元数据规范与分类体系。

2. **版本管理策略**：利用Git的分支、标签、提交历史等核心功能，对教材（PDF）、源代码（Python/Matlab）、实验手册、课件、数据文件等异构资源进行有效的版本追踪、协同编辑与历史回溯。

3. **CI/CD自动化流水线**：利用GitHub Actions构建自动化工作流，实现针对代码资源的自动语法检查与测试、文档资源的自动格式校验与构建、以及整体知识仓库的自动打包与发布。

4. **静态站点生成**：应用Jekyll静态网站生成器，将GitHub仓库中结构化的Markdown文档、代码示例等资源，动态生成为一个具备良好导航、搜索与阅读体验的可公开访问网站（GitHub Pages）。

5. **可维护性与可扩展性**：设计清晰的仓库目录结构、规范的提交信息约定、完善的README与贡献指南，确保平台易于后续维护、功能扩展，并能作为模板推广至其他课程。

## 预期成果

- **功能完整的GitHub仓库实例**：包含精心设计的目录结构、示例性的DSP课程资源（如FFT、滤波器设计等经典理论的代码与文档），并实践完整的Git工作流。

- **可复用的CI/CD自动化配置方案**：以YAML文件形式提供，能够自动完成资源校验、网站构建与部署，提升资源更新效率。

- **部署在GitHub Pages上的静态知识门户网站**：网站内容与仓库同步，直观展示DSP知识体系，提供资源的在线浏览与下载。

## 仓库目录结构

```
.
├── .github/            # GitHub相关配置
│   ├── workflows/      # GitHub Actions工作流配置
│   │   ├── ci.yml      # 持续集成配置
│   │   └── pages.yml   # GitHub Pages部署配置
│   └── dependabot.yml  # 依赖自动更新配置
├── _includes/          # Jekyll模板包含文件
├── codes/              # 代码资源
│   ├── examples/       # 示例代码
│   ├── labs/           # 实验代码
│   └── projects/       # 项目代码
├── docs/               # 文档资源
│   ├── chapter1-intro.md         # 第一章：引言
│   ├── chapter2-discrete-signals.md  # 第二章：离散信号
│   ├── chapter3-ztransform.md    # 第三章：Z变换
│   ├── chapter4-dft.md            # 第四章：离散傅里叶变换
│   ├── chapter5-fft.md            # 第五章：快速傅里叶变换
│   ├── chapter6-iir-filter.md     # 第六章：IIR滤波器
│   ├── chapter7-fir-filter.md     # 第七章：FIR滤波器
│   └── about.md                   # 关于本项目
├── resources/          # 其他资源
├── .gitignore          # Git忽略文件配置
├── Gemfile             # Ruby依赖配置
├── Gemfile.lock        # Ruby依赖锁定文件
├── LICENSE             # 许可证文件
├── README.md           # 项目说明文件
├── _config.yml         # Jekyll配置文件
├── convert_encoding.py # 编码转换工具
└── index.md            # 网站首页
```

## 快速开始

### 本地构建与预览

假设您已安装 [Jekyll] 和 [Bundler]：

1. 进入项目根目录
2. 运行 `bundle install` 安装依赖
3. 运行 `bundle exec jekyll serve` 构建并预览网站，访问 `localhost:4000/test2`

### 部署到GitHub Pages

1. 确保您的 `_config.yml` 文件配置正确
2. 推送代码到GitHub仓库的 `main` 分支
3. GitHub Actions 将自动构建并部署网站
4. 访问 `https://your-username.github.io/test2` 查看部署结果

## 贡献指南

请参阅 [CONTRIBUTING.md](CONTRIBUTING.md) 文件了解如何贡献代码和资源。

## 代码规范

- 提交信息应遵循 [Conventional Commits](https://www.conventionalcommits.org/) 规范
- 代码应包含适当的注释和文档
- 新增功能应添加相应的测试

## 许可证

本项目采用 [MIT License](LICENSE) 许可证。

[Jekyll]: https://jekyllrb.com
[Bundler]: https://bundler.io
