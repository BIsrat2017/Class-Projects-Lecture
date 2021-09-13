# Sesait Asefaw
# CSS 110 Intro to programing 
# Homework o6 
# a program that draws a line grid 
# and a boomerang that are called from the main function of the program 

import Gui

CANVAS_WIDTH = 1000
CANVAS_HEIGHT = 1000

# function that draws a line grid
# Given the coordinates of the left line's top point and
# the height of the line grid. Successive lines are drawn with shifted endpoints
# height: height of the line grid 
# x,y : the coordinates of the left line's top point
# lines: the number of lines
# color: the color of the line grid 
def line_grid(height, x, y, lines, color):

    grid_length = height/(lines - 1)
    
    point_y = y + height
    canvas.line([[x,y],[x, point_y]],fill = color)
    
    for i in range(lines-1):
        x = x+grid_length
        canvas.line([[x,y],[x, point_y]],fill = color)
        
# function that draws a boomerang 
# A  boomerang either opens left or right.
# A boomerang has at least one circle, the starting circle
# x,y : cordinates of the boomerang firt circle 
# color : color of the circles outline
# open_left: if true the boomerang opens left, right otherwise
# number of circles: the number of circles in each arm
# r: radius of one cirlce 
def boomerang(x, y, r, color, open_left, number_of_cirlces):

    canvas.circle([x,y], r,outline = color)
    
    if(open_left):
        x1=x
        y1=y
        for i in range(number_of_cirlces):
            x1 = x1 - 2*r
            y1 = y1 - r
            canvas.circle([x1,y1], r,outline = color)

            x = x - 2*r
            y = y + r
            canvas.circle([x,y], r,outline = color)

    else:
        x1=x
        y1=y
        for i in range(number_of_cirlces):
            x1 = x1 + 2*r
            y1 = y1 + r
            canvas.circle([x1,y1], r,outline = color)

            x = x + 2*r
            y = y - r
            canvas.circle([x,y], r,outline = color)




    

def main():

    line_grid(120,-200,300,20,'green')

    line_grid(200,135,250,5,'purple')
    
    line_grid(90,-300,-280,8,'red')



    boomerang(0,0,10,'blue',True,15)
    boomerang(-100,-200,5,'red',False,10)






win = Gui.Gui()
win.title('Playing around with Gui')
canvas = win.ca(width = CANVAS_WIDTH, height = CANVAS_HEIGHT)

main()

win.mainloop()


# I start this homework by drawing a line grid and a boomerang on graph paper 
# I start coding one function at a time, and testing as I go.
# I get stuck when i was writing the boomering second circle center coordinates 
# I test my program using the provided parameters and throwing a random values
# and observing the changes on the line grid or boomerang and evrythiing worked as expected
# from this Assigneemnt I learned how to draw different shapes using python Gui
# Next time i see my self applying the things i have learned to expand on different drawing 
#
#
