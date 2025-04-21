package edu.kiu.midterm;

import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

@RestController
public class MainController {

	@GetMapping("/health")
	public void health() {
		System.out.println("Health check passed");
	}

	@GetMapping("/hello/{name}")
	public String hello(@PathVariable("name") String name) {
		return "Hello, " + name + "!";
	}

	@PostMapping("/form")
	public String submit(@RequestParam("name") String name) {
		return "Form submitted with name: " + name;
	}

}
