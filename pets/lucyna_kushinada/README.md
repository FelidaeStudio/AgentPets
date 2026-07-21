# Lucyna Kushinada

从用户提供的 `lucy-codex-pet.zip` 导入的 Lucyna Kushinada 风格赛博朋克 Codex Pet。

![Lucyna Kushinada animation contact sheet](run/qa/contact-sheet.png)

## 安装

从仓库根目录运行：

```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File scripts/install-pet.ps1 -PetId lucyna_kushinada
```

然后在 Codex 中选择 **Settings > Pets > Refresh > Lucyna Kushinada**，再输入 `/pet`。

## 产物与历史

- `package/`：可直接安装的 `pet.json + spritesheet.webp`。
- `run/source/`：原始 ZIP、其中的原始 `pet.json` 和 PNG atlas。
- `run/final/`：从原始 PNG 确定性规范化出的 PNG/WebP，以及后补验证结果。
- `run/qa/contact-sheet.png`：后补生成的视觉检查表。

这个导入只有最终产物，没有原始 prompts、参考图、row strips、frames 或生成 manifest。仓库没有伪造这些缺失历史；详情见 [BUILD.md](BUILD.md)。

公开使用前请阅读仓库根目录的 [FAN-CONTENT-NOTICE.md](../../FAN-CONTENT-NOTICE.md)。
