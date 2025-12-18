package com.mnu.jpstudy.config;

import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.config.annotation.web.configuration.EnableWebSecurity;
import org.springframework.security.web.SecurityFilterChain;

@Configuration // 설정 파일이다
@EnableWebSecurity // 스프링 시큐리티를 활성화한다
public class SecurityConfig {

    @Bean
    public SecurityFilterChain filterChain(HttpSecurity http) throws Exception {
        http
            .csrf(csrf -> csrf.disable()) // 테스트를 위해 CSRF 보안 끄기
            .authorizeHttpRequests(auth -> auth
                .anyRequest().permitAll() // "모든 요청(anyRequest)을 허용(permitAll)해라"
            );
            
        return http.build();
    }
}