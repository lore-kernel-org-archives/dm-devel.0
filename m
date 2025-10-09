Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F87A1DE3DC
	for <dm-devel@lists.linux.dev>; Thu,  9 Oct 2025 03:04:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759979081; cv=none; b=JCMVs/QBu48a/jHAbSdYGGur5iurT+vIvxVOWZwslxcK3xz4rwXEwEhdLOfqsJZkOo0M+XCCOr40nmhmyaMF5QMaaamVc074NAqGS9LhqURIMC8raRWf5TInr8Pwpl1NIzgp27oR3Mo1pvP8RPJwuvJp3IYkCm/jiYRvUIFDGxI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759979081; c=relaxed/simple;
	bh=mWSAStpGXa9ippsGPyX7oUGoNQ14xBUZiSva4AjRGGA=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:content-type; b=fsIG5+YYptAoEoBFjknBJxEDcsgBD/OUA0D2lGF8ps5HYacAxqARwfL4fNZfHAe4KRTq98+r0bP6DW0iPYEDUkjBGBcVSkuHNNGKiKXqo2/sVOdaTqlwRd5K/2sU5Nvha8T28BAa8oqNoH9nKfFTnSwMPsV+yFYo9SY8vhY8Hx4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=LwBKmEAg; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="LwBKmEAg"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1759979077;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=/H+TjmX8BGXiUkYX82RHZ54HZ1pBbWtyfYhK9HX9L4w=;
	b=LwBKmEAg9kVs9N1C6/Z+Uzmv21DDKv8cHgMTPSUEjCD+9IBQMKjVZYzgSjtG7L4qkgKuVb
	wEgFQAhYxlIwkWqspJ1DWwDZQ6lQkwN6uh5OGT47khMJKb9/5eISnKjJpAYWh6ggSPZXbc
	Sd4ueKhcRmrfJFcI9uz2ZYb3kUJfgMI=
Received: from mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-270-tP40pa6yN3qNlG_l9b-Qyg-1; Wed,
 08 Oct 2025 23:04:34 -0400
X-MC-Unique: tP40pa6yN3qNlG_l9b-Qyg-1
X-Mimecast-MFC-AGG-ID: tP40pa6yN3qNlG_l9b-Qyg_1759979073
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 6CAC319560AE;
	Thu,  9 Oct 2025 03:04:33 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (unknown [10.6.23.247])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 0FE181800983;
	Thu,  9 Oct 2025 03:04:32 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.17.1) with ESMTPS id 59934VaV2895504
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Wed, 8 Oct 2025 23:04:31 -0400
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.18.1/Submit) id 59934VKp2895503;
	Wed, 8 Oct 2025 23:04:31 -0400
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Mikulas Patocka <mpatocka@redhat.com>, Mike Snitzer <snitzer@kernel.org>
Cc: Martin Wilck <mwilck@suse.com>, dm-devel@lists.linux.dev
Subject: [PATCH] dm: Fix deadlock when reloading a multipath table
Date: Wed,  8 Oct 2025 23:04:31 -0400
Message-ID: <20251009030431.2895495-1-bmarzins@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: r5iph7Xh2VGR_y2VhA3PoSk--1e4JjxF0XL-Mt-PwCM_1759979073
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true

Request-based devices (dm-multipath) queue I/O in blk-mq on noflush
suspends. Any queued IO will make it impossible to freeze the queue. If
a process attempts to update the queue limits while there is queued IO,
it can be get stuck holding the limits lock, while unable to freeze the
queue. If device-mapper then attempts to update the limits during a
table swap, it will deadlock trying to grab the limits lock while making
it impossible to flush the IO.

Disallow updating the queue limits during a table swap, when updating an
immutable request-based dm device (dm-multipath) during a noflush
suspend. It is userspace's responsibility to make sure that the new
table uses the same limits as the existing table if it asks for a
noflush suspend.

Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 drivers/md/dm-table.c |  4 ++++
 drivers/md/dm-thin.c  |  7 ++-----
 drivers/md/dm.c       | 35 +++++++++++++++++++++++------------
 3 files changed, 29 insertions(+), 17 deletions(-)

diff --git a/drivers/md/dm-table.c b/drivers/md/dm-table.c
index ad0a60a07b93..0522cd700e0e 100644
--- a/drivers/md/dm-table.c
+++ b/drivers/md/dm-table.c
@@ -2043,6 +2043,10 @@ bool dm_table_supports_size_change(struct dm_table *t, sector_t old_size,
 	return true;
 }
 
+/*
+ * This function will be skipped by noflush reloads of immutable request
+ * based devices (dm-mpath).
+ */
 int dm_table_set_restrictions(struct dm_table *t, struct request_queue *q,
 			      struct queue_limits *limits)
 {
diff --git a/drivers/md/dm-thin.c b/drivers/md/dm-thin.c
index c84149ba4e38..6f98936f0e05 100644
--- a/drivers/md/dm-thin.c
+++ b/drivers/md/dm-thin.c
@@ -4383,11 +4383,8 @@ static void thin_postsuspend(struct dm_target *ti)
 {
 	struct thin_c *tc = ti->private;
 
-	/*
-	 * The dm_noflush_suspending flag has been cleared by now, so
-	 * unfortunately we must always run this.
-	 */
-	noflush_work(tc, do_noflush_stop);
+	if (dm_noflush_suspending(ti))
+		noflush_work(tc, do_noflush_stop);
 }
 
 static int thin_preresume(struct dm_target *ti)
diff --git a/drivers/md/dm.c b/drivers/md/dm.c
index 3ede5ba4cf7e..87e65c48dd04 100644
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -2439,7 +2439,6 @@ static struct dm_table *__bind(struct mapped_device *md, struct dm_table *t,
 {
 	struct dm_table *old_map;
 	sector_t size, old_size;
-	int ret;
 
 	lockdep_assert_held(&md->suspend_lock);
 
@@ -2454,11 +2453,13 @@ static struct dm_table *__bind(struct mapped_device *md, struct dm_table *t,
 
 	set_capacity(md->disk, size);
 
-	ret = dm_table_set_restrictions(t, md->queue, limits);
-	if (ret) {
-		set_capacity(md->disk, old_size);
-		old_map = ERR_PTR(ret);
-		goto out;
+	if (limits) {
+		int ret = dm_table_set_restrictions(t, md->queue, limits);
+		if (ret) {
+			set_capacity(md->disk, old_size);
+			old_map = ERR_PTR(ret);
+			goto out;
+		}
 	}
 
 	/*
@@ -2836,6 +2837,7 @@ static void dm_wq_work(struct work_struct *work)
 
 static void dm_queue_flush(struct mapped_device *md)
 {
+	clear_bit(DMF_NOFLUSH_SUSPENDING, &md->flags);
 	clear_bit(DMF_BLOCK_IO_FOR_SUSPEND, &md->flags);
 	smp_mb__after_atomic();
 	queue_work(md->wq, &md->work);
@@ -2848,6 +2850,7 @@ struct dm_table *dm_swap_table(struct mapped_device *md, struct dm_table *table)
 {
 	struct dm_table *live_map = NULL, *map = ERR_PTR(-EINVAL);
 	struct queue_limits limits;
+	bool update_limits = true;
 	int r;
 
 	mutex_lock(&md->suspend_lock);
@@ -2856,20 +2859,31 @@ struct dm_table *dm_swap_table(struct mapped_device *md, struct dm_table *table)
 	if (!dm_suspended_md(md))
 		goto out;
 
+	/*
+	 * To avoid a potential deadlock locking the queue limits, disallow
+	 * updating the queue limits during a table swap, when updating an
+	 * immutable request-based dm device (dm-multipath) during a noflush
+	 * suspend. It is userspace's responsibility to make sure that the new
+	 * table uses the same limits as the existing table, if it asks for a
+	 * noflush suspend.
+	 */
+	if (dm_request_based(md) && md->immutable_target &&
+	    __noflush_suspending(md))
+		update_limits = false;
 	/*
 	 * If the new table has no data devices, retain the existing limits.
 	 * This helps multipath with queue_if_no_path if all paths disappear,
 	 * then new I/O is queued based on these limits, and then some paths
 	 * reappear.
 	 */
-	if (dm_table_has_no_data_devices(table)) {
+	else if (dm_table_has_no_data_devices(table)) {
 		live_map = dm_get_live_table_fast(md);
 		if (live_map)
 			limits = md->queue->limits;
 		dm_put_live_table_fast(md);
 	}
 
-	if (!live_map) {
+	if (update_limits && !live_map) {
 		r = dm_calculate_queue_limits(table, &limits);
 		if (r) {
 			map = ERR_PTR(r);
@@ -2877,7 +2891,7 @@ struct dm_table *dm_swap_table(struct mapped_device *md, struct dm_table *table)
 		}
 	}
 
-	map = __bind(md, table, &limits);
+	map = __bind(md, table, update_limits ? &limits : NULL);
 	dm_issue_global_event();
 
 out:
@@ -2930,7 +2944,6 @@ static int __dm_suspend(struct mapped_device *md, struct dm_table *map,
 
 	/*
 	 * DMF_NOFLUSH_SUSPENDING must be set before presuspend.
-	 * This flag is cleared before dm_suspend returns.
 	 */
 	if (noflush)
 		set_bit(DMF_NOFLUSH_SUSPENDING, &md->flags);
@@ -2993,8 +3006,6 @@ static int __dm_suspend(struct mapped_device *md, struct dm_table *map,
 	if (!r)
 		set_bit(dmf_suspended_flag, &md->flags);
 
-	if (noflush)
-		clear_bit(DMF_NOFLUSH_SUSPENDING, &md->flags);
 	if (map)
 		synchronize_srcu(&md->io_barrier);
 
-- 
2.50.1

