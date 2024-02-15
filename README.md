# ChargeFinder

![charging-station-icon](https://github.com/Ghassen21/ChargeFinder/assets/72602715/928e40d1-2602-46b1-859e-8164efdf872b)


This App focused on helping drivers of electric cars find nearby charging stations and view their availability status in real time.
The mandatory product backlog or the prioritized (must) have been implemented in this project, ensuring the creation of a Minimum Viable Product (MVP).

[MUST] As a user, I want to see all charging stations within a 1km radius of my position listed. A second tab should be available in the app, displaying a list of charging stations. The list should be sorted by "Power" in descending order (i.e., stations with the highest charging power at the top). Each list entry must display "id," "Power," and availability at a minimum.

[MUST] As a user, I want to view real-time availability without manually reloading data. Acceptance criteria: Charging station availability is automatically updated. A 'last update' field appears in the UI indicating the time of the last data update. Validation is done against map.geo.admin.ch (refer below).

[MUST] As a user, I want to be able to view the last loaded list of charging stations when I am offline. Acceptance criteria: Opening the app with internet connectivity synchronizes available charging stations around me. Disabling internet connectivity, closing and reopening the app should retain the list. The map does not need to be cached or stored; only the list is available in offline mode.
