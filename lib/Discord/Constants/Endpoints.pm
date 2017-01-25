package Discord::Constants::Endpoints;

# This package renames Discord REST endpoints to human readable constants
# and to provide a quick way to access these by returning a string
# that is appendable to the API URL

use Discord::Loader;

use constant CHANNELS => "/channels";
use constant GUILDS => "/guilds";
use constant USERS => "/users";

func OAUTH ($app_id) {
    return "/oauth2/applications/${app_id}";
};

# ---------------------
# - CHANNEL ENDPOINTS -
# ---------------------
func CHANNEL ($channel_id) {
    return "/channels/${channel_id}";
};

func CHANNEL_MESSAGE ($channel_id, $message_id) {
    return "/channels/${channel_id}/messages/${message_id}";
};

func CHANNEL_MESSAGES ($channel_id) {
    return "/channels/${channel_id}/messages";
};

func CHANNEL_MESSAGE_REACTION ($channel_id, $message_id, $reaction) {
    return "/channels/${channel_id}/messages/${message_id}/reactions/${reaction}";
};

func CHANNEL_MESSAGE_REACTIONS ($channel_id, $message_id) {
    return "/channels/${channel_id}/messages/${message_id}/reactions";
};

func CHANNEL_MESSAGE_REACTION_USER ($channel_id, $message_id, $reaction, $user_id) {
    return "/channels/${channel_id}/messages/${message_id}/reactions/${reaction}/${user_id}";
};

func CHANNEL_MESSAGES_SEARCH ($channel_id) {
    return "/channels/${channel_id}/messages/search";
};

func CHANNEL_PERMISSION ($channel_id, $override_id) {
    return "/channels/${channel_id}/permissions/${override_id}";
};

func CHANNEL_PERMISSIONS ($channel_id) {
    return "/channels/${channel_id}/permissions";
};

func CHANNEL_PIN ($channel_id, $message_id) {
    return "/channels/${channel_id}/pins/${message_id}";
};

func CHANNEL_PINS ($channel_id) {
    return "/channels/${channel_id}/pins";
};

func CHANNEL_INVITES ($channel_id) {
    return "/channels/${channel_id}/invites";
};

func CHANNEL_BULK_DELETE ($channel_id) {
    return "/channels/${channel_id}/messages/bulk_delete";
};

func CHANNEL_TYPING ($channel_id) {
    return "/channels/${channel_id}/typing";
};

func CHANNEL_CALL_RING ($channel_id) {
    return "/channels/${channel_id}/call/ring";
};

func CHANNEL_WEBHOOKS ($channel_id) {
    return "/channels/${channel_id}/webhooks";
};

func CHANNEL_RECIPIENT ($group_id, $user_id) {
    return "/channels/${group_id}/recipients/${user_id}";
};

# -------------------
# - GUILD ENDPOINTS -
# -------------------

func GUILD ($guild_id) {
    return "/guilds/${guild_id}";
};

func GUILD_CHANNELS ($guild_id) {
    return "/guilds/${guild_id}/channels";
};

func GUILD_INVITES ($guild_id) {
    return "/guilds/${guild_id}/invites";
};

func GUILD_MEMBERS ($guild_id) {
    return "/guilds/${guild_id}/members";
};

func GUILD_MEMBER ($guild_id, $member_id) {
    return "/guilds/${guild_id}/members/${member_id}";
};

func GUILD_MEMBER_NICK ($guild_id, $member_id) {
    return "/guilds/${guild_id}/members/${member_id}/nick";
};

func GUILD_MEMBER_ROLE ($guild_id, $member_id, $role_id) {
    return "/guilds/${guild_id}/members/${member_id}/roles/${role_id}";
};

func GUILD_INTEGRATIONS ($guild_id) {
    return "/guilds/${guild_id}/integrations";
};

func GUILD_INTEGRATION ($guild_id, $int_id) {
    return "/guilds/${guild_id}/integrations/${int_id}";
};

func GUILD_INTEGRATION_SYNC ($guild_id, $int_id) {
    return "/guilds/${guildID}/integrations/${int_id}/sync";
};

func GUILD_ROLE ($guild_id, $role_id) {
    return "/guilds/${guild_id}/roles/${role_id}";
};

func GUILD_ROLES ($guild_id) {
    return "/guilds/${guildID}/roles";
};

func GUILD_EMOJI ($guild_id, $emoji_id) {
    return "/guilds/${guild_id}/emojis/${emoji_id}";
};

func GUILD_EMOJIS ($guild_id) {
    return "/guilds/${guild_id}/emojis";
};

func GUILD_EMBED ($guild_id) {
    return "/guilds/${guild_id}/embed";
};

func GUILD_MESSAGES_SEARCH ($guild_id) {
    return "/guilds/${guild_id}/messages/search";
};

func GUILD_PRUNE ($guild_id) {
    return "/guilds/${guild_id}/prune";
};

func GUILD_BAN ($guild_id, $member_id) {
    return "/guilds/${guild_id}/bans/${member_id}";
};

func GUILD_BANS ($guild_id) {
    return "/guilds/${guild_id}/bans";
};

func GUILD_WEBHOOKS ($guild_id) {
    return "/guilds/${guild_id}/webhooks";
};

func GUILD_VOICE_REGIONS ($guild_id) {
    return "/guilds/${guild_id}/regions";
};

# ---------------------
# - WEBHOOK ENDPOINTS -
# ---------------------

func WEBHOOK ($webhook_id) {
    return "/webhooks/${webhook_id}";
};

func WEBHOOK_TOKEN ($webhook_id, $token) {
    return "/webhooks/${webhook_id}/${token}";
};

# ------------------
# - USER ENDPOINTS -
# ------------------

func USER ($user_id) {
    return "/users/${user_id}";
};

func USER_GUILDS ($user_id) {
    return "/users/${user_id}/guilds";
};

func USER_GUILD ($user_id, $guild_id) {
    return "/users/${user_id}/guilds/${guild_id}";
};

func USER_CHANNELS ($user_id) {
    return "/users/${user_id}/channels";
};

func USER_RELATIONSHIP ($user_id, $relation_id) {
    return "/users/${user_id}/relationships/${relation_id}";
};

# END OF CONSTANTS!

1;
__END__
