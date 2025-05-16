Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 190DF23AD
	for <dm-devel@lists.linux.dev>; Fri, 16 May 2025 01:55:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747360547; cv=none; b=irVh38GLfp0bDTq9w+DyMxvh2OIt+M7dCRIuphvcyzTRD4FXjJaq00SPf1OjF/GNkE8G6hKynvRf1zG8K9q1JDeE97y0x9jp25wbe2CdELMbnT4eFTcDwGgrhhvHtgVzES1yqTWxzEPgJvcTSaT6pT4MqP4kRf+xmVcWGwqn78A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747360547; c=relaxed/simple;
	bh=qFE+Fx1HnOsXj2ZZ1QUHMR5NbvaS/2poI3jscQ10RAk=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:content-type; b=XA1Jq1AGAsaZ8eUTlFtu7W47uJqrmM7PIs8IINypNLAfyXvDa833G/Ay9f+3edaWt203Mi4Vy47bArYmQ+2PBy6eQOEBlo61fJPM3lwrQ6YsQz+8+shwC3TgFWyWzftx0oWaF+uffcMo+kjczxCiZ+aIkWAUXLh6HOVs0X61Lb8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=ao5z0yND; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ao5z0yND"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1747360541;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=Uq6EI5N53UDCIy5uhfCnZBKCBzPwmJLrFAVfRqCX2N0=;
	b=ao5z0yND/L4qCPazmedi/cIu17TGzziI3isICArp8AFYAUCq9JtbPDHc1kJr0j+/y+lxHS
	Nw4oYXVT9S5AQK6XISj/c1Q/j/+Akh1oUdn7+Z4QX2P35E9mPJEFuNc4WmTEXj3EsmkTYU
	hCllxGkSXOfr13BqwV/ca3B+Kv4hcE8=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-541-qRT26sxIMzeDrItJlHS9uA-1; Thu,
 15 May 2025 21:55:38 -0400
X-MC-Unique: qRT26sxIMzeDrItJlHS9uA-1
X-Mimecast-MFC-AGG-ID: qRT26sxIMzeDrItJlHS9uA_1747360537
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 86FB9180035F;
	Fri, 16 May 2025 01:55:37 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (unknown [10.6.23.247])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id AECD7180047F;
	Fri, 16 May 2025 01:55:36 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.17.1) with ESMTPS id 54G1tZWR4146184
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Thu, 15 May 2025 21:55:35 -0400
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.18.1/Submit) id 54G1tUje4146183;
	Thu, 15 May 2025 21:55:30 -0400
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Mikulas Patocka <mpatocka@redhat.com>, Mike Snitzer <snitzer@redhat.com>
Cc: dm-devel@lists.linux.dev, Kevin Wolf <kwolf@redhat.com>,
        Hanna Czenczek <hreitz@redhat.com>,
        Martin Wilck <martin.wilck@suse.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Christoph Hellwig <hch@infradead.org>, Hannes Reinecke <hare@suse.de>
Subject: [PATCH] dm-mpath: Don't grab work_mutex while probing paths
Date: Thu, 15 May 2025 21:55:29 -0400
Message-ID: <20250516015530.4146175-1-bmarzins@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: ynxfrwJwerlpRgj6f2FW5767XYP6VyN6v5VX_gamqDc_1747360537
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true

Grabbing the work_mutex keeps probe_active_paths() from running at the
same time as multipath_message(). The only messages that could interfere
with probing the paths are "disable_group", "enable_group", and
"switch_group". These messages could force multipath to pick a new
pathgroup while probe_active_paths() was probing the current pathgroup.
If the multipath device has a hardware handler, and it switches active
pathgroups while there is outstanding IO to a path device, it's possible
that IO to the path will fail, even if the path would be usable if it
was in the active pathgroup. To avoid this, do not clear the current
pathgroup for the *_group messages while probe_active_paths() is
running. Instead set a flag, and probe_active_paths() will clear the
current pathgroup when it finishes probing the paths. For this to work
correctly, multipath needs to check current_pg before next_pg in
choose_pgpath(), but before this patch next_pg was only ever set when
current_pg was cleared, so this doesn't change the current behavior when
paths aren't being probed. Even with this change, it is still possible
to switch pathgroups while the probe is running, but only if all the
paths have failed, and the probe function will skip them as well in this
case.

