%%======================================================================
%%
%% Leo Transaction Manager
%%
%% Copyright (c) 2012-2017 Rakuten, Inc.
%%
%% This file is provided to you under the Apache License,
%% Version 2.0 (the "License"); you may not use this file
%% except in compliance with the License.  You may obtain
%% a copy of the License at
%%
%%   http://www.apache.org/licenses/LICENSE-2.0
%%
%% Unless required by applicable law or agreed to in writing,
%% software distributed under the License is distributed on an
%% "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
%% KIND, either express or implied.  See the License for the
%% specific language governing permissions and limitations
%% under the License.
%%
%%======================================================================
-module(leo_tran).

-include("leo_tran.hrl").
-include_lib("eunit/include/eunit.hrl").

%% Application callbacks
-export([run/5, run/6,
         state/3,
         all_states/0,
         wait/3, notify_all/3
        ]).

%% ===================================================================
%% API
%% ===================================================================
%% @doc Execute a taransaction
%%
-spec(run(Tbl, Key, Method, Callback, UserContext) ->
             ok | {error, any()} when Tbl::atom(),
                                      Key::any(),
                                      Method::atom(),
                                      UserContext::any(),
                                      Callback::module()).
run(Tbl, Key, Method, Callback, UserContext) ->
    run(Tbl, Key, Method, Callback, UserContext, []).

-spec(run(Tbl, Key, Method, Callback, UserContext, Options) ->
             ok | {error, any()} when Tbl::atom(),
                                      Key::any(),
                                      Method::atom(),
                                      Callback::module(),
                                      UserContext::any(),
                                      Options::[{tran_prop(), integer()|boolean()}]).
run(Tbl, Key, Method, Callback, UserContext, Options) ->
    leo_tran_serializable_cntnr:run(Tbl, Key, Method, Callback, UserContext, Options).


%% @doc Retrieve state of the transaction
%%
-spec(state(Tbl, Key, Method) ->
             {ok, State} | {error, any()} when Tbl::atom(),
                                               Key::any(),
                                               Method::atom(),
                                               State::running | not_running).
state(Tbl, Key, Method) ->
    leo_tran_serializable_cntnr:state(Tbl, Key, Method).


%% @doc Retrieve all state of the transactions
%%
-spec(all_states() ->
             {ok, [{Table, Key, State}]} |
             {error, any()} when Table::atom(),
                                 Key::any(),
                                 State::running | not_running).
all_states() ->
    leo_tran_serializable_cntnr:all_states().


%% @doc Block the caller process until notify_all/3 is called from another process
%%
-spec(wait(Table, Key, Method) ->
             ok | {error, any()} when Table::atom(),
                                      Key::any(),
                                      Method::atom()).
wait(Table, Key, Method) ->
    leo_tran_concurrent_cntnr:wait(Table, Key, Method).


%% @doc Resume all blocked processes invoking wait/3
%%
-spec(notify_all(Table, Key, Method) ->
             ok | {error, any()} when Table::atom(),
                                      Key::any(),
                                      Method::atom()).
notify_all(Table, Key, Method) ->
    leo_tran_concurrent_cntnr:notify_all(Table, Key, Method).
