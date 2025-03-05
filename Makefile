# **************************************************************************** #
#                                                                              #
#                                                         :::      ::::::::    #
#    Makefile                                           :+:      :+:    :+:    #
#                                                     +:+ +:+         +:+      #
#    By: gsabatin <gsabatin@student.42.fr>          +#+  +:+       +#+         #
#                                                 +#+#+#+#+#+   +#+            #
#    Created: 2024/12/09 19:27:37 by gsabatin          #+#    #+#              #
#    Updated: 2025/03/05 04:33:54 by gsabatin         ###   ########.fr        #
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
JOBS				:= $(shell nproc 2>/dev/null || echo 2)

# General
NAME				= libft.a
NAME_TEST			= libft_test.a
NAME_DEBUG			= libft_debug.out
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
OBJS_DEBUG_DIR		:= objs/debug

# Compile info
SRCS				:= $(shell find src -type f -name "*.c")
OBJS				:= $(SRCS:$(SRCS_DIR)%.c=$(OBJS_DIR)%.o)
DEBUG_OBJS			:= $(SRCS:$(SRCS_DIR)%.c=$(OBJS_DEBUG_DIR)%.o)

DEPS				:= includes/libft.h

ifndef VERBOSE
	MAKEFLAGS += -s
endif

ifdef DEBUG
$(info Debug mode enabled)
CFLAGS				+= -g -DDEBUG
endif

all: validate_environment
	$(MAKE) $(NAME)

$(NAME): $(OBJS)
	@echo "$(YELLOW)[COMPILE]	Compiling archive [$(NAME)]...$(RESET)"
	$(AR) $(NAME) $(OBJS)
	@echo "$(GREEN)[SUCCESS]	Archive [$(NAME)] successfully compiled!$(RESET)"

test: validate_environment
	@$(MAKE) -j$(JOBS) $(NAME_TEST)
	@echo "$(BLUE)[INFO]		Running [$(NAME_TEST)]...$(RESET)"
	./$(NAME_TEST)

$(NAME_TEST): $(OBJS)
	@echo "$(YELLOW)[COMPILE]	Compiling exe [$(NAME_TEST)]...$(RESET)"
	$(CC) $(CFLAGS) $(OBJS) test.c -o $(NAME_TEST)
	@echo "$(GREEN)[SUCCESS]	Exe [$(NAME_TEST)] successfully compiled!$(RESET)"

$(OBJS_DIR)%.o: $(SRCS_DIR)%.c $(DEPS)
	$(CC) $(CFLAGS) -c $< -o $@

clean:
	@echo "$(RED)[CLEAN]		Cleaning [$(NAME)] object files...$(RESET)"
	$(RM) $(OBJS_DIR)

fclean: clean
	@echo "$(RED)[CLEAN]		Full cleaning: Removing [$(NAME)]...$(RESET)"
	$(RM) $(NAME) $(NAME_TEST) $(NAME_DEBUG)

re: fclean all

validate_environment:
	@echo "$(BLUE)[INFO]		Creating/checking [$(NAME)] directories...$(RESET)"
	mkdir -p $(OBJS_DIR) $(sort $(dir $(OBJS)))

validate_debug_env:
	@echo "$(BLUE)[DEBUG]		Setting up debug environment...$(RESET)"
	@mkdir -p $(OBJS_DEBUG_DIR) $(sort $(dir $(DEBUG_OBJS)))

# Debug
ASAN_CHECK := $(shell $(CC) -fsanitize=address -x c -c /dev/null -o /dev/null 2>/dev/null && echo "supported" || echo "not supported")
debug: validate_debug_env
	@echo "$(BLUE)[DEBUG]		Building debug version...$(RESET)"
	@if [ "$(ASAN_CHECK)" = "supported" ]; then \
		echo "$(GREEN)[INFO]		Address Sanitizer is supported and will be enabled$(RESET)"; \
		$(MAKE) -j$(JOBS) --no-print-directory SANITIZE=yes debug_build; \
	else \
		echo "$(YELLOW)[WARNING]	Address Sanitizer not supported, building with basic debug symbols$(RESET)"; \
		$(MAKE) -j$(JOBS) --no-print-directory validate_debug_env debug_build_no_asan; \
	fi

debug_build: $(DEBUG_OBJS)
	@echo "$(YELLOW)[DEBUG]		Compiling [$(NAME_DEBUG)] exe...$(RESET)"
	$(CC) $(CFLAGS) $(DEBUG_FLAGS) $(SANITIZE_COMPILE) \
		test.c $(DEBUG_OBJS) $(SANITIZE_LINK) -o $(NAME_DEBUG)
	@echo "$(GREEN)[SUCCESS]	Debug build complete with: $(RESET)"
	@echo "		- Debug symbols enabled"
	@echo "		- Address sanitizer active (detects memory issues)"
	@echo "		- Undefined behavior detection active"
	@echo "		- Frame pointer preserved (for better backtraces)"

