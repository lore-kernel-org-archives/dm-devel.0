From: Guan Junxiong <guanjunxiong@huawei.com>
Subject: Re: [PATCH 3/4] libmultipath: path latency: simplify
	getprio()
Date: Sun, 19 Nov 2017 10:52:13 +0800
Message-ID: <74584b90-53c7-341e-d422-dca85c267c90@huawei.com>
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
Cc: dm-devel@redhat.com, niuhaoxin <niuhaoxin@huawei.com>, "Shenhong (C)" <shenhong09@huawei.com>
List-Id: dm-devel.ids



On 2017/11/18 8:11, Martin Wilck wrote:
> The log standard deviation can be calculated much more simply
> by realizing
> 
>    sum_n (x_i - avg(x))^2 == sum_n x_i^2 - n * avg(x)^2
> 

I derive the equation:
 sum_n {(x_i - avg(x))^2} = sum_n{x_i^2 -2*x_i*avg(x) + avg(x)^2}
                          = sum_n{x_i^2} - 2*avg(x)*sum_n{x_i} + sum_n{avg(x)^2}
                          = sum_n{x_i^2} - 2*avg(x)*avg(x) + n*avg(x)^2
                          =  sum_n{x_i^2} + (n-2)*avg(x)^2

> Also, use timespecsub rather than the custom timeval_to_usec,
> and avoid taking log(0).
> 

Great.


> +	pp_pl_log(3, "%s: latency avg=%.2e uncertainty=%.1f prio=%d\n",

latency avg -> latency geometric avg ? Because in most cases,
avg means arithmetic avg , but in this case, it means geometric avg.


> +		  pp->dev, exp(lg_avglatency * lg_base),
> +		  exp(standard_deviation * lg_base), rc);

How can you get the uncertainty of Log-normal distribution
is the exp(standard_deviation * lg_base) ?

Thanks.
Regards
Guan

.

> +
>  	return rc;
>  }
> 
