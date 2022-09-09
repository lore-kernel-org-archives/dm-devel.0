Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 40B88ECAAA1
	for <dm-devel@archiver.kernel.org>; Fri,  9 Sep 2022 06:40:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1662705636;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=qYGq4KKp+l8vu+7fTjJwTh542wSjlm9SqkmsbjuyPsE=;
	b=g0/KTVAaP62GFRLn8AuzMeqIC/qFh4yLruTt1uBt0ZvxvG7EDfPtDNF9cuwpf4D0LwxFnM
	v2qaD5qoPcwUbDLzO6f+GQLxPFax5wAB/coJcxwYxx1vzq0DqaXc2Oql/h/5vIeFMPAhvE
	CvHQmFpfZOzztwSe4ZLYC0tUrBtToJU=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-42-QYDPUN6YNUOn5NYE7iBlPA-1; Fri, 09 Sep 2022 02:40:33 -0400
X-MC-Unique: QYDPUN6YNUOn5NYE7iBlPA-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 090D5101AA46;
	Fri,  9 Sep 2022 06:40:32 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 8A2AA4010D42;
	Fri,  9 Sep 2022 06:40:29 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 557AE1946A44;
	Fri,  9 Sep 2022 06:40:29 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com
 [10.11.54.1])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id E0AA31946A41
 for <dm-devel@listman.corp.redhat.com>; Fri,  9 Sep 2022 00:45:17 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id A696240B40C9; Fri,  9 Sep 2022 00:45:17 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast02.extmail.prod.ext.rdu2.redhat.com [10.11.55.18])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id A304340CF8F0
 for <dm-devel@redhat.com>; Fri,  9 Sep 2022 00:45:17 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [207.211.31.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 7BC1580231E
 for <dm-devel@redhat.com>; Fri,  9 Sep 2022 00:45:17 +0000 (UTC)
Received: from unicom145.biz-email.net (unicom145.biz-email.net
 [210.51.26.145]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-635-r2jlh7P2P4ev5AWG7kqeEA-1; Thu, 08 Sep 2022 20:45:15 -0400
X-MC-Unique: r2jlh7P2P4ev5AWG7kqeEA-1
Received: from ([60.208.111.195])
 by unicom145.biz-email.net ((D)) with ASMTP (SSL) id DZA00104;
 Fri, 09 Sep 2022 08:43:04 +0800
Received: from localhost.localdomain (10.200.104.82) by
 jtjnmail201609.home.langchao.com (10.100.2.9) with Microsoft SMTP Server id
 15.1.2507.12; Fri, 9 Sep 2022 08:43:03 +0800
From: Deming Wang <wangdeming@inspur.com>
To: <agk@redhat.com>, <snitzer@kernel.org>, <dm-devel@redhat.com>
Date: Thu, 8 Sep 2022 20:43:01 -0400
Message-ID: <20220909004301.1514-1-wangdeming@inspur.com>
MIME-Version: 1.0
X-Originating-IP: [10.200.104.82]
tUid: 20229090843046010acde93eee3f4acb457c60445ce8d
X-Abuse-Reports-To: service@corp-email.com
Abuse-Reports-To: service@corp-email.com
X-Complaints-To: service@corp-email.com
X-Report-Abuse-To: service@corp-email.com
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.1
X-Mailman-Approved-At: Fri, 09 Sep 2022 06:40:28 +0000
Subject: [dm-devel] [PATCH] dm raid: fix spelling typo in comment
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
Cc: Deming Wang <wangdeming@inspur.com>, linux-kernel@vger.kernel.org
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.2
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Fix spelling typo in comment.

Signed-off-by: Deming Wang <wangdeming@inspur.com>
---
 drivers/md/dm-raid.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/md/dm-raid.c b/drivers/md/dm-raid.c
index e448fd45a914..54263679a7b1 100644
--- a/drivers/md/dm-raid.c
+++ b/drivers/md/dm-raid.c
@@ -2590,7 +2590,7 @@ static int analyse_superblocks(struct dm_target *ti, struct raid_set *rs)
 
 /*
  * Adjust data_offset and new_data_offset on all disk members of @rs
- * for out of place reshaping if requested by contructor
+ * for out of place reshaping if requested by constructor
  *
  * We need free space at the beginning of each raid disk for forward
  * and at the end for backward reshapes which userspace has to provide
-- 
2.27.0

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

