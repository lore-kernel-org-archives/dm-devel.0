Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 56FCBCCA48B
	for <dm-devel@archiver.kernel.org>; Sun, 24 Jul 2022 18:29:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1658687372;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=6IUIcw4eCitl6R4Ob8oZI5mBYJfxXxyT9w0JLKtppBc=;
	b=HeK0Y1QSd4DsZVGRv3uJMInr9pMho504eujXHbr0aWd2jyBYgjuTPV00CM6hLF3ZcZOIga
	5LbKlB6aP7hKArW8rYK1u+ITHMoaUOl0/0aYSSdllvy85h7yb9jyfbAa1S8uAsSWU0MtMl
	HuOFEkzYMJPI2BVf0Qgna2JaiwvyX7g=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-564-KCO2J7WgMSi8LKf03QfjOQ-1; Sun, 24 Jul 2022 14:29:29 -0400
X-MC-Unique: KCO2J7WgMSi8LKf03QfjOQ-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id C0AC71C0519F;
	Sun, 24 Jul 2022 18:29:27 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 9E462492C3B;
	Sun, 24 Jul 2022 18:29:27 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 5F3E61945D82;
	Sun, 24 Jul 2022 18:29:27 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com
 [10.11.54.3])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 5CC211945D83
 for <dm-devel@listman.corp.redhat.com>; Sun, 24 Jul 2022 18:29:26 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 2BAEA1121319; Sun, 24 Jul 2022 18:29:26 +0000 (UTC)
Received: from file01.intranet.prod.int.rdu2.redhat.com
 (file01.intranet.prod.int.rdu2.redhat.com [10.11.5.7])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 21F901121314;
 Sun, 24 Jul 2022 18:29:26 +0000 (UTC)
Received: from file01.intranet.prod.int.rdu2.redhat.com (localhost [127.0.0.1])
 by file01.intranet.prod.int.rdu2.redhat.com (8.14.4/8.14.4) with ESMTP id
 26OITQ3N026314; Sun, 24 Jul 2022 14:29:26 -0400
Received: from localhost (mpatocka@localhost)
 by file01.intranet.prod.int.rdu2.redhat.com (8.14.4/8.14.4/Submit) with ESMTP
 id 26OITQdf026310; Sun, 24 Jul 2022 14:29:26 -0400
X-Authentication-Warning: file01.intranet.prod.int.rdu2.redhat.com: mpatocka
 owned process doing -bs
Date: Sun, 24 Jul 2022 14:29:26 -0400 (EDT)
From: Mikulas Patocka <mpatocka@redhat.com>
X-X-Sender: mpatocka@file01.intranet.prod.int.rdu2.redhat.com
To: Song Liu <song@kernel.org>
Message-ID: <alpine.LRH.2.02.2207241426320.26078@file01.intranet.prod.int.rdu2.redhat.com>
User-Agent: Alpine 2.02 (LRH 1266 2009-07-14)
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.3
Subject: [dm-devel] [PATCH] md-raid10: fix KASAN warning
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
Cc: linux-raid@vger.kernel.org, Heinz Mauelshagen <heinzm@redhat.com>,
 Mike Snitzer <msnitzer@redhat.com>, dm-devel@redhat.com
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.10
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

There's a KASAN warning in raid10_remove_disk when running the lvm
test lvconvert-raid-reshape.sh. We fix this warning by verifying that the
value "number" is valid.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Cc: stable@vger.kernel.org

---
 drivers/md/raid10.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

Index: linux-2.6/drivers/md/raid10.c
===================================================================
--- linux-2.6.orig/drivers/md/raid10.c	2022-07-13 19:05:50.000000000 +0200
+++ linux-2.6/drivers/md/raid10.c	2022-07-13 19:07:05.000000000 +0200
@@ -2167,9 +2167,12 @@ static int raid10_remove_disk(struct mdd
 	int err = 0;
 	int number = rdev->raid_disk;
 	struct md_rdev **rdevp;
-	struct raid10_info *p = conf->mirrors + number;
+	struct raid10_info *p;
 
 	print_conf(conf);
+	if (unlikely(number >= mddev->raid_disks))
+		return 0;
+	p = conf->mirrors + number;
 	if (rdev == p->rdev)
 		rdevp = &p->rdev;
 	else if (rdev == p->replacement)
--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

