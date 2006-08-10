From: Stefan Bader <Stefan.Bader@de.ibm.com>
Subject: [PATCH and question]: dm-table should check for valid
	queue
Date: Thu, 10 Aug 2006 13:29:08 +0200
Message-ID: <44DB1884.7070800@de.ibm.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="------------010404090004020206000002"
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
To: dm-devel@redhat.com
List-Id: dm-devel.ids

This is a multi-part message in MIME format.
--------------010404090004020206000002
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit

Hi,

in some cases it is possible that bdev_get_queue() returns NULL. And
there are some places where device-mapper just uses the returned pointer
to call queue functions. The attached patch adds this to
dm_table_unplug_all() and dm_table_flush_all(). I treated a device
without a queue as sort of successfully flushed. Is this what would be
expected?
Same problem with dm_table_any_congested() which I didn't change, yet.
This function should probably also check before using
q->backing_dev_info. But what effect should a missing queue have? Same
as device is congested or not or let the call fail somehow?

Regards,
Stefan Bader

--------------010404090004020206000002
Content-Type: text/plain;
 name="dm-table-checkreqq.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="dm-table-checkreqq.diff"

diff -Nurp linux-RHEL4/drivers/md/dm-table.c linux-RHEL4-BTM/drivers/md/dm-table.c
--- linux-RHEL4/drivers/md/dm-table.c	2006-08-07 13:15:30.000000000 +0200
+++ linux-RHEL4-BTM/drivers/md/dm-table.c	2005-10-06 15:34:15.000000000 +0200
@@ -917,7 +917,7 @@ void dm_table_unplug_all(struct dm_table
 		struct dm_dev *dd = list_entry(d, struct dm_dev, list);
 		request_queue_t *q = bdev_get_queue(dd->bdev);
 
-		if (q && q->unplug_fn)
+		if (q->unplug_fn)
 			q->unplug_fn(q);
 	}
 }
@@ -932,9 +932,6 @@ int dm_table_flush_all(struct dm_table *
 		request_queue_t *q = bdev_get_queue(dd->bdev);
 		int err;
 
-		if (!q)
-			continue;
-
 		if (!q->issue_flush_fn)
 			err = -EOPNOTSUPP;
 		else

--------------010404090004020206000002
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--------------010404090004020206000002--
