#!/bin/bash

# Function 1: Backup a directory
backup_directory() {
    if [ -z "$source_dir" ] || [ -z "$backup_dir" ]; then
        echo "Usage: backup_directory <source_directory> <backup_directory>"
        return
    fi

    if [ ! -d "$source_dir" ]; then
        echo "Error: Source directory does not exist."
        return
    fi

    if [ ! -d "$backup_dir" ]; then
        echo "Error: Backup directory does not exist, creating it."
        mkdir -p "$backup_dir"
    fi

    echo "Backing up directory: $source_dir to $backup_dir"
    rsync -a --progress "$source_dir/" "$backup_dir"
    echo "Backup completed."
}

# Function 2: Unzip a file
unzip_file() {
    if [ -z "$zip_file" ] || [ ! -f "$zip_file" ]; then
        echo "Usage: unzip_file <zip_file>"
        return
    fi

    echo "Unzipping file: $zip_file"
    unzip "$zip_file"
    echo "Unzip completed."
}

# Function 3: Encrypt and decrypt a file
encrypt_decrypt_file() {
    local algorithm="aes-256-cbc"
    local password="your_secret_password"

    if [ -z "$file_path" ] || [ ! -f "$file_path" ]; then
        echo "Usage: encrypt_decrypt_file <file_path>"
        return
    fi

    local encrypted_file="$file_path.enc"
    local decrypted_file="$file_path.dec"

    if [ "$1" == "encrypt" ]; then
        echo "Encrypting file: $file_path"
        openssl enc -$algorithm -salt -in "$file_path" -out "$encrypted_file" -k "$password"
        echo "Encryption completed."
    elif [ "$1" == "decrypt" ]; then
        echo "Decrypting file: $encrypted_file"
        openssl enc -$algorithm -d -in "$encrypted_file" -out "$decrypted_file" -k "$password"
        echo "Decryption completed."
    else
        echo "Invalid operation. Use 'encrypt' or 'decrypt' as the first argument."
    fi
}

# Function 4: Count the number of occurrences of a specific word in a file
count_word_occurrences() {
    if [ -z "$file_path" ] || [ ! -f "$file_path" ]; then
        echo "Usage: count_word_occurrences <file_path>"
        return
    fi

    if [ -z "$search_word" ]; then
        echo "Usage: count_word_occurrences <file_path> <search_word>"
        return
    fi

    echo "Counting occurrences of '$search_word' in file: $file_path"
    occurrences=$(grep -o -w "$search_word" "$file_path" | wc -l)
    echo "Number of occurrences: $occurrences"
}

# Main script
echo "Choose an option:"
echo "1. Backup a directory"
echo "2. Unzip a file"
echo "3. Encrypt and decrypt a file"
echo "4. Count the number of occurrences of a specific word in a file"
read option

case "$option" in
1)
    read -p "Enter source directory: " source_dir
    read -p "Enter backup directory: " backup_dir
    backup_directory
    ;;
2)
    read -p "Enter zip file: " zip_file
    unzip_file
    ;;
3)
    read -p "Enter file path: " file_path
    read -p "Enter operation (encrypt|decrypt): " operation
    encrypt_decrypt_file "$operation"
    ;;
4)
    read -p "Enter file path: " file_path
    read -p "Enter search word: " search_word
    count_word_occurrences
    ;;
*)
    echo "Invalid option."
    ;;
esac