# Lucyblade 构建记录

## 当前产物

- 构建工具：Codex `hatch-pet` v2
- 显示名称：`Lucyblade`
- 描述：`A tiny pixel-chibi cyberpunk netrunner inspired by Lucy, wielding a vivid blue lightsaber.`
- atlas：1536 × 2288，8 × 11，单元格 192 × 208
- manifest：`spriteVersionNumber: 2`
- Pet id：`lucyblade`
- canonical reference：`run/references/canonical-base.png`
- 安装包：`package/pet.json + package/spritesheet.webp`

前九行包含 `idle`、`running-right`、`running-left`、`waving`、`jumping`、`failed`、`waiting`、`running` 和 `review`。第 10–11 行包含 16 个按屏幕坐标顺时针排列的 look directions。

## Lucy 与 lightsaber 约束

重做时固定了银白色短 bob、淡紫发梢、不对称长刘海、紫色眼睛、黑白红赛博服装和像素 chibi 比例。每个有效帧必须只有一把蓝色 lightsaber，剑柄与同一只手连接，不允许复制、脱手、光晕、拖尾或游离特效。

视觉参考来自 [OpenPets 上 huiishan99 的 Lucy Pet](https://openpets.sh/pets/github-huiishan99-web-shan-verse-0a60ae41)。本地留档及用途说明保存在 `rework-inputs/`；参考图用于角色辨识和像素 chibi 方向，不直接复制其最终动画帧。

## 构建与 QA

完整的新构建位于 `run/`，包括请求、jobs manifest、原始生成选择、prompt、布局 guide、拆分帧、注册数据、失败候选、atlas、GIF 和所有 QA 报告。

九条标准动画均在生成后立即拆帧检查，随后合成标准 contact sheet 做独立视觉 QA。四个 cardinal anchors 经过语义门禁；最初的 `000` 因看起来像正视而被拒绝并单独重做。

`look-row-10` 经历了多次完整重生成：错误的屏幕左右、`337.5 → 000` 闭环跳变和单元格边缘风险都触发了拒绝。所有失败整行保存在 `run/generated/rejected/`。最终候选通过结构注册和带标签视觉检查。

最终 atlas 只执行一次绿边去染色，严格验证结果为 1536 × 2288 RGBA、v2、零 errors、零 warnings，见 `run/final/validation.json`。

三名互相隔离的审查者只查看无答案 A/B 方向表；hard cardinal gates 全部通过。多数决对若干中间角度留下 review warnings，原始 verdict、合并结果和答案校验均保存在 `run/qa/blind-verdicts/`，未被隐藏或改写。带标签的完整方向复核确认 16 格顺时针语义、Lucy 身份、基线和 lightsaber 连接可接受。

## 与原版并存

重做版使用独立 id `lucyblade`。原版 v1 使用 `lunablade`，保存在 `../lunablade/`，两者都在 catalog 中并且都有独立 package；安装一版不会覆盖另一版。

## 重建安装包

从仓库根目录运行：

```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File scripts/package-pet.ps1 -PetId lucyblade
```

脚本根据 `build.json` 把 `run/final/spritesheet.webp` 复制到 `package/`，并生成包含 `spriteVersionNumber: 2` 的 `pet.json`。
