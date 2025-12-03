package com.jdi.apply;

public class ApplyDTO {
    private int reqId;       // 신청 번호 (PK)
    private Integer wordId;  // 수정 신청 시 대상 단어 ID, 신규 등록 신청 시 null
    private String word;     // 단어
    private String doc;      // 요미가나
    private String korean;   // 뜻
    private String jlpt;     // 급수
    private String jdiUser;  // 신청자 ID (FK)
    private String status;   // 상태 (WAIT, OK, NO)
    private String regDate;  // 신청일

    // 생성자
    public ApplyDTO() {}
    
    public ApplyDTO(String word, String doc, String korean, String jlpt, String jdiUser) {
        this.word = word;
        this.doc = doc;
        this.korean = korean;
        this.jlpt = jlpt;
        this.jdiUser = jdiUser;
    }
    
    // 수정 신청용 생성자
    public ApplyDTO(Integer wordId, String doc, String korean, String jlpt, String jdiUser) {
        this.wordId = wordId;
        this.doc = doc;
        this.korean = korean;
        this.jlpt = jlpt;
        this.jdiUser = jdiUser;
    }

    // Getter & Setter
    public int getReqId() { return reqId; }
    public void setReqId(int reqId) { this.reqId = reqId; }
    public Integer getWordId() { return wordId; }
    public void setWordId(Integer wordId) { this.wordId = wordId; }
    public String getWord() { return word; }
    public void setWord(String word) { this.word = word; }
    public String getDoc() { return doc; }
    public void setDoc(String doc) { this.doc = doc; }
    public String getKorean() { return korean; }
    public void setKorean(String korean) { this.korean = korean; }
    public String getJlpt() { return jlpt; }
    public void setJlpt(String jlpt) { this.jlpt = jlpt; }
    public String getJdiUser() { return jdiUser; }
    public void setJdiUser(String jdiUser) { this.jdiUser = jdiUser; }
    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }
    public String getRegDate() { return regDate; }
    public void setRegDate(String regDate) { this.regDate = regDate; }
    
}