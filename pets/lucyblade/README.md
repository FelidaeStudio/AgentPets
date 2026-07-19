# Lucyblade

一个明显以 Lucy 为视觉灵感的像素 chibi 赛博朋克 netrunner：银白淡紫短发、紫色眼睛、黑白红赛博服装，并始终手持一把鲜明的蓝色 lightsaber。

![Lucyblade animation contact sheet](run/qa/final-contact-sheet.png)

## 使用

可安装内容位于 [`package/`](package/)：

```text
package/
├── pet.json
└── spritesheet.webp
```

从仓库根目录运行：

```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File scripts/install-pet.ps1 -PetId lucyblade
```

然后在 Codex 中选择 **Settings > Pets > Refresh > Lucyblade**，再输入 `/pet`。

## 构建记录

当前完整构建资产保存在 [`run/`](run/)：

- `pet_request.json` 与 `imagegen-jobs.json`：完整请求和每个视觉任务的选择记录。
- `prompts/`：主造型、九条标准动画、方向锚点、方向行与重试 prompt。
- `references/`：Lucy 风格参考、canonical base、布局 guide 与方向生成 guide。
- `decoded/`：所有已选生成 strip、方向锚点和注册结果。
- `qa/`：逐行拆帧检查、GIF、contact sheet、连续性测量、三份隔离盲测及最终验证。
- `generated/rejected/`：被方向语义、闭环连续性或边缘安全门禁拒绝的完整候选。
- `final/`：当前安装包使用的 v2 PNG/WebP atlas 和严格验证结果。

原版 Lunablade 作为独立的 [`../lunablade/`](../lunablade/) v1 Pet 保留并继续可安装。参考图来源和重做过程见 [BUILD.md](BUILD.md)，机器可读元数据见 [build.json](build.json)。

公开使用前请阅读仓库根目录的 [FAN-CONTENT-NOTICE.md](../../FAN-CONTENT-NOTICE.md)。
