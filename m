Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DE924C77B72
	for <dm-devel@archiver.kernel.org>; Thu, 20 Apr 2023 06:57:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1681973836;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=P3j2GxvA4wIyPLyk727CMcvN+KSh+QLo3d9/kVapFEM=;
	b=aRW4KkzPc2L+PLiClodB/zI4lHH7dbbbNgp1+Jnfp/UhNcm7WA4L4XMaSViRUsg0JwAZNb
	rjknVrWZKdoThLCPqxEkAQDv4+lOj1ZfKPTKa5D5tWe1TEyBerjmiNtNeYiIjqQkFL0LE6
	UHEVLgC5Eldw7Wn/s/QMH0J+8uO43Yk=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-146-p1YHDfVsMFmE3bgEDly8QA-1; Thu, 20 Apr 2023 02:57:11 -0400
X-MC-Unique: p1YHDfVsMFmE3bgEDly8QA-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 924273C0D876;
	Thu, 20 Apr 2023 06:57:07 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 7F73140BC79E;
	Thu, 20 Apr 2023 06:57:07 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id F08A71946A42;
	Thu, 20 Apr 2023 06:57:05 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com
 [10.11.54.9])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 2100619465A0
 for <dm-devel@listman.corp.redhat.com>; Wed, 19 Apr 2023 14:10:55 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 03607492B04; Wed, 19 Apr 2023 14:10:55 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast04.extmail.prod.ext.rdu2.redhat.com [10.11.55.20])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id F03AE492B05
 for <dm-devel@redhat.com>; Wed, 19 Apr 2023 14:10:54 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [205.139.110.61])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id D43CC101A557
 for <dm-devel@redhat.com>; Wed, 19 Apr 2023 14:10:54 +0000 (UTC)
Received: from mail-wr1-f50.google.com (mail-wr1-f50.google.com
 [209.85.221.50]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-34-EcIaqcyaP-qDDsTlloGXow-1; Wed, 19 Apr 2023 10:10:50 -0400
X-MC-Unique: EcIaqcyaP-qDDsTlloGXow-1
Received: by mail-wr1-f50.google.com with SMTP id
 ffacd0b85a97d-2f87c5b4635so2905792f8f.1; 
 Wed, 19 Apr 2023 07:10:48 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20221208; t=1681913447; x=1684505447;
 h=content-transfer-encoding:mime-version:references:in-reply-to
 :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
 :subject:date:message-id:reply-to;
 bh=JN1Y2bvJVpq6/q4dmcPnKZ0rBsOm/7Q8Ad5f4nAyRoc=;
 b=jzz9y0kAgYDRr55Y2mBrk/1uUS08BC1yUqTMh+s9BflQUJCAzEZSDaD5QqsfMGZFXA
 Z0ytx3osxuZ8bUCysXcv7SkIequ8fKd3yQelPKuEqQTNLqxjPbAK9SzWswc4tGQlPSYb
 rX7gMoTZx6AMOyd7stfPzszFSYfHRxVAiq7FY57wu5ELaKJHhHT0K33sGEtvyRWNbCtt
 CCmC5clm4VFowG0UuTpisX0J98tzaVZ/E6qM8/phOrG7li0SJj645xguW41N4MU7iCZX
 EVW73aVd81SIV+UlD2PbuUIHWEeBx/Lh79FGfL3iigBDKo+GKwM7NwR7cn8eLtSRrqyr
 klzw==
X-Gm-Message-State: AAQBX9enbl16YqmYceyh28dd39mDfuY5NN+Xjkgpoc3+eYM6EjOnYJW4
 Xgs8nBSkKom9vQJntm43sts=
X-Google-Smtp-Source: AKy350Y02nCXtd9Ex2dTiMUqdMuZubY7+g/E9AAW5VIMPA7K0NU5P6NletE91Ad3MZoVtt3NEzGYVg==
X-Received: by 2002:a5d:5546:0:b0:2f6:8ca4:a71e with SMTP id
 g6-20020a5d5546000000b002f68ca4a71emr4777763wrw.52.1681913447180; 
 Wed, 19 Apr 2023 07:10:47 -0700 (PDT)
Received: from localhost.localdomain
 (aftr-62-216-205-204.dynamic.mnet-online.de. [62.216.205.204])
 by smtp.googlemail.com with ESMTPSA id
 q17-20020a5d61d1000000b002faaa9a1721sm7612089wrv.58.2023.04.19.07.10.45
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Wed, 19 Apr 2023 07:10:46 -0700 (PDT)
From: Johannes Thumshirn <jth@kernel.org>
To: axboe@kernel.dk
Date: Wed, 19 Apr 2023 16:09:22 +0200
Message-Id: <20230419140929.5924-13-jth@kernel.org>
In-Reply-To: <20230419140929.5924-1-jth@kernel.org>
References: <20230419140929.5924-1-jth@kernel.org>
MIME-Version: 1.0
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.9
X-Mailman-Approved-At: Thu, 20 Apr 2023 06:57:04 +0000
Subject: [dm-devel] [PATCH v3 12/19] zonefs: use __bio_add_page for adding
 single page to bio
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
Cc: shaggy@kernel.org, jfs-discussion@lists.sourceforge.net, linux-mm@kvack.org,
 dm-devel@redhat.com, hch@lst.de, agruenba@redhat.com,
 Damien Le Moal <damien.lemoal@opensource.wdc.com>, willy@infradead.org,
 cluster-devel@redhat.com, kch@nvidia.com, snitzer@kernel.org,
 ming.lei@redhat.com, linux-block@vger.kernel.org, rpeterso@redhat.com,
 dsterba@suse.com, linux-raid@vger.kernel.org, damien.lemoal@wdc.com,
 song@kernel.org, johannes.thumshirn@wdc.com, linux-fsdevel@vger.kernel.org,
 linux-btrfs@vger.kernel.org
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.2
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: kernel.org
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

From: Johannes Thumshirn <johannes.thumshirn@wdc.com>

The zonefs superblock reading code uses bio_add_page() to add a page to a
newly created bio. bio_add_page() can fail, but the return value is
never checked.

Use __bio_add_page() as adding a single page to a newly created bio is
guaranteed to succeed.

This brings us a step closer to marking bio_add_page() as __must_check.

Signed-off-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Acked-by: Damien Le Moal <damien.lemoal@opensource.wdc.com>
---
 fs/zonefs/super.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/zonefs/super.c b/fs/zonefs/super.c
index 23b8b299c64e..9350221abfc5 100644
--- a/fs/zonefs/super.c
+++ b/fs/zonefs/super.c
@@ -1128,7 +1128,7 @@ static int zonefs_read_super(struct super_block *sb)
 
 	bio_init(&bio, sb->s_bdev, &bio_vec, 1, REQ_OP_READ);
 	bio.bi_iter.bi_sector = 0;
-	bio_add_page(&bio, page, PAGE_SIZE, 0);
+	__bio_add_page(&bio, page, PAGE_SIZE, 0);
 
 	ret = submit_bio_wait(&bio);
 	if (ret)
-- 
2.39.2

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

