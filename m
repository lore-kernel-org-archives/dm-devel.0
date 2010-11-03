From: Mike Snitzer <snitzer@redhat.com>
Subject: [PATCH] dm: remove extra locking when changing device
	size
Date: Wed, 3 Nov 2010 14:06:12 -0400
Message-ID: <20101103180611.GA15355@redhat.com>
References: <20101019220711.GA25169@redhat.com>
	<20101029215001.GA4827@redhat.com> <4CCE69E4.9030406@ce.jp.nec.com>
	<20101101131455.GA30753@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20101101131455.GA30753@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: dm-devel@redhat.com
List-Id: dm-devel.ids

DM no longer needlessly holds md->bdev->bd_inode->i_mutex when changing
the size of a DM device.  This additional locking is unnecessary because
i_size_write() is already protected by the existing critical section in
dm_swap_table().  DM already has a reference on md->bdev so the
associated bd_inode may be changed without lifetime concerns.

A negative side-effect of having held md->bdev->bd_inode->i_mutex was
that a concurrent DM device resize and flush (via fsync) would
deadlock.  Dropping md->bdev->bd_inode->i_mutex eliminates this
potential for deadlock.  The following reproducer no longer deadlocks:
https://www.redhat.com/archives/dm-devel/2009-July/msg00284.html

Signed-off-by: Mike Snitzer <snitzer@redhat.com>
Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
---
 drivers/md/dm.c |    7 +++++--
 1 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/md/dm.c b/drivers/md/dm.c
index 7cb1352..1794dee 100644
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -1996,9 +1996,12 @@ static void __set_size(struct mapped_device *md, sector_t size)
 {
 	set_capacity(md->disk, size);
 
-	mutex_lock(&md->bdev->bd_inode->i_mutex);
+	/*
+	 * Only DM is allowed to change the size of a DM device.
+	 * i_size_write() is protected by the dm_swap_table() critical
+	 * section that uses md->suspend_lock.
+	 */
 	i_size_write(md->bdev->bd_inode, (loff_t)size << SECTOR_SHIFT);
-	mutex_unlock(&md->bdev->bd_inode->i_mutex);
 }
 
 /*
