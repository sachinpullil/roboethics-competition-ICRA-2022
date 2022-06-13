# ICRA 2022 Roboethics Hackathon - Submission by Sachin Pullil

UPDATE (June 2022): To try this solution, clone this repository and run 'roboethics.pde'.

For my submission, I chose to implement my team's proposal - the Ethical Home Robot.

The following features from the proposal have been successfully implemented in the Processing project.
- Data privacy
The user has control over the data that is collected from the fetch requests. They can click on the 'Privacy Settings' button, turn OFF data recording, and proceed to complete fetch requests. If they want to turn it back ON, they can do so through the same panel. Also, the user can see the data that is collected from their activity within the same panel. Thus, I was successfully able to implement our vision for privacy of the user when handling the robot.
- Operator roles and item classes
In our proposal, we assigned role tags to each potential user of the robot. We also assigned classes for each item. This allows us to classify both in general contexts and apply rules for the fetch accordingly.
- Access rule table
We use a table to determine whether a particular user should have access to a certain object. This is essentially the crux of our proposal. Users can access this table by clicking on the  'View access rule table' button. This allows us to exercise our principle of transparency.
- Ability to change permissions of users
I have also implemented the ability to change permissions of users. For example, if there is a responsible teenager, the parent can decide to make them a full user and give them access to items that may not be recommended for young adults, like alcohol. This is to reflect the user autonomy principle we followed during design.
- Ability to add new users and items
To allow users to experiment with different items and operators, I've added functionality to add both through a button on the main screen.
- Infeasible and dangerous to robot
Items that are infeasible to fetch or are dangerous to the robot have been designed to be rejected.
- Offering to call emergency services
In our proposal, we suggested that the robot could ask if it should call emergency services if an item of the emergency class was fetched. In this implementation, I have designed the robot to ask this question after fetching such an item.
- Informing human of dangerous items
We also suggested that the robot should inform the human when a dangerous item has been fetched. This has been incorporated in the code.

However, a few key features of the proposal could not be implemented due to a lack of time or design complexity.
- Emergency override mode
We proposed that the robot have an emergency mode where it would only fetch emergency items and would take orders from anyone. This was not implemented here.
- Cognitive test
We also proposed that if the user seems to be in an unstable mental condition, the robot would perform a quick cognitive test. However, this could not be implemented because further deliberation is necessary to determine how the robot can understand if a person is unstable and what kind of test should be administered.
- Safety during execution
In this implementation, the access-rule table takes care of most of the safety precautions. There have been no additions to the code to determine if the robot is safely executing the task.
- Flexible access table
In the proposal, the administrator had the discretion to change certain permissions of a specific type of user, like a Partial User.
- User-defined class
To further improve the autonomy of the user, we suggested allowing user-defined classes where the administrator could define which items are allowed for such a class to fetch and which ones are banned.
- User-defined ban
Similarly, we also proposed allowing the user to ban certain items in their house for all users except the admin.

Key considerations:
- I realized that the program recognized the dog and the baby as potential users. This was not considered by our proposal. Hence, I made them as non-users and gave them no power to fetch an item.
- In our design of the proposal and my implementation in this project, we intentionally ignored the recipient of the item in the decision-making process. This is to align with our principle of autonomy. The individual ordering the fetch, if they have permission to fetch the item, will be given autonomy in deciding how to use the item and where it should be delivered.


# Added files:
1. Image for water
2. Image for person
3. Image for thing
4. Image for fire extinguisher
5. Image for access-rule table

# Files with major changes:
1. Character.java
Added operator role tag functionality.
2. Item.java
Added item class tag functionality.
3. Controller.pde
Now tests whether requested user has access via the access-rule table for the targeted item. Allows fetch if check is passed and rejects request if table disallows it.
4. GUI.pde
Added buttons to change privacy settings, user roles, add new users and items, and see the access-rule table.
5. Scenario.java
Initialized operators and items with roles and class tags, respectively.

# Files with minor changes:
1. Entity.java
2. Roboethics.pde
