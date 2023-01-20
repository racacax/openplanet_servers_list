class Room {
    int id;
    int clubId;
    string clubName;
    string name;
    int playerCount;
    int maxPlayers;
    string region;
    string gameMode;
    bool isNadeo;
    bool hasPassword;
    string type;
    string titlepack;
    string login;

    Room() {}
    Room(const Json::Value &in id, const Json::Value &in clubId,const Json::Value &in clubName, const Json::Value &in name, const Json::Value &in playerCount, const Json::Value &in maxPlayers, const Json::Value &in region, const Json::Value &in gameMode, const Json::Value &in isNadeo, const Json::Value &in hasPassword, const string &in login = "") {
        this.id = id;
        this.clubId = clubId;
        this.clubName = clubName;
        this.isNadeo = isNadeo;
        this.hasPassword = hasPassword;
        this.name = name;
        this.playerCount = playerCount;
        this.login = login;
        if(maxPlayers.GetType() != Json::Type::Null) {
            this.maxPlayers = maxPlayers;
        } else {
            this.maxPlayers = -1;
        }
        if(region.GetType() != Json::Type::Null) {
            this.region = region;
        } else {
            this.region = "unknown";
        }
        if(gameMode.GetType() != Json::Type::Null && gameMode != "") {
            auto gameModeSplit = string(gameMode).Split(".");
            gameModeSplit = gameModeSplit[0].Split("/");
            this.gameMode = gameModeSplit[gameModeSplit.Length -1];
        } else {
            this.gameMode = "Unknown";
        }
        this.type = "ClubRoom";
    }

    string GetMaxPlayers() {
        if(this.maxPlayers == -1)
            return "-";
        return tostring(this.maxPlayers);
    }

}

class ManiaPlanetRoom: Room {
    ManiaPlanetRoom() {}
    ManiaPlanetRoom(const Json::Value &in id, const Json::Value &in name, const Json::Value &in playerCount, const Json::Value &in maxPlayers, const Json::Value &in region, const Json::Value &in gameMode, const Json::Value &in login, const Json::Value &in titlepack, const Json::Value &in hasPassword) {
        super(id, 0, "", name, playerCount, maxPlayers, region, gameMode, Json::Value(false), hasPassword);
        this.type = "ManiaPlanetRoom";
        this.login = login;
        this.titlepack = titlepack;
    }

}

class TotdRoom: Room {
    TotdRoom() {}
    TotdRoom(const Json::Value &in playerCount) {
        super(Json::Value(-1), Json::Value(0), Json::Value("Ubisoft Nadeo"), Json::Value("Track of the day"), playerCount, GetNullJsonValue(), GetNullJsonValue(), Json::Value("TM_TimeAttack_Online"), Json::Value(false), Json::Value(false));
        this.type = "TotdRoom";
    }

}

class CampaignRoom: TotdRoom {
    CampaignRoom() {}
    CampaignRoom(const Json::Value &in playerCount) {
        super(playerCount);
        this.name = "Official Seasonal Campaign";
        this.type = "CampaignRoom";
        this.id = -2;
    }

}

class ArcadeRoom: TotdRoom {
    ArcadeRoom() {}
    ArcadeRoom(const Json::Value &in name, const Json::Value &in playerCount) {
        super(playerCount);
        this.name = name;
        this.type = "ArcadeRoom";
        this.id = -3;
    }

}