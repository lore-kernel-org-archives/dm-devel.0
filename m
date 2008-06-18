From: Christof Schmitt <christof.schmitt@de.ibm.com>
Subject: Re: might_sleep warning in multipath_dtr
Date: Wed, 18 Jun 2008 09:32:28 +0200
Message-ID: <20080618073228.GA13557@schmichrtp.de.ibm.com>
References: <20080507083716.GA30401@schmichrtp.de.ibm.com>
	<20080507132820.GN8827@agk.fab.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20080507132820.GN8827@agk.fab.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: device-mapper development <dm-devel@redhat.com>
Cc: Alasdair G Kergon <agk@redhat.com>
List-Id: dm-devel.ids

On Wed, May 07, 2008 at 02:28:20PM +0100, Alasdair G Kergon wrote:
> On Wed, May 07, 2008 at 10:37:16AM +0200, Christof Schmitt wrote:
> >     <4> [<000003e00008f79c>] multipath_dtr+0x38/0x50 [dm_multipath]
> >     <4> [<000003e000077e4a>] dm_table_put+0xae/0x134 [dm_mod]
> >     <4> [<000003e000076020>] dm_any_congested+0x50/0x88 [dm_mod]
> 
> > I don't know, if this exact situation is reproducible, but we have a
> > memory dump that should have some more data.
> 
> Well I'm guessing dm_any_congested() ran alongside a table reload, such
> that dm_any_congested() was still referencing the old table after
> dm_swap_table() removed it.
> 
> IOW There needs to be better synchronisation between those two
> functions.

If the dm_swap_table should take care of the destruction, the attached
patch enforces this by letting the __unbind function wait until all
other users of the table did free their references to the table.

With this patch, the system survived a series of multipath failover
tests.

Signed-off-by: Christof Schmitt <christof.schmitt@de.ibm.com>
---
 drivers/md/dm-table.c |    7 +++++++
 drivers/md/dm.c       |    1 +
 drivers/md/dm.h       |    1 +
 3 files changed, 9 insertions(+)

--- a/drivers/md/dm-table.c	2008-04-17 11:08:04.000000000 +0200
+++ b/drivers/md/dm-table.c	2008-06-16 17:00:36.000000000 +0200
@@ -27,6 +27,7 @@
 struct dm_table {
 	struct mapped_device *md;
 	atomic_t holders;
+	wait_queue_head_t unbind_wait;
 
 	/* btree table */
 	unsigned int depth;
@@ -227,6 +228,7 @@ int dm_table_create(struct dm_table **re
 
 	INIT_LIST_HEAD(&t->devices);
 	atomic_set(&t->holders, 1);
+	init_waitqueue_head(&t->unbind_wait);
 
 	if (!num_targets)
 		num_targets = KEYS_PER_NODE;
@@ -1023,6 +1025,11 @@ struct mapped_device *dm_table_get_md(st
 	return t->md;
 }
 
+void dm_table_wait(struct dm_table *map)
+{
+	wait_event(map->unbind_wait, atomic_read(&map->holders) == 1);
+}
+
 EXPORT_SYMBOL(dm_vcalloc);
 EXPORT_SYMBOL(dm_get_device);
 EXPORT_SYMBOL(dm_put_device);
--- a/drivers/md/dm.c	2008-04-17 11:08:04.000000000 +0200
+++ b/drivers/md/dm.c	2008-06-16 16:57:24.000000000 +0200
@@ -1189,6 +1189,7 @@ static void __unbind(struct mapped_devic
 	write_lock(&md->map_lock);
 	md->map = NULL;
 	write_unlock(&md->map_lock);
+	dm_table_wait(map);
 	dm_table_put(map);
 }
 
--- a/drivers/md/dm.h	2008-01-25 13:26:14.000000000 +0100
+++ b/drivers/md/dm.h	2008-06-16 16:56:32.000000000 +0200
@@ -111,6 +111,7 @@ void dm_table_postsuspend_targets(struct
 int dm_table_resume_targets(struct dm_table *t);
 int dm_table_any_congested(struct dm_table *t, int bdi_bits);
 void dm_table_unplug_all(struct dm_table *t);
+void dm_table_wait(struct dm_table *map);
 
 /*
  * To check the return value from dm_table_find_target().
