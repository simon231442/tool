#include <stdio.h>
#include <stdlib.h>
#include <time.h>

void create_styled_c_file(const char *filename) {
    FILE *file = fopen(filename, "w");
    if (!file) {
        fprintf(stderr, "Erreur: Impossible de créer le fichier %s.\n", filename);
        return;
    }

    time_t now = time(NULL);
    struct tm *t = localtime(&now);

    fprintf(file, "/* ************************************************************************** */\n");
    fprintf(file, "/*                                                                            */\n");
    fprintf(file, "/*                                                           *                */\n");
    fprintf(file, "/*                                                          * *               */\n");
    fprintf(file, "/*                                                         *   *              */\n");
    fprintf(file, "/*                                                        * * * *             */\n");
    fprintf(file, "/*                                                       *       *            */\n");
    fprintf(file, "/*                                                      * *     * *           */\n");
    fprintf(file, "/*                                                     *   *   *   *          */\n");
    fprintf(file, "/*                                                    * * * * * * * *         */\n");
    fprintf(file, "/*                                                   *               *        */\n");
    fprintf(file, "/*                                                  * *             * *       */\n");
    fprintf(file, "/*   %-45s *   *           *   *      */\n", filename);
    fprintf(file, "/*                                                * * * *         * * * *     */\n");
    fprintf(file, "/*   By: srenaud <srenaud@student.42lausanne.ch> *       *       *       *    */\n");
    fprintf(file, "/*                                              * *     * *     * *     * *   */\n");
    fprintf(file, "/*   Created: %04d/%02d/%02d %02d:%02d:%02d by srenaud   *   *   *   *   *   *   *   *  */\n",
            t->tm_year + 1900, t->tm_mon + 1, t->tm_mday, t->tm_hour, t->tm_min, t->tm_sec);
    fprintf(file, "/*   Updated: %04d/%02d/%02d %02d:%02d:%02d by srenaud  * * * * * * * * * * * * * * * * */\n",
            t->tm_year + 1900, t->tm_mon + 1, t->tm_mday, t->tm_hour, t->tm_min, t->tm_sec);
    fprintf(file, "/*                                                                            */\n");
    fprintf(file, "/* ************************************************************************** */\n");

    fclose(file);
}

int main(int argc, char *argv[]) {
    if (argc != 2) {
        fprintf(stderr, "Usage: %s <filename>\n", argv[0]);
        return 1;
    }

    create_styled_c_file(argv[1]);
    return 0;
}