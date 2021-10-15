Return-Path: <SRS0=TigA=PD=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2D1BAC433EF
	for <dm-devel@archiver.kernel.org>; Fri, 15 Oct 2021 23:31:20 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id B3A416120C
	for <dm-devel@archiver.kernel.org>; Fri, 15 Oct 2021 23:31:18 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org B3A416120C
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-495-tQr_ldIzNSKqDkgV2VcsxA-1; Fri, 15 Oct 2021 19:31:14 -0400
X-MC-Unique: tQr_ldIzNSKqDkgV2VcsxA-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 0F9E22FD21;
	Fri, 15 Oct 2021 23:31:10 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id E8D295DF36;
	Fri, 15 Oct 2021 23:31:09 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id C2239180BAD1;
	Fri, 15 Oct 2021 23:31:09 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
	[10.11.54.5])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 19FNV2wn015412 for <dm-devel@listman.util.phx.redhat.com>;
	Fri, 15 Oct 2021 19:31:02 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id 45834D1BB2; Fri, 15 Oct 2021 23:31:02 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast03.extmail.prod.ext.rdu2.redhat.com [10.11.55.19])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 3EB12D016B
	for <dm-devel@redhat.com>; Fri, 15 Oct 2021 23:30:59 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[207.211.31.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 51175811E7F
	for <dm-devel@redhat.com>; Fri, 15 Oct 2021 23:30:59 +0000 (UTC)
Received: from bombadil.infradead.org (bombadil.infradead.org
	[198.137.202.133]) (Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-289-Wpmf7igEOCeKgRTYLbhnBg-1; Fri, 15 Oct 2021 19:30:57 -0400
X-MC-Unique: Wpmf7igEOCeKgRTYLbhnBg-1
Received: from mcgrof by bombadil.infradead.org with local (Exim 4.94.2 #2
	(Red Hat Linux)) id 1mbWej-0095v7-E9; Fri, 15 Oct 2021 23:30:29 +0000
From: Luis Chamberlain <mcgrof@kernel.org>
To: axboe@kernel.dk, jejb@linux.ibm.com, martin.petersen@oracle.com,
	agk@redhat.com, snitzer@redhat.com, colyli@suse.de,
	kent.overstreet@gmail.com, boris.ostrovsky@oracle.com, jgross@suse.com, 
	sstabellini@kernel.org, roger.pau@citrix.com, geert@linux-m68k.org,
	ulf.hansson@linaro.org, tj@kernel.org, hare@suse.de, jdike@addtoit.com, 
	richard@nod.at, anton.ivanov@cambridgegreys.com,
	johannes.berg@intel.com, krisman@collabora.com,
	chris.obbard@collabora.com, thehajime@gmail.com,
	zhuyifei1999@gmail.com, haris.iqbal@ionos.com, jinpu.wang@ionos.com,
	miquel.raynal@bootlin.com, vigneshr@ti.com, linux-mtd@lists.infradead.org
Date: Fri, 15 Oct 2021 16:30:27 -0700
Message-Id: <20211015233028.2167651-9-mcgrof@kernel.org>
In-Reply-To: <20211015233028.2167651-1-mcgrof@kernel.org>
References: <20211015233028.2167651-1-mcgrof@kernel.org>
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
Cc: linux-m68k@vger.kernel.org, linux-scsi@vger.kernel.org,
	linux-um@lists.infradead.org, linux-bcache@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-block@vger.kernel.org,
	dm-devel@redhat.com, Luis Chamberlain <mcgrof@kernel.org>,
	xen-devel@lists.xenproject.org
Subject: [dm-devel] [PATCH 8/9] rnbd: add error handling support for
	add_disk()
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

We never checked for errors on add_disk() as this function
returned void. Now that this is fixed, use the shiny new
error handling.

Acked-by: Jack Wang <jinpu.wang@ionos.com>
Signed-off-by: Luis Chamberlain <mcgrof@kernel.org>
---
 drivers/block/rnbd/rnbd-clt.c | 13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)

diff --git a/drivers/block/rnbd/rnbd-clt.c b/drivers/block/rnbd/rnbd-clt.c
index 5864c9b46cb9..3b78dc55a9a2 100644
--- a/drivers/block/rnbd/rnbd-clt.c
+++ b/drivers/block/rnbd/rnbd-clt.c
@@ -1384,8 +1384,10 @@ static void setup_request_queue(struct rnbd_clt_dev *dev)
 	blk_queue_write_cache(dev->queue, dev->wc, dev->fua);
 }
 
-static void rnbd_clt_setup_gen_disk(struct rnbd_clt_dev *dev, int idx)
+static int rnbd_clt_setup_gen_disk(struct rnbd_clt_dev *dev, int idx)
 {
+	int err;
+
 	dev->gd->major		= rnbd_client_major;
 	dev->gd->first_minor	= idx << RNBD_PART_BITS;
 	dev->gd->minors		= 1 << RNBD_PART_BITS;
@@ -1410,7 +1412,11 @@ static void rnbd_clt_setup_gen_disk(struct rnbd_clt_dev *dev, int idx)
 
 	if (!dev->rotational)
 		blk_queue_flag_set(QUEUE_FLAG_NONROT, dev->queue);
-	add_disk(dev->gd);
+	err = add_disk(dev->gd);
+	if (err)
+		blk_cleanup_disk(dev->gd);
+
+	return err;
 }
 
 static int rnbd_client_setup_device(struct rnbd_clt_dev *dev)
@@ -1426,8 +1432,7 @@ static int rnbd_client_setup_device(struct rnbd_clt_dev *dev)
 	rnbd_init_mq_hw_queues(dev);
 
 	setup_request_queue(dev);
-	rnbd_clt_setup_gen_disk(dev, idx);
-	return 0;
+	return rnbd_clt_setup_gen_disk(dev, idx);
 }
 
 static struct rnbd_clt_dev *init_dev(struct rnbd_clt_session *sess,
-- 
2.30.2

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

