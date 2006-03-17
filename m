From: "Jun'ichi Nomura" <j-nomura@ce.jp.nec.com>
Subject: [PATCH] RFC: Changing dm core (2/5) : Put_table in safer
	place
Date: Thu, 16 Mar 2006 19:23:38 -0500
Message-ID: <441A018A.7070301@ce.jp.nec.com>
References: <4419FF61.9050501@ce.jp.nec.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="------------080306000809090601080100"
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <4419FF61.9050501@ce.jp.nec.com>
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

This is a multi-part message in MIME format.
--------------080306000809090601080100
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit

Move dm_table_put() outside of dm_sem.

Thanks,
-- 
Jun'ichi Nomura, NEC Solutions (America), Inc.

--------------080306000809090601080100
Content-Type: text/x-patch;
 name="02-put-table-after-unlock.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="02-put-table-after-unlock.patch"

Move dm_table_put() outside of dm_sem.

Signed-off-by: Jun'ichi Nomura <j-nomura@ce.jp.nec.com>

 dm-ioctl.c |   15 +++++++++++----
 1 files changed, 11 insertions(+), 4 deletions(-)

--- linux-2.6.16-rc6-mm1-dm.01-dm-sem/drivers/md/dm-ioctl.c	2006-03-13 17:35:40.000000000 -0500
+++ linux-2.6.16-rc6-mm1-dm.02-put-table-after-unlock/drivers/md/dm-ioctl.c	2006-03-15 10:15:11.000000000 -0500
@@ -984,7 +984,7 @@ static int table_load(struct dm_ioctl *p
 {
 	int r;
 	struct hash_cell *hc;
-	struct dm_table *t;
+	struct dm_table *t, *oldmap = NULL;
 	struct mapped_device *md;
 
 	md = find_device(param);
@@ -1005,14 +1005,14 @@ static int table_load(struct dm_ioctl *p
 	hc = dm_get_mdptr(md);
 	if (!hc || hc->md != md) {
 		DMWARN("device has been removed from the dev hash table.");
-		dm_table_put(t);
+		oldmap = t;
 		up_write(&dm_sem);
 		r = -ENXIO;
 		goto out;
 	}
 
 	if (hc->new_map)
-		dm_table_put(hc->new_map);
+		oldmap = hc->new_map;
 	hc->new_map = t;
 	up_write(&dm_sem);
 
@@ -1020,6 +1020,8 @@ static int table_load(struct dm_ioctl *p
 	r = __dev_status(md, param);
 
 out:
+	if (oldmap)
+		dm_table_put(oldmap);
 	dm_put(md);
 
 	return r;
@@ -1029,6 +1031,7 @@ static int table_clear(struct dm_ioctl *
 {
 	int r;
 	struct hash_cell *hc;
+	struct dm_table *oldmap = NULL;
 
 	down_write(&dm_sem);
 
@@ -1040,7 +1043,7 @@ static int table_clear(struct dm_ioctl *
 	}
 
 	if (hc->new_map) {
-		dm_table_put(hc->new_map);
+		oldmap = hc->new_map;
 		hc->new_map = NULL;
 	}
 
@@ -1048,6 +1051,10 @@ static int table_clear(struct dm_ioctl *
 
 	r = __dev_status(hc->md, param);
 	up_write(&dm_sem);
+
+	if (oldmap)
+		dm_table_put(oldmap);
+
 	return r;
 }
 

--------------080306000809090601080100
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--------------080306000809090601080100--
