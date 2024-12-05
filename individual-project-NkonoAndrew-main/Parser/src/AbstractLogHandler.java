public abstract class AbstractLogHandler implements LogHandler {
    protected LogHandler nextHandler;

    @Override
    public void setNext(LogHandler nextHandler) {
        this.nextHandler = nextHandler;
    }

    @Override
    public void handle(String logLine) {
        if (nextHandler != null) {
            nextHandler.handle(logLine);
        }
    }
}
