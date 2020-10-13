
Pkg.add("Plots")
Pkg.add("PyPlot") # or  Pkg.add("PlotlyJS")
using Plots
pyplot() 

A=AAPL[:,6]
H=HD[:,6]
K=KO[:,6]
Q=QCOM[:,6]
T=TSLA[:,6]
W=WMT[:,6]

other=hcat(A,H,K,Q,T,W)

##This gives the rates of returns between time period t and t-1

function rate_return_matrix(data)
    a,b=size(data)
    
    new_matrix=zeros((a-1),b)
    
    for i in 1:(b)
        avg_return_vector=[]
        for j in 1:(a-1)
            change=(data[:,i][j+1]-data[:,i][j])/data[:,i][j]
            push!(avg_return_vector,change)
            end   
        new_matrix[:,i]=avg_return_vector
    end
    return new_matrix
end

##The return matrix for our stocks over the time period
new_r=rate_return_matrix(other)

##The expected average return       
expected_return=new_r'ones(1258)*(1/1258)    

 0.0013948616853978269 
 0.0008900820692928485 
 0.00042347055128076465
 0.0010011865177489779 
 0.0023025577958828134 
 0.0008093645364203608 

function covariance_matrix(mate,avges)
    
    a,b=size(mate)
    o=zeros(b,b)
    
    for i in 1:b
        for j in i:b
            o[i,j]=sum((mate[k,i]-avges[i])*(mate[k,j]-avges[j]) for k in 1:a)/a
            if i!=j
                o[j,i]=o[i,j]
            end
        end
    end
    
    return o
end

function risks_each_asset(mate,avges)
    
    a,b=size(mate)
    o=[]
    for i in 1:b
        p=sum((mate[j,i]-avges[i])^2 for j in 1:a)/(a-1)
        push!(o,sqrt(p))
    end
    
    return o
end

##This will display the risk of each asset.
each_risk=risks_each_asset(new_r,expected_return)

a_cov=covariance_matrix(new_r,expected_return)  

 0.000340376  0.000162771  9.02922e-5   0.000217143  0.000238522  8.68074e-5 
 0.000162771  0.000256363  0.000103834  0.000178052  0.000194624  9.30243e-5 
 9.02922e-5   0.000103834  0.00015256   9.24132e-5   9.13158e-5   6.31718e-5 
 0.000217143  0.000178052  9.24132e-5   0.000538595  0.00022028   8.17975e-5 
 0.000238522  0.000194624  9.13158e-5   0.00022028   0.00122138   7.34903e-5 
 8.68074e-5   9.30243e-5   6.31718e-5   8.17975e-5   7.34903e-5   0.000204076

##Risk of each stock.  Apple Coke Home Depot Qualcomm Tesla Walmart
each_risk

 0.018456626449247577
 0.01601771421736777 
 0.012356422949851661
 0.023216881333632953
 0.03496218052418478 
 0.014291182777060077

##Risk function to calculate the variance of each asset
function risk(weights,cov_matrix)
    
    times=length(weights)
    
    cov_o=0
            
    cov_o=sum(sum(weights[i]*weights[j]*cov_matrix[i,j] for j in 1:times) for i in 1:times)
    
    risk_from_cov_o=sqrt(cov_o)
    
    return risk_from_cov_o
    
end

##Create the random weights matrix to test for optimality of returns vs. risk
function random_weights(port_length,num_tests)
    
    test_matrix=zeros(num_tests,port_length)
    
    for i in 1:num_tests
        
        aye=rand(0.0:1000,port_length)
        aye=aye ./sum(aye)
        
        test_matrix[i,:]=aye
       
    end
    
    return test_matrix
    
end

random_generated=random_weights(6,60000)

##Function to calculate the risk
function min_answer(ran_matrix)
    
    a,b=size(ran_matrix)
    
    min_done=[]
    
    for i in 1:a
         
        insert=risk(ran_matrix[i,:]',a_cov)
        
        push!(min_done,insert)
    end
    
    return min_done
    
end

##Function to calculate the return
function max_answer(r_matrix,averages)
    
    Max_part=r_matrix*averages
    
    return Max_part
    
end

##Risk
Risky=min_answer(random_generated)

##Return
Returns=max_answer(random_generated,expected_return)
 
##Matrix to easily return the weights and returns and risk by row. Easier to index.
random_all=hcat(random_generated,Returns,Risky)

##Sorts the matrix to more easily pick out the non-dominated portfolio (Pareto)
a=sortslices(random_all,dims=1,by=x->x[7],rev=true)
##Collecting the risk and return
feed_for_function=a[:,[7,8]]

##risk free rate is .54% so makes sense to invest right now.  Money won't do anything.  later
##that is why it makes sense to chill out when interest rates are higher.  too volatile.  

function sharpe(risks,returns,rate)
    
    sharp=[]
    
    for i in 1:length(returns)
       
        push!(sharp,((returns[i]-rate)/risks[i]))
        
    end
    
    return sharp
end 

##Return/Pareto
j=[]
##Risk/Pareto
l=[]

##Sorts the matrix to more easily pick out the non-dominated portfolio (Pareto)
a=sortslices(random_all,dims=1,by=x->x[7],rev=true)
##Collecting the risk and return
feed_for_function=a[:,[7,8]]
##The data that we fit into the Pareto function.  
mate=feed_for_function


start=1
global k=0

while length(j)!=1
    
    k=start+1
    
    for i in start:60000-1
        
        if mate[:,1][i]>mate[:,1][k] && mate[:,2][i]<=maximum(mate[:,2][k:length(mate[:,2])])
            push!(j,mate[:,1][i])
            push!(l,mate[:,2][i])
            break
        else
            k+=1
        end
    end
    
    if length(j)==0
        start+=1
    end
    
end


newstart=k

for i in newstart:60000

    if j[length(j)]>=mate[:,1][i] && l[length(l)]<mate[:,2][i]
        i+=1
    else
        push!(j,mate[:,1][i])
        push!(l,mate[:,2][i])
    end
end

##This is the matrix to be able to show the weights, returns and risk for each Pareto optimal


weights_to_returns_and_risk=zeros(length(j),8)
for i in 1:length(j)
   finding_spot = indexin(j[i],random_all[:,7])
    weights_to_returns_and_risk[i,:]=random_all[finding_spot,:]
end

##Putting percentages to a higher decimal place to seem more relevant
j= j .*100
l= l .*100
Returns=Returns .*100
Risky=Risky .*100

plot(Risky[1:60000],Returns[1:60000],seriestype =:scatter,label="Data")
plot!(l,j,linestyle = :solid, linewidth=3,label="Pareto curve")

plot(l,j,seriestype =:scatter,xlabel="Risk",ylabel="Returns",legend=false)
plot!(l,j,linestyle =:solid,linewidth=2,legend=false,title="Daily Returns vs. Risk %")

##This is the return function for the return of the time period.

function return_time_period(Returns,time_periods,amount_invested)
    
    
    comp_return=[]
    
    for i in 1:length(Returns)
        push!(comp_return,amount_invested*(1+Returns[i]/time_periods)^time_periods)
    end
    
    return comp_return
    
end

##To view the returns for each portfolio on our Pareto fronteir
see=return_time_period(j,length(A),10000)

why=sharpe(l,j,.34/1258)

##Maximum Sharpe ratio for non dominated solutions
maximum(why)

0.09163040878851014

##Sharpe ratio for the maximum return and the minimum risk
(maximum(j)-(.34/1258))/minimum(l)
    
0.16776183138362108
