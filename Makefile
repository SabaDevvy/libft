# Colors
RST					= \033[0m
BLD					= \033[1m
ERS					= \033[K

RED					= \033[0;31m
GRN					= \033[0;32m
YLW					= \033[0;33m
BLU					= \033[0;34m
MAG					= \033[0;35m
CYN					= \033[0;36m
WHT					= \033[0;37m

REDB				= \033[0;91m
GRNB				= \033[0;92m
YLWB				= \033[0;93m
BLUB				= \033[0;94m
CYNB				= \033[0;96m

# Git settings
GITHUB_USER			:= SabaDevvy
GITHUB_URL			:= git@github.com:$(GITHUB_USER)/

# Make settings and machine info
LOG_TIME			= $$(date "+%H:%M:%S")
UNAME_S				:= $(shell uname -s)
UNAME_M				:= $(shell uname -m)
IS_LINUX			:= $(filter Linux,$(UNAME_S))

JOBS				:= $(shell nproc 2>/dev/null || echo 2)

ifeq ($(filter --jobserver-fds=% -j%,$(MAKEFLAGS)),)
  ifeq ($(MAKELEVEL), 0)
    MAKEFLAGS += -j$(JOBS)
  endif
endif

ifndef VERBOSE
	MAKEFLAGS += -s
endif

# Project
PROJECT				= libft

NAME				= $(addsuffix .a, $(PROJECT))

NAME_TEST			= $(addsuffix _test.exe, $(PROJECT))
NAME_DEBUG_ARCHIVE	= $(addsuffix _debug.a, $(PROJECT))
NAME_DEBUG_EXE		= $(addsuffix _debug.exe, $(PROJECT))
NAME_DEBUG_VAL		= $(addsuffix _debug_val.exe, $(PROJECT))
ASAN_LOGS			= $(addsuffix .dSYM, $(NAME_DEBUG_EXE))

# Libraries
# LIBS_PRIVATE if you don't use submodules, else LIBS_SUBMODULE. LIBS_EXTERNAL = external libraries.
LIBS_PRIVATE		:=
LIBS_SUBMODULE		:=
LIBS_EXTERNAL		:=
LIBS				:= $(LIBS_EXTERNAL) $(LIBS_PRIVATE) $(LIBS_SUBMODULE)
LIBS_CLEAN			:= $(strip $(LIBS))

# Compile settings
CC					= cc
CFLAGS				= -Wall -Wextra -Werror -Iincludes
DEBUG_FLAGS			= -O0 -gdwarf-4 -fno-omit-frame-pointer
SANITIZE_COMPILE	= -fsanitize=address -fsanitize=undefined -fsanitize=signed-integer-overflow # -fsanitize=thread
SANITIZE_LINK		= -fsanitize=address -fsanitize=undefined -fsanitize=signed-integer-overflow # -fsanitize=thread
AR					= ar rcs
RM					= rm -rf

ifdef DEBUG
CFLAGS				+= -DDEBUG
endif

# Directories
SRCS_DIR			:= src/
OBJS_DIR 			:= objs/
OBJS_DIRS			= $(sort $(dir $(OBJS)))
DEBUG_DIR			= debug/
DOCKER_DIR			= debug/docker/
LIBS_DIR			:= ../
LIBS_DIRS			:= $(addprefix $(LIBS_DIR), $(addsuffix /, $(LIBS)))

OBJS_DEBUG_DIR		= debug/objs/
OBJS_DOCKER_DIR		= debug/docker/objs/

# Compile info
SRCS				:= $(shell find src -type f -name "*.c")
OBJS				:= $(SRCS:$(SRCS_DIR)%.c=$(OBJS_DIR)%.o)
OBJS_DEBUG			:= $(SRCS:$(SRCS_DIR)%.c=$(OBJS_DEBUG_DIR)%.o)
OBJS_DOCKER			:= $(SRCS:$(SRCS_DIR)%.c=$(OBJS_DOCKER_DIR)%.o)

DEPS				:= $(wildcard includes/*.h)

LIBS_LINKS			:= $(addprefix -L, $(LIBS_DIRS)) $(addprefix -l, $(subst lib,,$(LIBS)))
LIBS_LINKS_DOCKER	:= $(addprefix -L, $(DOCKER_DIR)) $(addprefix -l, $(subst lib,,$(addsuffix _docker,$(LIBS))))

TEST_FILES			:= test.c

# # Includes
# INCLUDES_DIR		:= includes/
# INCLUDES_DIRS		:= $(INCLUDES_DIR) $(addsuffix $(INCLUDES_DIR), $(LIBS_DIRS))
# vpath %.h $(INCLUDES_DIRS)
# CFLAGS				+= $(addprefix -I, $(INCLUDES_DIRS))
# $(info $(INCLUDES_DIRS))

all: validate_env
	@mkdir -p $(sort $(dir $(OBJS)))
	$(MAKE) $(NAME)

$(NAME): $(OBJS)
	@echo "$(ERS)[$(LOG_TIME)]$(YLW)[$(PROJECT)]	[COMPILE]	[$(PROJECT)] src files successfully compiled$(RST)"
	@echo "[$(LOG_TIME)]$(YLWB)[$(PROJECT)]	[COMPILE]	Compiling archive [$(NAME)]...$(RST)"
	$(AR) $(NAME) $(OBJS)
	@echo "[$(LOG_TIME)]$(GRNB)[$(PROJECT)]	[SUCCESS]	Exe [$(NAME)] successfully compiled!$(RST)"

test: all build-libs
	@echo "$(ERS)[$(LOG_TIME)]$(YLW)[$(PROJECT)]	[COMPILE]	[$(PROJECT)] src files successfully compiled$(RST)"
	@echo "[$(LOG_TIME)]$(YLW)[$(PROJECT)]	[COMPILE]	Compiling exe [$(NAME_TEST)]...$(RST)"
	$(CC) $(CFLAGS) $(TEST_FILES) -L. -l$(subst lib,,$(PROJECT)) $(LIBS_LINKS) -o $(NAME_TEST)
	@echo "[$(LOG_TIME)]$(GRNB)[$(PROJECT)]	[SUCCESS]	Exe [$(NAME_TEST)] successfully compiled!$(RST)"
	@echo "[$(LOG_TIME)]$(BLU)[$(PROJECT)]	[INFO]		Running [$(NAME_TEST)]...$(RST)"
	echo "-----------------------------------------"
	./$(NAME_TEST) $(ARGS)
	echo "\n-----------------------------------------"

$(OBJS_DIR)%.o: $(SRCS_DIR)%.c $(DEPS)
ifeq ($(DETAILS),1)
	@echo "[$(LOG_TIME)]$(YLW)[$(PROJECT)]	[COMPILE]	Compiling $(YLWB)$<$(YLW) in $(OBJS_DIR)$(RST)"
else
	@printf "$(ERS)[$(LOG_TIME)]$(YLW)[$(PROJECT)]	[COMPILE]	Compiling $(YLWB)$<$(RST)\r"
endif
	$(CC) $(CFLAGS) -c $< -o $@

clean:
	@echo "[$(LOG_TIME)]$(RED)[$(PROJECT)]	[CLEAN]		Cleaning [$(NAME)] object files...$(RST)"
	$(RM) $(OBJS_DIR)

fclean: clean
	@echo "[$(LOG_TIME)]$(REDB)[$(PROJECT)]	[CLEAN]		Full cleaning: Removing [$(NAME)]...$(RST)"
	$(RM) $(NAME) $(DEBUG_DIR)

re:
	$(MAKE) fclean
	$(MAKE) all

validate_env: # NAME=$(...)
	@echo "[$(LOG_TIME)]$(BLU)[$(PROJECT)]	[INFO]		Checking [$(NAME)] environment...$(RST)"
	# Check if required libs paths exist
	@for library in $(LIBS); do \
		if [ ! -d "$(LIBS_DIR)$$library" ]; then \
			echo "[$(LOG_TIME)]$(REDB)[$(PROJECT)]	[ERROR]		$$library directory not found!$(RST)"; \
			echo "$(YLW)					-> Run: [$(YLWB)make clone_libs / make update_submodules$(YLW)] and import external libraries if there are any.$(RST)" ; \
			exit 1 ; \
		fi; \
	done
	# Check for outdated or uninitialized submodules
	@if git submodule status --recursive | grep '^[+-]' > /tmp/submodule_issues; then \
		echo "[$(LOG_TIME)]$(REDB)[$(PROJECT)]	[ERROR]		Some submodules are outdated or not initialized!$(RST)"; \
		while read -r line; do \
			submodule=$$(echo $$line | awk '{print $$2}'); \
			submodule_name=$$(basename $$submodule); \
			if echo "$$line" | grep -q '^+'; then \
				echo "[$(LOG_TIME)]$(YLW)[$(PROJECT)]	[WARNING]	Submodule $$submodule is not on tracked commit.$(RST)"; \
				echo "$(YLW)					-> Git add and commit to update submodule commit, or run [$(YLWB)make update_submodules$(YLW)] to set it back to tracked commit.$(RST)"; \
			elif echo "$$line" | grep -q '^-'; then \
				echo "[$(LOG_TIME)]$(RED)[$(PROJECT)]	[ERROR]		Submodule $$submodule is not initialized!. \
				Run: [$(YLWB)make clone_libs / make update_submodules$(RED)]$(RST)"; \
				exit 1; \
			fi; \
		done < /tmp/submodule_issues; \
		rm /tmp/submodule_issues; \
	fi
	# Checks uncommitted changes
	@for submodule in $(LIBS_SUBMODULE); do \
		if cd $(LIBS_DIR)$$submodule && git status --porcelain | grep -q .; then \
			echo "[$(LOG_TIME)]$(YLW)[$(PROJECT)]	[WARNING]	Detected changes in submodule [$(LIBS_DIR)$$submodule]. Remember to commit in modified submodules!$(RST)"; \
		fi; \
		cd $(CURDIR); \
	done

update_submodules:
	@echo "[$(LOG_TIME)]$(BLU)[$(PROJECT)]	[INFO]		Initializing/updating submodules [$(LIBS_SUBMODULE)]...$(RST)"
	@git submodule update --init --recursive
	@echo "[$(LOG_TIME)]$(GRN)[$(PROJECT)]	[SUCCESS]	All submodules are now initialized and up to date!$(RST)"

clone_repos:
	@if [ -z "$(LIBS_PRIVATE)" ]; then \
		echo "[$(LOG_TIME)]$(YLW)[$(PROJECT)]	[INFO]		No private libraries to clone!$(RST)"; \
	else \
		for library in $(LIBS_PRIVATE); do \
			echo "[$(LOG_TIME)]$(BLU)[$(PROJECT)]	[INFO]		Cloning [$(BLUB)$$library$(BLU)] in $(LIBS_DIR)$$library$(RST)"; \
			git clone $(GITHUB_URL)$$library.git $(LIBS_DIR)$$library; \
		done; \
		echo "[$(LOG_TIME)]$(GRN)[$(PROJECT)]	[SUCCESS]	All needed private libraries have been cloned!$(RST)"; \
	fi

build-libs:
	@if [ -z "$(LIBS_CLEAN)" ]; then \
		echo "[$(LOG_TIME)]$(YLW)[$(PROJECT)]	[INFO]		No libraries to build.$(RST)"; \
	else \
		echo "[$(LOG_TIME)]$(BLUB)[$(PROJECT)]	[INFO]		Building libraries...$(RST)"; \
		for lib_dir in $(LIBS_DIRS); do \
			echo "[$(LOG_TIME)]$(BLU)[$(PROJECT)]	[BUILD]		Building in $$lib_dir$(RST)"; \
			$(MAKE) -C $$lib_dir; \
		done; \
	fi

re-build-libs:
	@if [ -z "$(LIBS_CLEAN)" ]; then \
		echo "[$(LOG_TIME)]$(YLW)[$(PROJECT)]	[INFO]		No libraries to rebuild.$(RST)"; \
	else \
		@echo "[$(LOG_TIME)]$(BLUB)[$(PROJECT)]	[INFO]		Rebuilding libraries...$(RST)"; \
		@for lib_dir in $(LIBS_DIRS); do \
			echo "[$(LOG_TIME)]$(BLU)[$(PROJECT)]	[BUILD]		Rebuilding in $$lib_dir$(RST)"; \
			$(MAKE) -C $$lib_dir re; \
		done; \
	fi

clean-deep:
	@if [ -z "$(LIBS_CLEAN)" ]; then \
		echo "[$(LOG_TIME)]$(YLW)[$(PROJECT)]	[INFO]		No libraries to clean.$(RST)"; \
	else \
		echo "[$(LOG_TIME)]$(REDB)[$(PROJECT)]	[DEEP CLEAN]	Cleaning all dependent libraries: [$(LIBS)]...$(RST)"; \
		for lib_dir in $(LIBS_DIRS); do \
			echo "[$(LOG_TIME)]$(RED)[$(PROJECT)]	[CLEAN]		Cleaning in $$lib_dir$(RST)"; \
			$(MAKE) -C $$lib_dir clean; \
		done; \
		$(MAKE) clean; \
	fi

fclean-deep:
	@if [ -z "$(LIBS_CLEAN)" ]; then \
		echo "[$(LOG_TIME)]$(YLW)[$(PROJECT)]	[INFO]		No libraries to full clean.$(RST)"; \
	else \
		echo "[$(LOG_TIME)]$(REDB)[$(PROJECT)]	[DEEP FCLEAN]	Full Cleaning all dependent libraries: [$(LIBS)]...$(RST)"; \
		for lib_dir in $(LIBS_DIRS); do \
			echo "[$(LOG_TIME)]$(RED)[$(PROJECT)]	[FCLEAN]	Full cleaning in $$lib_dir$(RST)"; \
			$(MAKE) -C $$lib_dir fclean; \
		done; \
		$(MAKE) fclean; \
	fi

re-deep:
	@if [ -z "$(LIBS_CLEAN)" ]; then \
		echo "[$(LOG_TIME)]$(YLW)[$(PROJECT)]	[INFO]  No libraries to re-make.$(RST)"; \
	else \
		echo "[$(LOG_TIME)]$(BLUB)[$(PROJECT)]	[REBUILD]	Completely rebuilding all libraries and project...$(RST)"; \
		for lib_dir in $(LIBS_DIRS); do \
			echo "[$(LOG_TIME)]$(BLU)[$(PROJECT)]	[REBUILD]	Rebuilding in $$lib_dir$(RST)"; \
			$(MAKE) -C $$lib_dir re; \
		done; \
		$(MAKE) re; \
	fi

# Debug
ASAN_CHECK				= $(shell $(CC) -fsanitize=address -x c -c /dev/null -o /dev/null 2>/dev/null && echo "supported" || echo "not_supported")
debug:
	$(MAKE) build-libs;
	$(MAKE) validate_env NAME=$(NAME_DEBUG_EXE)
	@echo "[$(LOG_TIME)]$(BLU)[$(PROJECT)]	[DEBUG]		Building debug version...$(RST)"
	@if [ "$(ASAN_CHECK)" = "supported" ]; then \
		echo "[$(LOG_TIME)]$(GRN)[$(PROJECT)]	[DEB-INFO]	Address Sanitizer is supported and will be enabled$(RST)"; \
		$(MAKE) --no-print-directory SANITIZE=yes debug-build; \
	else \
		echo "[$(LOG_TIME)]$(YLW)[$(PROJECT)]	[DEB-WARNING]	Address Sanitizer not enabled/supported, building with basic debug symbols$(RST)"; \
		$(MAKE) --no-print-directory debug-build_no_asan; \
	fi

debug-build: $(DEBUG_DIR)$(NAME)
	@echo "[$(LOG_TIME)]$(YLWB)[$(PROJECT)]	[DEB-COMPILE]	Compiling [$(NAME_DEBUG_EXE)] exe...$(RST)"
	$(CC) $(CFLAGS) $(DEBUG_FLAGS) $(SANITIZE_COMPILE) \
	$(TEST_FILES) -L$(DEBUG_DIR) -l$(subst lib,,$(PROJECT)) $(LIBS_LINKS) -o $(NAME_DEBUG_EXE) $(SANITIZE_LINK)
	@echo "[$(LOG_TIME)]$(GRNB)[$(PROJECT)]	[SUCCESS]	Debug build complete with: $(RST)"
	@echo "[$(LOG_TIME)]$(BLU)[$(PROJECT)]	[DEB-INFO]	- Debug symbols enabled$(RST)"
	@echo "[$(LOG_TIME)]$(BLU)[$(PROJECT)]	[DEB-INFO]	- Address sanitizer active (detects memory issues)$(RST)"
	@echo "[$(LOG_TIME)]$(BLU)[$(PROJECT)]	[DEB-INFO]	- Undefined behavior detection active$(RST)"
	@echo "[$(LOG_TIME)]$(BLU)[$(PROJECT)]	[DEB-INFO]	- Frame pointer preserved (for better backtraces)$(RST)"
	@mv -f $(NAME_DEBUG_EXE) $(ASAN_LOGS) ./$(DEBUG_DIR) 2>/dev/null || true
	@echo "[$(LOG_TIME)]$(BLU)[$(PROJECT)]	[DEB-INFO]	[$(NAME_DEBUG_EXE)] and [$(ASAN_LOGS)] in ./$(DEBUG_DIR) $(RST)"

debug-build_no_asan: $(DEBUG_DIR)$(NAME) #OBJS_DEBUG=$() NAME_DEBUG_EXE=$(...) LIBS_LINKS=$(...)
	@echo "[$(LOG_TIME)]$(YLW)[$(PROJECT)]	[DEB-INFO]	Compiling [$(NAME_DEBUG_EXE)] exe without sanitizers...$(RST)"
	$(CC) $(CFLAGS) $(DEBUG_FLAGS) $(TEST_FILES) -L$(DEBUG_DIR) -l$(subst lib,,$(PROJECT)) $(LIBS_LINKS) -o $(NAME_DEBUG_EXE)
	@echo "[$(LOG_TIME)]$(GRNB)[$(PROJECT)]	[DEB-SUCCESS]	Debug build complete with basic debug symbols$(RST)"
	@echo "[$(LOG_TIME)]$(BLU)[$(PROJECT)]	[DEB-INFO]	[$(NAME_DEBUG_EXE)] in ./$(DEBUG_DIR) $(RST)"

debug-build_archive: $(DEBUG_DIR)$(NAME)

$(DEBUG_DIR)$(NAME): $(OBJS_DEBUG)
	@echo "$(ERS)[$(LOG_TIME)]$(YLW)[$(PROJECT)]	[DEB-COMPILE]	[$(PROJECT)] src files successfully compiled with debug flags$(RST)"
	@echo "[$(LOG_TIME)]$(YLW)[$(PROJECT)]	[DEB-COMPILE]	Compiling [$(PROJECT)] debug archive. Address sanitizers: $(ASAN_CHECK).$(RST)"
		$(AR) $(NAME) $(OBJS_DEBUG)
	@echo "[$(LOG_TIME)]$(GRNB)[$(PROJECT)]	[DEB-SUCCESS]	[$(NAME)] debug archive succesfully compiled!$(RST)"
	@mv -f $(NAME) ./$(DEBUG_DIR) 2>/dev/null || true

$(OBJS_DEBUG_DIR)%.o: $(SRCS_DIR)%.c $(DEPS)
	@mkdir -p $(dir $@)
ifeq ($(DETAILS),1)
	@echo "[$(LOG_TIME)]$(YLW)[$(PROJECT)]	[DEB-COMPILE]	Compiling $(YLWB)$<$(YLW) in $(OBJS_DEBUG_DIR)$(RST)"
else
	@printf "$(ERS)[$(LOG_TIME)]$(YLW)[$(PROJECT)]	[DEB-COMPILE]	Compiling $(YLWB)$<$(RST)\r"
endif
ifeq ($(SANITIZE),yes)
	$(CC) $(CFLAGS) $(DEBUG_FLAGS) $(SANITIZE_COMPILE) -c $< -o $@
else
	$(CC) $(CFLAGS) $(DEBUG_FLAGS) -c $< -o $@
endif

debug-run: debug
	@echo "[$(LOG_TIME)]$(BLUB)[$(PROJECT)]	[DEBUG-RUN]	Running [$(NAME_DEBUG_EXE)] with sanitizers enabled...$(RST)"
	./$(DEBUG_DIR)$(NAME_DEBUG_EXE) $(ARGS)

leak-check: debug
	@echo "[$(LOG_TIME)]$(BLU)[$(PROJECT)]	[DEBUG-RUN]	Running [$(NAME_DEBUG_EXE)] with leak detection...$(RST)"
	ASAN_OPTIONS=detect_leaks=1 ./$(DEBUG_DIR)$(NAME_DEBUG_EXE) $(ARGS)

debug-gdb: debug
	@echo "[$(LOG_TIME)]$(BLU)[$(PROJECT)]	[DEBU-RUNG]	Starting [$(NAME_DEBUG_EXE)] with GDB session...$(RST)"
	gdb -ex "set confirm off" -ex "b main" -ex "run" ./$(DEBUG_DIR)$(NAME_DEBUG_EXE) $(ARGS)

clean-debug:
	@echo "[$(LOG_TIME)]$(RED)[$(PROJECT)]	[CLEAN]		Cleaning debug objed files...$(RST)"
	$(RM) $(OBJS_DEBUG_DIR)

fclean-debug:
	@echo "[$(LOG_TIME)]$(REDB)[$(PROJECT)]	[FCLEAN]	Full cleaning: Removing [$(NAME_DEBUG_EXE) $(NAME_DEBUG_VAL) $(ASAN_LOGS)]...$(RST)"
	$(RM) $(DEBUG_DIR)

re-debug:
	$(MAKE) fclean-debug
	$(MAKE) debug

debug-makeflags:
	@echo "[$(LOG_TIME)][$(PROJECT)]	MAKELEVEL: $(MAKELEVEL)"
	@echo "[$(LOG_TIME)][$(PROJECT)]	MAKEFLAGS: $(MAKEFLAGS)"
	@echo "[$(LOG_TIME)][$(PROJECT)]	Extracted -jN from MAKEFLAGS: $(filter -j%,$(MAKEFLAGS))"

# Valgrind configuration
VALGRIND_IMAGE_NAME	:= valgrind-env
VALGRIND_PERS_CONT	:= valgrind-persistent
VALGRIND_REPORT		:= valgrind_report.txt
NAME_DEBUG_VAL_PATH	:= $(DEBUG_DIR)$(NAME_DEBUG_VAL)
REPORT_PATH			:= $(DEBUG_DIR)$(VALGRIND_REPORT)
VALGRIND_DOCKERFILE	:= $(DOCKER_DIR)Dockerfile
VALGRIND_FLAGS		:= --leak-check=full --show-leak-kinds=all --track-origins=yes --tool=memcheck

# Main Valgrind rule - detects environment and calls appropriate implementation
# Example: make valgrind ARGS='"1 2 3" "5 4 10"'(multiple argv); make valgrind ARGS="1 2 3 5 4 10" (unique argv)
valgrind:
ifeq ($(IS_LINUX),Linux)
	@echo "[$(LOG_TIME)]$(BLU)[$(PROJECT)]	[VALGRIND]	Linux detected, running Valgrind natively...$(RST)"
	$(MAKE) valgrind-native
else
	@echo "[$(LOG_TIME)]$(BLU)[$(PROJECT)]	[VALGRIND]	Non-Linux OS detected, using Docker-based Valgrind...$(RST)"
	@if [ "$(SLEEP)" = "1" ]; then \
		$(MAKE) valgrind-docker_sleep; \
	else \
		$(MAKE) valgrind-docker; \
	fi
endif
	@echo "[$(LOG_TIME)]$(GRN)[$(PROJECT)]	[SUCCESS]	Valgrind analysis complete.$(RST)"
	@echo "[$(LOG_TIME)]$(GRN)[$(PROJECT)]	[SUCCESS]	Full report saved in $(REPORT_PATH)$(RST)"
	$(MAKE) process-valgrind-report REPORT_PATH=$(VALGRIND_REPORT)
	@mv -f $(NAME_DEBUG_VAL) $(VALGRIND_REPORT) ./$(DEBUG_DIR) 2>/dev/null || true

valgrind-native:
	$(MAKE) validate_env NAME=$(NAME_DEBUG_VAL)
	@echo "[$(LOG_TIME)]$(BLUB)[$(PROJECT)]	[VALGRIND]	Running Valgrind analysis natively...$(RST)"
	@if ! command -v valgrind >/dev/null 2>&1; then \
		echo "[$(LOG_TIME)]$(RED)[$(PROJECT)]	[ERROR]	Valgrind is not installed. Please install it first.$(RST)"; \
		echo "[$(LOG_TIME)]$(YLW)[$(PROJECT)]	[INFO]		Install with command: [sudo apt-get install valgrind]$(RST)"; \
		exit 1; \
	fi; \
	$(MAKE) debug-build_no_asan NAME_DEBUG_EXE=$(NAME_DEBUG_VAL) ASAN_CHECK="disabled" SANITIZE="false"
	@echo "[$(LOG_TIME)]$(BLUB)[$(PROJECT)]	[VALGRIND]	Running memory analysis with Valgrind...$(RST)"
	echo '-----------------------------------------'
	@valgrind $(VALGRIND_FLAGS) --log-file=$(VALGRIND_REPORT) \
		./$(NAME_DEBUG_VAL) $(ARGS)
	@echo "\n-----------------------------------------"
	@mv -f $(NAME_DEBUG_VAL) ./$(DEBUG_DIR) 2>/dev/null

# Docker Valgrind setup
valgrind-docker-setup:
	$(MAKE) validate_env NAME=$(NAME_DEBUG_VAL)
	@echo "[$(LOG_TIME)]$(BLU)[$(PROJECT)]	[VALGRIND]	Preparing Docker Valgrind environment...$(RST)"
	@mkdir -p $(DOCKER_DIR)
	@if ! command -v docker >/dev/null 2>&1; then \
		echo "[$(LOG_TIME)]$(RED)[$(PROJECT)]	[ERROR]	Docker is not installed. Please install Docker Desktop first.$(RST)"; \
		exit 1; \
	fi
	@if ! docker info >/dev/null 2>&1; then \
		echo "[$(LOG_TIME)]$(RED)[$(PROJECT)]	[ERROR]	Docker daemon is not running. Please start Docker Desktop.$(RST)"; \
		exit 1; \
	fi
	# Check if Docker image exists and build if needed
	@if ! docker image inspect $(VALGRIND_IMAGE_NAME) >/dev/null 2>&1; then \
		echo "[$(LOG_TIME)]$(BLU)[$(PROJECT)]	[VALGRIND]	Creating [$(VALGRIND_DOCKERFILE)] Dockerfile...$(RST)"; \
		echo "FROM ubuntu:22.04" > $(VALGRIND_DOCKERFILE); \
		echo "ENV DEBIAN_FRONTEND=noninteractive" >> $(VALGRIND_DOCKERFILE); \
		echo "RUN apt-get update && apt-get install -y build-essential gcc make valgrind git && apt-get clean && rm -rf /var/lib/apt/lists/*" >> $(VALGRIND_DOCKERFILE); \
		echo "WORKDIR /app" >> $(VALGRIND_DOCKERFILE); \
		echo "[$(LOG_TIME)]$(BLU)[$(PROJECT)]	[VALGRIND]	Building Docker image with Valgrind...$(RST)"; \
		docker build -q -t $(VALGRIND_IMAGE_NAME) -f $(VALGRIND_DOCKERFILE) . ; \
		echo "[$(LOG_TIME)]$(GRN)[$(PROJECT)]	[SUCCESS]	Docker image [$(VALGRIND_IMAGE_NAME)] successfully created$(RST)"; \
	else \
		echo "[$(LOG_TIME)]$(BLU)[$(PROJECT)]	[VALGRIND]	Using existing Docker image [$(VALGRIND_IMAGE_NAME)] for Valgrind...$(RST)"; \
	fi

valgrind-docker: valgrind-docker-setup
	@echo "[$(LOG_TIME)]$(BLUB)[$(PROJECT)]	[INFO]		Running Valgrind analysis inside docker container...$(RST)"
	@docker run --rm \
		-v $(abspath ..):/parent \
		-w /parent/$(notdir $(CURDIR)) \
		$(VALGRIND_IMAGE_NAME) \
		/bin/bash -c " \
			export MAKE=/usr/bin/make && \
			echo -e '[$(LOG_TIME)]$(CYNB)[$(PROJECT)]	[DOCKER]	Building debug version inside docker container...$(RST)' && \
			\$$MAKE build-docker_libs DETAILS=$(DETAILS) && \
			\$$MAKE debug-build_no_asan DETAILS=$(DETAILS) \
			OBJS_DEBUG=\"$(OBJS_DOCKER)\" \
			OBJS_DEBUG_DIR=\"$(OBJS_DOCKER_DIR)\" \
			NAME_DEBUG_EXE=\"$(NAME_DEBUG_VAL)\" \
			LIBS_LINKS=\"$(LIBS_LINKS_DOCKER)\" \
			ASAN_CHECK=\"disabled\" && \
			SANITIZE=\"no\" && \
			echo -e '[$(LOG_TIME)]$(CYN)[$(PROJECT)]	[DOCKER]	Checking for executable...$(RST)'; \
			if [ ! -f \"$(NAME_DEBUG_VAL)\" ]; then \
				echo -e '[$(LOG_TIME)]$(RED)[$(PROJECT)]	[DOCK-ERROR]	Debug executable not found. Something went wrong during compilation...$(RST)'; \
				exit 1; \
			fi; \
			echo -e '[$(LOG_TIME)]$(CYNB)[$(PROJECT)]	[DOCK-INFO]	Valgrind build successfully compiled in docker container!$(RST)' && \
			echo -e '[$(LOG_TIME)]$(CYNB)[$(PROJECT)]	[DOCK-RUN]	Running Valgrind analysis in docker container...$(RST)' && \
			echo -e '-----------------------------------------' && \
			valgrind $(VALGRIND_FLAGS) --log-file=\"$(VALGRIND_REPORT)\" \
			\"./$(NAME_DEBUG_VAL)\" \"$(ARGS)\" ; \
			echo -e '\n-----------------------------------------'; \
			mv -f \"$(NAME_DEBUG_VAL)\" \"./$(DEBUG_DIR)\" 2>/dev/null "

valgrind-docker_sleep: valgrind-docker-setup valgrind-container-start
	@echo "[$(LOG_TIME)]$(BLUB)[$(PROJECT)]	[INFO]		Running Valgrind analysis inside persistent docker container...$(RST)"
	@docker exec $(VALGRIND_PERS_CONT) \
		/bin/bash -c " \
			export MAKE=/usr/bin/make && \
			echo -e '[$(LOG_TIME)]$(CYNB)[$(PROJECT)]	[DOCK-INFO]	Building debug version inside docker container...$(RST)' && \
			\$$MAKE build-docker_libs DETAILS=$(DETAILS) && \
			\$$MAKE debug-build_no_asan DETAILS=$(DETAILS) \
			OBJS_DEBUG=\"$(OBJS_DOCKER)\" \
			OBJS_DEBUG_DIR=\"$(OBJS_DOCKER_DIR)\" \
			NAME_DEBUG_EXE=\"$(NAME_DEBUG_VAL)\" \
			LIBS_LINKS=\"$(LIBS_LINKS_DOCKER)\" \
			ASAN_CHECK=\"disabled\" && \
			SANITIZE=\"no\" && \
			echo -e '[$(LOG_TIME)]$(CYN)[$(PROJECT)]	[DOCK-INFO]	Checking for executable...$(RST)'; \
			if [ ! -f \"$(NAME_DEBUG_VAL)\" ]; then \
				echo -e '[$(LOG_TIME)]$(RED)[$(PROJECT)]	[DOCK-ERROR]	Debug executable not found. Something went wrong during compilation...$(RST)'; \
				exit 1; \
			fi; \
			echo -e '[$(LOG_TIME)]$(CYNB)[$(PROJECT)]	[DOCK-INFO]	Valgrind build successfully compiled in docker container!$(RST)' && \
			echo -e '[$(LOG_TIME)]$(CYNB)[$(PROJECT)]	[DOCK-RUN]	Running Valgrind analysis in docker container...$(RST)' && \
			echo -e '-----------------------------------------' && \
			valgrind $(VALGRIND_FLAGS) --log-file=\"$(VALGRIND_REPORT)\" \
			\"./$(NAME_DEBUG_VAL)\" \"$(ARGS)\" ; \
			echo -e '\n-----------------------------------------'; \
			mv -f \"$(NAME_DEBUG_VAL)\" \"./$(DEBUG_DIR)\" 2>/dev/null "

valgrind-container-start:
	@echo "[$(LOG_TIME)]$(BLU)[$(PROJECT)]	[VALGRIND]	Starting persistent Valgrind container...$(RST)"
	@if ! docker ps -a --format '{{.Names}}' | grep -q $(VALGRIND_PERS_CONT); then \
		echo "[$(LOG_TIME)]$(BLU)[$(PROJECT)]	[VALGRIND]	Creating [$(VALGRIND_PERS_CONT)] container...$(RST)"; \
		docker run -d --name $(VALGRIND_PERS_CONT) \
			-v $(CURDIR):/app \
			-w /app \
			$(VALGRIND_IMAGE_NAME) \
			sleep infinity \
			| xargs -I {} printf "[$(LOG_TIME)]$(BLU)[$(PROJECT)]	[DOCK-INFO]	[$(VALGRIND_PERS_CONT)] ID: {}$(RST)\n"; \
	elif ! docker ps --format '{{.Names}}' | grep -q $(VALGRIND_PERS_CONT); then \
		echo "[$(LOG_TIME)]$(BLU)[$(PROJECT)]	[VALGRIND]	Starting existing [$(VALGRIND_PERS_CONT)] container...$(RST)"; \
		docker start $(VALGRIND_PERS_CONT); \
	else \
		echo "[$(LOG_TIME)]$(BLU)[$(PROJECT)]	[VALGRIND]	Container [$(VALGRIND_PERS_CONT)] already running$(RST)"; \
	fi

valgrind-container-stop:
	@echo "[$(LOG_TIME)]$(BLU)[$(PROJECT)]	[DOCK-INFO]	Stopping [$(VALGRIND_PERS_CONT)] docker container...$(RST)"
	@if docker ps --format '{{.Names}}' | grep -q $(VALGRIND_PERS_CONT); then \
		docker stop valgrind-persistent 1>/dev/null && \
		echo "[$(LOG_TIME)]$(BLU)[$(PROJECT)]	[DOCK-INFO]	Container [$(VALGRIND_PERS_CONT)] successfully stopped!$(RST)"; \
	fi
	@if docker ps -a --format '{{.Names}}' | grep -q $(VALGRIND_PERS_CONT); then \
		docker rm $(VALGRIND_PERS_CONT) 1>/dev/null && \
		echo "[$(LOG_TIME)]$(BLU)[$(PROJECT)]	[DOCK-INFO]	Container [$(VALGRIND_PERS_CONT)] successfully removed!$(RST)"; \
	fi

build-docker_libs:
	@if [ -z "$(LIBS_CLEAN)" ]; then \
		echo "[$(LOG_TIME)]$(YLW)[$(PROJECT)]	[DOCK-INFO]	No libraries to build.$(RST)"; \
	else \
		echo "[$(LOG_TIME)]$(BLUB)[$(PROJECT)]	[DOCK-INFO]	Building docker libraries without relinking...$(RST)"; \
		for lib_dir in $(LIBS_DIRS); do \
			NAME=$$(basename "$$lib_dir")_docker.a; \
			$(MAKE) -C "$$lib_dir" NAME="$$NAME" 1>/dev/null 2>/dev/null; \
			LIB_FILE="$$lib_dir/$$NAME"; \
			if [ -f "$$LIB_FILE" ]; then \
				cp -f "$$LIB_FILE" "$(DOCKER_DIR)$$NAME"; \
			else \
				echo "[$(LOG_TIME)]$(RED)[$(PROJECT)]	[DOCK-ERROR]	Library $$NAME was not generated in $$lib_dir!$(RST)"; \
				exit 1; \
			fi; \
		done; \
		echo "[$(LOG_TIME)]$(GRN)[$(PROJECT)]	[DOCK-SUCCESS]	All docker_libraries built and copied to $(DOCKER_DIR) $(RST)"; \
	fi

# Memory allocation and access errors
VALGRIND_MEM_ACCESS	= "Invalid read" "Invalid write" "Jump to the invalid address" \
					  "Address .* is .* bytes after a block of size" "Address .* is .* bytes before a block of size" \
					  ".* bytes in .* blocks are definitely lost"

# Memory management errors
VALGRIND_MEM_MGMT	= "Invalid free" "Mismatched free" "Invalid memory pool address"

# Uninitialized value errors
VALGRIND_UNINIT		= "Uninitialised value" "Use of uninitialised value" \
					  "Conditional jump or move depends on uninitialised value"

# Other errors
VALGRIND_OTHER		= "Source and destination overlap" "Syscall param" \
					  "Process terminating with non-zero status"

VALGRIND_ERRORS = $(VALGRIND_MEM_ACCESS) $(VALGRIND_MEM_MGMT) $(VALGRIND_UNINIT) $(VALGRIND_OTHER)

process-valgrind-report: #REPORT_PATH=$() full path needed es. ./valgrind_report.txt , standard one is debug/valgrind_report.txt
	@if [ ! -f "$(REPORT_PATH)" ]; then \
		echo "[$(LOG_TIME)]$(RED)[$(PROJECT)]	[VAL-ERROR]	Valgrind report not found at $(REPORT_PATH).$(RST)"; \
		exit 1; \
	fi; \
	echo "[$(LOG_TIME)]$(BLU)[$(PROJECT)]	[VAL-INFO]	Processing memory analysis results...$(RST)"; \
	if grep -q "ERROR SUMMARY: [1-9]" "$(REPORT_PATH)"; then \
		error_count=$$(grep "ERROR SUMMARY" "$(REPORT_PATH)" | awk '{print $$4}'); \
		echo "[$(LOG_TIME)]$(REDB)[$(PROJECT)]	[VAL-ERROR]	$$error_count memory errors detected$(RST)"; \
		\
		for error in $(VALGRIND_ERRORS); do \
			if grep -q "$$error" "$(REPORT_PATH)"; then \
				display_error=$$(echo "$$error" | sed 's/"//g'); \
				echo "[$(LOG_TIME)]$(RED)[$(PROJECT)]	[VAL-ERROR]	$$display_error detected:$(RST)"; \
				\
				error_line=$$(grep -n "$$error" "$(REPORT_PATH)" | head -1 | cut -d: -f1); \
				awk -v line=$$error_line -v err="$$error" ' \
					BEGIN { found=0; printed=0; } \
					NR >= line { \
						if ($$0 ~ err && found == 0) { \
							found=1; \
							print; \
							printed++; \
						} else if (found == 1) { \
							if ($$0 ~ /^==.*== $$/) { \
								exit; \
							} \
							print; \
							printed++; \
							if (printed >= 20) exit; \
						} \
					}' "$(REPORT_PATH)"; \
				\
				count=$$(grep -c "$$error" "$(REPORT_PATH)"); \
				if [ "$$count" -gt 1 ]; then \
					echo "[$(LOG_TIME)]$(YLW)[$(PROJECT)]	[INFO]	... ($$count total occurrences of this error type) ...$(RST)"; \
				fi; \
			fi; \
		done; \
	else \
		echo "[$(LOG_TIME)]$(GRNB)[$(PROJECT)]	[VAL-SUCCESS]	No memory errors detected.$(RST)"; \
	fi; \
	if grep -q "LEAK SUMMARY:" "$(REPORT_PATH)"; then \
		echo "[$(LOG_TIME)]$(REDB)[$(PROJECT)]	[VAL-ERROR]	Memory leaks detected:$(RST)"; \
		echo "[$(LOG_TIME)]$(BLU)[$(PROJECT)]	[VAL-INFO]	Memory leak summary:$(RST)"; \
		grep -A 5 "LEAK SUMMARY" "$(REPORT_PATH)"; \
	else \
		echo "[$(LOG_TIME)]$(GRNB)[$(PROJECT)]	[VAL-SUCCESS]	No memory leaks detected.$(RST)"; \
	fi; \
	echo "[$(LOG_TIME)]$(YLWB)[$(PROJECT)]	[WARNING]	Always double-check $(VALGRIND_REPORT) available in: $(DEBUG_DIR)$(VALGRIND_REPORT)$(RST)";

re-valgrind:
	@echo "[$(LOG_TIME)]$(BLU)[$(PROJECT)]	[INFO]		Rebuilding valgrind version from scratch$(RST)"
ifeq ($(IS_LINUX),Linux)
	$(RM) $(OBJS_DEBUG_DIR)
else
	$(RM) $(OBJS_DOCKER_DIR)
endif
	$(RM) $(NAME_DEBUG_VAL_PATH) $(REPORT_PATH)
	$(MAKE) fclean-deep
	$(MAKE) valgrind


# Help command
help:
	@echo ""
	@echo "$(BLU)Configuration:$(RST)"
	@echo "  Compiler:		$(YLW)$(CC)$(RST)"
	@echo "  Flags:		$(YLW)$(CFLAGS)$(RST)"
	@echo "  Debug Flags:		$(YLW)$(DEBUG_FLAGS)$(RST)"
	@echo "  Valgrind Flags	$(YLW)$(VALGRIND_FLAGS)$(RST)"
	@echo ""
	@echo "$(BLU)Compile & debug info:$(RST)"
	@echo "  Address Sanitizer:	$(ASAN_CHECK)"
	@echo "  Sources:		$(words $(SRCS)) files"
	@echo "  Objects:		$(words $(OBJS)) files"
	@echo "  Debug Objects:	$(words $(OBJS_DEBUG)) files\n"
	@echo "  Sources:		$(SRCS)\n"
	@echo "  Objects:		$(OBJS)\n"
	@echo "  Debug Objects:	$(OBJS_DEBUG)\n"
	@echo "  Private libraries:		$(LIBS_PRIVATE)"
	@echo "  Submodule libraries:	$(LIBS_SUBMODULE)"
	@echo "  External libraries:	$(LIBS_EXTERNAL)"
	@echo ""
	@echo "$(BLUB)+- Available Commands -----------------+ $(RST)"
	@echo ""
	@echo "$(BLU)Main Commands: $(RST)"
	@echo "  $(GRN)make all$(RST)					-  $(WHT)Build the project (default)$(RST)"
	@echo "  $(GRN)make test$(RST)					-  $(WHT)Build the project and links it with TEST_FILES to make an exe$(RST)"
	@echo "  $(GRN)make validate_env$(RST)				-  $(WHT)Checks if directory environment is set up$(RST)"
	@echo "  $(GRN)make update_submodules$(RST)			-  $(WHT)Initialize and update all submodules$(RST)"
	@echo "  $(GRN)make clone_repos$(RST)				-  $(WHT)Clone necessary repositories for local libraries$(RST)"
	@echo "  $(GRN)make build-libs$(RST)				-  $(WHT)Build all dependent libraries$(RST)"
	@echo "  $(GRN)make re-build-libs$(RST)				-  $(WHT)Rebuild all dependent libraries$(RST)"
	@echo "  $(GRN)make re$(RST)					-  $(WHT)Rebuild current project from scratch$(RST)"
	@echo "  $(RED)make clean$(RST)					-  $(WHT)Remove object files$(RST)"
	@echo "  $(RED)make fclean$(RST)					-  $(WHT)Remove all generated files$(RST)"
	@echo "  $(GRN)make re-deep$(RST)					-  $(WHT)Rebuild all libraries and project from scratch$(RST)"
	@echo "  $(RED)make clean-deep$(RST)				-  $(WHT)Clean all libraries and project objects$(RST)"
	@echo "  $(RED)make fclean-deep$(RST)				-  $(WHT)Full clean of all libraries and project$(RST)"
	@echo ""
	@echo "$(BLU)Debug Commands: $(RST)"
	@echo "  $(CYN)make debug$(RST)					-  $(WHT)Builds executable (linking test files) with sanitizers (if supported) and debug flags for leak and error detection$(RST)"
	@echo "  $(CYN)make debug-build_archive$(RST)			-  $(WHT)Builds archive with sanitizers (if supported) and debug flags for leak and error detection$(RST)"
	@echo "  $(CYN)make debug-run$(RST)				-  $(WHT)Run the program with sanitizers$(RST)"
	@echo "  $(CYN)make leak-check$(RST)				-  $(WHT)Memory leak detection with AddressSanitizer$(RST)"
	@echo "  $(CYN)make debug-gdb$(RST)				-  $(WHT)Build and debug with GDB$(RST)"
	@echo "  $(GRN)make re-debug$(RST)					-  $(WHT)Rebuild current debug version from scratch$(RST)"
	@echo "  $(RED)make clean-debug$(RST)				-  $(WHT)Remove debug objects$(RST)"
	@echo "  $(RED)make fclean-debug$(RST)				-  $(WHT)Remove all generated debug files$(RST)"
	@echo "  $(CYN)make debug-makeflags$(RST)				-  $(WHT)Display make flags information$(RST)"
	@echo ""
	@echo "$(BLU)Valgrind Commands: $(RST)"
	@echo "  $(CYN)make valgrind$(RST)					-  $(WHT)Auto-selects best Valgrind method for your platform (default)$(RST)"
	@echo "  $(CYN)make valgrind-native$(RST)				-  $(WHT)Run Valgrind natively (Linux only)$(RST)"
	@echo "  $(CYN)make valgrind-docker$(RST)				-  $(WHT)Run Valgrind via Docker (any platform)$(RST)"
	@echo "  $(CYN)make valgrind-docker_sleep$(RST)			-  $(WHT)Run Valgrind in persistent Docker container$(RST)"
	@echo "  $(CYN)make valgrind-container-start$(RST)			-  $(WHT)Start persistent Valgrind container$(RST)"
	@echo "  $(CYN)make valgrind-container-stop$(RST)			-  $(WHT)Stop and remove persistent Valgrind container$(RST)"
	@echo "  $(CYN)make process-valgrind-report$(RST)			-  $(WHT)Process and display Valgrind report$(RST)"
	@echo "  $(GRN)make re-valgrind$(RST)				-  $(WHT)Rebuild and run Valgrind from scratch$(RST)"
	@echo "  $(CYN)make build-libs_docker$(RST)			-  $(WHT)Build libraries from Docker environment (Linux)$(RST)"
	@echo ""
	@echo "$(BLU)Options: $(RST)"
	@echo "  Add $(MAG)VERBOSE=1$(RST)					-  $(WHT)For detailed output$(RST)"
	@echo "  Add $(MAG)DETAILS=1$(RST)					-  $(WHT)For detailed files compilation$(RST)"
	@echo "  Add $(MAG)DEBUG=1$(RST)					-  $(WHT)For debug mode -> Use #ifdef DEBUG ... #endif for debugging inside src$(RST)"
	@echo "  Add $(MAG)SLEEP=1$(RST)					-  $(WHT)For Docker valgrind in persistent container. Remember to run make valgrind-container-stop when needed$(RST)"
	@echo "  Add $(MAG)ARGS=\"...\"$(RST)				-  $(WHT)To pass arguments to valgrind tests. For multiple arguments use: ARGS='\"...\" \"...\"'$(RST)"
	@echo ""
	@echo "$(BLUB)+--------------------------------------+ $(RST)"

.PHONY: all clean fclean re validate_env update_submodules clone_repos build-libs re-build-libs \
	clean-deep fclean-deep re-deep \
	debug debug-build_archive debug-build debug-build_no_asan debug-run leak-check debug-gdb clean-debug fclean-debug re-debug debug-makeflags \
	valgrind valgrind-native valgrind-docker valgrind-docker-setup valgrind-docker_sleep \
	valgrind-container-start valgrind-container-stop build-libs_docker process-valgrind-report re-valgrind \
	help
