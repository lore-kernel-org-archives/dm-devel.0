Return-Path: <SRS0=PruR=NO=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-14.0 required=3.0 tests=BAYES_00,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 37B1EC4320A
	for <dm-devel@archiver.kernel.org>; Mon, 23 Aug 2021 21:45:41 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id BF4CD613D0
	for <dm-devel@archiver.kernel.org>; Mon, 23 Aug 2021 21:45:40 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org BF4CD613D0
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-315-J2_PCox2M6qzOPCn7n9jKg-1; Mon, 23 Aug 2021 17:45:38 -0400
X-MC-Unique: J2_PCox2M6qzOPCn7n9jKg-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id D0D111082921;
	Mon, 23 Aug 2021 21:45:32 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id B1BB96788C;
	Mon, 23 Aug 2021 21:45:32 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 86D484A7CB;
	Mon, 23 Aug 2021 21:45:32 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
	[10.11.54.5])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 17NLIbqw019299 for <dm-devel@listman.util.phx.redhat.com>;
	Mon, 23 Aug 2021 17:18:37 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id E1296BE5BF; Mon, 23 Aug 2021 21:18:36 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast02.extmail.prod.ext.rdu2.redhat.com [10.11.55.18])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id DC41EBDC5F
	for <dm-devel@redhat.com>; Mon, 23 Aug 2021 21:18:36 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [207.211.31.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
	bits)) (No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id C501380018D
	for <dm-devel@redhat.com>; Mon, 23 Aug 2021 21:18:36 +0000 (UTC)
Received: from bombadil.infradead.org (bombadil.infradead.org
	[198.137.202.133]) (Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-449-xuGJWfW0P4uKQiZfY1I0jA-1; Mon, 23 Aug 2021 17:18:35 -0400
X-MC-Unique: xuGJWfW0P4uKQiZfY1I0jA-1
Received: from mcgrof by bombadil.infradead.org with local (Exim 4.94.2 #2
	(Red Hat Linux)) id 1mIGZa-000ZjO-4g; Mon, 23 Aug 2021 20:29:34 +0000
From: Luis Chamberlain <mcgrof@kernel.org>
To: axboe@kernel.dk, martin.petersen@oracle.com, jejb@linux.ibm.com,
	kbusch@kernel.org, sagi@grimberg.me, adrian.hunter@intel.com,
	beanhuo@micron.com, ulf.hansson@linaro.org, avri.altman@wdc.com,
	swboyd@chromium.org, agk@redhat.com, snitzer@redhat.com,
	josef@toxicpanda.com
Date: Mon, 23 Aug 2021 13:29:23 -0700
Message-Id: <20210823202930.137278-4-mcgrof@kernel.org>
In-Reply-To: <20210823202930.137278-1-mcgrof@kernel.org>
References: <20210823202930.137278-1-mcgrof@kernel.org>
MIME-Version: 1.0
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.79 on 10.11.54.5
X-loop: dm-devel@redhat.com
X-Mailman-Approved-At: Mon, 23 Aug 2021 17:45:12 -0400
Cc: linux-block@vger.kernel.org, bvanassche@acm.org, linux-scsi@vger.kernel.org,
	linux-mmc@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-nvme@lists.infradead.org, ming.lei@redhat.com,
	hch@infradead.org, dm-devel@redhat.com, nbd@other.debian.org,
	Luis Chamberlain <mcgrof@kernel.org>
Subject: [dm-devel] [PATCH 03/10] scsi/sr: use blk_cleanup_disk() instead of
	put_disk()
X-BeenThere: dm-devel@redhat.com
X-Mailman-Version: 2.1.12
Precedence: junk
List-Id: device-mapper development <dm-devel.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

The single put_disk() is useful if you know you're not doing
a cleanup after add_disk(), but since we want to add support
for that, just use the normal form of blk_cleanup_disk() to
cleanup the queue and put the disk.

Signed-off-by: Luis Chamberlain <mcgrof@kernel.org>
---
 drivers/scsi/sr.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/sr.c b/drivers/scsi/sr.c
index a0df27db4d61..dc78ad96e6f9 100644
--- a/drivers/scsi/sr.c
+++ b/drivers/scsi/sr.c
@@ -792,7 +792,7 @@ static int sr_probe(struct device *dev)
 	clear_bit(minor, sr_index_bits);
 	spin_unlock(&sr_index_lock);
 fail_put:
-	put_disk(disk);
+	blk_cleanup_disk(disk);
 	mutex_destroy(&cd->lock);
 fail_free:
 	kfree(cd);
-- 
2.30.2

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

