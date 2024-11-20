#!/bin/bash

# Usage information
usage() {
    echo "Usage: $0 <dir1> <dir2>"
    echo "Compare two directories recursively and show differences"
    exit 1
}

# Check if we have two arguments
if [ $# -ne 2 ]; then
    usage
fi

DIR1="$1"
DIR2="$2"

# Check if both directories exist
if [ ! -d "$DIR1" ]; then
    echo "Error: Directory '$DIR1' does not exist"
    exit 1
fi

if [ ! -d "$DIR2" ]; then
    echo "Error: Directory '$DIR2' does not exist"
    exit 1
fi

# Convert to absolute paths
DIR1=$(cd "$DIR1" && pwd)
DIR2=$(cd "$DIR2" && pwd)

echo "Comparing directories:"
echo "< $DIR1"
echo "> $DIR2"
echo

# Find files unique to DIR1 (marked in red with -)
echo "Files only in $DIR1:"
diff --brief -r "$DIR1" "$DIR2" | grep "Only in $DIR1" |
    sed "s|Only in $DIR1\(.*\): \(.*\)|\1/\2|" |
    while read -r file; do
        echo -e "\033[31m- ${file#/}\033[0m"
    done

# Find files unique to DIR2 (marked in green with +)
echo -e "\nFiles only in $DIR2:"
diff --brief -r "$DIR1" "$DIR2" | grep "Only in $DIR2" |
    sed "s|Only in $DIR2\(.*\): \(.*\)|\1/\2|" |
    while read -r file; do
        echo -e "\033[32m+ ${file#/}\033[0m"
    done

# Find and show diffs for modified files
echo -e "\nModified files:"
diff --brief -r "$DIR1" "$DIR2" | grep "differ$" |
    while read -r line; do
        file1=$(echo "$line" | cut -d ' ' -f 2)
        file2=$(echo "$line" | cut -d ' ' -f 4)
        rel_path=${file1#$DIR1/}
        echo -e "\n\033[36mFile: $rel_path\033[0m"
        # Check if files are text files
        if file "$file1" | grep -q "text"; then
            # Show colored diff output
            diff -u "$file1" "$file2" |
                sed '1,2d' |
                while IFS= read -r diffline; do
                    case $diffline in
                    +*)
                        echo -e "\033[32m$diffline\033[0m"
                        ;;
                    -*)
                        echo -e "\033[31m$diffline\033[0m"
                        ;;
                    *)
                        echo "$diffline"
                        ;;
                    esac
                done
        else
            echo "Binary files differ"
        fi
    done

# Print a summary
echo -e "\nSummary:"
only_in_1=$(diff --brief -r "$DIR1" "$DIR2" | grep "Only in $DIR1" | wc -l)
only_in_2=$(diff --brief -r "$DIR1" "$DIR2" | grep "Only in $DIR2" | wc -l)
modified=$(diff --brief -r "$DIR1" "$DIR2" | grep "differ$" | wc -l)

echo "$only_in_1 files only in $DIR1"
echo "$only_in_2 files only in $DIR2"
echo "$modified files modified"
