Assessment: Field Task – Location-Based Task
Management App
Scenario
Your organization manages a team of on-field agents who carry out inspections, deliveries, and
maintenance visits at different client locations every day.
Currently, agents report their visits manually using phone calls and messages, which leads to delays,
missing records, and confusion in reporting.
You have been asked to design and build a mobile application that allows agents to manage and update
their daily field tasks in real time — using location-based check-ins and offline support for areas with
poor connectivity.
Project Objective
The “Field Task” App should allow agents to:
• View, manage, and complete their daily field assignments.
• Automatically verify their presence at task locations using GPS.
• Continue working even when offline, with data syncing when back online.
User Flow
1. View Assigned Tasks – See all tasks for the day in a scrollable, paginated list, showing the
task title, description, deadline, and status.
2. Search and Filter Tasks – Quickly search tasks by title.
3. Create a New Task – Add a new field task manually by entering details (title, description, due
time) and marking the task location on a map.
4. View Task Details – Tap a task to open a detailed view that includes a map preview of the
location, full description, and any attached notes or media.
5. Check-In at Location – When physically near the task location, the agent can check in to
confirm presence. The app should verify proximity (e.g., within 100 meters) before allowing
check-in.
6. Complete a Task – Agents can mark tasks as completed if agent is in the located area. Other
Agent Can not complete the task.
7. Offline Usage – Agents should still be able to view cached tasks offline. All updates must
automatically sync once the device reconnects to the internet.

Key Expectations
The app should:
• Deliver a smooth, intuitive, and reliable experience.
• Handle large lists efficiently using pagination.
• Verify user location accurately for check-in validation.
• Store data locally.
• Maintain a clear and organized code structure with good readability.
• Follow a clear architectural pattern suitable for a medium-sized app. Keep UI separate from
business logic.
• Use a consistent state-management approach with unidirectional data flow and predictable
state transitions.
Deliverables
• A GitHub public repository containing the full project code.
• A /dist folder containing the generated APK file.
• A README file briefly explaining:
o App flow and feature summary
o Offline and syncing approach
o Design or architectural decisions made