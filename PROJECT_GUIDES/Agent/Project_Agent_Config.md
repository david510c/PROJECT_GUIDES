# Project Agent Configuration

## Project Context
- **Project Domain**: [Domain description]
- **Key Terminology**: [Important terms and definitions]
- **Primary Goals**: [Main project objectives]
- **Core Constraints**: [Technical or business constraints]
- **Quality Priorities**: [Performance, security, usability priorities]

## Development Principles
### YAGNI (You Aren't Gonna Need It)
- **Application Guidelines**:
  - Always question whether a feature is actually needed for current requirements
  - Prioritize features that solve immediate user needs
  - Defer implementation of "nice-to-have" features until they become necessary
  - Focus on minimal viable implementations before adding complexity
  - Regularly review backlog items to verify continued relevance

### SOLID
- **Single Responsibility Principle**:
  - Each module/class/component should focus on one specific aspect of functionality
  - Clear component boundaries based on responsibility domains
  - Function names should accurately reflect their singular purpose
  - Refactor when multiple responsibilities are detected in a single component

- **Open/Closed Principle**:
  - Design components to be extended without modifying existing code
  - Use interfaces, abstract classes, and composition over inheritance
  - Implement plugin architectures where appropriate
  - Favor configuration over code modification

- **Liskov Substitution Principle**:
  - Ensure derived classes can fully substitute base classes without altering behavior
  - Validate subclass implementations against base class contracts
  - Avoid subclass methods that violate base class expectations
  - Design by contract: maintain pre/post conditions

- **Interface Segregation Principle**:
  - Design small, focused interfaces specific to client needs
  - Avoid "fat" interfaces with methods that clients don't need
  - Split large interfaces into smaller, more specific ones
  - Clients should only depend on methods they actually use

- **Dependency Inversion Principle**:
  - Depend on abstractions rather than concrete implementations
  - Use dependency injection to provide implementations to components
  - Define clear interface contracts between system layers
  - High-level modules should not depend on low-level modules directly

### KISS (Keep It Simple, Stupid)
- **Application Guidelines**:
  - Choose the simpler solution when faced with multiple options
  - Avoid premature optimization or over-engineering
  - Use straightforward algorithms and data structures when they suffice
  - Value code readability and maintainability over cleverness
  - Break complex problems into smaller, manageable pieces

### DRY (Don't Repeat Yourself)
- **Application Guidelines**:
  - Identify and extract repeated logic into reusable components
  - Create shared libraries for common functionality
  - Use parameterization over code duplication
  - Balance DRY against introducing unnecessary abstraction
  - Apply appropriate design patterns to eliminate duplication

## Core Configuration
- **Context Optimization Strategy**: [How context will be managed]
- **Knowledge Retrieval Priorities**: [What information to prioritize]
- **Tool Utilization Preferences**: [Which tools to favor]
- **Response Formatting Guidelines**: [How responses should be structured]

## Interaction Patterns
- **Command Recognition**: [How to identify specific commands]
- **Custom Instructions**: [Project-specific instruction formats]
- **Workflow Interactions**: [Standard interaction sequences]
- **Response Templates**: [Templates for consistent responses]

## Code Implementation Guidelines
- **Coding Standards**: [Language-specific standards and conventions]
- **Documentation Requirements**: [Comment and documentation expectations]
- **Error Handling Approach**: [How errors should be handled]
- **Testing Expectations**: [Testing requirements and approaches]
- **Performance Considerations**: [Performance targets and considerations]

## Optimization Strategies
- **Context Management**: [How to optimize context usage]
- **Knowledge Compression**: [Techniques for knowledge compression]
- **Task Decomposition**: [How to break down complex tasks]
- **Implementation Sequencing**: [Order of implementation steps]
- **Validation Approach**: [How to validate implementations]

## Learning Parameters
- **Pattern Recognition**: [Thresholds for identifying patterns]
- **Knowledge Integration**: [How to incorporate new knowledge]
- **Template Adaptation**: [When and how to adapt templates]
- **Workflow Optimization**: [Metrics for workflow improvement]
- **Evolution Tracking**: [How to track system evolution]