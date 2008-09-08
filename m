From: Stefan Raspl <raspl@linux.vnet.ibm.com>
Subject: [PATCH] Fix Null pointer Exception
Date: Mon, 08 Sep 2008 17:40:59 +0200
Message-ID: <48C5478B.2040401@linux.vnet.ibm.com>
Reply-To: raspl@linux.vnet.ibm.com,
	device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
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
To: device-mapper development <dm-devel@redhat.com>, agk@redhat.com
Cc: akpm@linux-foundation.org, h.carstens@de.ibm.com, martin.schwidefsky@de.ibm.com
List-Id: dm-devel.ids

Here's a trivial patch for the kernel panics that we reported last week
when testing various ways to forcefully disconnect or temporarily disable
DASD disks from an IBM System z machine. We ran into NULL pointer exceptions
at the respective places.


Signed-off-by: Stefan Raspl <raspl@linux.vnet.ibm.com>


---
 drivers/md/dm-table.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/drivers/md/dm-table.c
+++ b/drivers/md/dm-table.c
@@ -943,7 +943,8 @@ int dm_table_any_congested(struct dm_tab
 
 	list_for_each_entry(dd, devices, list) {
 		struct request_queue *q = bdev_get_queue(dd->bdev);
-		r |= bdi_congested(&q->backing_dev_info, bdi_bits);
+		if (q)
+			r |= bdi_congested(&q->backing_dev_info, bdi_bits);
 	}
 
 	return r;
@@ -957,7 +958,8 @@ void dm_table_unplug_all(struct dm_table
 	list_for_each_entry(dd, devices, list) {
 		struct request_queue *q = bdev_get_queue(dd->bdev);
 
-		blk_unplug(q);
+		if (q)
+			blk_unplug(q);
 	}
 }
 
