# Features with Classes
[![License: MIT](https://img.shields.io/badge/License-MIT-green.svg)](https://opensource.org/licenses/MIT)
[![4D](https://img.shields.io/badge/Language-4D-2F6FED.svg)](https://www.4d.com/)
[![Last Commit](https://img.shields.io/github/last-commit/vdelachaux/features-with-classes)](https://github.com/vdelachaux/features-with-classes/commits/master)
[![Issues](https://img.shields.io/github/issues/vdelachaux/features-with-classes)](https://github.com/vdelachaux/features-with-classes/issues)

Feature flags for 4D applications, built with classes.

## Installation

Currently, this component is not yet available through the 4D dependency manager.

To use it in your project:

1. Copy the `feature` class from [Project/Sources/Classes/feature.4dm](Project/Sources/Classes/feature.4dm) to your project's `Sources/Classes/` folder.
2. Copy the class documentation from [Documentation/Classes/feature.md](Documentation/Classes/feature.md) to your project's documentation.

## Overview
Features with Classes helps you enable or disable application behavior safely, without scattering conditions all over your codebase.

## Why
Use this project when you need progressive rollout, safer releases, and fast fallback in production.

## Key Benefits
- Centralized feature activation logic
- Cleaner and more maintainable business code
- Progressive delivery ready
- Safer production toggles
- Better long-term readability

## Quick Start
1. Add the `feature` class to your 4D project.
2. Define explicit feature names.
3. Enable or disable features from one place.
4. Guard business behavior with a feature check.

Example:

```4d
// Setup
featureManager.enable("newInvoiceFlow")
featureManager.disable("betaColorMatching")

If (featureManager.isEnabled("newInvoiceFlow"))
	// New behavior
Else
	// Current behavior
End if
```

## Before / After
Before:

```4d
If ($isProd)
	If ($userRole="admin")
		// behavior A
	Else
		// behavior B
	End if
Else
	If ($testMode)
		// behavior C
	Else
		// behavior D
	End if
End if
```

After:

```4d
If (featureManager.isEnabled("advancedPermissions"))
	// behavior A
Else
	// behavior B
End if

If (featureManager.isEnabled("newTestFlow"))
	// behavior C
Else
	// behavior D
End if
```

## Release Strategy
- If a feature is not ready for a release, either remove its declaration line or mark it as pending.
- With a Git branch workflow, feature declarations should depend on the branch.
- In-progress features are declared in development branches, not in the production branch.

## Documentation
- Class documentation: [Documentation/Classes/feature.md](Documentation/Classes/feature.md)

## Open Source
Contributions are welcome: docs improvements, integration examples, and activation strategy ideas.

- Open an issue for ideas or bugs
- Propose a pull request with clear context
- Keep examples focused and practical

## Roadmap
- More real-world integration examples
- Environment-specific activation patterns
- Testing guidance for feature-driven flows

## License
MIT License.
