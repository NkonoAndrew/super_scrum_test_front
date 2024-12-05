import com.fasterxml.jackson.databind.ObjectMapper;
import org.junit.Test;
import java.io.*;
import java.util.*;

import static org.junit.Assert.*;

public class IntegrationTest {
    @Test
    public void testProcessLogFile() throws IOException {
        String inputLogFile = "sample_input_logs-1.txt";
        LogProcessor.main(new String[]{"--file", inputLogFile});

        File apmFile = new File("apm.json");
        File applicationFile = new File("application.json");
        File requestFile = new File("request.json");

        assertTrue(apmFile.exists());
        assertTrue(applicationFile.exists());
        assertTrue(requestFile.exists());

        // Check APM JSON content
        Map<String, Object> apmData = new ObjectMapper().readValue(apmFile, Map.class);
        assertNotNull(apmData.get("cpu_usage_percent"));

        // Check Application JSON content
        Map<String, Object> applicationData = new ObjectMapper().readValue(applicationFile, Map.class);
        assertTrue(applicationData.containsKey("INFO"));

        // Check Request JSON content
        Map<String, Object> requestData = new ObjectMapper().readValue(requestFile, Map.class);
        assertNotNull(requestData.get("/api/status"));
    }
}
