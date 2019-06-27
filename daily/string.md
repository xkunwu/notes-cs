---
---
sed: stream editor; awk: table fields editor.
string/parameter substitution: "inconsistent command syntax and overlap of functionality, not to mention confusion."
-   awk: start index at 1.

#### Bash string/parameter substitution
```
${string/pattern/replacement}
# shortest from beginning
${string/#pattern/replacement}
# shortest from end
${string/%pattern/replacement}
```