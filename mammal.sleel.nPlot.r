# Libraries
library(rCharts)
# I took data from ggplot2 package
library(ggplot2)
data(msleep)
colnames(msleep)
data<-na.omit(msleep[,c("order","genus","vore","sleep_total","sleep_rem","bodywt","brainwt","awake")])

# traits for size of circle (brainbody) and for point-annotations (brainbodyP) 
data$brainbody<-100*data$brainwt/data$bodywt+1
data$brainbodyP<-round(100*data$brainwt/data$bodywt,2)
data$color<-as.numeric(data$vore)

# trait for color of points, "vore" variable, in RGB format
ramp <- colorRamp(data$color)
col.pch <- rgb(ramp(seq(0, 1, length = length(data$vore))), max = 255)
data$color <- col.pch

# nvd3 plot form rCharts
# evth between these symbols '#! .... !#' is javascript, which will be read by function nPlot
# d.brainbody means that function should ask dataset (d) for variable "braindody" 
p1 <- nPlot(sleep_total ~ sleep_rem, group = 'vore', data = data, 
            type = "scatterChart",width=600,height=500)
p1$chart(size = '#! function (d) {return d.brainbody } !#' )
p1$chart(color = c(unique(data$color)))

# with arguments "forceY" and "forceX" - set limits of axes.
p1$chart(forceY = c(0, 22))
p1$chart(forceX = c(0, 6.5))
p1$xAxis(axisLabel = 'REM sleep, hours')
p1$yAxis(axisLabel = 'Total sleep, hours')

# specify which information to be seen in point annotations ("tooltipContent")
p1$chart(tooltipContent = '#! function (key,x,y,e){
         return \'Order: \' + e.point.order + \'<br/>\' + 
         \'Genus: \' + e.point.genus + \'<br/>\' + 
         \'Brain/Body = \' + e.point.brainbodyP + \'%\' } !#' )

# to see chart in Viewer of RStudio
p1

# save chart as standalone html page in working directory
p1$save('Mammal_Sleep_mychart2.html', standalone = TRUE)

# publish from RStudio to gist (github account is required!)
p1$publish('Mammal sleep', host = 'gist')
# If evth is OK, then such info appeared in console:
#       Your gist has been published
#       View chart at http://rcharts.github.io/viewer/?92be822df58f6185ddab

### SOME other features
# change tick formats - from simple digits, like 18, to 18%
# p1$yAxis(tickFormat = "#! function(d) {return d + '%'} !#")
# p1$xAxis(tickFormat = "#! function(d) {return d + '%'} !#")
# p1$chart(showLegend = TRUE)
# p1$chart(showDistX = TRUE, showDistY = TRUE) ## works well for raw plot (without other changes in p1$chart)
### set size of plot
# p1$set(width=500,height=400)
### to show all variables in point annotation:
# p1$chart(
#         tooltipContent = '#! function(x,y,e,graph){
#         return d3.entries(graph.point).map(function(key){
#         return key.key +  \': \' +  key.value;
#         }).join(\'<br>\');
#     } !#'
#         )