If multiple DM_MPATH_PROBE_PATHS requests are received at once, there is
no point in repeatedly issuing test IOs. Instead, the later probes
should wait for the current probe to complete. If current pathgroup is
still the same as the one that was just checked, the other probes should
skip probing and just check the number of valid paths.  Finally, probing
the paths should quit early if the multipath device is trying to
suspend, instead of continuing to issue test IOs, delaying the suspend.

While this patch will not change the behavior of existing multipath
users which don't use the DM_MPATH_PROBE_PATHS ioctl, when that ioctl
is used, the behavior of the "disable_group", "enable_group", and
"switch_group" messages can change subtly. When these messages return,
the next IO to the multipath device will no longer be guaranteed to
choose a new pathgroup. Instead, choosing a new pathgroup could be
delayed by an in-progress DM_MPATH_PROBE_PATHS ioctl. The userspace
multipath tools make no assumptions about what will happen to IOs after
sending these messages, so this change will not effect already released
versions of them, even if the DM_MPATH_PROBE_PATHS ioctl is run
alongside them.

Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 drivers/md/dm-mpath.c | 118 ++++++++++++++++++++++++++++--------------
 1 file changed, 78 insertions(+), 40 deletions(-)

diff --git a/drivers/md/dm-mpath.c b/drivers/md/dm-mpath.c
index 53861ad5dd1d..12b7bcae490c 100644
--- a/drivers/md/dm-mpath.c
+++ b/drivers/md/dm-mpath.c
@@ -79,6 +79,7 @@ struct multipath {
 	struct pgpath *current_pgpath;
 	struct priority_group *current_pg;
 	struct priority_group *next_pg;	/* Switch to this PG if set */
+	struct priority_group *last_probed_pg;
 
 	atomic_t nr_valid_paths;	/* Total number of usable paths */
 	unsigned int nr_priority_groups;
@@ -87,6 +88,7 @@ struct multipath {
 	const char *hw_handler_name;
 	char *hw_handler_params;
 	wait_queue_head_t pg_init_wait;	/* Wait for pg_init completion */
+	wait_queue_head_t probe_wait;   /* Wait for probing paths */
 	unsigned int pg_init_retries;	/* Number of times to retry pg_init */
 	unsigned int pg_init_delay_msecs;	/* Number of msecs before pg_init retry */
 	atomic_t pg_init_in_progress;	/* Only one pg_init allowed at once */
@@ -100,6 +102,7 @@ struct multipath {
 	struct bio_list queued_bios;
 
 	struct timer_list nopath_timer;	/* Timeout for queue_if_no_path */
+	bool is_suspending;
 };
 
 /*
@@ -132,6 +135,8 @@ static void queue_if_no_path_timeout_work(struct timer_list *t);
 #define MPATHF_PG_INIT_DISABLED 4		/* pg_init is not currently allowed */
 #define MPATHF_PG_INIT_REQUIRED 5		/* pg_init needs calling? */
 #define MPATHF_PG_INIT_DELAY_RETRY 6		/* Delay pg_init retry? */
+#define MPATHF_DELAY_PG_SWITCH 7		/* Delay switching pg if it still has paths */
+#define MPATHF_NEED_PG_SWITCH 8			/* Need to switch pgs after the delay has ended */
 
 static bool mpath_double_check_test_bit(int MPATHF_bit, struct multipath *m)
 {
@@ -254,6 +259,7 @@ static int alloc_multipath_stage2(struct dm_target *ti, struct multipath *m)
 	atomic_set(&m->pg_init_count, 0);
 	m->pg_init_delay_msecs = DM_PG_INIT_DELAY_DEFAULT;
 	init_waitqueue_head(&m->pg_init_wait);
+	init_waitqueue_head(&m->probe_wait);
 
 	return 0;
 }
@@ -413,13 +419,21 @@ static struct pgpath *choose_pgpath(struct multipath *m, size_t nr_bytes)
 		goto failed;
 	}
 
+	/* Don't change PG until it has no remaining paths */
+	pg = READ_ONCE(m->current_pg);
+	if (pg) {
+		pgpath = choose_path_in_pg(m, pg, nr_bytes);
+		if (!IS_ERR_OR_NULL(pgpath))
+			return pgpath;
+	}
+
 	/* Were we instructed to switch PG? */
 	if (READ_ONCE(m->next_pg)) {
 		spin_lock_irqsave(&m->lock, flags);
 		pg = m->next_pg;
 		if (!pg) {
 			spin_unlock_irqrestore(&m->lock, flags);
-			goto check_current_pg;
+			goto check_all_pgs;
 		}
 		m->next_pg = NULL;
 		spin_unlock_irqrestore(&m->lock, flags);
@@ -427,16 +441,7 @@ static struct pgpath *choose_pgpath(struct multipath *m, size_t nr_bytes)
 		if (!IS_ERR_OR_NULL(pgpath))
 			return pgpath;
 	}
-
-	/* Don't change PG until it has no remaining paths */
-check_current_pg:
-	pg = READ_ONCE(m->current_pg);
-	if (pg) {
-		pgpath = choose_path_in_pg(m, pg, nr_bytes);
-		if (!IS_ERR_OR_NULL(pgpath))
-			return pgpath;
-	}
-
+check_all_pgs:
 	/*
 	 * Loop through priority groups until we find a valid path.
 	 * First time we skip PGs marked 'bypassed'.
@@ -1439,15 +1444,19 @@ static int action_dev(struct multipath *m, dev_t dev, action_fn action)
  * Temporarily try to avoid having to use the specified PG
  */
 static void bypass_pg(struct multipath *m, struct priority_group *pg,
-		      bool bypassed)
+		      bool bypassed, bool can_be_delayed)
 {
 	unsigned long flags;
 
 	spin_lock_irqsave(&m->lock, flags);
 
 	pg->bypassed = bypassed;
-	m->current_pgpath = NULL;
-	m->current_pg = NULL;
+	if (can_be_delayed && test_bit(MPATHF_DELAY_PG_SWITCH, &m->flags))
+		set_bit(MPATHF_NEED_PG_SWITCH, &m->flags);
+	else {
+		m->current_pgpath = NULL;
+		m->current_pg = NULL;
+	}
 
 	spin_unlock_irqrestore(&m->lock, flags);
 
@@ -1476,8 +1485,12 @@ static int switch_pg_num(struct multipath *m, const char *pgstr)
 		if (--pgnum)
 			continue;
 
-		m->current_pgpath = NULL;
-		m->current_pg = NULL;
+		if (test_bit(MPATHF_DELAY_PG_SWITCH, &m->flags))
+			set_bit(MPATHF_NEED_PG_SWITCH, &m->flags);
+		else {
+			m->current_pgpath = NULL;
+			m->current_pg = NULL;
+		}
 		m->next_pg = pg;
 	}
 	spin_unlock_irqrestore(&m->lock, flags);
