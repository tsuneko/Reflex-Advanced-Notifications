# [Reflex-Advanced-Notifications](http://steamcommunity.com/sharedfiles/filedetails/?id=890151289)

# I removed Advanced Notifications from the Steam Workshop due to the "Timer" controversy in the Reflex community

The code provided can be used, if you rename the file to "advnotif" and use it as a local mod. Although I have provided the mod here, please do not use it in competitive play (... if anyone still plays anyhow).

# About

Adds similar functionality to [Kytö's Timestamps](https://steamcommunity.com/sharedfiles/filedetails/?id=789028269) (which appears to have also been removed from the workshop) but with easier to configure settings (visual widgets menu rather than cvars) and more features. However, Advanced Notifications is designed only for 1v1 and will not tell you when your teammates take items.

Features:
- Timestamp on Item Pickup
- Notify before an Item Respawns (configurable between 0.1~20 seconds, default is 5)
- Notify when an Item Respawns

- Toggle all of those three above features
- Toggle on every armor type and mega health

- Toggle on custom notifications (read more about this below)

- Set a limit on how many notifications will pop up (1~6, default is 3)
- Set a duration on each notification (0.1~6 seconds, default is 1.8)

- Toggle counting time downwards (default) or upwards
- Toggle showing armour/mega health icon with notification
- Toggle showing timestamp (applies to Item Pickup only)
- Toggle showing item respawn timestamp (applies to Item Respawn warning only)

- and Colour Settings, if you have some fancy HUD and don't want black/white.

Custom Notifications are a way to add your own notifications into the game. You do this by using the cvar:
ui_advnotifs_notify [delay] [message]
The game will give you a notification after delay seconds, with the message. This can be used to add notifications (eg. check on carnage respawn). If we wanted to use this example where the game would send us a notification on carnage respawn after 85 seconds after we press a key (q in example) we would enter this into console:
bind q ui_advnotifs_notify 85 Check Carnage Respawn
Then whenever we see or hear carnage spawn, we can press Q on our keyboard then after 85 seconds a notification will pop up on the screen reminding us to go to the carnage spawn to do an easy item pickup.

If there are any bugs or features you want, please add to comments and I'll see about it.

Of course the screenshots were taken with a much larger scale and duration than what you would use.

![Image](https://steamuserimages-a.akamaihd.net/ugc/84846967804450789/2815FA9796FE3D94F435733F46724B3BB8B738F8/)
![Image](https://steamuserimages-a.akamaihd.net/ugc/84846967804346422/055A58C65D445F887AE8BD52E7939C97F68BAFF8/)
![Image](https://steamuserimages-a.akamaihd.net/ugc/84846967804346821/2FFD529CA99D3503605B008DB4F8BB41EAE551BC/)
![Image](https://steamuserimages-a.akamaihd.net/ugc/84846967804349537/BE29D1960B4EA05A34BB5FF7C5A358F40A492595/)
![Image](https://steamuserimages-a.akamaihd.net/ugc/84846967804349698/852F50AC0C6F98821008F9774643636AE4CF2F93/)
![Image](https://steamuserimages-a.akamaihd.net/ugc/84846967804353015/0130C381524C4E7FDBBA801D6F20C5E17CA58D00/)
