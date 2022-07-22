Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BBE7CC43334
	for <dm-devel@archiver.kernel.org>; Fri, 22 Jul 2022 18:27:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1658514431;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=lcwvCzKYLL37JUAX4l+95T0eY3G0T9PDsDO1Qj3oDOA=;
	b=UHJCSk16/NypPApJX9TfvTZ4IegcK403PMZmkJg4Kz4CamMArEpac3kpyvU+jdAnn/meHO
	H9tbVaw3zDWSKiSMK/RzdF434vnphFQvAdZ52jlHAqfHtWmDP0H8eQYn36M6VLacEMsJCn
	DAIV6xNi04KMbdTKCoZNtIEkabF0Fpo=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-131-lnkMNYYgNQ297_lc_UhHKg-1; Fri, 22 Jul 2022 14:27:08 -0400
X-MC-Unique: lnkMNYYgNQ297_lc_UhHKg-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 5FA25805F70;
	Fri, 22 Jul 2022 18:27:06 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 4CD422166B2B;
	Fri, 22 Jul 2022 18:27:06 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 738A51949763;
	Fri, 22 Jul 2022 18:27:05 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com
 [10.11.54.3])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 5BE1F1947049
 for <dm-devel@listman.corp.redhat.com>; Fri, 22 Jul 2022 09:38:52 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 3FAED1121315; Fri, 22 Jul 2022 09:38:52 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast04.extmail.prod.ext.rdu2.redhat.com [10.11.55.20])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 3C46E1121314
 for <dm-devel@redhat.com>; Fri, 22 Jul 2022 09:38:52 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [207.211.31.81])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 20E6B1035343
 for <dm-devel@redhat.com>; Fri, 22 Jul 2022 09:38:52 +0000 (UTC)
