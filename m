Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5109DC04E69
	for <dm-devel@archiver.kernel.org>; Wed,  9 Aug 2023 06:50:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1691563808;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=CzEA2dYj74WAN4l3KoLE7P0DDI37EEGBZGzYixtLUbw=;
	b=CG9iDiWHIiRlwbub7sgZcC8qtbo+isXTnR1BqjOFAFxurRiyu8PRc2v7GD8hKobJzXi9zY
	vGyUv2Z+k8v2YR1ZjJBBZE4hMHopiZk1cCubceNx9ZGCTkroTu4OMttvMWsBB4ogcAeZpK
	jKoRFWED6FJFiJBZ6eh6alVWnoHFBC4=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-604-K73IEXP7P8qYGFIem0zMSA-1; Wed, 09 Aug 2023 02:50:05 -0400
X-MC-Unique: K73IEXP7P8qYGFIem0zMSA-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 05D9080558D;
	Wed,  9 Aug 2023 06:50:03 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id E88BF1121315;
	Wed,  9 Aug 2023 06:50:02 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 1CB5B1946A4C;
	Wed,  9 Aug 2023 06:50:02 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com
 [10.11.54.8])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 60E7B1946586
 for <dm-devel@listman.corp.redhat.com>; Wed,  9 Aug 2023 03:06:30 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 400EEC15BB8; Wed,  9 Aug 2023 03:06:30 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast06.extmail.prod.ext.rdu2.redhat.com [10.11.55.22])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 37B01C15BAE
 for <dm-devel@redhat.com>; Wed,  9 Aug 2023 03:06:30 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [207.211.31.81])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 1DB51185A78B
 for <dm-devel@redhat.com>; Wed,  9 Aug 2023 03:06:30 +0000 (UTC)
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com
 [45.249.212.187]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-513-Jv9W8TuvPRmAhBDjEnTszQ-1; Tue, 08 Aug 2023 23:06:26 -0400
X-MC-Unique: Jv9W8TuvPRmAhBDjEnTszQ-1
Received: from canpemm500007.china.huawei.com (unknown [172.30.72.55])
 by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4RLFH058THztS6p;
 Wed,  9 Aug 2023 11:02:52 +0800 (CST)
Received: from localhost (10.174.179.215) by canpemm500007.china.huawei.com
 (7.192.104.62) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.27; Wed, 9 Aug
 2023 11:06:21 +0800
From: Yue Haibing <yuehaibing@huawei.com>
To: <agk@redhat.com>, <snitzer@kernel.org>, <dm-devel@redhat.com>,
 <heinzm@redhat.com>
Date: Wed, 9 Aug 2023 11:06:08 +0800
Message-ID: <20230809030608.9528-1-yuehaibing@huawei.com>
MIME-Version: 1.0
X-Originating-IP: [10.174.179.215]
X-ClientProxiedBy: dggems701-chm.china.huawei.com (10.3.19.178) To
 canpemm500007.china.huawei.com (7.192.104.62)
X-CFilter-Loop: Reflected
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.8
X-Mailman-Approved-At: Wed, 09 Aug 2023 06:49:58 +0000
Subject: [dm-devel] [PATCH v2 -next] dm: Remove unused declaration
 dm_get_rq_mapinfo()
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
Cc: yuehaibing@huawei.com, linux-kernel@vger.kernel.org, hugo@hugovil.com
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.3
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: huawei.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Commit ae6ad75e5c3c ("dm: remove unused dm_get_rq_mapinfo()")
removed the implementation but not the declaration.

Signed-off-by: Yue Haibing <yuehaibing@huawei.com>
---
v2: revise commit log
---
 include/linux/device-mapper.h | 1 -
 1 file changed, 1 deletion(-)

diff --git a/include/linux/device-mapper.h b/include/linux/device-mapper.h
index 69d0435c7ebb..5bc69c6a64e0 100644
--- a/include/linux/device-mapper.h
+++ b/include/linux/device-mapper.h
@@ -502,7 +502,6 @@ int dm_post_suspending(struct dm_target *ti);
 int dm_noflush_suspending(struct dm_target *ti);
 void dm_accept_partial_bio(struct bio *bio, unsigned int n_sectors);
 void dm_submit_bio_remap(struct bio *clone, struct bio *tgt_clone);
-union map_info *dm_get_rq_mapinfo(struct request *rq);
 
 #ifdef CONFIG_BLK_DEV_ZONED
 struct dm_report_zones_args {
-- 
2.34.1

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

