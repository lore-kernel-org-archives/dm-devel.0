Return-Path: <SRS0=cgFg=FA=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F347AC56202
	for <dm-devel@archiver.kernel.org>; Thu, 26 Nov 2020 15:13:58 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 2C15B20B80
	for <dm-devel@archiver.kernel.org>; Thu, 26 Nov 2020 15:13:57 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="BFX5x3Pz"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 2C15B20B80
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1606403636;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=PrbZWybszYphLv/NxZBXdw1JYYsyGllpjbRYtGgpl+8=;
	b=BFX5x3PzWA1q/yBuui0XVkfVCwl9Pp3HuVq5gHhWpvBZPXLGlrzUkIiHixud24DzPrPmOw
	OWHSQ7ZtbNM0cWHvSq28dtCu5GMOnOmHHYtUg8tak8PV6GTquv2M0tnTIu1waVW8k5x5Cd
	QqrB9+MrqwHGUlmXFBJ0EkkKZOBRooE=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-515-kovUhVAvMRCh5mnaHDRW9w-1; Thu, 26 Nov 2020 10:13:54 -0500
X-MC-Unique: kovUhVAvMRCh5mnaHDRW9w-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 94DD3814414;
	Thu, 26 Nov 2020 15:13:49 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 1E4FF5C1BD;
	Thu, 26 Nov 2020 15:13:48 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 70FF85002C;
	Thu, 26 Nov 2020 15:13:46 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com
	[10.5.11.16])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 0AQFDisR016453 for <dm-devel@listman.util.phx.redhat.com>;
	Thu, 26 Nov 2020 10:13:44 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id CF48C5C1CF; Thu, 26 Nov 2020 15:13:44 +0000 (UTC)
Received: from file01.intranet.prod.int.rdu2.redhat.com
	(file01.intranet.prod.int.rdu2.redhat.com [10.11.5.7])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 5D4285C1C5;
	Thu, 26 Nov 2020 15:13:40 +0000 (UTC)
Received: from file01.intranet.prod.int.rdu2.redhat.com (localhost [127.0.0.1])
	by file01.intranet.prod.int.rdu2.redhat.com (8.14.4/8.14.4) with ESMTP
	id 0AQFDdTp012091; Thu, 26 Nov 2020 10:13:39 -0500
Received: from localhost (mpatocka@localhost)
	by file01.intranet.prod.int.rdu2.redhat.com (8.14.4/8.14.4/Submit) with
	ESMTP id 0AQFDdgH012087; Thu, 26 Nov 2020 10:13:39 -0500
X-Authentication-Warning: file01.intranet.prod.int.rdu2.redhat.com: mpatocka
	owned process doing -bs
Date: Thu, 26 Nov 2020 10:13:39 -0500 (EST)
From: Mikulas Patocka <mpatocka@redhat.com>
X-X-Sender: mpatocka@file01.intranet.prod.int.rdu2.redhat.com
To: Mike Snitzer <msnitzer@redhat.com>, Milan Broz <mbroz@redhat.com>
Message-ID: <alpine.LRH.2.02.2011261003400.11630@file01.intranet.prod.int.rdu2.redhat.com>
User-Agent: Alpine 2.02 (LRH 1266 2009-07-14)
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
X-loop: dm-devel@redhat.com
Cc: Ondrej Kozina <okozina@redhat.com>, dm-devel@redhat.com
Subject: [dm-devel] [PATCH] dm-crypt: fix deadlock when swapping to
	encrypted device
X-BeenThere: dm-devel@redhat.com
X-Mailman-Version: 2.1.12
Precedence: junk
List-Id: device-mapper development <dm-devel.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

The system would deadlock when swapping to a dm-crypt device. The reason
is that for each incoming write bio, dm-crypt allocates memory that holds
encrypted data. These excessive allocations exhaust all the memory and the
result is either deadlock or OOM trigger.

This patch limits the number of in-flight bios, so that the memory
consumed by dm-crypt is limited. If we are over the limit, we block in the
function crypt_map, so that the caller will not attempt to send more bios.

This is similar to request-based drivers - they will also block when the
number of bios is over the limit.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Cc: stable@vger.kernel.org

Index: linux-2.6/drivers/md/dm-crypt.c
===================================================================
--- linux-2.6.orig/drivers/md/dm-crypt.c
+++ linux-2.6/drivers/md/dm-crypt.c
@@ -214,16 +214,21 @@ struct crypt_config {
 	mempool_t page_pool;
 
 	struct bio_set bs;
+
+	struct semaphore bio_limit;
 	struct mutex bio_alloc_lock;
 
 	u8 *authenc_key; /* space for keys in authenc() format (if used) */
 	u8 key[];
 };
 
+#define MAX_BIOS	4096
 #define MIN_IOS		64
 #define MAX_TAG_SIZE	480
 #define POOL_ENTRY_SIZE	512
 
+static int bio_limit = MAX_BIOS;
+
 static DEFINE_SPINLOCK(dm_crypt_clients_lock);
 static unsigned dm_crypt_clients_n = 0;
 static volatile unsigned long dm_crypt_pages_per_client;
@@ -1713,6 +1718,7 @@ static void crypt_dec_pending(struct dm_
 		kfree(io->integrity_metadata);
 
 	base_bio->bi_status = error;
+	up(&cc->bio_limit);
 	bio_endio(base_bio);
 }
 
@@ -3106,6 +3112,7 @@ static int crypt_ctr(struct dm_target *t
 		goto bad;
 	}
 
+	sema_init(&cc->bio_limit, bio_limit);
 	mutex_init(&cc->bio_alloc_lock);
 
 	ret = -EINVAL;
@@ -3234,6 +3241,8 @@ static int crypt_map(struct dm_target *t
 	if (unlikely(bio->bi_iter.bi_size & (cc->sector_size - 1)))
 		return DM_MAPIO_KILL;
 
+	down(&cc->bio_limit);
+
 	io = dm_per_bio_data(bio, cc->per_bio_data_size);
 	crypt_io_init(io, cc, bio, dm_target_offset(ti, bio->bi_iter.bi_sector));
 
@@ -3461,6 +3470,9 @@ static void __exit dm_crypt_exit(void)
 module_init(dm_crypt_init);
 module_exit(dm_crypt_exit);
 
+module_param_named(max_bios_in_flight, bio_limit, int, S_IRUGO | S_IWUSR);
+MODULE_PARM_DESC(max_bios_in_flight, "maximum number of bios in flight");
+
 MODULE_AUTHOR("Jana Saout <jana@saout.de>");
 MODULE_DESCRIPTION(DM_NAME " target for transparent encryption / decryption");
 MODULE_LICENSE("GPL");

--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel

