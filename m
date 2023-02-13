Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DED91C636D4
	for <dm-devel@archiver.kernel.org>; Mon, 13 Feb 2023 20:14:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1676319296;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=nlnq5IN+v+P3zycUVyeTX64N8fJ/bifG0M+hMajG4gE=;
	b=MsHv+5pcUp0g4T/zkzx6hCXKBbHAI7s4dI0qK5ZAqx+ScJy3tFgpi2ak+h8rJ1ZFSnWTyJ
	RyDGm6c9Y+KUDdf8qn5aL/nLuuKbF2McI5OnCBDRye4o0M+bKpdIIa/0Qtkq7FbkDDYsC0
	PGOrhJd2leM4gmlA9qUVoo+VKbmWRHc=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-120-lOburCfmNQSLQnApQcZ25w-1; Mon, 13 Feb 2023 15:14:52 -0500
X-MC-Unique: lOburCfmNQSLQnApQcZ25w-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 0BB4B87B2A0;
	Mon, 13 Feb 2023 20:14:51 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id ECE35140EBF4;
	Mon, 13 Feb 2023 20:14:50 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id DF7791946588;
	Mon, 13 Feb 2023 20:14:50 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com
 [10.11.54.7])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 358FE1946586
 for <dm-devel@listman.corp.redhat.com>; Mon, 13 Feb 2023 20:14:49 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 26162140EBF6; Mon, 13 Feb 2023 20:14:49 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast06.extmail.prod.ext.rdu2.redhat.com [10.11.55.22])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 1E29D140EBF4
 for <dm-devel@redhat.com>; Mon, 13 Feb 2023 20:14:49 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [205.139.110.61])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 02A9A1871CD7
 for <dm-devel@redhat.com>; Mon, 13 Feb 2023 20:14:49 +0000 (UTC)
