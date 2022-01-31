Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2D2B9C433EF
	for <dm-devel@archiver.kernel.org>; Mon, 31 Jan 2022 18:50:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1643655022;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=OAwyPFYsSXnvh6UGxha6h8EG4fzjqPnGF3d9WenRgYM=;
	b=GGtcAjm07zzFuJs6YJEc7XkZP/H5SCoTk0We2mUF5ifriTY+2wRsmDLdBK32QTwlojS1Ae
	iLeUMvDbLrrJHnSc8lLsg52TKo9bSRK4YpXws6ipNpiuX5MuUaI/DHk4EIIDHox/cAW5F0
	Wfu+I2kBgn6AdHIBF8AttvrvFvQ0sIg=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-93-12jZtIHqOUqymhTVapVgdQ-1; Mon, 31 Jan 2022 13:50:18 -0500
X-MC-Unique: 12jZtIHqOUqymhTVapVgdQ-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 76E5418982BE;
	Mon, 31 Jan 2022 18:50:10 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 1BE2F781B0;
	Mon, 31 Jan 2022 18:50:07 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id A2BA04BB7C;
	Mon, 31 Jan 2022 18:50:03 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com
	[10.5.11.15])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 20VIo1NZ022706 for <dm-devel@listman.util.phx.redhat.com>;
	Mon, 31 Jan 2022 13:50:01 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id AE84C77457; Mon, 31 Jan 2022 18:50:01 +0000 (UTC)
Received: from file01.intranet.prod.int.rdu2.redhat.com
	(file01.intranet.prod.int.rdu2.redhat.com [10.11.5.7])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 83F1D74EBE;
	Mon, 31 Jan 2022 18:49:49 +0000 (UTC)
Received: from file01.intranet.prod.int.rdu2.redhat.com (localhost [127.0.0.1])
	by file01.intranet.prod.int.rdu2.redhat.com (8.14.4/8.14.4) with ESMTP
	id 20VInm13032595; Mon, 31 Jan 2022 13:49:48 -0500
Received: from localhost (mpatocka@localhost)
	by file01.intranet.prod.int.rdu2.redhat.com (8.14.4/8.14.4/Submit) with
	ESMTP id 20VInmpt032591; Mon, 31 Jan 2022 13:49:48 -0500
X-Authentication-Warning: file01.intranet.prod.int.rdu2.redhat.com: mpatocka
	owned process doing -bs
Date: Mon, 31 Jan 2022 13:49:48 -0500 (EST)
From: Mikulas Patocka <mpatocka@redhat.com>
X-X-Sender: mpatocka@file01.intranet.prod.int.rdu2.redhat.com
To: Mike Snitzer <msnitzer@redhat.com>
Message-ID: <alpine.LRH.2.02.2201311346140.32171@file01.intranet.prod.int.rdu2.redhat.com>
User-Agent: Alpine 2.02 (LRH 1266 2009-07-14)
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
X-loop: dm-devel@redhat.com
Cc: dm-devel@redhat.com
Subject: [dm-devel] [PATCH] dm-crypt: introduce a module parameter that
 makes it possible to limit all bios
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

The patch a666e5c05e7c4aaabb2c5d58117b0946803d03d2 ("dm: fix deadlock when
swapping to encrypted device") limits the number of in-flight swap bios
for the dm-crypt target. It avoids a deadlock when swapping to a dm-crypt
device.

The limit is not applied to non-swap workload because it uses shared
variables that cause cache line bouncing.

In some situations it may be desired to apply the limit on all bios, this
patch adds the file "/sys/module/dm_crypt/parameters/limit_all_bios" that
enables it. It must be enabled prior to creating a dm-crypt device.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>

---
 drivers/md/dm-crypt.c         |    6 +++++-
 drivers/md/dm.c               |    6 +++++-
 include/linux/device-mapper.h |    6 ++++--
 3 files changed, 14 insertions(+), 4 deletions(-)

Index: linux-2.6/include/linux/device-mapper.h
===================================================================
--- linux-2.6.orig/include/linux/device-mapper.h	2022-01-24 15:10:45.000000000 +0100
+++ linux-2.6/include/linux/device-mapper.h	2022-01-31 19:19:33.000000000 +0100
@@ -353,9 +353,11 @@ struct dm_target {
 	bool discards_supported:1;
 
 	/*
-	 * Set if we need to limit the number of in-flight bios when swapping.
+	 * 0 - don't limit the number of bios
+	 * 1 - limit only swap bios
+	 * 2 - limit all bios
 	 */
-	bool limit_swap_bios:1;
+	unsigned char limit_swap_bios:2;
 
 	/*
 	 * Set if this target implements a a zoned device and needs emulation of
Index: linux-2.6/drivers/md/dm-crypt.c
===================================================================
--- linux-2.6.orig/drivers/md/dm-crypt.c	2022-01-06 18:54:58.000000000 +0100
+++ linux-2.6/drivers/md/dm-crypt.c	2022-01-31 19:17:58.000000000 +0100
@@ -241,6 +241,10 @@ static struct scatterlist *crypt_get_sg_
 
 static bool crypt_integrity_aead(struct crypt_config *cc);
 
+static bool limit_all_bios = false;
+module_param(limit_all_bios, bool, 0644);
+MODULE_PARM_DESC(limit_all_bios, "True if you want to limit all bios; false if you want to limit only swap bios");
+
 /*
  * Use this to access cipher attributes that are independent of the key.
  */
@@ -3372,7 +3376,7 @@ static int crypt_ctr(struct dm_target *t
 	}
 
 	ti->num_flush_bios = 1;
-	ti->limit_swap_bios = true;
+	ti->limit_swap_bios = limit_all_bios ? 2 : 1;
 
 	dm_audit_log_ctr(DM_MSG_PREFIX, ti, 1);
 	return 0;
Index: linux-2.6/drivers/md/dm.c
===================================================================
--- linux-2.6.orig/drivers/md/dm.c	2022-01-24 15:10:42.000000000 +0100
+++ linux-2.6/drivers/md/dm.c	2022-01-31 19:20:29.000000000 +0100
@@ -873,7 +873,11 @@ void disable_write_zeroes(struct mapped_
 
 static bool swap_bios_limit(struct dm_target *ti, struct bio *bio)
 {
-	return unlikely((bio->bi_opf & REQ_SWAP) != 0) && unlikely(ti->limit_swap_bios);
+	if (likely(!ti->limit_swap_bios))
+		return false;
+	if (likely(ti->limit_swap_bios == 1))
+		return unlikely((bio->bi_opf & REQ_SWAP) != 0);
+	return true;
 }
 
 static void clone_endio(struct bio *bio)

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

