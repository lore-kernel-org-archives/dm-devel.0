From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: dm: fix free_rq_clone() NULL pointer when requeueing
 unmapped request
Date: Thu, 30 Apr 2015 08:56:06 -0400
Message-ID: <20150430125606.GB29757@redhat.com>
References: <553F7474.70905@sandisk.com> <20150429132029.GA3876@lst.de>
	<20150429133433.GA23127@redhat.com>
	<20150429185345.GA5975@redhat.com> <55412CE0.4060909@sandisk.com>
	<20150429195342.GA6110@redhat.com>
	<20150430091105.GC1200@ak-desktop.emea.nsn-net.net>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20150430091105.GC1200@ak-desktop.emea.nsn-net.net>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Aaro Koskinen <aaro.koskinen@nokia.com>
Cc: Bart Van Assche <bart.vanassche@sandisk.com>, device-mapper development <dm-devel@redhat.com>, Christoph Hellwig <hch@lst.de>
List-Id: dm-devel.ids

On Thu, Apr 30 2015 at  5:11am -0400,
Aaro Koskinen <aaro.koskinen@nokia.com> wrote:

> Hi,
> 
> On Wed, Apr 29, 2015 at 03:53:42PM -0400, Mike Snitzer wrote:
> > http://git.kernel.org/cgit/linux/kernel/git/snitzer/linux.git/log/?h=wip2
> > 
> > Anyway, here it is rebased to 4.1-rc1 (BTW, I'm open to dropping the
> > WARN_ON_ONCE but I need to research further.. if you guys think that
> > there are perfectly resonable ways to explain why clone->q is NULL in
> > the IO completion path then I'm all ears):
> 
> This fixes the crash I'm seeing, but the WARN ON is still triggering
> on almost (*) every boot. I'm using rootfs where multipathd is built
> and started with the default configuration it ships with, and it looks
> like this:

Can you show multipath -ll for the device in question?  Are you saying
that you're using multipath for the root device?

Do you have the scsi_dh module that the device uses getting preloaded
at boot? (e.g. add "rdloaddriver=scsi_dh_alua" to the grub kernel
commandline).  Alternatively the relevant scsi_dh can just be built-in
to the kernel, that way it'll always get attached when the SCSI device
scan occurs.

> [  OK  ] Started Device-Mapper Multipath Device Controller.
> [  OK  ] Started Network Service.
>          Starting Network Name Resolution...
> [  OK  ] Reached target Network.
>          Starting GlusterFS, a clustered file-system server...
> [   16.562604] device-mapper: multipath service-time: version 0.2.0 loaded
> [   16.586067] device-mapper: table: 253:0: multipath: error getting device
> [   16.586428] device-mapper: ioctl: error adding target to table
> [   16.679048] device-mapper: multipath: Failing path 8:16.
> [  OK  ] Started Network Name Resolution.
> [*     ] A start job is running for GlusterF...le-system server (13s / 5min 7s)
> [...]
> [   23.034550] ------------[ cut here ]------------
> [   23.035525] WARNING: CPU: 0 PID: 3 at /home/aakoskin/linux/drivers/md/dm.c:1090 free_rq_clone+0xbc/0x130 [dm_mod]()
> [...]
> [   23.041885] Call Trace:
> [   23.042064] [<ffffffff8010bc90>] show_stack+0x78/0x90
> [   23.042505] [<ffffffff80133764>] warn_slowpath_common+0xa4/0xe0
> [   23.043019] [<ffffffffc000e37c>] free_rq_clone+0xbc/0x130 [dm_mod]
> [   23.043412] [<ffffffffc000e830>] dm_softirq_done+0x198/0x2c0 [dm_mod]
> [   23.043775] [<ffffffff803388dc>] blk_done_softirq+0xac/0xc0
> [   23.044076] [<ffffffff80136894>] __do_softirq+0x174/0x368
> [   23.044376] [<ffffffff80136af8>] run_ksoftirqd+0x70/0xa8
> [   23.044668] [<ffffffff8015604c>] smpboot_thread_fn+0x1bc/0x1c8
> [   23.044980] [<ffffffff80152440>] kthread+0xe0/0xf8
> [   23.045247] [<ffffffff80105768>] ret_from_kernel_thread+0x14/0x1c
> [   23.045673]
> [   23.045824] ---[ end trace e0e5377c5d7b858b ]---
> [   23.046326] blk_update_request: I/O error, dev dm-0, sector 0
> [   23.056271] blk_update_request: I/O error, dev dm-0, sector 0
> [   23.056745] Buffer I/O error on dev dm-0, logical block 0, async page read
> [   23.070427] blk_update_request: I/O error, dev dm-0, sector 0
> [   23.070833] Buffer I/O error on dev dm-0, logical block 0, async page read
> 
> (*) Strange thing is that it only happens when my test bot is booting
> the system. With interactive console it's OK without any I/O errors.
> 
> A.
