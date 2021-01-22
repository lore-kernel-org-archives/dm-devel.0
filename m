Return-Path: <SRS0=voF8=GZ=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E26FEC433E9
	for <dm-devel@archiver.kernel.org>; Fri, 22 Jan 2021 15:20:09 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 9D34C23AAA
	for <dm-devel@archiver.kernel.org>; Fri, 22 Jan 2021 15:20:08 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 9D34C23AAA
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=arrikto.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-333-Iu5V-PYPPb2mPol5mksiGg-1; Fri, 22 Jan 2021 10:20:04 -0500
X-MC-Unique: Iu5V-PYPPb2mPol5mksiGg-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 5927F107ACE3;
	Fri, 22 Jan 2021 15:19:58 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 59552100239A;
	Fri, 22 Jan 2021 15:19:57 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 625874E58E;
	Fri, 22 Jan 2021 15:19:55 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
	[10.11.54.5])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 10MFJrkf027997 for <dm-devel@listman.util.phx.redhat.com>;
	Fri, 22 Jan 2021 10:19:53 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 16C1FEE854; Fri, 22 Jan 2021 15:19:53 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast01.extmail.prod.ext.rdu2.redhat.com [10.11.55.17])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 107FDEE84C
	for <dm-devel@redhat.com>; Fri, 22 Jan 2021 15:19:49 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[207.211.31.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id AB57E858280
	for <dm-devel@redhat.com>; Fri, 22 Jan 2021 15:19:49 +0000 (UTC)
Received: from mail-wm1-f41.google.com (mail-wm1-f41.google.com
	[209.85.128.41]) (Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-275-VLySmBdjOASum9HqC_5jvQ-1; Fri, 22 Jan 2021 10:19:47 -0500
X-MC-Unique: VLySmBdjOASum9HqC_5jvQ-1
Received: by mail-wm1-f41.google.com with SMTP id v184so4660290wma.1
	for <dm-devel@redhat.com>; Fri, 22 Jan 2021 07:19:46 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=1e100.net; s=20161025;
	h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
	:references;
	bh=febDwTYPWvnuIz8Mt7aixV3uURSD/6AX0oqu2hVKJ3U=;
	b=so1AtmIjj77EuQW2AQtLWHUsPZT/z2obXGnYxzCtjfKc7alrNusItpT7yd3EkPsKMC
	P6JN5QNVJL2pzgdW9AoCfhisCFA+XvYUb+zUvPbrxo0EUYC4bHzFmbohS8NXmQqluD/7
	Lfz7a5YmZUsxcjRlfM0IkqFO95eP/rDU3zvzEagKBTHVpRPngOnsLDTlYKGTcMoSfx9R
	81LM/cVJOSI3IuPx5nHKdInw4nd8agTDRRIPTQRTiuwxKByV/Gk79J/sZav3sKS9l0ge
	klqxkng4xpdg6n1EPNat6yqizSyxz4nBl3XS99AGYxiJsXey5JldmYrJXuBm7lnRWFIr
	gZqg==
X-Gm-Message-State: AOAM532KeUN8fhWn3cVHDALcata182oIun+DsW+iC+g3ysHUCKlHUXe/
	LvLWjyuJokipWeinNL4FdKVAkw==
X-Google-Smtp-Source: ABdhPJyrSgWgLgrydsedHy4GJANGM2zLAAB2SXC8mkTugu4+nmVmq9TwtDOQCHvmG8eSyBJuKtFrhA==
X-Received: by 2002:a7b:c31a:: with SMTP id k26mr4400479wmj.72.1611328785877; 
	Fri, 22 Jan 2021 07:19:45 -0800 (PST)
Received: from snf-864.vm.snf.arr ([31.177.62.212])
	by smtp.gmail.com with ESMTPSA id
	j13sm11526650wmi.24.2021.01.22.07.19.44
	(version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
	Fri, 22 Jan 2021 07:19:44 -0800 (PST)
From: Nikos Tsironis <ntsironis@arrikto.com>
To: snitzer@redhat.com, agk@redhat.com, dm-devel@redhat.com
Date: Fri, 22 Jan 2021 17:19:30 +0200
Message-Id: <20210122151931.24645-2-ntsironis@arrikto.com>
In-Reply-To: <20210122151931.24645-1-ntsironis@arrikto.com>
References: <20210122151931.24645-1-ntsironis@arrikto.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.79 on 10.11.54.5
X-loop: dm-devel@redhat.com
Cc: ejt@redhat.com, ntsironis@arrikto.com
Subject: [dm-devel] [PATCH 1/2] dm era: Recover committed writeset after
	crash
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
MIME-Version: 1.0
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Following a system crash, dm-era fails to recover the committed writeset
for the current era, leading to lost writes. That is, we lose the
information about what blocks were written during the affected era.

dm-era assumes that the writeset of the current era is archived when the
device is suspended. So, when resuming the device, it just moves on to
the next era, ignoring the committed writeset.

This assumption holds when the device is properly shut down. But, when
the system crashes, the code that suspends the target never runs, so the
writeset for the current era is not archived.

There are three issues that cause the committed writeset to get lost:

1. dm-era doesn't load the committed writeset when opening the metadata
2. The code that resizes the metadata wipes the information about the
   committed writeset (assuming it was loaded at step 1)
3. era_preresume() starts a new era, without taking into account that
   the current era might not have been archived, due to a system crash.

To fix this:

1. Load the committed writeset when opening the metadata
2. Fix the code that resizes the metadata to make sure it doesn't wipe
   the loaded writeset
3. Fix era_preresume() to check for a loaded writeset and archive it,
   before starting a new era.

Fixes: eec40579d84873 ("dm: add era target")
Cc: stable@vger.kernel.org # v3.15+
Signed-off-by: Nikos Tsironis <ntsironis@arrikto.com>
---
 drivers/md/dm-era-target.c | 17 +++++++++--------
 1 file changed, 9 insertions(+), 8 deletions(-)

diff --git a/drivers/md/dm-era-target.c b/drivers/md/dm-era-target.c
index b24e3839bb3a..854b1be8b452 100644
--- a/drivers/md/dm-era-target.c
+++ b/drivers/md/dm-era-target.c
@@ -71,8 +71,6 @@ static size_t bitset_size(unsigned nr_bits)
  */
 static int writeset_alloc(struct writeset *ws, dm_block_t nr_blocks)
 {
-	ws->md.nr_bits = nr_blocks;
-	ws->md.root = INVALID_WRITESET_ROOT;
 	ws->bits = vzalloc(bitset_size(nr_blocks));
 	if (!ws->bits) {
 		DMERR("%s: couldn't allocate in memory bitset", __func__);
@@ -85,12 +83,14 @@ static int writeset_alloc(struct writeset *ws, dm_block_t nr_blocks)
 /*
  * Wipes the in-core bitset, and creates a new on disk bitset.
  */
-static int writeset_init(struct dm_disk_bitset *info, struct writeset *ws)
+static int writeset_init(struct dm_disk_bitset *info, struct writeset *ws,
+			 dm_block_t nr_blocks)
 {
 	int r;
 
-	memset(ws->bits, 0, bitset_size(ws->md.nr_bits));
+	memset(ws->bits, 0, bitset_size(nr_blocks));
 
+	ws->md.nr_bits = nr_blocks;
 	r = setup_on_disk_bitset(info, ws->md.nr_bits, &ws->md.root);
 	if (r) {
 		DMERR("%s: setup_on_disk_bitset failed", __func__);
@@ -579,6 +579,7 @@ static int open_metadata(struct era_metadata *md)
 	md->nr_blocks = le32_to_cpu(disk->nr_blocks);
 	md->current_era = le32_to_cpu(disk->current_era);
 
+	ws_unpack(&disk->current_writeset, &md->current_writeset->md);
 	md->writeset_tree_root = le64_to_cpu(disk->writeset_tree_root);
 	md->era_array_root = le64_to_cpu(disk->era_array_root);
 	md->metadata_snap = le64_to_cpu(disk->metadata_snap);
@@ -870,7 +871,6 @@ static int metadata_era_archive(struct era_metadata *md)
 	}
 
 	ws_pack(&md->current_writeset->md, &value);
-	md->current_writeset->md.root = INVALID_WRITESET_ROOT;
 
 	keys[0] = md->current_era;
 	__dm_bless_for_disk(&value);
@@ -882,6 +882,7 @@ static int metadata_era_archive(struct era_metadata *md)
 		return r;
 	}
 
+	md->current_writeset->md.root = INVALID_WRITESET_ROOT;
 	md->archived_writesets = true;
 
 	return 0;
@@ -898,7 +899,7 @@ static int metadata_new_era(struct era_metadata *md)
 	int r;
 	struct writeset *new_writeset = next_writeset(md);
 
-	r = writeset_init(&md->bitset_info, new_writeset);
+	r = writeset_init(&md->bitset_info, new_writeset, md->nr_blocks);
 	if (r) {
 		DMERR("%s: writeset_init failed", __func__);
 		return r;
@@ -951,7 +952,7 @@ static int metadata_commit(struct era_metadata *md)
 	int r;
 	struct dm_block *sblock;
 
-	if (md->current_writeset->md.root != SUPERBLOCK_LOCATION) {
+	if (md->current_writeset->md.root != INVALID_WRITESET_ROOT) {
 		r = dm_bitset_flush(&md->bitset_info, md->current_writeset->md.root,
 				    &md->current_writeset->md.root);
 		if (r) {
@@ -1565,7 +1566,7 @@ static int era_preresume(struct dm_target *ti)
 
 	start_worker(era);
 
-	r = in_worker0(era, metadata_new_era);
+	r = in_worker0(era, metadata_era_rollover);
 	if (r) {
 		DMERR("%s: metadata_era_rollover failed", __func__);
 		return r;
-- 
2.11.0

--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel

