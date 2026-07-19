# Lunablade 构建记录

## 概况

- 构建工具：Codex curated skill `hatch-pet`
- 样式：非像素、动漫风格角色 sprite
- 标准 atlas：1536 × 1872 WebP/PNG
- 单元格：192 × 208
- canonical reference：`run/references/canonical-base.png`
- 安装包：`package/pet.json + package/spritesheet.webp`

## 标准状态

标准 atlas 保存以下九个 hatch-pet 状态：

1. `idle`
2. `running-right`
3. `running-left`
4. `waving`
5. `jumping`
6. `failed`
7. `waiting`
8. `running`
9. `review`

## 扩展实验

`run/final/spritesheet-extended.*` 是 1536 × 2288 的方向观察扩展稿。它属于
构建研究资料，不是当前 Codex 安装包。相关 prompt、方向锚点和 QA 均保留在
`run/` 中。

## 可追溯资产

原始工作目录中的以下内容已原样纳入版本控制：

- 生成 prompts 和重试 prompts
- decoded base 与动作行
- canonical base、布局 guides 和方向锚点
- 所有拆分 frames
- 标准与扩展 spritesheets
- contact sheets、方向检查和动作 GIF previews

## 已知缺失的原始运行记录

导入仓库时，原始 hatch-pet 工作目录没有以下文件：

- `pet_request.json`
- `imagegen-jobs.json`
- 原始 `final/validation.json`
- 原始 `qa/review.json`
- 原始 `qa/run-summary.json`

这些历史文件没有被伪造。现有图片、prompt 和 QA 资产仍然保留了主要构建
过程；但无法仅凭现有文件还原当时每个 imagegen job 的精确时间、source path
和选择记录。

## 后补确定性验证

2026-07-19 使用当前本机的 curated `hatch-pet` 脚本，对保留的 frames 和
标准 WebP 重新执行了：

```text
inspect_frames.py --require-components
validate_atlas.py
```

结果写入：

- `run/qa/review.json`
- `run/final/validation.json`

两项检查均通过，零 errors、零 warnings；atlas 为 RGBA WebP、1536 × 1872，
透明像素不存在隐藏 RGB 残留。这是后补验证，不冒充原始运行记录。

## 包装

`scripts/package-pet.ps1 -PetId lunablade` 从
`run/final/spritesheet.webp` 复制安装图并根据 `build.json` 生成
`package/pet.json`。因此 package 可以随时从受审查的 run 产物重建。

重做的 v2 版本使用独立 id `lucyblade`，不会覆盖此 v1 package。
