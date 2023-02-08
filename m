Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 16B48C05027
	for <dm-devel@archiver.kernel.org>; Wed,  8 Feb 2023 04:22:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1675830122;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=FKFIff82xLNVR0dLBnW5dkftSvApGflLIyhms8ZBen8=;
	b=Dyneg04Z5D6xALiqLjXCQYx/WJ7oym+/0bfnrk/386mDYMeudfjRz39PCQ7gu6VGUObPOz
	VfmzTo2aYNuTwCb13Tono2EbIsqcW2mfct9sxsvmj2lsyyS6TuqFZlNlZEAIuJglZKjReC
	4Oi9QyG0rxhXooFZmr+beMTwD3V5eVg=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-194-ZhovElTIMDSkyFN9FRNoNQ-1; Tue, 07 Feb 2023 23:21:59 -0500
X-MC-Unique: ZhovElTIMDSkyFN9FRNoNQ-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id F2FA23814948;
	Wed,  8 Feb 2023 04:21:57 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 9C71C4043840;
	Wed,  8 Feb 2023 04:21:57 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 615041946589;
	Wed,  8 Feb 2023 04:21:57 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
 [10.11.54.6])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id B42681946588
 for <dm-devel@listman.corp.redhat.com>; Wed,  8 Feb 2023 04:21:42 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 6F98B2166B2A; Wed,  8 Feb 2023 04:21:42 +0000 (UTC)
Received: from octiron.msp.redhat.com (octiron.msp.redhat.com [10.15.80.209])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 545BD2166B29;
 Wed,  8 Feb 2023 04:21:42 +0000 (UTC)
Received: from octiron.msp.redhat.com (localhost.localdomain [127.0.0.1])
 by octiron.msp.redhat.com (8.14.9/8.14.9) with ESMTP id 3184LfTi025764;
 Tue, 7 Feb 2023 22:21:41 -0600
Received: (from bmarzins@localhost)
 by octiron.msp.redhat.com (8.14.9/8.14.9/Submit) id 3184LepS025763;
 Tue, 7 Feb 2023 22:21:40 -0600
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Mike Snitzer <snitzer@kernel.org>, dm-devel@redhat.com
Date: Tue,  7 Feb 2023 22:21:40 -0600
Message-Id: <1675830100-25726-1-git-send-email-bmarzins@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.6
Subject: [dm-devel] [PATCH] dm-table: Check that a dm device doesn't
 reference itself
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
Cc: Demi Marie Obenour <demi@invisiblethingslab.com>
MIME-Version: 1.0
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.2
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

If a dm device table references itself, it will crash the kernel with an
infinite recursion.  Check for a self-reference in dm_get_device(). This
is a quick check, but it won't catch more complicated circular
references.

Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 drivers/md/dm-table.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/md/dm-table.c b/drivers/md/dm-table.c
index 8541d5688f3a..24ad42b385c1 100644
--- a/drivers/md/dm-table.c
+++ b/drivers/md/dm-table.c
@@ -364,6 +364,8 @@ int dm_get_device(struct dm_target *ti, const char *path, fmode_t mode,
 		if (!dev)
 			return -ENODEV;
 	}
+	if (dev == disk_devt(t->md->disk))
+		return -EINVAL;
 
 	dd = find_device(&t->devices, dev);
 	if (!dd) {
-- 
2.30.2

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

