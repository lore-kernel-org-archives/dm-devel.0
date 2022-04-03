Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 05AF9C433EF
	for <dm-devel@archiver.kernel.org>; Sun,  3 Apr 2022 18:38:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1649011113;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=KHqCtM62+ITv5Ep8JTGAvcSyUmrANOxg5HrpC2S1H1Q=;
	b=JYIOwdh3rcD23ZourlcM9c3NAr8lU7AjhlsxOsCD+PH/cN5/hikH09N46U5FmaJkV1GQZ1
	NDeKxRipCbUtNAFAYYJDMULtie/CSK8c60iGy2CBTLThoVTgxo+aQiufnn/5aF3d3aCFn/
	184ln4IaQhkkjZ9lI9FcKoiZJXWOHsk=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-346-_Ein59kCM7mxAaDdLhj9RQ-1; Sun, 03 Apr 2022 14:38:30 -0400
X-MC-Unique: _Ein59kCM7mxAaDdLhj9RQ-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 4F1E585A5A8;
	Sun,  3 Apr 2022 18:38:28 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id DCD9A145D85A;
	Sun,  3 Apr 2022 18:38:23 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 9F5461940363;
	Sun,  3 Apr 2022 18:38:23 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com
 [10.11.54.10])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id D36C51940362
 for <dm-devel@listman.corp.redhat.com>; Sun,  3 Apr 2022 18:38:22 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 98116463E0E; Sun,  3 Apr 2022 18:38:22 +0000 (UTC)
Received: from file01.intranet.prod.int.rdu2.redhat.com
 (file01.intranet.prod.int.rdu2.redhat.com [10.11.5.7])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 8E9CB463E0A;
 Sun,  3 Apr 2022 18:38:22 +0000 (UTC)
Received: from file01.intranet.prod.int.rdu2.redhat.com (localhost [127.0.0.1])
 by file01.intranet.prod.int.rdu2.redhat.com (8.14.4/8.14.4) with ESMTP id
 233IcM7s028955; Sun, 3 Apr 2022 14:38:22 -0400
Received: from localhost (mpatocka@localhost)
 by file01.intranet.prod.int.rdu2.redhat.com (8.14.4/8.14.4/Submit) with ESMTP
 id 233IcMRT028951; Sun, 3 Apr 2022 14:38:22 -0400
X-Authentication-Warning: file01.intranet.prod.int.rdu2.redhat.com: mpatocka
 owned process doing -bs
Date: Sun, 3 Apr 2022 14:38:22 -0400 (EDT)
From: Mikulas Patocka <mpatocka@redhat.com>
X-X-Sender: mpatocka@file01.intranet.prod.int.rdu2.redhat.com
To: Mike Snitzer <snitzer@redhat.com>
In-Reply-To: <alpine.LRH.2.02.2203311207540.22503@file01.intranet.prod.int.rdu2.redhat.com>
Message-ID: <alpine.LRH.2.02.2204031437430.28888@file01.intranet.prod.int.rdu2.redhat.com>
References: <alpine.LRH.2.02.2203301424570.11614@file01.intranet.prod.int.rdu2.redhat.com>
 <CAH6w=ayZoHOnN5Pj=BVbFhi5OweCy8bX3u6nKtL3PJoyLtQUHA@mail.gmail.com>
 <alpine.LRH.2.02.2203311207540.22503@file01.intranet.prod.int.rdu2.redhat.com>
User-Agent: Alpine 2.02 (LRH 1266 2009-07-14)
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.10
Subject: [dm-devel] [PATCH] dm-integrity: fix memory corruption when
 tag_size is less than the actual digest size
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
Cc: Ondrej Kozina <okozina@redhat.com>, dm-devel@redhat.com,
 Milan Broz <gmazyland@gmail.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.7
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

It is possible to set up dm-integrity in such a way that the "tag_size"
parameter is less than the actual digest size. In this situation, a part
of the digest beyond tag_size is ignored.

In this case, dm-integrity would write beyond the end of the
ic->recalc_tags array and corrupt memory. The corruption happened in
integrity_recalc->integrity_sector_checksum->crypto_shash_final.

This patch fixes the corruption.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Cc: stable@vger.kernel.org	# v4.19+

---
 drivers/md/dm-integrity.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

Index: linux-2.6/drivers/md/dm-integrity.c
===================================================================
--- linux-2.6.orig/drivers/md/dm-integrity.c	2022-04-02 14:17:13.000000000 +0200
+++ linux-2.6/drivers/md/dm-integrity.c	2022-04-02 14:43:06.000000000 +0200
@@ -4399,6 +4399,7 @@ try_smaller_buffer:
 	}
 
 	if (ic->internal_hash) {
+		size_t recalc_tags_size;
 		ic->recalc_wq = alloc_workqueue("dm-integrity-recalc", WQ_MEM_RECLAIM, 1);
 		if (!ic->recalc_wq ) {
 			ti->error = "Cannot allocate workqueue";
@@ -4412,8 +4413,10 @@ try_smaller_buffer:
 			r = -ENOMEM;
 			goto bad;
 		}
-		ic->recalc_tags = kvmalloc_array(RECALC_SECTORS >> ic->sb->log2_sectors_per_block,
-						 ic->tag_size, GFP_KERNEL);
+		recalc_tags_size = (RECALC_SECTORS >> ic->sb->log2_sectors_per_block) * ic->tag_size;
+		if (crypto_shash_digestsize(ic->internal_hash) > ic->tag_size)
+			recalc_tags_size += crypto_shash_digestsize(ic->internal_hash) - ic->tag_size;
+		ic->recalc_tags = kvmalloc(recalc_tags_size, GFP_KERNEL);
 		if (!ic->recalc_tags) {
 			ti->error = "Cannot allocate tags for recalculating";
 			r = -ENOMEM;

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

