From: Alasdair G Kergon <agk@redhat.com>
Subject: [PATCH] Cope if snapshot-origin got extended
Date: Fri, 28 Jan 2005 20:35:11 +0000
Message-ID: <20050128203511.GN10195@agk.surrey.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
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
List-Id: dm-devel.ids

Handle writes to a snapshot-origin device that has been extended since
the snapshot was taken.

The idea is to allow:
  create origin lv
  create snapshot of it
Deactivate both devices.
  extend the origin
Reactivate with the revised device sizes.

Then the origin is bigger than the snapshot and reads to the new
part of the origin don't need to trigger exceptions.

[This is the easiest case: It's harder to support doing this while the 
devices are active, or shrinking the origin (which doesn't achieve much).]

--- diff/drivers/md/dm-snap.c	2005-01-28 18:04:03.000000000 +0000
+++ source/drivers/md/dm-snap.c	2005-01-28 20:25:26.000000000 +0000
@@ -931,6 +931,10 @@
 		if (!snap->valid)
 			continue;
 
+		/* Nothing to do if writing beyond end of snapshot */
+		if (bio->bi_sector >= dm_table_get_size(snap->table))
+			continue;
+
 		down_write(&snap->lock);
 
 		/*

--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel
