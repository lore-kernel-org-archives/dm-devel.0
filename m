From: akpm@osdl.org
Subject: + dm-raid1-fix-waiting-for-io-on-suspend-fix.patch added
	to -mm tree
Date: Tue, 07 Nov 2006 12:29:22 -0800
Message-ID: <200611072029.kA7KTMfh015230@shell0.pdx.osdl.net>
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
To: mm-commits@vger.kernel.org
Cc: akpm@osdl.org, dm-devel@redhat.com, agk@redhat.com
List-Id: dm-devel.ids


The patch titled
     dm-raid1-fix-waiting-for-io-on-suspend-fix
has been added to the -mm tree.  Its filename is
     dm-raid1-fix-waiting-for-io-on-suspend-fix.patch

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: dm-raid1-fix-waiting-for-io-on-suspend-fix
From: Andrew Morton <akpm@osdl.org>

Give _kmirrord_recovery_stopped static scope.

Cc: Jonathan E Brassow <jbrassow@redhat.com>
Cc: Alasdair G Kergon <agk@redhat.com>
Cc: <dm-devel@redhat.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/md/dm-raid1.c |    2 +-
 1 files changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/md/dm-raid1.c~dm-raid1-fix-waiting-for-io-on-suspend-fix drivers/md/dm-raid1.c
--- a/drivers/md/dm-raid1.c~dm-raid1-fix-waiting-for-io-on-suspend-fix
+++ a/drivers/md/dm-raid1.c
@@ -24,7 +24,7 @@
 
 static struct workqueue_struct *_kmirrord_wq;
 static struct work_struct _kmirrord_work;
