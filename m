Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 36596C433EF
	for <dm-devel@archiver.kernel.org>; Wed, 29 Jun 2022 18:07:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1656526065;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=Yy61yWvs/Qc18Zzok0gb9w7CeVAWxiQ1aIOHtBM5RKc=;
	b=fvB2RGiBKcQlM84SOFrKNzkt51F9iN3VQo7aUugAaElyYAb77J7wNkzgUfqh8Uo9L3oy+Y
	EJB7MR7lIOw6GqUcdwUICz+riZpb9hNZM2nD9LlNIOAsNPZMSttoR64OO081C3ZrxPjil0
	G/1EtyhhSme5SZWK05oQgN2du+MzzjI=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-338-QapYhVciP9OluvcjNnqakg-1; Wed, 29 Jun 2022 14:07:44 -0400
X-MC-Unique: QapYhVciP9OluvcjNnqakg-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 89136101A589;
	Wed, 29 Jun 2022 18:07:42 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 758402166B26;
	Wed, 29 Jun 2022 18:07:42 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 3530D194705B;
	Wed, 29 Jun 2022 18:07:42 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com
 [10.11.54.2])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 02ECF1947058
 for <dm-devel@listman.corp.redhat.com>; Wed, 29 Jun 2022 17:40:01 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 933E440EC006; Wed, 29 Jun 2022 17:40:01 +0000 (UTC)
Received: from file01.intranet.prod.int.rdu2.redhat.com
 (file01.intranet.prod.int.rdu2.redhat.com [10.11.5.7])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 8A79140EC003;
 Wed, 29 Jun 2022 17:40:01 +0000 (UTC)
Received: from file01.intranet.prod.int.rdu2.redhat.com (localhost [127.0.0.1])
 by file01.intranet.prod.int.rdu2.redhat.com (8.14.4/8.14.4) with ESMTP id
 25THe1F3018738; Wed, 29 Jun 2022 13:40:01 -0400
Received: from localhost (mpatocka@localhost)
 by file01.intranet.prod.int.rdu2.redhat.com (8.14.4/8.14.4/Submit) with ESMTP
 id 25THe1wt018734; Wed, 29 Jun 2022 13:40:01 -0400
X-Authentication-Warning: file01.intranet.prod.int.rdu2.redhat.com: mpatocka
 owned process doing -bs
Date: Wed, 29 Jun 2022 13:40:01 -0400 (EDT)
From: Mikulas Patocka <mpatocka@redhat.com>
X-X-Sender: mpatocka@file01.intranet.prod.int.rdu2.redhat.com
To: song@kernel.org, Mike Snitzer <msnitzer@redhat.com>,
 Heinz Mauelshagen <heinzm@redhat.com>
Message-ID: <alpine.LRH.2.02.2206291332230.18482@file01.intranet.prod.int.rdu2.redhat.com>
User-Agent: Alpine 2.02 (LRH 1266 2009-07-14)
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.2
Subject: [dm-devel] [PATCH] dm-raid: fix KASAN warning in raid5_remove_disk
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
Cc: linux-raid@vger.kernel.org, dm-devel@redhat.com
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.6
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

There's a KASAN warning in raid5_remove_disk when running the LVM
testsuite. We fix this warning by verifying that the "number" variable is
within limits.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Cc: stable@vger.kernel.org

---
 drivers/md/raid5.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

Index: linux-2.6/drivers/md/raid5.c
===================================================================
--- linux-2.6.orig/drivers/md/raid5.c	2022-06-15 09:06:14.000000000 +0200
+++ linux-2.6/drivers/md/raid5.c	2022-06-16 13:33:18.000000000 +0200
@@ -7933,7 +7933,7 @@ static int raid5_remove_disk(struct mdde
 	int err = 0;
 	int number = rdev->raid_disk;
 	struct md_rdev __rcu **rdevp;
-	struct disk_info *p = conf->disks + number;
+	struct disk_info *p;
 	struct md_rdev *tmp;
 
 	print_raid5_conf(conf);
@@ -7952,6 +7952,9 @@ static int raid5_remove_disk(struct mdde
 		log_exit(conf);
 		return 0;
 	}
+	if (unlikely(number >= conf->pool_size))
+		return 0;
+	p = conf->disks + number;
 	if (rdev == rcu_access_pointer(p->rdev))
 		rdevp = &p->rdev;
 	else if (rdev == rcu_access_pointer(p->replacement))
--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

