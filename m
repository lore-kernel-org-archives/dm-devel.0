Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DFD95C6FD1A
	for <dm-devel@archiver.kernel.org>; Tue,  7 Mar 2023 17:32:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1678210365;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=bfj1Ct//OXbY0NGPX8PrOejdsWsgULkGOm5E5I/pDpw=;
	b=J+HcpFDSMetgHApIw0luZVNmuPvzRnVEGQDhfsOxuR41TmubhAJiQrhArXddKx0l2jhXdt
	Bcmi1uDFpPhxa37m1t6Sm0D039lr8ChM4N4oRBeR28Y3mJ8EbnqSr3CylSbFLHzN2jHvpb
	3r9GIx3pbGo2sYWno4BpDRKM500mUKY=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-31-2InhZc26O0qhO8SUchXWow-1; Tue, 07 Mar 2023 12:32:42 -0500
X-MC-Unique: 2InhZc26O0qhO8SUchXWow-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 3D5052810C10;
	Tue,  7 Mar 2023 17:32:40 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 77F2C2026D4B;
	Tue,  7 Mar 2023 17:32:38 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 4B13E19465A3;
	Tue,  7 Mar 2023 17:32:38 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com
 [10.11.54.8])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 63F721946594
 for <dm-devel@listman.corp.redhat.com>; Tue,  7 Mar 2023 17:32:37 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 33808C16020; Tue,  7 Mar 2023 17:32:37 +0000 (UTC)
Received: from file01.intranet.prod.int.rdu2.redhat.com
 (file01.intranet.prod.int.rdu2.redhat.com [10.11.5.7])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 24C5BC15BA0;
 Tue,  7 Mar 2023 17:32:37 +0000 (UTC)
Received: from file01.intranet.prod.int.rdu2.redhat.com (localhost [127.0.0.1])
 by file01.intranet.prod.int.rdu2.redhat.com (8.14.4/8.14.4) with ESMTP id
 327HWbHT016451; Tue, 7 Mar 2023 12:32:37 -0500
Received: from localhost (mpatocka@localhost)
 by file01.intranet.prod.int.rdu2.redhat.com (8.14.4/8.14.4/Submit) with ESMTP
 id 327HWbg9016447; Tue, 7 Mar 2023 12:32:37 -0500
X-Authentication-Warning: file01.intranet.prod.int.rdu2.redhat.com: mpatocka
 owned process doing -bs
Date: Tue, 7 Mar 2023 12:32:37 -0500 (EST)
From: Mikulas Patocka <mpatocka@redhat.com>
X-X-Sender: mpatocka@file01.intranet.prod.int.rdu2.redhat.com
To: Mike Snitzer <snitzer@kernel.org>, Milan Broz <gmazyland@gmail.com>,
 Zdenek Kabelac <zkabelac@redhat.com>
In-Reply-To: <alpine.LRH.2.21.2303061407210.5778@file01.intranet.prod.int.rdu2.redhat.com>
Message-ID: <alpine.LRH.2.21.2303071203060.15370@file01.intranet.prod.int.rdu2.redhat.com>
References: <alpine.LRH.2.21.2303061407210.5778@file01.intranet.prod.int.rdu2.redhat.com>
User-Agent: Alpine 2.21 (LRH 202 2017-01-01)
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.8
Subject: [dm-devel] [PATCH v2] dm-zero, dm-error: support discards
X-BeenThere: dm-devel@redhat.com
X-Mailman-Version: 2.1.29
Precedence: list
List-Id: device-mapper development <dm-devel.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/dm-devel>,
 <mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <http://listman.redhat.com/archives/dm-devel/>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/dm-devel>,
 <mailto:dm-devel-request@redhat.com?subject=subscribe>
Cc: dm-devel@redhat.com
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.4
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

dm-zero, dm-error: support discards

This patch adds discard support to dm-zero and dm-error. dm-zero ignores
the discards, dm-error return -EIO. It is useful when the user combines
dm-zero or dm-error with other discard-supporting targets in the same
table; without dm-zero or dm-error support, discards would be disabled for
the whole combined device.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>

