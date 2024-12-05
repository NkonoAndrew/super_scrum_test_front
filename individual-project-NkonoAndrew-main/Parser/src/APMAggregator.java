import java.util.*;

public class APMAggregator {
    private Map<String, List<Double>> metricValues = new HashMap<>();

    public void processLog(Map<String, String> logMap) {
        String metric = logMap.get("metric");
        String valueStr = logMap.get("value");
        try {
            double value = Double.parseDouble(valueStr);
            metricValues.computeIfAbsent(metric, k -> new ArrayList<>()).add(value);
        } catch (NumberFormatException e) {
            // Ignore invalid value
        }
    }

    public Map<String, Object> getAggregatedData() {
        Map<String, Object> result = new HashMap<>();
        for (Map.Entry<String, List<Double>> entry : metricValues.entrySet()) {
            String metric = entry.getKey();
            List<Double> values = entry.getValue();
            Collections.sort(values);
            double min = values.get(0);
            double max = values.get(values.size() - 1);
            double median = computeMedian(values);
            double average = computeAverage(values);
            Map<String, Double> stats = new HashMap<>();
            stats.put("minimum", min);
            stats.put("median", median);
            stats.put("average", average);
            stats.put("max", max);
            result.put(metric, stats);
        }
        return result;
    }

    private double computeMedian(List<Double> values) {
        int size = values.size();
        if (size % 2 == 0) {
            return (values.get(size / 2 - 1) + values.get(size / 2)) / 2.0;
        } else {
            return values.get(size / 2);
        }
    }

    private double computeAverage(List<Double> values) {
        double sum = 0;
        for (Double v : values) {
            sum += v;
        }
        return sum / values.size();
    }
}
