Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9B60AC761A6
	for <dm-devel@archiver.kernel.org>; Thu, 30 Mar 2023 10:45:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1680173114;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=RR0ZePM/yZPp48wl/Dj9eqJZ/8+24oIFYGr9NUhsd4s=;
	b=Y9tqzjS/pWpKUhxJTazKdDt7GTtBzxl1CkL3qgfD+H3dS2gBl7dGNjKKkn8W2GxZqxLcjm
	DSL/BHE9BoGFig01+JgOGqeTk9S8ATAxtWr6cCvqaN0tGkVPuq/rcPnYxhcVK0QuK7Elw5
	mlJPNv1eBpa/pGgG8CNswEK361YANZg=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-593-I_8B5sqLNDq6HpkHzWeZCA-1; Thu, 30 Mar 2023 06:45:11 -0400
X-MC-Unique: I_8B5sqLNDq6HpkHzWeZCA-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id B8BD3802D1A;
	Thu, 30 Mar 2023 10:45:09 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 666DC1121330;
	Thu, 30 Mar 2023 10:45:09 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 55B29194658F;
	Thu, 30 Mar 2023 10:45:09 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
 [10.11.54.4])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id CFA601946587
 for <dm-devel@listman.corp.redhat.com>; Thu, 30 Mar 2023 10:45:07 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id B30A4202701F; Thu, 30 Mar 2023 10:45:07 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast08.extmail.prod.ext.rdu2.redhat.com [10.11.55.24])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id AAC04202701E
 for <dm-devel@redhat.com>; Thu, 30 Mar 2023 10:45:07 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [207.211.31.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 898403823A09
 for <dm-devel@redhat.com>; Thu, 30 Mar 2023 10:45:07 +0000 (UTC)
Received: from esa1.hgst.iphmx.com (esa1.hgst.iphmx.com [68.232.141.245]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-599-tREiTXPSOjaY-VgfbpnyVQ-20; Thu, 30 Mar 2023 06:45:03 -0400
X-MC-Unique: tREiTXPSOjaY-VgfbpnyVQ-20
X-IronPort-AV: E=Sophos;i="5.98,303,1673884800"; d="scan'208";a="338948214"
Received: from uls-op-cesaip02.wdc.com (HELO uls-op-cesaep02.wdc.com)
 ([199.255.45.15])
 by ob1.hgst.iphmx.com with ESMTP; 30 Mar 2023 18:45:02 +0800
IronPort-SDR: FTfZVyAiw3tFVtBqqu2DdinT42HDX+yd9hq/laGBHqClarz5PsCepc+osz7ukyPDzRC3Fgkw9D
 +sVSKcBABpbeqdPlRGoQLfsSMSCbIFOYvlmEWB0OAtavObPoPXcF5jwl6FrkjgMhsflx0bPzdy
 T58QCLajKPPuF0dxLQbxv5G/h6qF35xtARww9s7IDrMvdyUqvw8Ydhn59gyd1JMDAqNSE6yy5t
 F61/BNzhR76BawE+oAdqQ/h9EDISvHkEN8cywXhBTlK39lDAUv54M9OAtjb29pXtWsA85tJj9i
 Cro=
Received: from uls-op-cesaip01.wdc.com ([10.248.3.36])
 by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256;
 30 Mar 2023 02:55:29 -0700
IronPort-SDR: 9/iVByN1BTBiF+2N/dyRq0R7dQSPqShiTdspahbVYlwZj+qd277O1HWwqfoLFDxzoWSe+cmGNO
 qkqMCZzgrdZnDhpQxYdEe8150myn5LsK8KEx5pL72+ObD0hqMaaHSizvdtrMKOqlTNP+VQELhc
 NlTnbrlHYwL6lfM55WWo+X+nqbpVvrNh8MXJJfN+oROGcrGXbtZ95QXnOLEHZI8U/WSie1EYFD
 ciM8A+htMWi8T8Q2A6kN9QQtMNJHy+EVASUqPt+O4sCYrrpZ40AnMpPDuYxlZJyUb2MJgf0HsW
 yDM=
WDCIronportException: Internal
Received: from unknown (HELO redsun91.ssa.fujisawa.hgst.com) ([10.149.66.72])
 by uls-op-cesaip01.wdc.com with ESMTP; 30 Mar 2023 03:45:00 -0700
From: Johannes Thumshirn <johannes.thumshirn@wdc.com>
To: Jens Axboe <axboe@kernel.dk>
Date: Thu, 30 Mar 2023 03:44:01 -0700
Message-Id: <981a2b8809dedbd6dd756d7af1df4251944f42b0.1680172791.git.johannes.thumshirn@wdc.com>
In-Reply-To: <cover.1680172791.git.johannes.thumshirn@wdc.com>
References: <cover.1680172791.git.johannes.thumshirn@wdc.com>
MIME-Version: 1.0
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.4
Subject: [dm-devel] [PATCH v2 19/19] block: mark bio_add_page as __must_check
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
Cc: Dave Kleikamp <shaggy@kernel.org>, jfs-discussion@lists.sourceforge.net,
 Song Liu <song@kernel.org>, dm-devel@redhat.com,
 Christoph Hellwig <hch@lst.de>, Andreas Gruenbacher <agruenba@redhat.com>,
 Damien Le Moal <damien.lemoal@opensource.wdc.com>,
 Matthew Wilcox <willy@infradead.org>, cluster-devel@redhat.com,
 Chaitanya Kulkarni <kch@nvidia.com>, Mike Snitzer <snitzer@kernel.org>,
 Ming Lei <ming.lei@redhat.com>, linux-raid@vger.kernel.org,
 Bob Peterson <rpeterso@redhat.com>, David Sterba <dsterba@suse.com>,
 linux-block@vger.kernel.org, Damien Le Moal <damien.lemoal@wdc.com>,
 linux-mm@kvack.org, Johannes Thumshirn <johannes.thumshirn@wdc.com>,
 linux-fsdevel@vger.kernel.org, linux-btrfs@vger.kernel.org
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.3
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: wdc.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Now that all users of bio_add_page check for the return value, mark
bio_add_page as __must_check.

Signed-off-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Reviewed-by: Damien Le Moal <damien.lemoal@opensource.wdc.com>
---
 include/linux/bio.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/linux/bio.h b/include/linux/bio.h
index d766be7152e1..0f8a8d7a6384 100644
--- a/include/linux/bio.h
+++ b/include/linux/bio.h
@@ -465,7 +465,7 @@ extern void bio_uninit(struct bio *);
 void bio_reset(struct bio *bio, struct block_device *bdev, blk_opf_t opf);
 void bio_chain(struct bio *, struct bio *);
 
-int bio_add_page(struct bio *, struct page *, unsigned len, unsigned off);
+int __must_check bio_add_page(struct bio *, struct page *, unsigned len, unsigned off);
 bool bio_add_folio(struct bio *, struct folio *, size_t len, size_t off);
 extern int bio_add_pc_page(struct request_queue *, struct bio *, struct page *,
 			   unsigned int, unsigned int);
-- 
2.39.2

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

