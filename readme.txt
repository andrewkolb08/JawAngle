Matlab code for calculating a subject's jaw angle.

This is done through two methods:

1.  Using a position-based method.  Placing a sensor on the lower midsagittal incisors and
	in the back of the mouth on the back-right molar.  The vector formed by these two sensors
	is compared with a vector that points out of the subject's mouth in the maxillary occlusal
	plane.
	
2.  Using an orientation-based method.  The method uses quaternion orientation data provided
	by the sensor on the midsagittal incisors and uses the vector given by its orientation
	data to find angle w/r/t a vector pointing out of the mouth in the maxillary occlusal plane.
	
	
An example subject is included in the code for testing, sub003_oe.  This contains a subject 
repeating "oo-ee-ow-ee" repeatedly as fast as they can.  Running finalJawAngle.m will plot
the calculated quaternion angle versus the position-derived angle.  

The code should be adapted for a user's specific purpose.  The best choice to adapt the code
is to modify getJawAngle.m.