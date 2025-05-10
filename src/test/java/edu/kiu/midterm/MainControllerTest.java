package edu.kiu.midterm;

import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.get;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.post;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.content;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.status;

import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.autoconfigure.web.servlet.WebMvcTest;
import org.springframework.test.web.servlet.MockMvc;

@WebMvcTest(MainController.class)
public class MainControllerTest {

	@Autowired
	private MockMvc mockMvc;

	@Test
	public void testHealth() throws Exception {
		mockMvc.perform(get("/health"))
				.andExpect(status().isOk());
	}

	@Test
	public void testHello() throws Exception {
		mockMvc.perform(get("/hello/{name}", "World"))
				.andExpect(status().isOk())
				.andExpect(content().string("Hello, World!"));
	}

	@Test
	public void testSubmit() throws Exception {
		mockMvc.perform(post("/form")
						.param("name", "John"))
				.andExpect(status().isOk())
				.andExpect(content().string("Form submitted with a name: John"));
	}

}
