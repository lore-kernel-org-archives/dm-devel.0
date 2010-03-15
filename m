From: Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH 1/4] Iterate both origin and snapshot devices
Date: Mon, 15 Mar 2010 02:00:27 -0400 (EDT)
Message-ID: <Pine.LNX.4.64.1003150159590.12526@hs20-bc2-1.build.redhat.com>
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

Iterate both origin and snapshot devices

iterate_devices method should call the callback for all the devices where
the bio may be remapped. Thus, snapshot_iterate_devices should call the callback
for both snapshot and origin underlying devices because it remaps some bios
to the snapshot and some to the origin.

snapshot_iterate_devices called the callback only for the origin device.
This lead to badly calculated device limits if snapshot and origin were placed
on different types of disks.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>

---
 drivers/md/dm-snap.c |    8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

Index: linux-2.6.34-rc1-devel/drivers/md/dm-snap.c
===================================================================
--- linux-2.6.34-rc1-devel.orig/drivers/md/dm-snap.c	2010-03-12 14:24:39.000000000 +0100
+++ linux-2.6.34-rc1-devel/drivers/md/dm-snap.c	2010-03-12 14:30:30.000000000 +0100
@@ -1899,8 +1899,14 @@ static int snapshot_iterate_devices(stru
 				    iterate_devices_callout_fn fn, void *data)
 {
 	struct dm_snapshot *snap = ti->private;
+	int r;
+
+	r = fn(ti, snap->origin, 0, ti->len, data);
 
-	return fn(ti, snap->origin, 0, ti->len, data);
+	if (!r)
+		r = fn(ti, snap->cow, 0, get_dev_size(snap->cow->bdev), data);
+
+	return r;
 }
 
 
