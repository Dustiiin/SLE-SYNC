//////////////////////////////////////////
//           Discord Whitelist          //
//             Made By MikeTV           //
//////////////////////////////////////////

/// Config Area ///

var enableWhitelist = true; // Enable the Whitelist/Allowlist
var guildId = "885795162964512808"; // Guild ID for a Discord Server, see https://faxes.zone/i/zjKnd.png
var botToken = "MTAxMzYyMjEwNjM1MDY5MDMzNA.GuHPzx.gfw_Hl_7oayOyPZuv8y_-ATtsLZdZslwUcsJI4"; // This must be a Discord bot token, create a bot @ https://discord.com/developers/applications

var whitelistRoles = [ // Roles by ID that are whitelisted.
    "1040114359403298817"
];
var blacklistRoles = [ // Roles by Id that are blacklisted.
    "1040114647312912446"
];

var notWhitelistedMessage = "Du bist noch nicht gewhitelisted. Um hier zu spielen musst du auf unserm Discord Server sein.";
var noGuildMessage = "Mitglied nicht gefunden. Sieht so aus als wenn du nicht ein Mitglied bist für die Community.";
var blacklistMessage = "Du wurdest leider Geblacklisted. Bitte wende dich an den Support!";
var debugMode = false; // 
var cacheMaxTime = "1h"; // This is the time it takes for refreshes (cache) to have to reload when fetching Discord roles.

/// Code ///
var work = true;
var cache = {};
const axios = require('axios').default;
const ms = require('ms');
axios.defaults.baseURL = 'https://discord.com/api/v9';
axios.defaults.headers = {
    
};
const version = '4.1.1'

getUserDiscord = async function(source, callback) {
    if(typeof source == 'string') return source;
    if(!GetPlayerName(source)) return false;
    let arr = []
    for(let index = 0; index <= GetNumPlayerIdentifiers(source); index ++) {
        if(GetPlayerIdentifier(source, index)) {
            arr.push(GetPlayerIdentifier(source, index))
        }
    }
    setTimeout(() => {
        const found = arr.find(e => e.startsWith('discord:'));
        if(found) {
            callback(found.replace('discord:', ''));
        } else {
            callback(null);
        }
    }, 500);
}

setTimeout(async () => {
    let botAccount = await axios({
        method: 'GET',
        url: `https://discord.com/api/v9/users/@me`,
        headers: {
            'Content-Type': 'application/json',
            Authorization: `Bot ${botToken}`
        },
    }).catch(async (err) => {
        console.log(`[${version}] ^5Bot token is incorrect, ensure your token is correct. ^1Stopping...^7`);
        work = false;
    });

    if(botAccount.data) {
        await axios({
            method: 'GET',
            url: `https://discord.com/api/v9/guilds/${guildId}`,
            headers: {
                'Content-Type': 'application/json',
                Authorization: `Bot ${botToken}`
            },
        }).catch(async (err) => {
            console.log(`[${version}] ^5Guild ID is incorrect or bot isn't in guild. ^1Stopping...^7`);
            console.log(`[${version}] ^5Invite: https://discord.com/api/oauth2/authorize?client_id=${botAccount.data.id}&permissions=1024&scope=bot ^7`);
            work = false;
        });
    }
}, 2000);

// 0 = Not whitelisted
// 1 = Whitelisted
// 2 = Expired cache / refresh
// 3 = Blacklisted
function checkCache(userId) {
    if(cache[userId]) { // Check cache
        // Check timeout
        if(Date.now() > cache[userId].timeAt) { // cache expired
            return 2
        } else {
            if(cache[userId].passed == 1) {
                return 1
            } else if(cache[userId].passed == 3) {
                return 3
            } else {
                return 0
            }
        }
    } else {
        return 2
    }
}

