From: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
Subject: Re: [PATCH] dm: Fix lock dependency warning for request
	based dm
Date: Thu, 19 Feb 2009 12:02:23 +0900
Message-ID: <499CCBBF.4090602@ct.jp.nec.com>
References: <20090218142154.GA1782@schmichrtp.de.ibm.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20090218142154.GA1782@schmichrtp.de.ibm.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Christof Schmitt <christof.schmitt@de.ibm.com>
Cc: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

Hi Christof,

On 2009/02/18 23:21 +0900, Christof Schmitt wrote:
> > From: Christof Schmitt <christof.schmitt@de.ibm.com>
> > 
> > Testing with request based dm multipathing and lock dependency checking
> > revealed this problem. Fix this by disabling interrupts when acquiring the
> > map_lock from the ioctl call in __bind and __unbind.
> > 
> > It seems that the problem has been introduced with this patch:
> > http://lkml.indiana.edu/hypermail/linux/kernel/0810.0/1067.html

Thank you for your testing request-based dm-multipath and the patch.

Attached is a patch to fix it.
Since request-based dm gets map_lock after taking queue_lock with
interrupt disabled, we have to use save/restore variant.
(By the way, although lockdep warns the deadlock possibility, currently
 there should be no such code path in request-based dm where request_fn
 is called from the interrupt context.)

I have done simple build and boot testings, but haven't done other
testings (e.g. stress testing) yet.
I will include this patch to the next update after such testings.

Thanks,
Kiyoshi Ueda


Index: linux-2.6.29-rc2/drivers/md/dm.c
===================================================================
--- linux-2.6.29-rc2.orig/drivers/md/dm.c
+++ linux-2.6.29-rc2/drivers/md/dm.c
@@ -504,12 +504,13 @@ static int queue_io(struct mapped_device
 struct dm_table *dm_get_table(struct mapped_device *md)
 {
 	struct dm_table *t;
+	unsigned long flags;
 
-	read_lock(&md->map_lock);
+	read_lock_irqsave(&md->map_lock, flags);
 	t = md->map;
 	if (t)
 		dm_table_get(t);
-	read_unlock(&md->map_lock);
+	read_unlock_irqrestore(&md->map_lock, flags);
 
 	return t;
 }
@@ -1892,6 +1893,7 @@ static int __bind(struct mapped_device *
 {
 	struct request_queue *q = md->queue;
 	sector_t size;
+	unsigned long flags;
 
 	size = dm_table_get_size(t);
 
@@ -1921,10 +1923,10 @@ static int __bind(struct mapped_device *
 	if (dm_table_request_based(t) && !blk_queue_stopped(q))
 		stop_queue(q);
 
-	write_lock(&md->map_lock);
+	write_lock_irqsave(&md->map_lock, flags);
 	md->map = t;
 	dm_table_set_restrictions(t, q);
-	write_unlock(&md->map_lock);
+	write_unlock_irqrestore(&md->map_lock, flags);
 
 	return 0;
 }
@@ -1932,14 +1934,15 @@ static int __bind(struct mapped_device *
 static void __unbind(struct mapped_device *md)
 {
 	struct dm_table *map = md->map;
+	unsigned long flags;
 
 	if (!map)
 		return;
 
 	dm_table_event_callback(map, NULL, NULL);
-	write_lock(&md->map_lock);
+	write_lock_irqsave(&md->map_lock, flags);
 	md->map = NULL;
-	write_unlock(&md->map_lock);
+	write_unlock_irqrestore(&md->map_lock, flags);
 	dm_table_destroy(map);
 }
 
