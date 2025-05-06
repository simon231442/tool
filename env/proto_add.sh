#!/bin/bash

# Check if a file is provided as an argument
if [ "$#" -ne 1 ]; then
    echo "Usage: $0 <filename>"
    exit 1
fi

FILE=$1

# Check if the file exists
if [ ! -f "$FILE" ]; then
    echo "Error: File '$FILE' not found."
    exit 1
fi

# Create a temporary file for prototypes
tmpfile=$(mktemp)

# Find function declarations using awk
awk '
BEGIN { in_comment = 0; in_function = 0; prototype_count = 0; }

# Skip multi-line comments
/\/\*/ { if (!in_comment) in_comment = 1; }
/\*\// { if (in_comment) in_comment = 0; next; }
{ if (in_comment) next; }

# Match function definitions - handles both static and non-static
/^[a-zA-Z_][a-zA-Z0-9_\*\t ]+[a-zA-Z0-9_\*]+\([^;]*$/ {
    if ($0 ~ /\{/) {
        # Function definition on a single line with opening brace
        gsub(/\{.*$/, "", $0);
        print $0 ";";
        prototype_count++;
    } else {
        # Function definition might span multiple lines
        in_function = 1;
        func_def = $0;
    }
    next;
}

# Continue capturing multi-line function definitions
in_function && !/^\t/ {
    func_def = func_def " " $0;
    if ($0 ~ /\{/) {
        in_function = 0;
        gsub(/\{.*$/, "", func_def);
        print func_def ";";
        prototype_count++;
    }
}

END { 
    if (prototype_count == 0) {
        print "No function prototypes generated." > "/dev/stderr";
        exit 1;
    }
}
' "$FILE" > "$tmpfile"

# Check if any prototypes were found
if [ -s "$tmpfile" ]; then
    # Create another temporary file for the new content
    finalfile=$(mktemp)
    
    # Add header comment for prototypes
    echo "/* Function Prototypes */" > "$finalfile"
    cat "$tmpfile" >> "$finalfile"
    echo "" >> "$finalfile"
    
    # Add original file content
    cat "$FILE" >> "$finalfile"
    
    # Replace the original file
    mv "$finalfile" "$FILE"
    echo "Prototypes added successfully to '$FILE'."
else
    echo "No functions found to generate prototypes."
    rm "$tmpfile"
    exit 1
fi

# Clean up
rm "$tmpfile"