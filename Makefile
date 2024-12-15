#
#	'file you want to create': '...files you need to create it, the "prerequisites" '
#		> shell command you need to execute
#		> ... another shell command
#		> .... and so on
#		> in order to create the file


# Make Variables ##################################################
.DEFAULT_GOAL	= all


PROJECT_NAME	= ftprintf

LIBRARY_NAME    = lib$(PROJECT_NAME).a

NAME		= $(LIBRARY_NAME)

SRCS_DIR	= ./srcs/
OBJS_DIR	= ./objs/
INCLUDES_DIR	= ./includes/

DIRECTORIES	= $(OBJS_DIR)

SRCS_FILES	= ft_printf pf_letters

#
#		= $('input variable that contains a list':'truc'='new_truc')
#		example
#		> if
#		LIST = xay xby xcy
#		> then
#		$(LIST:x%y=Hello % World)
#		> would resul in:
#		Hello a World
#		Hello b World
#		Hello c World
#
SRCS		= $(SRCS_FILES:%=$(SRCS_DIR)%.c)
OBJS    	= $(SRCS:$(SRCS_DIR)%.c=$(OBJS_DIR)%.o)

# Test variables
TEST_SRC 	= test/main.c
TEST    	= test_program

# C-compilation variables
CC      	= cc
CFLAGS  	= -Wall -Wextra -Werror -I includes

MKDIR		= mkdir -p

# Make Rules ##################################################
# Compilation de la bibliothèque


# '$@' reerence to the file I want to create
$(DIRECTORIES):
	$(MKDIR) $@

.PHONY: all
all: $(NAME)


$(NAME): $(OBJS)
	ar rcs $(NAME) $(OBJS)

# -c: specifies that you are compiling into an objcet, not a binary executable.
#
#  Instead of an executable you create a .o and you do not need a main function
#  to compile like this
#
#-o: specifies the output filename
# '$<'  is the FIRST prerequisite
#
$(OBJS_DIR)%.o: $(SRCS_DIR)%.c $(OBJS_DIR)
	$(CC) $(CFLAGS) -c $< -o $@

# Génération de l'exécutable de test
test: $(TEST)

$(TEST): $(NAME) $(TEST_SRC)
	$(CC) $(CFLAGS) -o $(TEST) $(TEST_SRC) -L. -lftprintf

# Nettoyage
.PHONY: clean
clean:
	$(RM) $(OBJS)

.PHONY: fclean
fclean: clean
	$(RM) $(NAME) $(TEST)

.PHONY: re
re: fclean all
