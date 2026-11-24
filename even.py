file_name = input("Name of input file:")
with open(file_name) as file:
    code = file.read()

line = code.split("\n")
vliw_code = ""
last_even_line = ""
for i in range(len(lines)):
    if i % 2 == 0:
        if i == len(lines) - 1:
            vliw_code += f"{lines[i]}00000000"
        else:
            even_line = lines[i]
    else:
        vliw_code += f"{even_line}{lines[i]}\n"

with open("vliw_hexcode.txt", "w") as file:
    file.write(vliw_code)
