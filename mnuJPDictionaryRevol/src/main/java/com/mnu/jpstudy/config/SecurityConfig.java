package com.mnu.jpstudy.config;

import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.config.annotation.web.configuration.EnableWebSecurity;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.security.web.SecurityFilterChain;
import org.springframework.security.web.util.matcher.AntPathRequestMatcher;

@Configuration
@EnableWebSecurity
public class SecurityConfig {

    @Bean
    public SecurityFilterChain filterChain(HttpSecurity http) throws Exception {
        http
            // 1. 접근 권한 설정
            .authorizeHttpRequests(auth -> auth
                .requestMatchers("/", "/auth/**", "/css/**", "/js/**", "/images/**").permitAll() // 누구나 접근 가능
                .requestMatchers("/admin/**").hasRole("ADMIN") // 관리자만
                .anyRequest().authenticated() // 나머지는 로그인해야 함
            )
            // 2. 폼 로그인 설정
            .formLogin(form -> form
                .loginPage("/auth/login") // 커스텀 로그인 페이지 경로
                .loginProcessingUrl("/auth/login") // 폼 태그 action url
                .defaultSuccessUrl("/", true) // 성공 시 이동
                .permitAll()
            )
            // 3. 로그아웃 설정
            .logout(logout -> logout
                .logoutRequestMatcher(new AntPathRequestMatcher("/auth/logout"))
                .logoutSuccessUrl("/")
                .invalidateHttpSession(true)
            );
            // .csrf(csrf -> csrf.disable()); // 개발 중엔 편의상 끄기도 하지만 보안상 켜두는 게 좋음

        return http.build();
    }

    @Bean
    public PasswordEncoder passwordEncoder() {
        return new BCryptPasswordEncoder(); // 비밀번호 암호화 필수
    }
}