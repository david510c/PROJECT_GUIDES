# Project Template Guide

## Project Initialization Flow

### 1. Project Understanding Phase
```
When a new project request is received:
1. Identify project type and scope
2. Extract key requirements
3. Determine {$Project_Description}
4. Confirm understanding with user
```

### 2. Document Creation Phase
```
Create three core documents:
1. Project Guides/Project_and_Technical.md
2. Project_and_Technical.md
3. Project Guides/breakdown_and_tracking.md
```

### 3. Document Population Phase

#### A. Analysis StyleGuide Population
```
# {$Project_Description}_Analysis_StyleGuide.md

## Technical Foundation
- Domain-specific technologies
- Key frameworks and libraries
- Best practices and patterns
- Common pitfalls and solutions

## Implementation Patterns
- Proven implementation approaches
- Code organization strategies
- Error handling patterns
- Performance optimization techniques

## Web Scraping Specific Guidelines
- Rate limiting and throttling approaches
- DOM traversal best practices
- Dynamic content handling strategies
- Data extraction and validation techniques
- Anti-detection measures
- Error recovery and resilience patterns
- Output formatting and consistency

## Development Guidelines
- Coding standards
- Testing strategies
- Documentation requirements
- Review processes

## Evolution & Maintenance
- Update procedures
- Version control practices
- Migration strategies
- Deprecation handling
```

#### B. Project Documentation Setup
```
# Project Guides/Project_and_Technical.md

## Project Overview
- Project description
- Core objectives
- Key stakeholders
- Success criteria

## Current System Architecture
- System components
- Data flows
- Integration points
- Dependencies

## Requested Features & Changes
- Feature requirements
- Technical changes needed
- Implementation approach
- Success metrics

## Implementation Plan
- Phase breakdown
- Dependencies
- Milestones
- Timeline estimates
```

#### C. Task Tracking Structure
```
# Project Guides/breakdown_and_tracking.md

## Session Memory
[As per updated structure]

## Phase Tracking
[Current phase implementation]

## Status & Progress
[Active status updates]

## Session Insights
[Technical discoveries and decisions]
```

### 4. Project Execution Guidelines

#### A. Memory Management
```
Each session:
1. Load context from Session Memory
2. Update as work progresses
3. Capture new insights
4. Save session state before ending
```

#### B. Task Management
```
For each task:
1. Break into context-sized chunks
2. Execute with tool support
3. Document progress
4. Update session memory
```

#### C. Progress Tracking
```
Regular updates:
1. Mark task completion
2. Document technical findings
3. Update session state
4. Plan next actions
```

## Best Practices

### 1. Context Management
- Keep tasks within GPT context limits
- Use tools effectively for context loading
- Document context dependencies
- Maintain session state

### 2. Documentation Updates
- Real-time progress tracking
- Immediate insight capture
- Cross-document references
- Clear status indicators

### 3. Tool Usage
- Prefer semantic search for context
- Use appropriate tools for tasks
- Validate changes
- Document tool outcomes

### 4. User Interaction
- Clear progress indicators
- Simple yes/proceed responses
- Explicit next steps
- Status visibility

## Template Maintenance

### 1. Regular Updates
- Document successful patterns
- Remove obsolete sections
- Add new best practices
- Refine existing guidelines

### 2. Version Control
- Track template changes
- Document improvements
- Maintain backwards compatibility
- Version numbering

This guide should be treated as a living document, continuously improved based on project experiences and user feedback.