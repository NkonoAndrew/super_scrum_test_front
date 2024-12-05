import org.junit.Test;
import java.util.Map;

import static org.junit.Assert.*;

public class LogParserTest {
    @Test
    public void testParseValidLogLine() {
        String logLine = "timestamp=2024-11-24T10:00:50Z level=INFO message=\"User updated profile\" user_id=103 host=webserver3";
        Map<String, String> result = LogParser.parseLogLine(logLine);

        assertEquals("2024-11-24T10:00:50Z", result.get("timestamp"));
        assertEquals("INFO", result.get("level"));
        assertEquals("User updated profile", result.get("message"));
        assertEquals("103", result.get("user_id"));
        assertEquals("webserver3", result.get("host"));
    }

    @Test
    public void testParseInvalidLogLine() {
        String logLine = "This is a malformed log line without key-value pairs";
        Map<String, String> result = LogParser.parseLogLine(logLine);

        assertTrue(result.isEmpty());
    }
}
