Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8B922C19F28
	for <dm-devel@archiver.kernel.org>; Tue, 26 Jul 2022 16:10:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1658851817;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=raoYQrRDK4ZsA7JQHrxWDJD/M4xWiy7xnL0KDVpnpX0=;
	b=WkPH9LK4V1XT6xJ/41Y4S1wOIN0VwtY0lGt0PCSFdiMEliIvbh4cEzDqlwCtfKKDa76d2V
	CxxXVRbNj1yOXT4gHYevVkJ+BKGP53JCh6FL34Gl1bxAlfrAFMd4Pe0zADpmvqOkB1BoeK
	paeHEuWXW9DgR+qmc1Xml0s7gghM268=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-620-oyZ2iZ3TOPGXtcSu0GwQ0g-1; Tue, 26 Jul 2022 12:10:16 -0400
X-MC-Unique: oyZ2iZ3TOPGXtcSu0GwQ0g-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 13105280302B;
	Tue, 26 Jul 2022 16:10:14 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 0223E492C3B;
	Tue, 26 Jul 2022 16:10:14 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id C529F1945DAD;
	Tue, 26 Jul 2022 16:10:13 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com
 [10.11.54.10])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 83CFF1945DAD
 for <dm-devel@listman.corp.redhat.com>; Tue, 26 Jul 2022 16:10:12 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 68160401E92; Tue, 26 Jul 2022 16:10:12 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast04.extmail.prod.ext.rdu2.redhat.com [10.11.55.20])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 640AD492C3B
 for <dm-devel@redhat.com>; Tue, 26 Jul 2022 16:10:12 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [207.211.31.81])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 15A871019C96
 for <dm-devel@redhat.com>; Tue, 26 Jul 2022 16:10:12 +0000 (UTC)
