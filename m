From: Guan Junxiong <guanjunxiong@huawei.com>
Subject: Re: [PATCH 3/4] libmultipath: path latency: simplify
	getprio()
Date: Thu, 7 Dec 2017 12:26:15 +0800
Message-ID: <19c4c292-3297-b602-36c4-0dde2c61e266@huawei.com>
References: <20171118001134.26622-1-mwilck@suse.com>
	<20171118001134.26622-4-mwilck@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20171118001134.26622-4-mwilck@suse.com>
Content-Language: en-US
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Martin Wilck <mwilck@suse.com>, Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: guanjunxiong@huawei.com, dm-devel@redhat.com, niuhaoxin <niuhaoxin@huawei.com>, "Shenhong (C)" <shenhong09@huawei.com>
List-Id: dm-devel.ids

Hi Martin,

I have tested this patch and found something needed to be correct. My comments inline.


On 2017/11/18 8:11, Martin Wilck wrote:
> The log standard deviation can be calculated much more simply
> by realizing
> 
>    sum_n (x_i - avg(x))^2 == sum_n x_i^2 - n * avg(x)^2
> 


> @@ -340,8 +323,14 @@ int getprio(struct path *pp, char *args, unsigned int timeout)
>  			  ".It is recommend to be set larger",
>  			  pp->dev, base_num);
>  
> +	standard_deviation = sqrt((sum_squares - lg_toldelay * lg_toldelay)
> +				  / (io_num -1));
>  
This assignment is wrong. It gets a "NAN" for standard_deviation.
It should be the following equation according to sum_n (x_i - avg(x))^2 == sum_n x_i^2 - n * avg(x)^2

standard_deviation = sqrt((sum_squares - io_num* lg_avglatency* lg_avglatency)/ (io_num -1));
                   = sqrt((sum_squares -  lg_toldelay* lg_avglatency)/ (io_num -1));


>  	rc = calcPrio(lg_avglatency, lg_maxavglatency, lg_minavglatency);
>  
> +	pp_pl_log(3, "%s: latency avg=%.2e uncertainty=%.1f prio=%d\n",
> +		  pp->dev, exp(lg_avglatency * lg_base),
> +		  exp(standard_deviation * lg_base), rc);
> +

I still have the doubt about the computation of the "uncertainty" item.
Because I have observed that the uncertainty is in the range of 1.3 ~ 1.6 whenever
the base_num varies from 1.1 to 10.

Do you mean the uncertainty as the "Error function" of (log) normal distribution?
Here is the definition of https://en.wikipedia.org/wiki/Error_function

I prefer to using  "Error function" that describes accumulated probability of  how  prio
locates in the (-inf, prio-1) and (prio+1, +inf).

Thanks
Guan
