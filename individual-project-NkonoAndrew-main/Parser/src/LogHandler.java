public interface LogHandler {
    void setNext(LogHandler nextHandler);
    void handle(String logLine);
}
