From: Bart Van Assche <bart.vanassche@sandisk.com>
Subject: Re: 4.1-rc2 dm-multipath-mq kernel warning
Date: Thu, 28 May 2015 10:19:55 +0200
Message-ID: <5566CFAB.7060408@sandisk.com>
References: <5548CDE5.9@sandisk.com> <20150506022332.GA12096@redhat.com>
	<5549C68E.2050705@sandisk.com> <20150506182942.GA15545@redhat.com>
	<554B3C22.4060305@sandisk.com> <20150527125732.GA15911@redhat.com>
	<5565E2EA.2000302@sandisk.com> <5565E3E3.4080801@sandisk.com>
	<20150527161415.GA22520@redhat.com>	<20150527170001.GA22548@redhat.com>
	<20150527223741.GA18501@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20150527223741.GA18501@redhat.com>
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
Cc: device-mapper development <dm-devel@redhat.com>, Christoph Hellwig <hch@lst.de>
List-Id: dm-devel.ids

On 05/28/15 00:37, Mike Snitzer wrote:
> FYI, I've staged a variant patch for 4.1 that is simpler; along with the
> various fixes I've picked up from Junichi and the leak fix I emailed
> earlier.  They are now in linux-next and available in this 'dm-4.1'
> specific branch (based on 4.1-rc5):
> https://git.kernel.org/cgit/linux/kernel/git/device-mapper/linux-dm.git/log/?h=dm-4.1
>
> Please try and let me know if your test works.

No data corruption was reported this time but a very large number of 
memory leaks were reported by kmemleak. The initiator system ran out of 
memory after some time due to these leaks. Here is an example of a leak 
reported by kmemleak:

unreferenced object 0xffff8800a39fc1a8 (size 96):
    comm "srp_daemon", pid 2116, jiffies 4294955508 (age 137.600s)
    hex dump (first 32 bytes):
      00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
      00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
    backtrace:
      [<ffffffff81600029>] kmemleak_alloc+0x49/0xb0
      [<ffffffff81167d19>] kmem_cache_alloc_node+0xd9/0x190
      [<ffffffff81425400>] scsi_init_request+0x20/0x40
      [<ffffffff812cbb98>] blk_mq_init_rq_map+0x228/0x290
      [<ffffffff812cbcc6>] blk_mq_alloc_tag_set+0xc6/0x220
      [<ffffffff81427488>] scsi_mq_setup_tags+0xc8/0xd0
      [<ffffffff8141e34f>] scsi_add_host_with_dma+0x6f/0x300
      [<ffffffffa04c62bf>] srp_create_target+0x11cf/0x1600 [ib_srp]
      [<ffffffff813f9c93>] dev_attr_store+0x13/0x20
      [<ffffffff81200a33>] sysfs_kf_write+0x43/0x60
      [<ffffffff811fff8b>] kernfs_fop_write+0x13b/0x1a0
      [<ffffffff81183e53>] __vfs_write+0x23/0xe0
      [<ffffffff81184524>] vfs_write+0xa4/0x1b0
      [<ffffffff811852d4>] SyS_write+0x44/0xb0
      [<ffffffff81613cdb>] system_call_fastpath+0x16/0x73
      [<ffffffffffffffff>] 0xffffffffffffffff

> I don't have SRP setup otherwise I'd try your reproducer you shared a
> while ago.  Any chance you're aware of a way to reproduce with LIO (and
> tcm utils)?

If I find a way to reproduce this with LIO I'll let you know.

Bart.
