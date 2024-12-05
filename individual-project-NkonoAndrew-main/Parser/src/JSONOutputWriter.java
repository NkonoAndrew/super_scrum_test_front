import com.fasterxml.jackson.databind.ObjectMapper;
import java.io.File;
import java.io.IOException;
import java.util.Map;

public class JSONOutputWriter implements OutputWriter {
    @Override
    public void writeOutput(Map<String, Object> data, String filename) {
        ObjectMapper mapper = new ObjectMapper();
        try {
            mapper.writerWithDefaultPrettyPrinter().writeValue(new File(filename), data);
        } catch (IOException e) {
            e.printStackTrace();
        }
    }
}
