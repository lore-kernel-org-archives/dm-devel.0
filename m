From: Keith Busch <keith.busch@intel.com>
Subject: Re: blk-mq request allocation stalls
Date: Mon, 12 Jan 2015 17:53:20 +0000 (UTC)
Message-ID: <alpine.LNX.2.00.1501121738000.4026@localhost.lm.intel.com>
References: <alpine.LNX.2.00.1501071755110.4026@localhost.lm.intel.com>
	<20150109194955.GA32641@redhat.com>
	<54B042FE.2000205@kernel.dk> <54B043FC.8000902@kernel.dk>
	<20150109214015.GA1032@redhat.com> <54B04E94.3010403@kernel.dk>
	<20150109222543.GA1190@redhat.com>
	<54B071DC.9000307@kernel.dk> <20150110014811.GA2384@redhat.com>
	<54B08779.2080705@kernel.dk> <20150110031057.GA2823@redhat.com>
	<54B3DE54.7090909@sandisk.com> <54B3EB4A.9090404@kernel.dk>
	<54B3F255.5080802@sandisk.com> <54B3F78D.2020704@kernel.dk>
	<54B3FE89.200@sandisk.com> <54B3FFAE.4070609@kernel.dk>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <54B3FFAE.4070609@kernel.dk>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Jens Axboe <axboe@kernel.dk>
Cc: Christoph Hellwig <hch@infradead.org>, Mike Snitzer <snitzer@redhat.com>, Keith Busch <keith.busch@intel.com>, device-mapper development <dm-devel@redhat.com>, Jun'ichi Nomura <j-nomura@ce.jp.nec.com>, Bart Van Assche <bart.vanassche@sandisk.com>
List-Id: dm-devel.ids

On Mon, 12 Jan 2015, Jens Axboe wrote:
> On 01/12/2015 10:04 AM, Bart Van Assche wrote:
>> The tag state after having stopped multipathd (systemctl stop
>> multipathd) is as follows:
>> # dmsetup table /dev/dm-0
>> 0 256000 multipath 3 queue_if_no_path pg_init_retries 50 0 1 1
>> service-time 0 2 2 8:48 1 1 8:32 1 1
>> # ls -l /dev/sd[cd]
>> brw-rw---- 1 root disk 8, 32 Jan 12 17:47 /dev/sdc
>> brw-rw---- 1 root disk 8, 48 Jan 12 17:47 /dev/sdd
>> # for d in sdc sdd dm-0; do echo ==== $d; (cd /sys/block/$d/mq &&
>>    find|cut -c3-|grep active|xargs grep -aH ''); done
>> ==== sdc
>> 0/active:10
>> 1/active:14
>> 2/active:7
>> 3/active:13
>> 4/active:6
>> 5/active:10
>> ==== sdd
>> 0/active:17
>> 1/active:8
>> 2/active:9
>> 3/active:13
>> 4/active:5
>> 5/active:10
>> ==== dm-0
>> -bash: cd: /sys/block/dm-0/mq: No such file or directory
>
> OK, so it's definitely leaking, but only partially - the requests are freed, 
> yet the active count isn't decremented. I wonder if we're losing that flag 
> along the way. It's numbered high enough that a cast to int will drop it, 
> perhaps the cmd_flags is being copied/passed around as an int and not the 
> appropriate u64? We've had bugs like that before.

Is the nr_active count correct prior to starting the mkfs test? Trying
to see if someone is calling "blk_mq_alloc_tag_set()" twice on the same
set. It might be good to add a WARN if this is detected anyway.
