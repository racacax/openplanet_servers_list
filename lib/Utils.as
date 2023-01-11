/*
    Method to join server
    #qjoin : join a server directly
    #join : Show server details before connecting on dedicated servers. Same as #qjoin for Nadeo servers
    #qspectate : Spectate server
*/
void JoinServer(const string &in login) {
    cast<CTrackMania>(GetApp()).ManiaPlanetScriptAPI.OpenLink("maniaplanet://" + login, CGameManiaPlanetScriptAPI::ELinkType::ManialinkBrowser);
}

Json::Value GetNullJsonValue() {
    return Json::Parse('{"key":null}')["key"];
}

/*
TODO : Would be better to convert Account Id to login directly from there instead of doing an API request
string ASCII_TABLE = Json::FromFile("assets/ascii.json");
// Based on Beu's code from OpenPlanet Discord
string getLoginFromAccountID(string accountId) {
    accountId = accountId.Replace("-", "");
    string login = "";
    for(uint i=0; i< accountId.Length; i+=2) {
        string pair = accountId.SubStr(i, 2);
        vec4 hexVal = Text::ParseHexColor("#" + pair + "0000");
        int intVal = 0xFF * hexVal.x;
        //Log::Trace(tostring(intVal));
        login += ASCII_TABLE[tostring(intVal)];
    }
    auto buffer = MemoryBuffer();
    buffer.Write(login);
    buffer.Seek(0);
    //IO::SetClipboard(buffer.ReadToBase64(buffer.GetSize()));
    return buffer.ReadToBase64(buffer.GetSize()).Replace("+", "-").Replace("");
}
*/