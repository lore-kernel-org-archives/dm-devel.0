From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: Re: linux-next: Tree for August 27
Date: Fri, 29 Aug 2008 02:10:37 +0200
Message-ID: <200808290210.37211.bzolnier@gmail.com>
References: <20080827183453.eb651f50.sfr@canb.auug.org.au> <58cb370e0808270757k583c0fc2oc659bc8e2dd6c21e@mail.gmail.com> <200808272145.20627.bzolnier@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-next-owner@vger.kernel.org>
In-Reply-To: <200808272145.20627.bzolnier@gmail.com>
Content-Disposition: inline
Sender: linux-next-owner@vger.kernel.org
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>, dm-devel@redhat.com, Tejun Heo <tj@kernel.org>, Jens Axboe <jens.axboe@oracle.com>
List-Id: dm-devel.ids


[ Thanks to Ingo for handling x86-vs-UP build fix ]

On Wednesday 27 August 2008, Bartlomiej Zolnierkiewicz wrote:

[...]

> However now I'm getting device-mapper errors on 'cryptsetup create':
> 
> dmesg:
> ...
> device-mapper: core: bdget failed in dm_suspend
> device-mapper: ioctl: device doesn't appear to be in the dev hash table.
> ...
> 
> cryptsetup:
> ...
> Command failed: device-mapper: resume ioctl failed: Invalid argument
> ...
> 
> next-20080826 is fine

next-20080828 still isn't, The Lucky Winner is:

commit 9617fc8f8e599166590fe339de78a50bc5ab5e93
Author: Tejun Heo <tj@kernel.org>
Date:   Mon Aug 25 19:56:08 2008 +0900

    block: move __dev from disk to part0

    Move disk->__dev to part0->__dev.  This simplifies bdget_disk() and
    lookup_devt() and allows common sysfs attributes to be unified.
    part_to_disk() is updated to handle part0 -> disk.

    Signed-off-by: Tejun Heo <tj@kernel.org>
    Signed-off-by: Jens Axboe <jens.axboe@oracle.com>

Fix:

From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: [PATCH] block: fix part0 handling in bdget_disk() / blk_lookup_devt()

part0 is a "special" partition and doesn't need to have capacity set - this
fixes regression caused by "block: move __dev from disk to part0" commit.

Cc: Tejun Heo <tj@kernel.org>
Cc: Jens Axboe <jens.axboe@oracle.com>
Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
Jens, please integrate it into the original commit if feasible.

 block/genhd.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

Index: b/block/genhd.c
===================================================================
--- a/block/genhd.c
+++ b/block/genhd.c
@@ -543,7 +543,7 @@ extern struct block_device *bdget_disk(s
 	struct block_device *bdev = NULL;
 
 	part = disk_get_part(disk, partno);
-	if (part && part->nr_sects)
+	if (part && (part->nr_sects || partno == 0))
 		bdev = bdget(part_devt(part));
 	disk_put_part(part);
 
@@ -1001,7 +1001,7 @@ dev_t blk_lookup_devt(const char *name, 
 			continue;
 
 		part = disk_get_part(disk, partno);
-		if (part && part->nr_sects) {
+		if (part && (part->nr_sects || partno == 0)) {
 			devt = part_devt(part);
 			disk_put_part(part);
 			break;
--

On the somehow related topic - CONFIG_DEBUG_BLOCK_EXT_DEVT which is
introduced by commit 3e5ba59bbab878f60b8b87004ac55a464bddc819 ("block:
implement CONFIG_DEBUG_BLOCK_EXT_DEVT") is way too intrusive to be
enabled by default if CONFIG_DEBUG_KERNEL is set as it easily results
in no longer bootable systems (+ help entry for the new option says
"Say N if you are unsure.").

Tejun/Jens: please consider changing this.

> BTW it also seems that certain people need some encouragement
> to fix the nasty warning first reported by Randy two weeks ago
> (http://lkml.org/lkml/2008/8/14/207) and later addressed by
> Rusty (http://lkml.org/lkml/2008/8/16/40) (the solution is said
> to be fragile but there doesn't seem to be any better one on
> the horizon so...)

Solution is indeed very fragile - it managed to convert mere
WARNING into full BUG.  Amazing! ;)

BUG: unable to handle kernel NULL pointer dereference at 00000030
IP: [<c023540a>] driver_register+0x46/0xd6
*pde = 00000000
Oops: 0000 [#1] PREEMPT
last sysfs file:
Modules linked in:

Pid: 1, comm: swapper Not tainted (2.6.27-rc4-next-20080828-dirty #182)
EIP: 0060:[<c023540a>] EFLAGS: 00000246 CPU: 0
EIP is at driver_register+0x46/0xd6
EAX: 00000000 EBX: 00000000 ECX: c7801f60 EDX: c03c1838
ESI: c040807c EDI: c03c1908 EBP: 00000000 ESP: c7820f5c
 DS: 007b ES: 007b FS: 0000 GS: 0000 SS: 0068
Process swapper (pid: 1, ti=c7820000 task=c781fcc0 task.ti=c7820000)
Stack: 00000000 00000000 c040807c 00000000 00000000 c03e9f00 c0101122 c03e9ebb
       00000001 00000000 c0117300 c0307528 0000000f c04202b8 c782b330 00000001
       00000246 00000246 c780a5a0 c78022e0 00000000 c0355ff8 c0128b07 00000000
Call Trace:
 [<c03e9f00>] acpi_power_init+0x45/0x65
 [<c0101122>] _stext+0x3a/0x12a
 [<c03e9ebb>] acpi_power_init+0x0/0x65
 [<c0117300>] __enqueue_entity+0xcc/0xe2
 [<c0128b07>] __create_workqueue_key+0x14d/0x162
 [<c03d84ba>] kernel_init+0xec/0x150
 [<c03d83ce>] kernel_init+0x0/0x150
 [<c0103a47>] kernel_thread_helper+0x7/0x10
 =======================
Code: 00 74 06 83 7f 14 00 75 0c 83 78 20 00 74 14 83 7f 18 00 74 0e ff 37 68 02 c0 37 c0 e8 13 93 0c 00 5e 5d 8b 47 04 8b 17 8b 40 38 <8b> 40 30 e8 bc bb f9 ff 85 c0 74 24 8b 40 54 85 c0 74 1d 8b 40
EIP: [<c023540a>] driver_register+0x46/0xd6 SS:ESP 0068:c7820f5c
---[ end trace 4eaa2a86a8e2da22 ]---
Kernel panic - not syncing: Attempted to kill init!