Received: from mail-qk1-f175.google.com (mail-qk1-f175.google.com
 [209.85.222.175]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-177-o_qUX4x7PlWf6xo6oS3akQ-1; Tue, 26 Jul 2022 12:10:10 -0400
X-MC-Unique: o_qUX4x7PlWf6xo6oS3akQ-1
Received: by mail-qk1-f175.google.com with SMTP id c24so11297855qkm.4
 for <dm-devel@redhat.com>; Tue, 26 Jul 2022 09:10:10 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
 :references:mime-version:content-transfer-encoding;
 bh=OrKw6hqzfp+S52iy7N8NkTjJdvfO+1gPRJBn8FbTRiw=;
 b=m8ZC2mU774DbD4iEWNRq52uPo/Kk68uLUcTTiWkdTaspoB5PeU7u3I/QV1tIHsl9eL
 XSx7+t8znH74DKPsSnBUQlgATR1zW+5Clv6FzxQvH5MNRFcdTKP4Jb7bkg+JQiHoOegb
 KPGyLqdFmmPUZAHxuQkqieq12hiz1KARpC516xKFvuh1+JkUtvA3mr+vorvi3ci6FFgu
 G1JO4jJwfJTmPdr9Z4TLYbHr8khdgA3Pdr9LtZX906hWXE45paWIYMiAMla3bt+c73F1
 yZAKU4uNghIEkzga12E74X/G102Jj6mUtrmb6EZakFsiCBBxXFL6ez7kRLOppfVG2//D
 C7/w==
X-Gm-Message-State: AJIora9Hf19KtruYGmZRWuBshdt2/1/Q46qFZuBlB4EGHKmGqx4lnBCj
 jWKqpWn/8wbz+M/HryDzGBYi+RIiUYcl9A4=
X-Google-Smtp-Source: AGRyM1sUTKOWdUS4GSGVnkjsR0LQz+EA1j3HL5/+X4+wUt0/qiVuUGBCAEOD7G6nbWOwrHRx4lwH+g==
X-Received: by 2002:a05:620a:4629:b0:6b5:ede1:f9cd with SMTP id
 br41-20020a05620a462900b006b5ede1f9cdmr13638053qkb.487.1658851809786; 
 Tue, 26 Jul 2022 09:10:09 -0700 (PDT)
Received: from localhost (pool-68-160-173-162.bstnma.fios.verizon.net.
 [68.160.173.162]) by smtp.gmail.com with ESMTPSA id
 cn9-20020a05622a248900b0031f229d4427sm7229451qtb.96.2022.07.26.09.10.09
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Tue, 26 Jul 2022 09:10:09 -0700 (PDT)
From: Mike Snitzer <snitzer@kernel.org>
To: Nathan Huckleberry <nhuck@google.com>, Eric Biggers <ebiggers@kernel.org>
Date: Tue, 26 Jul 2022 12:09:59 -0400
Message-Id: <20220726160959.89247-7-snitzer@kernel.org>
In-Reply-To: <20220726160959.89247-1-snitzer@kernel.org>
References: <20220726160959.89247-1-snitzer@kernel.org>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.10
Subject: [dm-devel] [PATCH v2 6/6] dm verity: conditionally enable branching
 for "try_verify_in_tasklet"
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
Cc: dm-devel@redhat.com, Sami Tolvanen <samitolvanen@google.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.10
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Use jump_label to limit the need for branching unless the optional
"try_verify_in_tasklet" feature is used.

Signed-off-by: Mike Snitzer <snitzer@kernel.org>
---
 drivers/md/dm-verity-target.c | 19 ++++++++++++++-----
 1 file changed, 14 insertions(+), 5 deletions(-)

diff --git a/drivers/md/dm-verity-target.c b/drivers/md/dm-verity-target.c
index 054095c2052b..f747eb874cfb 100644
--- a/drivers/md/dm-verity-target.c
+++ b/drivers/md/dm-verity-target.c
@@ -19,6 +19,7 @@
 #include <linux/module.h>
 #include <linux/reboot.h>
 #include <linux/scatterlist.h>
+#include <linux/jump_label.h>
 
 #define DM_MSG_PREFIX			"verity"
 
@@ -43,6 +44,8 @@ static unsigned dm_verity_prefetch_cluster = DM_VERITY_DEFAULT_PREFETCH_SIZE;
 
 module_param_named(prefetch_cluster, dm_verity_prefetch_cluster, uint, S_IRUGO | S_IWUSR);
 
+static DEFINE_STATIC_KEY_FALSE(use_tasklet_enabled);
+
 struct dm_verity_prefetch_work {
 	struct work_struct work;
 	struct dm_verity *v;
@@ -287,7 +290,7 @@ static int verity_verify_level(struct dm_verity *v, struct dm_verity_io *io,
 
 	verity_hash_at_level(v, block, level, &hash_block, &offset);
 
-	if (io->in_tasklet) {
+	if (static_branch_unlikely(&use_tasklet_enabled) && io->in_tasklet) {
 		data = dm_bufio_get(v->bufio, hash_block, &buf);
 		if (data == NULL) {
 			/*
@@ -320,7 +323,8 @@ static int verity_verify_level(struct dm_verity *v, struct dm_verity_io *io,
 		if (likely(memcmp(verity_io_real_digest(v, io), want_digest,
 				  v->digest_size) == 0))
 			aux->hash_verified = 1;
-		else if (io->in_tasklet) {
+		else if (static_branch_unlikely(&use_tasklet_enabled) &&
+			 io->in_tasklet) {
 			/*
 			 * FEC code cannot be run in a tasklet since it may
 			 * sleep, so fallback to using a work-queue.
@@ -547,7 +551,8 @@ static int verity_verify_io(struct dm_verity_io *io)
 			if (v->validated_blocks)
 				set_bit(cur_block, v->validated_blocks);
 			continue;
-		} else if (io->in_tasklet) {
+		} else if (static_branch_unlikely(&use_tasklet_enabled) &&
+			   io->in_tasklet) {
 			/*
 			 * FEC code cannot be run in a tasklet since it may
 			 * sleep, so fallback to using a work-queue.
@@ -592,7 +597,7 @@ static void verity_finish_io(struct dm_verity_io *io, blk_status_t status)
 	bio->bi_end_io = io->orig_bi_end_io;
 	bio->bi_status = status;
 
-	if (!io->in_tasklet)
+	if (!static_branch_unlikely(&use_tasklet_enabled) || !io->in_tasklet)
 		verity_fec_finish_io(io);
 
 	bio_endio(bio);
@@ -634,7 +639,7 @@ static void verity_end_io(struct bio *bio)
 	}
 
 	io->block_idx = 0;
-	if (io->v->use_tasklet) {
+	if (static_branch_unlikely(&use_tasklet_enabled) && io->v->use_tasklet) {
 		tasklet_init(&io->tasklet, verity_tasklet, (unsigned long)io);
 		tasklet_schedule(&io->tasklet);
 	} else {
@@ -944,6 +949,9 @@ static void verity_dtr(struct dm_target *ti)
 
 	kfree(v->signature_key_desc);
 
+	if (v->use_tasklet)
+		static_branch_dec(&use_tasklet_enabled);
+
 	kfree(v);
 }
 
@@ -1075,6 +1083,7 @@ static int verity_parse_opt_args(struct dm_arg_set *as, struct dm_verity *v,
 
 		} else if (!strcasecmp(arg_name, DM_VERITY_OPT_TASKLET_VERIFY)) {
 			v->use_tasklet = true;
+			static_branch_inc(&use_tasklet_enabled);
 			continue;
 
 		} else if (verity_is_fec_opt_arg(arg_name)) {
-- 
2.32.1 (Apple Git-133)

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

