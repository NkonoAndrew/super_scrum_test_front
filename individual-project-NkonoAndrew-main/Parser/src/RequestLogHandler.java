import java.util.*;

public class RequestLogHandler extends AbstractLogHandler {
    private Map<String, RequestData> requests = new HashMap<>();

    @Override
    public void handle(String logLine) {
        Map<String, String> logMap = LogParser.parseLogLine(logLine);
        if (logMap.containsKey("request_method") && logMap.containsKey("request_url")) {
            String url = logMap.get("request_url");
            double responseTime = Double.parseDouble(logMap.getOrDefault("response_time_ms", "0"));
            String statusCode = logMap.get("response_status");

            RequestData requestData = requests.computeIfAbsent(url, k -> new RequestData());
            requestData.addResponseTime(responseTime);
            requestData.incrementStatusCode(statusCode);
        } else {
            super.handle(logLine);
        }
    }

    public Map<String, Object> getAggregatedData() {
        Map<String, Object> result = new HashMap<>();
        for (Map.Entry<String, RequestData> entry : requests.entrySet()) {
            result.put(entry.getKey(), entry.getValue().toMap());
        }
        return result;
    }
}
