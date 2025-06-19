class AiRewriteService < ApplicationService
  def call
    text = @context[:text]
    mode = @context[:mode]
    # Mock AI service - replace with real AI integration
    rewritten_text = case mode
    when "polite"
      make_polite(text)
    when "cheerful"
      make_cheerful(text)
    when "mysterious"
      make_mysterious(text)
    else
      text
    end

    result.data = rewritten_text
    result
  rescue StandardError => e
    result.add_error("AI service error: #{e.message}", code: "ai_error")
    result
  end

  def make_polite(text)
    # Simple mock transformation
    "Please note: #{text}. Thank you for your attention."
  end

  def make_cheerful(text)
    # Simple mock transformation
    "#{text} 😊 Have a wonderful day!"
  end

  def make_mysterious(text)
    # Simple mock transformation
    "In the shadows of understanding lies this truth: #{text}... but what lies beyond?"
  end
end
