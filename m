Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C6FF23645D
	for <dm-devel@lists.linux.dev>; Wed,  5 Nov 2025 15:03:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762355024; cv=none; b=ss7MW/AcoZOPYajsJoDRdY5YBtdoYZwnYbkEDmtG8CXhjHfa0ounjAzw1MCl+VG7rhtpK4Bs0eDOgwX7Ta6OfBBmdFNT3n/hE5SQZgU3qvt5B9jVpo1uvVucSdMpviuPXojNqPQG5k3qk/D2gn/uwaO93oQ36ObDJZlDTOZWK+g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762355024; c=relaxed/simple;
	bh=GbvhQot8QXXgQcoJ+Ne3L4eUMNgzFp9o9Yllj641iEk=;
	h=Date:From:To:Subject:Message-ID:MIME-Version:Content-Type; b=qLjP5/dNsNtAce89xkyruVRCh2a0yowXN2/rtu1D67EgPCzpNFEBG3CCqFaE+V1vCP9/EL2Rm3TOrGDNCpsx0lUBLOoaqOgtXMXtm4JUhjaOQ9efM3SAXYt6NqJD/hiKQJsv3CTkhHW4V8y/wDONyNvid3LSiqTAJ/vih+h+slM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=QrbPsG9T; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="QrbPsG9T"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1762355021;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:mime-version:mime-version:content-type:content-type;
	bh=psx61vsbYDjGzGI9XkMvi98Dt0OzROMogSN0oBBy6t4=;
	b=QrbPsG9TMsqcrhVEmSz/8R/49odv/MEu9UQq8KOU6O6Q/9FnzIaNRLLM670foaUYpBgMrl
	wEb0l4O5WPOLgbXHG1j8VN1p5Km4v21L6Yb3PQsGzk0j00cczu8MQ2nLq+rdviGJhebnWp
	i2oRK0+7Wxuh0kW+xsv8n/yHYsmY+N8=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-529-ZyiS4af3PvKbygJ4xorwsQ-1; Wed,
 05 Nov 2025 10:03:37 -0500
X-MC-Unique: ZyiS4af3PvKbygJ4xorwsQ-1
X-Mimecast-MFC-AGG-ID: ZyiS4af3PvKbygJ4xorwsQ_1762355014
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 0B43018FCEA7;
	Wed,  5 Nov 2025 15:02:41 +0000 (UTC)
Received: from [10.45.225.163] (unknown [10.45.225.163])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 1A27A3000198;
	Wed,  5 Nov 2025 15:02:38 +0000 (UTC)
Date: Wed, 5 Nov 2025 16:02:36 +0100 (CET)
From: Mikulas Patocka <mpatocka@redhat.com>
To: John Garry <john.g.garry@oracle.com>, agk@redhat.com, snitzer@kernel.org, 
    dm-devel@lists.linux.dev, michael.christie@oracle.com, 
    martin.petersen@oracle.com
Subject: [PATCH 2/2] dm-crypt: enable DM_TARGET_ATOMIC_WRITES
Message-ID: <e0b99d8e-1159-a489-6df3-648b21c4f091@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: NDbMbB9CDi3wIw7b-0To-Swvvx24V2dFPSUzkS1_ob0_1762355014
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=US-ASCII

Allow handling of bios with REQ_ATOMIC flag set.

Don't split these bios and fail them if they overrun the hard limit
"BIO_MAX_VECS << PAGE_SHIFT".

This commit joins the logic that avoids splitting emulated zone append
bios with atomic write bios.

Signed-off-by: John Garry <john.g.garry@oracle.com>
Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>

---
 drivers/md/dm-crypt.c |   39 ++++++++++++++++++++++++---------------
 1 file changed, 24 insertions(+), 15 deletions(-)

