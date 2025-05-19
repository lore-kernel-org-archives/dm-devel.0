Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7534326B2A5
	for <dm-devel@lists.linux.dev>; Mon, 19 May 2025 13:50:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747662631; cv=none; b=Wy5l6ufEoTsFeYr/dx7n18mkIc1dS7TLHNMtfXqhHuZmS1DAIkYf5nU0ebV+eVdgsx828QNJWsMX3M77LZqtSzuEvqbi94Kp2mfXVq35nKQXBhtkqPgyaFU6Kr9VKRvRWXs9u1qZq592SynezGX2hEY864Fkbx298ns31a4r4Xs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747662631; c=relaxed/simple;
	bh=f9+AqjoifH8Hhm2Xjr34+nO+8en/rg7AghDSAn3mH54=;
	h=Date:From:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=bOiGAK/yLaYm7hvD4I5JCQtcdezPChOtcB1nzodwUU2n4vwLOTBWCfGg2yMYd9zuh/UtxGUrr1d7srBWkSAR+5z2mT3LWPUamh2th4kObowCCGWFVjx0bTbECfUgGo5pm1z1uOWj+DrTFuHLc7UkkQ/kxO172FYTLxyVvHzUudw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=ZYmRIELs; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ZYmRIELs"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1747662627;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=+jI+C9rMI4p64K6G4rk36nHS0tb3UnHv/AriYe/CJUI=;
	b=ZYmRIELsIsGMj2gnxFYXIGFxVDNJMX6s0Pa6KGjHFd6WEdAdI9glCtQ/xzd69jl3NzU6SA
	DNSH/LRl2MbL2n0DB3uCWiQSbqX3+73c2E9J+BcHsJbCBbImf/3JEPPbMsywVO3Cgfq08z
	SXSPjV29LeoN4SvIfW13R4Ga16dDz6M=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-169--R1oPCXENZ2UuozmYcL2aA-1; Mon,
 19 May 2025 09:50:26 -0400
X-MC-Unique: -R1oPCXENZ2UuozmYcL2aA-1
X-Mimecast-MFC-AGG-ID: -R1oPCXENZ2UuozmYcL2aA_1747662624
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 2203719560AD;
	Mon, 19 May 2025 13:50:24 +0000 (UTC)
Received: from [10.22.80.45] (unknown [10.22.80.45])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 5764F1800570;
	Mon, 19 May 2025 13:50:20 +0000 (UTC)
Date: Mon, 19 May 2025 15:50:15 +0200 (CEST)
From: Mikulas Patocka <mpatocka@redhat.com>
To: Benjamin Marzinski <bmarzins@redhat.com>
cc: Mike Snitzer <snitzer@redhat.com>, dm-devel@lists.linux.dev, 
    Kevin Wolf <kwolf@redhat.com>, Hanna Czenczek <hreitz@redhat.com>, 
    Martin Wilck <martin.wilck@suse.com>, Paolo Bonzini <pbonzini@redhat.com>, 
    Christoph Hellwig <hch@infradead.org>, Hannes Reinecke <hare@suse.de>
Subject: [PATCH] dm mpath: replace spin_lock_irqsave with spin_lock_irq
In-Reply-To: <a6bbd5ee-492e-7a19-d884-52485e412a63@redhat.com>
Message-ID: <5f348c81-5f69-089c-4092-86703f0b87a3@redhat.com>
References: <20250516015530.4146175-1-bmarzins@redhat.com> <a6bbd5ee-492e-7a19-d884-52485e412a63@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.93
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: VNyvBDDfvkzoeBxX6lIV-z8RBRMt8XkGD3mfwkMDYTY_1747662624
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=US-ASCII



On Fri, 16 May 2025, Mikulas Patocka wrote:

