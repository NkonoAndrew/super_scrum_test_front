import java.util.*;
import java.util.regex.*;

public class LogParser {
    public static Map<String, String> parseLogLine(String line) {
        Map<String, String> map = new HashMap<>();
        Pattern pattern = Pattern.compile("(\\w+)=((\"[^\"]*\")|(\\S+))");
        Matcher matcher = pattern.matcher(line);
        while (matcher.find()) {
            String key = matcher.group(1);
            String value = matcher.group(2).replaceAll("^\"|\"$", "");
            map.put(key, value);
        }
        return map;
    }
}
