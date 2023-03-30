Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1A612C7619A
	for <dm-devel@archiver.kernel.org>; Thu, 30 Mar 2023 21:28:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1680211692;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=OztVVvyghsw13h4JjGmeF4ecXlQ/Vd76++oqxdivmA8=;
	b=bzDr4VUczcmKdeNZmiqbFMo+xFrUEK+9ml26Gb0unXm7gWLH0tdl9CW+6gvCf7esqwiB9D
	BavuMCKKyh8eLGwJB9WzNNjRzDVSAZ5R8Db9T7nfbItdbFY+bUC/1meWp3zXwEHi3xF5KQ
	yJ7rsFjTNRbVOBHusZxC/Gz5AbjIQQE=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-492-D1G4N5FDP92e-2zYfhDd0w-1; Thu, 30 Mar 2023 17:28:09 -0400
X-MC-Unique: D1G4N5FDP92e-2zYfhDd0w-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 2FC7985A5A3;
	Thu, 30 Mar 2023 21:28:07 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id B62451121330;
	Thu, 30 Mar 2023 21:28:06 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 814B5194658F;
	Thu, 30 Mar 2023 21:28:06 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com
 [10.11.54.7])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 051801946587
 for <dm-devel@listman.corp.redhat.com>; Thu, 30 Mar 2023 21:28:04 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id C6B3D14171BF; Thu, 30 Mar 2023 21:28:04 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast07.extmail.prod.ext.rdu2.redhat.com [10.11.55.23])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id BEDE314171BE
 for <dm-devel@redhat.com>; Thu, 30 Mar 2023 21:28:04 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [207.211.31.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 3E5FC3C0F1A5
 for <dm-devel@redhat.com>; Thu, 30 Mar 2023 21:28:04 +0000 (UTC)
Received: from mail-qt1-f200.google.com (mail-qt1-f200.google.com
 [209.85.160.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-203-tBfK7ChJMjmmqUJeeeyO7g-1; Thu, 30 Mar 2023 17:28:02 -0400
X-MC-Unique: tBfK7ChJMjmmqUJeeeyO7g-1
Received: by mail-qt1-f200.google.com with SMTP id
 c14-20020ac87d8e000000b003e38726ec8bso13312641qtd.23
 for <dm-devel@redhat.com>; Thu, 30 Mar 2023 14:28:02 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112; t=1680211682;
 h=content-transfer-encoding:mime-version:message-id:date:subject:cc
 :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
 :reply-to;
 bh=rt6EJ3ZeV4qq0asIu+DFVmM346d+zHCFno0fyrsIV8Y=;
 b=WzS3YM5ckchqA/I+zaEbJFnY2OiTIe3UQZTEdVHsT8lucx8oD59fZak0jSC6lfRxSO
 YxHwQB9/vMk10kMnRTEL+oaPzM640bPEPAIZJjP/LfBZmviUao5IWz0sEDcSaqQWPhlj
 MM8wenGGjGCI6nSovGqVWZgRPB2Ypeyhs00h/Hs7GBSKJozuhU6/jVx6ZYRGwCLn78TZ
 OQ29nuyIzb7S3c2+kVA9FOyH1hGoomlPNWtTOVETtlXZCUq+HG+g4qcjF/ddgKHlaLvv
 ddDyKVANeRwdu1jGNZbox4vl6PYAoFFlYgCpmsP0RZwZrmmOtGLIf3eA4ntQhfvMqz15
 PEoA==
X-Gm-Message-State: AAQBX9cuaf6q82Iy0BGskxP46iKBM5ikD9bHtshdDo5YA8Dw1lonjb0L
 KDRQHoju9U6D5CgRYO1J8rPbUZe2dfQv6VW0+6Esjy/yihcvd6BROHfc37zOufzT6A0BFwXKap5
 ZLHK45H7nBt6DgaY=
X-Received: by 2002:ad4:4eaf:0:b0:570:bf43:48c with SMTP id
 ed15-20020ad44eaf000000b00570bf43048cmr43188304qvb.17.1680211682483; 
 Thu, 30 Mar 2023 14:28:02 -0700 (PDT)
X-Google-Smtp-Source: AKy350bukr0FcRQMc2nG5KrRM/m8w5YgIIaWjKzHx1vTOdwbnYGxASPxDm2TVeIoaQM48y1CP6Db1g==
X-Received: by 2002:ad4:4eaf:0:b0:570:bf43:48c with SMTP id
 ed15-20020ad44eaf000000b00570bf43048cmr43188280qvb.17.1680211682193; 
 Thu, 30 Mar 2023 14:28:02 -0700 (PDT)
Received: from dell-per740-01.7a2m.lab.eng.bos.redhat.com
 (nat-pool-bos-t.redhat.com. [66.187.233.206])
 by smtp.gmail.com with ESMTPSA id
 18-20020a05620a041200b00746059d9c3fsm172156qkp.35.2023.03.30.14.28.01
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Thu, 30 Mar 2023 14:28:01 -0700 (PDT)
From: Tom Rix <trix@redhat.com>
To: agk@redhat.com, snitzer@kernel.org, nathan@kernel.org,
 ndesaulniers@google.com
Date: Thu, 30 Mar 2023 17:27:53 -0400
Message-Id: <20230330212753.1843266-1-trix@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.7
Subject: [dm-devel] [PATCH] dm raid: remove unused d variable
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
Cc: Tom Rix <trix@redhat.com>, dm-devel@redhat.com, llvm@lists.linux.dev,
 linux-kernel@vger.kernel.org
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.3
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

clang with W=1 reports
drivers/md/dm-raid.c:2212:15: error: variable
  'd' set but not used [-Werror,-Wunused-but-set-variable]
        unsigned int d;
                     ^
This variable is not used so remove it.

Signed-off-by: Tom Rix <trix@redhat.com>
---
 drivers/md/dm-raid.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/drivers/md/dm-raid.c b/drivers/md/dm-raid.c
index 60632b409b80..2dfd51509647 100644
--- a/drivers/md/dm-raid.c
+++ b/drivers/md/dm-raid.c
@@ -2209,7 +2209,6 @@ static int super_load(struct md_rdev *rdev, struct md_rdev *refdev)
 static int super_init_validation(struct raid_set *rs, struct md_rdev *rdev)
 {
 	int role;
-	unsigned int d;
 	struct mddev *mddev = &rs->md;
 	uint64_t events_sb;
 	uint64_t failed_devices[DISKS_ARRAY_ELEMS];
@@ -2324,7 +2323,6 @@ static int super_init_validation(struct raid_set *rs, struct md_rdev *rdev)
 	 *    to provide capacity for redundancy or during reshape
 	 *    to add capacity to grow the raid set.
 	 */
-	d = 0;
 	rdev_for_each(r, mddev) {
 		if (test_bit(Journal, &rdev->flags))
 			continue;
@@ -2340,8 +2338,6 @@ static int super_init_validation(struct raid_set *rs, struct md_rdev *rdev)
 			if (test_bit(FirstUse, &r->flags))
 				rebuild_and_new++;
 		}
-
-		d++;
 	}
 
 	if (new_devs == rs->raid_disks || !rebuilds) {
-- 
2.27.0

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

