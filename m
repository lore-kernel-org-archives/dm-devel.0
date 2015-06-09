From: Laurence Oberman <loberman@redhat.com>
Subject: Re: [PATCH 4/4] dm stats: support statistics on
 requests-based devices
Date: Tue, 9 Jun 2015 17:23:59 -0400 (EDT)
Message-ID: <1185981540.11910821.1433885039023.JavaMail.zimbra@redhat.com>
References: <alpine.LRH.2.02.1506091705160.1545@file01.intranet.prod.int.rdu2.redhat.com>
	<alpine.LRH.2.02.1506091722120.1545@file01.intranet.prod.int.rdu2.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <alpine.LRH.2.02.1506091722120.1545@file01.intranet.prod.int.rdu2.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: Mike Snitzer <msnitzer@redhat.com>, Tao Ma <boyu.mt@taobao.com>, Robin Dong <sanbai@alibaba-inc.com>, dm-devel@redhat.com, Coly Li <colyli@gmail.com>, "Alasdair G. Kergon" <agk@redhat.com>
List-Id: dm-devel.ids

Awesome.
Thanks I will pull the patches build and test.

Regards
Laurence

Laurence Oberman
Red Hat Global Support Service
SEG Team

----- Original Message -----
From: "Mikulas Patocka" <mpatocka@redhat.com>
To: "Alasdair G. Kergon" <agk@redhat.com>, "Mike Snitzer" <msnitzer@redhat.com>, "Coly Li" <colyli@gmail.com>
Cc: dm-devel@redhat.com, "Tao Ma" <boyu.mt@taobao.com>, "Robin Dong" <sanbai@alibaba-inc.com>, "Laurence Oberman" <loberman@redhat.com>
Sent: Tuesday, June 9, 2015 5:22:49 PM
Subject: [PATCH 4/4] dm stats: support statistics on requests-based devices

This patch makes it possible to use dm stats on multipath.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>

---
 drivers/md/dm-stats.c |    5 -----
 drivers/md/dm.c       |   27 +++++++++++++++++++++++++++
 2 files changed, 27 insertions(+), 5 deletions(-)

Index: linux-4.1-rc7/drivers/md/dm-stats.c
===================================================================
--- linux-4.1-rc7.orig/drivers/md/dm-stats.c	2015-06-09 13:53:26.000000000 +0200
+++ linux-4.1-rc7/drivers/md/dm-stats.c	2015-06-09 13:53:35.000000000 +0200
@@ -1155,11 +1155,6 @@ int dm_stats_message(struct mapped_devic
 {
 	int r;
 
-	if (dm_request_based(md)) {
-		DMWARN("Statistics are only supported for bio-based devices");
-		return -EOPNOTSUPP;
-	}
-
 	/* All messages here must start with '@' */
 	if (!strcasecmp(argv[0], "@stats_create"))
 		r = message_stats_create(md, argc, argv, result, maxlen);
Index: linux-4.1-rc7/drivers/md/dm.c
===================================================================
--- linux-4.1-rc7.orig/drivers/md/dm.c	2015-06-09 13:53:50.000000000 +0200
+++ linux-4.1-rc7/drivers/md/dm.c	2015-06-09 16:07:35.000000000 +0200
@@ -86,6 +86,9 @@ struct dm_rq_target_io {
 	struct kthread_work work;
 	int error;
 	union map_info info;
+	struct dm_stats_aux stats_aux;
+	unsigned long duration_jiffies;
+	unsigned n_sectors;
 };
 
 /*
@@ -1084,6 +1087,17 @@ static struct dm_rq_target_io *tio_from_
 	return (rq->q->mq_ops ? blk_mq_rq_to_pdu(rq) : rq->special);
 }
 
+static void rq_end_stats(struct mapped_device *md, struct request *orig)
+{
+	if (unlikely(dm_stats_used(&md->stats))) {
+		struct dm_rq_target_io *tio = tio_from_request(orig);
+		tio->duration_jiffies = jiffies - tio->duration_jiffies;
+		dm_stats_account_io(&md->stats, orig->cmd_flags, blk_rq_pos(orig),
+				    tio->n_sectors, true, tio->duration_jiffies,
+				    &tio->stats_aux);
+	}
+}
+
 /*
  * Don't touch any member of the md after calling this function because
  * the md may be freed in dm_put() at the end of this function.
@@ -1169,6 +1183,7 @@ static void dm_end_request(struct reques
 	}
 
 	free_rq_clone(clone);
+	rq_end_stats(md, rq);
 	if (!rq->q->mq_ops)
 		blk_end_request_all(rq, error);
 	else
@@ -1211,6 +1226,7 @@ static void dm_requeue_unmapped_original
 
 	dm_unprep_request(rq);
 
+	rq_end_stats(md, rq);
 	if (!rq->q->mq_ops)
 		old_requeue_request(rq);
 	else {
@@ -1309,6 +1325,7 @@ static void dm_softirq_done(struct reque
 	int rw;
 
 	if (!clone) {
+		rq_end_stats(tio->md, rq);
 		rw = rq_data_dir(rq);
 		if (!rq->q->mq_ops) {
 			blk_end_request_all(rq, tio->error);
@@ -2120,6 +2137,15 @@ static void dm_start_request(struct mapp
 		md->last_rq_start_time = ktime_get();
 	}
 
+	if (unlikely(dm_stats_used(&md->stats))) {
+		struct dm_rq_target_io *tio = tio_from_request(orig);
+		tio->duration_jiffies = jiffies;
+		tio->n_sectors = blk_rq_sectors(orig);
+		dm_stats_account_io(&md->stats, orig->cmd_flags, blk_rq_pos(orig),
+				    tio->n_sectors, false, 0,
+				    &tio->stats_aux);
+	}
+
 	/*
 	 * Hold the md reference here for the in-flight I/O.
 	 * We can't rely on the reference count by device opener,
@@ -2853,6 +2879,7 @@ static int dm_mq_queue_rq(struct blk_mq_
 		/* Direct call is fine since .queue_rq allows allocations */
 		if (map_request(tio, rq, md) == DM_MAPIO_REQUEUE) {
 			/* Undo dm_start_request() before requeuing */
+			rq_end_stats(md, rq);
 			rq_completed(md, rq_data_dir(rq), false);
 			return BLK_MQ_RQ_QUEUE_BUSY;
 		}
