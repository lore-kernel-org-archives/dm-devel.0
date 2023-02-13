Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 48D12C64EC7
	for <dm-devel@archiver.kernel.org>; Mon, 13 Feb 2023 20:14:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1676319288;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=45Hn1cCBoMZR4Lzt/iTiNcQY9Wf8bloiac4UM4uar3o=;
	b=RtHfpHZVtLbfsmJxze1QD0wjXLdAV785vp8+amR0Da8XnaPp2hBBh1IbVLh2iaPyAQ91Pp
	WogEY3MpW0bUoKcZMLv8xGrUV3g0J5DpmDCifhkqKrXh4AcFqU9CCtCFCoLIWYnB+YUpiE
	2lhfqKJK8GLsnlVQFyJOptiCV2QnKh4=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-568-gfswfdj5OLKZlrbTKHzRMg-1; Mon, 13 Feb 2023 15:14:44 -0500
X-MC-Unique: gfswfdj5OLKZlrbTKHzRMg-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 2B4133815F65;
	Mon, 13 Feb 2023 20:14:43 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 1B8E2400D927;
	Mon, 13 Feb 2023 20:14:43 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id F06251946595;
	Mon, 13 Feb 2023 20:14:42 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
 [10.11.54.4])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id B22F11946586
 for <dm-devel@listman.corp.redhat.com>; Mon, 13 Feb 2023 20:14:42 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id A44E62026D68; Mon, 13 Feb 2023 20:14:42 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast06.extmail.prod.ext.rdu2.redhat.com [10.11.55.22])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 9C98D2026D4B
 for <dm-devel@redhat.com>; Mon, 13 Feb 2023 20:14:42 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [205.139.110.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 82BD418483B3
 for <dm-devel@redhat.com>; Mon, 13 Feb 2023 20:14:42 +0000 (UTC)
Received: from mail-qt1-f180.google.com (mail-qt1-f180.google.com
 [209.85.160.180]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-434-DPt_EfPjPnqBOSFjWhUbxw-1; Mon, 13 Feb 2023 15:14:41 -0500
X-MC-Unique: DPt_EfPjPnqBOSFjWhUbxw-1
Received: by mail-qt1-f180.google.com with SMTP id c2so15201285qtw.5
 for <dm-devel@redhat.com>; Mon, 13 Feb 2023 12:14:40 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=content-transfer-encoding:mime-version:references:in-reply-to
 :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
 :subject:date:message-id:reply-to;
 bh=5ZsjmNZ/2WWOqDA2G5i1rJc577KukZRXC8o8aR5xLPY=;
 b=LzQufUq4233+8tyjRWpyjUJwkCujBkKl9j7BhQtMa4JkzfU9IZOSH5re2kRKGKpQAo
 kBwMamoxDxWpdM10REaMIOM9ybmpZRDxMvipzzQqCRmTLyXm0SKCyJPZGIwaUT8EtrDI
 W0NFrkEDyHw+5EXbplb2g4PU4+R7GSLTbsE18HIpcESv3ZBbd0xUB/BdhgTurOBbm7HV
 8bPpUj1U0oQDKXLsNhzxDX/70YPuO1Qgl3JoZg2AIRjhYkySf0hI9ub6o8pNCnFwT8ts
 vmfa68OzC/wGzxoK2JxYYUinE4DhqFYlotFOgsH0i4MOtP3Vua8RJ9hBL+z+Q6lKA9dj
 h2tw==
X-Gm-Message-State: AO0yUKUPwkkeZ3yi+Xt3nFUnfYx4jmXToV2RZcWy8Bw9zh2Udyoltr5Z
 +i4CUytuUK0VD9gPGWhtZvN+9594htPVVtNo0PiFG9C8woPb+lCQ2L59iME6qmmhmgQTCT3ue0q
 wfJee+ut1pU6ZzKXFbmNUjjbmqA0AZrwMRWU6p1noy6LGkkkiRL1U0pV7QcJdcGyOOYzRsQ==
X-Google-Smtp-Source: AK7set8wnxYD/AhcXcGQyKChqN/6L1q82N6+8WiR9nbOt7RoAkMAJQZL/VQ9iYULKCaPJGoIZh2EsQ==
X-Received: by 2002:a05:622a:1393:b0:3b6:30b6:b894 with SMTP id
 o19-20020a05622a139300b003b630b6b894mr41313679qtk.20.1676319279954; 
 Mon, 13 Feb 2023 12:14:39 -0800 (PST)
Received: from localhost (pool-68-160-166-30.bstnma.fios.verizon.net.
 [68.160.166.30]) by smtp.gmail.com with ESMTPSA id
 b20-20020ac86794000000b003b2957fb45bsm9936405qtp.8.2023.02.13.12.14.39
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Mon, 13 Feb 2023 12:14:39 -0800 (PST)
From: Mike Snitzer <snitzer@kernel.org>
To: dm-devel@redhat.com
Date: Mon, 13 Feb 2023 15:13:30 -0500
Message-Id: <20230213201401.45973-9-snitzer@kernel.org>
In-Reply-To: <20230213201401.45973-1-snitzer@kernel.org>
References: <20230213201401.45973-1-snitzer@kernel.org>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.4
Subject: [dm-devel] [PATCH 08/39] dm: address space issues relative to
 switch/while/for/...
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
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.1
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

From: Heinz Mauelshagen <heinzm@redhat.com>

Signed-off-by: Heinz Mauelshagen <heinzm@redhat.com>
Signed-off-by: Mike Snitzer <snitzer@kernel.org>
---
 drivers/md/dm-bio-prison-v2.c  | 2 +-
 drivers/md/dm-cache-metadata.c | 8 ++++----
 drivers/md/dm-log.c            | 4 ++--
 drivers/md/dm-mpath.c          | 2 +-
 drivers/md/dm-ps-io-affinity.c | 2 +-
 drivers/md/dm-ps-round-robin.c | 2 +-
 drivers/md/dm-zoned-metadata.c | 4 ++--
 7 files changed, 12 insertions(+), 12 deletions(-)

diff --git a/drivers/md/dm-bio-prison-v2.c b/drivers/md/dm-bio-prison-v2.c
index 3b4875a8488c..388d7c88e4d5 100644
--- a/drivers/md/dm-bio-prison-v2.c
+++ b/drivers/md/dm-bio-prison-v2.c
@@ -195,7 +195,7 @@ static bool __put(struct dm_bio_prison_v2 *prison,
 
 	// FIXME: shared locks granted above the lock level could starve this
 	if (!cell->shared_count) {
-		if (cell->exclusive_lock){
+		if (cell->exclusive_lock) {
 			if (cell->quiesce_continuation) {
 				queue_work(prison->wq, cell->quiesce_continuation);
 				cell->quiesce_continuation = NULL;
diff --git a/drivers/md/dm-cache-metadata.c b/drivers/md/dm-cache-metadata.c
index 94634a901157..ddcd633cce4b 100644
--- a/drivers/md/dm-cache-metadata.c
+++ b/drivers/md/dm-cache-metadata.c
@@ -1010,13 +1010,13 @@ static bool cmd_write_lock(struct dm_cache_metadata *cmd)
 	do {					\
 		if (!cmd_write_lock((cmd)))	\
 			return -EINVAL;		\
-	} while(0)
+	} while (0)
 
 #define WRITE_LOCK_VOID(cmd)			\
 	do {					\
 		if (!cmd_write_lock((cmd)))	\
 			return;			\
-	} while(0)
+	} while (0)
 
 #define WRITE_UNLOCK(cmd) \
 	up_write(&(cmd)->root_lock)
@@ -1035,13 +1035,13 @@ static bool cmd_read_lock(struct dm_cache_metadata *cmd)
 	do {					\
 		if (!cmd_read_lock((cmd)))	\
 			return -EINVAL;		\
-	} while(0)
+	} while (0)
 
 #define READ_LOCK_VOID(cmd)			\
 	do {					\
 		if (!cmd_read_lock((cmd)))	\
 			return;			\
-	} while(0)
+	} while (0)
 
 #define READ_UNLOCK(cmd) \
 	up_read(&(cmd)->root_lock)
diff --git a/drivers/md/dm-log.c b/drivers/md/dm-log.c
index 3cd166d3a7a8..2601dc9acb08 100644
--- a/drivers/md/dm-log.c
+++ b/drivers/md/dm-log.c
@@ -784,7 +784,7 @@ static int core_status(struct dm_dirty_log *log, status_type_t status,
 	int sz = 0;
 	struct log_c *lc = log->context;
 
-	switch(status) {
+	switch (status) {
 	case STATUSTYPE_INFO:
 		DMEMIT("1 %s", log->type->name);
 		break;
@@ -809,7 +809,7 @@ static int disk_status(struct dm_dirty_log *log, status_type_t status,
 	int sz = 0;
 	struct log_c *lc = log->context;
 
-	switch(status) {
+	switch (status) {
 	case STATUSTYPE_INFO:
 		DMEMIT("3 %s %s %c", log->type->name, lc->log_dev->name,
 		       lc->log_dev_flush_failed ? 'F' :
diff --git a/drivers/md/dm-mpath.c b/drivers/md/dm-mpath.c
index a8fcb41878fe..c882d6e8dfdb 100644
--- a/drivers/md/dm-mpath.c
+++ b/drivers/md/dm-mpath.c
@@ -1822,7 +1822,7 @@ static void multipath_status(struct dm_target *ti, status_type_t type,
 		if (test_bit(MPATHF_RETAIN_ATTACHED_HW_HANDLER, &m->flags))
 			DMEMIT("retain_attached_hw_handler ");
 		if (m->queue_mode != DM_TYPE_REQUEST_BASED) {
-			switch(m->queue_mode) {
+			switch (m->queue_mode) {
 			case DM_TYPE_BIO_BASED:
 				DMEMIT("queue_mode bio ");
 				break;
diff --git a/drivers/md/dm-ps-io-affinity.c b/drivers/md/dm-ps-io-affinity.c
index 76ce4ce87222..461ee6b2044d 100644
--- a/drivers/md/dm-ps-io-affinity.c
+++ b/drivers/md/dm-ps-io-affinity.c
@@ -162,7 +162,7 @@ static int ioa_status(struct path_selector *ps, struct dm_path *path,
 		return sz;
 	}
 
-	switch(type) {
+	switch (type) {
 	case STATUSTYPE_INFO:
 		DMEMIT("%d ", atomic_read(&s->map_misses));
 		break;
diff --git a/drivers/md/dm-ps-round-robin.c b/drivers/md/dm-ps-round-robin.c
index 3cc80efbadd2..85ca14f87873 100644
--- a/drivers/md/dm-ps-round-robin.c
+++ b/drivers/md/dm-ps-round-robin.c
@@ -94,7 +94,7 @@ static int rr_status(struct path_selector *ps, struct dm_path *path,
 	if (!path)
 		DMEMIT("0 ");
 	else {
-		switch(type) {
+		switch (type) {
 		case STATUSTYPE_INFO:
 			break;
 		case STATUSTYPE_TABLE:
diff --git a/drivers/md/dm-zoned-metadata.c b/drivers/md/dm-zoned-metadata.c
index c795ea7da791..35bdb83e3a6e 100644
--- a/drivers/md/dm-zoned-metadata.c
+++ b/drivers/md/dm-zoned-metadata.c
@@ -1430,7 +1430,7 @@ static int dmz_emulate_zones(struct dmz_metadata *zmd, struct dmz_dev *dev)
 	int idx;
 	sector_t zone_offset = 0;
 
-	for(idx = 0; idx < dev->nr_zones; idx++) {
+	for (idx = 0; idx < dev->nr_zones; idx++) {
 		struct dm_zone *zone;
 
 		zone = dmz_insert(zmd, idx, dev);
@@ -1457,7 +1457,7 @@ static void dmz_drop_zones(struct dmz_metadata *zmd)
 {
 	int idx;
 
-	for(idx = 0; idx < zmd->nr_zones; idx++) {
+	for (idx = 0; idx < zmd->nr_zones; idx++) {
 		struct dm_zone *zone = xa_load(&zmd->zones, idx);
 
 		kfree(zone);
-- 
2.37.0 (Apple Git-136)

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

