Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D3D92C77B7A
	for <dm-devel@archiver.kernel.org>; Wed, 31 May 2023 12:08:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1685534881;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=I9aWN9FzWZokBAPN0pa+gRGI8xBdqJ4fNuomwZEsVgw=;
	b=SXLysDr2oHf0c9KZzjsPUhsy219F4h6OgoaD+G71cRcjvuIZ0/yyJf879guUHbclKj/UNS
	8QCWKgcJLAgxsl+ZU8oRUIcBvTbikBq3ou8AaZsE3vxvDHstDibuP4sCQTb3L7eBQ633jf
	SEFNrdmC3W+uRwcD5T5fAIx/xEi4yJE=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-604-TBtGsA9qO5Sx_KuiLKUOlQ-1; Wed, 31 May 2023 08:07:58 -0400
X-MC-Unique: TBtGsA9qO5Sx_KuiLKUOlQ-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 2FBE73C0F235;
	Wed, 31 May 2023 12:07:56 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id DD907420AA;
	Wed, 31 May 2023 12:07:55 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 970A819451C7;
	Wed, 31 May 2023 12:07:45 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com
 [10.11.54.1])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 3175119465BA
 for <dm-devel@listman.corp.redhat.com>; Wed, 31 May 2023 11:51:58 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 0629840CFD46; Wed, 31 May 2023 11:51:58 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast03.extmail.prod.ext.rdu2.redhat.com [10.11.55.19])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id F37DA40CFD47
 for <dm-devel@redhat.com>; Wed, 31 May 2023 11:51:57 +0000 (UTC)
Received: from us-smtp-inbound-1.mimecast.com (us-smtp-2.mimecast.com
 [205.139.110.61])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id D9C00811E91
 for <dm-devel@redhat.com>; Wed, 31 May 2023 11:51:57 +0000 (UTC)
Received: from esa3.hgst.iphmx.com (esa3.hgst.iphmx.com [216.71.153.141]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-588-yk6sSV8-OoeIT-s3sY4CIA-4; Wed, 31 May 2023 07:51:54 -0400
X-MC-Unique: yk6sSV8-OoeIT-s3sY4CIA-4
X-IronPort-AV: E=Sophos;i="6.00,207,1681142400"; d="scan'208";a="237002012"
Received: from uls-op-cesaip02.wdc.com (HELO uls-op-cesaep02.wdc.com)
 ([199.255.45.15])
 by ob1.hgst.iphmx.com with ESMTP; 31 May 2023 19:51:52 +0800
IronPort-SDR: It5JX19klvDg3taP/DM477yYb7frVNjGL0lEUWpS9v/y930LSdGS7mFl0V8RuEA22ZSvHrW5yJ
 MusUxUo+vajKqcw391fZVqzE1cO5Nvy90AdAka8QIyG0bsqpS7ACf5uBBPx5CAfMLWAkGHMDrs
 mMBvhCObuvHPigoUPTz6KCaq/rWt6bl1CPICJQ9N0xR9wiA4qkibjcfaZJQdIsqZOVKvBkcRqp
 2RXP7vcnkSHXpxOQHBhN6rC+Kf658/wpnsshJF/BRPWWityr33mPCE0l0KPcjMIimQKuK8SJMD
 Nvc=
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
 by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256;
 31 May 2023 04:01:04 -0700
IronPort-SDR: K8DGvXh3flLPynticzqNOEK+cYmmrpCanEBz66JFrWIngUtekJYSQhCrCrQqqhG+xCFaPCQa2f
 kPJSf1LI5UoWCk4clEw/qwVZ0W4JIS0jS8S+dvN+TLf0ZfYCIO+3Xte4UP0xRPIscBgFVDQ2Kd
 i0oECfF+1dh8ufMGv5dV011PahNQRw/rJMUEPkg/QmDHoXKUFcS063SfGvdOMAWACqKfwoUrw7
 ZHc2iWsZBS8kDjkwhUtPmAIWhJo/MvPANH9LDUtKSOoqChVFdvi5WpUhFTDcEYLLYC3pqPKsMY
 Ipk=
WDCIronportException: Internal
Received: from unknown (HELO redsun91.ssa.fujisawa.hgst.com) ([10.149.66.6])
 by uls-op-cesaip02.wdc.com with ESMTP; 31 May 2023 04:51:50 -0700
From: Johannes Thumshirn <johannes.thumshirn@wdc.com>
To: Jens Axboe <axboe@kernel.dk>
Date: Wed, 31 May 2023 04:50:43 -0700
Message-Id: <381360a45ac3684120cfbe1e07685e9c36256e47.1685532726.git.johannes.thumshirn@wdc.com>
In-Reply-To: <cover.1685532726.git.johannes.thumshirn@wdc.com>
References: <cover.1685532726.git.johannes.thumshirn@wdc.com>
MIME-Version: 1.0
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.1
Subject: [dm-devel] [PATCH v7 20/20] block: mark bio_add_folio as
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
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.5
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: wdc.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Now that all callers of bio_add_folio() check the return value, mark it as
__must_check.

Reviewed-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
---
 include/linux/bio.h | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/include/linux/bio.h b/include/linux/bio.h
index f907d75af205..c7a9425d19ee 100644
--- a/include/linux/bio.h
+++ b/include/linux/bio.h
@@ -467,7 +467,8 @@ void bio_chain(struct bio *, struct bio *);
 
 int __must_check bio_add_page(struct bio *bio, struct page *page, unsigned len,
 			      unsigned off);
-bool bio_add_folio(struct bio *, struct folio *, size_t len, size_t off);
+bool __must_check bio_add_folio(struct bio *bio, struct folio *folio,
+				size_t len, size_t off);
 extern int bio_add_pc_page(struct request_queue *, struct bio *, struct page *,
 			   unsigned int, unsigned int);
 int bio_add_zone_append_page(struct bio *bio, struct page *page,
-- 
2.40.1

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

