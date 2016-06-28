From: Bart Van Assche <bart.vanassche@sandisk.com>
Subject: Re: dm mpath: Fix a dm_blk_ioctl() deadlock
Date: Tue, 28 Jun 2016 20:29:42 +0200
Message-ID: <f2f4fe18-b3e0-30f6-5f4f-0fee385bade8@sandisk.com>
References: <c987a4ca-4b55-0b3a-a414-2608f2ded132@sandisk.com>
	<20160628181526.GA8013@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20160628181526.GA8013@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Mike Snitzer <snitzer@redhat.com>
Cc: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

On 06/28/2016 08:15 PM, Mike Snitzer wrote:
> This patch doesn't make sense.
> 
> In the context of dm-mpath.c:multipath_prepare_ioctl, *bdev is only
> valid if r == 0.  But r == -ENOTCONN so how can *bdev be valid?

Sorry but the dm code is not my area of expertise. How about the patch
below? Please note that so far only the queue-length path selector has
been tested.

Thanks,

Bart.

diff --git a/drivers/md/dm-queue-length.c b/drivers/md/dm-queue-length.c
index 23f1786..4c36648 100644
--- a/drivers/md/dm-queue-length.c
+++ b/drivers/md/dm-queue-length.c
@@ -199,6 +199,8 @@ static struct dm_path *ql_select_path(struct path_selector *ps, size_t nr_bytes)
 	list_move_tail(s->valid_paths.next, &s->valid_paths);
 
 	list_for_each_entry(pi, &s->valid_paths, list) {
+		if (blk_queue_dying(bdev_get_queue(pi->path->dev->bdev)))
+			continue;
 		if (!best ||
 		    (atomic_read(&pi->qlen) < atomic_read(&best->qlen)))
 			best = pi;
diff --git a/drivers/md/dm-round-robin.c b/drivers/md/dm-round-robin.c
index 4ace1da..56e3919 100644
--- a/drivers/md/dm-round-robin.c
+++ b/drivers/md/dm-round-robin.c
@@ -217,13 +217,17 @@ static struct dm_path *rr_select_path(struct path_selector *ps, size_t nr_bytes)
 			return current_path;
 	}
 
+	current_path = NULL;
+
 	spin_lock_irqsave(&s->lock, flags);
-	if (!list_empty(&s->valid_paths)) {
-		pi = list_entry(s->valid_paths.next, struct path_info, list);
+	list_for_each_entry(pi, &s->valid_paths, list) {
+		if (blk_queue_dying(bdev_get_queue(pi->path->dev->bdev)))
+			continue;
 		list_move_tail(&pi->list, &s->valid_paths);
 		percpu_counter_set(&s->repeat_count, pi->repeat_count);
 		set_percpu_current_path(s, pi->path);
 		current_path = pi->path;
+		break;
 	}
 	spin_unlock_irqrestore(&s->lock, flags);
 
diff --git a/drivers/md/dm-service-time.c b/drivers/md/dm-service-time.c
index 7b86420..fccf66a 100644
--- a/drivers/md/dm-service-time.c
+++ b/drivers/md/dm-service-time.c
@@ -285,9 +285,12 @@ static struct dm_path *st_select_path(struct path_selector *ps, size_t nr_bytes)
 	/* Change preferred (first in list) path to evenly balance. */
 	list_move_tail(s->valid_paths.next, &s->valid_paths);
 
-	list_for_each_entry(pi, &s->valid_paths, list)
+	list_for_each_entry(pi, &s->valid_paths, list) {
+		if (blk_queue_dying(bdev_get_queue(pi->path->dev->bdev)))
+			continue;
 		if (!best || (st_compare_load(pi, best, nr_bytes) < 0))
 			best = pi;
+	}
 
 	if (!best)
 		goto out;
-- 
2.8.4
