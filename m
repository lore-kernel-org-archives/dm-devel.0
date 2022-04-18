Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 078E1C433EF
	for <dm-devel@archiver.kernel.org>; Mon, 18 Apr 2022 02:27:56 +0000 (UTC)
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-591-vtyZ-PE8NzKCsrJGAyJI3A-1; Sun, 17 Apr 2022 22:27:53 -0400
X-MC-Unique: vtyZ-PE8NzKCsrJGAyJI3A-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 67D4985A5BE;
	Mon, 18 Apr 2022 02:27:50 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 54EA2145D47B;
	Mon, 18 Apr 2022 02:27:50 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 0366C19451F1;
	Mon, 18 Apr 2022 02:27:50 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com
 [10.11.54.2])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 146F819466DF
 for <dm-devel@listman.corp.redhat.com>; Mon, 18 Apr 2022 02:27:49 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id EAABA40F495E; Mon, 18 Apr 2022 02:27:48 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast05.extmail.prod.ext.rdu2.redhat.com [10.11.55.21])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id E72A440F4941
 for <dm-devel@redhat.com>; Mon, 18 Apr 2022 02:27:48 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [207.211.31.81])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id CF3F0833959
 for <dm-devel@redhat.com>; Mon, 18 Apr 2022 02:27:48 +0000 (UTC)
Received: from mail-qv1-f48.google.com (mail-qv1-f48.google.com
 [209.85.219.48]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-537-WoWaWgUcPseWvSHQ0so3Zw-1; Sun, 17 Apr 2022 22:27:45 -0400
X-MC-Unique: WoWaWgUcPseWvSHQ0so3Zw-1
Received: by mail-qv1-f48.google.com with SMTP id a5so10150094qvx.1
 for <dm-devel@redhat.com>; Sun, 17 Apr 2022 19:27:45 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
 :references;
 bh=0iFUbMQ1MaL1zxidYVv8ly7CAkxek8OY10wWV6GKMmg=;
 b=v4sg7u9tFL0CKzfmQfe/hhD1tfLNWAtOsNcVyDuLZH9KvDsbja+bZIvwtLanWVv5fT
 VAGkNfjBEuBMr2anqDZ6rVQ5VB+TWh6zVYnbrlvMqmC6hjqOY2Q7ihzCZ6WIG9ycGZLk
 mfwBYRmpt8jmthl66OyoWogL97x+5Nhn6npzGIGC4BwXihjPMhuzA8yo6DtUQ+ZQkGOr
 JJLtEieSCuqtHXGFSCcZwvw5DJaggU9A0JSYH2SdvfIiyaa7lYPBNZTUbpTV1tYNpFrG
 f20AJum5cxJR+YkIG55F6O4Y9oeCNfETK65UtqlA7XA1tJH2kXd0eM3aXU815H+Ph3x5
 2oYw==
X-Gm-Message-State: AOAM531lE9iBJqXkOGMAswrRvgLa5VQFmgEK+b3G9qfh+U6BXSkVJYQz
 ptc2ev0GevWkSX5YnsqnQW9R0sfqhBZDtMpkhDgRGfAx8ZWLMcpkZQ6KXz8v/nVrXpRv2WzOvxx
 Euk+g0r9L1dIGD/3eGrU8F3YGACCyLYH4Km61lU6Qb1lWG7WwkO29Z3WJJeENMTRB4iE=
X-Google-Smtp-Source: ABdhPJwmCafxng+SNNtb7sTIoRaCj9+asgReLxSDZYYIR8dM0OCm2Zlr2Q2MIYLjZd/iyKDXbJVVtA==
X-Received: by 2002:ad4:4ea7:0:b0:446:4cfe:da38 with SMTP id
 ed7-20020ad44ea7000000b004464cfeda38mr4857662qvb.79.1650248864464; 
 Sun, 17 Apr 2022 19:27:44 -0700 (PDT)
Received: from localhost (pool-68-160-176-52.bstnma.fios.verizon.net.
 [68.160.176.52]) by smtp.gmail.com with ESMTPSA id
 bj41-20020a05620a192900b0069bfb976482sm6355292qkb.58.2022.04.17.19.27.43
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Sun, 17 Apr 2022 19:27:44 -0700 (PDT)
From: Mike Snitzer <snitzer@kernel.org>
To: dm-devel@redhat.com
Date: Sun, 17 Apr 2022 22:27:20 -0400
Message-Id: <20220418022733.56168-9-snitzer@kernel.org>
In-Reply-To: <20220418022733.56168-1-snitzer@kernel.org>
References: <20220418022733.56168-1-snitzer@kernel.org>
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.2
Subject: [dm-devel] [dm-5.19 PATCH 08/21] dm: move hot dm_io members to same
 cacheline as dm_target_io
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
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.7
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Just saves some cacheline bouncing for members accessed during cloned
bio submission and completion.

Signed-off-by: Mike Snitzer <snitzer@kernel.org>
---
 drivers/md/dm-core.h | 12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

diff --git a/drivers/md/dm-core.h b/drivers/md/dm-core.h
index db069fa9cee5..41d6511dc7cf 100644
--- a/drivers/md/dm-core.h
+++ b/drivers/md/dm-core.h
@@ -250,17 +250,19 @@ static inline bool dm_tio_is_normal(struct dm_target_io *tio)
 #define DM_IO_MAGIC 19577
 struct dm_io {
 	unsigned short magic;
-	blk_short_t flags;
-	atomic_t io_count;
-	struct mapped_device *md;
-	struct bio *orig_bio;
-	blk_status_t status;
+
 	spinlock_t lock;
 	unsigned long start_time;
 	void *data;
 	struct hlist_node node;
 	struct task_struct *map_task;
 	struct dm_stats_aux stats_aux;
+
+	blk_short_t flags;
+	blk_status_t status;
+	atomic_t io_count;
+	struct mapped_device *md;
+	struct bio *orig_bio;
 	/* last member of dm_target_io is 'struct bio' */
 	struct dm_target_io tio;
 };
-- 
2.15.0

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

