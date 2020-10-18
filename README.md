# Markowitz Model Portfolio Optimization

  Using the daily trading data from the last five years a Markowitz portfolio optimization is made for six assets.  The six stocks are Apple, Coke, Home Depot, Qualcomm, Tesla and Walmart.  The Markowitz model of portfolio optimization is to find the maximum return while minimizing the risk of a given portfolio.  The parameters that are found to accomplish the objectives are the percentages of the investment to invest in each available asset.  
   
https://en.wikipedia.org/wiki/Modern_portfolio_theory
   
The parameters are chosen out of a 60000 by 6 random matrix.  For each set of weights the return and risk are calculated.  An optimal value can be chosen but normally there is a trade off when dealing with multiple objectives.  A Pareto front is a selection of objectives that are non dominant over all of other solutions.  Having solutions that are non dominant allows for a trade-off between what is desired.  Since our goal is to have a maximum return with minimum risk or variance, each portfolio in our non dominated list will have a trade-off between objectives.  No one portfolio is strictly better than the
next portfolio in both objectives.  For this purpose if a a higher return is desired then the risk would also increase.  If a lower risk is desired then a lower return would be the result.  Moving from one solution in our Pareto fronteir to the next would have to result in this tradeoff. The graphs of the data and the pareto curve are as follows:

![Data and pareto](https://user-images.githubusercontent.com/58529391/95814311-efbefe80-0cce-11eb-9406-fcdd67405d23.png)

![Pareto](https://user-images.githubusercontent.com/58529391/95814331-f9486680-0cce-11eb-99d4-31254598160a.png)

  An investor will be comfortable with a certain amount of risk.  We can see that the maximum return on our Pareto fronteir is about .18 percent daily or 200% over 5 years.  This could be more and it could be less.  The daily risk for the same return is 2.6% each day.  This is the dispersion or variance around the expected return of the portfolio.  The return of the portfolio can be off of the expected return each day by 2.6%.  This amount of risk might be too much for some investors because if the 
dispersion is in a negative direction each day then the portfolio could instead lose 200% of its value over the 5 year time period, which is impossible because the portfolio could eventually be worthless and not negative in value.  A way to measure the Return to Risk ratio is by calculating the Sharpe ratio for the portfolio.  The Sharpe ratio for the highest return of Pareto-optimal returns is about .09 or 9%.  This could be an indicator that the selected assets are not the optimal ones for the portfolio.  Some diversification such as a greater allocation of funds in risk-free assets such as an ETF or government bonds could help to lower the volatility and improve the Sharpe ratio.

```



$\large \text{Rate of return} \space r_t=\frac{P_t - P_{t-1}}{P_t}$

$\large \large \text{Each assets expected return}\space\space \mu_i=E(r^i)=\frac{\sum_{n=1}^{m} r_t^i}{m}$

$\large \large \text{Covariance matrix} \space \Omega_{n\space x \space n}=\begin{pmatrix}
\sigma_{1}^2 & \sigma_{12} \space \cdots \space \sigma_{1n}\\
\sigma_{21}  & \sigma_{2}^2 \space \cdots \space \sigma_{2n} \\
\vdots       & \vdots       \space \ddots \space \space \vdots\\
\sigma_{n1}  & \sigma{n2}   \space \cdots \space \sigma_n^2
\end{pmatrix}$

$\large \text{For each} \space \sigma_{ij}=\frac{\sum_{t=1}^{m} (r_t^i-\mu_i)(r_j^t-\mu_j)}{m}$

$\large \text{Maximize}\space E(r_p)=\sum_{i=1}^n w_i\mu_i$

$\large \text{Minimize} \space \sigma_P=\sqrt{\sum_{i=1}^n\sum_{j=1}^nw_iw_j\sigma_{ij}}$

$\large \sum_{i=1}^n w_i=1$

$\large 0\leq w_i\leq1,\space\space i=1\cdots,n$
```
