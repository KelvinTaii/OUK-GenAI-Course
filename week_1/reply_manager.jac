"""Reply Manager with BYLLM (Gemini) + Hybrid Rules"""

import from byllm { Model }

# Use Gemini model through BYLLM
glob llm = Model(model_name="gemini/gemini-2.0-flash", verbose=False);

# Explicit classification: only "QUESTION" or "COMMENT"
def classify_comment(comment: str) -> str by llm(prompt="""
Classify the following social media comment strictly as either:
- QUESTION (if the comment is asking something)
- COMMENT (if it’s just feedback or a statement)

Comment: {comment}
Your Answer (only one word):
""");

# Polite, relevant reply for questions
def answer_question(comment: str) -> str by llm(prompt="""
You are a helpful social media manager. 
Provide a polite and relevant reply to this user question:

{comment}

Reply:
""");

walker ReplyManager {
    has comment: str;
    has reply: str = "";

    can start with entry {
        print("Comment: " + self.comment);

        classification = classify_comment(self.comment).strip().upper();

        # --- Hybrid logic: LLM + rule-based fallback ---
        if "QUESTION" in classification or "?" in self.comment {
            self.reply = answer_question(self.comment).strip();
        } elif (
            "great" in self.comment.lower() or
            "amazing" in self.comment.lower() or
            "love" in self.comment.lower() or
            "nice" in self.comment.lower() or
            "awesome" in self.comment.lower()
        ) {
            self.reply = "Thanks so much for your kind words! We’re glad you enjoyed it.";
        } else {
            self.reply = "Thanks for your comment! We appreciate your support.";
        }

        print("Reply: " + self.reply);
    }
}

# CLI runner
with entry {
    root spawn ReplyManager("What time do you open?");
    root spawn ReplyManager("Great post, I love it!");
    root spawn ReplyManager("Do you deliver?");
    root spawn ReplyManager("Amazing work!");
    root spawn ReplyManager("Nice product, well done!");
}
