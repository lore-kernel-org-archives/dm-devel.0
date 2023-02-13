Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5EDF5C64ED8
	for <dm-devel@archiver.kernel.org>; Mon, 13 Feb 2023 20:15:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1676319333;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=HlJMN/12IDwqtZPocZoRmOvBbDP3E5rfmtjHbM+cckA=;
	b=fNBTKQTXTCFImaNJKIFTm8WQmq28ZpFpENSXQy2bMyJDpYO1AYszM7JNE+UkfJpPZgxi8I
	duIbAAnrKjnNDALWFX0IH5tFXP2zXQ2BuRbQNyBoCcz2Q5TLr2f/g5DA7jpUBRXBtFTfdq
	Rqc9nwLVRIqnOqQFiiDLshf1QFLomCg=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-557-qrITkgYKMhCfaecg5MDa4w-1; Mon, 13 Feb 2023 15:15:30 -0500
X-MC-Unique: qrITkgYKMhCfaecg5MDa4w-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 39746811E9C;
	Mon, 13 Feb 2023 20:15:14 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 28EDD1121318;
	Mon, 13 Feb 2023 20:15:14 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 1AFD81946588;
	Mon, 13 Feb 2023 20:15:14 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com
 [10.11.54.9])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 0AB981946586
 for <dm-devel@listman.corp.redhat.com>; Mon, 13 Feb 2023 20:15:13 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id E2752492B06; Mon, 13 Feb 2023 20:15:12 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast10.extmail.prod.ext.rdu2.redhat.com [10.11.55.26])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id DB5D8492B07
 for <dm-devel@redhat.com>; Mon, 13 Feb 2023 20:15:12 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [205.139.110.61])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 5E4161C29D60
 for <dm-devel@redhat.com>; Mon, 13 Feb 2023 20:15:10 +0000 (UTC)
Received: from mail-qv1-f52.google.com (mail-qv1-f52.google.com
 [209.85.219.52]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-408-B_5J4fYPPmOBTmBsU5ZQrg-2; Mon, 13 Feb 2023 15:15:08 -0500
X-MC-Unique: B_5J4fYPPmOBTmBsU5ZQrg-2
Received: by mail-qv1-f52.google.com with SMTP id l7so4176881qvw.7
 for <dm-devel@redhat.com>; Mon, 13 Feb 2023 12:15:06 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=content-transfer-encoding:mime-version:references:in-reply-to
 :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
 :subject:date:message-id:reply-to;
 bh=EDVXlhuG0g0Fb+VaMSnineXTFf0cCbB2rds5NqrAsJE=;
 b=P1UWcTKlXJLztBldH+q3IyU4c5+lt6Ea7pRZ4a/c+Co/HlcY/o77ONymYlEkmv24wJ
 H82e7/Y3J48cQNlIErdENbF9opf2QcK852vzfeHQC4utSu9HQFzlwqHkOPvJ8gWP574+
 LaWmrBhtIT6JAwuIEisw9VQyOLYeY4mx20+9X3cILYURIJq8mB4lcITw2LRgLTDLWZPW
 QvKZrJmhVocWXyWddqtXEMchVYBhrJFBKzcjb7GNC3n7fFusybHyYPmtV5SUp1B4X81Z
 kPP6mZJFVkq0YhbhHTo9qBFcL3G46Dhnoe4iAATci8/xjN3fXD3hiPfbP2kXhQZJoh76
 LnDA==
X-Gm-Message-State: AO0yUKWjmbhp6+O5oHcd6TEHO382G6Nwi5QgzBSW9cqYR99ei989IS6r
 v3yFOxyO/vPKW2viqk6ifj6JLfw0Y1SGYnDyxrQ5ZUeIM9faXHukauOf97iVliSvxlzT37Zy+54
 YcVe06HWJQTOqgT2501Urixp7Yj2jeMDhkCI4xYTSzTxYFjT9or3C77APj3EyBSqcpdNGCg==
X-Google-Smtp-Source: AK7set824Z/IM7j+vhBu/nwM1YGZeMLvdxHiXhy61HLUSujWetMR3WDmAzyrywTpfkVOHBpERN3Oyg==
X-Received: by 2002:ad4:5dc6:0:b0:56c:27b0:ed05 with SMTP id
 m6-20020ad45dc6000000b0056c27b0ed05mr213094qvh.45.1676319306137; 
 Mon, 13 Feb 2023 12:15:06 -0800 (PST)
Received: from localhost (pool-68-160-166-30.bstnma.fios.verizon.net.
 [68.160.166.30]) by smtp.gmail.com with ESMTPSA id
 k189-20020a3788c6000000b0071dc769d5e7sm10322698qkd.56.2023.02.13.12.15.05
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Mon, 13 Feb 2023 12:15:05 -0800 (PST)
From: Mike Snitzer <snitzer@kernel.org>
To: dm-devel@redhat.com
Date: Mon, 13 Feb 2023 15:13:45 -0500
Message-Id: <20230213201401.45973-24-snitzer@kernel.org>
In-Reply-To: <20230213201401.45973-1-snitzer@kernel.org>
References: <20230213201401.45973-1-snitzer@kernel.org>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.9
Subject: [dm-devel] [PATCH 23/39] dm: favour __aligned(N) versus
 "__attribute__ (aligned(N))"
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
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.3
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

From: Heinz Mauelshagen <heinzm@redhat.com>

Signed-off-by: Heinz Mauelshagen <heinzm@redhat.com>
Signed-off-by: Mike Snitzer <snitzer@kernel.org>
---
 drivers/md/dm-io.c                               | 2 +-
 drivers/md/persistent-data/dm-btree-internal.h   | 4 ++--
 drivers/md/persistent-data/dm-space-map-common.h | 8 ++++----
 3 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/md/dm-io.c b/drivers/md/dm-io.c
index faa8d0e1b460..9844edc1ae7c 100644
--- a/drivers/md/dm-io.c
+++ b/drivers/md/dm-io.c
@@ -39,7 +39,7 @@ struct io {
 	void *context;
 	void *vma_invalidate_address;
 	unsigned long vma_invalidate_size;
-} __attribute__((aligned(DM_IO_MAX_REGIONS)));
+} __aligned(DM_IO_MAX_REGIONS);
 
 static struct kmem_cache *_dm_io_cache;
 
