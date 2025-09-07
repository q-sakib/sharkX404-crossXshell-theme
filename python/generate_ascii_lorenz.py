from PIL import Image

# Open the local PNG image (not an SVG)
img = Image.open("3703.jpg").convert("L")  # Convert to grayscale

# Resize for terminal
new_width = 100
aspect_ratio = img.height / img.width
new_height = int(aspect_ratio * new_width * 0.5)
img = img.resize((new_width, new_height))

# ASCII character mapping
ascii_chars = "@%#*+=-:. "
pixels = list(img.getdata())

# Convert to ASCII
ascii_art = []
for y in range(new_height):
    line = "".join(
        ascii_chars[pixels[y * new_width + x] * (len(ascii_chars) - 1) // 255]
        for x in range(new_width)
    )
    ascii_art.append(line)

# Output as PowerShell array
print('$asciiArt = @(')
for line in ascii_art:
    print(f'    "{line}"')
print(')\n')

# PowerShell rendering loop
print('foreach ($line in $asciiArt) { Write-Host $line -ForegroundColor Green; Start-Sleep -Milliseconds 30 }')
