package com.mjdi.user;

public class UserDTO {
    // 1. 필드 (테이블 컬럼과 1:1 매칭)
    private String jdi_user;   // 아이디
    private String jdi_pass;   // 비밀번호
    private String jdi_name;   // 이름
    private String jdi_email;  // 이메일
    private String jdi_phone;  // 전화번호
    private String jdi_profile;
    private String jdi_role;

    public String getJdi_role() {
		return jdi_role;
	}

	public void setJdi_role(String jdi_role) {
		this.jdi_role = jdi_role;
	}

	public String getJdi_profile() {
		return jdi_profile;
	}

	public void setJdi_profile(String jdi_profile) {
		this.jdi_profile = jdi_profile;
	}

	// 2. 기본 생성자
    public UserDTO() {}

    // 3. 전체 필드 생성자
    public UserDTO(String jdi_user, String jdi_pass, String jdi_name, String jdi_email, String jdi_phone) {
        this.jdi_user = jdi_user;
        this.jdi_pass = jdi_pass;
        this.jdi_name = jdi_name;
        this.jdi_email = jdi_email;
        this.jdi_phone = jdi_phone;
    }

    // 4. Getter & Setter
    public String getJdi_user() { return jdi_user; }
    public void setJdi_user(String jdi_user) { this.jdi_user = jdi_user; }

    public String getJdi_pass() { return jdi_pass; }
    public void setJdi_pass(String jdi_pass) { this.jdi_pass = jdi_pass; }

    public String getJdi_name() { return jdi_name; }
    public void setJdi_name(String jdi_name) { this.jdi_name = jdi_name; }

    public String getJdi_email() { return jdi_email; }
    public void setJdi_email(String jdi_email) { this.jdi_email = jdi_email; }

    public String getJdi_phone() { return jdi_phone; }
    public void setJdi_phone(String jdi_phone) { this.jdi_phone = jdi_phone; }
}