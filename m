Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E73DDC77B6D
	for <dm-devel@archiver.kernel.org>; Wed, 29 Mar 2023 17:08:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1680109706;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=PEjW6Q8gNjYpe+ZBADgIwCZYxm3uScRwhDJdJ8aQ5ug=;
	b=FWYl77USq3ACizBSG+/2bgdVgxQpiu/anaOTAuiqezt0qD3+XSSigzV/1poPrYV+Hi3JmO
	1b7oh6XPEST00tfeA4A5Db8WuELAY01mXK+rRcjMHadSzQImek/Xf5DzN3Des7fTX5DhVy
	FL258Mo919mlRf/0+xZOTgLYL1YtgQM=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-645-gw0Fsg2IMCSPxg8RO9TUGg-1; Wed, 29 Mar 2023 13:08:22 -0400
X-MC-Unique: gw0Fsg2IMCSPxg8RO9TUGg-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 4B4331C06EE5;
	Wed, 29 Mar 2023 17:08:20 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 394BC2166B33;
	Wed, 29 Mar 2023 17:08:20 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 0B1A21946588;
	Wed, 29 Mar 2023 17:08:20 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com
 [10.11.54.7])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 9C7E51946587
 for <dm-devel@listman.corp.redhat.com>; Wed, 29 Mar 2023 17:08:18 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 8D8C114171BC; Wed, 29 Mar 2023 17:08:18 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast09.extmail.prod.ext.rdu2.redhat.com [10.11.55.25])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 85F7014171BB
 for <dm-devel@redhat.com>; Wed, 29 Mar 2023 17:08:18 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [205.139.110.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 6BA05293248C
 for <dm-devel@redhat.com>; Wed, 29 Mar 2023 17:08:18 +0000 (UTC)
Received: from esa1.hgst.iphmx.com (esa1.hgst.iphmx.com [68.232.141.245]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-28-Z5tNP99hNa-k_HRzGSHFLA-1; Wed, 29 Mar 2023 13:08:16 -0400
X-MC-Unique: Z5tNP99hNa-k_HRzGSHFLA-1
X-IronPort-AV: E=Sophos;i="5.98,301,1673884800"; d="scan'208";a="338882646"
Received: from h199-255-45-14.hgst.com (HELO uls-op-cesaep01.wdc.com)
 ([199.255.45.14])
 by ob1.hgst.iphmx.com with ESMTP; 30 Mar 2023 01:07:12 +0800
IronPort-SDR: mFqtuAO/eymlbrkyiQ6JWyH6hyxojTs17+A2h5qDr8eIk+OhknL5Tp5K8Csr6ZUam+X2rxfu5w
 YMW7kayjF0KhRH8aZblY68XOoHOg47L52YlLp2zcU4JsEhj6gHmOEpmRrxV8/GZMU31z/xPbRN
 1YMivFRFRYETCxmQNLWTle2auoOpZfU3ZSdbnEEOtN1fDbdP+RBsDLtkCks5SoKZGmOwMf2cm5
 Gryne2HEz9Z1XAhYXOOvzBdzQjaHSJn3V5dUxFPNVbCL9yeTk57kUQk1vaQSEuNb1Jqqvsep7x
 jC0=
Received: from uls-op-cesaip01.wdc.com ([10.248.3.36])
 by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256;
 29 Mar 2023 09:23:21 -0700
IronPort-SDR: 5x6F8sxMltI4WaB27lEorTzv/W+x0JlN7rg04JjPfd38UU2ZZm/8DVpEHZF7Dz1SymcLD61OdU
 pMAulltziCw14vrFFK29xsFqr89kB9UbrC7cwH7R1RI8Lt7mmLGDYyj8PgO4p5chUbgRB50fDX
 pEWQG9uo914V+cwk1EfVh6hsltWKfNnh9Gqxgm0AGxlxSe7pa8UIAv+zE9lP4gByUZGpAjJ+IZ
 Lyi/Xsr9WvBwip9Y4KMe0trG46KV0zl+LFfsw1hbin01REWR95Nk66NcjalZz84eqJSVFLmHCh
 l0Q=
WDCIronportException: Internal
Received: from unknown (HELO redsun91.ssa.fujisawa.hgst.com) ([10.149.66.72])
 by uls-op-cesaip01.wdc.com with ESMTP; 29 Mar 2023 10:07:11 -0700
From: Johannes Thumshirn <johannes.thumshirn@wdc.com>
To: Jens Axboe <axboe@kernel.dk>
Date: Wed, 29 Mar 2023 10:06:04 -0700
Message-Id: <beea645603eccbb045ad9bb777e05a085b91808a.1680108414.git.johannes.thumshirn@wdc.com>
In-Reply-To: <cover.1680108414.git.johannes.thumshirn@wdc.com>
References: <cover.1680108414.git.johannes.thumshirn@wdc.com>
MIME-Version: 1.0
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.7
Subject: [dm-devel] [PATCH 18/19] dm-crypt: check if adding pages to clone
 bio fails
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
 David Sterba <dsterba@suse.com>, linux-fsdevel@vger.kernel.org,
 Christoph Hellwig <hch@lst.de>, linux-btrfs@vger.kernel.org,
 Bob Peterson <rpeterso@redhat.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.6
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: wdc.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Check if adding pages to clone bio fails and if bail out.

This way we can mark bio_add_pages as __must_check.

Signed-off-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
---
 drivers/md/dm-crypt.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/drivers/md/dm-crypt.c b/drivers/md/dm-crypt.c
index 3ba53dc3cc3f..19f7e087c6df 100644
--- a/drivers/md/dm-crypt.c
+++ b/drivers/md/dm-crypt.c
@@ -1693,7 +1693,14 @@ static struct bio *crypt_alloc_buffer(struct dm_crypt_io *io, unsigned int size)
 
 		len = (remaining_size > PAGE_SIZE) ? PAGE_SIZE : remaining_size;
 
-		bio_add_page(clone, page, len, 0);
+		if (!bio_add_page(clone, page, len, 0)) {
+			mempool_free(page, &cc->page_pool);
+			crypt_free_buffer_pages(cc, clone);
+			bio_put(clone);
+			gfp_mask |= __GFP_DIRECT_RECLAIM;
+			goto retry;
+
+		}
 
 		remaining_size -= len;
 	}
-- 
2.39.2

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

