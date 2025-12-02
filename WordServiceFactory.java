package com.jdi.word;

import com.jdi.util.Action;

public class WordServiceFactory {
	 private WordServiceFactory() {}
	 
	 private static WordServiceFactory instance = new WordServiceFactory();
	 
	 public static WordServiceFactory getInstance() {
			return instance;
		}
	 public Action action(String cmd) {
		 Action action = null;
		 
		 if (cmd.equals("word_search")) {// 관리자로그인
				action = new WordSearchService();
			}
		return action; 
		 
	 }
}
