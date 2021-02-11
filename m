Return-Path: <SRS0=OsX1=HN=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6C277C433E0
	for <dm-devel@archiver.kernel.org>; Thu, 11 Feb 2021 14:23:16 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 958E964ED7
	for <dm-devel@archiver.kernel.org>; Thu, 11 Feb 2021 14:23:15 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 958E964ED7
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=arrikto.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-393-Pv3OhnIiOpG3OHH7c6Be2Q-1; Thu, 11 Feb 2021 09:23:12 -0500
X-MC-Unique: Pv3OhnIiOpG3OHH7c6Be2Q-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 699DF6D50A;
	Thu, 11 Feb 2021 14:23:05 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 1CD421F438;
	Thu, 11 Feb 2021 14:23:05 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 3FEF718095CC;
	Thu, 11 Feb 2021 14:23:04 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
	[10.11.54.6])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 11BEN2m7008421 for <dm-devel@listman.util.phx.redhat.com>;
	Thu, 11 Feb 2021 09:23:02 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 0F2112166B31; Thu, 11 Feb 2021 14:23:02 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast01.extmail.prod.ext.rdu2.redhat.com [10.11.55.17])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 0912D2166B2E
	for <dm-devel@redhat.com>; Thu, 11 Feb 2021 14:22:59 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [207.211.31.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 849C0858F18
	for <dm-devel@redhat.com>; Thu, 11 Feb 2021 14:22:59 +0000 (UTC)
Received: from mail-wr1-f46.google.com (mail-wr1-f46.google.com
	[209.85.221.46]) (Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-425-v5Dq53BkPjGIj8-wTELH0g-1; Thu, 11 Feb 2021 09:22:57 -0500
X-MC-Unique: v5Dq53BkPjGIj8-wTELH0g-1
Received: by mail-wr1-f46.google.com with SMTP id 7so4397735wrz.0
	for <dm-devel@redhat.com>; Thu, 11 Feb 2021 06:22:57 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=1e100.net; s=20161025;
	h=x-gm-message-state:from:to:cc:subject:date:message-id;
	bh=/+FjXm5M90vS44To6kunQvddPMUijBc/z7y0WMHzOoI=;
	b=ZbTBYnUbSb+n6F/llEt0HLkXuANDby4wK1A+Carn3aqsy3a/nLBSb4oVANhf1y8cEv
	Rvhh/goLlgVQRNyQw7n48U+ESEE66Zntd3nxM0sZ46dBCk5gDTn/4EXTHWeR4t6JpHB9
	VoBoOrRvZ1S0rRybonfzCXBRmHRqped+Oea/CnxAT/rco2PX3282P0+Wj2lXNYc6oDx3
	Zaqyd9ZAM9QcWbTHrrX1EKfjtWhtDZ6Y8vFONdq5tHI12A7FPFY9h3yCdUvDoxTmLPm/
	1JHQcjBhTwfwwSSpGxu7Og/BXIn11tzQeDx6U0MIc1W7xyrvzEc+9Cp4VdjW6nWjCGXG
	monA==
X-Gm-Message-State: AOAM531new1Ha6CKSlI1z/tWWxbYsAStZ8whT8a75S2p1H3R3G9pZG1c
	1g6Jui3CXBHOyW+drq11MAne+w==
X-Google-Smtp-Source: ABdhPJy5NpIXEP44aaSlASOzr0bKt6X7KUjOeohsBJAQ+waj1tSQHHDRbBAlCNAe2gc+KXe02NxsdA==
X-Received: by 2002:a5d:4dd2:: with SMTP id f18mr6147071wru.115.1613053376495; 
	Thu, 11 Feb 2021 06:22:56 -0800 (PST)
Received: from snf-864.vm.snf.arr ([31.177.62.212])
	by smtp.gmail.com with ESMTPSA id
	c11sm5209909wrs.28.2021.02.11.06.22.55
	(version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
	Thu, 11 Feb 2021 06:22:55 -0800 (PST)
From: Nikos Tsironis <ntsironis@arrikto.com>
To: snitzer@redhat.com, agk@redhat.com, dm-devel@redhat.com
Date: Thu, 11 Feb 2021 16:22:43 +0200
Message-Id: <20210211142243.31062-1-ntsironis@arrikto.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.6
X-loop: dm-devel@redhat.com
Cc: ntsironis@arrikto.com
Subject: [dm-devel] [PATCH v2] dm era: only resize metadata in preresume
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
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Metadata resize shouldn't happen in the ctr. The ctr loads a temporary
(inactive) table that will only become active upon resume. That is why
resize should always be done in terms of resume. Otherwise a load (ctr)
whose inactive table never becomes active will incorrectly resize the
metadata.

Also, perform the resize directly in preresume, instead of using the
worker to do it.

The worker might run other metadata operations, e.g., it could start
digestion, before resizing the metadata. These operations will end up
using the old size.

This could lead to errors, like:

  device-mapper: era: metadata_digest_transcribe_writeset: dm_array_set_value failed
  device-mapper: era: process_old_eras: digest step failed, stopping digestion

The reason of the above error is that the worker started the digestion
of the archived writeset using the old, larger size.

As a result, metadata_digest_transcribe_writeset tried to write beyond
the end of the era array.

Fixes: eec40579d84873 ("dm: add era target")
Cc: stable@vger.kernel.org # v3.15+
Signed-off-by: Nikos Tsironis <ntsironis@arrikto.com>
---
 drivers/md/dm-era-target.c | 21 ++++++++++-----------
 1 file changed, 10 insertions(+), 11 deletions(-)

diff --git a/drivers/md/dm-era-target.c b/drivers/md/dm-era-target.c
index d0e75fd31c1e..d9ac7372108c 100644
--- a/drivers/md/dm-era-target.c
+++ b/drivers/md/dm-era-target.c
@@ -1501,15 +1501,6 @@ static int era_ctr(struct dm_target *ti, unsigned argc, char **argv)
 	}
 	era->md = md;
 
-	era->nr_blocks = calc_nr_blocks(era);
-
-	r = metadata_resize(era->md, &era->nr_blocks);
-	if (r) {
-		ti->error = "couldn't resize metadata";
-		era_destroy(era);
-		return -ENOMEM;
-	}
-
 	era->wq = alloc_ordered_workqueue("dm-" DM_MSG_PREFIX, WQ_MEM_RECLAIM);
 	if (!era->wq) {
 		ti->error = "could not create workqueue for metadata object";
@@ -1584,9 +1575,17 @@ static int era_preresume(struct dm_target *ti)
 	dm_block_t new_size = calc_nr_blocks(era);
 
 	if (era->nr_blocks != new_size) {
-		r = in_worker1(era, metadata_resize, &new_size);
-		if (r)
+		r = metadata_resize(era->md, &new_size);
+		if (r) {
+			DMERR("%s: metadata_resize failed", __func__);
 			return r;
+		}
+
+		r = metadata_commit(era->md);
+		if (r) {
+			DMERR("%s: metadata_commit failed", __func__);
+			return r;
+		}
 
 		era->nr_blocks = new_size;
 	}
-- 
2.11.0

--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel

