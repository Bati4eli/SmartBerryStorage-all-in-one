---
name: android-build-and-publish
description: Build and publish the SmartCloud Android debug APK when the user explicitly requests release publication. Do not use for ordinary builds, installs, or emulator testing.
disable-model-invocation: true
---

# Android Build And Publish

Run this workflow only after explicit user authorization to publish.

- Work in `SmartCloud-Android`; never run Gradle from the workspace aggregator root or the backend repository.
- Before publishing, prepare concise user-facing release notes from the changes included in this APK. Do not reuse the previous release's notes.
- Use the project task name exactly: `./gradlew.bat BUILD_AND_PUBLISH`. `buildAndPublish` is not a Gradle task in this project.
- After a successful task, read `app-update.properties` in the published directory to obtain the actual version. Overwrite `<published-directory>/diff.txt` before reporting completion. This is a required part of every publication.
- Write `diff.txt` in Markdown: a level-one heading `# SmartCloud <version>`, then only relevant level-three sections such as `### ✨ Новое`, `### 🐛 Исправления`, `### ⚡ Улучшения`, with short `-` bullet points under each. Describe user-visible results; omit implementation details, file names, and empty sections.
- Verify `diff.txt` exists, its version matches `app-update.properties`, and its Markdown has a heading and at least one bullet. Report the published version, destination, and that the user changelog was updated.
- On build failure, report the failing output and do not change `diff.txt`. If writing or validating `diff.txt` fails after the APK is published, report the publication as incomplete; do not retry a different publishing task or publish from another repository without user direction.
