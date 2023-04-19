Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 896B5C77B78
	for <dm-devel@archiver.kernel.org>; Thu, 20 Apr 2023 06:57:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1681973839;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=kXpB421/CzufXNePUa2LWEgklC+TV4eWTh1Q6/O1j+U=;
	b=fvg+tRh0wddYcq0Hxd2Y2inP6eAV1eBoKnvf5cmnnek/3lMn466IhMUuB7dGMrtoK2zCyn
	Op3um/Q5fDA2vGNb4XhwhzRdzNcG1G3ONX1WkQVtMiYglwX94HPIyqXh+3NT4TjGTvg/+f
	7K9QdDxvZN2tbn7qxLHQRY4NkTq5QxE=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-567-_Lfb3TpvOvSErFsePu5_kw-1; Thu, 20 Apr 2023 02:57:17 -0400
X-MC-Unique: _Lfb3TpvOvSErFsePu5_kw-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id F1F8C2807D86;
	Thu, 20 Apr 2023 06:57:08 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id DF910C164E7;
	Thu, 20 Apr 2023 06:57:08 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id BD25C1946A4C;
	Thu, 20 Apr 2023 06:57:06 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
 [10.11.54.4])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id DC46419465B1
 for <dm-devel@listman.corp.redhat.com>; Wed, 19 Apr 2023 14:10:56 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id BE6A52026E1C; Wed, 19 Apr 2023 14:10:56 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast09.extmail.prod.ext.rdu2.redhat.com [10.11.55.25])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id B73132026D25
 for <dm-devel@redhat.com>; Wed, 19 Apr 2023 14:10:56 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [205.139.110.61])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 9A7E02999B31
 for <dm-devel@redhat.com>; Wed, 19 Apr 2023 14:10:56 +0000 (UTC)
Received: from mail-wm1-f45.google.com (mail-wm1-f45.google.com
 [209.85.128.45]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-300-7hk5TTWBPY2HHwDDfAh7Cw-1; Wed, 19 Apr 2023 10:10:51 -0400
X-MC-Unique: 7hk5TTWBPY2HHwDDfAh7Cw-1
Received: by mail-wm1-f45.google.com with SMTP id r15so7632062wmo.1;
 Wed, 19 Apr 2023 07:10:49 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20221208; t=1681913449; x=1684505449;
 h=content-transfer-encoding:mime-version:references:in-reply-to
 :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
 :subject:date:message-id:reply-to;
 bh=D58hy5/Cr3/DLqz8bPLF+cijdU1EeyUsaB6+w7+K1A4=;
 b=XrXQPqx++6wob6VwNH37IJGZlpjDsUIFWYGE/GHExgtFqnrShXYIGrKxBT5tIcPobV
 YBwIde+4Uo4DixA6FM3sc5qQF5CmL/GeICYScGfENxs+Nb+9LFQTrcYeHF224RPsRWrl
 hFH50FakSYknNkKggVn6MiGIAVEC8TGrf8sgW8R3YEGho5e+H9rixlwD/J1+QXAg8MIk
 i6qFbiQZO9Z4QNSt7Fwn3+3mmMr6UgokrWox5+eaLn6/anhc57VblsRQIXx5z8wAGJRP
 PlADgfiG0ZKVTv5r0kwYgSBDoNAz5wy3lhEm4EQIrze/KbFBLZNqwaRzKU0L1nPMGd6u
 9wBA==
X-Gm-Message-State: AAQBX9cB1m0iRHup/Ai8aw3C5MyrFr+yG01p2dR3+f+flJrv7EBjHBej
 1hBy/ks/a/ev0MqDpXTvd5M=
X-Google-Smtp-Source: AKy350YVGom4jRqLlz1SlZT1B3VxAH80TCdfTvTrIcrTBS48HRxL8jnx3ehntNMClr8C3qNVzqHCog==
X-Received: by 2002:a05:600c:24d:b0:3f0:373d:780 with SMTP id
 13-20020a05600c024d00b003f0373d0780mr16769739wmj.34.1681913448956; 
 Wed, 19 Apr 2023 07:10:48 -0700 (PDT)
Received: from localhost.localdomain
 (aftr-62-216-205-204.dynamic.mnet-online.de. [62.216.205.204])
 by smtp.googlemail.com with ESMTPSA id
 q17-20020a5d61d1000000b002faaa9a1721sm7612089wrv.58.2023.04.19.07.10.47
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Wed, 19 Apr 2023 07:10:48 -0700 (PDT)
From: Johannes Thumshirn <jth@kernel.org>
To: axboe@kernel.dk
Date: Wed, 19 Apr 2023 16:09:23 +0200
Message-Id: <20230419140929.5924-14-jth@kernel.org>
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
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.4
X-Mailman-Approved-At: Thu, 20 Apr 2023 06:57:04 +0000
Subject: [dm-devel] [PATCH v3 13/19] zram: use __bio_add_page for adding
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
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.8
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: kernel.org
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

From: Johannes Thumshirn <johannes.thumshirn@wdc.com>

The zram writeback code uses bio_add_page() to add a page to a newly
created bio. bio_add_page() can fail, but the return value is never
checked.

Use __bio_add_page() as adding a single page to a newly created bio is
guaranteed to succeed.

This brings us a step closer to marking bio_add_page() as __must_check.

Signed-off-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Reviewed-by: Damien Le Moal <damien.lemoal@opensource.wdc.com>
---
 drivers/block/zram/zram_drv.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/block/zram/zram_drv.c b/drivers/block/zram/zram_drv.c
index aa490da3cef2..9179bd0f248c 100644
--- a/drivers/block/zram/zram_drv.c
+++ b/drivers/block/zram/zram_drv.c
@@ -760,7 +760,7 @@ static ssize_t writeback_store(struct device *dev,
 			 REQ_OP_WRITE | REQ_SYNC);
 		bio.bi_iter.bi_sector = blk_idx * (PAGE_SIZE >> 9);
 
-		bio_add_page(&bio, bvec.bv_page, bvec.bv_len,
+		__bio_add_page(&bio, bvec.bv_page, bvec.bv_len,
 				bvec.bv_offset);
 		/*
 		 * XXX: A single page IO would be inefficient for write
-- 
2.39.2

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

