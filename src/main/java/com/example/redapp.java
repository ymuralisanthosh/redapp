package com.example.redapp;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;

@SpringBootApplication
public class RedApp {

    public static void main(String[] args) {
        SpringApplication.run(RedApp.class, args);
    }
}

@RestController
class RedController {

    @GetMapping("/")
    public String displayRed() {
        return "<h1 style=\"color: red;\">Red App</h1>";
    }
}

