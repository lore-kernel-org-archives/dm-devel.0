From: Junichi Nomura <j-nomura@ce.jp.nec.com>
Subject: [PATCH] dm: fix AB-BA deadlock in __dm_destroy()
Date: Thu, 1 Oct 2015 08:31:51 +0000
Message-ID: <20151001083149.GA13075@xzibit.linux.bs1.fc.nec.co.jp>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Language: ja-JP
Content-ID: <90D2418C22844A4F947D211F0ABC9344@gisp.nec.co.jp>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: device-mapper development <dm-devel@redhat.com>, Mikulas Patocka <mpatocka@redhat.com>
List-Id: dm-devel.ids

__dm_destroy() takes io_barrier SRCU lock (dm_get_live_table) and
suspend_lock in reverse order. That can cause AB-BA deadlock:

Example:

  __dm_destroy                    dm_swap_table
  ---------------------------------------------------
                                  mutex_lock(suspend_lock)
  dm_get_live_table()
    srcu_read_lock(io_barrier)
                                  dm_sync_table()
                                    synchronize_srcu(io_barrier)
                                      .. waiting for dm_put_live_table()
  mutex_lock(suspend_lock)
    .. waiting for suspend_lock

This patch fixes the lock ordering.

Signed-off-by: Jun'ichi Nomura <j-nomura@ce.jp.nec.com>
Fixes: ab7c7bb6f4ab ("dm: hold suspend_lock while suspending device during device deletion")
Cc: Mikulas Patocka <mpatocka@redhat.com>
---
The problem could be reproduced with this script but it might take long.
(In my environment, it took more than 10 minutes)

-- cut here --
#!/bin/bash

t0="0 1024 zero"
t1="0 1024 error"
mapname=testmap

work1()
{
	while true; do
		dmsetup create --notable $mapname
		echo "$t0" | dmsetup load $mapname
		dmsetup resume $mapname
		dmsetup remove_all
	done
}

work2()
{
	while true; do
		echo "$t1" | dmsetup load $mapname
		dmsetup resume $mapname
		echo "$t0" | dmsetup load $mapname
		dmsetup resume $mapname
	done
}

work1 &
work2 &
wait
-- cut here --

When starting the script, it will emit a lot of errors such as "No such
device or address" and stops when the deadlock occurs.
Backtrace of dmsetup will look like this:

  # ps auxw|grep dmsetup
  root     32209  0.0  0.0 130024  3060 pts/0    D+   03:26   0:00 dmsetup resume testmap
  root     32210  0.0  0.0 130024  3048 pts/0    D+   03:26   0:00 dmsetup remove_all

  # cat /proc/32210/stack 
  [<ffffffffa00029ea>] __dm_destroy+0xba/0x280 [dm_mod]
  [<ffffffffa0003ec3>] dm_destroy+0x13/0x20 [dm_mod]
  [<ffffffffa0007edd>] dm_hash_remove_all+0x6d/0x130 [dm_mod]
  [<ffffffffa0007fc2>] remove_all+0x22/0x30 [dm_mod]
  [<ffffffffa0009a65>] ctl_ioctl+0x255/0x4d0 [dm_mod]
  [<ffffffffa0009cf3>] dm_ctl_ioctl+0x13/0x20 [dm_mod]
  [<ffffffff81210c82>] do_vfs_ioctl+0x2d2/0x4b0
  [<ffffffff81210ed9>] SyS_ioctl+0x79/0x90
  [<ffffffff816859ee>] entry_SYSCALL_64_fastpath+0x12/0x71
  [<ffffffffffffffff>] 0xffffffffffffffff

  # cat /proc/32209/stack 
  [<ffffffff810e1d34>] __synchronize_srcu+0xf4/0x130
  [<ffffffff810e1d94>] synchronize_srcu+0x24/0x30
  [<ffffffffa000406d>] dm_swap_table+0x17d/0x2e0 [dm_mod]
  [<ffffffffa00090fa>] dev_suspend+0x9a/0x240 [dm_mod]
  [<ffffffffa0009a65>] ctl_ioctl+0x255/0x4d0 [dm_mod]
  [<ffffffffa0009cf3>] dm_ctl_ioctl+0x13/0x20 [dm_mod]
  [<ffffffff81210c82>] do_vfs_ioctl+0x2d2/0x4b0
  [<ffffffff81210ed9>] SyS_ioctl+0x79/0x90
  [<ffffffff816859ee>] entry_SYSCALL_64_fastpath+0x12/0x71
  [<ffffffffffffffff>] 0xffffffffffffffff

diff --git a/drivers/md/dm.c b/drivers/md/dm.c
index 6264781..7289ece 100644
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -2837,8 +2837,6 @@ static void __dm_destroy(struct mapped_device *md, bool wait)
 
 	might_sleep();
 
-	map = dm_get_live_table(md, &srcu_idx);
-
 	spin_lock(&_minor_lock);
 	idr_replace(&_minor_idr, MINOR_ALLOCED, MINOR(disk_devt(dm_disk(md))));
 	set_bit(DMF_FREEING, &md->flags);
@@ -2852,14 +2850,14 @@ static void __dm_destroy(struct mapped_device *md, bool wait)
 	 * do not race with internal suspend.
 	 */
 	mutex_lock(&md->suspend_lock);
+	map = dm_get_live_table(md, &srcu_idx);
 	if (!dm_suspended_md(md)) {
 		dm_table_presuspend_targets(map);
 		dm_table_postsuspend_targets(map);
 	}
-	mutex_unlock(&md->suspend_lock);
-
 	/* dm_put_live_table must be before msleep, otherwise deadlock is possible */
 	dm_put_live_table(md, srcu_idx);
+	mutex_unlock(&md->suspend_lock);
 
 	/*
 	 * Rare, but there may be I/O requests still going to complete,
