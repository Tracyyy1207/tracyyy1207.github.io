# Final Report

## By: Ming Wang, Yumingxuan Guo, Pai Zheng, Yijin Wang

1. **Please list out changes in directions of your project if the final project is different from your original proposal (based on your stage 1 proposal submission).**

   We did not change the directions of our project, but we narrowed down the scope by using several main schemas to implement the final application with necessary but less functions.

2. **Discuss what you think your application achieved or failed to achieve regarding its usefulness.**

   While our application has successfully achieved the functionality of searching for information about particular airlines and routes, it has not been able to make plans for the users.

3. **Discuss if you change the schema or source of the data for your application.**

   We did not change the source of the data, but we did made a few changes in the schemas in order to make the relationships between tables more reasonable.

4. **Discuss what you change to your ER diagram and/or your table implementations. What are some differences between the original design and the final design? Why? What do you think is a more suitable design? **

   We have modified a few table schemas during our implementation. For instance, we have added the field “route” into our “Airline” table, so that the user can gain more information between the available flight routes and the airline companies.

5. **Discuss what functionalities you added or removed. Why?**

   While we removed the function of making travel plans for the customers (as time does not allow that), we have add two functions that include advanced queries: selecting the destination airports of all routes whose source airport belongs to a route of a particular airline; for each city whose name starts with a particular letter, selecting the number of routes whose source airport is in this city. These two advanced queries gives the users a more comprehensive understanding of the relationship between airlines, airports, and routes.

6. **Explain how you think your advanced database programs complement your application.**

   The advanced database queries enable users to perform complex, precise searches. They give the user a more comprehensive view of the airline data.

7. **Each team member should describe one technical challenge that the team encountered. This should be sufficiently detailed such that another future team could use this as helpful advice if they were to start a similar project or where to maintain your project. **

   **Yijin Wang:**

   The true application design is more time-consuming than what we originally thought, since we ended up spending a lot of time on the maintenance and making the basic function work after implementing and adding each advanced function to our application. Also, it is sometimes difficult to realize your code such as the trigger and the stored procedure to the final application, since they need to fit with your overall data model perfectly.

   **Ming Wang:**

   The technical challenges I encountered implementing the interface using JavaScript. Queries and operations are not difficult to implement, but designing the html interface is something quite new and not covered in class. The way I conquered this technical challenge is starting early, and generally learning how javascript and html work.\

   **Yumingxuan Guo:** 

   Coordinating on the online platform seems most challenging to me. We need to implement our application online by incorporating the online server, virtual machine, and the webpages, which takes a lot of effort to make things work. I would recommend to get familiar with the online platforms as early as possible, so that the platform protocols would not become obstacle.

   **Pai Zheng:**

   One technical challenge that I faced was to set up the virtual machine and SQL servers on GCP. We learnt from the class how to write a web page and what command to use in SQL, but we did not really know how everything was built to work. Through the development process, we learnt how to install all the components needed for the server as well as how to connect it to the SQL server. It could be very helpful to watch a comprehensive tutorial video on how to build website on GCP.

8. **Are there other things that changed comparing the final application with the original proposal?**

   The actual users’ interface is different from our original scratch.

9. **Describe future work that you think, other than the interface, that the application can improve on.**

   In terms of the system optimization, we could make the application to cost less and at the same time make the queries more efficient. We could also work on the plan-making functionality that we did not implement.

10. **Describe the final division of labor and how well you managed teamwork. **

    **Ming Wang:**

    Interface; CRUD & advanced query implementation for stage4; and database deployment on GCP.

    **Yijin Wang:** 

    Interface; UML diagram; Two advanced SQL queries creation; triggers.

    **Yumingxuan Guo:** 

    Coordinating group progress; project proposal; UML diagram, database implementation and indexing; CRUD for stage 5;

    **Pai Zheng:** 

    GCP setup; web development; database implementation; triggers and procedures in SQL.