> 
> 
> On Thu, 15 May 2025, Benjamin Marzinski wrote:
> 
> > @@ -2077,35 +2095,55 @@ static int probe_path(struct pgpath *pgpath)
> >  static int probe_active_paths(struct multipath *m)
> >  {
> >  	struct pgpath *pgpath;
> > -	struct priority_group *pg;
> > +	struct priority_group *pg = NULL;
> >  	unsigned long flags;
> >  	int r = 0;
> >  
> > -	mutex_lock(&m->work_mutex);
> > -
> >  	spin_lock_irqsave(&m->lock, flags);
> 
> Hi
> 
> I suggest replacing spin_lock_irqsave/spin_unlock_irqrestore with 
> spin_lock_irq/spin_unlock_irq here and in some other places where it is 
> known that interrupts are enabled (for example __map_bio, 
> process_queued_bios, multipath_ctr, flush_multipath_work, 
> multipath_resume, multipath_status, multipath_prepare_ioctl, ...).
> 
> I accepted this patch, so you can send the spinlock changes in a follow-up 
> patch.
> 
> Mikulas

Hi

I've created a patch for this. Please test it (with spinlock debugging 
enabled), if it passes the tests, I'll stage it.

Mikulas



From: Mikulas Patocka <mpatocka@redhat.com>

Replace spin_lock_irqsave/spin_unlock_irqrestore with
spin_lock_irq/spin_unlock_irq at places where it is known that interrupts
are enabled.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>

---
 drivers/md/dm-mpath.c |   61 ++++++++++++++++++++------------------------------
 1 file changed, 25 insertions(+), 36 deletions(-)

