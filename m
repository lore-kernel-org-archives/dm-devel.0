From: Yang Feng <philip.yang@huawei.com>
Subject: Re: [PATCH v4 0/1] multipath-tools: Prioritizer based on
 a latency algorithm
Date: Fri, 9 Jun 2017 15:20:59 +0800
Message-ID: <197737a7-c0bd-adf7-934c-b198adac82f3@huawei.com>
References: <1496717022-25392-1-git-send-email-philip.yang@huawei.com>
	<8f92be05-3841-e1b8-ac69-13ab4700395e@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <8f92be05-3841-e1b8-ac69-13ab4700395e@suse.de>
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
To: Hannes Reinecke <hare@suse.de>, dm-devel@redhat.com, christophe.varoqui@opensvc.com, bmarzins@redhat.com, mwilck@suse.com, xose.vazquez@gmail.com
Cc: zouming.zouming@huawei.com, hege09@huawei.com, guanjunxiong@huawei.com, shenhong09@huawei.com, qiuxin@huawei.com
List-Id: dm-devel.ids

Hi Hannes,

Thanks a lot.
Please find my replys as follows.

regards.
-Yang

On 2017/6/8 23:37, Hannes Reinecke wrote:
> On 06/06/2017 04:43 AM, Yang Feng wrote:
>> This patch value is in the following: 
>> 1. In the Storage-Backup environment of HyperCluster, includes
>> one storage array near to the host and one remote storage array,
>> and the two storage arrays have the same hardware.The same LUN is
>> writed or readed by the two storage arrays. However, usually, the
>> average latency of the paths of the remote storage array is much 
>> higher than the near storage array's. Apparently, the prioritizer
>> can be a good automatic solution. And the current selectors don't
>> solve it, IOs will send to the paths of the remote storage array,
>> IOPS will be influenced unavoidably.
>>
> Actually, you're not alone here; several other storage array setups
> suffer from the same problem.
> 
> Eg if you have a site-failover setup with two storage arrays at
> different locations the problem is more-or-less the same;
> both arrays potentially will be displaying identical priority
> information, despite one array being remote.
> 

It's up to the value set of the argument "latency_interval".For example,
If latency_interval=10ms, the paths will be grouped in priority groups
with path latency 0-10ms, 10-20ms, 20-30ms, etc. If the argument
"latency_interval" is set to appropriate value and the distance between
two arrays is not enough far, two priorities may be the same, But it's
OK, because between two arrays, the gap of average path latency is very
small and tolerable.

> Similarly, if you have a failover scenario where the individual paths
> are accessed via different protocols you're facing the same problem.
> 

Usually, the number of paths grouped into one priority is not only one.
And Mostly, the average latency of paths via FC protocol is much smaller
than the average latency of paths via iSCSI protocol. Unless all paths
via FC are fault, the failover scenario to paths via iSCSI will not happen.

> The underlying reason for this difficulty is the two-stage topology of
> the current multipath implementation:
> 
> - Each path is grouped into a path group
> - Priorities are attached to a path group
> - Each path group belongs to a multipath device
> 
> And as we only have a _single_ prioritizer per path we cannot easily
> handle this situation.
> 
> Ideally we should be able to 'stack' prioritizers, which would work by
> combining the priority numbers from the stacked/combined prioritizers.
> 

In this prioritizer, all paths will be grouped into several priorities,
and each path group has own priority who's different from the others.

1. By sending a certain number "cons_num" of read IOs to the current
path continuously, the IOs' average latency can be calculated.
2. According to the average latency of each path and the weight value
"latency_interval", the priority "rc" of each path can be provided.

Then all paths can be divided into different path groups. For example,
If latency_interval=10ms, the paths will be grouped in priority groups
with path latency 0-10ms, 10-20ms, 20-30ms, etc, as follows:

   latency_interval   latency_interval   latency_interval       latency_interval
 |------------------|------------------|------------------|...|------------------|
 |  priority rank 1 |  priority rank 2 |  priority rank 3 |...|  priority rank x |
 |------------------|------------------|------------------|...|------------------|
 |     0~10ms       |     10~20ms      |     20~30ms      |...| 10*(x-1)~10*x ms |
		          Priority Rank Partitioning

> But that would be requiring quite some rework, of course.
> 
> Cheers,
> 
> Hannes
> 
