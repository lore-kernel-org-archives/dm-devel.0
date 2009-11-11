From: Alasdair G Kergon <agk@redhat.com>
Subject: Re: dm: bind new table before destroying old
Date: Wed, 11 Nov 2009 01:20:40 +0000
Message-ID: <20091111012040.GP6208@agk-dp.fab.redhat.com>
References: <20091111011652.GK17055@agk-dp.fab.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20091111011652.GK17055@agk-dp.fab.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: dm-devel@redhat.com
Cc: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>, Mike Snitzer <snitzer@redhat.com>, Heinz Mauelshagen <mauelshagen@redhat.com>, Mikulas Patocka <mpatocka@redhat.com>, Zdenek Kabelac <zkabelac@redhat.com>, Jun'ichi Nomura <j-nomura@ce.jp.nec.com>, Milan Broz <mbroz@redhat.com>
List-Id: dm-devel.ids

And now a version that actually compiles:-)


From: Alasdair G Kergon <agk@redhat.com>

When replacing a mapped device's table during a 'resume', delay the
destruction of the old table until the new one is successfully in place.

This will make it easier for a later patch to transfer internal state
information from the old table to the new one (something we do not currently
support) while giving us more options for reversion if a later part
of the operation fails.

Devices are always in the suspended state during dm_swap_table().
This patch reinforces the requirement that all I/O must have been
flushed from the table targets while in this state (including any in
workqueues).  In the case of 'noflush' suspending, unprocessed
I/O should have been 'pushed back' to the dm core prior to this point,
for resubmission after the new table is in place.

Signed-off-by: Alasdair G Kergon <agk@redhat.com>
---
 drivers/md/dm-table.c |    3 +++
 drivers/md/dm.c       |   16 +++++++++++-----
 2 files changed, 14 insertions(+), 5 deletions(-)

Index: linux-2.6.32-rc6/drivers/md/dm-table.c
===================================================================
--- linux-2.6.32-rc6.orig/drivers/md/dm-table.c
+++ linux-2.6.32-rc6/drivers/md/dm-table.c
@@ -237,6 +237,9 @@ void dm_table_destroy(struct dm_table *t
 {
 	unsigned int i;
 
+	if (!t)
+		return;
+
 	while (atomic_read(&t->holders))
 		msleep(1);
 	smp_mb();
Index: linux-2.6.32-rc6/drivers/md/dm.c
===================================================================
--- linux-2.6.32-rc6.orig/drivers/md/dm.c
+++ linux-2.6.32-rc6/drivers/md/dm.c
@@ -2070,19 +2070,23 @@ static int __bind(struct mapped_device *
 	return 0;
 }
 
-static void __unbind(struct mapped_device *md)
+/*
+ * Returns unbound table for the caller to free.
+ */
+static struct dm_table *__unbind(struct mapped_device *md)
 {
 	struct dm_table *map = md->map;
 	unsigned long flags;
 
 	if (!map)
-		return;
+		return NULL;
 
 	dm_table_event_callback(map, NULL, NULL);
 	write_lock_irqsave(&md->map_lock, flags);
 	md->map = NULL;
 	write_unlock_irqrestore(&md->map_lock, flags);
-	dm_table_destroy(map);
+
+	return map;
 }
 
 /*
@@ -2175,7 +2179,7 @@ void dm_put(struct mapped_device *md)
 		}
 		dm_sysfs_exit(md);
 		dm_table_put(map);
-		__unbind(md);
+		dm_table_destroy(__unbind(md));
 		free_dev(md);
 	}
 }
@@ -2361,6 +2365,7 @@ static void dm_rq_barrier_work(struct wo
  */
 int dm_swap_table(struct mapped_device *md, struct dm_table *table)
 {
+	struct dm_table *map;
 	struct queue_limits limits;
 	int r = -EINVAL;
 
@@ -2381,8 +2386,9 @@ int dm_swap_table(struct mapped_device *
 		goto out;
 	}
 
-	__unbind(md);
+	map = __unbind(md);
 	r = __bind(md, table, &limits);
+	dm_table_destroy(map);
 
 out:
 	mutex_unlock(&md->suspend_lock);