diff --git a/drivers/md/persistent-data/dm-btree-internal.h b/drivers/md/persistent-data/dm-btree-internal.h
index bd353a00372d..62f8adf0b3eb 100644
--- a/drivers/md/persistent-data/dm-btree-internal.h
+++ b/drivers/md/persistent-data/dm-btree-internal.h
@@ -35,12 +35,12 @@ struct node_header {
 	__le32 max_entries;
 	__le32 value_size;
 	__le32 padding;
-} __attribute__((packed, aligned(8)));
+} __attribute__ ((packed)) __aligned(8);
 
 struct btree_node {
 	struct node_header header;
 	__le64 keys[];
-} __attribute__((packed, aligned(8)));
+} __attribute__ ((packed)) __aligned(8);
 
 
 /*
diff --git a/drivers/md/persistent-data/dm-space-map-common.h b/drivers/md/persistent-data/dm-space-map-common.h
index 292a91871d92..21755296fda7 100644
--- a/drivers/md/persistent-data/dm-space-map-common.h
+++ b/drivers/md/persistent-data/dm-space-map-common.h
@@ -34,7 +34,7 @@ struct disk_index_entry {
 	__le64 blocknr;
 	__le32 nr_free;
 	__le32 none_free_before;
-} __attribute__ ((packed, aligned(8)));
+} __attribute__ ((packed)) __aligned(8);
 
 
 #define MAX_METADATA_BITMAPS 255
@@ -44,7 +44,7 @@ struct disk_metadata_index {
 	__le64 blocknr;
 
 	struct disk_index_entry index[MAX_METADATA_BITMAPS];
-} __attribute__ ((packed, aligned(8)));
+} __attribute__ ((packed)) __aligned(8);
 
 struct ll_disk;
 
@@ -103,7 +103,7 @@ struct disk_sm_root {
 	__le64 nr_allocated;
 	__le64 bitmap_root;
 	__le64 ref_count_root;
-} __attribute__ ((packed, aligned(8)));
+} __attribute__ ((packed)) __aligned(8);
 
 #define ENTRIES_PER_BYTE 4
 
@@ -111,7 +111,7 @@ struct disk_bitmap_header {
 	__le32 csum;
 	__le32 not_used;
 	__le64 blocknr;
-} __attribute__ ((packed, aligned(8)));
+} __attribute__ ((packed)) __aligned(8);
 
 /*----------------------------------------------------------------*/
 
-- 
2.37.0 (Apple Git-136)

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

