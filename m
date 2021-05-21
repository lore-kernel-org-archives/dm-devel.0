Return-Path: <SRS0=3FFM=KT=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 57FF6C47083
	for <dm-devel@archiver.kernel.org>; Mon, 24 May 2021 06:47:24 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id C180561090
	for <dm-devel@archiver.kernel.org>; Mon, 24 May 2021 06:47:23 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org C180561090
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=canonical.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-494-E9PTZd0rN4SyQ1qyghOrtQ-1; Mon, 24 May 2021 02:47:20 -0400
X-MC-Unique: E9PTZd0rN4SyQ1qyghOrtQ-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 413E780293B;
	Mon, 24 May 2021 06:47:16 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id AA4A6100E113;
	Mon, 24 May 2021 06:47:15 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 0986C55340;
	Mon, 24 May 2021 06:47:12 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com
	[10.11.54.3])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 14L9pAH5015494 for <dm-devel@listman.util.phx.redhat.com>;
	Fri, 21 May 2021 05:51:10 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id 7B3B31003200; Fri, 21 May 2021 09:51:10 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast01.extmail.prod.ext.rdu2.redhat.com [10.11.55.17])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 77682100205D
	for <dm-devel@redhat.com>; Fri, 21 May 2021 09:51:07 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[205.139.110.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 9BC52858F0D
	for <dm-devel@redhat.com>; Fri, 21 May 2021 09:51:07 +0000 (UTC)
Received: from youngberry.canonical.com (youngberry.canonical.com
	[91.189.89.112]) (Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-34-sJhJmVwoPUiY7gWcq4LLrQ-1; Fri, 21 May 2021 05:51:03 -0400
X-MC-Unique: sJhJmVwoPUiY7gWcq4LLrQ-1
Received: from 1.general.cking.uk.vpn ([10.172.193.212] helo=localhost)
	by youngberry.canonical.com with esmtpsa (TLS1.2) tls
	TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256 (Exim 4.93)
	(envelope-from <colin.king@canonical.com>)
	id 1lk1o5-0005eY-OQ; Fri, 21 May 2021 09:51:01 +0000
From: Colin King <colin.king@canonical.com>
To: Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@redhat.com>,
	dm-devel@redhat.com, Joe Thornber <ejt@redhat.com>
Date: Fri, 21 May 2021 10:51:01 +0100
Message-Id: <20210521095101.42737-1-colin.king@canonical.com>
MIME-Version: 1.0
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.3
X-loop: dm-devel@redhat.com
X-Mailman-Approved-At: Mon, 24 May 2021 02:47:09 -0400
Cc: kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [dm-devel] [PATCH][V2][next] dm space maps: Fix uninitialized
	variable r2
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
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

From: Colin Ian King <colin.king@canonical.com>

In the case where recursing(mm) is true variable r2 is not
inintialized and an uninitialized value is being used in the
call combine_errors later on. Fix this by setting r2 to zero.

Addresses-Coverity: ("Uninitialized scalar variable")
Fixes: def6a7a9a7f0 ("dm space maps: improve performance with inc/dec on ranges of blocks")
Signed-off-by: Colin Ian King <colin.king@canonical.com>
---

V2: Add fix in function sm_metadata_inc_blocks

---
 drivers/md/persistent-data/dm-space-map-metadata.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/md/persistent-data/dm-space-map-metadata.c b/drivers/md/persistent-data/dm-space-map-metadata.c
index 3b70ee861cf5..a9a362777fad 100644
--- a/drivers/md/persistent-data/dm-space-map-metadata.c
+++ b/drivers/md/persistent-data/dm-space-map-metadata.c
@@ -417,6 +417,7 @@ static int sm_metadata_inc_blocks(struct dm_space_map *sm, dm_block_t b, dm_bloc
 		r = add_bop(smm, BOP_INC, b, e);
 		if (r)
 			return r;
+		r2 = 0;
 	} else {
 		in(smm);
 		r = sm_ll_inc(&smm->ll, b, e, &nr_allocations);
@@ -432,9 +433,10 @@ static int sm_metadata_dec_blocks(struct dm_space_map *sm, dm_block_t b, dm_bloc
 	int32_t nr_allocations;
 	struct sm_metadata *smm = container_of(sm, struct sm_metadata, sm);
 
-	if (recursing(smm))
+	if (recursing(smm)) {
 		r = add_bop(smm, BOP_DEC, b, e);
-	else {
+		r2 = 0;
+	} else {
 		in(smm);
 		r = sm_ll_dec(&smm->ll, b, e, &nr_allocations);
 		r2 = out(smm);
-- 
2.31.1

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

