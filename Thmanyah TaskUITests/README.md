# UI Tests for Thmanyah Task

## Overview
Comprehensive UI test suite covering Home and Search views with integration testing.

## Test Structure

### 📱 **HomeViewUITests**
- Initial loading and navigation
- Content interaction (scrolling, refresh)
- Error states and retry functionality  
- Accessibility compliance
- Device rotation and performance

### 🔍 **SearchViewUITests**
- Search functionality and debouncing
- Results display and interaction
- State persistence across navigation
- Error handling and recovery
- Performance and accessibility

### 🔄 **HomeSearchIntegrationTests**
- Cross-navigation state management
- Memory management during extended usage
- Error isolation between views
- Performance under load
- Device orientation changes

### 📱 **TabBarUITests**
- Tab bar structure and accessibility
- Navigation between all tabs
- Tab selection and visual states
- Content preservation across tabs
- Performance and memory management
- Error recovery and edge cases

### 🎛 **CustomTabBarUITests**
- Custom tab bar component testing
- Tab item visual states and interactions
- Layout and spacing verification
- Accessibility compliance
- Performance under load
- State management

### 🏗 **MainTabViewUITests**
- Main tab view structure and layout
- Content switching and transitions
- State persistence across navigation
- Memory management optimization
- Integration with dependency injection
- Device state changes handling

### 🛠 **BaseUITestCase**
- Common setup and teardown
- Helper methods for element detection
- Tab navigation utilities
- Accessibility verification
- Performance measurement tools
- Text input helpers (clearAndEnterText, performSearch)

### 📝 **TextInputUITests**
- Text input helper method testing
- Search field detection and interaction
- Text clearing strategies verification
- Special character handling
- Rapid operation stability testing

## Running Tests

### Single Test Class
```bash
# Home View Tests
xcodebuild test -scheme "Thmanyah Task" -destination 'platform=iOS Simulator,name=iPhone 15' -only-testing:Thmanyah_TaskUITests/HomeViewUITests

# TabBar Tests
xcodebuild test -scheme "Thmanyah Task" -destination 'platform=iOS Simulator,name=iPhone 15' -only-testing:Thmanyah_TaskUITests/TabBarUITests

# Custom TabBar Tests
xcodebuild test -scheme "Thmanyah Task" -destination 'platform=iOS Simulator,name=iPhone 15' -only-testing:Thmanyah_TaskUITests/CustomTabBarUITests

# Main TabView Tests
xcodebuild test -scheme "Thmanyah Task" -destination 'platform=iOS Simulator,name=iPhone 15' -only-testing:Thmanyah_TaskUITests/MainTabViewUITests

# Text Input Utility Tests
xcodebuild test -scheme "Thmanyah Task" -destination 'platform=iOS Simulator,name=iPhone 15' -only-testing:Thmanyah_TaskUITests/TextInputUITests
```

### All UI Tests
```bash
xcodebuild test -scheme "Thmanyah Task" -destination 'platform=iOS Simulator,name=iPhone 15' -only-testing:Thmanyah_TaskUITests
```

### Specific Test
```bash
xcodebuild test -scheme "Thmanyah Task" -destination 'platform=iOS Simulator,name=iPhone 15' -only-testing:Thmanyah_TaskUITests/HomeViewUITests/test_homeView_shouldLoadSuccessfully
```

## Key Features

### 🎯 **Robust Element Detection**
- Multiple selector strategies (accessibility identifier, button, text)
- Fallback mechanisms for different UI implementations
- Custom tab element detection for custom TabBar
- Smart search field detection across different views

### 📝 **Text Input Utilities**
- `clearAndEnterText()` - Reliable text clearing and entry
- `forceClearText()` - Alternative clearing using double-tap
- `clearTextWithBackspace()` - Character-by-character deletion
- `findSearchField()` - Cross-view search field detection
- `performSearch()` - Complete search operation helper

### ⚡ **Performance Monitoring**
- App launch time measurement
- Memory usage during extended operations
- CPU utilization during scrolling/searching
- Response time for user interactions

### ♿ **Accessibility Testing**
- Comprehensive accessibility compliance checks
- Tab navigation accessibility
- Interactive element verification
- Screen reader compatibility

### 🔄 **State Management Testing**
- Navigation state persistence
- Search query maintenance
- Loading state verification
- Error state recovery

## Troubleshooting

### Common Issues

1. **Tab Not Found**: 
   - Check accessibility identifiers in CustomTabBar
   - Verify tab names match TabItem.rawValue
   - Use findTabElement() helper method

2. **Element Not Hittable**:
   - Wait for element using waitForElement() helper
   - Check if element is covered by other views
   - Verify element is actually interactive

3. **Timing Issues**:
   - Increase timeout values for slow operations
   - Use waitForLoadingToComplete() for async operations
   - Add expectContentToLoad() for content verification

4. **Flaky Tests**:
   - Add takeScreenshot() for debugging
   - Use verifyAppIsResponsive() to check app state
   - Implement retry mechanisms for network-dependent tests

## Best Practices

1. **Always inherit from BaseUITestCase** for common functionality
2. **Use helper methods** like navigateToTab() and findTabElement()
3. **Add accessibility identifiers** to UI elements for reliable testing
4. **Test real user scenarios** not just happy paths
5. **Include performance and accessibility tests** in your suite
6. **Use descriptive test names** that explain the scenario
7. **Group related tests** with MARK comments for organization

## Adding New Tests

When adding new UI tests:

1. Inherit from `BaseUITestCase`
2. Use existing helper methods when possible
3. Add accessibility identifiers to new UI elements
4. Include both positive and negative test cases
5. Test accessibility and performance aspects
6. Add integration tests for cross-view interactions