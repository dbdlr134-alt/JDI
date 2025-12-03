package com.jdi.quiz;

import com.jdi.util.Action;

public class QuizServiceFactory {
	private QuizServiceFactory() {}
	
	private static QuizServiceFactory instance =new QuizServiceFactory();
	
	public static QuizServiceFactory getinstance() {
		return instance;
	}
	
	public Action action(String cmd) {
		Action action = null ;
		
		if(cmd.equals("word_quiz")) {
			action =new WordQuizServices();
		}else if(cmd.equals("quiz_incorrect")){
			action =new QuizIncorrectService();
		}
		return action;
	}
}
