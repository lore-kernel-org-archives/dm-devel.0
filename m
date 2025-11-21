Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D6ED22655B
	for <dm-devel@lists.linux.dev>; Fri, 21 Nov 2025 23:50:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763769003; cv=none; b=ut9inmdBgJWHm6RGKvgqxpCV0V6Ya7nXks4FZH6lEGDRh4lEEnwEHslIgdzl9g70rbas3aHbhvNUDecH92HO1reT0JvmXF6c4OnrA5d4bbuujN3IqpxkWx/si9k56sRjQ8OskHg2lZcx/pk+hKy8FycV57FWagXt4fOcCgck5gk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763769003; c=relaxed/simple;
	bh=Ta4h2WyNnVlHQJzeuCw30WIFzUyD7X1PGBtJyA2/dBA=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:content-type; b=DJfSEWVjd8jbFPLNz5Z85Iav/s/0XUa4JKWTwmfKbAx7xvceQiZmmHIEGgNNZ9DzGNHYHhHZxcmu4/9l7r1Eqo0jcBmnAafC46MWn93GovjxdT13LteMpoCjygLGnIhGT4Jj1R1pssKuFGUSB7LHdGw6bonkEbldai1O+iz5sB8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=etpCRovr; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="etpCRovr"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1763768999;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=tP0h7X5/wWD7wHpaZTRjHpbzBs8dRfvurl+YFULcIZQ=;
	b=etpCRovrOx/oLEUQOfmtalm5jsE11o9da6gmJnb0svQeydnxdoiTyRwMTrMqyiwY8grN11
	zQRBcZtxy1fR7Flg7XHntiEG02BKvaD5k9emfW4LHVqNeuYpyAtL4/sOKWTnhhfnLcAOUt
	w6tzGMpA0nXyZHYUsb6oyBkZ2NDW0Vg=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-692-KDAEozxyNZKJjCV5DchrWA-1; Fri,
 21 Nov 2025 18:49:54 -0500
X-MC-Unique: KDAEozxyNZKJjCV5DchrWA-1
X-Mimecast-MFC-AGG-ID: KDAEozxyNZKJjCV5DchrWA_1763768994
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id E46711956048;
	Fri, 21 Nov 2025 23:49:53 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (unknown [10.6.23.247])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id ACC141956045;
	Fri, 21 Nov 2025 23:49:53 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.17.1) with ESMTPS id 5ALNnq9W1035087
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Fri, 21 Nov 2025 18:49:52 -0500
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.18.1/Submit) id 5ALNnqGs1035086;
	Fri, 21 Nov 2025 18:49:52 -0500
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Mikulas Patocka <mpatocka@redhat.com>, Mike Snitzer <snitzer@kernel.org>
Cc: dm-devel@lists.linux.dev, Martin Wilck <mwilck@suse.com>
Subject: [PATCH] dm-mpath: Simplify the setup_scsi_dh code
Date: Fri, 21 Nov 2025 18:49:52 -0500
Message-ID: <20251121234952.1035078-1-bmarzins@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: 4nIfQ7WmEVuM7QO8XxDSEdkIf8il6vKd5c630CnWEBI_1763768994
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true

There's no point to the MPATHF_RETAIN_ATTACHED_HW_HANDLER flag any more.
The way setup_scsi_dh() worked, if that flag wasn't set, it would
attempt to attach any passed in hardware handler. This would always fail
if a different hardware handler was attached, which caused
setup_scsi_dh() to rerun as if the flag was set. So the code would
already retain any attached handler, because attaching a different one
would always fail.

Also, the code had a bug. If attached_handler_name was NULL but there
was a scsi device handler attached (because either
scsi_dh_attached_handler_name failed() to allocate a name, a handler got
attached after it was called) the code would loop endlessly.

Instead, ignore MPATHF_RETAIN_ATTACHED_HW_HANDLER, and always free the
passed in handler if *attached_handler_name is set. This simplifies the
code, and avoids the endless loop bug, while keeping the functionality
the same.

Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 drivers/md/dm-mpath.c | 61 ++++++++++++++++---------------------------
 1 file changed, 23 insertions(+), 38 deletions(-)

diff --git a/drivers/md/dm-mpath.c b/drivers/md/dm-mpath.c
index 5dd90b2cdb9b..c18358271618 100644
--- a/drivers/md/dm-mpath.c
+++ b/drivers/md/dm-mpath.c
@@ -131,7 +131,7 @@ static void queue_if_no_path_timeout_work(struct timer_list *t);
 #define MPATHF_QUEUE_IO 0			/* Must we queue all I/O? */
 #define MPATHF_QUEUE_IF_NO_PATH 1		/* Queue I/O if last path fails? */
 #define MPATHF_SAVED_QUEUE_IF_NO_PATH 2		/* Saved state during suspension */
-#define MPATHF_RETAIN_ATTACHED_HW_HANDLER 3	/* If there's already a hw_handler present, don't change it. */
+/* MPATHF_RETAIN_ATTACHED_HW_HANDLER no longer has any effect */
 #define MPATHF_PG_INIT_DISABLED 4		/* pg_init is not currently allowed */
 #define MPATHF_PG_INIT_REQUIRED 5		/* pg_init needs calling? */
 #define MPATHF_PG_INIT_DELAY_RETRY 6		/* Delay pg_init retry? */