---
 drivers/md/dm-table.c  |    6 +++++-
 drivers/md/dm-target.c |   11 ++++++++++-
 drivers/md/dm-zero.c   |   12 +++++++++++-
 3 files changed, 26 insertions(+), 3 deletions(-)

Index: linux-2.6/drivers/md/dm-zero.c
===================================================================
--- linux-2.6.orig/drivers/md/dm-zero.c
+++ linux-2.6/drivers/md/dm-zero.c
@@ -27,6 +27,7 @@ static int zero_ctr(struct dm_target *ti
 	 * Silently drop discards, avoiding -EOPNOTSUPP.
 	 */
 	ti->num_discard_bios = 1;
+	ti->discards_supported = true;
 
 	return 0;
 }
@@ -45,6 +46,7 @@ static int zero_map(struct dm_target *ti
 		zero_fill_bio(bio);
 		break;
 	case REQ_OP_WRITE:
+	case REQ_OP_DISCARD:
 		/* writes get silently dropped */
 		break;
 	default:
@@ -57,13 +59,21 @@ static int zero_map(struct dm_target *ti
 	return DM_MAPIO_SUBMITTED;
 }
 
+static void zero_io_hints(struct dm_target *ti, struct queue_limits *limits)
+{
+	limits->max_discard_sectors = UINT_MAX;
+	limits->max_hw_discard_sectors = UINT_MAX;
+	limits->discard_granularity = 512;
+}
+
 static struct target_type zero_target = {
 	.name   = "zero",
-	.version = {1, 1, 0},
+	.version = {1, 2, 0},
 	.features = DM_TARGET_NOWAIT,
 	.module = THIS_MODULE,
 	.ctr    = zero_ctr,
 	.map    = zero_map,
+	.io_hints = zero_io_hints,
 };
 
 static int __init dm_zero_init(void)
Index: linux-2.6/drivers/md/dm-table.c
===================================================================
--- linux-2.6.orig/drivers/md/dm-table.c
+++ linux-2.6/drivers/md/dm-table.c
@@ -1670,8 +1670,12 @@ int dm_calculate_queue_limits(struct dm_
 
 		blk_set_stacking_limits(&ti_limits);
 
-		if (!ti->type->iterate_devices)
+		if (!ti->type->iterate_devices) {
+			/* Set I/O hints portion of queue limits */
+			if (ti->type->io_hints)
+				ti->type->io_hints(ti, &ti_limits);
 			goto combine_limits;
+		}
 
 		/*
 		 * Combine queue limits of all the devices this target uses.
Index: linux-2.6/drivers/md/dm-target.c
===================================================================
--- linux-2.6.orig/drivers/md/dm-target.c
+++ linux-2.6/drivers/md/dm-target.c
@@ -119,6 +119,7 @@ static int io_err_ctr(struct dm_target *
 	 * Return error for discards instead of -EOPNOTSUPP
 	 */
 	tt->num_discard_bios = 1;
+	tt->discards_supported = true;
 
 	return 0;
 }
@@ -145,6 +146,13 @@ static void io_err_release_clone_rq(stru
 {
 }
 
+static void io_err_io_hints(struct dm_target *ti, struct queue_limits *limits)
+{
+	limits->max_discard_sectors = UINT_MAX;
+	limits->max_hw_discard_sectors = UINT_MAX;
+	limits->discard_granularity = 512;
+}
+
 static long io_err_dax_direct_access(struct dm_target *ti, pgoff_t pgoff,
 		long nr_pages, enum dax_access_mode mode, void **kaddr,
 		pfn_t *pfn)
@@ -154,13 +162,14 @@ static long io_err_dax_direct_access(str
 
 static struct target_type error_target = {
 	.name = "error",
-	.version = {1, 5, 0},
+	.version = {1, 6, 0},
 	.features = DM_TARGET_WILDCARD,
 	.ctr  = io_err_ctr,
 	.dtr  = io_err_dtr,
 	.map  = io_err_map,
 	.clone_and_map_rq = io_err_clone_and_map_rq,
 	.release_clone_rq = io_err_release_clone_rq,
+	.io_hints = io_err_io_hints,
 	.direct_access = io_err_dax_direct_access,
 };
 
--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

