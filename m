Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CDED3C636D4
	for <dm-devel@archiver.kernel.org>; Mon, 13 Feb 2023 20:15:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1676319324;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=xE8/d34+cRRayTVt1LPRrzwHwVaQMdaX6dO9yiuSM+E=;
	b=LZIqEbJ67fXlPzMpjSRLWe7ZUJXu6SMmr/qCHYhtnD2JPXMU/qdT7I3qazT3oxhHOpT6ZU
	d+XIPL5UzCdUQYdfbXIU/fLynHkyOgsSM6PFNggi/pr71mW6Ui5dzL6anCjwlkvtPa2Mp7
	6gBoGlqkdboiJI4heHHBSeoxqgvoPbM=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-619-jF2JZxg1MKaoTZfUwMuYEQ-1; Mon, 13 Feb 2023 15:15:20 -0500
X-MC-Unique: jF2JZxg1MKaoTZfUwMuYEQ-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id B748897109D;
	Mon, 13 Feb 2023 20:14:57 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id A373C492B15;
	Mon, 13 Feb 2023 20:14:57 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 965521946588;
	Mon, 13 Feb 2023 20:14:57 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
 [10.11.54.4])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id D097419465A2
 for <dm-devel@listman.corp.redhat.com>; Mon, 13 Feb 2023 20:14:56 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id C45D42026D68; Mon, 13 Feb 2023 20:14:56 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast04.extmail.prod.ext.rdu2.redhat.com [10.11.55.20])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id BCA322026D4B
 for <dm-devel@redhat.com>; Mon, 13 Feb 2023 20:14:56 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [205.139.110.61])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id A31DD10119EB
 for <dm-devel@redhat.com>; Mon, 13 Feb 2023 20:14:56 +0000 (UTC)
