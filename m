Return-Path: <SRS0=f+1/=ER=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BF221C388F9
	for <dm-devel@archiver.kernel.org>; Wed, 11 Nov 2020 18:41:20 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 1B463205CA
	for <dm-devel@archiver.kernel.org>; Wed, 11 Nov 2020 18:41:19 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 1B463205CA
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=veeam.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-443-jY_OJQpdMAmNxdj7SIjwxQ-1; Wed, 11 Nov 2020 13:41:16 -0500
X-MC-Unique: jY_OJQpdMAmNxdj7SIjwxQ-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 4EAF01074659;
	Wed, 11 Nov 2020 18:41:11 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 31EA25C1C4;
	Wed, 11 Nov 2020 18:41:11 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 0161C181A06D;
	Wed, 11 Nov 2020 18:41:11 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com
	[10.11.54.3])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 0ABCtium001231 for <dm-devel@listman.util.phx.redhat.com>;
	Wed, 11 Nov 2020 07:55:44 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 8FA1B10F1CD9; Wed, 11 Nov 2020 12:55:44 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast01.extmail.prod.ext.rdu2.redhat.com [10.11.55.17])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 8BC9F100404F
	for <dm-devel@redhat.com>; Wed, 11 Nov 2020 12:55:41 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[205.139.110.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 3EAEA858290
	for <dm-devel@redhat.com>; Wed, 11 Nov 2020 12:55:41 +0000 (UTC)
Received: from mx4.veeam.com (mx4.veeam.com [104.41.138.86]) (Using TLS) by
	relay.mimecast.com with ESMTP id us-mta-406-SNPdepi4MGCF-yTp4u4_uw-1;
	Wed, 11 Nov 2020 07:55:39 -0500
X-MC-Unique: SNPdepi4MGCF-yTp4u4_uw-1
Received: from mail.veeam.com (prgmbx01.amust.local [172.24.0.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mx4.veeam.com (Postfix) with ESMTPS id 1CA0992315;
	Wed, 11 Nov 2020 15:55:38 +0300 (MSK)
Received: from prgdevlinuxpatch01.amust.local (172.24.14.5) by
	prgmbx01.amust.local (172.24.0.171) with Microsoft SMTP Server
	(version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
	15.2.721.2; Wed, 11 Nov 2020 13:55:36 +0100
From: Sergei Shtepa <sergei.shtepa@veeam.com>
To: <agk@redhat.com>, <snitzer@redhat.com>, <dm-devel@redhat.com>,
	<linux-kernel@vger.kernel.org>
Date: Wed, 11 Nov 2020 15:55:46 +0300
Message-ID: <1605099346-3199-2-git-send-email-sergei.shtepa@veeam.com>
In-Reply-To: <1605099346-3199-1-git-send-email-sergei.shtepa@veeam.com>
References: <1605099346-3199-1-git-send-email-sergei.shtepa@veeam.com>
MIME-Version: 1.0
X-Originating-IP: [172.24.14.5]
X-ClientProxiedBy: prgmbx01.amust.local (172.24.0.171) To prgmbx01.amust.local
	(172.24.0.171)
X-EsetResult: clean, is OK
X-EsetId: 37303A29C604D26A617667
X-Veeam-MMEX: True
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
X-Mailman-Approved-At: Wed, 11 Nov 2020 13:39:49 -0500
Cc: Sergei Shtepa <sergei.shtepa@veeam.com>
Subject: [dm-devel] [PATCH 1/1] Fix bug with RCU locking in
	dm_blk_report_zones().
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
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

The dm_get_live_table() function makes RCU read lock and
dm_put_live_table() should call even when dm_table map was not found.

Signed-off-by: Sergei Shtepa <sergei.shtepa@veeam.com>
---
 drivers/md/dm.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/md/dm.c b/drivers/md/dm.c
index c18fc2548518..98866e725f25 100644
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -476,8 +476,10 @@ static int dm_blk_report_zones(struct gendisk *disk, sector_t sector,
 		return -EAGAIN;
 
 	map = dm_get_live_table(md, &srcu_idx);
-	if (!map)
-		return -EIO;
+	if (!map) {
+		ret = -EIO;
+		goto out;
+	}
 
 	do {
 		struct dm_target *tgt;
-- 
2.20.1

--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel

