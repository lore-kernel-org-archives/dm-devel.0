Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0F474C433EF
	for <dm-devel@archiver.kernel.org>; Wed, 16 Feb 2022 17:48:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1645033693;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=FlLPTArpBekiWwmXcVJSIpn9kgm4tUa/6DE42cMS+Kw=;
	b=HlrDm0jXKGKcYueCTzuV3FYj4LSkNUP2zqsV7uBm5pgnlAkUFTH9rLRZlvIOfoK2UKQlrO
	768a3rEck/dHuykOIico575cFl7pa3his682XJ7/V0ZaFl270MMi38oyBTzZzsVwgfmFKD
	uyUpOS97vpaNok+BZOktIsdRClOgA8c=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-225-SSIAOVr4PceiWRJrJC1Epw-1; Wed, 16 Feb 2022 12:48:11 -0500
X-MC-Unique: SSIAOVr4PceiWRJrJC1Epw-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id CD4872F44;
	Wed, 16 Feb 2022 17:48:05 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 4BD8810A48D5;
	Wed, 16 Feb 2022 17:48:04 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 7462F4BB7C;
	Wed, 16 Feb 2022 17:48:01 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com
	[10.5.11.12])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 21GHlxZd009928 for <dm-devel@listman.util.phx.redhat.com>;
	Wed, 16 Feb 2022 12:47:59 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id DD4127CAFF; Wed, 16 Feb 2022 17:47:59 +0000 (UTC)
Received: from file01.intranet.prod.int.rdu2.redhat.com
	(file01.intranet.prod.int.rdu2.redhat.com [10.11.5.7])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id A9AE57CD6E;
	Wed, 16 Feb 2022 17:47:50 +0000 (UTC)
Received: from file01.intranet.prod.int.rdu2.redhat.com (localhost [127.0.0.1])
	by file01.intranet.prod.int.rdu2.redhat.com (8.14.4/8.14.4) with ESMTP
	id 21GHlo6B028865; Wed, 16 Feb 2022 12:47:50 -0500
Received: from localhost (mpatocka@localhost)
	by file01.intranet.prod.int.rdu2.redhat.com (8.14.4/8.14.4/Submit) with
	ESMTP id 21GHloXk028861; Wed, 16 Feb 2022 12:47:50 -0500
X-Authentication-Warning: file01.intranet.prod.int.rdu2.redhat.com: mpatocka
	owned process doing -bs
Date: Wed, 16 Feb 2022 12:47:50 -0500 (EST)
From: Mikulas Patocka <mpatocka@redhat.com>
X-X-Sender: mpatocka@file01.intranet.prod.int.rdu2.redhat.com
To: Mike Snitzer <msnitzer@redhat.com>
Message-ID: <alpine.LRH.2.02.2202161244140.28642@file01.intranet.prod.int.rdu2.redhat.com>
User-Agent: Alpine 2.02 (LRH 1266 2009-07-14)
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
X-loop: dm-devel@redhat.com
Cc: dm-devel@redhat.com
Subject: [dm-devel] [PATCH] dm-stats: refactor dm_stats_precise_timestamps
X-BeenThere: dm-devel@redhat.com
X-Mailman-Version: 2.1.12
Precedence: junk
List-Id: device-mapper development <dm-devel.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Don't pollute struct mapped_device with dm_stats_precise_timestamps; move
it into struct dm_stats.

This patch also removes dm_stats->last_sector and dm_stats->last_rw which
are unused.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>

---
 drivers/md/dm-core.h  |    2 --
 drivers/md/dm-stats.c |   28 ++++++++++++++++++++++++----
 drivers/md/dm-stats.h |    9 +++++++--
 drivers/md/dm.c       |    5 +----
 4 files changed, 32 insertions(+), 12 deletions(-)

