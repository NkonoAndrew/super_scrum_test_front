import java.util.*;

public class RequestAggregator {
    private Map<String, List<Double>> responseTimesPerUrl = new HashMap<>();
    private Map<String, Map<String, Integer>> statusCountsPerUrl = new HashMap<>();

    public void processLog(Map<String, String> logMap) {
        String url = logMap.get("request_url");
        String responseTimeStr = logMap.get("response_time_ms");
        String statusCode = logMap.get("response_status");
        if (url == null || responseTimeStr == null || statusCode == null) {
            return; // Invalid log line
        }
        try {
            double responseTime = Double.parseDouble(responseTimeStr);
            responseTimesPerUrl.computeIfAbsent(url, k -> new ArrayList<>()).add(responseTime);

            String statusCategory = categorizeStatusCode(statusCode);
            Map<String, Integer> statusCounts = statusCountsPerUrl.computeIfAbsent(url, k -> new HashMap<>());
            statusCounts.put(statusCategory, statusCounts.getOrDefault(statusCategory, 0) + 1);
        } catch (NumberFormatException e) {
            // Invalid number, ignore
        }
    }

    private String categorizeStatusCode(String statusCode) {
        if (statusCode.startsWith("2")) {
            return "2XX";
        } else if (statusCode.startsWith("4")) {
            return "4XX";
        } else if (statusCode.startsWith("5")) {
            return "5XX";
        } else {
            return "Other";
        }
    }

    public Map<String, Object> getAggregatedData() {
        Map<String, Object> result = new HashMap<>();
        for (String url : responseTimesPerUrl.keySet()) {
            List<Double> times = responseTimesPerUrl.get(url);
            Collections.sort(times);
            int n = times.size();
            double min = times.get(0);
            double max = times.get(n - 1);
            Map<String, Double> percentiles = new HashMap<>();
            percentiles.put("min", min);
            percentiles.put("50_percentile", getPercentile(times, 50));
            percentiles.put("90_percentile", getPercentile(times, 90));
            percentiles.put("95_percentile", getPercentile(times, 95));
            percentiles.put("99_percentile", getPercentile(times, 99));
            percentiles.put("max", max);

            Map<String, Object> urlData = new HashMap<>();
            urlData.put("response_times", percentiles);
            urlData.put("status_codes", statusCountsPerUrl.get(url));

            result.put(url, urlData);
        }
        return result;
    }

    private double getPercentile(List<Double> sortedValues, double percentile) {
        int index = (int) Math.ceil(percentile / 100.0 * sortedValues.size()) - 1;
        index = Math.min(index, sortedValues.size() - 1);
        return sortedValues.get(index);
    }
}
