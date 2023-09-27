library(dagitty)
library(lavaan)

g <- dagitty(
  'dag {
    PA [exposure,pos="0, 0"]
    LTCs [pos="1.5, -1"]
    Obesity [pos="0.5, -1"]
    Sociodemographics [pos="1, 0.5"]
    HbA1c [outcome,pos="2, 0"]
    HbA1c -> LTCs
    Obesity -> HbA1c
    PA -> LTCs
    PA -> HbA1c
    PA -> Obesity
    Sociodemographics -> HbA1c
    Sociodemographics -> PA
    Sociodemographics -> Obesity
    Sociodemographics -> LTCs
  }')

tiff('./export/Fig1-DAG.tiff', res=300, height=750, width=1250, compression='lzw')
plot(g)
dev.off()
adjustmentSets(g)
