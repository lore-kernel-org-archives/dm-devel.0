From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: [PATCH 2/5] dm-multipath: push back requests instead
	of queueing
Date: Fri, 31 Jan 2014 10:40:42 -0500
Message-ID: <20140131154042.GA17221@redhat.com>
References: <1391159444-17987-1-git-send-email-hare@suse.de>
	<1391159444-17987-3-git-send-email-hare@suse.de>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <1391159444-17987-3-git-send-email-hare@suse.de>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Hannes Reinecke <hare@suse.de>
Cc: Jun'ichi Nomura <j-nomura@ce.jp.nec.com>, dm-devel@redhat.com, Alasdair Kergon <agk@redhat.com>
List-Id: dm-devel.ids

On Fri, Jan 31 2014 at  4:10am -0500,
Hannes Reinecke <hare@suse.de> wrote:

> There is no reason why multipath needs to queue requests
> internally for queue_if_no_path or pg_init; we should
> rather push them back onto the request queue.
> 
> And while we're at it we can simplify the conditional
> statement in map_io() to make it easier to read.
> 
> Cc: Mike Snitzer <snitzer@redhat.com>
> Cc: Jun'ichi Nomura <j-nomura@ce.jp.nec.com>
> Signed-off-by: Hannes Reinecke <hare@suse.de>
> ---
>  drivers/md/dm-mpath.c         | 115 ++++++++++++++----------------------------
>  drivers/md/dm.c               |  13 +++++
>  include/linux/device-mapper.h |   1 +
>  3 files changed, 52 insertions(+), 77 deletions(-)

...

> diff --git a/drivers/md/dm.c b/drivers/md/dm.c
> index 0704c52..291491b 100644
> --- a/drivers/md/dm.c
> +++ b/drivers/md/dm.c
> @@ -1912,6 +1912,19 @@ static int dm_any_congested(void *congested_data, int bdi_bits)
>  	return r;
>  }
>  
> +void dm_table_run_queue(struct dm_table *t)
> +{
> +	struct mapped_device *md = dm_table_get_md(t);
> +	unsigned long flags;
> +
> +	if (md->queue) {
> +		spin_lock_irqsave(md->queue->queue_lock, flags);
> +		blk_run_queue_async(md->queue);
> +		spin_unlock_irqrestore(md->queue->queue_lock, flags);
> +	}
> +}
> +EXPORT_SYMBOL_GPL(dm_table_run_queue);
> +

I think I agree with Junichi's previous point that this should live in
dm-table.c.  You don't need the mapped_device, only the associated
request_queue, so... I know I implemented something like
dm_get_md_queue() before, but obviously it never went in for whatever
reason.

Anyway, I think something like this would be ideal (I renamed to
dm_table_run_md_queue_async).  Please feel free to fold this in and
repost with v4 of your patchset (assuming you'll be fixing up patch 3
after you get Jun'ichi's feedback):

 drivers/md/dm-table.c |   14 ++++++++++++++
 drivers/md/dm.c       |    5 +++++
 drivers/md/dm.h       |    1 +
 3 files changed, 20 insertions(+), 0 deletions(-)

diff --git a/drivers/md/dm-table.c b/drivers/md/dm-table.c
index 6a7f2b8..72362ce 100644
--- a/drivers/md/dm-table.c
+++ b/drivers/md/dm-table.c
@@ -1618,6 +1618,20 @@ struct mapped_device *dm_table_get_md(struct dm_table *t)
 }
 EXPORT_SYMBOL(dm_table_get_md);
 
+void dm_table_run_md_queue_async(struct dm_table *t)
+{
+	struct mapped_device *md = dm_table_get_md(t);
+	struct request_queue *queue = dm_get_md_queue(md);
+	unsigned long flags;
+
+	if (queue) {
+		spin_lock_irqsave(queue->queue_lock, flags);
+		blk_run_queue_async(queue);
+		spin_unlock_irqrestore(queue->queue_lock, flags);
+	}
+}
+EXPORT_SYMBOL(dm_table_run_md_queue_async);
+
 static int device_discard_capable(struct dm_target *ti, struct dm_dev *dev,
 				  sector_t start, sector_t len, void *data)
 {
diff --git a/drivers/md/dm.c b/drivers/md/dm.c
index b49c762..10cae7f 100644
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -475,6 +475,11 @@ sector_t dm_get_size(struct mapped_device *md)
 	return get_capacity(md->disk);
 }
 
+struct request_queue *dm_get_md_queue(struct mapped_device *md)
+{
+	return md->queue;
+}
+
 struct dm_stats *dm_get_stats(struct mapped_device *md)
 {
 	return &md->stats;
diff --git a/drivers/md/dm.h b/drivers/md/dm.h
index c4569f0..1b2ca8a 100644
--- a/drivers/md/dm.h
+++ b/drivers/md/dm.h
@@ -189,6 +189,7 @@ int dm_lock_for_deletion(struct mapped_device *md, bool mark_deferred, bool only
 int dm_cancel_deferred_remove(struct mapped_device *md);
 int dm_request_based(struct mapped_device *md);
 sector_t dm_get_size(struct mapped_device *md);
+struct request_queue *dm_get_md_queue(struct mapped_device *md);
 struct dm_stats *dm_get_stats(struct mapped_device *md);
 
 int dm_kobject_uevent(struct mapped_device *md, enum kobject_action action,
