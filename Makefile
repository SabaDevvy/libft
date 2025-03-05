# **************************************************************************** #
#                                                                              #
#                                                         :::      ::::::::    #
#    Makefile                                           :+:      :+:    :+:    #
#                                                     +:+ +:+         +:+      #
#    By: gsabatin <gsabatin@student.42.fr>          +#+  +:+       +#+         #
#                                                 +#+#+#+#+#+   +#+            #
#    Created: 2024/12/09 19:27:37 by gsabatin          #+#    #+#              #
#    Updated: 2025/03/06 03:30:34 by gsabatin         ###   ########.fr        #
#                                                                              #
# **************************************************************************** #

# Colors
RESET				= \033[0m
BOLD				= \033[1m
RED					= \033[0;31m
GREEN				= \033[0;32m
YELLOW				= \033[0;33m
BLUE				= \033[0;34m
MAGENTA				= \033[0;35m
CYAN				= \033[0;36m
WHITE				= \033[0;37m

BRIGHT_RED			= \033[0;91m
BRIGHT_GREEN		= \033[0;92m
BRIGHT_YELLOW		= \033[0;93m
BRIGHT_BLUE			= \033[0;94m
BRIGHT_CYAN			= \033[0;96m

# Make settings
JOBS				:= $(shell nproc 2>/dev/null || echo 2)

ifeq ($(filter --jobserver-fds=% -j%,$(MAKEFLAGS)),)
  ifeq ($(MAKELEVEL), 0)
    MAKEFLAGS += -j$(JOBS)
  endif
endif

ifndef VERBOSE
	MAKEFLAGS += -s
endif

ifdef DEBUG
$(info Debug mode enabled)
CFLAGS				+= -g -DDEBUG
endif

# Project
PROJECT				= libft
NAME				= $(addsuffix .a, $(PROJECT))
NAME_TEST			= $(addsuffix _test.exe, $(PROJECT))
NAME_DEBUG			= $(addsuffix _debug.exe, $(PROJECT))
NAME_DEBUG_LOGS		= $(addsuffix .dSYM, $(NAME_DEBUG))

# Compile settings
CC					= cc
CFLAGS				= -Wall -Wextra -Werror -Iincludes
DEBUG_FLAGS			= -gdwarf-4 -DDEBUG -fno-omit-frame-pointer
SANITIZE_COMPILE	= -fsanitize=address -fsanitize=undefined
SANITIZE_LINK		= -fsanitize=address -fsanitize=undefined
AR					= ar rcs
RM					= rm -rf

# Directories
SRCS_DIR			:= src/
OBJS_DIR 			:= objs/
OBJS_DEBUG_DIR		:= objs/debug/

# Compile info
SRCS				:= $(shell find src -type f -name "*.c")
OBJS				:= $(SRCS:$(SRCS_DIR)%.c=$(OBJS_DIR)%.o)
OBJS_DEBUG			:= $(SRCS:$(SRCS_DIR)%.c=$(OBJS_DEBUG_DIR)%.o)

DEPS				:= includes/libft.h

all: validate_environment
	$(MAKE) $(NAME)

$(NAME): $(OBJS)
	@echo "$(YELLOW)[COMPILE]	Compiling archive [$(NAME)]...$(RESET)"
	$(AR) $(NAME) $(OBJS)
	@echo "$(BRIGHT_GREEN)[SUCCESS]	Archive [$(NAME)] successfully compiled!$(RESET)"

test: validate_environment $(NAME_TEST)
	@echo "$(BLUE)[INFO]		Running [$(NAME_TEST)]...$(RESET)"
	./$(NAME_TEST)

$(NAME_TEST): $(OBJS) $(NAME)
	@echo "$(YELLOW)[COMPILE]	Compiling exe [$(NAME_TEST)]...$(RESET)"
	$(CC) $(CFLAGS) $(NAME) test.c -o $(NAME_TEST)
	@echo "$(BRIGHT_GREEN)[SUCCESS]	Exe [$(NAME_TEST)] successfully compiled!$(RESET)"

$(OBJS_DIR)%.o: $(SRCS_DIR)%.c $(DEPS)
	# @echo "$(YELLOW)[COMPILE]\tCompiling: $<...$(RESET)"
	$(CC) $(CFLAGS) -c $< -o $@

clean:
	@echo "$(RED)[CLEAN]		Cleaning [$(NAME)] object files...$(RESET)"
	$(RM) $(OBJS_DIR)

fclean: clean
	@echo "$(BRIGHT_RED)[CLEAN]		Full cleaning: Removing [$(NAME)]...$(RESET)"
	$(RM) $(NAME) $(NAME_TEST) $(NAME_DEBUG)

re:
	$(MAKE) fclean
	$(MAKE) all

validate_environment:
	@echo "$(BLUE)[INFO]		Creating/checking [$(NAME)] directories...$(RESET)"
	mkdir -p $(OBJS_DIR) $(sort $(dir $(OBJS)))

validate_debug_env:
	@echo "$(BLUE)[DEBUG]		Setting up debug environment...$(RESET)"
	@mkdir -p $(OBJS_DEBUG_DIR) $(sort $(dir $(OBJS_DEBUG)))

# Debug
ASAN_CHECK := $(shell $(CC) -fsanitize=address -x c -c /dev/null -o /dev/null 2>/dev/null && echo "supported" || echo "not supported")
debug: validate_debug_env
	@echo "$(BLUE)[DEBUG]		Building debug version...$(RESET)"
	@if [ "$(ASAN_CHECK)" = "supported" ]; then \
		echo "$(GREEN)[INFO]		Address Sanitizer is supported and will be enabled$(RESET)"; \
		$(MAKE) --no-print-directory SANITIZE=yes debug_build; \
	else \
		echo "$(YELLOW)[WARNING]	Address Sanitizer not supported, building with basic debug symbols$(RESET)"; \
		$(MAKE) --no-print-directory validate_debug_env debug_build_no_asan; \
	fi
	@rm -rf ./$(OBJS_DEBUG_DIR)/$(NAME_DEBUG_LOGS)
	@mv -f $(NAME_DEBUG_LOGS) ./$(OBJS_DEBUG_DIR) 2>/dev/null || true
	@echo "\n$(BLUE)[INFO]		[$(NAME_DEBUG_LOGS)] in ./$(OBJS_DEBUG_DIR) $(RESET)"

debug_build: $(OBJS_DEBUG)
	@echo "$(YELLOW)[DEBUG]		Compiling [$(NAME_DEBUG)] exe...$(RESET)"
	$(CC) $(CFLAGS) $(DEBUG_FLAGS) $(SANITIZE_COMPILE) \
		test.c $(OBJS_DEBUG) $(SANITIZE_LINK) -o $(NAME_DEBUG)
	@echo "$(GREEN)[SUCCESS]	Debug build complete with: $(RESET)"
	@echo "$(BLUE)[INFO]		- Debug symbols enabled"
	@echo "$(BLUE)[INFO]		- Address sanitizer active (detects memory issues)"
	@echo "$(BLUE)[INFO]		- Undefined behavior detection active"
	@echo "$(BLUE)[INFO]		- Frame pointer preserved (for better backtraces)"

debug_build_no_asan: $(OBJS_DEBUG)
	@echo "$(YELLOW)[DEBUG]		Compiling $(NAME_DEBUG) exe without sanitizers...$(RESET)"
	$(CC) $(CFLAGS) $(DEBUG_FLAGS) test.c $(OBJS_DEBUG) -o $(NAME_DEBUG)
	@echo "$(GREEN)[SUCCESS]     Debug build complete with basic debug symbols$(RESET)"

$(OBJS_DEBUG_DIR)%.o: $(SRCS_DIR)%.c $(DEPS)
	@echo "$(YELLOW)[DEBUG]		Compiling: $<...$(RESET)"
ifeq ($(SANITIZE),yes)
	$(CC) $(CFLAGS) $(DEBUG_FLAGS) $(SANITIZE_COMPILE) -c $< -o $@
else
	$(CC) $(CFLAGS) $(DEBUG_FLAGS) -c $< -o $@
endif

debug_run: debug
	@echo "$(BRIGHT_BLUE)[DEBUG]		Running [$(NAME_DEBUG)] with sanitizers enabled...$(RESET)"
	./$(NAME_DEBUG)

valgrind: debug
	@echo "$(BLUE)[DEBUG]		Running [$(NAME_DEBUG)] with Valgrind to detect memory leaks...$(RESET)"
	valgrind --leak-check=full --show-leak-kinds=all --track-origins=yes ./$(NAME_DEBUG)

leak_check: debug
	@echo "$(BLUE)[DEBUG]		Running [$(NAME_DEBUG)] with leak detection...$(RESET)"
	ASAN_OPTIONS=detect_leaks=1 ./$(NAME_DEBUG)

debug_gdb: debug
	@echo "$(BLUE)[DEBUG]		Starting [$(NAME_DEBUG)] with GDB session...$(RESET)"
	gdb -ex "set confirm off" -ex "b main" -ex "run" ./$(NAME_DEBUG)

debug_lldb: debug
	@echo "$(BLUE)[DEBUG]		Starting [$(NAME_DEBUG)] LLDB session...$(RESET)"
	lldb -o "breakpoint set --name main" -o "run" ./$(NAME_DEBUG)

debug_clean:
	@echo "$(RED)[CLEAN]		Cleaning debug files...$(RESET)"
	$(RM) $(OBJS_DEBUG_DIR)

debug_fclean: debug_clean
	@echo "$(BRIGHT_RED)[FCLEAN]	Full cleaning: Removing [$(NAME_DEBUG) $(NAME_DEBUG_LOGS)]...$(RESET)"
	$(RM) $(NAME_DEBUG) $(NAME_DEBUG_LOGS)

re_debug:
	$(MAKE) debug_fclean
	$(MAKE) debug

debug_makeflags:
	@echo "MAKELEVEL: $(MAKELEVEL)"
	@echo "MAKEFLAGS: $(MAKEFLAGS)"
	@echo "Extracted -jN from MAKEFLAGS: $(filter -j%,$(MAKEFLAGS))"


# Help command
help:
	@echo ""
	@echo "$(BLUE)Configuration:$(RESET)"
	@echo "  Compiler:		$(YELLOW)$(CC)$(RESET)"
	@echo "  Flags:		$(YELLOW)$(CFLAGS)$(RESET)"
	@echo "  Debug Flags:		$(YELLOW)$(DEBUG_FLAGS)$(RESET)"
	@echo ""
	@echo "$(BLUE)Compile & debug info:$(RESET)"
	@echo "  Address Sanitizer:	$(ASAN_CHECK)"
	@echo "  Sources:		$(words $(SRCS)) files"
	@echo "  Objects:		$(words $(OBJS)) files"
	@echo "  Debug Objects:	$(words $(OBJS_DEBUG)) files"
	@echo "  Sources:		$(SRCS)"
	@echo "  Objects:		$(OBJS)"
	@echo "  Debug Objects:	$(OBJS_DEBUG)"
	@echo ""
	@echo "$(BLUE)Checking for missing files...:$(RESET)"
	@for src in $(SRCS); do \
		if [ ! -f $$src ]; then \
			echo "$(RED)Missing source: $$src$(RESET)"; \
		fi; \
	done
	@echo ""
	@echo "$(BRIGHT_BLUE)+- Available Commands -----------------+ $(RESET)"
	@echo ""
	@echo "$(BLUE)Main Commands: $(RESET)"
	@echo "  $(GREEN)make all$(RESET)					-  $(WHITE)Build the library (default)$(RESET)"
	@echo "  $(GREEN)make test$(RESET)					-  $(WHITE)Build the test exe linking test.c to libft$(RESET)"
	@echo "  $(GREEN)make validate_env$(RESET)				-  $(WHITE)Checks if directory environment is set up$(RESET)"
	@echo "  $(GREEN)make re$(RESET)					-  $(WHITE)Rebuild current build from scratch$(RESET)"
	@echo "  $(RED)make clean$(RESET)					-  $(WHITE)Remove object files$(RESET)"
	@echo "  $(RED)make fclean$(RESET)					-  $(WHITE)Remove all generated files$(RESET)"
	@echo ""
	@echo "$(BLUE)Debug: $(RESET)"
	@echo "  $(CYAN)make debug$(RESET)					- $(WHITE)Build with sanitizers for leak and error detection$(RESET)"
	@echo "  $(CYAN)make debug_check$(RESET)				- $(WHITE)Check for build system issues (duplicate sources)$(RESET)"
	@echo "  $(CYAN)make debug_run$(RESET)				- $(WHITE)Run the program with sanitizers$(RESET)"
	@echo "  $(CYAN)make valgrind$(RESET)					- $(WHITE)Run with Valgrind for comprehensive leak detection$(RESET)"
	@echo "  $(CYAN)make leak_check$(RESET)				- $(WHITE)Memory leak detection with AddressSanitizer$(RESET)"
	@echo "  $(CYAN)make debug_gdb$(RESET)				- $(WHITE)Build and debug with GDB$(RESET)"
	@echo "  $(CYAN)make debug_lldb$(RESET)				- $(WHITE)Build and debug with LLDB$(RESET)"
	@echo "  $(CYAN)make debug_clean$(RESET)				- $(WHITE)Remove debug objects$(RESET)"
	@echo "  $(CYAN)make debug_fclean$(RESET)				- $(WHITE)Remove all generated debug files$(RESET)"
	@echo "  $(GREEN)make re_debug$(RESET)					- $(WHITE)Rebuild current debug version from scratch$(RESET)"
	@echo ""
	@echo "$(BLUE)Options: $(RESET)"
	@echo "  Add $(MAGENTA)VERBOSE=1$(RESET)					- $(WHITE)For detailed output$(RESET)"
	@echo "  Add $(MAGENTA)DEBUG=1$(RESET)					- $(WHITE)For debug mode -> Use #ifdef DEBUG ... #endif for debug commands$(RESET)"
	@echo ""
	@echo "$(BRIGHT_BLUE)+--------------------------------------+ $(RESET)"

.PHONY: all bonus clean fclean re validate_env \
	debug validate_debug_env debug_build debug_build_no_asan valgrind leak_check debug_run debug_gdb debug_lldb debug_clean debug_fclean re_debug debug_makeflag \
	help
