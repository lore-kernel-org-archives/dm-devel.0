Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 92E14C43334
	for <dm-devel@archiver.kernel.org>; Tue, 14 Jun 2022 09:24:32 +0000 (UTC)
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-9-j-rwMhi4Me6y0L9b0ozIng-1; Tue, 14 Jun 2022 05:24:30 -0400
X-MC-Unique: j-rwMhi4Me6y0L9b0ozIng-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 65AF18027EE;
	Tue, 14 Jun 2022 09:24:28 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 104D6492CA2;
	Tue, 14 Jun 2022 09:24:28 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id AACCA194706D;
	Tue, 14 Jun 2022 09:24:27 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com
 [10.11.54.10])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id C55BE1947067
 for <dm-devel@listman.corp.redhat.com>; Tue, 14 Jun 2022 09:24:26 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id A2105415F5E; Tue, 14 Jun 2022 09:24:26 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast05.extmail.prod.ext.rdu2.redhat.com [10.11.55.21])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 9D96B492C3B
 for <dm-devel@redhat.com>; Tue, 14 Jun 2022 09:24:26 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [207.211.31.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 8565E80A0B5
 for <dm-devel@redhat.com>; Tue, 14 Jun 2022 09:24:26 +0000 (UTC)
Received: from bombadil.infradead.org (bombadil.infradead.org
 [198.137.202.133]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-571-ZYDMZQDPNwWKzn87ZqmVHA-1; Tue, 14 Jun 2022 05:24:24 -0400
X-MC-Unique: ZYDMZQDPNwWKzn87ZqmVHA-1
Received: from [2001:4bb8:180:36f6:1fed:6d48:cf16:d13c] (helo=localhost)
 by bombadil.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
 id 1o12YP-008ZdX-Tp; Tue, 14 Jun 2022 09:09:42 +0000
From: Christoph Hellwig <hch@lst.de>
To: Jens Axboe <axboe@kernel.dk>
Date: Tue, 14 Jun 2022 11:09:29 +0200
Message-Id: <20220614090934.570632-2-hch@lst.de>
In-Reply-To: <20220614090934.570632-1-hch@lst.de>
References: <20220614090934.570632-1-hch@lst.de>
MIME-Version: 1.0
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by
 bombadil.infradead.org. See http://www.infradead.org/rpr.html
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.10
Subject: [dm-devel] [PATCH 1/6] block: factor out a chunk_size_left helper
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
Cc: linux-block@vger.kernel.org, dm-devel@redhat.com,
 Mike Snitzer <snitzer@kernel.org>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.9
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Factor out a helper from blk_max_size_offset so that it can be reused
independently.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 include/linux/blkdev.h | 19 +++++++++++++------
 1 file changed, 13 insertions(+), 6 deletions(-)

diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index 914c613d81da7..e66ad451274ec 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -933,6 +933,17 @@ static inline unsigned int blk_queue_get_max_sectors(struct request_queue *q,
 	return q->limits.max_sectors;
 }
 
+/*
+ * Return how much of the chunk is left to be used for I/O at a given offset.
+ */
+static inline unsigned int blk_chunk_sectors_left(sector_t offset,
+		unsigned int chunk_sectors)
+{
+	if (unlikely(!is_power_of_2(chunk_sectors)))
+		return chunk_sectors - sector_div(offset, chunk_sectors);
+	return chunk_sectors - (offset & (chunk_sectors - 1));
+}
+
 /*
  * Return maximum size of a request at given offset. Only valid for
  * file system requests.
@@ -948,12 +959,8 @@ static inline unsigned int blk_max_size_offset(struct request_queue *q,
 			return q->limits.max_sectors;
 	}
 
-	if (likely(is_power_of_2(chunk_sectors)))
-		chunk_sectors -= offset & (chunk_sectors - 1);
-	else
-		chunk_sectors -= sector_div(offset, chunk_sectors);
-
-	return min(q->limits.max_sectors, chunk_sectors);
+	return min(q->limits.max_sectors,
+			blk_chunk_sectors_left(offset, chunk_sectors));
 }
 
 /*
-- 
2.30.2

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

