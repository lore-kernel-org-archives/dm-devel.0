Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B5B39C677F1
	for <dm-devel@archiver.kernel.org>; Mon, 13 Feb 2023 20:15:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1676319333;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=zrqLNAPwFU7tKtqddhaWbUQ62Yst+4tBBNLCum1dp78=;
	b=Rryof4uU4yKJ0Gc79MWmSd5OLecR5Ybc2nF9O8d3doQ/Q2rqaFt6VvsyPWHptafYqj9RnX
	VCeU+nPPxT/KIKqmE72MwFhFGuS1Vdho/puwmKpGdCTXfngXzRT1YHWg+B3TLo8vF1fgge
	VmdwBmjq2dy2DJ7XzzYa0QOaGQmJLy4=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-332-c0CIs_YuNnuLOmPiY4g6bw-1; Mon, 13 Feb 2023 15:15:29 -0500
X-MC-Unique: c0CIs_YuNnuLOmPiY4g6bw-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id A1A1C18E5314;
	Mon, 13 Feb 2023 20:15:17 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 8CADB140EBF6;
	Mon, 13 Feb 2023 20:15:17 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 6DC41194658C;
	Mon, 13 Feb 2023 20:15:17 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com
 [10.11.54.9])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 1E6071946586
 for <dm-devel@listman.corp.redhat.com>; Mon, 13 Feb 2023 20:15:17 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 0596D492B04; Mon, 13 Feb 2023 20:15:17 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast03.extmail.prod.ext.rdu2.redhat.com [10.11.55.19])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id F20E3492B03
 for <dm-devel@redhat.com>; Mon, 13 Feb 2023 20:15:16 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [205.139.110.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 6918088B7A0
 for <dm-devel@redhat.com>; Mon, 13 Feb 2023 20:15:14 +0000 (UTC)
Received: from mail-qt1-f180.google.com (mail-qt1-f180.google.com
 [209.85.160.180]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-434-Pvrv9ublMbGkF4m1L_AofQ-2; Mon, 13 Feb 2023 15:15:08 -0500
X-MC-Unique: Pvrv9ublMbGkF4m1L_AofQ-2
Received: by mail-qt1-f180.google.com with SMTP id c2so15202956qtw.5
 for <dm-devel@redhat.com>; Mon, 13 Feb 2023 12:15:08 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=content-transfer-encoding:mime-version:references:in-reply-to
 :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
 :subject:date:message-id:reply-to;
 bh=cY+D71v1BE0wFBiYWcy3AbUu8Q56OZChC1YZo97Hp/4=;
 b=azGOCcy2QiFhpOMUFb5RQBhaFKy0qEGXSfSqoW9LixoXaLIMb8danFqwoJzVBEY9Hz
 gC2JxownKAD1wCg/+qZfwsiE5eFpx83P1/cCUCxUmL482dgRF26uI6uoN1AriQhMNhNj
 GwNduSWPKHUNOqt0gQ3IqzY3JBxc9EpMNFTybAdyetYKGcaxamGHM4d1ckIgKcbBjMzb
 h4MXdAvV1qlyIpvCA/SugtzR/+VZpx/GpSsGvsQK6JtAg8EqPoH0jHBfWRP//JPA6gUi
 Fmg1F6toLNoty8xzlsHJsa1Dftk/eulHwFZvNn95CTgTGF097y6VP/GcOeyb5EA7Nvob
 S7TA==
X-Gm-Message-State: AO0yUKUfgcEVVEQsqo2on0EDm7rqIvURU7lM9CnYdHuqD5DpbrZOOoiJ
 qPdwhzLiQn7PekS0/0LiSXc42TtKcwTpFZpXbU619H4b9K0u5ZNBbDoK0KDQfh35U1zck81Qu8Q
 Zi+VKW4aFnhiyC775fAnUs2dXKDTsxdmw9HFKN7sQTEJ8JkhuuRVjSjcIidGBFrVesPf9ZA==
X-Google-Smtp-Source: AK7set9giLNH36guLzn1f4PAXziJdXGSEniwHVjbenAEumRMQCWFPeVhDXQLufQ5PckEPC1L0LQMHg==
X-Received: by 2002:a05:622a:18a:b0:3b6:45f1:4933 with SMTP id
 s10-20020a05622a018a00b003b645f14933mr45429863qtw.66.1676319307605; 
 Mon, 13 Feb 2023 12:15:07 -0800 (PST)
Received: from localhost (pool-68-160-166-30.bstnma.fios.verizon.net.
 [68.160.166.30]) by smtp.gmail.com with ESMTPSA id
 t71-20020a37aa4a000000b006fc2f74ad12sm10509086qke.92.2023.02.13.12.15.07
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Mon, 13 Feb 2023 12:15:07 -0800 (PST)
From: Mike Snitzer <snitzer@kernel.org>
To: dm-devel@redhat.com
Date: Mon, 13 Feb 2023 15:13:46 -0500
Message-Id: <20230213201401.45973-25-snitzer@kernel.org>
In-Reply-To: <20230213201401.45973-1-snitzer@kernel.org>
References: <20230213201401.45973-1-snitzer@kernel.org>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.9
Subject: [dm-devel] [PATCH 24/39] dm: favour __packed versus "__attribute__
 ((packed))"
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
 drivers/md/persistent-data/dm-btree-internal.h   | 4 ++--
 drivers/md/persistent-data/dm-space-map-common.h | 8 ++++----
 2 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/md/persistent-data/dm-btree-internal.h b/drivers/md/persistent-data/dm-btree-internal.h
index 62f8adf0b3eb..7ced7c8a647a 100644
--- a/drivers/md/persistent-data/dm-btree-internal.h
+++ b/drivers/md/persistent-data/dm-btree-internal.h
@@ -35,12 +35,12 @@ struct node_header {
 	__le32 max_entries;
 	__le32 value_size;
 	__le32 padding;
-} __attribute__ ((packed)) __aligned(8);
+} __packed __aligned(8);
 
 struct btree_node {
 	struct node_header header;
 	__le64 keys[];
-} __attribute__ ((packed)) __aligned(8);
+} __packed __aligned(8);
 
 
 /*
diff --git a/drivers/md/persistent-data/dm-space-map-common.h b/drivers/md/persistent-data/dm-space-map-common.h
index 21755296fda7..d197f4577ea0 100644
--- a/drivers/md/persistent-data/dm-space-map-common.h
+++ b/drivers/md/persistent-data/dm-space-map-common.h
@@ -34,7 +34,7 @@ struct disk_index_entry {
 	__le64 blocknr;
 	__le32 nr_free;
 	__le32 none_free_before;
-} __attribute__ ((packed)) __aligned(8);
+} __packed __aligned(8);
 
 
 #define MAX_METADATA_BITMAPS 255
@@ -44,7 +44,7 @@ struct disk_metadata_index {
 	__le64 blocknr;
 
 	struct disk_index_entry index[MAX_METADATA_BITMAPS];
-} __attribute__ ((packed)) __aligned(8);
+} __packed __aligned(8);
 
 struct ll_disk;
 
@@ -103,7 +103,7 @@ struct disk_sm_root {
 	__le64 nr_allocated;
 	__le64 bitmap_root;
 	__le64 ref_count_root;
-} __attribute__ ((packed)) __aligned(8);
+} __packed __aligned(8);
 
 #define ENTRIES_PER_BYTE 4
 
@@ -111,7 +111,7 @@ struct disk_bitmap_header {
 	__le32 csum;
 	__le32 not_used;
 	__le64 blocknr;
-} __attribute__ ((packed)) __aligned(8);
+} __packed __aligned(8);
 
 /*----------------------------------------------------------------*/
 
-- 
2.37.0 (Apple Git-136)

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

