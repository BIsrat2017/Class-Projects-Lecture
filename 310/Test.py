# Sample program that uses the GUI package
# You should type in other calls to the methods of the canvas object to become familiar
# with the syntax


CANVAS_WIDTH = 900
CANVAS_HEIGHT = 550

from Gui import *

def main():
    canvas.circle([50, 100],20, fill = 'yellow')
    canvas.rectangle([[-300, -150], [0,0]], outline='blue', fill = 'red', width = 5)
    canvas.line([[50,100], [50, 200]], fill = 'magenta')
    canvas.polygon([[-50, 0],[0, 50], [50, 0]] , width = 10, fill = 'cyan')




###################################################################
# Feel free to read what's here, but do not change

g = Gui()
g.title('Sample code for week 4')

# canvas is the drawing area
canvas = g.ca(width = CANVAS_WIDTH, height = CANVAS_HEIGHT)
main()
g.mainloop()
