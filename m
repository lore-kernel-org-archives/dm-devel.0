Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3341721B8E0
	for <dm-devel@lists.linux.dev>; Tue, 20 May 2025 03:56:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747713386; cv=none; b=iE2uhAdocQjvl6oIjAh4nfA3qwnztou5sfymfPur8dhWJs/k/I1eZcUUuMYP69vMqaHZPv1i/c1FRaiOLs5AUL+wzSF7DT87IlJtWfC+X9GNLmygG1NDy9MLMJvMbsIXh/2HG1vBU5sPdf54h1Qmsu73+YODizII7Amx3eaSeNM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747713386; c=relaxed/simple;
	bh=ylDNwczoR6bXkUs9N8yRhtYnoebbQ3Tg0oy8QM6YNOE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 In-Reply-To:Content-Type:Content-Disposition; b=kJy7bUA8p2Lb5rHF0zt+d4a+ffIzUjrtUXWoObX2BtrgVENTaXBp9wUzv23ewfyxRifSKYfZgs1P92k1Gvb9cZH8qw9oWQBO3wgMxT3p5TVF8jfUBIZKlRdT8irVTODf1pj0ryJE9zGyGNBX54a2lNdm6fBNrSttsfS1pljTpnA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=NWHCqgJr; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="NWHCqgJr"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1747713381;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=UN4qbrZXWIQYZLel2RRZ7tBgQCtNe+MYoqXRdRAzzLM=;
	b=NWHCqgJra2qbuEJJmUGqsGZJIknXZ6Z+Ke7jBjsDPGV2x15gquval3vPN6kn54KpIgJtxD
	hoJ7wDb2qxzFoQQ48ILBOL/M5j0PDoX5uJmv238M/U3cvqjLzV7lRbpgZCs3Wq4Wn1STMr
	WnCostAF+noUjJg4PN+eZyPh5thzNdg=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-556-C_zx0gTlMyqEPzQ9QyNGzw-1; Mon,
 19 May 2025 23:56:18 -0400
X-MC-Unique: C_zx0gTlMyqEPzQ9QyNGzw-1
X-Mimecast-MFC-AGG-ID: C_zx0gTlMyqEPzQ9QyNGzw_1747713377
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 051D4195608A;
	Tue, 20 May 2025 03:56:17 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (unknown [10.6.23.247])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 3838A30001AA;
	Tue, 20 May 2025 03:56:16 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.17.1) with ESMTPS id 54K3uEKf178557
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Mon, 19 May 2025 23:56:14 -0400
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.18.1/Submit) id 54K3uBQe178555;
	Mon, 19 May 2025 23:56:11 -0400
Date: Mon, 19 May 2025 23:56:11 -0400
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: Mike Snitzer <snitzer@redhat.com>, dm-devel@lists.linux.dev,
        Kevin Wolf <kwolf@redhat.com>, Hanna Czenczek <hreitz@redhat.com>,
        Martin Wilck <martin.wilck@suse.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Christoph Hellwig <hch@infradead.org>, Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH] dm mpath: replace spin_lock_irqsave with spin_lock_irq
Message-ID: <aCv9W5KgT4akZBBq@redhat.com>
References: <20250516015530.4146175-1-bmarzins@redhat.com>
 <a6bbd5ee-492e-7a19-d884-52485e412a63@redhat.com>
 <5f348c81-5f69-089c-4092-86703f0b87a3@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <5f348c81-5f69-089c-4092-86703f0b87a3@redhat.com>
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: XUx_dAESjACM2I1LwUJ9i-phodo_16TSyWtsilF8NqY_1747713377
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, May 19, 2025 at 03:50:15PM +0200, Mikulas Patocka wrote:
> 
> 
> On Fri, 16 May 2025, Mikulas Patocka wrote:
> 
> > 
> > 
> > On Thu, 15 May 2025, Benjamin Marzinski wrote:
> > 
> > > @@ -2077,35 +2095,55 @@ static int probe_path(struct pgpath *pgpath)
> > >  static int probe_active_paths(struct multipath *m)
> > >  {
> > >  	struct pgpath *pgpath;
> > > -	struct priority_group *pg;
> > > +	struct priority_group *pg = NULL;
> > >  	unsigned long flags;
> > >  	int r = 0;
> > >  
> > > -	mutex_lock(&m->work_mutex);
> > > -
> > >  	spin_lock_irqsave(&m->lock, flags);
> > 
> > Hi
> > 
> > I suggest replacing spin_lock_irqsave/spin_unlock_irqrestore with 
> > spin_lock_irq/spin_unlock_irq here and in some other places where it is 
> > known that interrupts are enabled (for example __map_bio, 
> > process_queued_bios, multipath_ctr, flush_multipath_work, 
> > multipath_resume, multipath_status, multipath_prepare_ioctl, ...).
> > 
> > I accepted this patch, so you can send the spinlock changes in a follow-up 
> > patch.
> > 
> > Mikulas
> 
> Hi
> 
> I've created a patch for this. Please test it (with spinlock debugging 
> enabled), if it passes the tests, I'll stage it.

