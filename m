Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 05F41C77B73
	for <dm-devel@archiver.kernel.org>; Wed, 31 May 2023 11:40:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1685533253;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=E0qjVSGtmAIinjvkz8Fv9xV0cP570Zj1dmCX2tj5jII=;
	b=S2TSamilmOfCpQC1omHWg1rTYxaj6KIeHiaQwjLsgCe3T6yLU1cUPRjZSfLMn+PFSWt+LV
	La5VuNShJTlrJtdMN5nAdSrF7wkXgdSJSxLJGMnz9Fask5ybeHkPu8eIA+VOA7onOEyO5O
	6UPVVyWQUsYevsOxYMnsS99gTHCHMRM=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-575-suMFQuEJNuaKieFXPIXWHg-1; Wed, 31 May 2023 07:40:49 -0400
X-MC-Unique: suMFQuEJNuaKieFXPIXWHg-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 103278030CD;
	Wed, 31 May 2023 11:40:48 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 0074140C6EC4;
	Wed, 31 May 2023 11:40:48 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id B664619465A0;
	Wed, 31 May 2023 11:40:42 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com
 [10.11.54.10])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 2AC481946595
 for <dm-devel@listman.corp.redhat.com>; Wed, 31 May 2023 11:39:14 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id F064B492B0B; Wed, 31 May 2023 11:39:13 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast02.extmail.prod.ext.rdu2.redhat.com [10.11.55.18])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id E94DC492B0A
 for <dm-devel@redhat.com>; Wed, 31 May 2023 11:39:13 +0000 (UTC)
Received: from us-smtp-inbound-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [207.211.31.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id C0E0E802355
 for <dm-devel@redhat.com>; Wed, 31 May 2023 11:39:13 +0000 (UTC)
Received: from esa3.hgst.iphmx.com (esa3.hgst.iphmx.com [216.71.153.141]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-625-CfxgJiaOPnGBnQ6BTd0xCQ-1; Wed, 31 May 2023 07:39:10 -0400
X-MC-Unique: CfxgJiaOPnGBnQ6BTd0xCQ-1
X-IronPort-AV: E=Sophos;i="6.00,207,1681142400"; d="scan'208";a="237001376"
Received: from uls-op-cesaip02.wdc.com (HELO uls-op-cesaep02.wdc.com)
 ([199.255.45.15])
 by ob1.hgst.iphmx.com with ESMTP; 31 May 2023 19:39:08 +0800
IronPort-SDR: mnDHecP+BlAOGVAl/Jvf+zQZZ7OwbfcO+B4KrT6Pb3cZ6BdR4jhyk0cVjDMAcvaBLfyZAPkzeo
 BFvT1htiOKlz/OkzvU++aP6dw3q2OaOvEhPlOWaPD3ZgjJ27u4PvFyDdwZy7XI4ObWbHFfc0gV
 jqp2WelwWwZiiwzqWRduMMRdQyXrwDxp0+eBUfElv+ap3xYKMp9Bs8LvBJRi0Kf0IEpmZ+6OQw
 +JeroxzDrDj07MlK8RXdv3x3G2F/uC9+zzI6tZT4Q8aO+FnDc8viKlwYF9MV7L4JXa28Ze3Q5q
 b4k=
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
 by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256;
 31 May 2023 03:48:20 -0700
IronPort-SDR: 8+Hdbq9JLo3j5INsLQlm6RtixEL95tqPyWSgg+3x81yQ5YpWjxlpDvvFf8C2gDpDL46OYeHMF7
 m502e3zSOaUbGvCXIe7yKR9yL0BHb3HBowtYM+/iT7iBMmtUUi7PSQ4hTrJAnGBjLnu1CVA5te
 bypZvx72taZMiH6TrSz8fb5NFkjFwSjOlPGNDGHmkMdbexVoR2mJv4XBGnJ7ALe50hf08OiFnB
 2J/tij7jzk4b7zRp70+No61r07ArBbAE7p376Qn5n8sBRZOrXcPJAPnX0eqzkQx6QywpRwQ1xb
 Wag=
WDCIronportException: Internal
Received: from unknown (HELO redsun91.ssa.fujisawa.hgst.com) ([10.149.66.6])
 by uls-op-cesaip02.wdc.com with ESMTP; 31 May 2023 04:39:05 -0700
From: Johannes Thumshirn <johannes.thumshirn@wdc.com>
To: Jens Axboe <axboe@kernel.dk>
Date: Wed, 31 May 2023 04:38:02 -0700
Message-ID: <3d45098a7640897cbace54713efe10d88b74c160.1685461490.git.johannes.thumshirn@wdc.com>
In-Reply-To: <cover.1685461490.git.johannes.thumshirn@wdc.com>
References: <cover.1685461490.git.johannes.thumshirn@wdc.com>
MIME-Version: 1.0
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.10
Subject: [dm-devel] [PATCH v6 20/20] block: mark bio_add_folio as
 __must_check
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
Cc: linux-raid@vger.kernel.org, Damien Le Moal <damien.lemoal@wdc.com>,
 cluster-devel@redhat.com, Chaitanya Kulkarni <kch@nvidia.com>,
 Andreas Gruenbacher <agruenba@redhat.com>, Song Liu <song@kernel.org>,
 Dave Kleikamp <shaggy@kernel.org>,
 Johannes Thumshirn <johannes.thumshirn@wdc.com>,
 Mike Snitzer <snitzer@kernel.org>, jfs-discussion@lists.sourceforge.net,
 Matthew Wilcox <willy@infradead.org>, Ming Lei <ming.lei@redhat.com>,
 linux-block@vger.kernel.org, linux-mm@kvack.org, dm-devel@redhat.com,
 Mikulas Patocka <mpatocka@redhat.com>, linux-fsdevel@vger.kernel.org,
 gouha7@uniontech.com, Christoph Hellwig <hch@lst.de>,
 Bob Peterson <rpeterso@redhat.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.2
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: wdc.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-ID: <20230531113802.W1SMzKjXiqHCCdqNSWEuYIGTZ_WsnlnnD3R6g7i6n3Q@z>

Now that all callers of bio_add_folio() check the return value, mark it as
__must_check.

Signed-off-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
---
 include/linux/bio.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/linux/bio.h b/include/linux/bio.h
index 4232a17e6b10..fef9f3085a02 100644
--- a/include/linux/bio.h
+++ b/include/linux/bio.h
@@ -466,7 +466,7 @@ void bio_reset(struct bio *bio, struct block_device *bdev, blk_opf_t opf);
 void bio_chain(struct bio *, struct bio *);
 
 int __must_check bio_add_page(struct bio *, struct page *, unsigned len, unsigned off);
-bool bio_add_folio(struct bio *, struct folio *, size_t len, size_t off);
+bool __must_check bio_add_folio(struct bio *, struct folio *, size_t len, size_t off);
 extern int bio_add_pc_page(struct request_queue *, struct bio *, struct page *,
 			   unsigned int, unsigned int);
 int bio_add_zone_append_page(struct bio *bio, struct page *page,
-- 
2.40.1

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