@@ -1507,7 +1520,7 @@ static int bypass_pg_num(struct multipath *m, const char *pgstr, bool bypassed)
 			break;
 	}
 
-	bypass_pg(m, pg, bypassed);
+	bypass_pg(m, pg, bypassed, true);
 	return 0;
 }
 
@@ -1561,7 +1574,7 @@ static void pg_init_done(void *data, int errors)
 		 * Probably doing something like FW upgrade on the
 		 * controller so try the other pg.
 		 */
-		bypass_pg(m, pg, true);
+		bypass_pg(m, pg, true, false);
 		break;
 	case SCSI_DH_RETRY:
 		/* Wait before retrying. */
@@ -1741,7 +1754,11 @@ static int multipath_end_io_bio(struct dm_target *ti, struct bio *clone,
 static void multipath_presuspend(struct dm_target *ti)
 {
 	struct multipath *m = ti->private;
+	unsigned long flags;
 
+	spin_lock_irqsave(&m->lock, flags);
+	m->is_suspending = true;
+	spin_unlock_irqrestore(&m->lock, flags);
 	/* FIXME: bio-based shouldn't need to always disable queue_if_no_path */
 	if (m->queue_mode == DM_TYPE_BIO_BASED || !dm_noflush_suspending(m->ti))
 		queue_if_no_path(m, false, true, __func__);
@@ -1765,6 +1782,7 @@ static void multipath_resume(struct dm_target *ti)
 	unsigned long flags;
 
 	spin_lock_irqsave(&m->lock, flags);
+	m->is_suspending = false;
 	if (test_bit(MPATHF_SAVED_QUEUE_IF_NO_PATH, &m->flags)) {
 		set_bit(MPATHF_QUEUE_IF_NO_PATH, &m->flags);
 		clear_bit(MPATHF_SAVED_QUEUE_IF_NO_PATH, &m->flags);
@@ -1845,10 +1863,10 @@ static void multipath_status(struct dm_target *ti, status_type_t type,
 
 	DMEMIT("%u ", m->nr_priority_groups);
 
-	if (m->next_pg)
-		pg_num = m->next_pg->pg_num;
-	else if (m->current_pg)
+	if (m->current_pg)
 		pg_num = m->current_pg->pg_num;
+	else if (m->next_pg)
+		pg_num = m->next_pg->pg_num;
 	else
 		pg_num = (m->nr_priority_groups ? 1 : 0);
 
@@ -2077,35 +2095,55 @@ static int probe_path(struct pgpath *pgpath)
 static int probe_active_paths(struct multipath *m)
 {
 	struct pgpath *pgpath;
-	struct priority_group *pg;
+	struct priority_group *pg = NULL;
 	unsigned long flags;
 	int r = 0;
 
-	mutex_lock(&m->work_mutex);
-
 	spin_lock_irqsave(&m->lock, flags);
-	if (test_bit(MPATHF_QUEUE_IO, &m->flags))
-		pg = NULL;
-	else
-		pg = m->current_pg;
+	if (test_bit(MPATHF_DELAY_PG_SWITCH, &m->flags)) {
+		wait_event_lock_irq(m->probe_wait,
+				    !test_bit(MPATHF_DELAY_PG_SWITCH, &m->flags),
+				    m->lock);
+		/*
+		 * if we waited because a probe was already in progress,
+		 * and it probed the current active pathgroup, don't
+		 * reprobe. Just return the number of valid paths
+		 */
+		if (m->current_pg == m->last_probed_pg)
+			goto skip_probe;
+	}
+	if (!m->current_pg || m->is_suspending ||
+	    test_bit(MPATHF_QUEUE_IO, &m->flags))
+		goto skip_probe;
+	set_bit(MPATHF_DELAY_PG_SWITCH, &m->flags);
+	pg = m->last_probed_pg = m->current_pg;
 	spin_unlock_irqrestore(&m->lock, flags);
 
-	if (pg) {
-		list_for_each_entry(pgpath, &pg->pgpaths, list) {
-			if (!pgpath->is_active)
-				continue;
+	list_for_each_entry(pgpath, &pg->pgpaths, list) {
+		if (pg != READ_ONCE(m->current_pg) ||
+		    READ_ONCE(m->is_suspending))
+			goto out;
+		if (!pgpath->is_active)
+			continue;
 
-			r = probe_path(pgpath);
-			if (r < 0)
-				goto out;
-		}
+		r = probe_path(pgpath);
+		if (r < 0)
+			goto out;
 	}
 
-	if (!atomic_read(&m->nr_valid_paths))
-		r = -ENOTCONN;
-
 out:
-	mutex_unlock(&m->work_mutex);
+	spin_lock_irqsave(&m->lock, flags);
+	clear_bit(MPATHF_DELAY_PG_SWITCH, &m->flags);
+	if (test_and_clear_bit(MPATHF_NEED_PG_SWITCH, &m->flags)) {
+		m->current_pgpath = NULL;
+		m->current_pg = NULL;
+	}
+skip_probe:
+	if (r == 0 && !atomic_read(&m->nr_valid_paths))
+		r = -ENOTCONN;
+	spin_unlock_irqrestore(&m->lock, flags);
+	if (pg)
+		wake_up(&m->probe_wait);
 	return r;
 }
 
-- 
2.48.1

