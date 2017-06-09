From: Yang Feng <philip.yang@huawei.com>
Subject: Re: [PATCH v4 0/1] multipath-tools: Prioritizer based on
 a latency algorithm
Date: Fri, 9 Jun 2017 16:26:09 +0800
Message-ID: <dd64aa99-bc63-7dfc-c58c-0cfc1776324c@huawei.com>
References: <1496717022-25392-1-git-send-email-philip.yang@huawei.com>
	<8f92be05-3841-e1b8-ac69-13ab4700395e@suse.de>
	<197737a7-c0bd-adf7-934c-b198adac82f3@huawei.com>
	<1496995552.4654.16.camel@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1496995552.4654.16.camel@suse.com>
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
To: Martin Wilck <mwilck@suse.com>, Hannes Reinecke <hare@suse.de>, dm-devel@redhat.com, christophe.varoqui@opensvc.com, bmarzins@redhat.com, xose.vazquez@gmail.com
Cc: zouming.zouming@huawei.com, hege09@huawei.com, guanjunxiong@huawei.com, shenhong09@huawei.com, qiuxin@huawei.com
List-Id: dm-devel.ids

Hi Martin,

Thanks a lot.
It's a good idea.
The updated patch will be sent later.

Regards,
-Yang


On 2017/6/9 16:05, Martin Wilck wrote:
> Hello Yang,
> 
>>> Actually, you're not alone here; several other storage array setups
>>> suffer from the same problem.
>>>
>>> Eg if you have a site-failover setup with two storage arrays at
>>> different locations the problem is more-or-less the same;
>>> both arrays potentially will be displaying identical priority
>>> information, despite one array being remote.
>>>
>>
>> It's up to the value set of the argument "latency_interval".For
>> example,
>> If latency_interval=10ms, the paths will be grouped in priority
>> groups
>> with path latency 0-10ms, 10-20ms, 20-30ms, etc. If the argument
>> "latency_interval" is set to appropriate value and the distance
>> between
>> two arrays is not enough far, two priorities may be the same, But
>> it's
>> OK, because between two arrays, the gap of average path latency is
>> very
>> small and tolerable.
> 
> I wonder if it would make sense to use "logarithmically" scaled latency
> intervals here. It wouldn't make a large difference whether the latency
> is 1ms or 2ms, but if we have paths where the latencies differ by order
> of magnitude, it would be very important to make a distinction. With
> the current linear intervals, it would be hard to get this right (us
> interval size would result in too many intervals, and sec interval size
> wouldn't allow a distinction between us and ms latencies).
> 
> By using logarithmic scale, you could setup the latency intevals e.g
> like this: 
> 
>   < 10us, 10us-100us, 100us-1ms, 1ms-10ms, 10ms-100ms, > 100ms
> 
> IMO that would be better, in particular if the latencies differ
> strongly between paths.
> 
> Regards
> Martin
> 
> 
