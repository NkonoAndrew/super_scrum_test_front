import java.util.*;

public class ApplicationLogHandler extends AbstractLogHandler {
    private Map<String, Integer> logLevels = new HashMap<>();

    @Override
    public void handle(String logLine) {
        Map<String, String> logMap = LogParser.parseLogLine(logLine);
        if (logMap.containsKey("level")) {
            String level = logMap.get("level");
            logLevels.put(level, logLevels.getOrDefault(level, 0) + 1);
        } else {
            super.handle(logLine);
        }
    }

    public Map<String, Object> getAggregatedData() {
        return new HashMap<>(logLevels);
    }
}
