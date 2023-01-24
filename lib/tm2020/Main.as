#if TMNEXT
string BASE_URL = "https://live-services.trackmania.nadeo.live/api/token/";

void RunGameSpecificMain() {
	NadeoServices::AddAudience("NadeoLiveServices");
	while (!NadeoServices::IsAuthenticated("NadeoLiveServices")) {
		yield();
	}
}

void RenderGameSpecificHeader() {
}
#endif