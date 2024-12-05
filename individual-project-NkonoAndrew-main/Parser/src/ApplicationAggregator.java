import java.util.HashMap;
import java.util.Map;

public class ApplicationAggregator {
    private Map<String, Integer> levelCounts = new HashMap<>();

    public void processLog(Map<String, String> logMap) {
        String level = logMap.get("level");
        levelCounts.put(level, levelCounts.getOrDefault(level, 0) + 1);
    }

    public Map<String, Object> getAggregatedData() {
        return new HashMap<>(levelCounts);
    }
}
