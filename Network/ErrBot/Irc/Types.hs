
-- This provides the basic algebraic data types for working with IRC messages.
-- This data type is the core of ErrBot. Basically, as soon as data comes in
-- from IRC, it gets parsed to this data type. The stream of input data get
-- processed, filtered, and transformed, and finally when everything has been
-- sliced, diced, and hashed, they're written back to IRC, maybe.

module Network.ErrBot.Irc.Types
    ( IrcInput(..)
    ) where

-- # Commands
--
-- From http://tools.ietf.org/html/rfc1459. These are just the ones I plan to
-- use.
--
-- * NICK <nickname> =>  ERR_NONICKNAMEGIVEN, ERR_ERRONEUSNICKNAME, ERR_NICKNAMEINUSE, ERR_NICKCOLLISION
-- * USER <username> <hostname> <servername> <realname> => ERR_NEEDMOREPARAMS, ERR_ALREADYREGISTRED
-- * QUIT <quitmessage>
-- * JOIN <channel>[,<channel>] => ERR_NEEDMOREPARAMS, ERR_BANNEDFROMCHAN, ERR_INVITEONLYCHAN, ERR_BADCHANNELKEY, ERR_CHANNELISFULL, ERR_BADCHANMASK, ERR_NOSUCHCHANNEL, ERR_TOOMANYCHANNELS, RPL_TOPIC
-- * TOPIC <channel> => ERR_NEEDMOREPARAMS, ERR_NOTONCHANNEL, RPL_NOTOPIC, RPL_TOPIC, ERR_CHANOPRIVSNEEDED
-- * NAMES <channel> => RPL_NAMREPLY, RPL_ENDOFNAMES
-- * PRIVMSG <receiver>[,<receiver>] <text> => ERR_NORECIPIENT, ERR_NOTEXTTOSEND, ERR_CANNOTSENDTOCHAN, ERR_NOTOPLEVEL, ERR_WILDTOPLEVEL, ERR_TOOMANYTARGETS, ERR_NOSUCHNICK, RPL_AWAY
-- * PONG => ERR_NOORIGIN, ERR_NOSUCHSERVER
-- * ISON <nick>[<space><nick>] => RPL_ISON, ERR_NEEDMOREPARAMS
--

-- # Errors
--
-- * ERR_ALREADYREGISTRED -- 462
-- * ERR_BADCHANMASK      -- 476
-- * ERR_BADCHANNELKEY    -- 475
-- * ERR_BANNEDFROMCHAN   -- 474
-- * ERR_CANNOTSENDTOCHAN -- 404
-- * ERR_CHANNELISFULL    -- 471
-- * ERR_CHANOPRIVSNEEDED -- 482
-- * ERR_ERRONEUSNICKNAME -- 432
-- * ERR_INVITEONLYCHAN   -- 473
-- * ERR_NEEDMOREPARAMS   -- 461
-- * ERR_NICKCOLLISION    -- 436
-- * ERR_NICKNAMEINUSE    -- 433
-- * ERR_NONICKNAMEGIVEN  -- 431
-- * ERR_NOORIGIN         -- 409
-- * ERR_NORECIPIENT      -- 411
-- * ERR_NOSUCHCHANNEL    -- 403
-- * ERR_NOSUCHNICK       -- 401
-- * ERR_NOSUCHSERVER     -- 402
-- * ERR_NOTEXTTOSEND     -- 412
-- * ERR_NOTONCHANNEL     -- 442
-- * ERR_NOTOPLEVEL       -- 413
-- * ERR_TOOMANYCHANNELS  -- 405
-- * ERR_TOOMANYTARGETS   -- 407
-- * ERR_UNKNOWNCOMMAND   -- 421
-- * ERR_WILDTOPLEVEL     -- 414
--

-- # Replies
--
-- * RPL_AWAY       -- 301
-- * RPL_ENDOFNAMES -- 366
-- * RPL_ISON       -- 303
-- * RPL_NAMREPLY   -- 353
-- * RPL_NOTOPIC    -- 331
-- * RPL_TOPIC      -- 332
--

