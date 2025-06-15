import Foundation

// MARK: - Data Models
struct DreamSymbol: Codable, Identifiable, Equatable {
    let id = UUID()
    let symbol: String
    let meaning: String
    
    init(symbol: String, meaning: String) {
        self.symbol = symbol
        self.meaning = meaning
    }
}

struct DreamInterpretationResponse {
    let interpretation: String
    let guidance: String
    let symbols: [DreamSymbol]
}

class NovitaAIClient {
    private let apiKey = "sk_fOJLIhPpTewwUfmSIdFHPVUjawwDOTEvao5NGpwZxzM"
    private let baseURL = URL(string: "https://api.novita.ai/v3/openai")!
    
    func fetchDreamInterpretationWithSymbols(dreamContent: String, completion: @escaping (Result<DreamInterpretationResponse, Error>) -> Void) {
        let structuredPrompt = """
        Role: You're a professional dream interpreter using Jungian psychology, symbolic analysis, and positive psychology. Generate a response in this exact format with three distinct sections:

        === INTERPRETATION SECTION ===
        
        Overall Theme
        [20-40 word theme summary using "may suggest/could reflect". Connect to waking life.]

        Key Symbols Analysis
        [Symbol Name]
        [Psychological/cultural context]
        [Personalized interpretation]

        [Repeat for 3-5 key symbols found in the dream]

        Emotional Journey
        [Trace emotion progression through dream stages]

        Personal Insights
        [Actionable non-prescriptive suggestion]

        [Second suggestion]
        
        === LUCID DREAM GUIDANCE ===
        
        Dream Awareness Techniques
        [Specific techniques to become lucid in similar dreams]
        
        Reality Check Triggers
        [Elements from this dream that could serve as reality check triggers]
        
        Lucid Action Suggestions
        [What to try if you become lucid in a similar dream scenario]
        
        Practice Recommendations
        [Science-backed techniques for improving lucid dreaming based on dream content]
        
        === SYMBOLS FORMAT ===
        Symbol: [single word only] | Meaning: [brief positive meaning, 8 words max]
        Symbol: [single word only] | Meaning: [brief positive meaning, 8 words max]
        [Continue for each symbol found]

        EXAMPLE OUTPUT FORMAT:

        === INTERPRETATION SECTION ===
        
        Overall Theme
        Your dream may suggest a desire for freedom and perspective in your current life situation, reflecting a need to rise above daily challenges.

        Key Symbols Analysis
        Flying
        In Jungian psychology, flying represents transcendence and liberation from earthly concerns.
        Your ability to fly suggests you're ready to overcome current limitations and gain new perspective on life challenges.

        City
        Cities symbolize community, civilization, and the collective unconscious.
        The city below may represent your social world and responsibilities that you're viewing from a new vantage point.

        Emotional Journey
        The dream progresses from initial wonder at flight to peaceful observation, suggesting a journey from excitement about new possibilities to calm acceptance of your elevated perspective.

        Personal Insights
        Consider what aspects of your life might benefit from a "bird's eye view" - step back from immediate concerns to see the bigger picture.

        Practice meditation or mindfulness to cultivate the sense of peaceful detachment you experienced while flying.
        
        === LUCID DREAM GUIDANCE ===
        
        Dream Awareness Techniques
        When you notice you're flying, perform a reality check by looking at your hands or trying to read text twice.
        
        Reality Check Triggers
        Any sensation of floating, unusual movement, or being high above ground should trigger lucidity awareness.
        
        Lucid Action Suggestions
        If you become lucid while flying, try directing your flight path toward specific destinations or practicing aerial maneuvers.
        
        Practice Recommendations
        Before sleep, visualize yourself flying and set the intention to recognize this as a dream sign for lucid dreaming practice.
        
        === SYMBOLS FORMAT ===
        Symbol: Flying | Meaning: Freedom and transcendence over limitations
        Symbol: City | Meaning: Community and social connections
        Symbol: Night | Meaning: Mystery and subconscious exploration

        Rules:
        - Prioritize emotions and key elements from the dream
        - For dark elements, provide light-based reframing and positive interpretations
        - NEVER diagnose conditions (use "may indicate stress")
        - NEVER predict futures
        - NEVER impose religious views
        - NEVER use absolute statements
        - NEVER include references, citations, or sources
        - For flying/water/falling: Reference Jungian archetypes
        - Include research-backed techniques for lucid dreaming
        - Max 5 symbols total
        - Use plain text formatting, no markdown syntax
        - Keep symbol meanings concise (10-15 words maximum)
        - Structure content with clear section headers for better readability
        - SYMBOLS MUST BE SINGLE WORDS ONLY (e.g., "Flying", "Water", "House", "Car")
        - GUIDANCE MUST BE POSITIVE, UPLIFTING, AND ENCOURAGING
        - Focus on growth, learning, and positive transformation in guidance
        - Reframe challenges as opportunities for personal development
        - FOLLOW THE EXACT FORMAT SHOWN IN THE EXAMPLE ABOVE

        Dream to interpret: \(dreamContent)
        """
        
        fetchChatCompletion(prompt: structuredPrompt) { result in
            switch result {
            case .success(let response):
                let parsedResponse = self.parseInterpretationResponse(response)
                completion(.success(parsedResponse))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    private func parseInterpretationResponse(_ response: String) -> DreamInterpretationResponse {
        print("🔍 Parsing AI response for three sections...")
        print("📄 Full AI Response:")
        print(String(repeating: "=", count: 50))
        print(response)
        print(String(repeating: "=", count: 50))
        
        let lines = response.components(separatedBy: .newlines)
        var interpretation = ""
        var guidance = ""
        var symbols: [DreamSymbol] = []
        var currentSection = ""
        
        for (index, line) in lines.enumerated() {
            let trimmedLine = line.trimmingCharacters(in: .whitespacesAndNewlines)
            print("📝 Line \(index): '\(trimmedLine)'")
            
            // Enhanced section header detection
            if trimmedLine.uppercased().contains("=== INTERPRETATION SECTION ===") ||
               trimmedLine.uppercased().contains("INTERPRETATION SECTION") {
                currentSection = "interpretation"
                print("⭐ Found interpretation section at line \(index)")
                continue
            } else if trimmedLine.uppercased().contains("=== LUCID DREAM GUIDANCE ===") ||
                      trimmedLine.uppercased().contains("LUCID DREAM GUIDANCE") {
                currentSection = "guidance"
                print("⭐ Found guidance section at line \(index)")
                continue
            } else if trimmedLine.uppercased().contains("=== SYMBOLS FORMAT ===") ||
                      trimmedLine.uppercased().contains("SYMBOLS FORMAT") ||
                      (trimmedLine.uppercased().contains("SYMBOL:") && trimmedLine.contains("|")) {
                currentSection = "symbols"
                print("⭐ Found symbols section at line \(index)")
                
                // If this line already contains a symbol, parse it
                if trimmedLine.contains("|") && trimmedLine.uppercased().contains("SYMBOL:") {
                    parseSymbolLine(trimmedLine, into: &symbols)
                }
                continue
            }
            
            // Skip empty lines and section dividers
            if trimmedLine.isEmpty || trimmedLine.starts(with: "===") || trimmedLine.starts(with: "---") {
                continue
            }
            
            // Process content based on current section
            switch currentSection {
            case "interpretation":
                if !interpretation.isEmpty {
                    interpretation += "\n"
                }
                interpretation += trimmedLine
                
            case "guidance":
                if !guidance.isEmpty {
                    guidance += "\n"
                }
                guidance += trimmedLine
                
            case "symbols":
                if trimmedLine.contains("|") {
                    parseSymbolLine(trimmedLine, into: &symbols)
                }
                
            default:
                // If no section is detected yet, try to infer from content
                if currentSection.isEmpty {
                    if trimmedLine.uppercased().contains("OVERALL THEME") ||
                       trimmedLine.uppercased().contains("KEY SYMBOLS") ||
                       trimmedLine.uppercased().contains("EMOTIONAL JOURNEY") ||
                       trimmedLine.uppercased().contains("PERSONAL INSIGHTS") {
                        currentSection = "interpretation"
                        if !interpretation.isEmpty {
                            interpretation += "\n"
                        }
                        interpretation += trimmedLine
                    } else if trimmedLine.uppercased().contains("DREAM AWARENESS") ||
                              trimmedLine.uppercased().contains("REALITY CHECK") ||
                              trimmedLine.uppercased().contains("LUCID ACTION") ||
                              trimmedLine.uppercased().contains("PRACTICE RECOMMENDATIONS") {
                        currentSection = "guidance"
                        if !guidance.isEmpty {
                            guidance += "\n"
                        }
                        guidance += trimmedLine
                    }
                }
            }
        }
        
        // Clean up sections by removing any unwanted formatting
        interpretation = cleanUpText(interpretation)
        guidance = cleanUpText(guidance)
        
        print("📊 Parsing Results:")
        print("- Interpretation length: \(interpretation.count) characters")
        print("- Guidance length: \(guidance.count) characters")
        print("- Symbols found: \(symbols.count)")
        for symbol in symbols {
            print("  • \(symbol.symbol): \(symbol.meaning)")
        }
        
        // Enhanced fallback: if sections are empty or symbols missing, try multiple extraction methods
        if interpretation.isEmpty || guidance.isEmpty || symbols.isEmpty {
            print("⚠️ Some sections missing, trying enhanced extraction...")
            
            // Try to extract from the full response if sections are empty
            if interpretation.isEmpty {
                interpretation = extractInterpretationFallback(from: response)
            }
            
            if guidance.isEmpty {
                guidance = extractGuidanceFallback(from: response)
            }
            
            if symbols.isEmpty {
                // Method 1: Look for symbols in the Key Symbols Analysis section
                symbols = extractSymbolsFromAnalysisSection(response)
                
                // Method 2: If still empty, use fallback extraction
                if symbols.isEmpty {
                    print("🔄 Using fallback symbol extraction")
                    symbols = extractFallbackSymbols(from: interpretation + " " + guidance)
                }
            }
        }
        
        print("🎯 Final result: \(symbols.count) symbols extracted")
        return DreamInterpretationResponse(interpretation: interpretation, guidance: guidance, symbols: symbols)
    }
    
    private func extractInterpretationFallback(from response: String) -> String {
        print("🔄 Using fallback interpretation extraction")
        let lines = response.components(separatedBy: .newlines)
        var result = ""
        var capturing = false
        
        for line in lines {
            let trimmed = line.trimmingCharacters(in: .whitespacesAndNewlines)
            
            // Start capturing after interpretation section or key interpretation keywords
            if trimmed.uppercased().contains("INTERPRETATION") ||
               trimmed.uppercased().contains("OVERALL THEME") ||
               trimmed.uppercased().contains("KEY SYMBOLS") {
                capturing = true
                if !trimmed.contains("===") && !trimmed.isEmpty {
                    result += trimmed + "\n"
                }
                continue
            }
            
            // Stop capturing when we hit guidance section
            if capturing && (trimmed.uppercased().contains("LUCID DREAM") ||
                           trimmed.uppercased().contains("GUIDANCE") ||
                           trimmed.uppercased().contains("SYMBOLS FORMAT")) {
                break
            }
            
            if capturing && !trimmed.isEmpty && !trimmed.starts(with: "===") {
                result += trimmed + "\n"
            }
        }
        
        return result.trimmingCharacters(in: .whitespacesAndNewlines)
    }
    
    private func extractGuidanceFallback(from response: String) -> String {
        print("🔄 Using fallback guidance extraction")
        let lines = response.components(separatedBy: .newlines)
        var result = ""
        var capturing = false
        
        for line in lines {
            let trimmed = line.trimmingCharacters(in: .whitespacesAndNewlines)
            
            // Start capturing after guidance section keywords
            if trimmed.uppercased().contains("LUCID DREAM") ||
               trimmed.uppercased().contains("DREAM AWARENESS") ||
               trimmed.uppercased().contains("REALITY CHECK") {
                capturing = true
                if !trimmed.contains("===") && !trimmed.isEmpty {
                    result += trimmed + "\n"
                }
                continue
            }
            
            // Stop capturing when we hit symbols section
            if capturing && (trimmed.uppercased().contains("SYMBOLS FORMAT") ||
                           (trimmed.contains("|") && trimmed.uppercased().contains("SYMBOL:"))) {
                break
            }
            
            if capturing && !trimmed.isEmpty && !trimmed.starts(with: "===") {
                result += trimmed + "\n"
            }
        }
        
        return result.trimmingCharacters(in: .whitespacesAndNewlines)
    }
    
    private func cleanUpText(_ text: String) -> String {
        return text
            .replacingOccurrences(of: "**", with: "") // Remove markdown bold
            .replacingOccurrences(of: "###", with: "") // Remove markdown headers
            .replacingOccurrences(of: "####", with: "") // Remove markdown headers
            .trimmingCharacters(in: .whitespacesAndNewlines)
    }
    
    private func parseSymbolLine(_ line: String, into symbols: inout [DreamSymbol]) {
        print("🔍 Parsing symbol line: '\(line)'")
        
        // Handle different symbol formats:
        // Format 1: "Symbol: Name | Meaning: Description"
        // Format 2: "Symbol: Name | Description"
        // Format 3: "Name | Description"
        
        let components = line.components(separatedBy: "|")
        if components.count >= 2 {
            let symbolPart = components[0].trimmingCharacters(in: .whitespacesAndNewlines)
            let meaningPart = components[1].trimmingCharacters(in: .whitespacesAndNewlines)
            
            // Extract symbol name (remove "Symbol:" prefix if present)
            var symbolName = symbolPart
                .replacingOccurrences(of: "Symbol:", with: "", options: .caseInsensitive)
                .trimmingCharacters(in: .whitespacesAndNewlines)
            
            // Extract meaning (remove "Meaning:" prefix if present)
            let symbolMeaning = meaningPart
                .replacingOccurrences(of: "Meaning:", with: "", options: .caseInsensitive)
                .trimmingCharacters(in: .whitespacesAndNewlines)
            
            // Ensure symbol name is a single word (take first word if multiple)
            let symbolWords = symbolName.components(separatedBy: .whitespaces)
            if !symbolWords.isEmpty {
                symbolName = symbolWords[0].capitalized
            }
            
            // Validate and add symbol
            if !symbolName.isEmpty && !symbolMeaning.isEmpty && symbolName.count > 1 {
                let newSymbol = DreamSymbol(symbol: symbolName, meaning: symbolMeaning)
                
                // Avoid duplicates
                if !symbols.contains(where: { $0.symbol.lowercased() == symbolName.lowercased() }) {
                    symbols.append(newSymbol)
                    print("✅ Parsed symbol: \(symbolName) - \(symbolMeaning)")
                } else {
                    print("⚠️ Duplicate symbol ignored: \(symbolName)")
                }
            } else {
                print("❌ Invalid symbol format: name='\(symbolName)', meaning='\(symbolMeaning)'")
            }
        } else {
            print("❌ Symbol line doesn't contain pipe separator: '\(line)'")
        }
    }
    
    private func extractFallbackSymbols(from text: String) -> [DreamSymbol] {
        let commonSymbols = [
            ("flying", "Freedom and liberation"),
            ("water", "Emotions and subconscious"),
            ("house", "Self and personal identity"),
            ("car", "Life direction and control"),
            ("animal", "Instincts and natural behavior"),
            ("death", "Transformation and change"),
            ("baby", "New beginnings and potential"),
            ("fire", "Passion and destruction"),
            ("tree", "Growth and life force"),
            ("mountain", "Challenges and achievements")
        ]
        
        var foundSymbols: [DreamSymbol] = []
        let lowercaseText = text.lowercased()
        
        for (symbol, meaning) in commonSymbols {
            if lowercaseText.contains(symbol) {
                foundSymbols.append(DreamSymbol(symbol: symbol.capitalized, meaning: meaning))
            }
        }
        
        return foundSymbols
    }
    
    private func extractSymbolsFromAnalysisSection(_ response: String) -> [DreamSymbol] {
        print("🔍 Extracting symbols from Key Symbols Analysis section...")
        var symbols: [DreamSymbol] = []
        let lines = response.components(separatedBy: .newlines)
        var inSymbolsAnalysis = false
        var currentSymbol = ""
        var currentMeaning = ""
        
        for line in lines {
            let trimmedLine = line.trimmingCharacters(in: .whitespacesAndNewlines)
            
            // Check if we're in the Key Symbols Analysis section
            if trimmedLine.uppercased().contains("KEY SYMBOLS ANALYSIS") {
                inSymbolsAnalysis = true
                print("📖 Found Key Symbols Analysis section")
                continue
            }
            
            // Stop if we hit another section
            if inSymbolsAnalysis && trimmedLine.starts(with: "####") && !trimmedLine.uppercased().contains("KEY SYMBOLS") {
                inSymbolsAnalysis = false
                continue
            }
            
            if inSymbolsAnalysis {
                // Look for symbol names (usually in **bold** format)
                if trimmedLine.starts(with: "**") && trimmedLine.contains("**") {
                    // Save previous symbol if exists
                    if !currentSymbol.isEmpty && !currentMeaning.isEmpty {
                        symbols.append(DreamSymbol(symbol: currentSymbol, meaning: currentMeaning))
                        print("✅ Extracted symbol from analysis: \(currentSymbol) - \(currentMeaning)")
                    }
                    
                    // Extract new symbol name
                    currentSymbol = trimmedLine.replacingOccurrences(of: "**", with: "").trimmingCharacters(in: .whitespacesAndNewlines)
                    currentMeaning = ""
                } else if !currentSymbol.isEmpty && trimmedLine.lowercased().contains("in your dream:") {
                    // Extract the meaning from "In your dream:" line
                    currentMeaning = trimmedLine.replacingOccurrences(of: "- In your dream:", with: "")
                        .replacingOccurrences(of: "In your dream:", with: "")
                        .trimmingCharacters(in: .whitespacesAndNewlines)
                }
            }
        }
        
        // Don't forget the last symbol
        if !currentSymbol.isEmpty && !currentMeaning.isEmpty {
            symbols.append(DreamSymbol(symbol: currentSymbol, meaning: currentMeaning))
            print("✅ Extracted final symbol from analysis: \(currentSymbol) - \(currentMeaning)")
        }
        
        print("📊 Extracted \(symbols.count) symbols from analysis section")
        return symbols
    }
    
    func fetchChatCompletion(prompt: String, completion: @escaping (Result<String, Error>) -> Void) {
        var request = URLRequest(url: baseURL.appendingPathComponent("chat/completions"))
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
        
        let body: [String: Any] = [
            "model": "meta-llama/llama-3.1-8b-instruct",
            "messages": [
                ["role": "system", "content": "Act like you are a helpful assistant."],
                ["role": "user", "content": prompt]
            ],
            "max_tokens": 1024
        ]
        
        request.httpBody = try? JSONSerialization.data(withJSONObject: body)
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                completion(.failure(NSError(domain: "NovitaAIClient", code: -1, userInfo: [NSLocalizedDescriptionKey: "No data received"])))
                return
            }
            
            do {
                if let json = try JSONSerialization.jsonObject(with: data) as? [String: Any],
                   let choices = json["choices"] as? [[String: Any]],
                   let message = choices.first?["message"] as? [String: Any],
                   let content = message["content"] as? String {
                    completion(.success(content))
                } else {
                    completion(.failure(NSError(domain: "NovitaAIClient", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid response format"])))
                }
            } catch {
                completion(.failure(error))
            }
        }
        
        task.resume()
    }
} 