I tested this with CONFIG_DEBUG_SPINLOCK=y and everything looks fine.
Actually, I tested a slightly different patch. Your patch applies on top
of dm-6.15, but that means it doesn't clean up the spin_lock_irqsave()
calls in my last patch. I tested using a version of your patch that goes
on top of dm-for-next, and changes the spinlocks in probe_active_paths()
and multipath_presuspend(), both of which can also only be called with
interrupts enabled. Here it is:

From: Mikulas Patocka <mpatocka@redhat.com>

Replace spin_lock_irqsave/spin_unlock_irqrestore with
spin_lock_irq/spin_unlock_irq at places where it is known that interrupts
are enabled.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 drivers/md/dm-mpath.c | 75 ++++++++++++++++++-------------------------
 1 file changed, 31 insertions(+), 44 deletions(-)

diff --git a/drivers/md/dm-mpath.c b/drivers/md/dm-mpath.c
index 12b7bcae490c..81fec2e1e0ef 100644
--- a/drivers/md/dm-mpath.c
+++ b/drivers/md/dm-mpath.c
@@ -617,7 +617,6 @@ static void multipath_queue_bio(struct multipath *m, struct bio *bio)
 static struct pgpath *__map_bio(struct multipath *m, struct bio *bio)
 {
 	struct pgpath *pgpath;
-	unsigned long flags;
 
 	/* Do we need to select a new pgpath? */
 	pgpath = READ_ONCE(m->current_pgpath);
@@ -625,12 +624,12 @@ static struct pgpath *__map_bio(struct multipath *m, struct bio *bio)
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
@@ -693,7 +692,6 @@ static void process_queued_io_list(struct multipath *m)
 static void process_queued_bios(struct work_struct *work)
 {
 	int r;
-	unsigned long flags;
 	struct bio *bio;
 	struct bio_list bios;
 	struct blk_plug plug;
@@ -702,16 +700,16 @@ static void process_queued_bios(struct work_struct *work)
 
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
@@ -1195,7 +1193,6 @@ static int multipath_ctr(struct dm_target *ti, unsigned int argc, char **argv)
 	struct dm_arg_set as;
 	unsigned int pg_count = 0;
 	unsigned int next_pg_num;
-	unsigned long flags;
 
 	as.argc = argc;
 	as.argv = argv;
@@ -1260,9 +1257,9 @@ static int multipath_ctr(struct dm_target *ti, unsigned int argc, char **argv)
 		goto bad;
 	}
 
-	spin_lock_irqsave(&m->lock, flags);
+	spin_lock_irq(&m->lock);
 	enable_nopath_timeout(m);
-	spin_unlock_irqrestore(&m->lock, flags);
+	spin_unlock_irq(&m->lock);
 
 	ti->num_flush_bios = 1;
 	ti->num_discard_bios = 1;
@@ -1297,23 +1294,21 @@ static void multipath_wait_for_pg_init_completion(struct multipath *m)
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
@@ -1375,11 +1370,10 @@ static int fail_path(struct pgpath *pgpath)
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
@@ -1409,7 +1403,7 @@ static int reinstate_path(struct pgpath *pgpath)
 	schedule_work(&m->trigger_event);
 
 out:
-	spin_unlock_irqrestore(&m->lock, flags);
+	spin_unlock_irq(&m->lock);
 	if (run_queue) {
 		dm_table_run_md_queue_async(m->ti->table);
 		process_queued_io_list(m);
@@ -1470,7 +1464,6 @@ static int switch_pg_num(struct multipath *m, const char *pgstr)
 {
 	struct priority_group *pg;
 	unsigned int pgnum;
-	unsigned long flags;
 	char dummy;
 
 	if (!pgstr || (sscanf(pgstr, "%u%c", &pgnum, &dummy) != 1) || !pgnum ||
@@ -1479,7 +1472,7 @@ static int switch_pg_num(struct multipath *m, const char *pgstr)
 		return -EINVAL;
 	}
 
-	spin_lock_irqsave(&m->lock, flags);
+	spin_lock_irq(&m->lock);
 	list_for_each_entry(pg, &m->priority_groups, list) {
 		pg->bypassed = false;
 		if (--pgnum)
@@ -1493,7 +1486,7 @@ static int switch_pg_num(struct multipath *m, const char *pgstr)
 		}
 		m->next_pg = pg;
 	}
-	spin_unlock_irqrestore(&m->lock, flags);
+	spin_unlock_irq(&m->lock);
 
 	schedule_work(&m->trigger_event);
 	return 0;
@@ -1754,11 +1747,10 @@ static int multipath_end_io_bio(struct dm_target *ti, struct bio *clone,
 static void multipath_presuspend(struct dm_target *ti)
 {
 	struct multipath *m = ti->private;
-	unsigned long flags;
 
-	spin_lock_irqsave(&m->lock, flags);
+	spin_lock_irq(&m->lock);
 	m->is_suspending = true;
-	spin_unlock_irqrestore(&m->lock, flags);
+	spin_unlock_irq(&m->lock);
 	/* FIXME: bio-based shouldn't need to always disable queue_if_no_path */
 	if (m->queue_mode == DM_TYPE_BIO_BASED || !dm_noflush_suspending(m->ti))
 		queue_if_no_path(m, false, true, __func__);
@@ -1779,9 +1771,8 @@ static void multipath_postsuspend(struct dm_target *ti)
 static void multipath_resume(struct dm_target *ti)
 {
 	struct multipath *m = ti->private;
-	unsigned long flags;
 
-	spin_lock_irqsave(&m->lock, flags);
+	spin_lock_irq(&m->lock);
 	m->is_suspending = false;
 	if (test_bit(MPATHF_SAVED_QUEUE_IF_NO_PATH, &m->flags)) {
 		set_bit(MPATHF_QUEUE_IF_NO_PATH, &m->flags);
@@ -1793,7 +1784,7 @@ static void multipath_resume(struct dm_target *ti)
 		test_bit(MPATHF_QUEUE_IF_NO_PATH, &m->flags),
 		test_bit(MPATHF_SAVED_QUEUE_IF_NO_PATH, &m->flags));
 
-	spin_unlock_irqrestore(&m->lock, flags);
+	spin_unlock_irq(&m->lock);
 }
 
 /*
@@ -1816,14 +1807,13 @@ static void multipath_status(struct dm_target *ti, status_type_t type,
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
@@ -1969,7 +1959,7 @@ static void multipath_status(struct dm_target *ti, status_type_t type,
 		break;
 	}
 
-	spin_unlock_irqrestore(&m->lock, flags);
+	spin_unlock_irq(&m->lock);
 }
 
 static int multipath_message(struct dm_target *ti, unsigned int argc, char **argv,
@@ -1979,7 +1969,6 @@ static int multipath_message(struct dm_target *ti, unsigned int argc, char **arg
 	dev_t dev;
 	struct multipath *m = ti->private;
 	action_fn action;
-	unsigned long flags;
 
 	mutex_lock(&m->work_mutex);
 
@@ -1991,9 +1980,9 @@ static int multipath_message(struct dm_target *ti, unsigned int argc, char **arg
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
@@ -2096,10 +2085,9 @@ static int probe_active_paths(struct multipath *m)
 {
 	struct pgpath *pgpath;
 	struct priority_group *pg = NULL;
-	unsigned long flags;
 	int r = 0;
 
-	spin_lock_irqsave(&m->lock, flags);
+	spin_lock_irq(&m->lock);
 	if (test_bit(MPATHF_DELAY_PG_SWITCH, &m->flags)) {
 		wait_event_lock_irq(m->probe_wait,
 				    !test_bit(MPATHF_DELAY_PG_SWITCH, &m->flags),
@@ -2117,7 +2105,7 @@ static int probe_active_paths(struct multipath *m)
 		goto skip_probe;
 	set_bit(MPATHF_DELAY_PG_SWITCH, &m->flags);
 	pg = m->last_probed_pg = m->current_pg;
-	spin_unlock_irqrestore(&m->lock, flags);
+	spin_unlock_irq(&m->lock);
 
 	list_for_each_entry(pgpath, &pg->pgpaths, list) {
 		if (pg != READ_ONCE(m->current_pg) ||
@@ -2132,7 +2120,7 @@ static int probe_active_paths(struct multipath *m)
 	}
 
 out:
-	spin_lock_irqsave(&m->lock, flags);
+	spin_lock_irq(&m->lock);
 	clear_bit(MPATHF_DELAY_PG_SWITCH, &m->flags);
 	if (test_and_clear_bit(MPATHF_NEED_PG_SWITCH, &m->flags)) {
 		m->current_pgpath = NULL;
@@ -2141,7 +2129,7 @@ static int probe_active_paths(struct multipath *m)
 skip_probe:
 	if (r == 0 && !atomic_read(&m->nr_valid_paths))
 		r = -ENOTCONN;
-	spin_unlock_irqrestore(&m->lock, flags);
+	spin_unlock_irq(&m->lock);
 	if (pg)
 		wake_up(&m->probe_wait);
 	return r;
@@ -2154,7 +2142,6 @@ static int multipath_prepare_ioctl(struct dm_target *ti,
 {
 	struct multipath *m = ti->private;
 	struct pgpath *pgpath;
-	unsigned long flags;
 	int r;
 
 	if (_IOC_TYPE(cmd) == DM_IOCTL) {
@@ -2182,10 +2169,10 @@ static int multipath_prepare_ioctl(struct dm_target *ti,
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
@@ -2193,10 +2180,10 @@ static int multipath_prepare_ioctl(struct dm_target *ti,
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
-- 
2.46.1

