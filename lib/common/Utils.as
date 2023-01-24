/*
    Method to join server
    #qjoin : join a server directly
    #join : Show server details before connecting on dedicated servers
    #qspectate : Spectate server directly
*/
void JoinServer(const string &in login) {
    cast<CTrackMania>(GetApp()).ManiaPlanetScriptAPI.OpenLink("maniaplanet://" + login, CGameManiaPlanetScriptAPI::ELinkType::ManialinkBrowser);
}

Json::Value GetNullJsonValue() {
    return Json::Parse('{"key":null}')["key"];
}

// Based on Beu's code from OpenPlanet Discord
// Thanks to Phlarx for the help
string GetLoginFromAccountId(string &in accountId) {
    accountId = accountId.Replace("-", "");
    string login = "";
    for(int i=0; i< accountId.Length; i+=2) {
        string pair = accountId.SubStr(i, 2);
        vec4 hexVal = Text::ParseHexColor("#" + pair + "0000");
        int intVal = int(Math::Round(0xFF * hexVal.x));
        login += " ";
        login[login.Length - 1] = intVal;
    }
    auto buffer = MemoryBuffer();
    buffer.Write(login);
    buffer.Seek(0);
    return buffer.ReadToBase64(buffer.GetSize()).Replace("+", "-").Replace("/", "_").Replace("=", "");
}