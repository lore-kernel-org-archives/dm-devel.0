Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 34C10C64ED8
	for <dm-devel@archiver.kernel.org>; Mon, 13 Feb 2023 20:15:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1676319339;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=SfPHOLYReJIO0Gj8LuIw9Yu25vC9Z7U8EvxzZ1CJVr8=;
	b=BBIsLt7O7sNGj1lLkScP5F9qiLma45Xh4YXyyFaoyqFHsC/DEeYdpopeMfzxEsKxnG900d
	Z94oR3UHNHk3F4rxBkDrEDZN5uIFvvrD6UNciaFfef/KePWhHOxfCwgHHmNySWP0VtrP2s
	o6+RZIEv9qe55e05/ZAToc7cyXLHxgQ=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-369-vFlilOQHN9mKib1BjTvKRg-1; Mon, 13 Feb 2023 15:15:36 -0500
X-MC-Unique: vFlilOQHN9mKib1BjTvKRg-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 4F4E9100F915;
	Mon, 13 Feb 2023 20:15:30 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 088512026D76;
	Mon, 13 Feb 2023 20:15:30 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id B9BDC19465A8;
	Mon, 13 Feb 2023 20:15:29 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
 [10.11.54.6])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 2FF6C1946586
 for <dm-devel@listman.corp.redhat.com>; Mon, 13 Feb 2023 20:15:29 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 265092166B29; Mon, 13 Feb 2023 20:15:29 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast09.extmail.prod.ext.rdu2.redhat.com [10.11.55.25])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 200562166B26
 for <dm-devel@redhat.com>; Mon, 13 Feb 2023 20:15:29 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [205.139.110.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 05CA72A5957D
 for <dm-devel@redhat.com>; Mon, 13 Feb 2023 20:15:29 +0000 (UTC)
Received: from mail-qt1-f182.google.com (mail-qt1-f182.google.com
 [209.85.160.182]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-58-lXiTMZRJPX6KMyPXZ5CJwg-1; Mon, 13 Feb 2023 15:15:26 -0500
X-MC-Unique: lXiTMZRJPX6KMyPXZ5CJwg-1
Received: by mail-qt1-f182.google.com with SMTP id ch10so14078152qtb.11
 for <dm-devel@redhat.com>; Mon, 13 Feb 2023 12:15:24 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=content-transfer-encoding:mime-version:references:in-reply-to
 :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
 :subject:date:message-id:reply-to;
 bh=o7imtIR5gIFDAvHjevwwDpf7zAjcZf+aOnhy+yd60oM=;
 b=IyNyy0YCNEQr49TT6uT5wnIKiLQpIxqEGrmPBX0w7wgYpeVETdvTRSyYBlFbBVmigY
 RyubRXY6dQSPFybysPsrXqzUEtVhpruTL15v5DLDwUg2q4FuF20haZAJIABE3fn7sZx9
 6sbfmZZNtxC1L+PsJEjQ95XZDsGqJCUN0y1XaYsiRtdy9EqtKeCiK2XL53SXyEWjoX8v
 blNzmu1z5OeQm/3bgOveX7HlN5zu+xMO+2GQ4RiifzFTrbDYm76QqKLZiyEhyy1jwPND
 70ocbi9GgfEx/voRRzaADmpVMvC1eJfCleDrteRcy8jv17IEaQBXaPDbj1Bl253F5USz
 yThg==
X-Gm-Message-State: AO0yUKXRqhHQkj9HjxBTscTrzdlHxWayKCLBJFaD33MSgj3AhaxkkG8G
 MJ8LDe5y4B/mBCQzBmHnmFESvbxYTHSKXqIXU6TmRkU95nl/zyZaECaMeXX6Hjwdya/0P7Karev
 csvAJG7NwULuZRxkHSzBS4nvNpkAymqMz8Z0V4nQJIUqh8AB934igvtNKitzmp90ujS1nvA==
X-Google-Smtp-Source: AK7set95O8GnC6RVfDp43OKKdFu4fKxWpG8lk9iV6Ave0aM+ju7zQK+a3YXpnzayH4IDHxy935ifBQ==
X-Received: by 2002:a05:622a:11ca:b0:3b8:6054:d41d with SMTP id
 n10-20020a05622a11ca00b003b86054d41dmr45440195qtk.28.1676319323584; 
 Mon, 13 Feb 2023 12:15:23 -0800 (PST)
Received: from localhost (pool-68-160-166-30.bstnma.fios.verizon.net.
 [68.160.166.30]) by smtp.gmail.com with ESMTPSA id
 s184-20020ae9dec1000000b0073b38652b9csm3419038qkf.122.2023.02.13.12.15.22
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Mon, 13 Feb 2023 12:15:23 -0800 (PST)
From: Mike Snitzer <snitzer@kernel.org>
To: dm-devel@redhat.com
Date: Mon, 13 Feb 2023 15:13:56 -0500
Message-Id: <20230213201401.45973-35-snitzer@kernel.org>
In-Reply-To: <20230213201401.45973-1-snitzer@kernel.org>
References: <20230213201401.45973-1-snitzer@kernel.org>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.6
Subject: [dm-devel] [PATCH 34/39] dm integrity: change macros min/max() ->
 min_t/max_t where appropriate
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
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.4
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

From: Heinz Mauelshagen <heinzm@redhat.com>

Signed-off-by: Heinz Mauelshagen <heinzm@redhat.com>
Signed-off-by: Mike Snitzer <snitzer@kernel.org>
---
 drivers/md/dm-integrity.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/md/dm-integrity.c b/drivers/md/dm-integrity.c
index b70defcdd982..16aa68988363 100644
--- a/drivers/md/dm-integrity.c
+++ b/drivers/md/dm-integrity.c
@@ -1730,7 +1730,7 @@ static void integrity_metadata(struct work_struct *w)
 		struct bio *bio = dm_bio_from_per_bio_data(dio, sizeof(struct dm_integrity_io));
 		char *checksums;
 		unsigned int extra_space = unlikely(digest_size > ic->tag_size) ? digest_size - ic->tag_size : 0;
-		char checksums_onstack[max((size_t)HASH_MAX_DIGESTSIZE, MAX_TAG_SIZE)];
+		char checksums_onstack[max_t(size_t, HASH_MAX_DIGESTSIZE, MAX_TAG_SIZE)];
 		sector_t sector;
 		unsigned int sectors_to_process;
 
@@ -2015,7 +2015,7 @@ static bool __journal_read_write(struct dm_integrity_io *dio, struct bio *bio,
 				} while (++s < ic->sectors_per_block);
 #ifdef INTERNAL_VERIFY
 				if (ic->internal_hash) {
-					char checksums_onstack[max((size_t)HASH_MAX_DIGESTSIZE, MAX_TAG_SIZE)];
+					char checksums_onstack[max_t(size_t, HASH_MAX_DIGESTSIZE, MAX_TAG_SIZE)];
 
 					integrity_sector_checksum(ic, logical_sector, mem + bv.bv_offset, checksums_onstack);
 					if (unlikely(memcmp(checksums_onstack, journal_entry_tag(ic, je), ic->tag_size))) {
@@ -3530,8 +3530,8 @@ static int initialize_superblock(struct dm_integrity_c *ic,
 		if (!interleave_sectors)
 			interleave_sectors = DEFAULT_INTERLEAVE_SECTORS;
 		ic->sb->log2_interleave_sectors = __fls(interleave_sectors);
-		ic->sb->log2_interleave_sectors = max((__u8)MIN_LOG2_INTERLEAVE_SECTORS, ic->sb->log2_interleave_sectors);
-		ic->sb->log2_interleave_sectors = min((__u8)MAX_LOG2_INTERLEAVE_SECTORS, ic->sb->log2_interleave_sectors);
+		ic->sb->log2_interleave_sectors = max_t(__u8, MIN_LOG2_INTERLEAVE_SECTORS, ic->sb->log2_interleave_sectors);
+		ic->sb->log2_interleave_sectors = min_t(__u8, MAX_LOG2_INTERLEAVE_SECTORS, ic->sb->log2_interleave_sectors);
 
 		get_provided_data_sectors(ic);
 		if (!ic->provided_data_sectors)
@@ -3921,7 +3921,7 @@ static int create_journal(struct dm_integrity_c *ic, char **error)
 
 				memset(crypt_iv, 0x00, ivsize);
 				memset(crypt_data, 0x00, crypt_len);
-				memcpy(crypt_data, &section_le, min((size_t)crypt_len, sizeof(section_le)));
+				memcpy(crypt_data, &section_le, min_t(size_t, crypt_len, sizeof(section_le)));
 
 				sg_init_one(&sg, crypt_data, crypt_len);
 				skcipher_request_set_crypt(req, &sg, &sg, crypt_len, crypt_iv);
-- 
2.37.0 (Apple Git-136)

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