Received: from mail-qv1-f52.google.com (mail-qv1-f52.google.com
 [209.85.219.52]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-508-5_t57ch4OfSJHQ5E9cZPtg-1; Mon, 13 Feb 2023 15:14:46 -0500
X-MC-Unique: 5_t57ch4OfSJHQ5E9cZPtg-1
Received: by mail-qv1-f52.google.com with SMTP id l4so2200704qvh.11
 for <dm-devel@redhat.com>; Mon, 13 Feb 2023 12:14:46 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=content-transfer-encoding:mime-version:references:in-reply-to
 :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
 :subject:date:message-id:reply-to;
 bh=pGLrP1YrwH5tJrIvPAdXclLgwu5flzT8rk5M9VSnXVA=;
 b=P1oYXCX5V42rgYVzRTLKsdGL4uoct/v0H2dmAfjb6o6LAiWw4g+XE8WqNmibR7pugp
 XTyv4gQPrt/mp4ncdLI88T1LFhtTqaoMJNUE/DigBFVQ0K9YxSV3R7tMnkdn8dZ50ff9
 /CmzEkbz7ar5V5jecJ2n3bW2Ihmiv1Obc3AI3IvpwjOIROjCk19BS6+NJNBoORI9d1ye
 e8XIOyLaQuvSg1hCKIzzkCAYcFU72a6tpQl7axDXRACbzJL2lE6FR8zeBNeHLvgfHNfT
 YoixfmuvHkS7kcs56Z17rUUJiZIN6ORHhVc34s8kyynrtGuxuzJ8SgMc74ydTlXVIxeo
 8x5Q==
X-Gm-Message-State: AO0yUKVN1FN5KrWYtjjX7rwBs8KVCpffGHZEtnz0Lb/KOO2EFuUa624z
 j7fuFTNFn1H9uZmOWv/v0gZ1x4NB1GFldOgc9cHHmUlxhG/KPLbfRFJ2iPvRCVF6/35vNEQ/mjW
 d+I6Bdikjqq2hFvwtNZfj9bCzieSUESC9RLP4r6WI/haQKJK0hmgFsaBHEFQjTjKOgE3oJw==
X-Google-Smtp-Source: AK7set8DgYSVlwmx2qBmxFh0hNNhmLodSS94TssYkpE16j4I8gf+iqeDTsK01DRpUqYJmJsbhFr9BA==
X-Received: by 2002:a05:6214:4248:b0:56e:9f19:71f9 with SMTP id
 ne8-20020a056214424800b0056e9f1971f9mr12422521qvb.17.1676319285550; 
 Mon, 13 Feb 2023 12:14:45 -0800 (PST)
Received: from localhost (pool-68-160-166-30.bstnma.fios.verizon.net.
 [68.160.166.30]) by smtp.gmail.com with ESMTPSA id
 m123-20020a375881000000b0073b4cdb0745sm1360906qkb.116.2023.02.13.12.14.44
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Mon, 13 Feb 2023 12:14:44 -0800 (PST)
From: Mike Snitzer <snitzer@kernel.org>
To: dm-devel@redhat.com
Date: Mon, 13 Feb 2023 15:13:33 -0500
Message-Id: <20230213201401.45973-12-snitzer@kernel.org>
In-Reply-To: <20230213201401.45973-1-snitzer@kernel.org>
References: <20230213201401.45973-1-snitzer@kernel.org>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.7
Subject: [dm-devel] [PATCH 11/39] dm: fix undue/missing spaces
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
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.7
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

From: Heinz Mauelshagen <heinzm@redhat.com>

Signed-off-by: Heinz Mauelshagen <heinzm@redhat.com>
Signed-off-by: Mike Snitzer <snitzer@kernel.org>
---
 drivers/md/dm-ioctl.c           | 4 ++--
 drivers/md/dm-mpath.c           | 2 +-
 drivers/md/dm-ps-service-time.c | 3 +--
 drivers/md/dm-snap.c            | 6 +++---
 drivers/md/dm-table.c           | 2 +-
 drivers/md/dm-uevent.h          | 2 +-
 drivers/md/dm-writecache.c      | 4 ++--
 drivers/md/dm-zoned-metadata.c  | 2 +-
 8 files changed, 12 insertions(+), 13 deletions(-)

diff --git a/drivers/md/dm-ioctl.c b/drivers/md/dm-ioctl.c
index ab080794eab5..c00a1fe69846 100644
--- a/drivers/md/dm-ioctl.c
+++ b/drivers/md/dm-ioctl.c
@@ -1572,7 +1572,7 @@ static void retrieve_deps(struct dm_table *table,
 	/*
 	 * Count the devices.
 	 */
-	list_for_each (tmp, dm_table_get_devices(table))
+	list_for_each(tmp, dm_table_get_devices(table))
 		count++;
 
 	/*
@@ -1589,7 +1589,7 @@ static void retrieve_deps(struct dm_table *table,
 	 */
 	deps->count = count;
 	count = 0;
-	list_for_each_entry (dd, dm_table_get_devices(table), list)
+	list_for_each_entry(dd, dm_table_get_devices(table), list)
 		deps->dev[count++] = huge_encode_dev(dd->dm_dev->bdev->bd_dev);
 
 	param->data_size = param->data_start + needed;
diff --git a/drivers/md/dm-mpath.c b/drivers/md/dm-mpath.c
index 14bb5283e1e2..e59f67d72ac2 100644
--- a/drivers/md/dm-mpath.c
+++ b/drivers/md/dm-mpath.c
@@ -1092,7 +1092,7 @@ static int parse_hw_handler(struct dm_arg_set *as, struct multipath *m)
 			goto fail;
 		}
 		j = sprintf(p, "%d", hw_argc - 1);
-		for (i = 0, p+=j+1; i <= hw_argc - 2; i++, p+=j+1)
+		for (i = 0, p += j + 1; i <= hw_argc - 2; i++, p += j + 1)
 			j = sprintf(p, "%s", as->argv[i]);
 	}
 	dm_consume_args(as, hw_argc - 1);