on('playerConnecting', async (name, setKickReason, deferrals) => {
    if(!work) return;
    if(!enableWhitelist) return;
    let src = global.source;
    deferrals.defer();
    setTimeout(() => {
        deferrals.update(`Hallo ${name}. Wir checken eben nur ob du Gewhitelistet bist ^^`)
        setTimeout(async function() {
            getUserDiscord(src, async function(userId) {
                if(userId) {
                    let cacheCheck = await checkCache(userId);
                    if(cacheCheck == 1) {
                        if(debugMode) console.log(`[${version}] ^5${name} Ist Genemigt^7`)
                        return deferrals.done();
                    } else if(cacheCheck == 3) {
                        if(debugMode) console.log(`[${version}] ^5${name} Du bist Geblacklisted^7`)
                        return deferrals.done(blacklistMessage);
                    } else if(cacheCheck == 2) {
                        let resDis = await axios({
                            method: 'GET',
                            url: `https://discord.com/api/v9/guilds/${guildId}/members/${userId}`,
                            headers: {
                                'Content-Type': 'application/json',
                                Authorization: `Bot ${botToken}`
                            },
                        }).catch(async (err) => {
                            // if(debugMode) console.error(JSON.stringify(err))
                            if(debugMode) console.log(`[${version}] ^5${name} ist kein Mitglied.^7`)
                            return deferrals.done(noGuildMessage);
                        });
                        if(!resDis) {
                            cache[userId] = {passed: 0,roles: null,timeAt: Date.now() + ms(cacheMaxTime)}
                            if(debugMode) console.log(`[${version}] ^5Error in Discord call. Maybe consider extending the 'cacheMaxTime' option.^7`)
                            return deferrals.done('Es gibt einen fehler mit deiner Discord ID, bitte wende dich an den Support.');
                        }
                        if(!resDis.data) {
                            cache[userId] = {passed: 0,roles: null,timeAt: Date.now() + ms(cacheMaxTime)}
                            if(debugMode) console.log(`[${version}] ^5${name} is not in the guild. Cache created^7`)
                            return deferrals.done(noGuildMessage);
                        }
                        let hasRole = false;
                        let hasBlackRole = false;
                        for (let i = 0; i < whitelistRoles.length; i++) {
                            if (resDis.data.roles.includes(whitelistRoles[i])) hasRole = true;
                        };
                        for (let i = 0; i < blacklistRoles.length; i++) {
                            if (resDis.data.roles.includes(blacklistRoles[i])) hasBlackRole = true;
                        }
                        if(hasBlackRole) {
                            cache[userId] = {passed: 3,roles: resDis.data.roles,timeAt: Date.now() + ms(cacheMaxTime)}
                            if(debugMode) console.log(`[${version}] ^5${name} is blacklisted. Cache created^7`)
                            return deferrals.done(blacklistMessage);
                        }
                        if(hasRole) {
                            cache[userId] = {passed: 1,roles: resDis.data.roles,timeAt: Date.now() + ms(cacheMaxTime)}
                            if(debugMode) console.log(`[${version}] ^5${name} is whitelisted. Cache created^7`)
                            return deferrals.done();
                        } else {
                            cache[userId] = {passed: 0,roles: resDis.data.roles,timeAt: Date.now() + ms(cacheMaxTime)}
                            if(debugMode) { 
                                console.log(`[${version}] ^5${name} is not whitelisted. Cache created^7`);
                                console.log(`[${version}] ^5${name}s Roles: ^7`, resDis.data.roles);
                            }
                            return deferrals.done(notWhitelistedMessage);              
                        }
                    } else if(cacheCheck == 0) {
                        if(debugMode) console.log(`[${version}] ^5${name} is not whitelisted.^7`)
                        return deferrals.done(notWhitelistedMessage);
                    }
                } else {
                    return deferrals.done(`Deine Discord-Anmeldeinformationen wurden nicht erkannt. Unter diesem Link finden Sie einige Tipps zur Erkennung - https://docs.weblutions.com/c/fivem/debugging-discord`);
                }
            });
        }, 0)
    }, 0)
});


// API AND EXPORTS
exports('getRoles', (src) => {
    if(!work) return;
    return new Promise((res, rej) => {
        getUserDiscord(src, function(userId) {
            if(userId) {
                axios(`/guilds/${guildId}/members/${userId}`).then((resDis) => {
                    if(!resDis.data) {
                        res([])
                    }
                    res(resDis.data.roles)
                }).catch((err) => {
                    res([])
                });
            } else {
                res([])
            }
        });
    });
});

exports('userHasRole', (src, roles) => {
    if(!work) return;
    return new Promise((res, rej) => {
        getUserDiscord(src, function(userId) {
            if(userId) {
                axios(`/guilds/${guildId}/members/${userId}`).then((resDis) => {
                    if(!resDis.data) {
                        res(false)
                    }
                    const hasRole = resDis.data.roles.some((cRole, i) => resDis.data.roles.includes(roles[i]));
                    if(hasRole) {
                        res(true)
                    } else {
                        res(false)
                    }
                    
                }).catch((err) => {
                    res(false)
                });
            } else {
                res(false)
            }
        });
    });
});

exports('getName', (src) => {
    if(!work) return;
    return new Promise((res, rej) => {
        getUserDiscord(src, function(userId) {
            if(userId) {
                axios(`/guilds/${guildId}/members/${userId}`).then((resDis) => {
                    if(!resDis.data) {
                        res(null)
                    }
                    res({username: resDis.data.username, discriminator: resDis.data.discriminator, nickname: resDis.data.nick})
                }).catch((err) => {
                    res(null)
                });
            } else {
                res(null)
            }
        });
    });
});
