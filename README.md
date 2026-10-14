# trime-config

同文输入法（[Trime](https://github.com/osfans/trime)）的一份**用户配置**，可直接整套拷进 Trime 用户目录使用。

> **这套配置是按「左手惯用」来排的**：回车（发送）放在左下角，拇指不用跨到右边；
> 空格键缩短，左右各放一个常用标点；等等。详见下面的「左手布局」。

## 交给 Agent 装（配置 + 带语音的 App）

配套的 App 是 [trime](https://github.com/FGG100y/trime) 的 `feature/on-device-voice-input`
分支（带**完全在本机跑**的语音输入，不需要联网权限）。整套东西都可以用一段话交给编码
Agent（Claude Code / Codex / pi 等）代劳：它会自己 clone、构建、`adb install`、推配置，
再把**只有人能在手机上做**的几步列成清单交给你。

把下面整段复制给 Agent（在哪个目录下运行都行）：

```text
帮我在手机上装好「同文输入法（左手九宫格）」和它的本机语音输入：

1. clone 两个仓库：
   - 配置：trime-config（仓库地址：https://github.com/FGG100y/trime-config）
   - App：https://github.com/FGG100y/trime ，用 feature/on-device-voice-input 分支
2. App 侧先跑 script/fetch-sherpa-onnx.sh，再用 BUILD_ABI=arm64-v8a 构建 debug 包
   （别编 armeabi-v7a，当前会挂）
3. adb install -r 装 debug 包；然后 PKG=com.osfans.trime.debug script/push.sh，把 rime/
   推到 /sdcard/Android/data/com.osfans.trime.debug/files/rime/
4. 最后把「只有我能在手机上做」的步骤列成清单给我，我自己做

约束：adb 只许操作这一个 App（安装 / 启动 / 看日志 / 截图），不要替我点别的 App、
不要动系统设置、不要在设备上模拟操作；需要真机验证的地方写清单给我。
```

### Agent 能自己做完的

- clone 两个仓库，切到 `feature/on-device-voice-input`。
- `script/fetch-sherpa-onnx.sh` 拉原生库 → `BUILD_ABI=arm64-v8a ./gradlew :app:assembleDebug`。
- `adb install -r` 装 debug 包（`com.osfans.trime.debug`）。
- `PKG=com.osfans.trime.debug script/push.sh`：把 `rime/` 推到设备用户目录。
- 想省事的话，也可以让它把语音模型解压到 `/sdcard/Download/`，省得你自己传大文件。

### 只能你自己做的（Agent 应该把这份清单交给你）

| 步骤 | 在哪里 |
| --- | --- |
| 启用并切到「同文输入法（debug）」 | 系统设置 → 语言和输入法（输入法只能由用户手动启用） |
| 部署一次，生成 `t9.prism.bin` 等 | Trime 主界面 →「**部署**」 |
| 导入语音模型（在系统文件选择器里选模型**文件夹**） | Trime 设置 → Local voice input → Import model |
| 首次长按空格时授权录音 | 弹出来的授权框 |
| 把 `Long press space` 设为 `Local voice input` | Trime 设置 → Local voice input（或 General 页的「长按空格」） |
| 填自己的自定义短语 | 见下面「自定义短语（打码即出）」 |

语音模型推荐 **SenseVoiceSmall**（~230 MB，中文好、自带标点）：
[`sherpa-onnx-sense-voice-zh-en-ja-ko-yue-int8-2024-07-17`](https://github.com/k2-fsa/sherpa-onnx/releases/download/asr-models/sherpa-onnx-sense-voice-zh-en-ja-ko-yue-int8-2024-07-17.tar.bz2)。
支持的其它型号、体积、以及「哪几个 release 其实是方言微调、根本不带标点」这些坑，见 App
仓库的 [`doc/voice-input.md`](https://github.com/FGG100y/trime/blob/feature/on-device-voice-input/doc/voice-input.md)。

### 只想用配置，不想自己编译 App

从 [trime releases](https://github.com/osfans/trime/releases)（或 F-Droid / Play）装官方版，
再照下面「部署 / 恢复」手动放配置就行 —— 但**语音输入只有这个分支有**，官方版里只有
「系统语音输入法」。

## 方案列表

| 方案 | id | 说明 |
| --- | --- | --- |
| 朙月拼音 | `luna_pinyin` | 内置全拼，繁体输出 |
| 朙月拼音·简化字 | `luna_pinyin_simp` | 内置全拼，简体输出 |
| 朙月·九宫格 | `t9` | 自定义，复用朙月词库，`speller` 加 2–9 数字映射 |
| Easy English Nano | `melt_eng` | 英文方案，同时作为朙月的次翻译器做中英混输 |

## 左手布局

**九宫格 `t9`**（4 列）

```
[，]   [ABC]  [DEF]  [符号]
[GHI]  [JKL]  [MNO]  [@]
[PQRS] [TUV]  [WXYZ] [⌫]
[↵]    [空格]        [菜单]
```

- `↵` 在左下角（左手拇指）。
- 空格缩短，左上角的 `，` 是标点键、右上角是 `符号`。
- `，` 键：单击 `，`、**上滑 `。`**、**下滑 `1`**、长按 `'`（分词，少用）；
  键顶小字 `。`、右下角 `1`。
- `@` 键（原分词位）：单击 `@`、上滑 `_`（下划线）、下滑 `：`（冒号）；
  键顶小字 `_`、右下角 `：`。下划线用 `commit` 直接上屏，因为 Rime 会把 `_` 转成 `——`。
- `⌫` 键：单击退格、**上滑全选**（键顶小字 `全选`）。
- 拼音键**下滑出字面数字**：`ABC`…`WXYZ` 下滑得 `2`…`9`、`空格` 下滑 `0`。
  数字由 `commit` 直接上屏（绕过 Rime 拼音），不用切键盘就能顺手打个数字。
  统一用下滑而不是上滑，因为空格键上方是语音麦克风图标。
- 每个数字键的**右下角**会有对应数字小字（靠 `hint` + `key_hint_offset_x` 定位，
  空格键更宽所以单独给了偏移量）；偏移值是按当前机器竖屏调的，换屏幕宽度/横屏会偏一些。
- `符号` 键：单击符号表、长按直达「**数字+**」键盘（要连续输入很多数字时用）、
  **下滑 `、`**（顿号，键右下角有提示）。
- 右下角 `菜单` 键：单击弹方案菜单、上滑 `？`、下滑 `！`（键顶小字 `？`、右下角 `！`）。
- **中英切换靠常驻栏的 `中/En` 按钮**：它翻 Rime 的 `ascii_mode`，App 会按键盘声明的
  `ascii_keyboard` 自动在 `t9` / `t9_en` 之间换布局，所以键盘上不再需要单独的 `中/英` 键。
- 输入中文时，候选上方显示的是解析出的**拼音**（如 `bie'ji`），而不是按下的数字
  （靠 `translator/spelling_hints` + `lua/t9_preedit.lua`，见下）。

**西文全键盘 `t9_en`**（由常驻栏的「中/En」进入）

```
q w e r t y u i o p
 a s d f g h j k l
  ⇧ z x c v b n m ⌫
[↵] [,] [空格] [.] [中/英]
```

- `↵` 在左下角；空格左右是 `,` 和 `.`。
- `⇧`：点按 = 临时大写（下一个字母），**长按 = 锁定大写**（Caps Lock，再点一下解除）。
- `中/英` 在右下角：点按回九宫格，长按弹方案菜单。

**朙月/简化字全键盘**（「标准」主题自带的 `default`）回车本来就在左下角，未改动。

## 目录

```
.
├── README.md
├── .gitignore
├── rime/                       # 要放到 Trime 用户目录的内容
│   ├── default.custom.yaml             # schema_list：加入 melt_eng 与 t9
│   ├── luna_pinyin.custom.yaml         # 把 melt_eng 挂成朙月的次翻译器（中英混输）
│   ├── t9.schema.yaml                  # 朙月·九宫格方案（复用朙月词库）
│   ├── lua/
│   │   └── t9_preedit.lua              # 九宫格：候选上方显示拼音而非数字
│   ├── custom_phrase.example.txt       # 自定义短语模板（复制成 custom_phrase.txt 填内容；后者已 gitignore）
│   ├── trime.custom.yaml               # 「預設」主题补丁：t9 / t9_en 键盘
│   ├── tongwenfeng.trime.custom.yaml   # 「标准」主题补丁：同上
│   ├── melt_eng.schema.yaml            # 英文方案
│   ├── melt_eng.dict.yaml              # 英文方案词库入口
│   └── en_dicts/
│       ├── en.dict.yaml                # 英文主词库
│       └── en_ext.dict.yaml            # 英文补充词库
└── script/
    ├── files.txt               # 同步的文件清单（pull/push 共用）
    ├── pull.sh                 # 从设备拉取手写配置到 ./rime
    ├── push.sh                 # 把 ./rime 推回设备
    └── backup-collection.sh    # 备份 App 私有数据（收藏夹/剪贴板）到 ./backup（不进 git）
```

## 部署 / 恢复

1. 把 `rime/` 下的文件按原目录结构放进 Trime 的**用户目录**：
   - debug 版：`/sdcard/Android/data/com.osfans.trime.debug/files/rime/`
   - release 版：设置 →「数据存储模式 / 用户文件夹」里显示的那个目录
2. 打开 Trime 主界面 → 点顶栏的「**部署**」，等待完成（首次会编译 `t9.prism.bin` 和 `melt_eng` 词库）。

## 同步脚本

```bash
script/pull.sh   # 设备 -> ./rime（只拉清单里的手写文件）
script/push.sh   # ./rime -> 设备，然后在 Trime 里点「部署」
```

可用环境变量覆盖默认值：

```bash
PKG=com.osfans.trime ./script/pull.sh
DEV=/path/to/rime  ./script/push.sh
```

## 自定义短语（打码即出）

`rime/custom_phrase.example.txt` 是模板，用法：

1. 复制成 `rime/custom_phrase.txt`（已在 `.gitignore`，不会进仓库），去掉示例行的
   `#` 并填入自己的内容。字段是 `词语<Tab>编码[<Tab>权重]`，分隔符必须是真正的 Tab。
2. `script/push.sh` → 在 Trime 里点「部署」。
3. 在「朙月拼音 / 简化字」**全键盘**下打编码即出；九宫格发的是数字，字母编码在
   九宫格里打不出来。

## App 私有数据备份（收藏夹 / 剪贴板）

收藏夹和剪贴板历史**不在** Rime 用户目录里，而在 App 私有存储的 SQLite：
`/data/data/<pkg>/databases/collection.db`、`clipboard.db`（WAL 模式，带
`-wal`/`-shm`）。它们不进 Rime 的「同步用户数据」，也不进本仓库的 `rime/`。

```bash
script/backup-collection.sh     # 快照到 ./backup/（已 gitignore）
```

- 只对 **debug 版**有效（靠 `run-as`）；release 版只能依赖系统自动备份
  （manifest 里 `allowBackup="true"`）。
- 快照把 `db` + `-wal` + `-shm` 三件套一起拷，否则会漏掉最近写入。
- **含个人信息，别提交、别 push。**

## 不在这里的东西（刻意不备份 / 不进 git）

- `build/`：部署生成的 `*.prism.bin`、`*.table.bin`、`*.reverse.bin` 等，可随时重建。
- `*.userdb/`：学到的词（二进制），交给 Rime 自带的「同步用户数据」处理。
- `user.yaml` / `installation.yaml`：上次使用的方案、设备 id 等运行状态。
- `opencc/`、`soundeffect/` 等从 APK 资产同步来的目录（`en_dicts/` 是例外，已在上面）。
- `rime/custom_phrase.txt` 与 `backup/`：个人内容，已在 `.gitignore`。

## 来源与授权

- 英文方案 `melt_eng`、`en_dicts/*` 来自 [tumuyan/rime-melt](https://github.com/tumuyan/rime-melt)
  与 [iDvel/rime-ice](https://github.com/iDvel/rime-ice)，请遵循其原始许可。
- 九宫格方案参考 [iDvel/rime-ice](https://github.com/iDvel/rime-ice) 的 `t9.schema.yaml`，
  改为复用朙月词库，不依赖 rime-ice。

## 注意

- `t9` 方案复用朙月的词典，只额外编译一份 `t9.prism.bin`，所以仓库很小、无需附带大词库。
- 键盘/主题的补丁靠 librime 的 auto-patch 生效；`*.custom.yaml` 里带 `/` 的路径补丁
  需要 Trime 部署（走"回落到部署产物"的路径），改完务必重新部署。
- 配套 App 需包含 `KeyboardWindow` 里「切方案时清空 `lastLockKeyboardId`」的修复，
  否则从 `t9` 切回其它方案后，下次开始输入可能被旧的锁定键盘劫持。
- 配套 App 还需支持 `ascii_keyboard`：`ascii_mode` 变化时按当前键盘声明的
  `ascii_keyboard` 自动换布局（`KeyboardWindow`）。没有这个的话，常驻栏 `中/En`
  会把九宫格变成 2–9 的“假数字键盘”而不是切到 `t9_en`。
