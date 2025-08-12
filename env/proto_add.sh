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

# Find function declarations using awk - simple version without formatting
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
        func_def = $0;
        gsub(/\{.*$/, "", func_def);
        # Remove trailing spaces before adding semicolon
        gsub(/[ \t]+$/, "", func_def);
        print func_def ";";
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
        gsub(/[ \t]+$/, "", func_def);
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
    # Create temporary files for different sections of the file
    before_include=$(mktemp)
    after_include=$(mktemp)
    finalfile=$(mktemp)
    
    # Find the last #include line's line number
    last_include_line=$(grep -n "#include" "$FILE" | tail -1 | cut -d':' -f1)
    
    if [ -n "$last_include_line" ]; then
        # Split the file at the last #include line
        head -n "$last_include_line" "$FILE" > "$before_include"
        tail -n +$((last_include_line + 1)) "$FILE" > "$after_include"
        
        # Remove leading empty lines from after_include
        sed_after=$(mktemp)
        sed '/./,$!d' "$after_include" > "$sed_after"
        
        # Construct the final file
        cat "$before_include" > "$finalfile"
        echo "" >> "$finalfile"  # Add empty line after includes
        echo "/* Function Prototypes */" >> "$finalfile"
        cat "$tmpfile" >> "$finalfile"
        echo "" >> "$finalfile"  # Add exactly one empty line after prototypes
        cat "$sed_after" >> "$finalfile"
        rm "$sed_after"
    else
        # If no #include is found, add prototypes at the beginning
        echo "/* Function Prototypes */" > "$finalfile"
        cat "$tmpfile" >> "$finalfile"
        echo "" >> "$finalfile" # Add exactly one empty line
        cat "$FILE" >> "$finalfile"
    fi
    
    # Replace the original file
    mv "$finalfile" "$FILE"
    echo "Prototypes added successfully after includes in '$FILE'."
    
    # Clean up temp files
    rm "$before_include" "$after_include"
else
    echo "No functions found to generate prototypes."
    rm "$tmpfile"
    exit 1
fi

# Clean up
rm "$tmpfile"
