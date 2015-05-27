From: Bart Van Assche <bart.vanassche@sandisk.com>
Subject: Re: 4.1-rc2 dm-multipath-mq kernel warning
Date: Wed, 27 May 2015 17:33:55 +0200
Message-ID: <5565E3E3.4080801@sandisk.com>
References: <5548CDE5.9@sandisk.com> <20150506022332.GA12096@redhat.com>
	<5549C68E.2050705@sandisk.com> <20150506182942.GA15545@redhat.com>
	<554B3C22.4060305@sandisk.com> <20150527125732.GA15911@redhat.com>
	<5565E2EA.2000302@sandisk.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <5565E2EA.2000302@sandisk.com>
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
Cc: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

On 05/27/15 17:29, Bart Van Assche wrote:
> On 05/27/15 14:57, Mike Snitzer wrote:
>> Looks like Junichi likely fixed this issue you reported, please try this
>> patch: https://patchwork.kernel.org/patch/6487321/
>
> Hello Mike,
>
> On a setup on which an I/O verification test passes with
> blk-mq/scsi-mq/dm-mq disabled, this is what fio reports after a few
> minutes with scsi-mq and dm-mq enabled:
>
> test: Laying out IO file(s) (1 file(s) / 10MB)
> fio: io_u error on file /mnt/test.0.0: Input/output error: write
> offset=8327168, buflen=4096
> fio: io_u error on file /mnt/test.0.0: Input/output error: write
> offset=9007104, buflen=4096
> fio: pid=4568, err=5/file:io_u.c:1564, func=io_u error,
> error=Input/output error

(replying to my own e-mail)

BTW, on the same test setup kmemleak reports several memory leaks, e.g. 
this one:

unreferenced object 0xffff88009b14e2b0 (size 16):
   comm "fio", pid 4274, jiffies 4294978034 (age 1253.210s)
   hex dump (first 16 bytes):
     40 12 f3 99 01 88 ff ff 00 10 00 00 00 00 00 00  @...............
   backtrace:
     [<ffffffff81600029>] kmemleak_alloc+0x49/0xb0
     [<ffffffff811679a8>] kmem_cache_alloc+0xf8/0x160
     [<ffffffff8111c950>] mempool_alloc_slab+0x10/0x20
     [<ffffffff8111cb37>] mempool_alloc+0x57/0x150
     [<ffffffffa04d2b61>] __multipath_map.isra.17+0xe1/0x220 [dm_multipath]
     [<ffffffffa04d2cb5>] multipath_clone_and_map+0x15/0x20 [dm_multipath]
     [<ffffffffa02889b5>] map_request.isra.39+0xd5/0x220 [dm_mod]
     [<ffffffffa028b0e4>] dm_mq_queue_rq+0x134/0x240 [dm_mod]
     [<ffffffff812cccb5>] __blk_mq_run_hw_queue+0x1d5/0x380
     [<ffffffff812ccaa5>] blk_mq_run_hw_queue+0xc5/0x100
     [<ffffffff812ce350>] blk_sq_make_request+0x240/0x300
     [<ffffffff812c0f30>] generic_make_request+0xc0/0x110
     [<ffffffff812c0ff2>] submit_bio+0x72/0x150
     [<ffffffff811c07cb>] do_blockdev_direct_IO+0x1f3b/0x2da0
     [<ffffffff811c166e>] __blockdev_direct_IO+0x3e/0x40
     [<ffffffff8120aa1a>] ext4_direct_IO+0x1aa/0x390

Bart.
