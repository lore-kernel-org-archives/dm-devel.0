From: Takahiro Yasui <tyasui@redhat.com>
Subject: [RFC][PATCH][BUGFIX] dm-raid1: fix NULL pointer
 dereference during suspend procedure
Date: Wed, 06 Jan 2010 17:11:32 -0500
Message-ID: <4B450A94.80006@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Alasdair G Kergon <agk@redhat.com>
Cc: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

Alasdair,

On 2.6.33-rc1 kernel, I hit the bug when I suspended the failed
mirror by dmsetup command.

BUG: unable to handle kernel NULL pointer dereference at 00000020
IP: [<f94f38e2>] dm_rh_dec+0x35/0xa1 [dm_region_hash]
...
EIP: 0060:[<f94f38e2>] EFLAGS: 00010046 CPU: 0
EIP is at dm_rh_dec+0x35/0xa1 [dm_region_hash]
EAX: 00000286 EBX: 00000000 ECX: 00000286 EDX: 00000000
ESI: eff79eac EDI: eff79e80 EBP: f6915cd4 ESP: f6915cc4
 DS: 007b ES: 007b FS: 00d8 GS: 0033 SS: 0068
Process dmsetup (pid: 2849, ti=f6914000 task=eff03e80 task.ti=f6914000)
 ...
Call Trace:
 [<f9530af6>] ? mirror_end_io+0x53/0x1b1 [dm_mirror]
 [<f9413104>] ? clone_endio+0x4d/0xa2 [dm_mod]
 [<f9530aa3>] ? mirror_end_io+0x0/0x1b1 [dm_mirror]
 [<f94130b7>] ? clone_endio+0x0/0xa2 [dm_mod]
 [<c02d6bcb>] ? bio_endio+0x28/0x2b
 [<f952f303>] ? hold_bio+0x2d/0x62 [dm_mirror]
 [<f952f942>] ? mirror_presuspend+0xeb/0xf7 [dm_mirror]
 [<c02aa3e2>] ? vmap_page_range+0xb/0xd
 [<f9414c8d>] ? suspend_targets+0x2d/0x3b [dm_mod]
 [<f9414ca9>] ? dm_table_presuspend_targets+0xe/0x10 [dm_mod]
 [<f941456f>] ? dm_suspend+0x4d/0x150 [dm_mod]
 [<f941767d>] ? dev_suspend+0x55/0x18a [dm_mod]
 [<c0343762>] ? _copy_from_user+0x42/0x56
 [<f9417fb0>] ? dm_ctl_ioctl+0x22c/0x281 [dm_mod]
 [<f9417628>] ? dev_suspend+0x0/0x18a [dm_mod]
 [<f9417d84>] ? dm_ctl_ioctl+0x0/0x281 [dm_mod]
 [<c02c3c4b>] ? vfs_ioctl+0x22/0x85
 [<c02c422c>] ? do_vfs_ioctl+0x4cb/0x516
 [<c02c42b7>] ? sys_ioctl+0x40/0x5a
 [<c0202858>] ? sysenter_do_call+0x12/0x28


Here is a patch to fix this bug.

In case that the DM_RAID1_HANDLE_ERRORS flag is set, the recent dm-raid1
keeps failed bios in the hold list and those bios are processed when
the mirror device is being suspended. This process expects __rh_lookup()
returns a valid region address, but it could returns NULL if the error
recovery had failed.

This bug could be fixed by preventing region data from being released
when error recovery is failed, but I think that it is more complicated.

I appreciate your comments.

Thanks,
Taka


Signed-off-by: Takahiro Yasui <tyasui@redhat.com>
---
 drivers/md/dm-region-hash.c |    9 +++++++++
 1 file changed, 9 insertions(+)

Index: linux-2.6.33-rc1-dm/drivers/md/dm-region-hash.c
===================================================================
--- linux-2.6.33-rc1-dm.orig/drivers/md/dm-region-hash.c
+++ linux-2.6.33-rc1-dm/drivers/md/dm-region-hash.c
@@ -540,6 +540,15 @@ void dm_rh_dec(struct dm_region_hash *rh
 	reg = __rh_lookup(rh, region);
 	read_unlock(&rh->hash_lock);
 
+	/*
+	 * reg could be NULL in case this function is called from
+	 * mirror_presuspend() after recovery process failed.
+	 * When reg is NULL, we can just return because the state
+	 * of the region is already DM_RH_NOSYNC.
+	 */
+	if (!reg)
+		return;
+
 	spin_lock_irqsave(&rh->region_lock, flags);
 	if (atomic_dec_and_test(&reg->pending)) {
 		/*

-- 
Takahiro Yasui
Hitachi Computer Products (America), Inc.
