From: Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH 3/4] Add dm_snap_origin function
Date: Mon, 15 Mar 2010 02:01:23 -0400 (EDT)
Message-ID: <Pine.LNX.4.64.1003150201010.12526@hs20-bc2-1.build.redhat.com>
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
Cc: Alasdair G Kergon <agk@redhat.com>
List-Id: dm-devel.ids

Add dm_snap_origin function

Add function dm_snap_origin, it will be used for checking chunk size against
origin sector size.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>

---
 drivers/md/dm-exception-store.h |    3 ++-
 drivers/md/dm-snap.c            |    6 ++++++
 2 files changed, 8 insertions(+), 1 deletion(-)

Index: linux-2.6.34-rc1-devel/drivers/md/dm-exception-store.h
===================================================================
--- linux-2.6.34-rc1-devel.orig/drivers/md/dm-exception-store.h	2010-03-12 14:41:37.000000000 +0100
+++ linux-2.6.34-rc1-devel/drivers/md/dm-exception-store.h	2010-03-12 14:42:11.000000000 +0100
@@ -126,8 +126,9 @@ struct dm_exception_store {
 };
 
 /*
- * Obtain the cow device used by a given snapshot.
+ * Obtain the origin and cow device used by a given snapshot.
  */
+struct dm_dev *dm_snap_origin(struct dm_snapshot *snap);
 struct dm_dev *dm_snap_cow(struct dm_snapshot *snap);
 
 /*
Index: linux-2.6.34-rc1-devel/drivers/md/dm-snap.c
===================================================================
--- linux-2.6.34-rc1-devel.orig/drivers/md/dm-snap.c	2010-03-12 14:41:20.000000000 +0100
+++ linux-2.6.34-rc1-devel/drivers/md/dm-snap.c	2010-03-12 14:42:37.000000000 +0100
@@ -148,6 +148,12 @@ struct dm_snapshot {
 #define RUNNING_MERGE          0
 #define SHUTDOWN_MERGE         1
 
+struct dm_dev *dm_snap_origin(struct dm_snapshot *s)
+{
+	return s->origin;
+}
+EXPORT_SYMBOL(dm_snap_origin);
+
 struct dm_dev *dm_snap_cow(struct dm_snapshot *s)
 {
 	return s->cow;
