#if MP4
string GetEnvironments() {
    string env = "";
    string ENV_PREFIX = "environments%5b%5d=";
    if(displayCanyon) env += ENV_PREFIX + CANYON + "&";
    if(displayStadium) env += ENV_PREFIX + STADIUM + "&";
    if(displayShootmania) env += ENV_PREFIX + SHOOTMANIA + "&";
    if(displayValley) env += ENV_PREFIX + VALLEY + "&";
    if(displayLagoon) env += ENV_PREFIX + LAGOON + "&";
    return env;
}
#endif