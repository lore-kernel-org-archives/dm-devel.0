From: akpm@osdl.org
Subject: +
	md-dm-reduce-stack-usage-with-stacked-block-devices-fixes.patch
	added to -mm tree
Date: Mon,  7 Nov 2005 15:39:00 -0800
Message-ID: <200511072338.jA7Ncc9o005010@shell0.pdx.osdl.net>
Reply-To: device-mapper development <dm-devel@redhat.com>
Return-path: <dm-devel-bounces@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: akpm@osdl.org, axboe@suse.de, dm-devel@redhat.com, neilb@suse.de, mm-commits@vger.kernel.org
List-Id: dm-devel.ids


The patch titled

     md-dm-reduce-stack-usage-with-stacked-block-devices-fixes

has been added to the -mm tree.  Its filename is

     md-dm-reduce-stack-usage-with-stacked-block-devices-fixes.patch


From: Andrew Morton <akpm@osdl.org>

Cc: Neil Brown <neilb@suse.de>
Cc: Jens Axboe <axboe@suse.de>
Cc: <dm-devel@redhat.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 block/ll_rw_blk.c     |    6 +++---
 include/linux/sched.h |    1 +
 2 files changed, 4 insertions(+), 3 deletions(-)

diff -puN block/ll_rw_blk.c~md-dm-reduce-stack-usage-with-stacked-block-devices-fixes block/ll_rw_blk.c
--- 25/block/ll_rw_blk.c~md-dm-reduce-stack-usage-with-stacked-block-devices-fixes	Mon Nov  7 15:38:51 2005
+++ 25-akpm/block/ll_rw_blk.c	Mon Nov  7 15:38:51 2005
@@ -2919,7 +2919,7 @@ void generic_make_request(struct bio *bi
 		return;
 	}
 	/* following loop may be a bit non-obvious, and so deserves some
-	 * explantion.
+	 * explanation.
 	 * Before entering the loop, bio->bi_next is NULL (as all callers
 	 * ensure that) so we have a list with a single bio.
 	 * We pretend that we have just taken it off a longer list, so
@@ -2933,8 +2933,8 @@ void generic_make_request(struct bio *bi
 	 * bio_tail or bi_next, and call into __generic_make_request again.
 	 *
 	 * The loop was structured like this to make only one call to
-	 * __generic_make_request (which is important as it is large and inlined)
-	 * and to keep the structure simple.
+	 * __generic_make_request (which is important as it is large and
+	 * inlined) and to keep the structure simple.
 	 */
 	BUG_ON(bio->bi_next);
 	do {
diff -puN include/linux/sched.h~md-dm-reduce-stack-usage-with-stacked-block-devices-fixes include/linux/sched.h
--- 25/include/linux/sched.h~md-dm-reduce-stack-usage-with-stacked-block-devices-fixes	Mon Nov  7 15:38:51 2005
+++ 25-akpm/include/linux/sched.h	Mon Nov  7 15:38:51 2005
@@ -39,6 +39,7 @@
 #include <linux/auxvec.h>	/* For AT_VECTOR_SIZE */
 
 struct exec_domain;
+struct bio;
 
 /*
  * cloning flags:
_

Patches currently in -mm which might be from akpm@osdl.org are

linus.patch
git-acpi-pciehprm_acpi-fix.patch
git-acpi-update-8250_acpi.patch
pnpacpi-handle-address-descriptors-in-_prs-fix-for-git-acpi-change.patch
i460-agp-warning-fixes.patch
pci-gart-fix.patch
git-netdev-all-ieee80211_get_payload-warning-fix.patch
gregkh-pci-pci-driver-owner-removal-agp-fixes.patch
gregkh-pci-pci-driver-owner-removal-fix-lpfc.patch
git-scsi-misc-fixup.patch
gregkh-pci-pci-driver-owner-removal-fix-aic94xx_init.patch
gregkh-usb-usb-pm-09-fix.patch
dma32-change-zones_shift-back-to-2-gfp_zonemask-too.patch
x86_64-enable_pagefaulttrace-warning-fix.patch
x86_64-vect-share-build-fix.patch
mm-zap_block-causes-redundant-work-warning-fix.patch
mm-implement-swap-prefetching-default-y.patch
mm-implement-swap-prefetching-tweaks.patch
swap-migration-v5-lru-operations-tweaks.patch
irda-donauboe-locking-fix.patch
acx1xx-wireless-driver-usb-is-bust.patch
acx1xx-allow-modular-build.patch
acx1xx-wireless-driver-spy_offset-went-away.patch
x86_64-div-by-zero-fix.patch
clear_buffer_uptodate-in-discard_buffer-check.patch
smbfs-readdir-vs-signal-fix.patch
rcu-signal-handling-tidies.patch
additional-catchup-rcu-signal-fixes-for-mm-warning-fix.patch
ext3_readdir-use-generic-readahead.patch
slob-introduce-the-slob-allocator-fixes.patch
cpuset-memory-pressure-meter-gcc-295-fix.patch
gregkh-pci-pci-driver-owner-removal-synclink_gt-fix.patch
changing-config_localversion-rebuilds-too-much-for-no-good-reason-ipw2200-fix.patch
remove-ext2-xattr-permission-checks-warning-fixes.patch
remove-xfs-xattr-permission-checks-warning-fixes.patch
replace-inode_update_time-with-file_update_time-switch-ntfs-to-touch_atime.patch
ocfs-update-atime-borkage.patch
ktimers-kt2-export-mktime.patch
edac-atomic-scrub-operations-fix.patch
edac-core-edac-support-code-ifdef-warnings.patch
edac-core-edac-support-code-fixes.patch
edac-core-edac-support-code-edac_mc_scrub_block-kunmap_atomic-fix.patch
edac-core-edac-support-code-edac_mc_scrub_block-kunmap_atomic-fix-2.patch
parport-constification-fix.patch
dlm-use-configfs-fix.patch
dvb-usb-urb-printk-fix.patch
sched-disable-preempt-in-idle-tasks-2-powerpc-fixes.patch
sched-resched-and-cpu_idle-rework-warning-fix.patch
reiser4-only.patch
reiser4-swsusp-build-fix.patch
reiser4-printk-warning-fix.patch
reiser4-mm-remove-pg_highmem-fix.patch
reiser4-page-private-fixes.patch
reiser4-big-update-div64-fix.patch
reiser4-remove-c99isms.patch
reiser4-big-update-update_atime-fixes.patch
reiser4_releasepage-gfp_t-fixes.patch
ide-promise-flushing-hang-fix.patch
md-dm-reduce-stack-usage-with-stacked-block-devices-fixes.patch
nr_blockdev_pages-in_interrupt-warning.patch
sysfs-crash-debugging.patch
device-suspend-debug.patch
tty-layer-buffering-revamp-pmac_zilog-warning-fix.patch
tty-layer-buffering-revamp-sunsab-build-fix.patch
isicom-pci-probing-added-fix-vs-gregkh-pci-pci-driver-owner-removal.patch
