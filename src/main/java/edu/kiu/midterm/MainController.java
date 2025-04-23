package edu.kiu.midterm;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

@Controller
public class MainController {

	@GetMapping("/health")
	@ResponseBody
	public void health() {
		System.out.println("Health check passed");
	}

	@GetMapping("/hello/{name}")
	@ResponseBody
	public String hello(@PathVariable("name") String name) {
		return "Hello, " + name + "!";
	}

	@PostMapping("/form")
	@ResponseBody
	public String submit(@RequestParam("name") String name) {
		return "Form submitted with name: " + name;
	}

	@GetMapping("/index")
	public String index() {
		return "index";
	}

	@GetMapping("/form")
	public String form() {
		return "form";
	}

	@GetMapping("/status")
	public String status() {
		return "status";
	}

}
