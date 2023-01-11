// Source : https://github.com/tm-rmc/MXRandom/blob/main/src/Utils/Logging.as
namespace Log
{
    void Log(string&in message, bool showNotification = false)
    {
        print(message);
        if (showNotification)
        {
            UI::ShowNotification(PLUGIN_NAME, message);
        }
    }

    void Trace(string&in message, bool showNotification = false)
    {
        trace(message);
        if (showNotification)
        {
            UI::ShowNotification(PLUGIN_NAME, message);
        }
    }

    void Warn(string&in message)
    {
        warn(message);
        vec4 color = UI::HSV(0.11, 1.0, 1.0);
        UI::ShowNotification(Icons::Kenney::ExclamationCircle + " " + PLUGIN_NAME + " - Warning", message, color, 5000);
    }
    void Succeed(string&in message)
    {
        vec4 color = UI::HSV(0.346, 0.92, 0.94);
        UI::ShowNotification(Icons::Kenney::ExclamationCircle + " " + PLUGIN_NAME + " - Success", message, color, 5000);
    }

    void Error(string&in message)
    {
        error(message);
        vec4 color = UI::HSV(1.0, 1.0, 1.0);
        UI::ShowNotification(Icons::Kenney::TimesCircle + " " + PLUGIN_NAME + " - Error", message, color, 8000);
    }
}