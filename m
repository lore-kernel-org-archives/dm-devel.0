Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EC8BBC433FE
	for <dm-devel@archiver.kernel.org>; Thu, 10 Feb 2022 08:19:03 +0000 (UTC)
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-661-lSdu-92vOeS0gzvW9PyFNg-1; Thu, 10 Feb 2022 03:18:45 -0500
X-MC-Unique: lSdu-92vOeS0gzvW9PyFNg-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 791871091DA1;
	Thu, 10 Feb 2022 08:18:41 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 5BF401042A56;
	Thu, 10 Feb 2022 08:18:41 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 326911806D2B;
	Thu, 10 Feb 2022 08:18:41 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com
	[10.11.54.1])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 2199fBPR025332 for <dm-devel@listman.util.phx.redhat.com>;
	Wed, 9 Feb 2022 04:41:11 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 789F540FF69C; Wed,  9 Feb 2022 09:41:11 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast09.extmail.prod.ext.rdu2.redhat.com [10.11.55.25])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 74ABE40FF69A
	for <dm-devel@redhat.com>; Wed,  9 Feb 2022 09:41:11 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [207.211.31.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
	bits)) (No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 25EC928EA6E1
	for <dm-devel@redhat.com>; Wed,  9 Feb 2022 09:41:11 +0000 (UTC)
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com
	[45.249.212.188]) by relay.mimecast.com with ESMTP with STARTTLS
	(version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
	us-mta-435-cbzw7hNUNE6EdBHVIUrupw-1; Wed, 09 Feb 2022 04:41:09 -0500
X-MC-Unique: cbzw7hNUNE6EdBHVIUrupw-1
Received: from canpemm500005.china.huawei.com (unknown [172.30.72.57])
	by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4JtvWC4WVKzbkLM;
	Wed,  9 Feb 2022 17:20:55 +0800 (CST)
Received: from huawei.com (10.175.127.227) by canpemm500005.china.huawei.com
	(7.192.104.229) with Microsoft SMTP Server (version=TLS1_2,
	cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2308.21;
	Wed, 9 Feb 2022 17:21:56 +0800
From: Zhang Yi <yi.zhang@huawei.com>
To: <dm-devel@redhat.com>
Date: Wed, 9 Feb 2022 17:37:51 +0800
Message-ID: <20220209093751.2986716-1-yi.zhang@huawei.com>
MIME-Version: 1.0
X-Originating-IP: [10.175.127.227]
X-ClientProxiedBy: dggems706-chm.china.huawei.com (10.3.19.183) To
	canpemm500005.china.huawei.com (7.192.104.229)
X-CFilter-Loop: Reflected
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.1
X-MIME-Autoconverted: from quoted-printable to 8bit by
	lists01.pubmisc.prod.ext.phx2.redhat.com id 2199fBPR025332
X-loop: dm-devel@redhat.com
X-Mailman-Approved-At: Thu, 10 Feb 2022 03:18:24 -0500
Cc: axboe@kernel.dk, snitzer@redhat.com, yi.zhang@huawei.com,
	linux-block@vger.kernel.org, yukuai3@huawei.com, agk@redhat.com
Subject: [dm-devel] [PATCH] dm: make sure dm_table is binded before queue
	request
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

We found a NULL pointer dereference problem when using dm-mpath target.
The problem is if we submit IO between loading and binding the table,
we could neither get a valid dm_target nor a valid dm table when
submitting request in dm_mq_queue_rq(). BIO based dm target could
handle this case in dm_submit_bio(). This patch fix this by checking
the mapping table before submitting request.

Signed-off-by: Zhang Yi <yi.zhang@huawei.com>
---
 drivers/md/dm-rq.c | 11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/drivers/md/dm-rq.c b/drivers/md/dm-rq.c
index 579ab6183d4d..af2cf71519e9 100644
--- a/drivers/md/dm-rq.c
+++ b/drivers/md/dm-rq.c
@@ -499,8 +499,15 @@ static blk_status_t dm_mq_queue_rq(struct blk_mq_hw_ctx *hctx,
 
 	if (unlikely(!ti)) {
 		int srcu_idx;
-		struct dm_table *map = dm_get_live_table(md, &srcu_idx);
-
+		struct dm_table *map;
+
+		map = dm_get_live_table(md, &srcu_idx);
+		if (!map) {
+			DMERR_LIMIT("%s: mapping table unavailable, erroring io",
+				    dm_device_name(md));
+			dm_put_live_table(md, srcu_idx);
+			return BLK_STS_IOERR;
+		}
 		ti = dm_table_find_target(map, 0);
 		dm_put_live_table(md, srcu_idx);
 	}
-- 
2.31.1


--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

