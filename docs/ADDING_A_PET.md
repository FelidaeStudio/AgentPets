# 新增一个 Pet

## 1. 选择公开 ID

Pet ID 必须使用小写字母、数字，以及单个 `-` 或 `_` 分隔符，例如
`moon-cat` 或 `moon_cat`。不能使用空格、连续分隔符或首尾分隔符。

工作目录固定为：

```text
pets/<pet-id>/run/
```

新生成 Pet 必须遵循 hatch-pet v2 contract：

- atlas：`1536 × 2288`
- 网格：8 列 × 11 行
- cell：`192 × 208`
- manifest：`spriteVersionNumber: 2`
- rows 0–8：九个标准动画状态
- rows 9–10：16 个顺时针 look directions

`1536 × 1872` 的 8 × 9 v1 atlas 只允许作为明确记录的旧包或 results-only
导入，不是新 Pet 的生成目标。

## 2. 保存完整构建证据

不要清理 active run。仓库要求保留 prompts、references、decoded strips、
frames、最终 atlas、QA、manifests、失败候选和修复记录。

目标结构：

```text
pets/<pet-id>/
├── README.md
├── BUILD.md
├── build.json
├── package/
│   ├── pet.json
│   └── spritesheet.webp
└── run/
    ├── pet_request.json
    ├── imagegen-jobs.json
    ├── prompts/
    ├── references/
    ├── decoded/
    ├── frames/
    ├── final/
    │   ├── spritesheet-extended.png
    │   ├── spritesheet-extended.webp
    │   └── validation-extended.json
    └── qa/
        ├── contact-sheet-extended.png
        ├── previews/
        ├── review.json
        ├── chroma-despill-extended.json
        ├── look-directions.png
        ├── direction-semantics.json
        ├── direction-blind-pairs.png
        ├── direction-blind-answer-key.json
        ├── direction-blind-verdicts.json
        ├── direction-blind-validation.json
        ├── look-continuity.json
        ├── final-visual-qa.md
        └── run-summary.json
```

如果 blind review 使用了允许的 minor override，还必须保留
`qa/blind-review-resolution.json`。

## 3. 记录来源和决策

`BUILD.md` 至少记录：

- 使用的工具或 skill；
- 输入页面、参考图和 canonical base；
- 参考资料的用途，以及是否复制了第三方图片；
- 样式、身份约束和不可镜像的非对称特征；
- 九个标准状态和 16 个 look directions；
- 被拒绝的尝试、完整行修复及选择理由；
- deterministic validation、blind review、semantic review、continuity 和
  final visual QA 结果；
- 缺失或未保存的历史文件；
- rights/licensing 状态和
  [FAN-CONTENT-NOTICE.md](../FAN-CONTENT-NOTICE.md)。

`build.json` 是仓库自动化元数据，不是 Codex 官方 manifest。路径必须使用
仓库相对路径；不要保存用户目录、Downloads、Codex generated storage、本机
工作区或私人邮箱。

## 4. 生成安装包

Windows PowerShell：

```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File scripts/package-pet.ps1 -PetId <pet-id>
```

PowerShell 7：

```powershell
pwsh -NoProfile -File scripts/package-pet.ps1 -PetId <pet-id>
```

`package/` 中只能有：

```text
pet.json
spritesheet.webp
```

新 v2 package 的 `pet.json` 必须包含 `spriteVersionNumber: 2`。

## 5. 登记和验证

在 `catalog.json` 添加 build、run、package 和 preview 的仓库相对路径，并在
根 README 表格登记 Pet。

运行：

```powershell
pwsh -NoProfile -File tests/validate-publication.ps1
pwsh -NoProfile -File tests/cross-platform.ps1
pwsh -NoProfile -File scripts/validate-pets.ps1
```

仓库验证器会检查 package hash、atlas、QA、manifest，并自动运行
`scripts/validate-publication.ps1`。

## 6. 测试安装

安装到临时 Codex home，不要覆盖真实配置：

```powershell
$temporaryCodexHome = Join-Path ([IO.Path]::GetTempPath()) "agentpets-install-test"
pwsh -NoProfile -File scripts/install-pet.ps1 `
  -PetId <pet-id> `
  -CodexHome $temporaryCodexHome
```

也可以验证所有 catalog pets：

```powershell
pwsh -NoProfile -File tests/install-all.ps1
```

## 7. 发布前检查

阅读 [PUBLISHING.md](PUBLISHING.md) 和根目录
[FAN-CONTENT-NOTICE.md](../FAN-CONTENT-NOTICE.md)。

本仓库不包含许可证，也不授予代码或美术复用许可。不要直接推送含本地路径、
私人提交邮箱或旧敏感历史的分支；公开仓库应从已验证快照建立新的干净历史。
