From: Jens Axboe <axboe@kernel.dk>
Subject: Re: dm-multipath low performance with blk-mq
Date: Wed, 27 Jan 2016 12:49:48 -0700
Message-ID: <56A91F5C.3030407@kernel.dk>
References: <569E11EA.8000305@dev.mellanox.co.il>
	<20160119224512.GA10515@redhat.com> <20160125214016.GA10060@redhat.com>
	<20160125233717.GQ24960@octiron.msp.redhat.com>
	<20160126132939.GA23967@redhat.com>
	<56A8A6A8.9090003@dev.mellanox.co.il>
	<20160127174828.GA31802@redhat.com> <56A904B6.50407@dev.mellanox.co.il>
	<20160127184245.GC31802@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20160127184245.GC31802@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Mike Snitzer <snitzer@redhat.com>, Sagi Grimberg <sagig@dev.mellanox.co.il>
Cc: "keith.busch@intel.com" <keith.busch@intel.com>, Christoph Hellwig <hch@infradead.org>, device-mapper development <dm-devel@redhat.com>, "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>, Bart Van Assche <bart.vanassche@sandisk.com>
List-Id: dm-devel.ids

On 01/27/2016 11:42 AM, Mike Snitzer wrote:
> On Wed, Jan 27 2016 at 12:56pm -0500,
> Sagi Grimberg <sagig@dev.mellanox.co.il> wrote:
>
>>
>>
>> On 27/01/2016 19:48, Mike Snitzer wrote:
>>>
>>> BTW, I _cannot_ get null_blk to come even close to your reported 1500K+
>>> IOPs on 2 "fast" systems I have access to.  Which arguments are you
>>> loading the null_blk module with?
>>>
>>> I've been using:
>>> modprobe null_blk gb=4 bs=4096 nr_devices=1 queue_mode=2 submit_queues=12
>>
>> $ for f in /sys/module/null_blk/parameters/*; do echo $f; cat $f; done
>> /sys/module/null_blk/parameters/bs
>> 512
>> /sys/module/null_blk/parameters/completion_nsec
>> 10000
>> /sys/module/null_blk/parameters/gb
>> 250
>> /sys/module/null_blk/parameters/home_node
>> -1
>> /sys/module/null_blk/parameters/hw_queue_depth
>> 64
>> /sys/module/null_blk/parameters/irqmode
>> 1
>> /sys/module/null_blk/parameters/nr_devices
>> 2
>> /sys/module/null_blk/parameters/queue_mode
>> 2
>> /sys/module/null_blk/parameters/submit_queues
>> 24
>> /sys/module/null_blk/parameters/use_lightnvm
>> N
>> /sys/module/null_blk/parameters/use_per_node_hctx
>> N
>>
>> $ fio --group_reporting --rw=randread --bs=4k --numjobs=24
>> --iodepth=32 --runtime=99999999 --time_based --loops=1
>> --ioengine=libaio --direct=1 --invalidate=1 --randrepeat=1
>> --norandommap --exitall --name task_nullb0 --filename=/dev/nullb0
>> task_nullb0: (g=0): rw=randread, bs=4K-4K/4K-4K/4K-4K,
>> ioengine=libaio, iodepth=32
>> ...
>> fio-2.1.10
>> Starting 24 processes
>> Jobs: 24 (f=24): [rrrrrrrrrrrrrrrrrrrrrrrr] [0.0% done]
>> [7234MB/0KB/0KB /s] [1852K/0/0 iops] [eta 1157d:09h:46m:22s]
>
> Thanks, the number of fio threads was pretty important.  I'm still
> seeing better IOPs with queue_mode=0 (bio-based).
>
> Jobs: 24 (f=24): [r(24)] [11.7% done] [11073MB/0KB/0KB /s] [2835K/0/0 iops] [eta 14m:42s]
>
> (with queue_mode=2 I get ~1930K IOPs.. which I need to use to stack
> request-based DM multipath ontop)
>
> Now I can focus on why dm-multipath is slow...

queue_mode=0 doesn't do a whole lot, once you add the required bits for 
a normal driver, that will eat up a bit of overhead. The point was to 
retain scaling, and to avoid drivers having to built support for the 
required functionality from scratch. If we do that once and 
fast/correct, then all mq drivers get it.

That said, your jump is a big one. Some of that is support 
functionality, and some of it (I bet) is just doing io stats. If you 
disable io stats with queue_mode=2, the performance will most likely 
increase. Other things we just can't disable or don't want to disable, 
if we are going to keep this as an indication of what a real driver 
could do through the mq stack.

Now, if queue_mode=1 is faster, then there's certainly an issue!

-- 
Jens Axboe
