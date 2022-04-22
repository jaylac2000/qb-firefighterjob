local Translations = {
    error = {
        canceled = 'Canceled',
        impossible = 'Action Impossible...',
        no_player = 'No Player Nearby',
        not_enough_money = 'You don\'t have enough money on you...',
        cant_help = 'You can\'t help this person...',
        not_fire = 'You are not a Firefighter or not signed in',
        not_online = 'Player Not Online'
    },
    info = {
        civ_call = 'Civilian Call',
        self_death = 'Themselves or an NPC',
        wep_unknown = 'Unknown',
        fire_plate = 'FIRE', -- Should only be 4 characters long due to the last 4 being a random 4 digits
        heli_plate = 'SAFR',  -- Should only be 4 characters long due to the last 4 being a random 4 digits
        safe = 'Firefighter Armory',
        fire_report = 'Fire Report',
        fd_station = 'Fire Station',
        fire_alert = 'Fire Alert - %{text}',
        message_sent = 'Message to be sent',
        player_id = 'Player ID (may be empty)',
    },
    menu = {
        fire_vehicles = 'Fire Vehicles',
        status = 'Heath Status',
        close = '⬅ Close Menu',
    },
    text = {
        pstash_button = '[E] - Personal stash',
        pstash = 'Personal stash',
        onduty_button = '[E] - Go On Duty',
        offduty_button = '[E] - Go Off Duty',
        duty = 'On/Off Duty',
        armory_button = '[E] - Armory',
        armory = 'Armory',
        veh_button = '[E] - Grab / Store Vehicle',
        heli_button = '[E] - Grab / Take Helicopter',
    }
}

Lang = Locale:new({
    phrases = Translations,
    warnOnMissing = true
})