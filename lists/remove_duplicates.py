def remove_duplicates_from_file(file_path):
    # Read the input file and collect unique lines
    unique_lines = set()
    with open(file_path, 'r') as file:
        for line in file:
            unique_lines.add(line.strip())

    # Write the unique lines back to the input file
    with open(file_path, 'w') as file:
        for line in unique_lines:
            file.write(line + '\n')

if __name__ == "__main__":
    input_file = "input.txt"    # Replace with the path to your input file

    remove_duplicates_from_file('provisioned_packages.lst')
