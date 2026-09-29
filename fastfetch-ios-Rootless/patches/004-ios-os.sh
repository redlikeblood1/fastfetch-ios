python3 - "$BUILD_DIR/src/detection/os/os_apple.m" <<'PY'
from pathlib import Path
import sys
import re

path = Path(sys.argv[1])
text = path.read_text()

text = re.sub(
    r'static bool parseSystemVersion\(FFOSResult\* os\)\s*\{.*?\n\}\n',
    '',
    text,
    flags=re.DOTALL
)

text = re.sub(
    r'static bool detectOSCodeName\(FFOSResult\* os\)\s*\{.*?\n\}\n',
    '',
    text,
    flags=re.DOTALL
)

start = text.index("void ffDetectOSImpl(FFOSResult* os)")
text = text[:start] + r'''void ffDetectOSImpl(FFOSResult* os)
{
    char model[256] = "";
    size_t len = sizeof(model);

    ffStrbufSetStatic(&os->id, "macos");

    ffSysctlGetString("kern.osproductversion", &os->version);
    ffStrbufAppend(&os->versionID, &os->version);

    bool haveModel = (sysctlbyname("hw.machine", model, &len, NULL, 0) == 0);

    // iPadOS exists since iOS 13; older iPads keep the classic name
    if (haveModel && strncmp(model, "iPad", 4) == 0 && atoi(os->version.chars) >= 13)
        ffStrbufSetStatic(&os->name, "iPadOS");
    else
        ffStrbufSetStatic(&os->name, "iPhone OS");

    if (haveModel)
        ffStrbufSetS(&os->prettyName, model);

    if (os->prettyName.length > 0)
    {
        FFstrbuf modelName;
        ffStrbufInit(&modelName);
        ffStrbufAppendF(&modelName, "%s %s %s",
            os->name.chars,
            os->version.chars,
            os->prettyName.chars);
        ffStrbufSet(&os->prettyName, &modelName);
        ffStrbufDestroy(&modelName);
    }
    else
    {
        ffStrbufSetF(&os->prettyName, "%s %s",
            os->name.chars,
            os->version.chars);
    }
}
'''

path.write_text(text)
PY

echo "Patched OS Identification for iOS"