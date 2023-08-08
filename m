Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D7CBCC04A94
	for <dm-devel@archiver.kernel.org>; Wed,  9 Aug 2023 06:50:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1691563808;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=vltJ8M5HpyCrXn2GNx3CtKIkCSnG9YHu4APKKUSIfO8=;
	b=VQyv1x1ppoEtZxCHtmHZ9hAW0A2CsggYKtRBLf8367euRf5RkxerNWVyZPMGWZat6kvoPu
	us+M5ZSvsZgMytFgzas17h/50Wx+nk0Xw4sGIEZ7oFNyQUXPDhwk2UzNBgZ7CsXbxKyBxN
	H0gN5shwb2YQAo3/mC7r7cvAwYWF6cA=
Received: from mimecast-mx02.redhat.com (66.187.233.73 [66.187.233.73]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-659-pH7HdAZBOiC1MvojFNku2g-1; Wed, 09 Aug 2023 02:50:04 -0400
X-MC-Unique: pH7HdAZBOiC1MvojFNku2g-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 8047D1C05EBE;
	Wed,  9 Aug 2023 06:50:02 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 6EC902026D68;
	Wed,  9 Aug 2023 06:50:02 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id E138D19465B8;
	Wed,  9 Aug 2023 06:50:01 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com
 [10.11.54.8])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 8E71A1946586
 for <dm-devel@listman.corp.redhat.com>; Tue,  8 Aug 2023 15:21:30 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 7CCFCC15BBA; Tue,  8 Aug 2023 15:21:30 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast09.extmail.prod.ext.rdu2.redhat.com [10.11.55.25])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 75AB4C15BAE
 for <dm-devel@redhat.com>; Tue,  8 Aug 2023 15:21:30 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [205.139.110.61])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 5DFDC299E750
 for <dm-devel@redhat.com>; Tue,  8 Aug 2023 15:21:30 +0000 (UTC)
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com
 [45.249.212.188]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-126-2SzdGrvZNDG0Cy_c7edT6g-1; Tue, 08 Aug 2023 11:21:25 -0400
X-MC-Unique: 2SzdGrvZNDG0Cy_c7edT6g-1
Received: from canpemm500007.china.huawei.com (unknown [172.30.72.56])
 by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4RKxDf1TT8zNmsB;
 Tue,  8 Aug 2023 22:59:46 +0800 (CST)
Received: from localhost (10.174.179.215) by canpemm500007.china.huawei.com
 (7.192.104.62) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.27; Tue, 8 Aug
 2023 23:03:14 +0800
From: Yue Haibing <yuehaibing@huawei.com>
To: <agk@redhat.com>, <snitzer@kernel.org>, <dm-devel@redhat.com>,
 <heinzm@redhat.com>
Date: Tue, 8 Aug 2023 23:03:01 +0800
Message-ID: <20230808150301.45196-1-yuehaibing@huawei.com>
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
Subject: [dm-devel] [PATCH -next] dm: Remove unused declaration
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
Cc: yuehaibing@huawei.com, linux-kernel@vger.kernel.org
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.4
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: huawei.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Commit ae6ad75e5c3c ("dm: remove unused dm_get_rq_mapinfo()")
removed the implementation but leave declaration.

Signed-off-by: Yue Haibing <yuehaibing@huawei.com>
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

