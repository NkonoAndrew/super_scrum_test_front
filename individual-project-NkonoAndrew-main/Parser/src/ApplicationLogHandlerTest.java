import org.junit.Test;
import java.util.Map;

import static org.junit.Assert.*;

public class ApplicationLogHandlerTest {
    @Test
    public void testHandleValidApplicationLog() {
        ApplicationLogHandler handler = new ApplicationLogHandler();
        handler.handle("timestamp=2024-11-24T10:00:50Z level=INFO message=\"User logged in\"");
        handler.handle("timestamp=2024-11-24T10:01:00Z level=ERROR message=\"Failed to process request\"");

        Map<String, Object> result = handler.getAggregatedData();

        assertEquals(1, result.get("INFO"));
        assertEquals(1, result.get("ERROR"));
    }

    @Test
    public void testHandleInvalidApplicationLog() {
        ApplicationLogHandler handler = new ApplicationLogHandler();
        handler.handle("timestamp=2024-11-24T10:00:50Z metric=cpu_usage_percent value=45");

        Map<String, Object> result = handler.getAggregatedData();
        assertTrue(result.isEmpty());
    }
}
