# read in file
with open('texfile.tex.txt', 'r') as file:
    data = file.readlines()

    
# dictionary of our replacements
replDict = { "incentivefee" : "Incentive Fee",
    "managementfee" : "Management Fee",
    "size\_ass" : "Size_t",
    "pastreturns" : "R_{t-1}",
    "past2returns" : "R_{t-2}",
    "past3returns" : "R_{t-3}",
    "past4returns" : "R_{t-4}",
    "past5returns" : "R_{t-5}",
    "past6returns" : "R_{t-6}",
    "pastflow\\_ass" : "Flow_{t-1}",
    "past2flow\\_ass" : "Flow_{t-2}",
    "past3flow\\_ass" : "Flow_{t-3}", 
    "pastvolatility" : "\\sigma_{t-1}",
    "ln\\_min\\_inv" : "Log Minimum Investment",
    "highwatermark" : "High Watermark",
    "personalcapital" : "Personal Capital",
    "opentopublic" : "Open to Public",
    "leveraged" : "Leveraged",
    "onshore" : "Onshore",
    "vwretd" : "S\\&P_t",
    "tmytm" : "\\textrm{Three Month Risk-Free Rate}_t",
    "vix" : "\\textrm{CBOE Volatility Index}_t",
    "agg6returns" : "R^*_{t-6}",
    "agg3flow\_ass" : "Flow^*_{t-3}",  
    "\_cons" : "Intercept",
    "\(N\)"  : "Obs",
    "N\_clust" : "Cluster",
    "r2\_a" : "\\textrm{Adjusted} R^2",
    "r2\_w" : "R^2 \\textrm{ within}",
    "r2\_b" : "R^2 \\textrm{ between}",
    "r2\_o" : "R^2 \\textrm{ overall}",
    "F" : "F-\\textrm{statistic}"
}

# when we get to the intercept term, switch goes to 0
switch = 1
# copy first 8 lines (0-7)
newData = []
newData[0:8] = data[0:8]

# then start from 8 and copy the rest
for i in range(8,len(data)):
    line = data[i]
    title = line.split("&")[0].strip(' ')
    

    
    
    if switch:
        if title in replDict:
            
            #coefficients
            lineList = line.split("&")
            lineList[-1] = line.split("&")[-1].split("\\")[0] + "\\\\[-0.2cm]" + "\r\n"
            writeMe = ' &'.join(lineList).replace(title, replDict[title])
            newData.append(writeMe)

            #standard errors
            lineList = data[i+1].split("&")
            lineList[-1] = data[i+1].split("&")[-1].split("\\")[0] + "\\\\[-0.1cm]" + "\r\n"
            writeMe = ' &'.join(lineList)
            newData.append(writeMe)
            
        # two lines at a time to have the standard errors
        i = i + 2
    else:
        if title in replDict:
            #values
            lineList = line.split("&")
            lineList[-1] = line.split("&")[-1].split("\\")[0] + "\\\\[-0.2cm]" + "\r\n"
            writeMe = ' &'.join(lineList).replace(title, replDict[title])
            newData.append(writeMe)
        i = i + 1
        
    if title == "\_cons":
        switch = 0
        
with open('outtex2.txt', 'w') as file:
    file.writelines(newData)