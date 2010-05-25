From: Tomohiro Kusumi <kusumi.tomohiro@jp.fujitsu.com>
Subject: [PATCH] multipath: generic timeout function in dm-mpath
Date: Tue, 25 May 2010 22:25:24 +0900
Message-ID: <4BFBCFC4.5090400@jp.fujitsu.com>
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
To: dm-devel@redhat.com
Cc: Mikulas Patocka <mpatocka@redhat.com>, Tomohiro Kusumi <kusumi.tomohiro@jp.fujitsu.com>, Alasdair G Kergon <agk@redhat.com>
List-Id: dm-devel.ids

Hi,

This patch is a trial patch for handling i/o latency issue in multipath layer.
Let me explain details.

I've been looking for ways to minimize impact of faulty (scsi) drive in a multipath
failover environment. Our major problem is that it takes quite long time before
dm-mpath can failover to alternative path not because of device-mapper, but because
of huge recovery operation by scsi driver's timeout handler. device-mapper can't
take care of timed out i/o until scsi subsystem finishes all the device/bus/host
reset handlers, retries and everything which I think conflicts with what the multipath
software is designed to do.

I've posted a patch to linux-scsi that can turn off error recovery operation recently,
so dm-mpath (or any other multipath software) can do fast failover when i/o had timed
out. http://groups.google.co.jp/group/linux.kernel/browse_thread/thread/c78d190336bbe363

This patch is yet another (trial) way by implementing generic timeout function in
device-mappper layer. A problem in this patch is that even if dm-mpath takes care
of timed out i/o, using fail_path() -> deactivate_path() on failover calls
blk_abort_queue() -> blk_abort_request(), and that ends up doing scsi error
recovery operation anyway. So it is required to implement generic fast failover
handler that can override the one registered by the lower level device driver.

Currently userland multipathd can detect a link break as path down, but there is
no way dm-mpath (or multipathd) can detect i/o latency issue. What would you say
to implementing generic timeout in dm-mpath ?? It could be device-mapper's generic
function implemented in md/dm.c.  Any comments would be helpful.

Thanks,
Tomohiro Kusumi



Signed-off-by: Tomohiro Kusumi <kusumi.tomohiro@jp.fujitsu.com>
---

diff -aNur linux-2.6.34.org/drivers/md/dm-mpath.c linux-2.6.34/drivers/md/dm-mpath.c
--- linux-2.6.34.org/drivers/md/dm-mpath.c	2010-05-17 06:17:36.000000000 +0900
+++ linux-2.6.34/drivers/md/dm-mpath.c	2010-05-25 21:45:10.000000000 +0900
@@ -104,6 +104,7 @@
 struct dm_mpath_io {
 	struct pgpath *pgpath;
 	size_t nr_bytes;
+	struct timer_list tmo;
 };
 
 typedef int (*action_fn) (struct pgpath *pgpath);
@@ -439,11 +440,13 @@
 
 		r = map_io(m, clone, mpio, 1);
 		if (r < 0) {
+			del_timer(&mpio->tmo);
 			mempool_free(mpio, m->mpio_pool);
 			dm_kill_unmapped_request(clone, r);
 		} else if (r == DM_MAPIO_REMAPPED)
 			dm_dispatch_request(clone);
 		else if (r == DM_MAPIO_REQUEUE) {
+			del_timer(&mpio->tmo);
 			mempool_free(mpio, m->mpio_pool);
 			dm_requeue_unmapped_request(clone);
 		}
@@ -940,6 +943,13 @@
 	free_multipath(m);
 }
 
+static void multipath_tmo(unsigned long priv)
+{
+	struct dm_mpath_io *mpio = (struct dm_mpath_io*)priv;
+	if (mpio->pgpath)
+		fail_path(mpio->pgpath);
+}
+
 /*
  * Map cloned requests
  */
@@ -956,11 +966,18 @@
 		return DM_MAPIO_REQUEUE;
 	memset(mpio, 0, sizeof(*mpio));
 
+	init_timer(&mpio->tmo);
+	mpio->tmo.function = multipath_tmo;
+	mpio->tmo.data = (unsigned long)mpio;
+	mod_timer(&mpio->tmo, jiffies+HZ*10); // timeout should be tunable
+
 	map_context->ptr = mpio;
 	clone->cmd_flags |= REQ_FAILFAST_TRANSPORT;
 	r = map_io(m, clone, mpio, 0);
-	if (r < 0 || r == DM_MAPIO_REQUEUE)
+	if (r < 0 || r == DM_MAPIO_REQUEUE) {
+		del_timer(&mpio->tmo);
 		mempool_free(mpio, m->mpio_pool);
+	}
 
 	return r;
 }
@@ -1297,6 +1314,7 @@
 		if (ps->type->end_io)
 			ps->type->end_io(ps, &pgpath->path, mpio->nr_bytes);
 	}
+	del_timer(&mpio->tmo);
 	mempool_free(mpio, m->mpio_pool);
 
 	return r;
