#1) histogram�� hist(table(x))���� �׷����� 2) correlation matrix�� cor(data)�� �����ø� �ǰ�, 3) ����м�#(correlation test)�� cor.test(y,x, method="pearson")�Դϴ�!
setwd("c:/R/FastCampus/project/")


library(nortest) # �����Ͱ� 5000�� �̻�.
library(dplyr)

# ���� �б�
par(mfrow=c(2,2))


###################################################################################
house <- read.csv(file   = "c:/R/FastCampus/project/kc_house_data.csv",
                 header = TRUE)
portion <- house[,c(3,9:12)]
###################################################################################

# �� variable���� histogram �ۼ�

variables <- c("waterfront","view","condition","grade")
for( i in 1:4 ){
  hist(table(portion[,i]), main = paste("Histogram of", variables[i]))
}
###################################################################################

# �͹����� : View(waterfront)�� ������ ������� price���� ���̰� ����.(mu1 = mu2)
# �븳���� : View(waterfront) ������ price�� ������ ��ģ��.(mu1>mu2)


house$view.group <- ifelse(house$view == 0,
                             "0", 
                             "1")

by(house$price, house$view.group, ad.test) # ���Լ�x

wilcox.test(house$price ~ house$view.group, # p-value : 1 �̹Ƿ� �븳���� ä��
            alternative = "greater")

# waterfront ����


house$waterfront.group <- ifelse(house$waterfront == 0,
                           "0", 
                           "1")
by(house$price, house$waterfront.group, ad.test) # ���Լ�x

wilcox.test(house$price ~ house$waterfront.group, # p-value : 1 �̹Ƿ� �븳���� ä��
            alternative = "greater")




# condition, grade ���� ���� ����.
house$condition.group <- ifelse(house$condition == 1,
                                 "1", 
                                 "2")
by(house$price, house$condition.group, ad.test) # ���Լ�x

wilcox.test(house$price ~ house$condition.group, # p-value : 1 �̹Ƿ� �븳���� ä��
            alternative = "greater")


house$grade.group <- ifelse(house$grade == 7,
                                "7", 
                                "8")

by(house$price, house$grade.group, ad.test) # ���Լ�x

wilcox.test(house$price ~ house$grade.group, # p-value : 1 �̹Ƿ� �븳���� ä��
            alternative = "greater")


# waterfront�� view�� 0�� �ƴ� ������ ��Ƽ� ������׷�
par(mfrow=c(2,1))

###################################################################################

is_waterfront <- dplyr::select(house, waterfront) %>%
  dplyr::filter(waterfront != 0)
hist(table(is_waterfront))



is_view <- dplyr::select(house, view) %>%
  dplyr::filter(view != 0)
hist(table(is_view))

table(house$waterfront)
###################################################################################

# scatterplot matrix
scatterplot_matrix <- pairs(portion)

## ���� sqft_above�� sqft_basement�� price�� ��� ������ �������踦 ���δ�. (Y�� X��)
## sqft_above�� sqft_basement�� ��� ������ �������踦 ���δ�.

# correlation matrix
correlation_matrix <- cor(portion)

# correlation test
cor.test(portion$waterfront, portion$view, method="pearson") # �����ϴ�(significant)
cor.test(portion$view, portion$price, method="pearson") # �����ϴ�(significant)

# ȸ�ͺм��� ���(coefficient) ��Ȯ�� ������ ���� OLS�� �����ϴµ�, �� ���� ���� ��
# �ϳ��� ��������(X)�鳢�� �����̶�� ���̴�. �̷� �� ��, yr_built�� sqft_above��
# ������� �ִٴ� ���� multicollinearity(���߰�����) ������ �߻��� �� �ִ�.