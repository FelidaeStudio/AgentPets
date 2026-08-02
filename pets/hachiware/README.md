# Hachiware

这一版以官方角色页为视觉参考，保留圆润的蓝白身体、大圆黑眼睛、每只眼睛的双高光、粉色腮红、粉色舌头，以及张嘴时露出的两颗可爱小尖牙。

![Hachiware animation contact sheet](run/qa/contact-sheet.png)

这是 Hachiware 的 Codex Pet，使用 8 × 11 的 v2 spritesheet。除了 idle、左右移动、挥手、跳跃、失败、等待、运行中和检查动作，还包含 16 个观察方向。Windows、Linux 和 macOS 都可以使用仓库里的脚本安装。

文件：

- [package/](package/)：安装包
- [run/qa/contact-sheet.png](run/qa/contact-sheet.png)：动作预览
- [BUILD.md](BUILD.md)：制作和检查记录

在仓库根目录安装：

```powershell
pwsh -NoProfile -File scripts/install-pet.ps1 -PetId hachiware
```

Windows PowerShell 5.1：

```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File scripts/install-pet.ps1 -PetId hachiware
```
