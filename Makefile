ERL_INCLUDE_PATH=$(shell erl -eval 'io:format("~s", [lists:concat([code:root_dir(), "/erts-", erlang:system_info(version), "/include"])])' -s init stop -noshell)

all: priv/exec.so

priv/exec.so: c_src/exec.c
	cc -fPIC -I$(ERL_INCLUDE_PATH) -dynamiclib -undefined dynamic_lookup -o priv/exec.so c_src/exec.c
