From: Bart Van Assche <bart.vanassche@sandisk.com>
Subject: [PATCH] dm mpath: Fix a dm_blk_ioctl() deadlock
Date: Tue, 28 Jun 2016 11:07:46 +0200
Message-ID: <c987a4ca-4b55-0b3a-a414-2608f2ded132@sandisk.com>
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
To: Mike Snitzer <snitzer@redhat.com>
Cc: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

Avoid that submitting an ioctl to a dm device while an underlying
block device is being removed triggers a deadlock. The call traces
reported by SysRq-w if the deadlock occurs are as follows:

sysrq: SysRq : Show Blocked State
  task                        PC stack   pid father
systemd-udevd   D ffff8803683f7878     0  6684    494 0x00000006
Call Trace:
 [<ffffffff815acf97>] schedule+0x37/0x90
 [<ffffffff815b14bb>] schedule_timeout+0x18b/0x230
 [<ffffffff815ac61f>] io_schedule_timeout+0x9f/0x110
 [<ffffffff815ad786>] bit_wait_io+0x16/0x60
 [<ffffffff815ad579>] __wait_on_bit_lock+0x49/0xa0
 [<ffffffff8111b3d6>] __lock_page+0xb6/0xc0
 [<ffffffff8112f6a4>] truncate_inode_pages_range+0x444/0x790
 [<ffffffff8112fa00>] truncate_inode_pages+0x10/0x20
 [<ffffffff811d6ef0>] kill_bdev+0x30/0x40
 [<ffffffff811d8201>] __blkdev_put+0x71/0x360
 [<ffffffff811d8539>] blkdev_put+0x49/0x170
 [<ffffffff811d8680>] blkdev_close+0x20/0x30
 [<ffffffff8119e338>] __fput+0xe8/0x1f0
 [<ffffffff8119e479>] ____fput+0x9/0x10
 [<ffffffff8107876c>] task_work_run+0x7c/0xb0
 [<ffffffff8105d047>] do_exit+0x3b7/0xb10
 [<ffffffff8105d82b>] do_group_exit+0x4b/0xc0
 [<ffffffff81068f25>] get_signal+0x1c5/0x7f0
 [<ffffffff8101a1a3>] do_signal+0x23/0x700
 [<ffffffff810020d3>] exit_to_usermode_loop+0x73/0xb0
 [<ffffffff81002580>] syscall_return_slowpath+0xb0/0xc0
 [<ffffffff815b2537>] entry_SYSCALL_64_fastpath+0xaa/0xac
systemd-udevd   D ffff880062613cd8     0  6767    494 0x00000000
Call Trace:
 [<ffffffff815acf97>] schedule+0x37/0x90
 [<ffffffff815b1487>] schedule_timeout+0x157/0x230
 [<ffffffff810c0d33>] msleep+0x33/0x40
 [<ffffffffa0341a5b>] dm_grab_bdev_for_ioctl+0x7b/0x150 [dm_mod]
 [<ffffffffa0341e25>] dm_blk_ioctl+0x35/0x80 [dm_mod]
 [<ffffffff812b36eb>] blkdev_ioctl+0x25b/0x980
 [<ffffffff811d79b8>] block_ioctl+0x38/0x40
 [<ffffffff811afd5e>] do_vfs_ioctl+0x8e/0x660
 [<ffffffff811b036c>] SyS_ioctl+0x3c/0x70
 [<ffffffff815b24a9>] entry_SYSCALL_64_fastpath+0x1c/0xac

Signed-off-by: Bart Van Assche <bart.vanassche@sandisk.com>
Cc: <stable@vger.kernel.org>
---
 drivers/md/dm.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/md/dm.c b/drivers/md/dm.c
index 1b2f962..f3564e1 100644
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -630,7 +630,8 @@ retry:
 
 out:
 	dm_put_live_table(md, srcu_idx);
-	if (r == -ENOTCONN && !fatal_signal_pending(current)) {
+	if (r == -ENOTCONN && !fatal_signal_pending(current) &&
+	    !blk_queue_dying(bdev_get_queue(*bdev))) {
 		msleep(10);
 		goto retry;
 	}
-- 
2.8.4
