Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3BF29C4332F
	for <dm-devel@archiver.kernel.org>; Mon, 18 Apr 2022 02:27:58 +0000 (UTC)
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-75-MOfTOlH5NIuetlqZBwabRQ-1; Sun, 17 Apr 2022 22:27:54 -0400
X-MC-Unique: MOfTOlH5NIuetlqZBwabRQ-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 86DD03C0010A;
	Mon, 18 Apr 2022 02:27:52 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 75BDA40F9D50;
	Mon, 18 Apr 2022 02:27:52 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 3455D19451F1;
	Mon, 18 Apr 2022 02:27:52 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com
 [10.11.54.3])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 95DBB19451F1
 for <dm-devel@listman.corp.redhat.com>; Mon, 18 Apr 2022 02:27:50 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 73DD41004D93; Mon, 18 Apr 2022 02:27:50 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast08.extmail.prod.ext.rdu2.redhat.com [10.11.55.24])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 6E93B111C4B0
 for <dm-devel@redhat.com>; Mon, 18 Apr 2022 02:27:44 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [207.211.31.81])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 51C7438035A1
 for <dm-devel@redhat.com>; Mon, 18 Apr 2022 02:27:44 +0000 (UTC)
Received: from mail-qk1-f179.google.com (mail-qk1-f179.google.com
 [209.85.222.179]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-589-km3Dxi-KOmmK_4twbo7bgw-1; Sun, 17 Apr 2022 22:27:43 -0400
X-MC-Unique: km3Dxi-KOmmK_4twbo7bgw-1
Received: by mail-qk1-f179.google.com with SMTP id 204so4324559qkg.5
 for <dm-devel@redhat.com>; Sun, 17 Apr 2022 19:27:42 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
 :references;
 bh=E56CaC0JIJpvrYVEiYcwCuRVG5+fjb6NDuyYl6jqq5Q=;
 b=hX/5UVS6udfhyWaCpP9WY6JeY7fMZzzebikx8BhWA2649+qbRuLU7pVpECUSyAFSfc
 CuLp4RN8B3rhZV1WX2vFYzGZs4y5Z1galkt497zkp8mtw3+hw8eFc4kEiGVxcrjHQ/zk
 /rEA+C2ZaNxaIu3wBMUfHof45jKr+TeHeO/LYacRUHJN1JzlLVavMhl6noOfm7lMN5mc
 L5lhm7qPTjZKhwUPVEJ3kpF2CRR+UMnSeIqUjKOdCDOmae+BraW40V6DEBuq0DZOGy0I
 v/nL1RhgA5f0KauArV6StAqrwF6dkBx/UHUMV+F8HZiWjw+eDNFkzXdmL2Q5/hggRJf6
 9UMA==
X-Gm-Message-State: AOAM531QyRD28egE3WMCsKw4FHUt8vJtLBglLc33euxi3j2xyh0gZkLj
 wYAiIb5D9cleGDwG1vCF/6HyWloQbDrlpI005oKQXKzVBRtu/Z00p1FoNI4HrR6WwfFXFCHsCg9
 g+Gnon91LyU9KrGd2h/+5cczu+YDqNW5NlfLoS/KjD5ZNCsqo/cFNmGHe+qSs6ljdprY=
X-Google-Smtp-Source: ABdhPJz3HdCDJxaoSMo3bzLz1rzj1KAfBXMOzOesUQEPcvNAb6m7B5BS10XTgturrJ8Ii/H7VrFgIw==
X-Received: by 2002:a37:ba45:0:b0:69b:e728:34b7 with SMTP id
 k66-20020a37ba45000000b0069be72834b7mr5352876qkf.606.1650248862057; 
 Sun, 17 Apr 2022 19:27:42 -0700 (PDT)
Received: from localhost (pool-68-160-176-52.bstnma.fios.verizon.net.
 [68.160.176.52]) by smtp.gmail.com with ESMTPSA id
 k189-20020a3788c6000000b0069c10860b10sm6060045qkd.107.2022.04.17.19.27.41
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Sun, 17 Apr 2022 19:27:41 -0700 (PDT)
From: Mike Snitzer <snitzer@kernel.org>
To: dm-devel@redhat.com
Date: Sun, 17 Apr 2022 22:27:18 -0400
Message-Id: <20220418022733.56168-7-snitzer@kernel.org>
In-Reply-To: <20220418022733.56168-1-snitzer@kernel.org>
References: <20220418022733.56168-1-snitzer@kernel.org>
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.3
Subject: [dm-devel] [dm-5.19 PATCH 06/21] dm: mark various branches unlikely
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
Cc: axboe@kernel.dk, hch@lst.de, ming.lei@redhat.com
MIME-Version: 1.0
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.1
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Signed-off-by: Mike Snitzer <snitzer@kernel.org>
---
 drivers/md/dm.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/md/dm.c b/drivers/md/dm.c
index 0974498c68e7..630c1880023a 100644
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -992,7 +992,7 @@ static void clone_endio(struct bio *bio)
 			disable_write_zeroes(md);
 	}
 
-	if (blk_queue_is_zoned(q))
+	if (unlikely(blk_queue_is_zoned(q)))
 		dm_zone_endio(io, bio);
 
 	if (endio) {
@@ -1289,7 +1289,7 @@ static void __map_bio(struct bio *clone)
 	 * on zoned target. In this case, dm_zone_map_bio() calls the target
 	 * map operation.
 	 */
-	if (dm_emulate_zone_append(io->md))
+	if (unlikely(dm_emulate_zone_append(io->md)))
 		r = dm_zone_map_bio(tio);
 	else
 		r = ti->type->map(ti, clone);
@@ -1632,7 +1632,7 @@ static void dm_submit_bio(struct bio *bio)
 	 * Use blk_queue_split() for abnormal IO (e.g. discard, writesame, etc)
 	 * otherwise associated queue_limits won't be imposed.
 	 */
-	if (is_abnormal_io(bio))
+	if (unlikely(is_abnormal_io(bio)))
 		blk_queue_split(&bio);
 
 	dm_split_and_process_bio(md, map, bio);
-- 
2.15.0

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

