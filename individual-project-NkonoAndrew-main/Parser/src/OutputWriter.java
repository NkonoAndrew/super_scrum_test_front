import java.util.Map;

public interface OutputWriter {
    void writeOutput(Map<String, Object> data, String filename);
}
