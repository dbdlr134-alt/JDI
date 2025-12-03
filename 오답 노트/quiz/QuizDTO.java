package com.jdi.quiz;

public class QuizDTO {
	private int quiz_id;
	public int getQuiz_id() {
		return quiz_id;
	}
	public void setQuiz_id(int quiz_id) {
		this.quiz_id = quiz_id;
	}
	public String getWord() {
		return word;
	}
	public void setWord(String word) {
		this.word = word;
	}
	public String getJlpt() {
		return jlpt;
	}
	public void setJlpt(String jlpt) {
		this.jlpt = jlpt;
	}
	public String getSelection1() {
		return selection1;
	}
	public void setSelection1(String selection1) {
		this.selection1 = selection1;
	}
	public String getSelection2() {
		return selection2;
	}
	public void setSelection2(String selection2) {
		this.selection2 = selection2;
	}
	public String getSelection3() {
		return selection3;
	}
	public void setSelection3(String selection3) {
		this.selection3 = selection3;
	}
	public String getSelection4() {
		return selection4;
	}
	public void setSelection4(String selection4) {
		this.selection4 = selection4;
	}
	public String getAnswer() {
		return answer;
	}
	public void setAnswer(String answer) {
		this.answer = answer;
	}
	private String word;
	private String jlpt;
	private String selection1;
	private String selection2;
	private String selection3;
	private String selection4;
	private String answer;
	private int note_id;
	private String jdi_user;
	private int wrong_count;
	private String wrong_date;
	private String doc;
	private String korean;
	private int word_id;
	public int getWord_id() {
		return word_id;
	}
	public void setWord_id(int word_id) {
		this.word_id = word_id;
	}
	public int getNote_id() {
		return note_id;
	}
	public void setNote_id(int note_id) {
		this.note_id = note_id;
	}
	public String getJdi_user() {
		return jdi_user;
	}
	public void setJdi_user(String jdi_user) {
		this.jdi_user = jdi_user;
	}
	public int getWrong_count() {
		return wrong_count;
	}
	public void setWrong_count(int wrong_count) {
		this.wrong_count = wrong_count;
	}
	public String getWrong_date() {
		return wrong_date;
	}
	public void setWrong_date(String wrong_date) {
		this.wrong_date = wrong_date;
	}
	public String getDoc() {
		return doc;
	}
	public void setDoc(String doc) {
		this.doc = doc;
	}
	public String getKorean() {
		return korean;
	}
	public void setKorean(String korean) {
		this.korean = korean;
	}
	
}
