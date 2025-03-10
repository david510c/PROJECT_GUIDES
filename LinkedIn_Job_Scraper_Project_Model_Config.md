# LinkedIn Job Scraper GPT Model Configuration

## Project Context
- **Domain**: Web scraping, browser automation, data extraction
- **Focus**: LinkedIn job listings data extraction
- **Key challenges**: Dynamic DOM structure, anti-bot measures, inconsistent data presentation
- **Primary Tools**: Playwright, Node.js

### Key Terminology
- **DOM Structure**: Document Object Model representing LinkedIn's page layout
- **Selectors**: CSS or XPath expressions used to target specific elements
- **Job Card**: Individual job listing in search results
- **Job Details**: Expanded information shown when clicking a job card
- **Enhanced Extraction**: Advanced techniques combining multiple selectors and pattern matching
- **Direct Job ID Access**: Accessing job details via their unique IDs rather than clicking cards

## Interaction Patterns

### Project-Specific Commands
- `selector-debug [data-point]`: Generate selector suggestions for specific data points
- `analyze-extraction [method]`: Compare extraction methods for specific data fields
- `stealth-review`: Analyze current anti-detection measures and suggest improvements
- `optimize [function-name]`: Review and optimize specific extraction functions

### Custom Workflows
1. **Selector Refinement Workflow**:
   ```
   1. Identify data point extraction issues
   2. Review current selector implementations
   3. Analyze LinkedIn DOM structure changes
   4. Generate improved selector strategies
   5. Implement and test fallback hierarchy
   ```

2. **Extraction Method Enhancement**:
   ```
   1. Analyze current extraction success rates
   2. Identify most challenging data points
   3. Design specialized extraction strategies
   4. Implement pattern recognition improvements
   5. Test and validate with sample data
   ```

3. **Anti-Detection Improvement**:
   ```
   1. Review current stealth measures
   2. Identify potential detection signals
   3. Research latest anti-bot countermeasures
   4. Implement browser fingerprint randomization
   5. Test with gradual scaling to verify
   ```

## Technical Adaptations

### LinkedIn-Specific Handling
- **Dynamic Content Handling**: Strategies for working with content that loads asynchronously
- **Class Name Changes**: Approaches for dealing with LinkedIn's frequent class name updates
- **Text Pattern Recognition**: Using content patterns rather than just selectors
- **Nested Information Extraction**: Handling deeply nested or context-dependent information

### Code Generation Rules
- Generate extraction functions with multiple selector fallbacks
- Include detailed comments for selector strategies and fallback logic
- Implement structured error handling with informative logging
- Maintain separation between navigation logic and data extraction logic
- Preserve stealth measures in all automated interactions
- Follow Node.js async/await best practices

## Learning Record

### Successful Interaction Patterns
- **Tiered Extraction Strategy**: Starting with fast, specific selectors before falling back to more complex methods
- **Context-Aware Extraction**: Using surrounding text and structure to infer data points
- **Stateful Authentication**: Saving and reusing authentication state between sessions
- **Parallel Hypothesis Testing**: Running multiple extraction strategies to determine best approach

### Optimization Discoveries
- Identification of most reliable selector patterns across LinkedIn updates
- Recognition of pattern-based extraction being more durable than class-based selectors
- Direct job ID access provides more consistent results for certain data points
- Text-based pattern matching is most reliable for salary and applicant count extraction

### Error Recovery Improvements
- Implementing retry logic with progressive delays for transient failures
- Adding context-based validation to verify extracted data accuracy
- Developing specialized extraction functions for challenging data points
- Creating comprehensive logging for failed extraction attempts