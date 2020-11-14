package com.colmena.zuul;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.cloud.netflix.eureka.EnableEurekaClient;
import org.springframework.cloud.netflix.zuul.EnableZuulProxy;
import org.springframework.context.annotation.Bean;

import com.colmena.zuul.filter.PreFilter;

@EnableEurekaClient
@EnableZuulProxy
@SpringBootApplication
public class ToolSrvZuulApplication {

	public static void main(String[] args) {
		SpringApplication.run(ToolSrvZuulApplication.class, args);
	}

	@Bean
	public PreFilter preFilter() {
	        return new PreFilter();
	 }
	  
}
