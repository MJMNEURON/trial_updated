# Trial Averaged Firing Rate
import os
import glob
import numpy as np

#path = '/home/major/trial/relay/mar_17/result_lum'

result = []
for ii in range (1, 7):
	os.chdir('/home/major/trial/relay/mar_17/result_lum/lumr'+str(ii))
	non_blank_count=0
	for i in range (1, 11):
		with open('lumr'+str(ii)+'_0'+str(i)+'.dat') as infp:
			
			for line in infp:
				if line.strip():
					non_blank_count+=1
			#print 'time', str(i+(ii-1)*10)
			count=float(non_blank_count)/10
	result.append(count)		
	print 'number of lines', str(non_blank_count), 'average', str(count)
	
print result
os.chdir('/home/major/trial/relay/')
