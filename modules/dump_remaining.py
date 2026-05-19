import re

dict_path = r"e:\Turtle Wow\Interface\AddOns\pfUI\modules\translator_dict.lua"

with open(dict_path, "r", encoding="utf-8") as f:
    lines = f.readlines()

remaining = []
for line in lines:
    match = re.search(r'^\s*add\(\s*"([^"]+)"\s*,\s*"([^"]+)"\s*\)', line)
    if match:
        remaining.append((match.group(1), match.group(2)))

print(f"Total binarias restantes: {len(remaining)}")
with open("remaining_binaries.txt", "w", encoding="utf-8") as out:
    for es, en in remaining:
        out.write(f'"{es}" -> "{en}"\n')
