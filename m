Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B6486C7EE21
	for <dm-devel@archiver.kernel.org>; Fri, 21 Apr 2023 06:47:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1682059678;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=Bag6PbUn67x8Md42tz7/JgCd4ZbSIkIcoC3KT1GlxpI=;
	b=OXQzUgtPyo1LjAaoda045LVfyv4jBlkwO6Ky/SisYfYKITVZ3HWrOXts0l5mGlPFQ5owkr
	6m1CjRGzoFMxp3x4hO/MADQB9QrhwEN71Gq8qix/M+8XIoK6BV7Z+kHV3itaVB8izr4HT4
	3FkgImYefpgplCUDGu5nnpaoxFS6qxQ=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-627-IZQamXSQPce9o2ZqMyRS9g-1; Fri, 21 Apr 2023 02:47:57 -0400
X-MC-Unique: IZQamXSQPce9o2ZqMyRS9g-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 89CC485A5B1;
	Fri, 21 Apr 2023 06:47:53 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 76E30492B01;
	Fri, 21 Apr 2023 06:47:53 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 1619A1949738;
	Fri, 21 Apr 2023 06:47:51 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com
 [10.11.54.8])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 27AB619465B9
 for <dm-devel@listman.corp.redhat.com>; Thu, 20 Apr 2023 10:06:39 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 384BCC16047; Thu, 20 Apr 2023 10:06:09 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast03.extmail.prod.ext.rdu2.redhat.com [10.11.55.19])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 30BDFC16045
 for <dm-devel@redhat.com>; Thu, 20 Apr 2023 10:06:09 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [207.211.31.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 14F31811E7D
 for <dm-devel@redhat.com>; Thu, 20 Apr 2023 10:06:09 +0000 (UTC)
Received: from mail-wm1-f47.google.com (mail-wm1-f47.google.com
 [209.85.128.47]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-5-LGbt8nPgO3enwfV-DbEPVA-1; Thu, 20 Apr 2023 06:06:05 -0400
X-MC-Unique: LGbt8nPgO3enwfV-DbEPVA-1
Received: by mail-wm1-f47.google.com with SMTP id
 5b1f17b1804b1-3f17b967bfbso14827095e9.1; 
 Thu, 20 Apr 2023 03:06:04 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20221208; t=1681985163; x=1684577163;
 h=content-transfer-encoding:mime-version:references:in-reply-to
 :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
 :subject:date:message-id:reply-to;
 bh=3G8vgZAFagEXL1mcgIvsIV/u4Cz0QizBZkd2HYzCGxY=;
 b=jaHSKqzdAwzCFXydQ9hDTDj64pzMgRdMaJzp0hNC8zl+ockcBvQMv4wfE3FROK0Vom
 sX1Ez0ZkLjNvm9cLbKZxxR2un3DFS7etg1JUyYytnFWVfEnB/+LDXXtrgUPO3ttylg1D
 gFnpX5mY/Hvpfg5TFzoJEZFva8wmmJLRTKa61aGXNQhUdl+X5bA7JDd+dbRU6uNu+6fC
 8BX1RxRTl+uzezmzSHvr7I6x9Gslq41n16qDM3Zp4JM28Io0NuPEKG9YyQdNqJEl3ZdY
 H1v/WOwCENbjzgo/RrPc/Qo9do7ReVQFU3O2zbwAGFpd83nPERHiIDjJrNzoCOjojs3i
 mMyg==
X-Gm-Message-State: AAQBX9fdbTMtaxsD6LA3lk7hGgVYoYGey4ExjM0x2xcaT4YjLcn8IO12
 r2eV4vHs4ILokrw0TmsCK94=
X-Google-Smtp-Source: AKy350Zwu6RqojLD2/82sYHKfY3An39L6ReZ+83ih6pfN87F+BwdyWXKO+szShokbvWeEtwYoIEk5g==
X-Received: by 2002:a5d:544e:0:b0:2fb:539c:5e89 with SMTP id
 w14-20020a5d544e000000b002fb539c5e89mr1022598wrv.4.1681985163497; 
 Thu, 20 Apr 2023 03:06:03 -0700 (PDT)
Received: from localhost.localdomain
 (aftr-62-216-205-208.dynamic.mnet-online.de. [62.216.205.208])
 by smtp.googlemail.com with ESMTPSA id
 l11-20020a5d674b000000b0030276f42f08sm201410wrw.88.2023.04.20.03.06.02
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Thu, 20 Apr 2023 03:06:03 -0700 (PDT)
From: Johannes Thumshirn <jth@kernel.org>
To: axboe@kernel.dk
Date: Thu, 20 Apr 2023 12:04:50 +0200
Message-Id: <20230420100501.32981-12-jth@kernel.org>
In-Reply-To: <20230420100501.32981-1-jth@kernel.org>
References: <20230420100501.32981-1-jth@kernel.org>
MIME-Version: 1.0
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.8
X-Mailman-Approved-At: Fri, 21 Apr 2023 06:47:49 +0000
Subject: [dm-devel] [PATCH v4 11/22] gfs2: use __bio_add_page for adding
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
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.10
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: kernel.org
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

From: Johannes Thumshirn <johannes.thumshirn@wdc.com>

The GFS2 superblock reading code uses bio_add_page() to add a page to a
newly created bio. bio_add_page() can fail, but the return value is never
checked.

Use __bio_add_page() as adding a single page to a newly created bio is
guaranteed to succeed.

This brings us a step closer to marking bio_add_page() as __must_check.

Signed-off-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Reviewed-by: Damien Le Moal <damien.lemoal@opensource.wdc.com>
Reviewed-by: Andreas Gruenbacher <agruenba@redhat.com>
---
 fs/gfs2/ops_fstype.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/gfs2/ops_fstype.c b/fs/gfs2/ops_fstype.c
index 6de901c3b89b..e0cd0d43b12f 100644
--- a/fs/gfs2/ops_fstype.c
+++ b/fs/gfs2/ops_fstype.c
@@ -254,7 +254,7 @@ static int gfs2_read_super(struct gfs2_sbd *sdp, sector_t sector, int silent)
 
 	bio = bio_alloc(sb->s_bdev, 1, REQ_OP_READ | REQ_META, GFP_NOFS);
 	bio->bi_iter.bi_sector = sector * (sb->s_blocksize >> 9);
-	bio_add_page(bio, page, PAGE_SIZE, 0);
+	__bio_add_page(bio, page, PAGE_SIZE, 0);
 
 	bio->bi_end_io = end_bio_io_page;
 	bio->bi_private = page;
-- 
2.39.2

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