debug_build_no_asan: $(DEBUG_OBJS)
	@echo "$(YELLOW)[DEBUG]		Compiling $(NAME_DEBUG) exe without sanitizers...$(RESET)"
	$(CC) $(CFLAGS) $(DEBUG_FLAGS) test.c $(DEBUG_OBJS) -o $(NAME_DEBUG)
	@echo "$(GREEN)[SUCCESS]     Debug build complete with basic debug symbols$(RESET)"

$(OBJS_DEBUG_DIR)%.o: $(SRCS_DIR)%.c $(DEPS)
	@echo "$(YELLOW)[DEBUG]		Compiling: $<...$(RESET)"
ifeq ($(SANITIZE),yes)
	$(CC) $(CFLAGS) $(DEBUG_FLAGS) $(SANITIZE_COMPILE) -c $< -o $@
else
	$(CC) $(CFLAGS) $(DEBUG_FLAGS) -c $< -o $@
endif

debug_run: debug
	@echo "$(BLUE)[DEBUG]		Running [$(NAME_DEBUG)] with sanitizers enabled...$(RESET)"
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
	$(RM) $(OBJS_DEBUG_DIR) $(NAME_DEBUG) $(NAME_DEBUG).dSYM

debug_check:
	@echo "$(BLUE)[INFO]		Build System Information:$(RESET)"
	@echo "Compiler: $(CC)"
	@echo "Compiler Flags: $(CFLAGS)"
	@echo "Debug Flags: $(DEBUG_FLAGS)"
	@echo ""
	@echo "$(BLUE)[INFO]		Checking for duplicate sources:$(RESET)"
	@for src in $(sort $(SRCS)); do \
		count=$$(echo "$(SRCS)" | tr ' ' '\n' | grep -c "$$src"); \
		if [ $$count -gt 1 ]; then \
			echo "$(RED)Duplicate source: $$src appears $$count times$(RESET)"; \
		fi; \
	done

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
	@echo "  Sources:		$(SRCS)"
	@echo "  Objects:		$(OBJS)"
	@echo ""
	@echo "$(BLUE)Checking for missing files:$(RESET)"
	@for src in $(SRCS); do \
		if [ ! -f $$src ]; then \
			echo "$(RED)Missing source: $$src$(RESET)"; \
		fi; \
	done
	@echo ""
	@echo "$(CYAN)$(BOLD)+- Available Commands -----------------+ $(RESET)"
	@echo ""
	@echo "$(BLUE)Main Commands: $(RESET)"
	@echo "  $(GREEN)make all$(RESET)					-  $(WHITE)Build the library (default)$(RESET)"
	@echo "  $(GREEN)make test$(RESET)					-  $(WHITE)Build the test exe linking test.c to libft$(RESET)"
	@echo "  $(GREEN)make validate_environment$(RESET)			-  $(WHITE)Checks if directory environment is set up$(RESET)"
	@echo "  $(GREEN)make clean$(RESET)					-  $(WHITE)Remove object files $(RESET)"
	@echo "  $(GREEN)make fclean$(RESET)					-  $(WHITE)Remove all generated files $(RESET)"
	@echo "  $(GREEN)make re$(RESET)					-  $(WHITE)Rebuild from scratch $(RESET)"
	@echo ""
	@echo "$(BLUE)Debug: $(RESET)"
	@echo "  $(CYAN)make debug$(RESET)					- $(WHITE)Build with sanitizers for leak and error detection$(RESET)"
	@echo "  $(CYAN)make debug_check$(RESET)				- $(WHITE)Check for build system issues (duplicate sources)$(RESET)"
	@echo "  $(CYAN)make debug_run$(RESET)				- $(WHITE)Run the program with sanitizers$(RESET)"
	@echo "  $(CYAN)make valgrind$(RESET)					- $(WHITE)Run with Valgrind for comprehensive leak detection$(RESET)"
	@echo "  $(CYAN)make leak_check$(RESET)				- $(WHITE)Memory leak detection with AddressSanitizer$(RESET)"
	@echo "  $(CYAN)make debug_gdb$(RESET)				- $(WHITE)Build and debug with GDB$(RESET)"
	@echo "  $(CYAN)make debug_lldb$(RESET)				- $(WHITE)Build and debug with LLDB$(RESET)"
	@echo "  $(CYAN)make debug_clean$(RESET)				- $(WHITE)Cleans debug files$(RESET)"
	@echo ""
	@echo "$(BLUE)Options: $(RESET)"
	@echo "  Add $(MAGENTA)VERBOSE=1$(RESET)					- $(WHITE)For detailed output$(RESET)"
	@echo "  Add $(MAGENTA)DEBUG=1$(RESET)					- $(WHITE)For debug mode -> Use #ifdef DEBUG ... #endif for debug commands$(RESET)"
	@echo ""
	@echo "$(CYAN)$(BOLD)+--------------------------------------+ $(RESET)"

.PHONY: all bonus clean fclean re validate_environment debug validate_debug_env debug_build debug_build_no_asan valgrind leak_check debug_run debug_gdb debug_lldb debug_clean debug_check help
