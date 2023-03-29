Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E073EC74A5B
	for <dm-devel@archiver.kernel.org>; Wed, 29 Mar 2023 17:08:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1680109693;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=7uwIKEa1jM2lDgOH2dNjEnOnyG+Fcelv13bd6mjmYFA=;
	b=Lhl4YVKerpQRCKHxinVxaDwaeoSdGoxYV7384AkkRNFVppJ/MmR8ff/URyzuKcaJ5IE2Fi
	2x8Ti+wdLO13Q9g0Zo0OCcXh2ZCYitUxvtkjOxE1hy4muZLBRwbBFRVxxXcbxVtwQzvfj4
	UGKI9y0OXcZJC8PJWHfgkYaZtTj6o4c=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-477-Hjp2RGXFNg-acWfiRYcOjw-1; Wed, 29 Mar 2023 13:08:12 -0400
X-MC-Unique: Hjp2RGXFNg-acWfiRYcOjw-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 70FF8884EC3;
	Wed, 29 Mar 2023 17:08:06 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 5F6572166B33;
	Wed, 29 Mar 2023 17:08:06 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 3D2FD1946588;
	Wed, 29 Mar 2023 17:08:06 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
 [10.11.54.5])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id C390F1946587
 for <dm-devel@listman.corp.redhat.com>; Wed, 29 Mar 2023 17:07:43 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 9862A18EC6; Wed, 29 Mar 2023 17:07:43 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast05.extmail.prod.ext.rdu2.redhat.com [10.11.55.21])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 9189818EC2
 for <dm-devel@redhat.com>; Wed, 29 Mar 2023 17:07:43 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [207.211.31.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 7075C884EC5
 for <dm-devel@redhat.com>; Wed, 29 Mar 2023 17:07:43 +0000 (UTC)
Received: from esa1.hgst.iphmx.com (esa1.hgst.iphmx.com [68.232.141.245]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-111-Ysbew0KLMjCx1q7ebTMXpw-3; Wed, 29 Mar 2023 13:07:39 -0400
X-MC-Unique: Ysbew0KLMjCx1q7ebTMXpw-3
X-IronPort-AV: E=Sophos;i="5.98,301,1673884800"; d="scan'208";a="338882574"
Received: from h199-255-45-14.hgst.com (HELO uls-op-cesaep01.wdc.com)
 ([199.255.45.14])
 by ob1.hgst.iphmx.com with ESMTP; 30 Mar 2023 01:06:35 +0800
IronPort-SDR: 2ilRNLoHMSvxiqWrcuab3xWOkUfIlRaKOuV4RtSfN/JqtoStUvWwP5Of2fmOOxpVfMdcJtLW/q
 swIbZKKOX1BO0AzJv/dSlscWpkGHWlOtTc16a2vD5HnTyIkn6o4+b947tRpOkET6BU4UxxLn83
 6rYHvXBnLn+RMmb6Gu9N7h0uqr10GoWrzR8RSzkkFq8DbjvkzEpbNMo7fOqnUj9Y4grpMRnp3J
 LP8PJH5pb6owHg5SWwv0vqShK3V7e2ljaQlZzlNM/Q7n4/YWJRl7oksP0Uag8OOJrL6IUG1raT
 NgM=
Received: from uls-op-cesaip01.wdc.com ([10.248.3.36])
 by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256;
 29 Mar 2023 09:22:44 -0700
IronPort-SDR: LCzDjMY5FJ5sr8pIsHJapmUnHR/HrhUl79JV22sYdEO2rzY0+ynCU/VuOjv7ZALoaIA05uNHnA
 KLRyUMuwlt12IwC+VHi4otXGnYicO4UmHegZ9Kplvajn0f/LaNS4Vr15N4xbFpRBJEti4HjRX1
 Bvit1PEiowY0ep8DeA0czhvEoDRP3Kll86DnbETpHg8w4X4G9iHJmSKb1l58xWudqk0JK6OIZ/
 BvTjCmaxL3mPyUI1B6gKVzuL8y2j4E/ZHPehNYyHvH3JipeuiATzGUF76GOIcEtetNffS4rAKx
 brQ=
WDCIronportException: Internal
Received: from unknown (HELO redsun91.ssa.fujisawa.hgst.com) ([10.149.66.72])
 by uls-op-cesaip01.wdc.com with ESMTP; 29 Mar 2023 10:06:34 -0700
From: Johannes Thumshirn <johannes.thumshirn@wdc.com>
To: Jens Axboe <axboe@kernel.dk>
Date: Wed, 29 Mar 2023 10:05:51 -0700
Message-Id: <55ec6659d861fd13e8e4f46d3e5a7fbad07e3721.1680108414.git.johannes.thumshirn@wdc.com>
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
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.5
Subject: [dm-devel] [PATCH 05/19] md: use __bio_add_page to add single page
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

The md-raid superblock writing code uses bio_add_page() to add a page to a
newly created bio. bio_add_page() can fail, but the return value is never
checked.

Use __bio_add_page() as adding a single page to a newly created bio is
guaranteed to succeed.

This brings us a step closer to marking bio_add_page() as __must_check.

Signed-of_-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
---
 drivers/md/md.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index 39e49e5d7182..e730c3627d00 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -958,7 +958,7 @@ void md_super_write(struct mddev *mddev, struct md_rdev *rdev,
 	atomic_inc(&rdev->nr_pending);
 
 	bio->bi_iter.bi_sector = sector;
-	bio_add_page(bio, page, size, 0);
+	__bio_add_page(bio, page, size, 0);
 	bio->bi_private = rdev;
 	bio->bi_end_io = super_written;
 
@@ -999,7 +999,7 @@ int sync_page_io(struct md_rdev *rdev, sector_t sector, int size,
 		bio.bi_iter.bi_sector = sector + rdev->new_data_offset;
 	else
 		bio.bi_iter.bi_sector = sector + rdev->data_offset;
-	bio_add_page(&bio, page, size, 0);
+	__bio_add_page(&bio, page, size, 0);
 
 	submit_bio_wait(&bio);
 
-- 
2.39.2

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

