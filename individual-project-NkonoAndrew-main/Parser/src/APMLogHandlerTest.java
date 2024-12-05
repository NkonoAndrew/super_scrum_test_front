import org.junit.Test;
import java.util.Map;

import static org.junit.Assert.*;

public class APMLogHandlerTest {
    @Test
    public void testHandleValidAPMLog() {
        APMLogHandler handler = new APMLogHandler();
        handler.handle("timestamp=2024-11-24T10:01:30Z metric=cpu_usage_percent host=webserver1 value=94");
        handler.handle("timestamp=2024-11-24T10:04:05Z metric=cpu_usage_percent host=webserver3 value=45");

        Map<String, Object> result = handler.getAggregatedData();
        Map<String, Double> cpuUsageStats = (Map<String, Double>) result.get("cpu_usage_percent");

        assertNotNull(cpuUsageStats);
        assertEquals(45.0, cpuUsageStats.get("minimum"), 0.01);
        assertEquals(94.0, cpuUsageStats.get("max"), 0.01);
        assertEquals(69.5, cpuUsageStats.get("median"), 0.01);
    }

    @Test
    public void testHandleInvalidAPMLog() {
        APMLogHandler handler = new APMLogHandler();
        handler.handle("timestamp=2024-11-24T10:01:30Z level=INFO message=\"Invalid log line\"");

        Map<String, Object> result = handler.getAggregatedData();
        assertTrue(result.isEmpty());
    }
}
