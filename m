Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F20ACC4332F
	for <dm-devel@archiver.kernel.org>; Wed,  2 Nov 2022 06:49:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1667371748;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=O+t55UUyblDk/hWSX+j+wsueAGYQX+p/zMEB5D1CQmE=;
	b=cBT+UYP325l7WIpbrsCqNYFUlo1CBQnV6bc5+6SjGWr1yUbODXXgXb6BsdPphoy5H/zsGP
	WFL5Ze7WhuZb3yXy/0Q+YfxJCGrM61Skn8jrqb1BdobWcunZQRE76pZkT2+gf9SbA++KGt
	7cgXKGbH9fkwl0w9GpWmulhSg3dMwKA=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-650-Mddox5SRPh203nwXePck8g-1; Wed, 02 Nov 2022 02:49:06 -0400
X-MC-Unique: Mddox5SRPh203nwXePck8g-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id C35AF858F13;
	Wed,  2 Nov 2022 06:49:04 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 80FCA492B07;
	Wed,  2 Nov 2022 06:49:02 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 6D8DD1946597;
	Wed,  2 Nov 2022 06:49:02 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com
 [10.11.54.7])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 8D2661946594
 for <dm-devel@listman.corp.redhat.com>; Wed,  2 Nov 2022 06:49:00 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 4D7F01415122; Wed,  2 Nov 2022 06:49:00 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast06.extmail.prod.ext.rdu2.redhat.com [10.11.55.22])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 465FF141511F
 for <dm-devel@redhat.com>; Wed,  2 Nov 2022 06:49:00 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [207.211.31.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 2F424185A78F
 for <dm-devel@redhat.com>; Wed,  2 Nov 2022 06:49:00 +0000 (UTC)
Received: from verein.lst.de (verein.lst.de [213.95.11.211]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-381-EGf9qolpPsaVrAhDMlPPkg-1; Wed, 02 Nov 2022 02:48:57 -0400
X-MC-Unique: EGf9qolpPsaVrAhDMlPPkg-1
Received: by verein.lst.de (Postfix, from userid 2407)
 id 426096732D; Wed,  2 Nov 2022 07:48:54 +0100 (CET)
Date: Wed, 2 Nov 2022 07:48:54 +0100
From: Christoph Hellwig <hch@lst.de>
To: Jens Axboe <axboe@kernel.dk>, Alasdair Kergon <agk@redhat.com>,
 Mike Snitzer <snitzer@kernel.org>
Message-ID: <20221102064854.GA8950@lst.de>
MIME-Version: 1.0
User-Agent: Mutt/1.5.17 (2007-11-01)
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.7
Subject: [dm-devel] [PATCH 8/7] block: don't claim devices that are not live
 in bd_link_disk_holder
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
Cc: linux-block@vger.kernel.org, Yu Kuai <yukuai1@huaweicloud.com>,
 dm-devel@redhat.com
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.10
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

For gendisk that are not live or their partitions, the bd_holder_dir
pointer is not valid and the kobject might not have been allocated
yet or freed already.  Check that the disk is live before creating the
linkage and error out otherwise.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 block/holder.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/block/holder.c b/block/holder.c
index a8c355b9d0806..a8806bbed2112 100644
--- a/block/holder.c
+++ b/block/holder.c
@@ -66,6 +66,11 @@ int bd_link_disk_holder(struct block_device *bdev, struct gendisk *disk)
 		return -EINVAL;
 
 	mutex_lock(&disk->open_mutex);
+	/* bd_holder_dir is only valid for live disks */
+	if (!disk_live(bdev->bd_disk)) {
+		ret = -EINVAL;
+		goto out_unlock;
+	}
 
 	WARN_ON_ONCE(!bdev->bd_holder);
 
-- 
2.30.2

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

