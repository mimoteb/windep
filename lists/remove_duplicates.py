import os

def remove_duplicate_lines_case_insensitive_and_update(input_file):
    seen_lines = set()
    total_lines = 0
    duplicates_removed = 0

    with open(input_file, 'r') as file:
        lines = file.readlines()

    with open(input_file, 'w') as file:
        for line in lines:
            line_lower = line.strip().lower()
            if line_lower not in seen_lines:
                seen_lines.add(line_lower)
                file.write(line)
            else:
                duplicates_removed += 1
            total_lines += 1

    return total_lines, duplicates_removed

def remove_trailing_whitespace_inplace(file_path):
    with open(file_path, 'r+') as file:
        lines = file.readlines()
        file.seek(0)
        file.truncate(0)  # Clear the file's contents

        for line in lines:
            stripped_line = line.strip()  # Remove trailing whitespace
            file.write(stripped_line + '\n')

def process_files_in_script_directory():
    script_directory = os.path.dirname(os.path.abspath(__file__))

    for filename in os.listdir(script_directory):
        if filename.endswith('.lst'):
            input_file = os.path.join(script_directory, filename)

            # Process each file
            remove_trailing_whitespace_inplace(input_file)
            print("Trailing whitespace removed from", input_file)

            total_lines, duplicates_removed = remove_duplicate_lines_case_insensitive_and_update(input_file)
            print("Total lines in the file:", total_lines)
            print("Duplicate lines removed:", duplicates_removed)
            print("Case-insensitive duplicate lines removed and saved to", input_file)
            print("="*30)

if __name__ == '__main__':
    process_files_in_script_directory()
