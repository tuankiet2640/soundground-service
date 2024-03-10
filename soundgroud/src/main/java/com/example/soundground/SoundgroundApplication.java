package com.example.soundground;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.cache.annotation.EnableCaching;

@SpringBootApplication @EnableCaching

public class SoundgroundApplication {

	public static void main(String[] args) {
		SpringApplication.run(SoundgroundApplication.class, args);
	}

}
