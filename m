Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F0325C43334
	for <dm-devel@archiver.kernel.org>; Wed,  6 Jul 2022 14:56:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1657119381;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=AgSl23UdMpes4NJnofKtES3426mxTpICiUw6v2FGG38=;
	b=bzdzI5Jxvvmd/3DCd2NWAWyuYYhIrXoFy3JDcE/aTkadZzkQtbn0W6R3C2DwoFDc1p7Bi4
	UVqW48MaDZ+YNYjj8LfIrxSbb/YBJXkq/0R3Ov7rUOnNpuU/QlfPIA/qdEF9pMJvguEeS6
	W7GHJJ06UvRYDByzi/QC5MxQLew7Zzs=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-176-q2izGI7lOAWUXQLd6Ly3EQ-1; Wed, 06 Jul 2022 10:56:17 -0400
X-MC-Unique: q2izGI7lOAWUXQLd6Ly3EQ-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 43B2C8339C2;
	Wed,  6 Jul 2022 14:56:16 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 328DC492C3B;
	Wed,  6 Jul 2022 14:56:16 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id E53971947063;
	Wed,  6 Jul 2022 14:56:15 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com
 [10.11.54.9])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 4AFB31947058
 for <dm-devel@listman.corp.redhat.com>; Fri,  1 Jul 2022 08:15:05 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 27FC7492CA3; Fri,  1 Jul 2022 08:15:05 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast09.extmail.prod.ext.rdu2.redhat.com [10.11.55.25])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 2412F492C3B
 for <dm-devel@redhat.com>; Fri,  1 Jul 2022 08:15:05 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [205.139.110.61])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 1109A294EDFB
 for <dm-devel@redhat.com>; Fri,  1 Jul 2022 08:15:05 +0000 (UTC)
Received: from mail.nfschina.com (nfschina.com [124.16.136.209]) by
 relay.mimecast.com with ESMTP id us-mta-364-N7qYDNhkPCipFsfWpr0aqQ-1; Fri,
 01 Jul 2022 04:15:03 -0400
X-MC-Unique: N7qYDNhkPCipFsfWpr0aqQ-1
Received: from localhost (unknown [127.0.0.1])
 by mail.nfschina.com (Postfix) with ESMTP id AE4E51E80D93;
 Fri,  1 Jul 2022 16:08:36 +0800 (CST)
X-Virus-Scanned: amavisd-new at test.com
Received: from mail.nfschina.com ([127.0.0.1])
 by localhost (mail.nfschina.com [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id svsQYpydDwZC; Fri,  1 Jul 2022 16:08:34 +0800 (CST)
Received: from localhost.localdomain (unknown [112.65.12.78])
 (Authenticated sender: jiaming@nfschina.com)
 by mail.nfschina.com (Postfix) with ESMTPA id B75C81E80D92;
 Fri,  1 Jul 2022 16:08:32 +0800 (CST)
From: Zhang Jiaming <jiaming@nfschina.com>
To: agk@redhat.com,
	snitzer@kernel.org,
	dm-devel@redhat.com
Date: Fri,  1 Jul 2022 16:09:59 +0800
Message-Id: <20220701080959.13980-1-jiaming@nfschina.com>
MIME-Version: 1.0
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.9
X-Mailman-Approved-At: Wed, 06 Jul 2022 14:51:05 +0000
Subject: [dm-devel] [PATCH] dm snapshot: Fix typo in comments
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
Cc: liqiong@nfschina.com, Zhang Jiaming <jiaming@nfschina.com>,
 renyu@nfschina.com, linux-kernel@vger.kernel.org
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.9
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

There is a typo (writeable) in comments.
Fix it.

Signed-off-by: Zhang Jiaming <jiaming@nfschina.com>
---
 drivers/md/dm-snap.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/md/dm-snap.c b/drivers/md/dm-snap.c
index 0d336b5ec571..d1c2f84d27e3 100644
--- a/drivers/md/dm-snap.c
+++ b/drivers/md/dm-snap.c
@@ -2026,7 +2026,7 @@ static int snapshot_map(struct dm_target *ti, struct bio *bio)
 	/*
 	 * Write to snapshot - higher level takes care of RW/RO
 	 * flags so we should only get this if we are
-	 * writeable.
+	 * writable.
 	 */
 	if (bio_data_dir(bio) == WRITE) {
 		pe = __lookup_pending_exception(s, chunk);
-- 
2.25.1

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