Index: linux-dm/drivers/md/dm-core.h
===================================================================
--- linux-dm.orig/drivers/md/dm-core.h	2022-02-16 17:49:02.000000000 +0100
+++ linux-dm/drivers/md/dm-core.h	2022-02-16 18:06:28.000000000 +0100
@@ -113,8 +113,6 @@ struct mapped_device {
 	struct blk_mq_tag_set *tag_set;
 	bool init_tio_pdu:1;
 
-	bool dm_stats_precise_timestamps:1;
-
 	struct srcu_struct io_barrier;
 
 #ifdef CONFIG_BLK_DEV_ZONED
Index: linux-dm/drivers/md/dm-stats.c
===================================================================
--- linux-dm.orig/drivers/md/dm-stats.c	2022-02-16 17:49:02.000000000 +0100
+++ linux-dm/drivers/md/dm-stats.c	2022-02-16 18:41:57.000000000 +0100
@@ -195,6 +195,7 @@ void dm_stats_init(struct dm_stats *stat
 
 	mutex_init(&stats->mutex);
 	INIT_LIST_HEAD(&stats->list);
+	stats->precise_timestamps = false;
 	stats->last = alloc_percpu(struct dm_stats_last_position);
 	for_each_possible_cpu(cpu) {
 		last = per_cpu_ptr(stats->last, cpu);
@@ -231,6 +232,21 @@ void dm_stats_cleanup(struct dm_stats *s
 	mutex_destroy(&stats->mutex);
 }
 
+static void dm_stats_recalc_precise_timestamps(struct dm_stats *stats)
+{
+	struct list_head *l;
+	struct dm_stat *tmp_s;
+	bool precise_timestamps = false;
+	list_for_each(l, &stats->list) {
+		tmp_s = container_of(l, struct dm_stat, list_entry);
+		if (tmp_s->stat_flags & STAT_PRECISE_TIMESTAMPS) {
+			precise_timestamps = true;
+			break;
+		}
+	}
+	stats->precise_timestamps = precise_timestamps;
+}
+
 static int dm_stats_create(struct dm_stats *stats, sector_t start, sector_t end,
 			   sector_t step, unsigned stat_flags,
 			   unsigned n_histogram_entries,
@@ -376,6 +392,9 @@ static int dm_stats_create(struct dm_sta
 	}
 	ret_id = s->id;
 	list_add_tail_rcu(&s->list_entry, l);
+
+	dm_stats_recalc_precise_timestamps(stats);
+
 	mutex_unlock(&stats->mutex);
 
 	resume_callback(md);
@@ -418,6 +437,9 @@ static int dm_stats_delete(struct dm_sta
 	}
 
 	list_del_rcu(&s->list_entry);
+
+	dm_stats_recalc_precise_timestamps(stats);
+
 	mutex_unlock(&stats->mutex);
 
 	/*
@@ -1006,11 +1028,9 @@ static int message_stats_create(struct m
 			a = dm_shift_arg(&as);
 			if (!a)
 				goto ret_einval;
-			if (!strcasecmp(a, "precise_timestamps")) {
+			if (!strcasecmp(a, "precise_timestamps"))
 				stat_flags |= STAT_PRECISE_TIMESTAMPS;
-				md->dm_stats_precise_timestamps = true;
-				// FIXME: disable md->dm_stats_precise_timestamps when no longer needed
-			} else if (!strncasecmp(a, "histogram:", 10)) {
+			else if (!strncasecmp(a, "histogram:", 10)) {
 				if (n_histogram_entries)
 					goto ret_einval;
 				if ((r = parse_histogram(a + 10, &n_histogram_entries, &histogram_boundaries)))
Index: linux-dm/drivers/md/dm-stats.h
===================================================================
--- linux-dm.orig/drivers/md/dm-stats.h	2022-02-16 17:49:02.000000000 +0100
+++ linux-dm/drivers/md/dm-stats.h	2022-02-16 18:41:19.000000000 +0100
@@ -13,8 +13,7 @@ struct dm_stats {
 	struct mutex mutex;
 	struct list_head list;	/* list of struct dm_stat */
 	struct dm_stats_last_position __percpu *last;
-	sector_t last_sector;
-	unsigned last_rw;
+	bool precise_timestamps;
 };
 
 struct dm_stats_aux {
@@ -40,4 +39,10 @@ static inline bool dm_stats_used(struct
 	return !list_empty(&st->list);
 }
 
+static inline void dm_stats_record_start(struct dm_stats *stats, struct dm_stats_aux *aux)
+{
+	if (unlikely(stats->precise_timestamps))
+		aux->duration_ns = ktime_to_ns(ktime_get());
+}
+
 #endif
Index: linux-dm/drivers/md/dm.c
===================================================================
--- linux-dm.orig/drivers/md/dm.c	2022-02-16 17:49:02.000000000 +0100
+++ linux-dm/drivers/md/dm.c	2022-02-16 18:34:29.000000000 +0100
@@ -567,9 +567,7 @@ static struct dm_io *alloc_io(struct map
 	io->start_io_acct = false;
 	io->was_accounted = 0;
 
-	if (unlikely(md->dm_stats_precise_timestamps &&
-		     dm_stats_used(&md->stats)))
-		io->stats_aux.duration_ns = ktime_to_ns(ktime_get());
+	dm_stats_record_start(&md->stats, &io->stats_aux);
 
 	return io;
 }
@@ -1695,7 +1693,6 @@ static struct mapped_device *alloc_dev(i
 
 	md->numa_node_id = numa_node_id;
 	md->init_tio_pdu = false;
-	md->dm_stats_precise_timestamps = false;
 	md->type = DM_TYPE_NONE;
 	mutex_init(&md->suspend_lock);
 	mutex_init(&md->type_lock);

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

