#include "erl_nif.h"

#include<errno.h>
#include<stdbool.h>
#include<stdio.h>
#include<string.h>
#include<sys/types.h>
#include<termios.h>
#include<unistd.h>

static int
load(ErlNifEnv* env, void** priv, ERL_NIF_TERM load_info)
{
    return 0;
}

static ERL_NIF_TERM
error(ErlNifEnv* env, char* reason)
{
    ERL_NIF_TERM error_atom = enif_make_atom_len(env, "error", 5);
    ERL_NIF_TERM reason_atom = enif_make_atom_len(env, reason, strlen(reason));
    return enif_make_tuple2(env, error_atom, reason_atom);
}

static ERL_NIF_TERM
error_errno(ErlNifEnv* env)
{
    ERL_NIF_TERM error_atom = enif_make_atom_len(env, "error", 5);
    ERL_NIF_TERM reason_string = enif_make_string(env, strerror(errno), ERL_NIF_LATIN1);
    return enif_make_tuple2(env, error_atom, reason_string);
}

#define MAX_STTYOPTS 65536

static bool
fix_tty(ErlNifEnv* env, ERL_NIF_TERM erl_stty_opts)
{
    char stty_command[MAX_STTYOPTS] = "/bin/stty ";
    if(enif_get_string(env, erl_stty_opts, stty_command + strlen(stty_command), MAX_STTYOPTS - strlen(stty_command), ERL_NIF_LATIN1) <= 0)
        return false;
    if(system(stty_command))
        return false;
    return true;
}

static void
free_exec_argv(char ** exec_argv, int argc)
{
    for(int i = 0; i < argc; i++) {
        if(exec_argv[i]) enif_free(exec_argv[i]);
    }
    enif_free(exec_argv);
}

static ERL_NIF_TERM
exec_nif(ErlNifEnv* env, int argc, const ERL_NIF_TERM argv[])
{
    if(argc != 2)
        return enif_make_badarg(env);

    ERL_NIF_TERM erl_exec_argv = argv[0];
    ERL_NIF_TERM erl_stty_opts = argv[1];

    unsigned exec_argv_len = 0;

    if(!enif_get_list_length(env, erl_exec_argv, &exec_argv_len))
        return error(env, "args_not_a_list");

    if(exec_argv_len < 1)
        return error(env, "empty_arg_list");

    char **exec_argv = (char **)enif_alloc(exec_argv_len + 1);
    if(!exec_argv)
        return error(env, "alloc_failed");
    for(int i = 0; i < exec_argv_len + 1; i++) {
        exec_argv[i] = 0;
    }

    ERL_NIF_TERM head;
    ERL_NIF_TERM tail;

    for(int i = 0; i < exec_argv_len; i++) {
        enif_get_list_cell(env, erl_exec_argv, &head, &tail);
        ERL_NIF_TERM erl_exec_arg = head;
        unsigned arg_len = 0;
        if(!enif_get_list_length(env, erl_exec_arg, &arg_len)) {
            free_exec_argv(exec_argv, exec_argv_len);
            return error(env, "args_not_a_list_of_strings");
        }
        exec_argv[i] = (char*)enif_alloc(arg_len + 1);
        if(!exec_argv[i]) {
            free_exec_argv(exec_argv, exec_argv_len);
            return error(env, "alloc_failed");
        }
        if(enif_get_string(env, erl_exec_arg, exec_argv[i], arg_len + 1, ERL_NIF_LATIN1) <= 0) {
            free_exec_argv(exec_argv, exec_argv_len);
            return error(env, "args_not_a_list_of_strings");
        }
        erl_exec_argv = tail;
    }

    struct termios old_termios;

    if(tcgetattr(STDIN_FILENO, &old_termios))
        return error(env, "tcgetattr_failed");

    if(!fix_tty(env, erl_stty_opts))
        return error(env, "stty_failed");

    if(execv(exec_argv[0], exec_argv) < 0) {
        free_exec_argv(exec_argv, exec_argv_len);
        tcsetattr(STDIN_FILENO, TCSANOW, &old_termios);
        return error_errno(env);
    }
    // should never happen
    return error(env, "exec_failed");
}

static ErlNifFunc nif_funcs[] = {
    {"do_exec", 2, exec_nif}
};


ERL_NIF_INIT(Elixir.Execv, nif_funcs, &load, NULL, NULL, NULL);

