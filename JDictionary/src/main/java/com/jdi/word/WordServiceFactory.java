package com.jdi.word;

import com.jdi.util.Action;

public class WordServiceFactory {
    private WordServiceFactory() {}
    private static WordServiceFactory instance = new WordServiceFactory();
    public static WordServiceFactory getInstance() { return instance; }

    public Action action(String cmd) {
        Action action = null;

        if (cmd == null || cmd.equals("main")) {
            action = new WordMainService();
        } else if (cmd.equals("word_search")) {
            action = new WordSearchService();
        } else if (cmd.equals("word_view")) {
            action = new WordViewService();
        } else if (cmd.equals("auto_complete")) { // 자동완성 연결
            action = new WordAutoCompleteService();
        } else if (cmd.equals("word_req")) {
            action = new WordReqService();
        }
        return action;
    }
}