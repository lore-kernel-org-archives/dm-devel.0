From: Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH] Lock only when querying status, not table
Date: Mon, 30 Nov 2009 14:05:09 -0500 (EST)
Message-ID: <Pine.LNX.4.64.0911301356260.26310@hs20-bc2-1.build.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
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
To: Alasdair G Kergon <agk@redhat.com>
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

Hi

Please, apply this before 2.6.32, there is a possibility for regression 
(locking in snapshot_status was introduced in 2.6.32-rc).

Mikulas

---

Lock only when querying status, not table

LVM sometimes suspends the underlying device and asks for a table.

To prevent a possible deadlock (LVM suspends the snapshot store, snapshot
takes the lock and waits for I/O, LVM asks for table before unsuspend,
deadlock), lock only when querying the status. The lock is not needed for
table anyway, because the table doesn't change during snapshot operation.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>

---
 drivers/md/dm-snap.c |   10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

Index: linux-2.6.32-rc8-devel/drivers/md/dm-snap.c
===================================================================
--- linux-2.6.32-rc8-devel.orig/drivers/md/dm-snap.c	2009-11-30 17:56:06.000000000 +0100
+++ linux-2.6.32-rc8-devel/drivers/md/dm-snap.c	2009-11-30 18:00:44.000000000 +0100
@@ -1407,10 +1407,11 @@ static int snapshot_status(struct dm_tar
 	unsigned sz = 0;
 	struct dm_snapshot *snap = ti->private;
 
-	down_write(&snap->lock);
-
 	switch (type) {
 	case STATUSTYPE_INFO:
+
+		down_write(&snap->lock);
+
 		if (!snap->valid)
 			DMEMIT("Invalid");
 		else {
@@ -1429,6 +1430,9 @@ static int snapshot_status(struct dm_tar
 			else
 				DMEMIT("Unknown");
 		}
+
+		up_write(&snap->lock);
+
 		break;
 
 	case STATUSTYPE_TABLE:
@@ -1443,8 +1447,6 @@ static int snapshot_status(struct dm_tar
 		break;
 	}
 
-	up_write(&snap->lock);
-
 	return 0;
 }
 
