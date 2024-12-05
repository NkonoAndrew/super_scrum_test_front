import java.util.*;

public class RequestData {
    private List<Double> responseTimes = new ArrayList<>();
    private Map<String, Integer> statusCodes = new HashMap<>();

    public void addResponseTime(double time) {
        responseTimes.add(time);
    }

    public void incrementStatusCode(String statusCode) {
        String category = statusCode.charAt(0) + "XX";
        statusCodes.put(category, statusCodes.getOrDefault(category, 0) + 1);
    }

    public Map<String, Object> toMap() {
        responseTimes.sort(Double::compareTo);
        Map<String, Object> result = new HashMap<>();
        result.put("response_times", Map.of(
                "min", responseTimes.get(0),
                "max", responseTimes.get(responseTimes.size() - 1),
                "50_percentile", responseTimes.get(responseTimes.size() / 2),
                "90_percentile", responseTimes.get((int) (responseTimes.size() * 0.9)),
                "95_percentile", responseTimes.get((int) (responseTimes.size() * 0.95)),
                "99_percentile", responseTimes.get((int) (responseTimes.size() * 0.99))
        ));
        result.put("status_codes", statusCodes);
        return result;
    }
}
