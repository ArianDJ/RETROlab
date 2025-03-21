import re

nextScenes = set()
scenes = set()

with open('script.js', 'r', encoding='utf-8') as f:
    content = f.read()

    for match in re.finditer(r'nextScene:\s*\"([^\"]+)\"', content):
        nextScenes.add(match.group(1))

    for match in re.finditer(r'^\s*(\w+):\s*{', content, re.MULTILINE):
        scenes.add(match.group(1))

missing = [scene for scene in nextScenes if scene not in scenes and scene != 'intro']

print('Missing scenes:', len(missing))
print(missing) if missing else print('All scenes are implemented!')