Index: linux-2.6/drivers/md/dm-crypt.c
===================================================================
--- linux-2.6.orig/drivers/md/dm-crypt.c	2025-11-05 14:50:28.000000000 +0100
+++ linux-2.6/drivers/md/dm-crypt.c	2025-11-05 14:50:28.000000000 +0100
@@ -254,22 +254,15 @@ static unsigned int max_write_size = 0;
 module_param(max_write_size, uint, 0644);
 MODULE_PARM_DESC(max_write_size, "Maximum size of a write request");
 
-static unsigned get_max_request_sectors(struct dm_target *ti, struct bio *bio)
+static unsigned get_max_request_sectors(struct dm_target *ti, struct bio *bio, bool no_split)
 {
 	struct crypt_config *cc = ti->private;
 	unsigned val, sector_align;
 	bool wrt = op_is_write(bio_op(bio));
 
-	if (wrt) {
-		/*
-		 * For zoned devices, splitting write operations creates the
-		 * risk of deadlocking queue freeze operations with zone write
-		 * plugging BIO work when the reminder of a split BIO is
-		 * issued. So always allow the entire BIO to proceed.
-		 */
-		if (ti->emulate_zone_append)
-			return bio_sectors(bio);
-
+	if (no_split) {
+		val = -1;
+	} else if (wrt) {
 		val = min_not_zero(READ_ONCE(max_write_size),
 				   DM_CRYPT_DEFAULT_MAX_WRITE_SIZE);
 	} else {
@@ -3496,6 +3489,7 @@ static int crypt_map(struct dm_target *t
 	struct dm_crypt_io *io;
 	struct crypt_config *cc = ti->private;
 	unsigned max_sectors;
+	bool no_split;
 
 	/*
 	 * If bio is REQ_PREFLUSH or REQ_OP_DISCARD, just bypass crypt queues.
@@ -3513,10 +3507,20 @@ static int crypt_map(struct dm_target *t
 
 	/*
 	 * Check if bio is too large, split as needed.
-	 */
-	max_sectors = get_max_request_sectors(ti, bio);
-	if (unlikely(bio_sectors(bio) > max_sectors))
+	 *
+	 * For zoned devices, splitting write operations creates the
+	 * risk of deadlocking queue freeze operations with zone write
+	 * plugging BIO work when the reminder of a split BIO is
+	 * issued. So always allow the entire BIO to proceed.
+	 */
+	no_split = (ti->emulate_zone_append && op_is_write(bio_op(bio))) ||
+		   (bio->bi_opf & REQ_ATOMIC);
+	max_sectors = get_max_request_sectors(ti, bio, no_split);
+	if (unlikely(bio_sectors(bio) > max_sectors)) {
+		if (unlikely(no_split))
+			return DM_MAPIO_KILL;
 		dm_accept_partial_bio(bio, max_sectors);
+	}
 
 	/*
 	 * Ensure that bio is a multiple of internal sector encryption size
@@ -3762,6 +3766,11 @@ static void crypt_io_hints(struct dm_tar
 	if (ti->emulate_zone_append)
 		limits->max_hw_sectors = min(limits->max_hw_sectors,
 					     BIO_MAX_VECS << PAGE_SECTORS_SHIFT);
+
+	limits->atomic_write_hw_unit_max = min(limits->atomic_write_hw_unit_max,
+					       BIO_MAX_VECS << PAGE_SHIFT);
+	limits->atomic_write_hw_max = min(limits->atomic_write_hw_max,
+					  BIO_MAX_VECS << PAGE_SHIFT);
 }
 
 static struct target_type crypt_target = {
@@ -3770,7 +3779,7 @@ static struct target_type crypt_target =
 	.module = THIS_MODULE,
 	.ctr    = crypt_ctr,
 	.dtr    = crypt_dtr,
-	.features = DM_TARGET_ZONED_HM,
+	.features = DM_TARGET_ZONED_HM | DM_TARGET_ATOMIC_WRITES,
 	.report_zones = crypt_report_zones,
 	.map    = crypt_map,
 	.status = crypt_status,

