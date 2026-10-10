# trime-config

同文输入法（[Trime](https://github.com/osfans/trime)）的**用户配置**备份与版本管理。

> **这套配置是按「左手惯用」来排的**：回车（发送）放在左下角，拇指不用跨到右边；
> 空格键缩短，左右各放一个常用标点；等等。详见下面的「左手布局」。

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
[，]   [ABC]  [DEF]  [符]
[GHI]  [JKL]  [MNO]  [分词]
[PQRS] [TUV]  [WXYZ] [⌫]
[↵]    [空格]        [中/英]
```

- `↵` 在左下角（左手拇指）。
- 空格缩短，`，` / `符` 分列两侧。
- `中/英` 在右下角：点按切西文全键盘，长按弹方案菜单。

**西文全键盘 `t9_en`**（由九宫格的「中/英」进入）

```
q w e r t y u i o p
 a s d f g h j k l
  ⇧ z x c v b n m ⌫
[↵] [,] [空格] [.] [中/英]
```

- `↵` 在左下角；空格左右是 `,` 和 `.`。
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
│   ├── custom_phrase.txt               # 自定义短语
│   ├── trime.custom.yaml               # 「預設」主题补丁：t9 / t9_en 键盘
│   ├── tongwenfeng.trime.custom.yaml   # 「标准」主题补丁：同上
│   ├── melt_eng.schema.yaml            # 英文方案
│   ├── melt_eng.dict.yaml              # 英文方案词库入口
│   └── en_dicts/
│       ├── en.dict.yaml                # 英文主词库
│       └── en_ext.dict.yaml            # 英文补充词库
└── script/
    ├── pull.sh                 # 从设备拉取手写配置到 ./rime
    └── push.sh                 # 把 ./rime 推回设备
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

## 不在这里的东西（刻意不备份 / 不进 git）

- `build/`：部署生成的 `*.prism.bin`、`*.table.bin`、`*.reverse.bin` 等，可随时重建。
- `*.userdb/`：学到的词（二进制），交给 Rime 自带的「同步用户数据」处理。
- `user.yaml` / `installation.yaml`：上次使用的方案、设备 id 等运行状态。
- `opencc/`、`soundeffect/`、`en_dicts/` 之外从 APK 资产同步来的目录。

## 来源与授权

- 英文方案 `melt_eng`、`en_dicts/*` 复制自 [tumuyan/rime-melt](https://github.com/tumuyan/rime-melt)
  与 [iDvel/rime-ice](https://github.com/iDvel/rime-ice)，仅作个人备份使用。
- 九宫格方案参考 [iDvel/rime-ice](https://github.com/iDvel/rime-ice) 的 `t9.schema.yaml`，
  改为复用朙月词库，不依赖 rime-ice。

## 注意

- `t9` 方案复用朙月的词典，只额外编译一份 `t9.prism.bin`，所以仓库很小、无需附带大词库。
- 键盘/主题的补丁靠 librime 的 auto-patch 生效；`*.custom.yaml` 里带 `/` 的路径补丁
  需要 Trime 部署（走"回落到部署产物"的路径），改完务必重新部署。
- 配套 App 需包含 `KeyboardWindow` 里「切方案时清空 `lastLockKeyboardId`」的修复，
  否则从 `t9` 切回其它方案后，下次开始输入可能被旧的锁定键盘劫持。
