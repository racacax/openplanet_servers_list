#if MP4
Json::Value DeclareRequest(const Net::HttpMethod method, const string &in url, const string &in body = "") {
	auto app = cast<CTrackMania>(GetApp());
    Net::HttpRequest@ req = Net::HttpRequest();
	req.Url = url;
	req.Method = method;
	req.Headers.Set("Accept", "application/json");
	req.Headers.Set("Content-Type", "application/json");
	req.Headers.Set("Maniaplanet-Auth", 'Login="'+ GetLocalLogin() +'", Token="' + app.ManiaPlanetScriptAPI.Authentication_Token + '"');
	req.Body = body;
	// Log::Trace("Body: " + body);
	req.Start();
	while (!req.Finished()) {
		yield();
	}
    Log::Trace("Result: " + req.String());
	return Json::Parse(req.String());
}

Json::Value Post(const string &in url, const string &in body = "") {
	return DeclareRequest(Net::HttpMethod::Post, url, body);
}

Json::Value Get(const string &in url) {
	return DeclareRequest(Net::HttpMethod::Get, url);
}
#endif