diff --git a/drivers/md/dm-ps-service-time.c b/drivers/md/dm-ps-service-time.c
index e38dda83952c..3c8f2e884a12 100644
--- a/drivers/md/dm-ps-service-time.c
+++ b/drivers/md/dm-ps-service-time.c
@@ -128,8 +128,7 @@ static int st_add_path(struct path_selector *ps, struct dm_path *path,
 	 * 			The valid range: 0-<ST_MAX_RELATIVE_THROUGHPUT>
 	 *			If not given, minimum value '1' is used.
 	 *			If '0' is given, the path isn't selected while
-	 * 			other paths having a positive value are
-	 * 			available.
+	 *			other paths having a positive value are	available.
 	 */
 	if (argc > 2) {
 		*error = "service-time ps: incorrect number of arguments";
diff --git a/drivers/md/dm-snap.c b/drivers/md/dm-snap.c
index 22b07a1bf972..35c648ef2162 100644
--- a/drivers/md/dm-snap.c
+++ b/drivers/md/dm-snap.c
@@ -389,7 +389,7 @@ static struct origin *__lookup_origin(struct block_device *origin)
 	struct origin *o;
 
 	ol = &_origins[origin_hash(origin)];
-	list_for_each_entry (o, ol, hash_list)
+	list_for_each_entry(o, ol, hash_list)
 		if (bdev_equal(o->bdev, origin))
 			return o;
 
@@ -408,7 +408,7 @@ static struct dm_origin *__lookup_dm_origin(struct block_device *origin)
 	struct dm_origin *o;
 
 	ol = &_dm_origins[origin_hash(origin)];
-	list_for_each_entry (o, ol, hash_list)
+	list_for_each_entry(o, ol, hash_list)
 		if (bdev_equal(o->dev->bdev, origin))
 			return o;
 
@@ -2448,7 +2448,7 @@ static int __origin_write(struct list_head *snapshots, sector_t sector,
 	chunk_t chunk;
 
 	/* Do all the snapshots on this origin */
-	list_for_each_entry (snap, snapshots, list) {
+	list_for_each_entry(snap, snapshots, list) {
 		/*
 		 * Don't make new exceptions in a merging snapshot
 		 * because it has effectively been deleted
diff --git a/drivers/md/dm-table.c b/drivers/md/dm-table.c
index eff611ac4ac0..6cb7c2afd2d3 100644
--- a/drivers/md/dm-table.c
+++ b/drivers/md/dm-table.c
@@ -212,7 +212,7 @@ static struct dm_dev_internal *find_device(struct list_head *l, dev_t dev)
 {
 	struct dm_dev_internal *dd;
 
-	list_for_each_entry (dd, l, list)
+	list_for_each_entry(dd, l, list)
 		if (dd->dm_dev->bdev->bd_dev == dev)
 			return dd;
 
diff --git a/drivers/md/dm-uevent.h b/drivers/md/dm-uevent.h
index 2c9ba561fd8e..12a5d4fb7d44 100644
--- a/drivers/md/dm-uevent.h
+++ b/drivers/md/dm-uevent.h
@@ -3,7 +3,7 @@
  * Device Mapper Uevent Support
  *
  * Copyright IBM Corporation, 2007
- * 	Author: Mike Anderson <andmike@linux.vnet.ibm.com>
+ *	Author: Mike Anderson <andmike@linux.vnet.ibm.com>
  */
 #ifndef DM_UEVENT_H
 #define DM_UEVENT_H
diff --git a/drivers/md/dm-writecache.c b/drivers/md/dm-writecache.c
index 0ccca4a87a6c..78c55fbb660f 100644
--- a/drivers/md/dm-writecache.c
+++ b/drivers/md/dm-writecache.c
@@ -85,12 +85,12 @@ struct wc_entry {
 	unsigned short wc_list_contiguous;
 	bool write_in_progress
 #if BITS_PER_LONG == 64
-		:1
+		: 1
 #endif
 	;
 	unsigned long index
 #if BITS_PER_LONG == 64
-		:47
+		: 47
 #endif
 	;
 	unsigned long age;
diff --git a/drivers/md/dm-zoned-metadata.c b/drivers/md/dm-zoned-metadata.c
index 35bdb83e3a6e..b13c1aa5e53b 100644
--- a/drivers/md/dm-zoned-metadata.c
+++ b/drivers/md/dm-zoned-metadata.c
@@ -1013,7 +1013,7 @@ static int dmz_check_sb(struct dmz_metadata *zmd, struct dmz_sb *dsb,
 	}
 
 	sb_block = le64_to_cpu(sb->sb_block);
-	if (sb_block != (u64)dsb->zone->id << zmd->zone_nr_blocks_shift ) {
+	if (sb_block != (u64)dsb->zone->id << zmd->zone_nr_blocks_shift) {
 		dmz_dev_err(dev, "Invalid superblock position "
 			    "(is %llu expected %llu)",
 			    sb_block,
-- 
2.37.0 (Apple Git-136)

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

