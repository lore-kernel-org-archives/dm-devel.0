Return-Path: <SRS0=2hlQ=FB=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7C0ADC3E8C5
	for <dm-devel@archiver.kernel.org>; Fri, 27 Nov 2020 17:54:28 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [63.128.21.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id DC4802224C
	for <dm-devel@archiver.kernel.org>; Fri, 27 Nov 2020 17:54:27 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="iNiGY8KD"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org DC4802224C
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1606499666;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=w5jr5E2BF2yp9i0wsjHODQ+Pj9e+502DnLHv5SFihP4=;
	b=iNiGY8KDjD3U5vk6go/4qzhQyncwfoMVa5E1mpWozvIwalE80UdDOxuf87vYfK07dptc/x
	kpx11aWD7rBkg6Ks/btjlrGbTGk3kMCaCwAhQcf3NsUT6+GqwD1Qk2sxd45u8DEUZZXFyP
	h2pCgIaeLnfJc4XFghTpswMJQnmykHA=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-482-Hz7FWu6hOy6tGKkZ7YTwbA-1; Fri, 27 Nov 2020 12:54:24 -0500
X-MC-Unique: Hz7FWu6hOy6tGKkZ7YTwbA-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 208EE107ACF9;
	Fri, 27 Nov 2020 17:54:20 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id DD8A819C46;
	Fri, 27 Nov 2020 17:54:19 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 48FEE4EBC6;
	Fri, 27 Nov 2020 17:54:19 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com
	[10.5.11.16])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 0ARHsHaX017643 for <dm-devel@listman.util.phx.redhat.com>;
	Fri, 27 Nov 2020 12:54:17 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id DA46D5C1D1; Fri, 27 Nov 2020 17:54:17 +0000 (UTC)
Received: from file01.intranet.prod.int.rdu2.redhat.com
	(file01.intranet.prod.int.rdu2.redhat.com [10.11.5.7])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 6DB185C1C2;
	Fri, 27 Nov 2020 17:54:14 +0000 (UTC)
Received: from file01.intranet.prod.int.rdu2.redhat.com (localhost [127.0.0.1])
	by file01.intranet.prod.int.rdu2.redhat.com (8.14.4/8.14.4) with ESMTP
	id 0ARHsEOc001633; Fri, 27 Nov 2020 12:54:14 -0500
Received: from localhost (mpatocka@localhost)
	by file01.intranet.prod.int.rdu2.redhat.com (8.14.4/8.14.4/Submit) with
	ESMTP id 0ARHsDeJ001629; Fri, 27 Nov 2020 12:54:14 -0500
X-Authentication-Warning: file01.intranet.prod.int.rdu2.redhat.com: mpatocka
	owned process doing -bs
Date: Fri, 27 Nov 2020 12:54:13 -0500 (EST)
From: Mikulas Patocka <mpatocka@redhat.com>
X-X-Sender: mpatocka@file01.intranet.prod.int.rdu2.redhat.com
To: Mike Snitzer <msnitzer@redhat.com>, Milan Broz <mbroz@redhat.com>,
	Alasdair Kergon <agk@redhat.com>
In-Reply-To: <alpine.LRH.2.02.2011261003400.11630@file01.intranet.prod.int.rdu2.redhat.com>
Message-ID: <alpine.LRH.2.02.2011271240290.31117@file01.intranet.prod.int.rdu2.redhat.com>
References: <alpine.LRH.2.02.2011261003400.11630@file01.intranet.prod.int.rdu2.redhat.com>
User-Agent: Alpine 2.02 (LRH 1266 2009-07-14)
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
X-loop: dm-devel@redhat.com
Cc: Ondrej Kozina <okozina@redhat.com>, dm-devel@redhat.com
Subject: [dm-devel] [PATCH v2] dm-crypt: fix deadlock when swapping to
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
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Hi

This is second version of the dm-crypt swapping patch.

Changes since the first version:
- we only count write bios
- when the user changes 
  /sys/module/dm_crypt/parameters/max_bios_in_flight, the change is 
  instantly applied to all dm-crypt instances
- do not lock up if the user sets max_bios_in_flight to zero

I was considering making the default value some fraction of memory, but it 
didn't work - i.e. for eaxmple, if we have 8GB machine and 256MB or more 
dm-crypt memory, it doesn't work (it doesn't deadlock, but it slows down 
the machine very much, to the point that it's unuseable). With smaller 
dm-crypt memory, it is more responsive.

Mikulas


From: Mikulas Patocka <mpatocka@redhat.com>

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
@@ -214,16 +214,24 @@ struct crypt_config {
 	mempool_t page_pool;
 
 	struct bio_set bs;
+
+	int bio_limit;
+	struct semaphore bio_limit_semaphore;
+	struct mutex bio_limit_lock;
+
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
@@ -1713,6 +1721,8 @@ static void crypt_dec_pending(struct dm_
 		kfree(io->integrity_metadata);
 
 	base_bio->bi_status = error;
+	if (bio_data_dir(base_bio) == WRITE)
+		up(&cc->bio_limit_semaphore);
 	bio_endio(base_bio);
 }
 
@@ -2567,6 +2577,7 @@ static void crypt_dtr(struct dm_target *
 	kfree_sensitive(cc->cipher_auth);
 	kfree_sensitive(cc->authenc_key);
 
+	mutex_destroy(&cc->bio_limit_lock);
 	mutex_destroy(&cc->bio_alloc_lock);
 
 	/* Must zero key material before freeing */
@@ -3007,6 +3018,7 @@ static int crypt_ctr(struct dm_target *t
 	int key_size;
 	unsigned int align_mask;
 	unsigned long long tmpll;
+	int latch;
 	int ret;
 	size_t iv_size_padding, additional_req_size;
 	char dummy;
@@ -3106,6 +3118,12 @@ static int crypt_ctr(struct dm_target *t
 		goto bad;
 	}
 
+	latch = READ_ONCE(bio_limit);
+	if (unlikely(latch <= 0))
+		latch = MAX_BIOS;
+	cc->bio_limit = latch;
+	sema_init(&cc->bio_limit_semaphore, latch);
+	mutex_init(&cc->bio_limit_lock);
 	mutex_init(&cc->bio_alloc_lock);
 
 	ret = -EINVAL;
@@ -3234,6 +3252,25 @@ static int crypt_map(struct dm_target *t
 	if (unlikely(bio->bi_iter.bi_size & (cc->sector_size - 1)))
 		return DM_MAPIO_KILL;
 
+	if (bio_data_dir(bio) == WRITE) {
+		int latch = READ_ONCE(bio_limit);
+		if (unlikely(latch <= 0))
+			latch = MAX_BIOS;
+		if (unlikely(cc->bio_limit != latch)) {
+			mutex_lock(&cc->bio_limit_lock);
+			while (latch < cc->bio_limit) {
+				down(&cc->bio_limit_semaphore);
+				cc->bio_limit--;
+			}
+			while (latch > cc->bio_limit) {
+				up(&cc->bio_limit_semaphore);
+				cc->bio_limit++;
+			}
+			mutex_unlock(&cc->bio_limit_lock);
+		}
+		down(&cc->bio_limit_semaphore);
+	}
+
 	io = dm_per_bio_data(bio, cc->per_bio_data_size);
 	crypt_io_init(io, cc, bio, dm_target_offset(ti, bio->bi_iter.bi_sector));
 
@@ -3461,6 +3498,9 @@ static void __exit dm_crypt_exit(void)
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

