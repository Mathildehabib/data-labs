# -*- coding: utf-8 -*-
"""
Created on Fri Oct 25 11:48:17 2019

@author: mathi
"""
import pandas as pd
import matplotlib.pyplot as plt
import seaborn as sns
year=int(input('Enter the Year: '))
title = 'Top 10 Car Producers by Fuel Efficienty in ' +str(year)

def acquisition():
    data=pd.read_csv(r'C:\Users\mathi\Documents\Python\vehicles\vehicles\vehicles.csv')
    return data

def wrangling(df):
    filtered=df[df.Year==year]
    return filtered

def analyze(filtered):
    result = filtered.groupby('Make',as_index=False)['Combined MPG'].mean().sort_values(by='Combined MPG',ascending=False).head(10).round(1)
    return result

def viz(df):
    fig,ax=plt.subplots(figsize=(15,8))
    barchart=sns.barplot(data=df,x='Make',y='Combined MPG')
    
    plt.title(title+'\n',fontsize=16)
    sns.set(style='darkgrid')
    plt.show()
    return barchart

def save_viz(chart):
    fig=chart.get_figure()
    fig.savefig(r'C:\Users\mathi\Documents\Python\vehicles\vehicles/'+title+'.png')

if __name__=='__main__':
    data=acquisition()
    filtered=wrangling(data)
    results=analyze(filtered)
    barchart=viz(results)
    save_viz(barchart)