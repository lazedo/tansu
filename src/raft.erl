%% Copyright (c) 2016 Peter Morgan <peter.james.morgan@gmail.com>
%%
%% Licensed under the Apache License, Version 2.0 (the "License");
%% you may not use this file except in compliance with the License.
%% You may obtain a copy of the License at
%%
%% http://www.apache.org/licenses/LICENSE-2.0
%%
%% Unless required by applicable law or agreed to in writing, software
%% distributed under the License is distributed on an "AS IS" BASIS,
%% WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
%% See the License for the specific language governing permissions and
%% limitations under the License.

-module(raft).

-export([start/0]).
-export([trace/1]).
-export([vsn/0]).

start() ->
    application:ensure_all_started(?MODULE).

ensure_loaded() ->
    lists:foreach(fun code:ensure_loaded/1, modules()).

modules() ->
    modules(?MODULE) ++ modules(mnesia).

modules(Application) ->
    {ok, Modules} = application:get_key(Application, modules),
    Modules.


trace(true) ->
    ensure_loaded(),
    case recon_trace:calls([m(Module) || Module <- modules()],
                           [{scope, local},
                            {pid, all}]) of
        Matches when Matches > 0 ->
            ok;
        _ ->
            error
    end;
trace(false) ->
    recon_trace:clear().

m(Module) ->
    {Module, '_', '_'}.

vsn() ->
    {ok, VSN} = application:get_key(?MODULE, vsn),
    VSN.
