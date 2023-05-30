Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8657DC77B73
	for <dm-devel@archiver.kernel.org>; Tue, 30 May 2023 15:52:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1685461925;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=LR9YmlQDOHct7MUSOtSjcgJiE3wrzSuEDR5r3xeYqtg=;
	b=edGZF2tLabahR43OngF3Jv6ld7qwxh6rHGnFMdmmis97L5EhqhdseQsaXVsDl01reeqkwO
	Ktx5TlTTMYXa8LAic4CTUaS9O4swWK6uZbZ/99H6BhQnh9mHITrjMcBXcIrV68Zp9W6goq
	aCjIeIIdMLPisFVhF4XDXYtCgVc9OCo=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-423-P5qSiXhCMWOxJA8gBM_rPQ-1; Tue, 30 May 2023 11:52:02 -0400
X-MC-Unique: P5qSiXhCMWOxJA8gBM_rPQ-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 284D63C11CD7;
	Tue, 30 May 2023 15:52:00 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 17050140E955;
	Tue, 30 May 2023 15:52:00 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id CC0621946A45;
	Tue, 30 May 2023 15:50:53 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com
 [10.11.54.7])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 624D919452CA
 for <dm-devel@listman.corp.redhat.com>; Tue, 30 May 2023 15:50:23 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 45037140E957; Tue, 30 May 2023 15:50:23 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast02.extmail.prod.ext.rdu2.redhat.com [10.11.55.18])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 3BCA9140E955
 for <dm-devel@redhat.com>; Tue, 30 May 2023 15:50:23 +0000 (UTC)
Received: from us-smtp-inbound-1.mimecast.com (us-smtp-2.mimecast.com
 [207.211.31.81])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 1F6BD8028B2
 for <dm-devel@redhat.com>; Tue, 30 May 2023 15:50:23 +0000 (UTC)
Received: from esa6.hgst.iphmx.com (esa6.hgst.iphmx.com [216.71.154.45]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-637-6BmMRIoiORqt-0BN6faARA-6; Tue, 30 May 2023 11:50:19 -0400
X-MC-Unique: 6BmMRIoiORqt-0BN6faARA-6
X-IronPort-AV: E=Sophos;i="6.00,204,1681142400"; d="scan'208";a="231986052"
Received: from uls-op-cesaip01.wdc.com (HELO uls-op-cesaep01.wdc.com)
 ([199.255.45.14])
 by ob1.hgst.iphmx.com with ESMTP; 30 May 2023 23:50:18 +0800
IronPort-SDR: DyQu/Bz9itPCoV3gVbQwwXXHyM6CLDT487GpBA3jH0jYeFn1Eh7FvJXJpKdEcJO8xAJHkKuFzf
 0rw0vQd10B14M0Mn9oQ8QBxK9rLgcRsOQjFPMmlKEsQEtEO0RoDeeOk/GFyaclh1qAlYhB5tIw
 XhX1nLxXxRslL5H6h1TcN96vh/bDneidY+9FhsOnAvqSQv+Gyb7y8BYeiKw22SXlsq28APwVgh
 AZYj9Xvqqifp4Wu/gkitGltfN0keb2Lhoe+CrkgTlKs2yndcSBsaX07AT/0G+jsHC1M4eKTeiv
 MWQ=
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
 by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256;
 30 May 2023 08:05:11 -0700
IronPort-SDR: nWMXgYPXj9My0dJwx11mPIKRe2pSzWz6O3nUVEtHmwd7YXnITNPMVp+01mOZjGN5zhcXbH+IdK
 m4NVW5MyTKxZspeJpQdq/5lcWtTCTrtHWknfnsfGCvolyx2j0ZqjEnJPHzs6IqRD93mSDPBKaJ
 W3wnvvvnGzwMhFNe3tC3vpLamIMSeTnweXnIJe6DaIylSDsi76tjZmEcCIggRMz2kCpsmYogzT
 umSo039ixODhCfl7GjDCN2dVBtWEhKpEVTPbeeTLYiBLVoeQNEC7m5EzM08Q+jnw67MjY23eAu
 xTo=
WDCIronportException: Internal
Received: from unknown (HELO redsun91.ssa.fujisawa.hgst.com) ([10.149.66.6])
 by uls-op-cesaip02.wdc.com with ESMTP; 30 May 2023 08:50:15 -0700
From: Johannes Thumshirn <johannes.thumshirn@wdc.com>
To: Jens Axboe <axboe@kernel.dk>
Date: Tue, 30 May 2023 08:49:19 -0700
Message-Id: <e1c7ed59e2d2b69567ef2d9925fa997ecb7b4822.1685461490.git.johannes.thumshirn@wdc.com>
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
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.7
Subject: [dm-devel] [PATCH v6 16/20] dm-crypt: check if adding pages to
 clone bio fails
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
 Bob Peterson <rpeterso@redhat.com>, Mikulas Patocka <mpatocka@redhat.com>,
 linux-block@vger.kernel.org, Damien Le Moal <damien.lemoal@wdc.com>,
 gouhao@uniontech.com, linux-mm@kvack.org,
 Johannes Thumshirn <johannes.thumshirn@wdc.com>, linux-fsdevel@vger.kernel.org
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.7
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: wdc.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Check if adding pages to clone bio fails and if it does retry with
reclaim. This mirrors the behaviour of page allocation in
crypt_alloc_buffer().

This way we can mark bio_add_pages as __must_check.

Reviewed-by: Damien Le Moal <damien.lemoal@opensource.wdc.com>
Signed-off-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
---
 drivers/md/dm-crypt.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/md/dm-crypt.c b/drivers/md/dm-crypt.c
index 8b47b913ee83..0dd231e61757 100644
--- a/drivers/md/dm-crypt.c
+++ b/drivers/md/dm-crypt.c
@@ -1693,7 +1693,10 @@ static struct bio *crypt_alloc_buffer(struct dm_crypt_io *io, unsigned int size)
 
 		len = (remaining_size > PAGE_SIZE) ? PAGE_SIZE : remaining_size;
 
-		bio_add_page(clone, page, len, 0);
+		if (!bio_add_page(clone, page, len, 0)) {
+			WARN_ONCE(1, "Adding page to bio failed\n");
+			return NULL;
+		}
 
 		remaining_size -= len;
 	}
-- 
2.40.1

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

