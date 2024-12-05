import java.util.*;

public class APMLogHandler extends AbstractLogHandler {
    private Map<String, List<Double>> metrics = new HashMap<>();

    @Override
    public void handle(String logLine) {
        Map<String, String> logMap = LogParser.parseLogLine(logLine);
        if (logMap.containsKey("metric") && logMap.containsKey("value")) {
            String metric = logMap.get("metric");
            double value = Double.parseDouble(logMap.get("value"));
            metrics.computeIfAbsent(metric, k -> new ArrayList<>()).add(value);
        } else {
            super.handle(logLine);
        }
    }

    public Map<String, Object> getAggregatedData() {
        Map<String, Object> result = new HashMap<>();
        for (Map.Entry<String, List<Double>> entry : metrics.entrySet()) {
            List<Double> values = entry.getValue();
            values.sort(Double::compareTo);
            double min = values.get(0);
            double max = values.get(values.size() - 1);
            double median = values.size() % 2 == 0
                    ? (values.get(values.size() / 2 - 1) + values.get(values.size() / 2)) / 2.0
                    : values.get(values.size() / 2);
            double average = values.stream().mapToDouble(Double::doubleValue).average().orElse(0.0);
            Map<String, Double> stats = Map.of(
                    "minimum", min,
                    "median", median,
                    "average", average,
                    "max", max
            );
            result.put(entry.getKey(), stats);
        }
        return result;
    }
}
