import org.junit.Test;
import java.util.Map;

import static org.junit.Assert.*;

public class RequestLogHandlerTest {
    @Test
    public void testHandleValidRequestLog() {
        RequestLogHandler handler = new RequestLogHandler();
        handler.handle("timestamp=2024-11-24T10:01:30Z request_method=GET request_url=\"/api/status\" response_status=200 response_time_ms=150");
        handler.handle("timestamp=2024-11-24T10:02:30Z request_method=POST request_url=\"/api/status\" response_status=500 response_time_ms=300");

        Map<String, Object> result = handler.getAggregatedData();
        Map<String, Object> apiStatusData = (Map<String, Object>) result.get("/api/status");

        assertNotNull(apiStatusData);
        assertTrue(((Map<String, Integer>) apiStatusData.get("status_codes")).containsKey("2XX"));
        assertTrue(((Map<String, Integer>) apiStatusData.get("status_codes")).containsKey("5XX"));
    }

    @Test
    public void testHandleInvalidRequestLog() {
        RequestLogHandler handler = new RequestLogHandler();
        handler.handle("timestamp=2024-11-24T10:01:30Z level=INFO message=\"Invalid log line\"");

        Map<String, Object> result = handler.getAggregatedData();
        assertTrue(result.isEmpty());
    }
}
