#if MP4
string BASE_URL = "https://prod.live.maniaplanet.com/ingame/";
string SHOOTMANIA = "Storm";
string STADIUM = "Stadium";
string VALLEY = "Valley";
string CANYON = "Canyon";
string LAGOON = "Lagoon";

void RunGameSpecificMain() {
	while(cast<CTrackMania>(GetApp()).ManiaPlanetScriptAPI.Authentication_Token == "") {
        yield();
    }
}
void RenderGameSpecificHeader() {
    UI::BeginTable("titlesTable", 5, UI::TableFlags::SizingFixedFit);
	UI::TableNextRow();
	UI::TableNextColumn();
    if(displayStadium != UI::Checkbox(STADIUM, displayStadium)) {
        page = 0;
        displayStadium = !displayStadium;
        AddEvent("getAllRooms");
    }
	UI::TableNextColumn();
    if(displayCanyon != UI::Checkbox(CANYON, displayCanyon)) {
        page = 0;
        displayCanyon = !displayCanyon;
        AddEvent("getAllRooms");
    }
	UI::TableNextColumn();
    if(displayValley != UI::Checkbox(VALLEY, displayValley)) {
        page = 0;
        displayValley = !displayValley;
        AddEvent("getAllRooms");
    }
	UI::TableNextColumn();
    if(displayLagoon != UI::Checkbox(LAGOON, displayLagoon)) {
        page = 0;
        displayLagoon = !displayLagoon;
        AddEvent("getAllRooms");
    }
	UI::TableNextColumn();
    if(displayShootmania != UI::Checkbox(SHOOTMANIA, displayShootmania)) {
        page = 0;
        displayShootmania = !displayShootmania;
        AddEvent("getAllRooms");
    }
    UI::EndTable();
}
#endif