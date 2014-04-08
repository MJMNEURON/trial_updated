# Trial Averaged Firing Rate
import os
import glob
import numpy as np

#path = '/home/major/trial/relay/mar_17/result_lum'

result = []
for ii in range (1, 5):
	os.chdir('/Users/jiemei/Desktop/combined_v2/trial/combined/result_cs_2/csr'+str(ii))
	non_blank_count=0
	for i in range (1, 11):
		with open('csr'+str(ii)+'_0'+str(i)+'.dat') as infp:
			
			for line in infp:
				if line.strip():
					non_blank_count+=1
			#print 'time', str(i+(ii-1)*10)
			count=float(non_blank_count)/10
	result.append(count)		
	print 'number of lines', str(non_blank_count), 'average', str(count)
	
print result
os.chdir('/Users/jiemei/Desktop/combined_v2/trial/combined')
