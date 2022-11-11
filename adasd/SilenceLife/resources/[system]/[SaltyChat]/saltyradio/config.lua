Config = {}

Config.enableCmd = true --  /radio command should be active or not (if not you have to carry the item "radio") true / false

Config.RestrictedChannels = {
  [1] = {
    ['police'] = true,
    ['army'] = true
  },
  [2] = {
    ['ambulance'] = true,
    ['police'] = true,
    ['army'] = true
  },
  [3] = {
    ['fire'] = true,
    ['police'] = true,
    ['army'] = true
  },
  [4] = {
    ['mechanic'] = true,
    ['police'] = true
  },
  [5] = {
    ['taxi'] = true,
    ['police'] = true
  },
  [6] = {  
    ['army'] = true,
    ['police'] = true
  },
  [7] = {
    ['grove'] = true,
    ['police'] = true
  },
  [8] = {
    ['crips'] = true
  },
  [9] = {
    ['vagos'] = true
  },
  [10] = {
    ['triaden'] = true
  },
  [11] = {
    ['yakuza'] = true
  },
  [12] = {
	  ['ballas'] = true
  },
  [13] = {
    ['grove'] = true
  },
  [14] = {
    ['mg'] = true
  },
  [15] = {
    ['midnight'] = true
  },
  [16] = {
    ['lostmc'] = true
  },
  [17] = {
    ['bratwa'] = true
  },
}

Config.messages = {
  ['not_on_radio'] = 'Du bist momentan in keinem Funk-Kanal',
  ['on_radio'] = 'Du bist im Funk-Kanal: <b>',
  ['joined_to_radio'] = 'Du bist nun im Funk',
  ['restricted_channel_error'] = 'Dieser Funk-Kanal ist verschlüsselt',
  ['you_on_radio'] = 'Du bist bereits in diesem Funk',
  ['you_leave'] = 'Du hast den Funk-Kanal verlassen'

}
