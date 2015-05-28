From: Bart Van Assche <bart.vanassche@sandisk.com>
Subject: Re: 4.1-rc2 dm-multipath-mq kernel warning
Date: Thu, 28 May 2015 16:54:09 +0200
Message-ID: <55672C11.2080809@sandisk.com>
References: <20150506182942.GA15545@redhat.com> <554B3C22.4060305@sandisk.com>
	<20150527125732.GA15911@redhat.com> <5565E2EA.2000302@sandisk.com>
	<5565E3E3.4080801@sandisk.com> <20150527161415.GA22520@redhat.com>
	<20150527170001.GA22548@redhat.com>
	<20150527223741.GA18501@redhat.com>
	<5566CFAB.7060408@sandisk.com> <20150528131051.GA22527@redhat.com>
	<20150528140702.GA25917@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20150528140702.GA25917@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Mike Snitzer <snitzer@redhat.com>
Cc: Junichi Nomura <j-nomura@ce.jp.nec.com>, device-mapper development <dm-devel@redhat.com>, Christoph Hellwig <hch@lst.de>
List-Id: dm-devel.ids

On 05/28/15 16:07, Mike Snitzer wrote:
> On Thu, May 28 2015 at  9:10P -0400,
> Mike Snitzer <snitzer@redhat.com> wrote:
>
>> On Thu, May 28 2015 at  4:19am -0400,
>> Bart Van Assche <bart.vanassche@sandisk.com> wrote:
>>
>>> On 05/28/15 00:37, Mike Snitzer wrote:
>>>> FYI, I've staged a variant patch for 4.1 that is simpler; along with the
>>>> various fixes I've picked up from Junichi and the leak fix I emailed
>>>> earlier.  They are now in linux-next and available in this 'dm-4.1'
>>>> specific branch (based on 4.1-rc5):
>>>> https://git.kernel.org/cgit/linux/kernel/git/device-mapper/linux-dm.git/log/?h=dm-4.1
>>>>
>>>> Please try and let me know if your test works.
>>>
>>> No data corruption was reported this time but a very large number of
>>> memory leaks were reported by kmemleak. The initiator system ran out
>>> of memory after some time due to these leaks. Here is an example of
>>> a leak reported by kmemleak:
>>>
>>> unreferenced object 0xffff8800a39fc1a8 (size 96):
>>>     comm "srp_daemon", pid 2116, jiffies 4294955508 (age 137.600s)
>>>     hex dump (first 32 bytes):
>>>       00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
>>>       00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
>>>     backtrace:
>>>       [<ffffffff81600029>] kmemleak_alloc+0x49/0xb0
>>>       [<ffffffff81167d19>] kmem_cache_alloc_node+0xd9/0x190
>>>       [<ffffffff81425400>] scsi_init_request+0x20/0x40
>>>       [<ffffffff812cbb98>] blk_mq_init_rq_map+0x228/0x290
>>>       [<ffffffff812cbcc6>] blk_mq_alloc_tag_set+0xc6/0x220
>>>       [<ffffffff81427488>] scsi_mq_setup_tags+0xc8/0xd0
>>>       [<ffffffff8141e34f>] scsi_add_host_with_dma+0x6f/0x300
>>>       [<ffffffffa04c62bf>] srp_create_target+0x11cf/0x1600 [ib_srp]
>>>       [<ffffffff813f9c93>] dev_attr_store+0x13/0x20
>>>       [<ffffffff81200a33>] sysfs_kf_write+0x43/0x60
>>>       [<ffffffff811fff8b>] kernfs_fop_write+0x13b/0x1a0
>>>       [<ffffffff81183e53>] __vfs_write+0x23/0xe0
>>>       [<ffffffff81184524>] vfs_write+0xa4/0x1b0
>>>       [<ffffffff811852d4>] SyS_write+0x44/0xb0
>>>       [<ffffffff81613cdb>] system_call_fastpath+0x16/0x73
>>>       [<ffffffffffffffff>] 0xffffffffffffffff
>>
>> I suspect I'm missing some cleanup of the request I got from the
>> underlying blk-mq device.  I'll have a closer look.
>
> BTW, your test was with the dm-4.1 branch right?
>
> The above kmemleak trace clearly speaks to dm-mpath's ->clone_and_map_rq
> having allocated the underlying scsi-mq request.  So it'll later require
> a call to dm-mpath's ->release_clone_rq to free the associated memory --
> which happens in dm.c:free_rq_clone().
>
> But I'm not yet seeing where we'd be missing a required call to
> free_rq_clone() in the DM core error paths.  You can try this patch to
> see if you hit the WARN_ON but I highly doubt you would.. similarly the
> clone request shouldn't ever be allocated (nor tio->clone initialized)
> in the REQUEUE case:

Hello Mike,

This occurred with the dm-4.1 branch merged with the for-4.2 IB branch. 
The leak was reported for regular I/O and before I started to trigger 
path failures. I had a look myself at how the sense_buffer pointer is 
manipulated by the scsi-mq code but could not find anything that is 
wrong. So the next I did was to repeat my test with kmemleak disabled. 
During this test the number of kmalloc-96 objects in /proc/slabinfo 
remained constant. So I probably have hit a bug in kmemleak. Maybe the 
code that clears and restores the sense buffer pointer in 
scsi_mq_prep_fn() is confusing kmemleak ? Sorry for the noise.

Bart.
