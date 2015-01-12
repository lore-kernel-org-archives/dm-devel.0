From: Jens Axboe <axboe@kernel.dk>
Subject: Re: blk-mq request allocation stalls
Date: Mon, 12 Jan 2015 08:42:02 -0700
Message-ID: <54B3EB4A.9090404@kernel.dk>
References: <alpine.LNX.2.00.1501071755110.4026@localhost.lm.intel.com>
	<20150109194955.GA32641@redhat.com>
	<54B042FE.2000205@kernel.dk> <54B043FC.8000902@kernel.dk>
	<20150109214015.GA1032@redhat.com> <54B04E94.3010403@kernel.dk>
	<20150109222543.GA1190@redhat.com> <54B071DC.9000307@kernel.dk>
	<20150110014811.GA2384@redhat.com> <54B08779.2080705@kernel.dk>
	<20150110031057.GA2823@redhat.com> <54B3DE54.7090909@sandisk.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <54B3DE54.7090909@sandisk.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Bart Van Assche <bart.vanassche@sandisk.com>, Mike Snitzer <snitzer@redhat.com>
Cc: Keith Busch <keith.busch@intel.com>, Christoph Hellwig <hch@infradead.org>, device-mapper development <dm-devel@redhat.com>, Jun'ichi Nomura <j-nomura@ce.jp.nec.com>
List-Id: dm-devel.ids

On 01/12/2015 07:46 AM, Bart Van Assche wrote:
> On 01/10/15 04:10, Mike Snitzer wrote:
>> On Fri, Jan 09 2015 at  8:59pm -0500,
>> Jens Axboe <axboe@kernel.dk> wrote:
>>> Bart, could you try the patch (the -v4) and your DM hang and see if
>>> it solves it for you?
>>
>> Yes, I'm interested to hear from Bart on v4 too.
>
> Hello Mike and Jens,
>
> Sorry but even with v4 applied filesystem creation still takes too long.
> The kernel I have been testing with was generated as follows:
> * Started from Mike's dm-for-3.20-blk-mq branch.
> * Merged v3.19-rc4 with this branch.
> * Applied Jens' blk-mq tag patch and Mike's debug patch on top.
> * Modified Mike's patch to make it print the blk-mq "may_queue" state
>    (hctx_may_queue(hctx, bt)).
>
> Here are the results without multipath:
>
> # systemctl disable multipathd
> # systemctl stop multipathd
> # dmsetup remove_all
> # rmmod dm_service_time
> # rmmod dm_multipath
> # rmmod dm_mod
> # time mkfs.xfs -f /dev/sdc >/dev/null
> real    0m0.037s
> user    0m0.000s
> sys     0m0.020s
> # time mkfs.xfs -f /dev/sdd >/dev/null
> real    0m0.030s
> user    0m0.010s
> sys     0m0.010s
>
> With multipath:
>
> # ls -l /dev/sd[cd]
> brw-rw---- 1 root disk 8, 32 Jan 12 15:09 /dev/sdc
> brw-rw---- 1 root disk 8, 48 Jan 12 15:11 /dev/sdd
> # systemctl start multipathd
> # dmsetup table /dev/dm-0
> 0 256000 multipath 3 queue_if_no_path pg_init_retries 50 0 1 1
> service-time 0 2 2 8:48 1 1 8:32 1 1
> # time mkfs.xfs -f /dev/dm-0 >/dev/null
> real    0m8.845s
> user    0m0.000s
> sys     0m0.020s
> # time mkfs.xfs -f /dev/dm-0 >/dev/null
> real    0m14.905s
> user    0m0.000s
> sys     0m0.020s
>
> What is remarkable is that Mike's debug patch started to report
> "bt_get() returned -1" as soon as multipathd was started. The first of
> many identical call traces printed by this debug patch was as follows:
>
> bt_get: __bt_get() returned -1
> queue_num=2, nr_tags=62, reserved_tags=0, bits_per_word=3
> nr_free=62, nr_reserved=0, may_queue=0
> active_queues=8

Can you add dumping of hctx->nr_active when this fails? You case is that 
the may_queue logic says no-can-do, so it smells like the nr_active 
accounting is wonky since you have supposedly no allocated tags, yet it 
clearly thinks that you do.

-- 
Jens Axboe
