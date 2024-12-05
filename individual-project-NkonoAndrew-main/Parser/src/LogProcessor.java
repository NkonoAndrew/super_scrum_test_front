import java.io.*;
import java.util.*;

public class LogProcessor {
    public static void main(String[] args) {
        // Check for valid command-line arguments
        if (args.length != 2 || !args[0].equals("--file")) {
            System.out.println("Usage: java LogProcessor --file <filename>");
            return;
        }

        String inputFile = args[1];
        try (BufferedReader br = new BufferedReader(new FileReader(inputFile))) {
            // Create handlers and set up the chain
            LogHandler apmHandler = new APMLogHandler();
            LogHandler appHandler = new ApplicationLogHandler();
            LogHandler requestHandler = new RequestLogHandler();
            apmHandler.setNext(appHandler);
            appHandler.setNext(requestHandler);

            // Process each log line
            String line;
            while ((line = br.readLine()) != null) {
                apmHandler.handle(line);
            }

            // Output results
            OutputWriter writer = new JSONOutputWriter();
            writer.writeOutput(((APMLogHandler) apmHandler).getAggregatedData(), "apm.json");
            writer.writeOutput(((ApplicationLogHandler) appHandler).getAggregatedData(), "application.json");
            writer.writeOutput(((RequestLogHandler) requestHandler).getAggregatedData(), "request.json");
            System.out.println("Logs processed and output files generated.");
        } catch (IOException e) {
            e.printStackTrace();
        }
    }
}
