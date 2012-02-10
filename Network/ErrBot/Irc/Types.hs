{-# OverloadedStrings #-}

-- This provides the basic algebraic data types for working with IRC messages.
-- This data type is the core of ErrBot. Basically, as soon as data comes in
-- from IRC, it gets parsed to this data type. The stream of input data get
-- processed, filtered, and transformed, and finally when everything has been
-- sliced, diced, and hashed, they're written back to IRC, maybe.

module Network.ErrBot.Irc.Types
    ( Nick
    , NickList
    , Username
    , Host
    , Server
    , RealName
    , MessageText
    , Channel
    , ChannelList
    , Recipient
    , RecipientList
    , IrcInput(..)
    , ErrorType(..)
    , Replies(..)
    , errorCodes
    ) where


-- For performance, we'll keep most of the data in ByteStrings.
import qualified Data.ByteString as B
import qualified Data.Map as M


-- Some type aliases to make things easier.
type Nick        = B.ByteString
type NickList    = [Nick]
type Username    = B.ByteString
type Host        = B.ByteString
type Server      = B.ByteString
type RealName    = B.ByteString
type MessageTest = B.ByteString
type Channel     = B.ByteString
type ChannelList = [Channel]

-- This is the data type for any kind of message recipient.
type Recipient = Either Nick Channel
type RecipientList = [Recipient] 

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

-- This is the algebraic data type describing everything that goes into and out
-- of IRC.
data IrcInput
    = IrcNick Nick
    | IrcUser Username Host Server RealName
    | IrcQuit MessageText
    | IrcJoin ChannelList
    | IrcTopic Channel (Maybe MessageText)
    | IrcNames Channel
    | IrcPrivMsg RecipientList MessageText
    | IrcPing Server
    | IrcPong (Maybe Server)
    | IrcIsOn NickList
    | IrcError ErrorType MessageText

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

-- These are the errors.
data ErrorType
    = AlreadyRegistered
    | BadChanMask
    | BadChannelKey
    | BannedFromChan
    | CannotSendToChan
    | ChannelIsFull
    | ChanOPrivsNeeded
    | ErroneusNickname
    | InviteOnlyChan
    | NeedMoreParams
    | NickCollision
    | NickNameInUse
    | NoNickNameGiven
    | NoOrigin
    | NoRecipient
    | NoSuchChannel
    | NoSuchNick
    | NoSuchServer
    | NoTextToSend
    | NotOnChannel
    | NoTopLevel
    | TooManyChannels
    | TooManyTargets
    | UnknownCommand
    | WildTopLevel

errorCodes :: M.Map Int ErrorType
errorCodes = M.fromList
  [ (462, AlreadyRegistered)
  , (476, BadChanMask)
  , (475, BadChannelKey)
  , (474, BannedFromChan)
  , (404, CannotSendToChan)
  , (471, ChannelIsFull)
  , (482, ChanOPrivsNeeded)
  , (432, ErroneusNickname)
  , (473, InviteOnlyChan)
  , (461, NeedMoreParams)
  , (436, NickCollision)
  , (433, NicknameInUse)
  , (431, NoNicknameGiven)
  , (409, NoOrigin)
  , (411, NoRecipient)
  , (403, NoSuchChannel)
  , (401, NoSuchNick)
  , (402, NoSuchServer)
  , (412, NoTextToSend)
  , (442, NotOnChannel)
  , (413, NoTopLevel)
  , (405, TooManyChannels)
  , (407, TooManyTargets)
  , (421, UnknownCommand)
  , (414, WildTopLevel)
  ]

-- # Replies
--
-- * RPL_AWAY       -- 301
-- * RPL_ENDOFNAMES -- 366
-- * RPL_ISON       -- 303
-- * RPL_NAMREPLY   -- 353
-- * RPL_NOTOPIC    -- 331
-- * RPL_TOPIC      -- 332
--

