Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E573AC433F5
	for <dm-devel@archiver.kernel.org>; Fri, 11 Feb 2022 21:47:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1644616024;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=ObtuxbtqEPBaFAzuCU7SCxRMzvia7/lnhb+IHjVHqNg=;
	b=IDncrl4/Ys+PiVWXZyZlSRodtLp5c2lQHyQhxmq2SjUH+p9/hA0Kf6vd/WHkbUi0ZOj5Xk
	EvegymGNlPN/0xg3rdlnq6kQpX9nw8cJRS7nis0475yS3IT2jxrqhnSkdW8HUzXN99psG8
	Dsr3D618vChUM5cqzAzJF+arzJdwVTk=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-648-fWXWtgtyN_GM10slYb0LMw-1; Fri, 11 Feb 2022 16:46:18 -0500
X-MC-Unique: fWXWtgtyN_GM10slYb0LMw-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 5713894DDC;
	Fri, 11 Feb 2022 21:46:11 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 38FF956F82;
	Fri, 11 Feb 2022 21:46:11 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 121674BB7C;
	Fri, 11 Feb 2022 21:46:11 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com
	[10.11.54.2])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 21BLflhH024841 for <dm-devel@listman.util.phx.redhat.com>;
	Fri, 11 Feb 2022 16:41:47 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 02EBD40E80EA; Fri, 11 Feb 2022 21:41:46 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast05.extmail.prod.ext.rdu2.redhat.com [10.11.55.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id F2E7240E80E4
	for <dm-devel@redhat.com>; Fri, 11 Feb 2022 21:41:45 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [207.211.31.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
	bits)) (No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 6985F831558
	for <dm-devel@redhat.com>; Fri, 11 Feb 2022 21:41:40 +0000 (UTC)
Received: from mail-oo1-f71.google.com (mail-oo1-f71.google.com
	[209.85.161.71]) by relay.mimecast.com with ESMTP with STARTTLS
	(version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
	us-mta-459-nSGu33QVN6KPPXfzaoXeIQ-1; Fri, 11 Feb 2022 16:41:26 -0500
X-MC-Unique: nSGu33QVN6KPPXfzaoXeIQ-1
Received: by mail-oo1-f71.google.com with SMTP id
	u13-20020a4ab5cd000000b002e021ad5bbcso6315462ooo.17
	for <dm-devel@redhat.com>; Fri, 11 Feb 2022 13:41:26 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=1e100.net; s=20210112;
	h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
	:references;
	bh=zCLaNAewIh7QkuP3rRG3MbVBEGym23cj6pMb7L3QmRw=;
	b=ULKYmckH4yYUAQtRjhushAfy/3OYiBMKqcSAXL4vjAdJDdboDT6uKT238RpHXYPz/h
	qtuNCkMYKYPm25a5OKU5LuaXQ8fuCYhZWuWam2vsZWhh9t8Qxz+2w/f+JiGmGmwYnG7t
	FonbXWaWhxkgUMoulcxDBqywOQkT8QDz6itrEDXf2p0k3qVhuv9BXcEgT9vms6TF2QCI
	ic6yKjBBMRj4MK7Kz1nCeVZuwAMbY3DXP68PeyeKSAkSu6RXdW/5sU87ZGC1coTAshUR
	d4nxMXnDVppjJ/1F3IAmOEfVxUxg4PnOKVquT+zJ50SVAX/794pTmTS/FcowQToUKjhf
	9Z9Q==
X-Gm-Message-State: AOAM532raYluJPYdwJ1QypLs6gTqsg4vJWm0b2SL3mKKs7XZT7umwuju
	+2X2fZcnkaTu0n6D0mvvCEgNVL/T/5a2uW11DTJBMjYOdi1xC2DFk3K7t4vGBP1mj7poSc7EANC
	jtNKqu0tXnGt4zASgibN7cBEdj82UEXyByVSGfiANgyJrDmRnu90vae9J+hQ3vBpByg==
X-Received: by 2002:a9d:58c8:: with SMTP id s8mr1306860oth.294.1644615685184; 
	Fri, 11 Feb 2022 13:41:25 -0800 (PST)
X-Google-Smtp-Source: ABdhPJyzn92w1zkt3XkDgBb0WATQwhT0Cg5dpyyOjGhJ9x8FW+WtRk+rD9rUvvy7aLTh3q+qoANrxw==
X-Received: by 2002:a9d:58c8:: with SMTP id s8mr1306850oth.294.1644615684909; 
	Fri, 11 Feb 2022 13:41:24 -0800 (PST)
Received: from localhost (pool-68-160-176-52.bstnma.fios.verizon.net.
	[68.160.176.52])
	by smtp.gmail.com with ESMTPSA id n4sm9481217otq.63.2022.02.11.13.41.24
	(version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
	Fri, 11 Feb 2022 13:41:24 -0800 (PST)
From: Mike Snitzer <snitzer@redhat.com>
To: dm-devel@redhat.com
Date: Fri, 11 Feb 2022 16:40:55 -0500
Message-Id: <20220211214057.40612-13-snitzer@redhat.com>
In-Reply-To: <20220211214057.40612-1-snitzer@redhat.com>
References: <20220211214057.40612-1-snitzer@redhat.com>
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.2
X-loop: dm-devel@redhat.com
Cc: linux-block@vger.kernel.org
Subject: [dm-devel] [PATCH v2 12/14] dm crypt: use dm_submit_bio_remap
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
MIME-Version: 1.0
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Signed-off-by: Mike Snitzer <snitzer@redhat.com>
---
 drivers/md/dm-crypt.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/md/dm-crypt.c b/drivers/md/dm-crypt.c
index a5006cb6ee8a..337517cb4e90 100644
--- a/drivers/md/dm-crypt.c
+++ b/drivers/md/dm-crypt.c
@@ -1855,7 +1855,7 @@ static int kcryptd_io_read(struct dm_crypt_io *io, gfp_t gfp)
 		return 1;
 	}
 
-	submit_bio_noacct(clone);
+	dm_submit_bio_remap(io->base_bio, clone);
 	return 0;
 }
 
@@ -1881,7 +1881,7 @@ static void kcryptd_io_write(struct dm_crypt_io *io)
 {
 	struct bio *clone = io->ctx.bio_out;
 
-	submit_bio_noacct(clone);
+	dm_submit_bio_remap(io->base_bio, clone);
 }
 
 #define crypt_io_from_node(node) rb_entry((node), struct dm_crypt_io, rb_node)
@@ -1960,7 +1960,7 @@ static void kcryptd_crypt_write_io_submit(struct dm_crypt_io *io, int async)
 
 	if ((likely(!async) && test_bit(DM_CRYPT_NO_OFFLOAD, &cc->flags)) ||
 	    test_bit(DM_CRYPT_NO_WRITE_WORKQUEUE, &cc->flags)) {
-		submit_bio_noacct(clone);
+		dm_submit_bio_remap(io->base_bio, clone);
 		return;
 	}
 
@@ -3363,6 +3363,7 @@ static int crypt_ctr(struct dm_target *ti, unsigned int argc, char **argv)
 
 	ti->num_flush_bios = 1;
 	ti->limit_swap_bios = true;
+	ti->accounts_remapped_io = true;
 
 	dm_audit_log_ctr(DM_MSG_PREFIX, ti, 1);
 	return 0;
@@ -3626,7 +3627,7 @@ static void crypt_io_hints(struct dm_target *ti, struct queue_limits *limits)
 
 static struct target_type crypt_target = {
 	.name   = "crypt",
-	.version = {1, 23, 0},
+	.version = {1, 24, 0},
 	.module = THIS_MODULE,
 	.ctr    = crypt_ctr,
 	.dtr    = crypt_dtr,
-- 
2.15.0

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