@@ -237,16 +237,10 @@ static struct multipath *alloc_multipath(struct dm_target *ti)
 
 static int alloc_multipath_stage2(struct dm_target *ti, struct multipath *m)
 {
-	if (m->queue_mode == DM_TYPE_NONE) {
+	if (m->queue_mode == DM_TYPE_NONE)
 		m->queue_mode = DM_TYPE_REQUEST_BASED;
-	} else if (m->queue_mode == DM_TYPE_BIO_BASED) {
+	else if (m->queue_mode == DM_TYPE_BIO_BASED)
 		INIT_WORK(&m->process_queued_bios, process_queued_bios);
-		/*
-		 * bio-based doesn't support any direct scsi_dh management;
-		 * it just discovers if a scsi_dh is attached.
-		 */
-		set_bit(MPATHF_RETAIN_ATTACHED_HW_HANDLER, &m->flags);
-	}
 
 	dm_table_set_type(ti->table, m->queue_mode);
 
@@ -887,36 +881,30 @@ static int setup_scsi_dh(struct block_device *bdev, struct multipath *m,
 	struct request_queue *q = bdev_get_queue(bdev);
 	int r;
 
-	if (mpath_double_check_test_bit(MPATHF_RETAIN_ATTACHED_HW_HANDLER, m)) {
-retain:
-		if (*attached_handler_name) {
-			/*
-			 * Clear any hw_handler_params associated with a
-			 * handler that isn't already attached.
-			 */
-			if (m->hw_handler_name && strcmp(*attached_handler_name, m->hw_handler_name)) {
-				kfree(m->hw_handler_params);
-				m->hw_handler_params = NULL;
-			}
-
-			/*
-			 * Reset hw_handler_name to match the attached handler
-			 *
-			 * NB. This modifies the table line to show the actual
-			 * handler instead of the original table passed in.
-			 */
-			kfree(m->hw_handler_name);
-			m->hw_handler_name = *attached_handler_name;
-			*attached_handler_name = NULL;
+	if (*attached_handler_name) {
+		/*
+		 * Clear any hw_handler_params associated with a
+		 * handler that isn't already attached.
+		 */
+		if (m->hw_handler_name && strcmp(*attached_handler_name,
+						 m->hw_handler_name)) {
+			kfree(m->hw_handler_params);
+			m->hw_handler_params = NULL;
 		}
+
+		/*
+		 * Reset hw_handler_name to match the attached handler
+		 *
+		 * NB. This modifies the table line to show the actual
+		 * handler instead of the original table passed in.
+		 */
+		kfree(m->hw_handler_name);
+		m->hw_handler_name = *attached_handler_name;
+		*attached_handler_name = NULL;
 	}
 
 	if (m->hw_handler_name) {
 		r = scsi_dh_attach(q, m->hw_handler_name);
-		if (r == -EBUSY) {
-			DMINFO("retaining handler on device %pg", bdev);
-			goto retain;
-		}
 		if (r < 0) {
 			*error = "error attaching hardware handler";
 			return r;
@@ -1138,7 +1126,7 @@ static int parse_features(struct dm_arg_set *as, struct multipath *m)
 		}
 
 		if (!strcasecmp(arg_name, "retain_attached_hw_handler")) {
-			set_bit(MPATHF_RETAIN_ATTACHED_HW_HANDLER, &m->flags);
+			/* no longer has any effect */
 			continue;
 		}
 
@@ -1823,7 +1811,6 @@ static void multipath_status(struct dm_target *ti, status_type_t type,
 		DMEMIT("%u ", test_bit(MPATHF_QUEUE_IF_NO_PATH, &m->flags) +
 			      (m->pg_init_retries > 0) * 2 +
 			      (m->pg_init_delay_msecs != DM_PG_INIT_DELAY_DEFAULT) * 2 +
-			      test_bit(MPATHF_RETAIN_ATTACHED_HW_HANDLER, &m->flags) +
 			      (m->queue_mode != DM_TYPE_REQUEST_BASED) * 2);
 
 		if (test_bit(MPATHF_QUEUE_IF_NO_PATH, &m->flags))
@@ -1832,8 +1819,6 @@ static void multipath_status(struct dm_target *ti, status_type_t type,
 			DMEMIT("pg_init_retries %u ", m->pg_init_retries);
 		if (m->pg_init_delay_msecs != DM_PG_INIT_DELAY_DEFAULT)
 			DMEMIT("pg_init_delay_msecs %u ", m->pg_init_delay_msecs);
-		if (test_bit(MPATHF_RETAIN_ATTACHED_HW_HANDLER, &m->flags))
-			DMEMIT("retain_attached_hw_handler ");
 		if (m->queue_mode != DM_TYPE_REQUEST_BASED) {
 			switch (m->queue_mode) {
 			case DM_TYPE_BIO_BASED:
-- 
2.50.1

