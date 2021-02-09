#############################################
#Dive Into Algorithms
#Application of Chapman's Algorithm
#############################################
#Problem: How does an outfielder know where to run when a baseball is hit?

#1.1 The Analytic Approach
##Create a function for calculating the trajectory of a ball (Pg. 3)
def ball_trajectory(x):
    location = 10*x - 5*(x**2) #note: ** is exponentiation, therefore the equation reads 10x - 5x^2
    return(location)
##Plot the function to see the what the ball's trajectory should look like
import matplotlib.pyplot as plt
xs = [x/100 for x in list (range(201))] #creates a sequence of numbers from 0/100 to 201/100 (e.g. 0, 0.1, 0.2...2.0)
ys = [ball_trajectory(x) for x in xs] #executes the ball trajectory function looping on the xs range created previously
plt.plot(xs,ys)
plt.title('The Trajectory of a Thrown Ball')
plt.xlabel('Horizontal Position of Ball')
plt.ylabel('Vertical Position of Ball')
plt.axhline(y=0) #creates a reference line at specified y value
plt.show()
#1.2 The Algorithmic Approach
##create line segment representing the outfielder's eyes
xs2 = [0.1,2]
ys2 = [ball_trajectory(0.1),0]
xs3 = [.2, 2]
ys3 = [ball_trajectory(0.2),0]
xs4 = [0.3,2]
ys4 = [ball_trajectory(0.3),0]
##create plot of a throown ball with lines of sight
plt.title('The Trajectory of a Thrown Ball - with Lines of Sight')
plt.xlabel('Horizontal Position of Ball')
plt.ylabel('Vertical Position of Ball')
plt.plot(xs,ys,xs2,ys2,xs3,ys3,xs4,ys4)
plt.show()
##As the ball progresses after the hit, the angle between the ground and the outfielder's line of sight increases (call this theta)
##We assume that the outfield is standing at the ball's landing spot (x = 2)
##In geometry, the tangent of an angle in a right triangle is Opposite over Adjacent (SOHCAHTOA)
###Thus, the tangent of theta is the ratio of the height of the ball to its horizontal distance from the outfielder
#Plot the sides whose ratio constitutes the tangent
xs5 = [0.3, 0.3]
ys5 = [0, ball_trajectory(0.3)]
xs6 = [0.3,2]
ys6 = [0,0]
plt.title('The Trajectory of a Thrown Ball - Tangent Calc')
plt.xlabel('Horizontal Position of Ball')
plt.ylabel('Vertical Position of Ball')
plt.plot(xs,ys,xs4,ys4,xs5,ys5,xs6,ys6)
plt.text(0.31,ball_trajectory(0.3)/2,'A',fontsize = 16)
plt.text((0.3 + 2)/2,0.05,'B',fontsize=16)
plt.show()