Received: from mail-qt1-f180.google.com (mail-qt1-f180.google.com
 [209.85.160.180]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-332-6or0u2szMySwYiSvE2hw0Q-3; Mon, 13 Feb 2023 15:14:55 -0500
X-MC-Unique: 6or0u2szMySwYiSvE2hw0Q-3
Received: by mail-qt1-f180.google.com with SMTP id g8so15148703qtq.13
 for <dm-devel@redhat.com>; Mon, 13 Feb 2023 12:14:55 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=content-transfer-encoding:mime-version:references:in-reply-to
 :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
 :subject:date:message-id:reply-to;
 bh=AVfGMvxJ6w49Ird7R24wSk8q7EXvGnkhVXI8d3Cg1HI=;
 b=cqsl2FNB0WEnWnhtHzPIz3XXEMWLwE4948OOL+v0Xvvd3VHiauryw/eXMmxT7QEFgo
 feDElHUcHr0B+bGMV91lznmQL2SobuiZJpSKdLgJHa6D78MPqRrCA7RaUp/jwlo05FiA
 71CnGQtod0EyYMskBd957Ry+1WzNjFrAPK+XxVURXmkD7nnUq+QSqoMLuZf0mBj7ybEW
 E6RyYDJ7/IFrCRDa8L0hLMxjsCsfLsOsHizcksrujlBs9aX06K6Q0EHqz4+TmTlnOrv9
 Z0zrtASol8/jIurWBPrdfkqidpOS4nmPldXcwNlqfTngYWWuH9k8d1dqK++QqaEWs1sY
 rzWQ==
X-Gm-Message-State: AO0yUKV+9zkr6W9UxCiq5Mf70MXMWONklshncUCoNuWvTv5Kl0NL6ZWr
 2yXlByg71v+Bpu0UPMr8zVFmcjWRqtpEaq2mbpeUranE/vnxRVIAbO7kzDoAKSsLjXCraeVNzcZ
 GjYLlwAwhIDbAFbP+DaIxS38Qs5zeVgMdkEioxjMhkD+OpZ/3Z/ehUeTt2RF/iMluti+l7w==
X-Google-Smtp-Source: AK7set+bBAIpg+mD9dvJJNxKqrYPD506Bd3Jebkfw8z151zOjrmctIWwdl1s6CaFahd+iIo8WhL0wQ==
X-Received: by 2002:ac8:5bd5:0:b0:3ba:1d8d:f6d0 with SMTP id
 b21-20020ac85bd5000000b003ba1d8df6d0mr48148297qtb.23.1676319294294; 
 Mon, 13 Feb 2023 12:14:54 -0800 (PST)
Received: from localhost (pool-68-160-166-30.bstnma.fios.verizon.net.
 [68.160.166.30]) by smtp.gmail.com with ESMTPSA id
 e7-20020a378207000000b0071a49ac0e05sm10315124qkd.111.2023.02.13.12.14.53
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Mon, 13 Feb 2023 12:14:53 -0800 (PST)
From: Mike Snitzer <snitzer@kernel.org>
To: dm-devel@redhat.com
Date: Mon, 13 Feb 2023 15:13:38 -0500
Message-Id: <20230213201401.45973-17-snitzer@kernel.org>
In-Reply-To: <20230213201401.45973-1-snitzer@kernel.org>
References: <20230213201401.45973-1-snitzer@kernel.org>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.4
Subject: [dm-devel] [PATCH 16/39] dm: add argument identifier names
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
Cc: ebiggers@kernel.org, Heinz Mauelshagen <heinzm@redhat.com>,
 Mike Snitzer <snitzer@kernel.org>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.10
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

From: Heinz Mauelshagen <heinzm@redhat.com>

Signed-off-by: Heinz Mauelshagen <heinzm@redhat.com>
Signed-off-by: Mike Snitzer <snitzer@kernel.org>
---
 drivers/md/dm-bufio.c           |  6 +++---
 drivers/md/dm-core.h            |  2 +-
 drivers/md/dm-era-target.c      | 10 +++++-----
 drivers/md/dm-snap-persistent.c |  2 +-
 drivers/md/dm-sysfs.c           |  4 ++--
 5 files changed, 12 insertions(+), 12 deletions(-)

diff --git a/drivers/md/dm-bufio.c b/drivers/md/dm-bufio.c
index 8d06ca801a10..0b25dce09d39 100644
--- a/drivers/md/dm-bufio.c
+++ b/drivers/md/dm-bufio.c
@@ -92,8 +92,8 @@ struct dm_bufio_client {
 	struct block_device *bdev;
 	unsigned int block_size;
 	s8 sectors_per_block_bits;
-	void (*alloc_callback)(struct dm_buffer *);
-	void (*write_callback)(struct dm_buffer *);
+	void (*alloc_callback)(struct dm_buffer *buf);
+	void (*write_callback)(struct dm_buffer *buf);
 	struct kmem_cache *slab_buffer;
 	struct kmem_cache *slab_cache;
 	struct dm_io_client *dm_io;
@@ -156,7 +156,7 @@ struct dm_buffer {
 	unsigned int write_end;
 	struct dm_bufio_client *c;
 	struct list_head write_list;
-	void (*end_io)(struct dm_buffer *, blk_status_t);
+	void (*end_io)(struct dm_buffer *buf, blk_status_t stat);
 #ifdef CONFIG_DM_DEBUG_BLOCK_STACK_TRACING
 #define MAX_STACK 10
 	unsigned int stack_len;
diff --git a/drivers/md/dm-core.h b/drivers/md/dm-core.h
index 28c3ba5dd402..f58227a1cce3 100644
--- a/drivers/md/dm-core.h
+++ b/drivers/md/dm-core.h
@@ -217,7 +217,7 @@ struct dm_table {
 	struct list_head devices;
 
 	/* events get handed up using this callback */
-	void (*event_fn)(void *);
+	void (*event_fn)(void *data);
 	void *event_context;
 
 	struct dm_md_mempools *mempools;
diff --git a/drivers/md/dm-era-target.c b/drivers/md/dm-era-target.c
index c4fd79135794..a42cfd950e04 100644
--- a/drivers/md/dm-era-target.c
+++ b/drivers/md/dm-era-target.c
@@ -682,7 +682,7 @@ struct digest {
 	__le32 value;
 	struct dm_disk_bitset info;
 
-	int (*step)(struct era_metadata *, struct digest *);
+	int (*step)(struct era_metadata *md, struct digest *d);
 };
 
 static int metadata_digest_lookup_writeset(struct era_metadata *md,
@@ -1193,8 +1193,8 @@ struct era {
 struct rpc {
 	struct list_head list;
 
-	int (*fn0)(struct era_metadata *);
-	int (*fn1)(struct era_metadata *, void *);
+	int (*fn0)(struct era_metadata *md);
+	int (*fn1)(struct era_metadata *md, void *ref);
 	void *arg;
 	int result;
 
@@ -1388,7 +1388,7 @@ static int perform_rpc(struct era *era, struct rpc *rpc)
 	return rpc->result;
 }
 
-static int in_worker0(struct era *era, int (*fn)(struct era_metadata *))
+static int in_worker0(struct era *era, int (*fn)(struct era_metadata *md))
 {
 	struct rpc rpc;
 	rpc.fn0 = fn;
@@ -1398,7 +1398,7 @@ static int in_worker0(struct era *era, int (*fn)(struct era_metadata *))
 }
 
 static int in_worker1(struct era *era,
-		      int (*fn)(struct era_metadata *, void *), void *arg)
+		      int (*fn)(struct era_metadata *md, void *ref), void *arg)
 {
 	struct rpc rpc;
 	rpc.fn0 = NULL;
diff --git a/drivers/md/dm-snap-persistent.c b/drivers/md/dm-snap-persistent.c
index c511af93b5dc..7d8232b6935f 100644
--- a/drivers/md/dm-snap-persistent.c
+++ b/drivers/md/dm-snap-persistent.c
@@ -95,7 +95,7 @@ struct core_exception {
 };
 
 struct commit_callback {
-	void (*callback)(void *, int success);
+	void (*callback)(void *ref, int success);
 	void *context;
 };
 
diff --git a/drivers/md/dm-sysfs.c b/drivers/md/dm-sysfs.c
index 9e97a5d9e1ec..a884401f0ca6 100644
--- a/drivers/md/dm-sysfs.c
+++ b/drivers/md/dm-sysfs.c
@@ -12,8 +12,8 @@
 
 struct dm_sysfs_attr {
 	struct attribute attr;
-	ssize_t (*show)(struct mapped_device *, char *);
-	ssize_t (*store)(struct mapped_device *, const char *, size_t count);
+	ssize_t (*show)(struct mapped_device *md, char *p);
+	ssize_t (*store)(struct mapped_device *md, const char *p, size_t count);
 };
 
 #define DM_ATTR_RO(_name) \
-- 
2.37.0 (Apple Git-136)

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

