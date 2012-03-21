From: "Jun'ichi Nomura" <j-nomura@ce.jp.nec.com>
Subject: Re: [PATCH] dm-mpath: Track invalid map_context
Date: Wed, 21 Mar 2012 13:16:26 +0900
Message-ID: <4F69561A.5040406@ce.jp.nec.com>
References: <1332171546-33434-1-git-send-email-hare@suse.de>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1332171546-33434-1-git-send-email-hare@suse.de>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: device-mapper development <dm-devel@redhat.com>, Hannes Reinecke <hare@suse.de>
Cc: Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@redhat.com>
List-Id: dm-devel.ids

Hi Hannes,

On 03/20/12 00:39, Hannes Reinecke wrote:
> The map_context pointer should always be set. However, we
> have reports that upon requeing it is not set correctly.
> So add a BUG_ON() statement and clear the pointer to
> track the issue properly.
> 
> Cc: Alasdair Kergon <agk@redhat.com>
> Cc: Mike Snitzer <snitzer@redhat.com>
> Signed-off-by: Hannes Reinecke <hare@suse.de>
> Tested-by: Heiko Carstens <heiko.carstens@de.ibm.com>
> Acked-by: Dave Wysochanski <dwysocha@redhat.com>
> ---
>  drivers/md/dm-mpath.c |    9 ++++++++-
>  1 files changed, 8 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/md/dm-mpath.c b/drivers/md/dm-mpath.c
> index 801d92d..2ed316e 100644
> --- a/drivers/md/dm-mpath.c
> +++ b/drivers/md/dm-mpath.c
> @@ -441,11 +441,13 @@ static void dispatch_queued_ios(struct multipath *m)
>  		r = map_io(m, clone, mpio, 1);
>  		if (r < 0) {
>  			mempool_free(mpio, m->mpio_pool);
> +			info->ptr = NULL;
>  			dm_kill_unmapped_request(clone, r);
>  		} else if (r == DM_MAPIO_REMAPPED)
>  			dm_dispatch_request(clone);
>  		else if (r == DM_MAPIO_REQUEUE) {
>  			mempool_free(mpio, m->mpio_pool);
> +			info->ptr = NULL;
>  			dm_requeue_unmapped_request(clone);
>  		}
>  	}

If we want to ensure info->ptr is either valid or NULL,
how about introducing a function to do it like this?

---
Jun'ichi Nomura, NEC Corporation


diff --git a/drivers/md/dm-mpath.c b/drivers/md/dm-mpath.c
index 801d92d..c6c33b0 100644
--- a/drivers/md/dm-mpath.c
+++ b/drivers/md/dm-mpath.c
@@ -226,6 +226,26 @@ static void free_multipath(struct multipath *m)
 	kfree(m);
 }
 
+static int set_mapinfo(struct multipath *m, union map_info *info)
+{
+	struct dm_mpath_io *mpio;
+
+	mpio = mempool_alloc(m->mpio_pool, GFP_ATOMIC);
+	if (!mpio)
+		return -ENOMEM;
+
+	memset(mpio, 0, sizeof(*mpio));
+	info->ptr = mpio;
+
+	return 0;
+}
+
+static void clear_mapinfo(struct multipath *m, union map_info *info)
+{
+	struct dm_mpath_io *mpio = info->ptr;
+	info->ptr = NULL;
+	mempool_free(mpio, m->mpio_pool);
+}
 
 /*-----------------------------------------------
  * Path selection
@@ -341,13 +361,14 @@ static int __must_push_back(struct multipath *m)
 }
 
 static int map_io(struct multipath *m, struct request *clone,
-		  struct dm_mpath_io *mpio, unsigned was_queued)
+		  union map_info *map_context, unsigned was_queued)
 {
 	int r = DM_MAPIO_REMAPPED;
 	size_t nr_bytes = blk_rq_bytes(clone);
 	unsigned long flags;
 	struct pgpath *pgpath;
 	struct block_device *bdev;
+	struct dm_mpath_io *mpio = map_context->ptr;
 
 	spin_lock_irqsave(&m->lock, flags);
 
@@ -423,7 +444,6 @@ static void dispatch_queued_ios(struct multipath *m)
 {
 	int r;
 	unsigned long flags;
-	struct dm_mpath_io *mpio;
 	union map_info *info;
 	struct request *clone, *n;
 	LIST_HEAD(cl);
@@ -436,16 +456,15 @@ static void dispatch_queued_ios(struct multipath *m)
 		list_del_init(&clone->queuelist);
 
 		info = dm_get_rq_mapinfo(clone);
-		mpio = info->ptr;
 
-		r = map_io(m, clone, mpio, 1);
+		r = map_io(m, clone, info, 1);
 		if (r < 0) {
-			mempool_free(mpio, m->mpio_pool);
+			clear_mapinfo(m, info);
 			dm_kill_unmapped_request(clone, r);
 		} else if (r == DM_MAPIO_REMAPPED)
 			dm_dispatch_request(clone);
 		else if (r == DM_MAPIO_REQUEUE) {
-			mempool_free(mpio, m->mpio_pool);
+			clear_mapinfo(m, info);
 			dm_requeue_unmapped_request(clone);
 		}
 	}
@@ -908,20 +927,16 @@ static int multipath_map(struct dm_target *ti, struct request *clone,
 			 union map_info *map_context)
 {
 	int r;
-	struct dm_mpath_io *mpio;
 	struct multipath *m = (struct multipath *) ti->private;
 
-	mpio = mempool_alloc(m->mpio_pool, GFP_ATOMIC);
-	if (!mpio)
+	if (set_mapinfo(m, map_context) < 0)
 		/* ENOMEM, requeue */
 		return DM_MAPIO_REQUEUE;
-	memset(mpio, 0, sizeof(*mpio));
 
-	map_context->ptr = mpio;
 	clone->cmd_flags |= REQ_FAILFAST_TRANSPORT;
-	r = map_io(m, clone, mpio, 0);
+	r = map_io(m, clone, map_context, 0);
 	if (r < 0 || r == DM_MAPIO_REQUEUE)
-		mempool_free(mpio, m->mpio_pool);
+		clear_mapinfo(m, map_context);
 
 	return r;
 }
@@ -1261,13 +1276,15 @@ static int multipath_end_io(struct dm_target *ti, struct request *clone,
 	struct path_selector *ps;
 	int r;
 
+	BUG_ON(!mpio);
+
 	r  = do_end_io(m, clone, error, mpio);
 	if (pgpath) {
 		ps = &pgpath->pg->ps;
 		if (ps->type->end_io)
 			ps->type->end_io(ps, &pgpath->path, mpio->nr_bytes);
 	}
-	mempool_free(mpio, m->mpio_pool);
+	clear_mapinfo(m, map_context);
 
 	return r;
 }
