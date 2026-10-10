-- 九宫格：把候选的拼音注释搬到 preedit，让输入框显示拼音而不是按键数字。
--
-- 背景：t9 方案在 speller/algebra 里把拼音派生成了数字编码，librime 生成
-- 预编辑（候选上方那一行）时用的是「按键原文」，所以打 "234" 就显示 "234"。
-- 开启 translator/spelling_hints 后，script_translator 会把候选的原始拼音
-- 拼写挂在候选的 comment 上；本 filter 再把它搬进候选的 preedit，而 librime
-- 在候选带 preedit 时会优先用它来渲染预编辑区。
--
-- 只在 comment 非空时替换；不想让候选旁边再显示一遍同样的拼音，就把 comment 清掉。
--（见 t9.schema.yaml：translator/spelling_hints 与 engine/filters）
local function t9_preedit(input, env)
  for cand in input:iter() do
    local c = cand:get_genuine()
    local py = c.comment
    if py and py ~= "" then
      c.preedit = py
      c.comment = ""
    end
    yield(cand)
  end
end

return t9_preedit
