Header "%% Copyright (C) K2 Informatics GmbH"
"%% @private"
"%% @Author Bikram Chatterjee"
"%% @Email bikram.chatterjee@k2informatics.ch".

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

Nonterminals
 descriptions description_list description
 tns_names tns
 opt_connection
.

Terminals
 VAL 'DESCRIPTION' 'LOAD_BALANCE' 'FAILOVER' 'ADDRESS' 'PROTOCOL' 'HOST' 'GLOBAL_NAME'
 'PORT' 'CONNECT_DATA' 'SID' 'SRVR' 'SERVER' 'SERVICE_NAME' 'ENABLE'
 '(' ')' '='
.

Rootsymbol tns_names.


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


tns_names -> tns                                    : ['$1'].
tns_names -> tns_names tns                          : '$1' ++ ['$2'].

tns -> VAL '=' '(' descriptions ')'                 : {srv, unwrap('$1'), '$4'}.

descriptions -> description_list opt_connection     : {'$1', '$2'}.

description_list -> '$empty'                        : [].
description_list -> description                     : ['$1'].
description_list -> description_list description    : '$1' ++ ['$2'].

opt_connection -> '$empty'                          : {connect_data, []}.
opt_connection -> '(' 'CONNECT_DATA' '=' '(' 'SID' '=' VAL ')' '(' 'GLOBAL_NAME' '=' VAL ')' ')' :  {connect_data, [{sid, '$7'}, {global_name, '$12'}]}.

description -> 'DESCRIPTION'                        : [].

%service_name -> (DESCRIPTION_LIST=
%    (DESCRIPTION=(ADDRESS_LIST=(ADDRESS=address)
%                  (ADDRESS=address))
%                   (CONNECT_DATA=(SID=sid)
%                       (GLOBAL_NAME=global_dbname)))
%    (DESCRIPTION=(ADDRESS_LIST=(ADDRESS=address)
%                   	(ADDRESS=address))
%			      (CONNECT_DATA=(SID=sid)
%					(GLOBAL_NAME=global_dbname)))
%    [(CONNECT_DATA =(SID=sid)(GLOBAL_NAME=global_dbname))])

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

Erlang code.

-include_lib("eunit/include/eunit.hrl").

unwrap({_,_,X}) -> X.
unwrap_bin({_,_,X}) -> list_to_binary(X).

%%-define(REG_COL, [
%%    {"([\n\r\t ]+)",                              " "}    % \r,\n or spaces               -> single space
%%  , {"(^[ ]+)|([ ]+$)",                           ""}     % leading or trailing spaces    -> removed
%%  , {"([ ]*)([\(\),])([ ]*)",                     "\\2"}  % spaces before or after ( or ) -> removed
%%  , {"([ ]*)([\\/\\*\\+\\-\\=\\<\\>]+)([ ]*)",    "\\2"}  % spaces around math operators  -> removed
%%% , {"([\)])([ ]*)",                              "\\1 "} % no space after )              -> added one space
%%]).
%%
%%-define(REG_CR, [
%%    {"(\r)",                 		""}     % all carriage returns		-> removed
%%]).
%%
%%-define(REG_NL, [
%%    {"(^[\r\n]+)",             		""}     % leading newline    		-> removed
%%  , {"([\r\n]+$)",             		""}     % trailing newline    		-> removed
%%]).
%%
%%str_diff([], [])                                            -> same;
%%str_diff(String1, []) when length(String1) > 0              -> {String1, ""};
%%str_diff([], String2) when length(String2) > 0              -> {"", String2};
%%str_diff([S0|_] = String1, [S1|_] = String2) when S0 =/= S1 -> {String1, String2};
%%str_diff([_|String1], [_|String2])                          -> str_diff(String1, String2).
%%
%%collapse(Sql) ->
%%    lists:foldl(
%%        fun({Re,R}, S) -> re:replace(S, Re, R, [{return, list}, global]) end,
%%        Sql,
%%        ?REG_COL).
%%
%%clean_cr(Sql) ->
%%    lists:foldl(
%%        fun({Re,R}, S) -> re:replace(S, Re, R, [{return, list}, global]) end,
%%        Sql,
%%        ?REG_CR).
%%
%%trim_nl(Sql) ->
%%    lists:foldl(
%%        fun({Re,R}, S) -> re:replace(S, Re, R, [{return, list}, global]) end,
%%        Sql,
%%        ?REG_NL).
%%
%%%remove_eva(S) ->
%%%	re:replace(S, "([ \t]eva[ \t])", "\t\t", [global, {return, list}]).
%%
%%
%%
%%parse_test() ->
%%    io:format(user, "===============================~n", []),
%%    io:format(user, "|    S Q L   P A R S I N G    |~n", []),
%%    io:format(user, "===============================~n", []),
%%    test_parse(?TEST_SQLS, 0).
%%test_parse([], _) -> ok;
%%test_parse([Sql|Sqls], N) ->
%%    io:format(user, "[~p]===============================~nSql: "++Sql++"~n", [N]),
%%    io:format(user, "Sql collapsed:~n~p~n", [collapse(Sql)]),
%%    case (catch sql_lex:string(Sql ++ ";")) of
%%        {ok, Tokens, _} ->
%%            case (catch sql_parse:parse(Tokens)) of
%%                {ok, [ParseTree|_]} -> 
%%                	io:format(user, "-------------------------------~nParseTree:~n", []),
%%                	io:format(user, "~p~n", [ParseTree]),
%%                	io:format(user, "-------------------------------~n", []);
%%                {'EXIT', Error} ->
%%                    io:format(user, "Failed ~p~nTokens~p~n", [Error, Tokens]),
%%                    ?assertEqual(ok, Error);
%%                Error ->
%%                    io:format(user, "Failed ~p~nTokens~p~n", [Error, Tokens]),
%%                    ?assertEqual(ok, Error)
%%            end;
%%        {'EXIT', Error} ->
%%            io:format(user, "Failed ~p~n", [Error]),
%%            ?assertEqual(ok, Error)
%%    end,
%%    test_parse(Sqls, N+1).


