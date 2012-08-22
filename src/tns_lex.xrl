Definitions.

Rules.

% Names

(DESCRIPTION|description)       :   {token, {'DESCRIPTION', TokenLine}}.
(LOAD_BALANCE|load_balance)     :   {token, {'LOAD_BALANCE', TokenLine}}.
(FAILOVER|failover)             :   {token, {'FAILOVER', TokenLine}}.
(ADDRESS|address)               :   {token, {'ADDRESS', TokenLine}}.
(PROTOCOL|protocol)             :   {token, {'PROTOCOL', TokenLine}}.
(HOST|Host|host)                :   {token, {'HOST', TokenLine}}.
(PORT|Port|port)                :   {token, {'PORT', TokenLine}}.
(CONNECT_DATA|connect_data)     :   {token, {'CONNECT_DATA', TokenLine}}.
(SID|sid)                       :   {token, {'SID', TokenLine}}.
(SRVR|srvr)                     :   {token, {'SRVR', TokenLine}}.
(SERVER|server)                 :   {token, {'SERVER', TokenLine}}.
(SERVICE_NAME|service_name)     :   {token, {'SERVICE_NAME', TokenLine}}.
(ENABLE|enable)                 :   {token, {'ENABLE', TokenLine}}.

% Constant Values
(TCP|BROKEN|DEDICATED|ON|OFF)   :   {token, {'VAL', TokenLine, list_to_binary(TokenChars)}}.

% Other Values
([\s\t\r\n]+)                   :   skip_token.	% white space
[A-Za-z][A-Za-z0-9_\.]*         :   {token, {'VAL', TokenLen, list_to_binary(TokenChars)}}.
(=|\(|\))                       :   {token, {list_to_atom(TokenChars), TokenLine}}.

Erlang code.