-DECLARE_WAIT_QUEUE_HEAD(_kmirrord_recovery_stopped);
+static DECLARE_WAIT_QUEUE_HEAD(_kmirrord_recovery_stopped);
 
 static inline void wake(void)
 {
_

Patches currently in -mm which might be from akpm@osdl.org are

origin.patch
dm-raid1-fix-waiting-for-io-on-suspend-fix.patch
revert-pci-quirk-for-ibm-dock-ii-cardbus-controllers.patch
revert-generic_file_buffered_write-handle-zero-length-iovec-segments.patch
revert-generic_file_buffered_write-deadlock-on-vectored-write.patch
generic_file_buffered_write-cleanup.patch
mm-fix-pagecache-write-deadlocks.patch
fs-prepare_write-fixes-fuse-fix.patch
fs-prepare_write-fixes-fat-fix.patch
git-acpi.patch
acpi-asus-s3-resume-fix.patch
sony_apci-resume.patch
git-cpufreq-prep.patch
git-cpufreq.patch
nozomi-warning-fixes.patch
nozomi-irq-flags-fixes.patch
update-uio_interrupt.patch
git-dvb.patch
git-ia64.patch
git-input.patch
git-input-fixup.patch
git-libata-all.patch
via-pata-controller-xfer-fixes-fix.patch
git-mtd.patch
git-netdev-all.patch
libphy-dont-do-that.patch
update-smc91x-driver-with-arm-versatile-board-info.patch
drivers-net-ns83820c-add-paramter-to-disable-auto.patch
git-net.patch
net-uninline-xfrm_selector_match.patch
net-uninline-skb_put.patch
ioat-warning-fix.patch
revert-scsi-ips-soft-lockup-during-reset-initialization.patch
scsi-ips-soft-lockup-during-reset-initialization-2.patch
git-watchdog.patch
revert-x86_64-mm-cpa-clflush.patch
prep-for-paravirt-be-careful-about-touching-bios-warning-fix.patch
prep-for-paravirt-desch-clearer-parameter-names-fix.patch
paravirtualization-patch-inline-replacements-for-fix-2.patch
xfs-rename-uio_read.patch
touchkit-ps-2-touchscreen-driver.patch
get-rid-of-zone_table.patch
new-scheme-to-preempt-swap-token-tidy.patch
balance_pdgat-cleanup.patch
vmalloc-optimization-cleanup-bugfixes-tweak.patch
radix-tree-rcu-lockless-readside.patch
acx1xx-wireless-driver.patch
swsusp-add-resume_offset-command-line-parameter-rev-2.patch
add-include-linux-freezerh-and-move-definitions-from-ueagle-fix.patch
cciss-set-sector_size-to-2048-for-performance-tidy.patch
deprecate-smbfs-in-favour-of-cifs.patch
edac-new-opteron-athlon64-memory-controller-driver.patch
kbuild-dont-put-temp-files-in-the-source-tree.patch
lockdep-annotate-nfs-nfsd-in-kernel-sockets-tidy.patch
drivers-add-lcd-support-3-Kconfig-fix.patch
setup_irq-better-mismatch-debugging.patch
probe_kernel_address-needs-to-do-set_fs.patch
slab-use-probe_kernel_address.patch
lockdep-spin_lock_irqsave_nested-fix.patch
lockdep-spin_lock_irqsave_nested-fix-2.patch
aio-use-prepare_to_wait.patch
exar-quad-port-serial-fix.patch
vfs_getattr-remove-dead-code.patch
ext3-uninline-large-functions.patch
ext4-uninline-large-functions.patch
uninline-module_put.patch
sleep-profiling-fixes.patch
pktcdvd-bio-write-congestion-using-blk_congestion_wait-fix.patch
bug-test-1.patch
fsstack-introduce-fsstack_copy_attrinode_-tidy.patch
log2-implement-a-general-integer-log2-facility-in-the-kernel-fix.patch
log2-implement-a-general-integer-log2-facility-in-the-kernel-vs-git-cryptodev.patch
log2-implement-a-general-integer-log2-facility-in-the-kernel-ppc-fix.patch
add-process_session-helper-routine-deprecate-old-field-tidy.patch
add-process_session-helper-routine-deprecate-old-field-fix-warnings.patch
add-process_session-helper-routine-deprecate-old-field-fix-warnings-2.patch
fs-cache-provide-a-filesystem-specific-syncable-page-bit-ext4.patch
fs-cache-make-kafs-use-fs-cache-fix.patch
fs-cache-make-kafs-use-fs-cache-vs-streamline-generic_file_-interfaces-and-filemap.patch
nfs-use-local-caching-12-fix.patch
fs-cache-cachefiles-a-cache-that-backs-onto-a-mounted-filesystem-log2-fix.patch
mxser-session-warning-fix.patch
tty-switch-to-ktermios-and-new-framework-warning-fix.patch
tty-switch-to-ktermios-bluetooth-fix.patch
drivers-isdn-handcrafted-min-max-macro-removal-fix.patch
kernel-schedc-whitespace-cleanups-more.patch
swap_prefetch-vs-zoned-counters.patch
add-include-linux-freezerh-and-move-definitions-from-prefetch.patch
readahead-sysctl-parameters.patch
make-copy_from_user_inatomic-not-zero-the-tail-on-i386-vs-reiser4.patch
resier4-add-include-linux-freezerh-and-move-definitions-from.patch
make-kmem_cache_destroy-return-void-reiser4.patch
reiser4-hardirq-include-fix.patch
reiser4-run-truncate_inode_pages-in-reiser4_delete_inode.patch
reiser4-get_sb_dev-fix.patch
reiser4-vs-zoned-allocator.patch
hpt3xx-rework-rate-filtering-tidy.patch
various-fbdev-files-mark-structs-fix.patch
statistics-infrastructure-fix-buffer-overflow-in-histogram-with-linear-tidy.patch
gtod-persistent-clock-support-i386.patch
hrtimers-state-tracking.patch
clockevents-drivers-for-i386.patch
gtod-mark-tsc-unusable-for-highres-timers.patch
round_jiffies-infrastructure-fix.patch
kevent-core-files-fix.patch
kevent-core-files-s390-hack.patch
kevent-socket-notifications-fix-2.patch
kevent-socket-notifications-fix-4.patch
kevent-timer-notifications-fix.patch
kevent_user_wait-retval-fix.patch
nr_blockdev_pages-in_interrupt-warning.patch
device-suspend-debug.patch
mutex-subsystem-synchro-test-module-fix.patch
slab-leaks3-default-y.patch
x86-kmap_atomic-debugging.patch
restore-rogue-readahead-printk.patch
put_bh-debug.patch
acpi_format_exception-debug.patch
jmicron-warning-fix.patch
squash-ipc-warnings.patch
squash-udf-warnings.patch