Received: from mail-yw1-f202.google.com (mail-yw1-f202.google.com
 [209.85.128.202]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-373-xlF2IDG4PVGx_yZmk9kqwQ-1; Fri, 22 Jul 2022 05:38:50 -0400
X-MC-Unique: xlF2IDG4PVGx_yZmk9kqwQ-1
Received: by mail-yw1-f202.google.com with SMTP id
 00721157ae682-31e5cc477dcso35549357b3.0
 for <dm-devel@redhat.com>; Fri, 22 Jul 2022 02:38:50 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=EdBwhDB1kTfOuaZ44XnXqAFiApYJfH6lT/hr3SDnJ/w=;
 b=SY926q76e8cXpUUgPr6pcR7HA+PpKY35q0XHIsu4HKwSi7cLoPP17zzJoRp87kvii4
 3wfzWR/ffFMTWjcc1GYPYo3si+yrJ0LKttML/JgKAphoxnx3H0l8lspE42+rZS6fE+pR
 VagADyL5a2Pjh75efJI3bSxFYU+fp/7wJnxSbbJbWCT4lzSE+oTs8Iae2w5pEFx7PppL
 EhIkACuDEY0ofZv2LzjOIVtU57QFf5w5TO147c/t4nNN131DBnM+5/kiuOfRpC3mAeXJ
 jqjm4rtkUK60gPTqpMpTRe6hYDnsvSV8dzudj4ifMRYfX49rW7a9BewEFLchixc7wKb5
 RIfQ==
X-Gm-Message-State: AJIora8UC7Oyo+vO/B/5CWzrKktH9jk2MmrrJDqepWfPRpHNAYbNhAJg
 9gD7r4VN+/52XIIY5/jjf1FjmlwY3g==
X-Google-Smtp-Source: AGRyM1v/0YsN7N1ZDNPpQQjFr5qD9ZaFHhp2KlBQW9DYS5Wzckg6JL2WrqE3KHHwbiqK6mFr34QSFCzL7g==
X-Received: from nhuck.c.googlers.com ([fda3:e722:ac3:cc00:14:4d90:c0a8:39cc])
 (user=nhuck job=sendgmr) by 2002:a25:71d7:0:b0:670:403b:a74f with
 SMTP id
 m206-20020a2571d7000000b00670403ba74fmr2198395ybc.239.1658482729838; Fri, 22
 Jul 2022 02:38:49 -0700 (PDT)
Date: Fri, 22 Jul 2022 09:38:21 +0000
In-Reply-To: <20220722093823.4158756-1-nhuck@google.com>
Message-Id: <20220722093823.4158756-2-nhuck@google.com>
Mime-Version: 1.0
References: <20220722093823.4158756-1-nhuck@google.com>
From: Nathan Huckleberry <nhuck@google.com>
To: linux-kernel@vger.kernel.org, dm-devel@redhat.com, 
 Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@kernel.org>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.3
X-Mailman-Approved-At: Fri, 22 Jul 2022 18:27:03 +0000
Subject: [dm-devel] [PATCH 1/3] dm-bufio: Add flags for
 dm_bufio_client_create
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
Cc: Eric Biggers <ebiggers@kernel.org>, Sami Tolvanen <samitolvanen@google.com>,
 Nathan Huckleberry <nhuck@google.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.6
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Add a flags argument to dm_bufio_client_create and update all the
callers.  This is in preparation to add the DM_BUFIO_GET_CANT_SLEEP
flag.

Signed-off-by: Nathan Huckleberry <nhuck@google.com>
---
 drivers/md/dm-bufio.c                         | 3 ++-
 drivers/md/dm-ebs-target.c                    | 3 ++-
 drivers/md/dm-integrity.c                     | 2 +-
 drivers/md/dm-snap-persistent.c               | 2 +-
 drivers/md/dm-verity-fec.c                    | 4 ++--
 drivers/md/dm-verity-target.c                 | 2 +-
 drivers/md/persistent-data/dm-block-manager.c | 3 ++-
 include/linux/dm-bufio.h                      | 3 ++-
 8 files changed, 13 insertions(+), 9 deletions(-)

diff --git a/drivers/md/dm-bufio.c b/drivers/md/dm-bufio.c
index 5ffa1dcf84cf..ad5603eb12e3 100644
--- a/drivers/md/dm-bufio.c
+++ b/drivers/md/dm-bufio.c
@@ -1717,7 +1717,8 @@ static unsigned long dm_bufio_shrink_count(struct shrinker *shrink, struct shrin
 struct dm_bufio_client *dm_bufio_client_create(struct block_device *bdev, unsigned block_size,
 					       unsigned reserved_buffers, unsigned aux_size,
 					       void (*alloc_callback)(struct dm_buffer *),
-					       void (*write_callback)(struct dm_buffer *))
+					       void (*write_callback)(struct dm_buffer *),
+					       unsigned int flags)
 {
 	int r;
 	struct dm_bufio_client *c;
diff --git a/drivers/md/dm-ebs-target.c b/drivers/md/dm-ebs-target.c
index 0221fa63f888..c90f9b9b1f02 100644
--- a/drivers/md/dm-ebs-target.c
+++ b/drivers/md/dm-ebs-target.c
@@ -312,7 +312,8 @@ static int ebs_ctr(struct dm_target *ti, unsigned int argc, char **argv)
 		goto bad;
 	}
 
-	ec->bufio = dm_bufio_client_create(ec->dev->bdev, to_bytes(ec->u_bs), 1, 0, NULL, NULL);
+	ec->bufio = dm_bufio_client_create(ec->dev->bdev, to_bytes(ec->u_bs), 1,
+		0, NULL, NULL, 0);
 	if (IS_ERR(ec->bufio)) {
 		ti->error = "Cannot create dm bufio client";
 		r = PTR_ERR(ec->bufio);
diff --git a/drivers/md/dm-integrity.c b/drivers/md/dm-integrity.c
index 3d5a0ce123c9..a508073d8414 100644
--- a/drivers/md/dm-integrity.c
+++ b/drivers/md/dm-integrity.c
@@ -4439,7 +4439,7 @@ static int dm_integrity_ctr(struct dm_target *ti, unsigned argc, char **argv)
 	}
 
 	ic->bufio = dm_bufio_client_create(ic->meta_dev ? ic->meta_dev->bdev : ic->dev->bdev,
-			1U << (SECTOR_SHIFT + ic->log2_buffer_sectors), 1, 0, NULL, NULL);
+			1U << (SECTOR_SHIFT + ic->log2_buffer_sectors), 1, 0, NULL, NULL, 0);
 	if (IS_ERR(ic->bufio)) {
 		r = PTR_ERR(ic->bufio);
 		ti->error = "Cannot initialize dm-bufio";
diff --git a/drivers/md/dm-snap-persistent.c b/drivers/md/dm-snap-persistent.c
index 3bb5cff5d6fc..aaa699749c3b 100644
--- a/drivers/md/dm-snap-persistent.c
+++ b/drivers/md/dm-snap-persistent.c
@@ -494,7 +494,7 @@ static int read_exceptions(struct pstore *ps,
 
 	client = dm_bufio_client_create(dm_snap_cow(ps->store->snap)->bdev,
 					ps->store->chunk_size << SECTOR_SHIFT,
-					1, 0, NULL, NULL);
+					1, 0, NULL, NULL, 0);
 
 	if (IS_ERR(client))
 		return PTR_ERR(client);
diff --git a/drivers/md/dm-verity-fec.c b/drivers/md/dm-verity-fec.c
index cea2b3789736..23cffce56403 100644
--- a/drivers/md/dm-verity-fec.c
+++ b/drivers/md/dm-verity-fec.c
@@ -749,7 +749,7 @@ int verity_fec_ctr(struct dm_verity *v)
 
 	f->bufio = dm_bufio_client_create(f->dev->bdev,
 					  f->io_size,
-					  1, 0, NULL, NULL);
+					  1, 0, NULL, NULL, 0);
 	if (IS_ERR(f->bufio)) {
 		ti->error = "Cannot initialize FEC bufio client";
 		return PTR_ERR(f->bufio);
@@ -765,7 +765,7 @@ int verity_fec_ctr(struct dm_verity *v)
 
 	f->data_bufio = dm_bufio_client_create(v->data_dev->bdev,
 					       1 << v->data_dev_block_bits,
-					       1, 0, NULL, NULL);
+					       1, 0, NULL, NULL, 0);
 	if (IS_ERR(f->data_bufio)) {
 		ti->error = "Cannot initialize FEC data bufio client";
 		return PTR_ERR(f->data_bufio);
diff --git a/drivers/md/dm-verity-target.c b/drivers/md/dm-verity-target.c
index d6dbd47492a8..5d3fc58a3c34 100644
--- a/drivers/md/dm-verity-target.c
+++ b/drivers/md/dm-verity-target.c
@@ -1266,7 +1266,7 @@ static int verity_ctr(struct dm_target *ti, unsigned argc, char **argv)
 
 	v->bufio = dm_bufio_client_create(v->hash_dev->bdev,
 		1 << v->hash_dev_block_bits, 1, sizeof(struct buffer_aux),
-		dm_bufio_alloc_callback, NULL);
+		dm_bufio_alloc_callback, NULL, 0);
 	if (IS_ERR(v->bufio)) {
 		ti->error = "Cannot initialize dm-bufio";
 		r = PTR_ERR(v->bufio);
diff --git a/drivers/md/persistent-data/dm-block-manager.c b/drivers/md/persistent-data/dm-block-manager.c
index 54c089a50b15..11935864f50f 100644
--- a/drivers/md/persistent-data/dm-block-manager.c
+++ b/drivers/md/persistent-data/dm-block-manager.c
@@ -391,7 +391,8 @@ struct dm_block_manager *dm_block_manager_create(struct block_device *bdev,
 	bm->bufio = dm_bufio_client_create(bdev, block_size, max_held_per_thread,
 					   sizeof(struct buffer_aux),
 					   dm_block_manager_alloc_callback,
-					   dm_block_manager_write_callback);
+					   dm_block_manager_write_callback,
+					   0);
 	if (IS_ERR(bm->bufio)) {
 		r = PTR_ERR(bm->bufio);
 		kfree(bm);
diff --git a/include/linux/dm-bufio.h b/include/linux/dm-bufio.h
index 90bd558a17f5..e21480715255 100644
--- a/include/linux/dm-bufio.h
+++ b/include/linux/dm-bufio.h
@@ -24,7 +24,8 @@ struct dm_bufio_client *
 dm_bufio_client_create(struct block_device *bdev, unsigned block_size,
 		       unsigned reserved_buffers, unsigned aux_size,
 		       void (*alloc_callback)(struct dm_buffer *),
-		       void (*write_callback)(struct dm_buffer *));
+		       void (*write_callback)(struct dm_buffer *),
+		       unsigned int flags);
 
 /*
  * Release a buffered IO cache.
-- 
2.37.1.359.gd136c6c3e2-goog

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

