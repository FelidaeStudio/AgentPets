# Lucyna Kushinada results-only 导入记录

## 来源

- 用户提供文件：`local-imports/lucy-codex-pet.zip`
- 仓库归档：`run/source/lucy-codex-pet.zip`
- 公开 Pet id：`lucyna_kushinada`
- 显示名称：`Lucyna Kushinada`
- 原始 atlas：1536 × 1872 RGBA PNG，8 × 9，单元格 192 × 208
- sprite contract：v1

## 已知构建历史缺失

ZIP 只包含 `lucy/pet.json` 与 `lucy/spritesheet.png`。以下历史资料没有随 ZIP 提供，因此没有在仓库中伪造：

- 生成 prompts 与参考图
- decoded 动画 row strips
- 拆分 frames
- imagegen jobs manifest
- 原始 QA、选择理由与失败候选

PNG 原始产物保存在 `run/source/`。为避免公开私人标识，manifest 与归档中的
Pet id 在发布前统一规范化为公开 id；这一隐私处理明确记录在 `build.json`，
不冒充未经处理的原始 manifest。

## 后补确定性处理

2026-07-21 使用当前 `hatch-pet` 脚本完成：

1. 将原始 atlas 规范化为 `run/final/spritesheet.png`。
2. 确定性导出 `run/final/spritesheet.webp`。
3. 执行 `validate_atlas.py`，结果写入 `run/final/validation.json`。
4. 生成 `run/qa/contact-sheet.png` 并进行独立视觉检查。

验证确认 atlas 为 1536 × 1872、RGBA、8 × 9、v1，零 errors、零 warnings。以上都是导入后的后补验证，不冒充原始构建记录。

## 打包

从仓库根目录运行：

```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File scripts/package-pet.ps1 -PetId lucyna_kushinada
```

仓库安装包使用 WebP，因此 package manifest 的 `spritesheetPath` 为 `spritesheet.webp`；ZIP 内原始 manifest 仍保留在 `run/source/pet.json`。
