Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 12F54C7EE31
	for <dm-devel@archiver.kernel.org>; Wed, 31 May 2023 11:41:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1685533289;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=Y3gX9sTZI2Ym84nReS7JQL1LUhP3zJr58rVhSE0plRQ=;
	b=guan9TssDl/sIGxKta7y53rHbyHgJ8648i4/LADD/McmwcoWfjoScicv3eSTsiXsJmTY9F
	ZccSCjUCBr5oQH2SaI2qfdjjsYOI7UspI1tccYqxBbzMmtcDXXtHSqso8ngDXc8PA53QnT
	N45l0Mkd8tLRn+NOYVpZVUBAOm077l4=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-422-NpJJQmJyMvqna19s76dPdw-1; Wed, 31 May 2023 07:41:26 -0400
X-MC-Unique: NpJJQmJyMvqna19s76dPdw-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 7047D811E92;
	Wed, 31 May 2023 11:41:24 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 5A1B940CFD47;
	Wed, 31 May 2023 11:41:24 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 3C83919452C1;
	Wed, 31 May 2023 11:41:24 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com
 [10.11.54.9])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id D16D41946595
 for <dm-devel@listman.corp.redhat.com>; Wed, 31 May 2023 11:39:12 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id C18B8400DFF; Wed, 31 May 2023 11:39:12 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast09.extmail.prod.ext.rdu2.redhat.com [10.11.55.25])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id BA084492B00
 for <dm-devel@redhat.com>; Wed, 31 May 2023 11:39:12 +0000 (UTC)
Received: from us-smtp-inbound-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [205.139.110.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 9F96F280D58E
 for <dm-devel@redhat.com>; Wed, 31 May 2023 11:39:12 +0000 (UTC)
Received: from esa3.hgst.iphmx.com (esa3.hgst.iphmx.com [216.71.153.141]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-98-aZEc2AKeMXe75Dpa4WXVbg-2; Wed, 31 May 2023 07:39:07 -0400
X-MC-Unique: aZEc2AKeMXe75Dpa4WXVbg-2
X-IronPort-AV: E=Sophos;i="6.00,207,1681142400"; d="scan'208";a="237001372"
Received: from uls-op-cesaip02.wdc.com (HELO uls-op-cesaep02.wdc.com)
 ([199.255.45.15])
 by ob1.hgst.iphmx.com with ESMTP; 31 May 2023 19:39:05 +0800
IronPort-SDR: vj+lT1ofmInwqMZaAKWO73ciWwm+T0MsGZaAJVdrBj80mSpBWYDCPXU4C0k8YiFjomk3X5lk/d
 jGyIYXYciaQSTsFbSmqqOGwOxTvPaaHzJ4y63nqdczI5TxYi8QUK/E93Ng1g65J4H9pd2Co4dd
 FG4dyTBHsf8n8imqYw9Baias1M2HClgpSroNceF4n9YAq/5wkTiKm3og0bmaJv803TD1hYi1Dn
 sm2EgMoZFLFR1/n/g/2a21sQdIDD+K6mZX19LorhFhYaeqAvRoSAQkiFyPGLMR6yufYp1RabI3
 fq8=
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
 by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256;
 31 May 2023 03:48:17 -0700
IronPort-SDR: dJb/CRSP3Swr2x2jiC+paW0dnGjzm6Bz1GAlGKlca4A7q/x/ky8HuVCu7AA6VYX5uJ0Ewh5t3x
 q+iWl5HlhzQMV3D+zIls3XMo7zp44uRPShf3qZmHTVjlHtCyJhoy3EfEEf+h9hvbiHfRi/SZaM
 d9U7RaXciqVsSQr8sZoG/qgLo3wszKIv+4kHv8jpR5BKyb+/H8r/7FEY1iK6JWuO591/DsqLKl
 X5ltcT6eaJJce6CRG0s8vZd0Q95JNHPvX3nOAbDWSbgMiVFC4dhkCvQP9zoXpp+VrisQgvbaoC
 Beg=
WDCIronportException: Internal
Received: from unknown (HELO redsun91.ssa.fujisawa.hgst.com) ([10.149.66.6])
 by uls-op-cesaip02.wdc.com with ESMTP; 31 May 2023 04:39:02 -0700
From: Johannes Thumshirn <johannes.thumshirn@wdc.com>
To: Jens Axboe <axboe@kernel.dk>
Date: Wed, 31 May 2023 04:38:01 -0700
Message-ID: <e809b83d60d9fb0f65a8116b3e50f1432f594725.1685461490.git.johannes.thumshirn@wdc.com>
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
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.9
Subject: [dm-devel] [PATCH v6 19/20] fs: iomap: use __bio_add_folio where
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
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.1
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: wdc.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-ID: <20230531113801.4OaLNABTMu7TJ5UM7aCHfcDHd2AfbQ8AljszdS4bP_M@z>

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
index 063133ec77f4..42c5fc0ad329 100644
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
@@ -539,7 +539,7 @@ static int iomap_read_folio_sync(loff_t block_start, struct folio *folio,
 
 	bio_init(&bio, iomap->bdev, &bvec, 1, REQ_OP_READ);
 	bio.bi_iter.bi_sector = iomap_sector(iomap, block_start);
-	bio_add_folio(&bio, folio, plen, poff);
+	__bio_add_folio(&bio, folio, plen, poff);
 	return submit_bio_wait(&bio);
 }
 
@@ -1582,7 +1582,7 @@ iomap_add_to_ioend(struct inode *inode, loff_t pos, struct folio *folio,
 
 	if (!bio_add_folio(wpc->ioend->io_bio, folio, len, poff)) {
 		wpc->ioend->io_bio = iomap_chain_bio(wpc->ioend->io_bio);
-		bio_add_folio(wpc->ioend->io_bio, folio, len, poff);
+		__bio_add_folio(wpc->ioend->io_bio, folio, len, poff);
 	}
 
 	if (iop)
-- 
2.40.1

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