Index: linux-2.6/drivers/md/dm-mpath.c
===================================================================
--- linux-2.6.orig/drivers/md/dm-mpath.c
+++ linux-2.6/drivers/md/dm-mpath.c
@@ -612,7 +612,6 @@ static void multipath_queue_bio(struct m
 static struct pgpath *__map_bio(struct multipath *m, struct bio *bio)
 {
 	struct pgpath *pgpath;
-	unsigned long flags;
 
 	/* Do we need to select a new pgpath? */
 	pgpath = READ_ONCE(m->current_pgpath);
@@ -620,12 +619,12 @@ static struct pgpath *__map_bio(struct m
 		pgpath = choose_pgpath(m, bio->bi_iter.bi_size);
 
 	if (!pgpath) {
-		spin_lock_irqsave(&m->lock, flags);
+		spin_lock_irq(&m->lock);
 		if (test_bit(MPATHF_QUEUE_IF_NO_PATH, &m->flags)) {
 			__multipath_queue_bio(m, bio);
 			pgpath = ERR_PTR(-EAGAIN);
 		}
-		spin_unlock_irqrestore(&m->lock, flags);
+		spin_unlock_irq(&m->lock);
 
 	} else if (mpath_double_check_test_bit(MPATHF_QUEUE_IO, m) ||
 		   mpath_double_check_test_bit(MPATHF_PG_INIT_REQUIRED, m)) {
@@ -688,7 +687,6 @@ static void process_queued_io_list(struc
 static void process_queued_bios(struct work_struct *work)
 {
 	int r;
-	unsigned long flags;
 	struct bio *bio;
 	struct bio_list bios;
 	struct blk_plug plug;
@@ -697,16 +695,16 @@ static void process_queued_bios(struct w
 
 	bio_list_init(&bios);
 
-	spin_lock_irqsave(&m->lock, flags);
+	spin_lock_irq(&m->lock);
 
 	if (bio_list_empty(&m->queued_bios)) {
-		spin_unlock_irqrestore(&m->lock, flags);
+		spin_unlock_irq(&m->lock);
 		return;
 	}
 
 	bio_list_merge_init(&bios, &m->queued_bios);
 
-	spin_unlock_irqrestore(&m->lock, flags);
+	spin_unlock_irq(&m->lock);
 
 	blk_start_plug(&plug);
 	while ((bio = bio_list_pop(&bios))) {
@@ -1190,7 +1188,6 @@ static int multipath_ctr(struct dm_targe
 	struct dm_arg_set as;
 	unsigned int pg_count = 0;
 	unsigned int next_pg_num;
-	unsigned long flags;
 
 	as.argc = argc;
 	as.argv = argv;
@@ -1255,9 +1252,9 @@ static int multipath_ctr(struct dm_targe
 		goto bad;
 	}
 
-	spin_lock_irqsave(&m->lock, flags);
+	spin_lock_irq(&m->lock);
 	enable_nopath_timeout(m);
-	spin_unlock_irqrestore(&m->lock, flags);
+	spin_unlock_irq(&m->lock);
 
 	ti->num_flush_bios = 1;
 	ti->num_discard_bios = 1;
@@ -1292,23 +1289,21 @@ static void multipath_wait_for_pg_init_c
 static void flush_multipath_work(struct multipath *m)
 {
 	if (m->hw_handler_name) {
-		unsigned long flags;
-
 		if (!atomic_read(&m->pg_init_in_progress))
 			goto skip;
 
-		spin_lock_irqsave(&m->lock, flags);
+		spin_lock_irq(&m->lock);
 		if (atomic_read(&m->pg_init_in_progress) &&
 		    !test_and_set_bit(MPATHF_PG_INIT_DISABLED, &m->flags)) {
-			spin_unlock_irqrestore(&m->lock, flags);
+			spin_unlock_irq(&m->lock);
 
 			flush_workqueue(kmpath_handlerd);
 			multipath_wait_for_pg_init_completion(m);
 
-			spin_lock_irqsave(&m->lock, flags);
+			spin_lock_irq(&m->lock);
 			clear_bit(MPATHF_PG_INIT_DISABLED, &m->flags);
 		}
-		spin_unlock_irqrestore(&m->lock, flags);
+		spin_unlock_irq(&m->lock);
 	}
 skip:
 	if (m->queue_mode == DM_TYPE_BIO_BASED)
@@ -1370,11 +1365,10 @@ out:
 static int reinstate_path(struct pgpath *pgpath)
 {
 	int r = 0, run_queue = 0;
-	unsigned long flags;
 	struct multipath *m = pgpath->pg->m;
 	unsigned int nr_valid_paths;
 
-	spin_lock_irqsave(&m->lock, flags);
+	spin_lock_irq(&m->lock);
 
 	if (pgpath->is_active)
 		goto out;
@@ -1404,7 +1398,7 @@ static int reinstate_path(struct pgpath
 	schedule_work(&m->trigger_event);
 
 out:
-	spin_unlock_irqrestore(&m->lock, flags);
+	spin_unlock_irq(&m->lock);
 	if (run_queue) {
 		dm_table_run_md_queue_async(m->ti->table);
 		process_queued_io_list(m);
@@ -1461,7 +1455,6 @@ static int switch_pg_num(struct multipat
 {
 	struct priority_group *pg;
 	unsigned int pgnum;
-	unsigned long flags;
 	char dummy;
 
 	if (!pgstr || (sscanf(pgstr, "%u%c", &pgnum, &dummy) != 1) || !pgnum ||
@@ -1470,7 +1463,7 @@ static int switch_pg_num(struct multipat
 		return -EINVAL;
 	}
 
-	spin_lock_irqsave(&m->lock, flags);
+	spin_lock_irq(&m->lock);
 	list_for_each_entry(pg, &m->priority_groups, list) {
 		pg->bypassed = false;
 		if (--pgnum)
@@ -1480,7 +1473,7 @@ static int switch_pg_num(struct multipat
 		m->current_pg = NULL;
 		m->next_pg = pg;
 	}
-	spin_unlock_irqrestore(&m->lock, flags);
+	spin_unlock_irq(&m->lock);
 
 	schedule_work(&m->trigger_event);
 	return 0;
@@ -1762,9 +1755,8 @@ static void multipath_postsuspend(struct
 static void multipath_resume(struct dm_target *ti)
 {
 	struct multipath *m = ti->private;
-	unsigned long flags;
 
-	spin_lock_irqsave(&m->lock, flags);
+	spin_lock_irq(&m->lock);
 	if (test_bit(MPATHF_SAVED_QUEUE_IF_NO_PATH, &m->flags)) {
 		set_bit(MPATHF_QUEUE_IF_NO_PATH, &m->flags);
 		clear_bit(MPATHF_SAVED_QUEUE_IF_NO_PATH, &m->flags);
@@ -1775,7 +1767,7 @@ static void multipath_resume(struct dm_t
 		test_bit(MPATHF_QUEUE_IF_NO_PATH, &m->flags),
 		test_bit(MPATHF_SAVED_QUEUE_IF_NO_PATH, &m->flags));
 
-	spin_unlock_irqrestore(&m->lock, flags);
+	spin_unlock_irq(&m->lock);
 }
 
 /*
@@ -1798,14 +1790,13 @@ static void multipath_status(struct dm_t
 			     unsigned int status_flags, char *result, unsigned int maxlen)
 {
 	int sz = 0, pg_counter, pgpath_counter;
-	unsigned long flags;
 	struct multipath *m = ti->private;
 	struct priority_group *pg;
 	struct pgpath *p;
 	unsigned int pg_num;
 	char state;
 
-	spin_lock_irqsave(&m->lock, flags);
+	spin_lock_irq(&m->lock);
 
 	/* Features */
 	if (type == STATUSTYPE_INFO)
@@ -1951,7 +1942,7 @@ static void multipath_status(struct dm_t
 		break;
 	}
 
-	spin_unlock_irqrestore(&m->lock, flags);
+	spin_unlock_irq(&m->lock);
 }
 
 static int multipath_message(struct dm_target *ti, unsigned int argc, char **argv,
@@ -1961,7 +1952,6 @@ static int multipath_message(struct dm_t
 	dev_t dev;
 	struct multipath *m = ti->private;
 	action_fn action;
-	unsigned long flags;
 
 	mutex_lock(&m->work_mutex);
 
@@ -1973,9 +1963,9 @@ static int multipath_message(struct dm_t
 	if (argc == 1) {
 		if (!strcasecmp(argv[0], "queue_if_no_path")) {
 			r = queue_if_no_path(m, true, false, __func__);
-			spin_lock_irqsave(&m->lock, flags);
+			spin_lock_irq(&m->lock);
 			enable_nopath_timeout(m);
-			spin_unlock_irqrestore(&m->lock, flags);
+			spin_unlock_irq(&m->lock);
 			goto out;
 		} else if (!strcasecmp(argv[0], "fail_if_no_path")) {
 			r = queue_if_no_path(m, false, false, __func__);
@@ -2026,7 +2016,6 @@ static int multipath_prepare_ioctl(struc
 {
 	struct multipath *m = ti->private;
 	struct pgpath *pgpath;
-	unsigned long flags;
 	int r;
 
 	pgpath = READ_ONCE(m->current_pgpath);
@@ -2044,10 +2033,10 @@ static int multipath_prepare_ioctl(struc
 	} else {
 		/* No path is available */
 		r = -EIO;
-		spin_lock_irqsave(&m->lock, flags);
+		spin_lock_irq(&m->lock);
 		if (test_bit(MPATHF_QUEUE_IF_NO_PATH, &m->flags))
 			r = -ENOTCONN;
-		spin_unlock_irqrestore(&m->lock, flags);
+		spin_unlock_irq(&m->lock);
 	}
 
 	if (r == -ENOTCONN) {
@@ -2055,10 +2044,10 @@ static int multipath_prepare_ioctl(struc
 			/* Path status changed, redo selection */
 			(void) choose_pgpath(m, 0);
 		}
-		spin_lock_irqsave(&m->lock, flags);
+		spin_lock_irq(&m->lock);
 		if (test_bit(MPATHF_PG_INIT_REQUIRED, &m->flags))
 			(void) __pg_init_all_paths(m);
-		spin_unlock_irqrestore(&m->lock, flags);
+		spin_unlock_irq(&m->lock);
 		dm_table_run_md_queue_async(m->ti->table);
 		process_queued_io_list(m);
 	}

