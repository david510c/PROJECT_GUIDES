# GitHub Copilot Agent Entry Instructions

## Initialization Command
When starting a new project or session, begin with:
```
Please initialize as a GitHub Copilot agent using the guides in Project Guides/. Start by reviewing Comprehensive_Project_Technical_Style_Reference.md to understand the project structure and technical requirements. Then, help me [task description].
```

## Reading Order
1. First Pass:
   - Project Guides/GPT_Config.md - Understand your capabilities
   - Project Guides/Comprehensive_Project_Technical_Style_Reference.md - Deep project structure
   - Project Guides/Template_Guide.md - Document templates and patterns

2. Second Pass:
   - Project Guides/breakdown_and_tracking.md - Current state and memory
   - Project Guides/Project_and_Technical.md - Project specifics
   - Any domain-specific StyleGuides

Note: Start_Here_Prompt.md is a guide for users to understand how to interact with this system, not for agent initialization.

## Best Practices
1. **Memory Management**
   - Always start by loading session memory
   - Update context after each significant task
   - Document technical discoveries immediately
   - Save session state before ending

2. **Tool Usage**
   - Prefer semantic_search for context
   - Use edit_file for all changes
   - Run commands through terminal tools
   - Validate all changes with get_errors

3. **Documentation**
   - Follow three-tier system
   - Keep cross-references updated
   - Use clear status indicators
   - Maintain chronological order

## Common Commands
```
Initialize: "Please initialize as a GitHub Copilot agent..."
Continue: "Yes" or "Proceed"
Status Check: "Status"
Details Request: "Details"
```

## Success Criteria
1. Session memory is loaded and maintained
2. Tools are used appropriately
3. Documentation is kept updated
4. Progress is clearly tracked
5. Context is efficiently managed

## Documentation Update Detection

### Milestone Detection Rules
1. Check for milestone indicators:
   - New version numbers in files
   - Completed phases in breakdown_and_tracking.md
   - Major feature completion markers
   - Breaking changes in implementation

2. Monitor documentation triggers:
   - New extraction methods
   - Core functionality changes
   - Data structure modifications
   - Performance optimizations
   - Security enhancements

### Update Protocol
When a milestone or significant change is detected:
1. Review Project_and_Technical.md milestone tracking
2. Check breakdown_and_tracking.md milestone status
3. Compare with CHANGELOG.md entries
4. Notify user if documentation updates are needed

### Documentation Checklist
On detecting milestone completion:
- [ ] Verify version numbers are consistent
- [ ] Ensure CHANGELOG.md is updated
- [ ] Update technical documentation
- [ ] Review configuration examples
- [ ] Update troubleshooting guides
- [ ] Verify implementation details
- [ ] Check for breaking changes

### User Notification Format
```
🔔 Major Milestone Detected: [Description]
Documentation updates required:
1. [Specific update needed]
2. [Specific update needed]
...
Suggested actions:
- Update CHANGELOG.md with version [X.Y.Z]
- Document new [feature/pattern/configuration]
- Update technical documentation for [component]
```

Remember: Always validate understanding and maintain session state through the Project Guides/breakdown_and_tracking.md file.