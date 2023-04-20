Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C2AFCC7EE22
	for <dm-devel@archiver.kernel.org>; Fri, 21 Apr 2023 06:48:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1682059684;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=PSA8iIJoPjx5ZWdVdkXY9TCCopKiMactTNNehyocRLI=;
	b=PYs7SXuJO0q8soNfdSg8tcY7+v/VbJwnfLro6D0FC/mhHNXsGBAIu+bvg+7HMamscDbaiA
	f3B1eynfdPzXbYwyfK79zaRss602iX7T65INKZeg13qoZBYHrFhHTHZ9ug6jeFzcFSkMa2
	3Iu5a9aVJT7VKd9V7H0haHU/jN/oVLM=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-370-Yp8KCzaxMr68_5-WEijx4A-1; Fri, 21 Apr 2023 02:48:02 -0400
X-MC-Unique: Yp8KCzaxMr68_5-WEijx4A-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id D14B91C129B7;
	Fri, 21 Apr 2023 06:47:57 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id BB2A21410F1E;
	Fri, 21 Apr 2023 06:47:57 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 939D51946A4E;
	Fri, 21 Apr 2023 06:47:57 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com
 [10.11.54.8])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 3323E1946A4A
 for <dm-devel@listman.corp.redhat.com>; Thu, 20 Apr 2023 10:06:39 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 7808AC090DC; Thu, 20 Apr 2023 10:06:19 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast10.extmail.prod.ext.rdu2.redhat.com [10.11.55.26])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 70BA7C16045
 for <dm-devel@redhat.com>; Thu, 20 Apr 2023 10:06:19 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [205.139.110.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 56ABF1C087B3
 for <dm-devel@redhat.com>; Thu, 20 Apr 2023 10:06:19 +0000 (UTC)
Received: from mail-wm1-f49.google.com (mail-wm1-f49.google.com
 [209.85.128.49]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-460-3c4vFA2HNCOovhMXLPyqGQ-1; Thu, 20 Apr 2023 06:06:17 -0400
X-MC-Unique: 3c4vFA2HNCOovhMXLPyqGQ-1
Received: by mail-wm1-f49.google.com with SMTP id
 5b1f17b1804b1-3f0a80b686eso3442995e9.1; 
 Thu, 20 Apr 2023 03:06:16 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20221208; t=1681985175; x=1684577175;
 h=content-transfer-encoding:mime-version:references:in-reply-to
 :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
 :subject:date:message-id:reply-to;
 bh=R6+NeAX2XCjGoXZTYs/vHx8pZBcBY0nCsbbwup4DNoY=;
 b=XedjZuWxZvDCfnZwvd9vJfITMew+9Q9bEhbD+HV8a+1JRPbK1ATtEy8fHumWQ++qLu
 dDaRBEKZ1LdGzuWWjO4S8CZ1aT6x1Lir8HULEUR/GFO7T4xrRcgc5GaZp0FPcdctJijr
 Wbe1iV7iRhvBaDlZ15TniIbr2TCZAOuyJEpSc3BEYSAcmu8lqJ7wa6rXhfiKaQW0v08y
 j2cvb6kCNEmUusjgQ+CyIJrCdgLYCmTiZZITEVlewFwfUghvD9MaA39UNPzxOs87JZfZ
 xIMO1ZIoHx+tsAKS6Re/NK388tbxXkz2KV0z1pmybBK2NimoejoIbvmNaCD13Bh+HM5X
 dPiA==
X-Gm-Message-State: AAQBX9dy8WzDthditQBUQ66NRTTPJbUsXV9ZmLmW1rNwsQk4+sL3A4bL
 jl2Oob13IyCjYegYarx8dFA=
X-Google-Smtp-Source: AKy350aN3PsOr81dbQugpISlk+yjR+a+4/2N8Qu7GaXUJdAVlidoOhFCKUKxX0oN92RzWan4aBS9aQ==
X-Received: by 2002:a5d:5957:0:b0:2f4:3b2c:1b2e with SMTP id
 e23-20020a5d5957000000b002f43b2c1b2emr951041wri.31.1681985175440; 
 Thu, 20 Apr 2023 03:06:15 -0700 (PDT)
Received: from localhost.localdomain
 (aftr-62-216-205-208.dynamic.mnet-online.de. [62.216.205.208])
 by smtp.googlemail.com with ESMTPSA id
 l11-20020a5d674b000000b0030276f42f08sm201410wrw.88.2023.04.20.03.06.14
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Thu, 20 Apr 2023 03:06:14 -0700 (PDT)
From: Johannes Thumshirn <jth@kernel.org>
To: axboe@kernel.dk
Date: Thu, 20 Apr 2023 12:05:00 +0200
Message-Id: <20230420100501.32981-22-jth@kernel.org>
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
Subject: [dm-devel] [PATCH v4 21/22] fs: iomap: use __bio_add_folio where
 possible
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
Cc: linux-block@vger.kernel.org, damien.lemoal@wdc.com, kch@nvidia.com,
 agruenba@redhat.com, linux-mm@kvack.org, shaggy@kernel.org,
 johannes.thumshirn@wdc.com, snitzer@kernel.org,
 jfs-discussion@lists.sourceforge.net, willy@infradead.org, ming.lei@redhat.com,
 cluster-devel@redhat.com, linux-fsdevel@vger.kernel.org, dm-devel@redhat.com,
 dsterba@suse.com, linux-raid@vger.kernel.org, song@kernel.org, hch@lst.de,
 linux-btrfs@vger.kernel.org, rpeterso@redhat.com
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.7
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: kernel.org
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

From: Johannes Thumshirn <johannes.thumshirn@wdc.com>

When the iomap buffered-io code can't add a folio to a bio, it allocates a
new bio and adds the folio to that one. This is done using bio_add_folio(),
but doesn't check for errors.

As adding a folio to a newly created bio can't fail, use the newly
introduced __bio_add_folio() function.

Signed-off-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
---
 fs/iomap/buffered-io.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/fs/iomap/buffered-io.c b/fs/iomap/buffered-io.c
index 6f4c97a6d7e9..473598b68067 100644
--- a/fs/iomap/buffered-io.c
+++ b/fs/iomap/buffered-io.c
@@ -312,7 +312,7 @@ static loff_t iomap_readpage_iter(const struct iomap_iter *iter,
 			ctx->bio->bi_opf |= REQ_RAHEAD;
 		ctx->bio->bi_iter.bi_sector = sector;
 		ctx->bio->bi_end_io = iomap_read_end_io;
-		bio_add_folio(ctx->bio, folio, plen, poff);
+		__bio_add_folio(ctx->bio, folio, plen, poff);
 	}
 
 done:
@@ -546,7 +546,7 @@ static int iomap_read_folio_sync(loff_t block_start, struct folio *folio,
 
 	bio_init(&bio, iomap->bdev, &bvec, 1, REQ_OP_READ);
 	bio.bi_iter.bi_sector = iomap_sector(iomap, block_start);
-	bio_add_folio(&bio, folio, plen, poff);
+	__bio_add_folio(&bio, folio, plen, poff);
 	return submit_bio_wait(&bio);
 }
 
@@ -1589,7 +1589,7 @@ iomap_add_to_ioend(struct inode *inode, loff_t pos, struct folio *folio,
 
 	if (!bio_add_folio(wpc->ioend->io_bio, folio, len, poff)) {
 		wpc->ioend->io_bio = iomap_chain_bio(wpc->ioend->io_bio);
-		bio_add_folio(wpc->ioend->io_bio, folio, len, poff);
+		__bio_add_folio(wpc->ioend->io_bio, folio, len, poff);
 	}
 
 	if (iop)
-- 
2.39.2

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

