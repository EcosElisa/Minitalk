# **************************************************************************** #
#                                                                              #
#                                                         :::      ::::::::    #
#    makefile                                           :+:      :+:    :+:    #
#                                                     +:+ +:+         +:+      #
#    By: esobrinh <esobrinh@student.42.fr>          +#+  +:+       +#+         #
#                                                 +#+#+#+#+#+   +#+            #
#    Created: 2023/06/05 18:33:25 by esobrinh          #+#    #+#              #
#    Updated: 2023/06/09 16:03:11 by esobrinh         ###   ########.fr        #
#                                                                              #
# **************************************************************************** #

# ======= COLORS ========
BLACK = \033[1;30m
RED = \033[1;31m
GREEN = \033[1;32m
YELLOW = \033[1;33m
BLUE = \033[1;34m
PURPLE = \033[1;35m
CYAN = \033[1;36m
WHITE = \033[1;37m
END_COL = \033[0m

# ==== Name of the program =====
CLIENT_NAME	=	client
SERVER_NAME	=	server
NAME		=	minitalk
SERVER_BONUS = server_bonus
CLIENT_BONUS = client_bonus

# ======= Sources and objs ========
SERVER_SRC	= $(addprefix $(PATH_SRC), server.c)
CLIENT_SRC	= $(addprefix $(PATH_SRC), client.c)
SERVER_OBJ = $(patsubst $(PATH_SRC)%.c, $(PATH_OBJ)%.o, $(SERVER_SRC))
CLIENT_OBJ = $(patsubst $(PATH_SRC)%.c, $(PATH_OBJ)%.o, $(CLIENT_SRC))

SERVER_SRC_B	= $(addprefix $(PATH_SRC_B), server_bonus.c)
CLIENT_SRC_B	= $(addprefix $(PATH_SRC_B), client_bonus.c)
SERVER_OBJ_B = $(patsubst $(PATH_SRC_B)%.c, $(PATH_OBJ_B)%.o, $(SERVER_SRC_B))
CLIENT_OBJ_B = $(patsubst $(PATH_SRC_B)%.c, $(PATH_OBJ_B)%.o, $(CLIENT_SRC_B))

HEADERM		= ./include/minitalk.h
HEADERB		= ./include/minitalk_bonus.h

FLAGS = -Wall -Wextra -Werror -g3

# ====== Folders and Paths ========
LIBFT_DIR = ./libft/
INCLUDE = -I ./include/
LIBFT = $(addprefix $(LIBFT_DIR), libft.a)
PATH_SRC = ./mandatory/source/
PATH_OBJ = ./mandatory/object/
PATH_SRC_B = ./bonus/source/
PATH_OBJ_B = ./bonus/object/

# ======================= Messages =====================================

COMP_LIFT	=	echo "\n🚀 $(YELLOW)Make: $(NO_COLOR)Starting the compilation...\n"
LIBS		=	echo "\n🚀 $(GREEN)Libft$(NO_COLOR)OK!\n"
SERV_READY	=	echo "\n🖥️ $(GREEN)Server ready!\n$(COLOUR_END)"
CLI_READY	=	echo "\n📱 $(GREEN)Client ready!\n$(COLOUR_END)"
SERVB_READY	=	echo "\n🖥️ $(GREEN)Server_bonus ready!\n$(COLOUR_END)"
CLIB_READY	=	echo "\n📱 $(GREEN)Client_bonus ready!\n$(COLOUR_END)"
RECOMP		=	echo "\n🔄 $(YELLOW)Recompilation done.\n$(COLOUR_END)"
RECOMPB		=	echo "\n🔄 $(YELLOW)Recompilation bonus done.\n$(COLOUR_END)"
CLEANED		=	echo "\n🗑️ $(YELLOW)Clean: $(NO_COLOR)Removed all the \".o\" files \n"
FCLEANED	=	echo "\n🧹 $(YELLOW)Fclean: $(NO_COLOR)ﾟ✧Removed the executablesﾟ✧ \n"
ERROR		=	echo "\n🚫 $(RED)Erro: $(NO_COLOR)File/Header not found ¯\_(ツ)_/¯"\n"

# =================== Rules ==========================

all: $(NAME)

$(NAME): comp_libft $(SERVER_NAME) $(CLIENT_NAME)

comp_libft:
	@$(COMP_LIFT)
	@make -C $(LIBFT_DIR) --no-print-directory

$(SERVER_NAME): $(SERVER_OBJ)
	@cc $(FLAGS) $^ $(LIBFT) $(INCLUDE) -o $@
	@$(SERV_READY)

$(CLIENT_NAME): $(CLIENT_OBJ)
	@cc $(FLAGS) $^ $(LIBFT) $(INCLUDE) -o $@
	@$(CLI_READY)

bonus: comp_libft $(SERVER_BONUS) $(CLIENT_BONUS)

$(SERVER_BONUS): $(SERVER_OBJ_B)
	@cc $(FLAGS) $^ $(LIBFT) $(INCLUDE) -o $@
	@$(SERV_READY)

$(CLIENT_BONUS): $(CLIENT_OBJ_B)
	@cc $(FLAGS) $^ $(LIBFT) $(INCLUDE) -o $@
	@$(CLI_READY)

re: fclean all
	@$(RECOMP)

rebonus: fclean all
	@$(RECOMPB);

clean:
	@rm -rf $(CLIENT_OBJ) $(SERVER_OBJ) $(PATH_OBJ) $(CLIENT_OBJ_B) $(SERVER_OBJ_B) $(PATH_OBJ_B)
	@make -C $(LIBFT_DIR) clean
	@$(CLEANED)

fclean: clean
	@rm -rf $(SERVER_NAME) $(CLIENT_NAME) $(SERVER_BONUS) $(CLIENT_BONUS)
	@make -C $(LIBFT_DIR) fclean
	@$(FCLEANED)

# Compiling Mandatory or Bonus Objs
$(PATH_OBJ)%.o: $(PATH_SRC)%.c $(HEADERM)
	mkdir -p $(PATH_OBJ)
	$(CC) $(FLAGS) $(INCLUDE) -c $< -o $@ -I$(LIBFT_DIR)

$(PATH_OBJ_B)%.o: $(PATH_SRC_B)%.c $(HEADERB)
	mkdir -p $(PATH_OBJ_B)
	$(CC) $(FLAGS) $(INCLUDE) -c $< -o $@ -I$(LIBFT_DIR)

re:	fclean all

.PHONY: all clean fclean re comp_libft bonus