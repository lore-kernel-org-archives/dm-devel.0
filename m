Return-Path: <SRS0=56gb=K4=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 66CFAC4708F
	for <dm-devel@archiver.kernel.org>; Wed,  2 Jun 2021 08:33:05 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id C6D55613D2
	for <dm-devel@archiver.kernel.org>; Wed,  2 Jun 2021 08:33:04 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org C6D55613D2
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=huawei.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-484-hyExD7fsMpyVmoH2atyGlA-1; Wed, 02 Jun 2021 04:33:02 -0400
X-MC-Unique: hyExD7fsMpyVmoH2atyGlA-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id BD32D801B15;
	Wed,  2 Jun 2021 08:32:57 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 2F76C5D9DE;
	Wed,  2 Jun 2021 08:32:57 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 9549D1801264;
	Wed,  2 Jun 2021 08:32:55 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
	[10.11.54.4])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 151A8OpK004400 for <dm-devel@listman.util.phx.redhat.com>;
	Tue, 1 Jun 2021 06:08:25 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id 9FB682044014; Tue,  1 Jun 2021 10:08:24 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast03.extmail.prod.ext.rdu2.redhat.com [10.11.55.19])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 9BBE02044011
	for <dm-devel@redhat.com>; Tue,  1 Jun 2021 10:08:22 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [205.139.110.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 3156780D0E5
	for <dm-devel@redhat.com>; Tue,  1 Jun 2021 10:08:22 +0000 (UTC)
Received: from szxga08-in.huawei.com (szxga08-in.huawei.com
	[45.249.212.255]) (Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-570-Oc-P6MYcNyilsbQJG8UKdw-1; Tue, 01 Jun 2021 06:08:20 -0400
X-MC-Unique: Oc-P6MYcNyilsbQJG8UKdw-1
Received: from dggemv703-chm.china.huawei.com (unknown [172.30.72.53])
	by szxga08-in.huawei.com (SkyGuard) with ESMTP id 4FvS5Z0zdKz1BGV9;
	Tue,  1 Jun 2021 17:48:18 +0800 (CST)
Received: from dggpemm000001.china.huawei.com (7.185.36.245) by
	dggemv703-chm.china.huawei.com (10.3.19.46) with Microsoft SMTP Server
	(version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
	15.1.2176.2; Tue, 1 Jun 2021 17:52:58 +0800
Received: from localhost.localdomain.localdomain (10.175.113.25) by
	dggpemm000001.china.huawei.com (7.185.36.245) with Microsoft SMTP
	Server
	(version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
	15.1.2176.2; Tue, 1 Jun 2021 17:52:58 +0800
From: Tong Tiangen <tongtiangen@huawei.com>
To: Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@redhat.com>,
	<dm-devel@redhat.com>
Date: Tue, 1 Jun 2021 18:02:18 +0800
Message-ID: <20210601100218.69842-1-tongtiangen@huawei.com>
MIME-Version: 1.0
X-Originating-IP: [10.175.113.25]
X-ClientProxiedBy: dggems703-chm.china.huawei.com (10.3.19.180) To
	dggpemm000001.china.huawei.com (7.185.36.245)
X-CFilter-Loop: Reflected
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.4
X-MIME-Autoconverted: from quoted-printable to 8bit by
	lists01.pubmisc.prod.ext.phx2.redhat.com id 151A8OpK004400
X-loop: dm-devel@redhat.com
X-Mailman-Approved-At: Wed, 02 Jun 2021 04:32:53 -0400
Cc: Tong Tiangen <tongtiangen@huawei.com>, linux-kernel@vger.kernel.org
Subject: [dm-devel] [PATCH -next] dm btree: shadow_child leaves unchecked in
	split_two_into_three
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Function shadow_child() leaves variable 'r' unchecked in
split_two_into_three when parent_index not equals to 0.
It's also not coordinate with above relative codes.

Fixes: dee29bf9192b ("dm btree: improve btree residency")
Signed-off-by: Tong Tiangen <tongtiangen@huawei.com>
---
 drivers/md/persistent-data/dm-btree.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/md/persistent-data/dm-btree.c b/drivers/md/persistent-data/dm-btree.c
index 3e5a90580427..0703ca7a7d9a 100644
--- a/drivers/md/persistent-data/dm-btree.c
+++ b/drivers/md/persistent-data/dm-btree.c
@@ -743,8 +743,10 @@ static int split_two_into_three(struct shadow_spine *s, unsigned parent_index,
 			return r;
 	} else {
 		middle_index = parent_index;
-		r = shadow_child(s->info, vt, pn, parent_index - 1, &left);
 		right = shadow_current(s);
+		r = shadow_child(s->info, vt, pn, parent_index - 1, &left);
+		if (r)
+			return r;
 	}
 
 	r = new_block(s->info, &middle);
-- 
2.18.0.huawei.25


--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

