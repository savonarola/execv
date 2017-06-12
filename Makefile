ERL_INCLUDE_PATH=$(shell erl -eval 'io:format("~s", [lists:concat([code:root_dir(), "/erts-", erlang:system_info(version), "/include"])])' -s init stop -noshell)

FLAGS=

UNAME=$(shell uname)

ifeq ($(UNAME),Linux)
	FLAGS += -std=c99 -shared
endif

ifeq ($(UNAME),Darwin)
	FLAGS += -dynamiclib -undefined dynamic_lookup
endif

all: priv/exec.so

priv/exec.so: c_src/exec.c
	mkdir -p priv
	cc -fPIC -I$(ERL_INCLUDE_PATH) $(FLAGS) -o priv/exec.so c_src/exec.c
