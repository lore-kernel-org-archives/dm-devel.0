Return-Path: <SRS0=+RIL=GM=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1A407C433E0
	for <dm-devel@archiver.kernel.org>; Sat,  9 Jan 2021 10:47:59 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 8F61A23A1E
	for <dm-devel@archiver.kernel.org>; Sat,  9 Jan 2021 10:47:58 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 8F61A23A1E
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-393-XZnYcT94NJKJzZ9XWfMw_w-1; Sat, 09 Jan 2021 05:47:55 -0500
X-MC-Unique: XZnYcT94NJKJzZ9XWfMw_w-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id F142B107ACE6;
	Sat,  9 Jan 2021 10:47:50 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id D3E3A100238C;
	Sat,  9 Jan 2021 10:47:50 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id AAAF34E58E;
	Sat,  9 Jan 2021 10:47:50 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com
	[10.11.54.3])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 109AlmZT026126 for <dm-devel@listman.util.phx.redhat.com>;
	Sat, 9 Jan 2021 05:47:48 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 568511016D9B; Sat,  9 Jan 2021 10:47:48 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast05.extmail.prod.ext.rdu2.redhat.com [10.11.55.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 51E3E101B546
	for <dm-devel@redhat.com>; Sat,  9 Jan 2021 10:47:45 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [205.139.110.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id E3480800140
	for <dm-devel@redhat.com>; Sat,  9 Jan 2021 10:47:45 +0000 (UTC)
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-516-mapXAiz9PciqNw-wly0Neg-1; Sat, 09 Jan 2021 05:47:41 -0500
X-MC-Unique: mapXAiz9PciqNw-wly0Neg-1
Received: from [2001:4bb8:19b:e528:4197:a20:99de:e7b0] (helo=localhost)
	by casper.infradead.org with esmtpsa (Exim 4.94 #2 (Red Hat Linux))
	id 1kyBl7-000TC6-Dn; Sat, 09 Jan 2021 10:46:20 +0000
From: Christoph Hellwig <hch@lst.de>
To: Jens Axboe <axboe@kernel.dk>
Date: Sat,  9 Jan 2021 11:42:52 +0100
Message-Id: <20210109104254.1077093-5-hch@lst.de>
In-Reply-To: <20210109104254.1077093-1-hch@lst.de>
References: <20210109104254.1077093-1-hch@lst.de>
MIME-Version: 1.0
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by
	casper.infradead.org. See http://www.infradead.org/rpr.html
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.3
X-loop: dm-devel@redhat.com
Cc: Sagi Grimberg <sagi@grimberg.me>, Mike Snitzer <snitzer@redhat.com>,
	Oleksii Kurochko <olkuroch@cisco.com>,
	Dongsheng Yang <dongsheng.yang@easystack.cn>,
	linux-block@vger.kernel.org, dm-devel@redhat.com,
	linux-nvme@lists.infradead.org,
	"Martin K . Petersen" <martin.petersen@oracle.com>,
	Ilya Dryomov <idryomov@gmail.com>, ceph-devel@vger.kernel.org
Subject: [dm-devel] [PATCH 4/6] block: propagate BLKROSET on the whole
	device to all partitions
X-BeenThere: dm-devel@redhat.com
X-Mailman-Version: 2.1.12
Precedence: junk
List-Id: device-mapper development <dm-devel.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Change the policy so that a BLKROSET on the whole device also affects
partitions.  To quote Martin K. Petersen:

It's very common for database folks to twiddle the read-only state of
block devices and partitions. I know that our users will find it very
counter-intuitive that setting /dev/sda read-only won't prevent writes
to /dev/sda1.

The existing behavior is inconsistent in the sense that doing:

  # blockdev --setro /dev/sda
  # echo foo > /dev/sda1

permits writes. But:

  # blockdev --setro /dev/sda
  <something triggers revalidate>
  # echo foo > /dev/sda1

doesn't.

And a subsequent:

  # blockdev --setrw /dev/sda
  # echo foo > /dev/sda1

doesn't work either since sda1's read-only policy has been inherited
from the whole-disk device.

You need to do:

  # blockdev --rereadpt

after setting the whole-disk device rw to effectuate the same change on
the partitions, otherwise they are stuck being read-only indefinitely.

However, setting the read-only policy on a partition does *not* require
the revalidate step. As a matter of fact, doing the revalidate will blow
away the policy setting you just made.

So the user needs to take different actions depending on whether they
are trying to read-protect a whole-disk device or a partition. Despite
using the same ioctl. That is really confusing.

I have lost count how many times our customers have had data clobbered
because of ambiguity of the existing whole-disk device policy. The
current behavior violates the principle of least surprise by letting the
user think they write protected the whole disk when they actually
didn't.

Suggested-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Martin K. Petersen <martin.petersen@oracle.com>
---
 block/genhd.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/block/genhd.c b/block/genhd.c
index e70bdc9b0893c1..10c76320510fef 100644
--- a/block/genhd.c
+++ b/block/genhd.c
@@ -1658,8 +1658,7 @@ EXPORT_SYMBOL(set_disk_ro);
 
 int bdev_read_only(struct block_device *bdev)
 {
-	return bdev->bd_read_only ||
-		test_bit(GD_READ_ONLY, &bdev->bd_disk->state);
+	return bdev->bd_read_only || get_disk_ro(bdev->bd_disk);
 }
 EXPORT_SYMBOL(bdev_read_only);
 
-- 
2.29.2

--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel

