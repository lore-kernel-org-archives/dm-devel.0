From: Bart Van Assche <bart.vanassche@sandisk.com>
Subject: Re: blk-mq request allocation stalls
Date: Mon, 12 Jan 2015 18:04:09 +0100
Message-ID: <54B3FE89.200@sandisk.com>
References: <alpine.LNX.2.00.1501071755110.4026@localhost.lm.intel.com>
	<20150109194955.GA32641@redhat.com>
	<54B042FE.2000205@kernel.dk> <54B043FC.8000902@kernel.dk>
	<20150109214015.GA1032@redhat.com> <54B04E94.3010403@kernel.dk>
	<20150109222543.GA1190@redhat.com> <54B071DC.9000307@kernel.dk>
	<20150110014811.GA2384@redhat.com> <54B08779.2080705@kernel.dk>
	<20150110031057.GA2823@redhat.com>
	<54B3DE54.7090909@sandisk.com> <54B3EB4A.9090404@kernel.dk>
	<54B3F255.5080802@sandisk.com> <54B3F78D.2020704@kernel.dk>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <54B3F78D.2020704@kernel.dk>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Jens Axboe <axboe@kernel.dk>, Mike Snitzer <snitzer@redhat.com>
Cc: Keith Busch <keith.busch@intel.com>, Christoph Hellwig <hch@infradead.org>, device-mapper development <dm-devel@redhat.com>, Jun'ichi Nomura <j-nomura@ce.jp.nec.com>
List-Id: dm-devel.ids

On 01/12/15 17:34, Jens Axboe wrote:
> On 01/12/2015 09:12 AM, Bart Van Assche wrote:
>> On 01/12/15 16:42, Jens Axboe wrote:
>>> On 01/12/2015 07:46 AM, Bart Van Assche wrote:
>>>> bt_get: __bt_get() returned -1
>>>> queue_num=2, nr_tags=62, reserved_tags=0, bits_per_word=3
>>>> nr_free=62, nr_reserved=0, may_queue=0
>>>> active_queues=8
>>>
>>> Can you add dumping of hctx->nr_active when this fails? You case is that
>>> the may_queue logic says no-can-do, so it smells like the nr_active
>>> accounting is wonky since you have supposedly no allocated tags, yet it
>>> clearly thinks that you do.
>>
>> Hello Jens,
>>
>> The requested output is as follows:
>>
>> bt_get: __bt_get() returned -1
>> queue_num=0, nr_tags=62, reserved_tags=0, bits_per_word=3
>> nr_free=62, nr_reserved=0, hctx->tags->active_queues=7,
>> hctx->nr_active=9, hctx_may_queue()=0
>> active_queues=7
> 
> So that does look a bit off, we have (supposedly) 9 active requests, but 
> nothing allocated. When the mkfs is done and things are idle, can you 
> try and cat the 'active' file in the mq directory? I want to see if it 
> drops to zero or stays elevated.

Hello Jens,

Sorry that I hadn't been more clear but the __bt_get() data in the
previous e-mail was gathered when multipathd started instead of when
mkfs was started. That was the time at which Mike's debug patch reported
for the first time that __bt_get() returned -1. What is also remarkable
is that all "__bt_get() returned -1" reports that I checked referred to
the /dev/dm-0 device and none to any of the underlying devices
(/dev/sd[cd]).

The tag state after having stopped multipathd (systemctl stop
multipathd) is as follows:
# dmsetup table /dev/dm-0
0 256000 multipath 3 queue_if_no_path pg_init_retries 50 0 1 1
service-time 0 2 2 8:48 1 1 8:32 1 1
# ls -l /dev/sd[cd]
brw-rw---- 1 root disk 8, 32 Jan 12 17:47 /dev/sdc
brw-rw---- 1 root disk 8, 48 Jan 12 17:47 /dev/sdd
# for d in sdc sdd dm-0; do echo ==== $d; (cd /sys/block/$d/mq &&
  find|cut -c3-|grep active|xargs grep -aH ''); done
==== sdc
0/active:10
1/active:14
2/active:7
3/active:13
4/active:6
5/active:10
==== sdd
0/active:17
1/active:8
2/active:9
3/active:13
4/active:5
5/active:10
==== dm-0
-bash: cd: /sys/block/dm-0/mq: No such file or directory

Bart.
