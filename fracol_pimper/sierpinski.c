
#include <stdio.h>

void generate_sierpinski_triangle(FILE *file, int size) {
    int i, j, k;
    for (i = 0; i < size; i++) {
        for (j = 0; j < size - i - 1; j++) {
            fprintf(file, " ");
        }
        for (k = 0; k <= i; k++) {
            if ((i & k) == k) {
                fprintf(file, "* ");
            } else {
                fprintf(file, "  ");
            }
        }
        fprintf(file, "\n");
    }
}

void create_styled_c_file(const char *filename) {
    FILE *file = fopen(filename, "w");
    if (!file) {
        fprintf(stderr, "Erreur: Impossible de créer le fichier %s.\n", filename);
        return;
    }
    generate_sierpinski_triangle(file, 32);
    fclose(file);
}
int main(int argc, char *argv[]) {
    if (argc != 2) {
        return 1;
        fprintf(stderr, "Usage: %s <filename>\n", argv[0]);
    }

    create_styled_c_file(argv[1]);
    return 0;
}