%%% -- # TNSNAMES.ORA Network Configuration File: C:\oracle\ora92\network\admin\tnsnames.ora
%%% -- # Generated by Oracle configuration tools.
%%% -- 
%%% -- LTT1.TEST = 
%%% --   (DESCRIPTION = 
%%% --      (LOAD_BALANCE = ON) 
%%% --      (FAILOVER = ON)
%%% --      (ADDRESS = (PROTOCOL = TCP)(HOST = 10.132.7.7)(PORT = 1521)
%%% --      )
%%% --      (CONNECT_DATA = 
%%% --         (SID = LTT1)
%%% --         (SRVR = DEDICATED)
%%% --      )
%%% --   )
%%% -- 
%%% -- SIS_T1.WORLD =
%%% --   (DESCRIPTION =
%%% --      (LOAD_BALANCE = ON)
%%% --      (FAILOVER = ON)
%%% --      (ADDRESS = (PROTOCOL = TCP)(HOST = 10.132.17.60)(PORT = 1521))
%%% --      (CONNECT_DATA =
%%% --         (SID = SIS1)
%%% --         (SRVR = DEDICATED)
%%% --      )
%%% --   )
%%% -- 
%%% -- SIS_T2.WORLD =
%%% --   (DESCRIPTION =
%%% --      (LOAD_BALANCE = ON)
%%% --      (FAILOVER = ON)
%%% --      (ADDRESS = (PROTOCOL = TCP)(HOST = 10.132.17.61)(PORT = 1521))
%%% --      (CONNECT_DATA =
%%% --         (SID = SIS2)
%%% --         (SRVR = DEDICATED)
%%% --      )
%%% --   )
%%% -- 
%%% -- SIS_T3.WORLD =
%%% --   (DESCRIPTION =
%%% --      (LOAD_BALANCE = ON)
%%% --      (FAILOVER = ON)
%%% --      (ADDRESS = (PROTOCOL = TCP)(HOST = 10.132.17.54)(PORT = 1521))
%%% --      (CONNECT_DATA =
%%% --         (SID = SIS3)
%%% --         (SRVR = DEDICATED)
%%% --      )
%%% --   )
%%% -- 
%%% -- SIS_P1.WORLD =
%%% --   (DESCRIPTION =
%%% --      (LOAD_BALANCE = ON)
%%% --      (FAILOVER = ON)
%%% --      (ADDRESS = (PROTOCOL = TCP)(HOST = 10.132.9.27)(PORT = 1521))
%%% --      (CONNECT_DATA =
%%% --         (SID = SIS)
%%% --         (SRVR = DEDICATED)
%%% --      )
%%% --   )
%%% -- 
%%% -- SIS_P2.WORLD =
%%% --   (DESCRIPTION =
%%% --      (LOAD_BALANCE = ON)
%%% --      (FAILOVER = ON)
%%% --      (ADDRESS = (PROTOCOL = TCP)(HOST = 10.132.9.32)(PORT = 1521))
%%% --      (CONNECT_DATA =
%%% --         (SID = SIS)
%%% --         (SRVR = DEDICATED)
%%% --      )
%%% --   )
%%% -- 
%%% -- SIS_P3.WORLD =
%%% --   (DESCRIPTION =
%%% --      (LOAD_BALANCE = ON)
%%% --      (FAILOVER = ON)
%%% --      (ADDRESS = (PROTOCOL = TCP)(HOST = 10.132.17.53)(PORT = 1521))
%%% --      (CONNECT_DATA =
%%% --         (SID = SIS3)
%%% --         (SRVR = DEDICATED)
%%% --      )
%%% --   )
%%% --   
%%% -- SBS0.TEST =
%%% --   (DESCRIPTION =
%%% --     (ADDRESS_LIST =
%%% --       (ADDRESS = (PROTOCOL = TCP)(Host = 10.132.26.158)(Port = 3505))
%%% --     )
%%% --     (CONNECT_DATA =
%%% --       (SID = Sbs0)
%%% --     )
%%% --   )
%%% -- 
%%% -- SBS0.PROD =
%%% --   (DESCRIPTION =
%%% --     (ADDRESS_LIST =
%%% --       (ADDRESS = (PROTOCOL = TCP)(Host = 10.132.7.173)(Port = 3505))
%%% --     )
%%% --     (CONNECT_DATA =
%%% --       (SID = Sbs0)
%%% --     )
%%% --   )
%%% -- 
%%% -- 
%%% -- SBS0.STAG =
%%% --   (DESCRIPTION =
%%% --     (ENABLE=BROKEN)
%%% --     (ADDRESS_LIST =
%%% --       (ADDRESS = (PROTOCOL = TCP)(HOST = sdm1-scan.it.bwns.ch)(PORT = 1521))
%%% --       (ADDRESS = (PROTOCOL = TCP)(HOST = sdm2-scan.it.bwns.ch)(PORT = 1521))
%%% --     )
%%% --     (CONNECT_DATA =
%%% --       (SERVER = DEDICATED)
%%% --       (SERVICE_NAME = SBS0.STAG.PIOSCS)
%%% --     )
%%% --   )
%%% -- 
%%% -- SBS0.EXAPROD =
%%% --   (DESCRIPTION =
%%% --     (ENABLE=BROKEN)
%%% --     (ADDRESS_LIST =
%%% --       (ADDRESS = (PROTOCOL = TCP)(HOST = bdm1-scan.it.bwns.ch)(PORT = 1521))
%%% --       (ADDRESS = (PROTOCOL = TCP)(HOST = bdm2-scan.it.bwns.ch)(PORT = 1521))
%%% --     )
%%% --     (CONNECT_DATA =
%%% --       (SERVER = DEDICATED)
%%% --       (SERVICE_NAME = SBS0.EXAPROD.PIOSCS)
%%% --     )
%%% --   )
%%% -- 
%%% -- SBS1.TEST =
%%% --   (DESCRIPTION =
%%% --     (ADDRESS_LIST =
%%% --       (ADDRESS = (PROTOCOL = TCP)(Host = 10.132.26.159)(Port = 3520))
%%% --     )
%%% --     (CONNECT_DATA =
%%% --       (SID = Sbs1)
%%% --     )
%%% --   )
%%% -- 
%%% -- SBS1.PROD =
%%% --   (DESCRIPTION =
%%% --     (ADDRESS_LIST =
%%% --       (ADDRESS = (PROTOCOL = TCP)(Host = 10.132.7.174)(Port = 3520))
%%% --     )
%%% --     (CONNECT_DATA =
%%% --       (SID = Sbs1)
%%% --     )
%%% --   )
%%% -- 
%%% -- SBS1.STAG =
%%% --   (DESCRIPTION =
%%% --     (ADDRESS_LIST =
%%% --       (ADDRESS = (PROTOCOL = TCP)(HOST = sdm1-scan.it.bwns.ch)(PORT = 1521))
%%% --       (ADDRESS = (PROTOCOL = TCP)(HOST = sdm2-scan.it.bwns.ch)(PORT = 1521))
%%% --     )
%%% --     (CONNECT_DATA =
%%% --       (SERVICE_NAME = SBS1.STAG)
%%% --       (SERVER = DEDICATED)
%%% --     )
%%% --   )
%%% -- 
%%% -- SBS1.EXAPROD =
%%% --   (DESCRIPTION =
%%% --     (ENABLE=BROKEN)
%%% --     (ADDRESS_LIST =
%%% --       (ADDRESS = (PROTOCOL = TCP)(HOST = bdm1-scan.it.bwns.ch)(PORT = 1521))
%%% --       (ADDRESS = (PROTOCOL = TCP)(HOST = bdm2-scan.it.bwns.ch)(PORT = 1521))
%%% --     )
%%% --     (CONNECT_DATA =
%%% --       (SERVER = DEDICATED)
%%% --       (SERVICE_NAME = SBS1.EXAPROD.PIOSCS)
%%% --     )
%%% --   )
%%% -- 
%%% -- SBS2.TEST = 
%%% --   (DESCRIPTION = 
%%% --      (LOAD_BALANCE = ON)
%%% --      (FAILOVER = ON)
%%% --      (ADDRESS = (PROTOCOL = TCP)(HOST = 10.132.26.21)(PORT = 3560))
%%% --      (CONNECT_DATA = 
%%% --        (SID = SBS2)
%%% --        (SRVR = DEDICATED)
%%% --      )
%%% --   )
%%% -- 
%%% -- SBS2.PROD = 
%%% --   (DESCRIPTION = 
%%% --      (LOAD_BALANCE = ON) 
%%% --      (FAILOVER = ON)
%%% --      (ADDRESS = (PROTOCOL = TCP)(HOST = 10.132.7.98)(PORT = 3550)
%%% --      )
%%% --      (CONNECT_DATA = 
%%% --         (SID = SBS2)
%%% --         (SRVR = DEDICATED)
%%% --      )
%%% --   )
%%% -- 
%%% -- 
%%% -- SBS2.STAG =
%%% --   (DESCRIPTION =
%%% --     (ENABLE=BROKEN)
%%% --     (ADDRESS_LIST =
%%% --       (ADDRESS = (PROTOCOL = TCP)(HOST = sdm1-scan.it.bwns.ch)(PORT = 1521))
%%% --       (ADDRESS = (PROTOCOL = TCP)(HOST = sdm2-scan.it.bwns.ch)(PORT = 1521))
%%% --     )
%%% --     (CONNECT_DATA =
%%% --       (SERVER = DEDICATED)
%%% --       (SERVICE_NAME = SBS2.STAG.PIOSCS)
%%% --     )
%%% --   )
%%% -- 
%%% -- SBS2.EXAPROD =
%%% --   (DESCRIPTION =
%%% --     (ENABLE=BROKEN)
%%% --     (ADDRESS_LIST =
%%% --       (ADDRESS = (PROTOCOL = TCP)(HOST = bdm1-scan.it.bwns.ch)(PORT = 1521))
%%% --       (ADDRESS = (PROTOCOL = TCP)(HOST = bdm2-scan.it.bwns.ch)(PORT = 1521))
%%% --     )
%%% --     (CONNECT_DATA =
%%% --       (SERVER = DEDICATED)
%%% --       (SERVICE_NAME = SBS2.EXAPROD.PIOSCS)
%%% --     )
%%% --   )
%%% -- 
%%% -- 
