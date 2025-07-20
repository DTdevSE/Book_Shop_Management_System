package com.bookshop.servlet;

import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import javax.servlet.*;
import java.io.IOException;

import okhttp3.OkHttpClient;
import okhttp3.Request;
import okhttp3.RequestBody;
import okhttp3.Response;
import okhttp3.MediaType;

@WebServlet("/ChatBotServlet")
public class ChatBotServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    // OpenAI API endpoint for chat completions
    private static final String OPENAI_API_URL = "https://platform.openai.com/api-keys";

    // TODO: Replace with your own API key securely! Don't commit to public repos!
    private static final String OPENAI_API_KEY = "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";

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String userMessage = request.getParameter("message");
        if (userMessage == null || userMessage.trim().isEmpty()) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            response.setContentType("application/json");
            response.getWriter().write("{\"error\":\"Message parameter is missing\"}");
            return;
        }

        // Escape double quotes in userMessage for JSON safety
        String escapedMessage = userMessage.replace("\"", "\\\"");

        // Build JSON request body for OpenAI chat completion
        String jsonRequestBody = "{"
                + "\"model\": \"gpt-3.5-turbo\","
                + "\"messages\": [{\"role\": \"user\", \"content\": \"" + escapedMessage + "\"}]"
                + "}";

        OkHttpClient client = new OkHttpClient();

        RequestBody body = RequestBody.create(
                jsonRequestBody,
                MediaType.parse("application/json; charset=utf-8")
        );

        Request openAiRequest = new Request.Builder()
                .url(OPENAI_API_URL)
                .addHeader("Authorization", "Bearer " + OPENAI_API_KEY)
                .post(body)
                .build();

        try (Response openAiResponse = client.newCall(openAiRequest).execute()) {
            if (!openAiResponse.isSuccessful()) {
                response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
                response.setContentType("application/json");
                response.getWriter().write("{\"error\":\"Error from OpenAI API: " + openAiResponse.message() + "\"}");
                return;
            }

            String responseBody = openAiResponse.body().string();

            response.setContentType("application/json");
            response.setCharacterEncoding("UTF-8");
            response.getWriter().write(responseBody);
        } catch (Exception e) {
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            response.setContentType("application/json");
            response.getWriter().write("{\"error\":\"Exception: " + e.getMessage() + "\"}");
        }
    }
}
