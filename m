Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 28BB5C77B7E
	for <dm-devel@archiver.kernel.org>; Tue,  2 May 2023 10:21:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1683022908;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=NFBN5TeY1i6n3jCAW00Tk1bdIb8jxsOlobiEmpBjQcw=;
	b=AlDnC9pDw/3EwmYZwVq6Ymqr6JvcDX96W3TNk6ZhV8f/FH0rFu8OhcPRBSV7zp3waQMBU9
	XubGxVi9Mvj+dLJZ442azCVquJcl3q51qLzaK98oYxXM75LngwOHRj6BAGFmEQ/HdsXM7c
	qb0pT0hIQErshu4Lx8uUyrSBLVZWYpA=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-267-pcZW1NlAOJiZ60FlHoo8mg-1; Tue, 02 May 2023 06:21:44 -0400
X-MC-Unique: pcZW1NlAOJiZ60FlHoo8mg-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 9344E2823804;
	Tue,  2 May 2023 10:21:42 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 7CB2E2166B2B;
	Tue,  2 May 2023 10:21:42 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 5FFDE1946597;
	Tue,  2 May 2023 10:21:42 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com
 [10.11.54.10])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 43040194658C
 for <dm-devel@listman.corp.redhat.com>; Tue,  2 May 2023 10:21:41 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 35C9E492B0F; Tue,  2 May 2023 10:21:41 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast05.extmail.prod.ext.rdu2.redhat.com [10.11.55.21])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 2EE00492B03
 for <dm-devel@redhat.com>; Tue,  2 May 2023 10:21:41 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [207.211.31.81])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 10CA8884EC5
 for <dm-devel@redhat.com>; Tue,  2 May 2023 10:21:41 +0000 (UTC)
Received: from esa5.hgst.iphmx.com (esa5.hgst.iphmx.com [216.71.153.144]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-633-4YXMXHD7PG-xqyHaFd0xAw-2; Tue, 02 May 2023 06:21:37 -0400
X-MC-Unique: 4YXMXHD7PG-xqyHaFd0xAw-2
X-IronPort-AV: E=Sophos;i="5.99,243,1677513600"; d="scan'208";a="229597942"
Received: from uls-op-cesaip02.wdc.com (HELO uls-op-cesaep02.wdc.com)
 ([199.255.45.15])
 by ob1.hgst.iphmx.com with ESMTP; 02 May 2023 18:21:36 +0800
IronPort-SDR: WkJV4kSdR1QbYZrzbhY8xiR+9dbi58wRlepHxWF7Okz7QkmzEh6ISYpKLT0+ZWps9pwdRBmqmM
 MFkN/WOHzdIQv/82tNjitsSwSomNsOBi369JPzKs8b8l5R3oEDaZ5gf8zJaSsviZhQyfMd9xS/
 l1IOt5Q5AP204/Gqx3H5coqbC/0sn/j1JLwmkRzKnmA2c90SAjkeO7G/iuzdYxUVse9dXGUhNs
 YY9zXR5PsabrSW7DJFxPcCP8GZcuXthNQ7i2QVfFbWp9pIkdsoCMnfAZzLwYwG0HgGwINNZS6E
 g3Q=
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
 by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256;
 02 May 2023 02:31:23 -0700
IronPort-SDR: uGIw254wyz5xW63y6mKPruYBxsDCJBiWJn5HyxXEKlHH3a6WQB95MJD2gL1U37MsE73pDlkDfH
 XrAQKE0o1trWaMuwmkCjZxReOE6bQKTuwcjttjZub9Fo2NWOrlg+l+x9Li4fpCvU8smOVgdBJe
 iX9LTVSMXZH6O+ImhKiOGTSlNSVog/dyr5RquJMBmwgwChPCFkHcE06ByPGE2sBKs5rW/DQtzK
 T5Xxpb54D4Yuz40YIDXaPoJ+wQXNcche+tu3/6iWe/RHtJ7xSAUbzgyNSPsRVFjywOIFjhKDZt
 2iU=
WDCIronportException: Internal
Received: from myd008205.ad.shared (HELO localhost.localdomain)
 ([10.225.1.100])
 by uls-op-cesaip02.wdc.com with ESMTP; 02 May 2023 03:21:32 -0700
From: Johannes Thumshirn <johannes.thumshirn@wdc.com>
To: "axboe @ kernel . dk" <axboe@kernel.dk>
Date: Tue,  2 May 2023 12:19:27 +0200
Message-Id: <20230502101934.24901-14-johannes.thumshirn@wdc.com>
In-Reply-To: <20230502101934.24901-1-johannes.thumshirn@wdc.com>
References: <20230502101934.24901-1-johannes.thumshirn@wdc.com>
MIME-Version: 1.0
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.10
Subject: [dm-devel] [PATCH v5 13/20] md: check for failure when adding pages
 in alloc_behind_master_bio
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
 agruenba@redhat.com, shaggy@kernel.org, song@kernel.org,
 Johannes Thumshirn <johannes.thumshirn@wdc.com>,
 Damien Le Moal <damien.lemoal@opensource.wdc.com>, snitzer@kernel.org,
 jfs-discussion@lists.sourceforge.net, willy@infradead.org, ming.lei@redhat.com,
 cluster-devel@redhat.com, linux-mm@kvack.org, dm-devel@redhat.com,
 linux-fsdevel@vger.kernel.org, linux-raid@vger.kernel.org, hch@lst.de,
 rpeterso@redhat.com
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.6
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: wdc.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

alloc_behind_master_bio() can possibly add multiple pages to a bio, but it
is not checking for the return value of bio_add_page() if adding really
succeeded.

Check if the page adding succeeded and if not bail out.

Reviewed-by: Damien Le Moal <damien.lemoal@opensource.wdc.com>
Signed-off-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
---
 drivers/md/raid1.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
index 68a9e2d9985b..8283ef177f6c 100644
--- a/drivers/md/raid1.c
+++ b/drivers/md/raid1.c
@@ -1147,7 +1147,10 @@ static void alloc_behind_master_bio(struct r1bio *r1_bio,
 		if (unlikely(!page))
 			goto free_pages;
 
-		bio_add_page(behind_bio, page, len, 0);
+		if (!bio_add_page(behind_bio, page, len, 0)) {
+			free_page(page);
+			goto free_pages;
+		}
 
 		size -= len;
 		i++;
-- 
2.40.0

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

