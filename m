Return-Path: <SRS0=TigA=PD=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DA28DC4321E
	for <dm-devel@archiver.kernel.org>; Fri, 15 Oct 2021 23:31:00 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 62B3B61151
	for <dm-devel@archiver.kernel.org>; Fri, 15 Oct 2021 23:31:00 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 62B3B61151
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-266-lEDMz4G2MNScp87ZD8kSvA-1; Fri, 15 Oct 2021 19:30:54 -0400
X-MC-Unique: lEDMz4G2MNScp87ZD8kSvA-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id BB15F180830E;
	Fri, 15 Oct 2021 23:30:49 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 76F11ADD7;
	Fri, 15 Oct 2021 23:30:49 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 13D454E590;
	Fri, 15 Oct 2021 23:30:47 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
	[10.11.54.5])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 19FNUgTs015294 for <dm-devel@listman.util.phx.redhat.com>;
	Fri, 15 Oct 2021 19:30:42 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id 4A3EFD0B3F; Fri, 15 Oct 2021 23:30:42 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast06.extmail.prod.ext.rdu2.redhat.com [10.11.55.22])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 44755D018A
	for <dm-devel@redhat.com>; Fri, 15 Oct 2021 23:30:39 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[207.211.31.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 74DC71857F02
	for <dm-devel@redhat.com>; Fri, 15 Oct 2021 23:30:39 +0000 (UTC)
Received: from bombadil.infradead.org (bombadil.infradead.org
	[198.137.202.133]) (Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-329-iKRKzG62MQ6nd-blRnWadg-1; Fri, 15 Oct 2021 19:30:37 -0400
X-MC-Unique: iKRKzG62MQ6nd-blRnWadg-1
Received: from mcgrof by bombadil.infradead.org with local (Exim 4.94.2 #2
	(Red Hat Linux)) id 1mbWej-0095v5-Ct; Fri, 15 Oct 2021 23:30:29 +0000
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
Date: Fri, 15 Oct 2021 16:30:26 -0700
Message-Id: <20211015233028.2167651-8-mcgrof@kernel.org>
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
Subject: [dm-devel] [PATCH 7/9] um/drivers/ubd_kern: add error handling
	support for add_disk()
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

ubd_disk_register() never returned an error, so just fix
that now and let the caller handle the error condition.

Reviewed-by: Gabriel Krisman Bertazi <krisman@collabora.com>
Signed-off-by: Luis Chamberlain <mcgrof@kernel.org>
---
 arch/um/drivers/ubd_kern.c | 13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)

diff --git a/arch/um/drivers/ubd_kern.c b/arch/um/drivers/ubd_kern.c
index fefd343412c7..69d2d0049a61 100644
--- a/arch/um/drivers/ubd_kern.c
+++ b/arch/um/drivers/ubd_kern.c
@@ -855,8 +855,8 @@ static const struct attribute_group *ubd_attr_groups[] = {
 	NULL,
 };
 
-static void ubd_disk_register(int major, u64 size, int unit,
-			      struct gendisk *disk)
+static int ubd_disk_register(int major, u64 size, int unit,
+			     struct gendisk *disk)
 {
 	disk->major = major;
 	disk->first_minor = unit << UBD_SHIFT;
@@ -873,7 +873,7 @@ static void ubd_disk_register(int major, u64 size, int unit,
 
 	disk->private_data = &ubd_devs[unit];
 	disk->queue = ubd_devs[unit].queue;
-	device_add_disk(&ubd_devs[unit].pdev.dev, disk, ubd_attr_groups);
+	return device_add_disk(&ubd_devs[unit].pdev.dev, disk, ubd_attr_groups);
 }
 
 #define ROUND_BLOCK(n) ((n + (SECTOR_SIZE - 1)) & (-SECTOR_SIZE))
@@ -920,10 +920,15 @@ static int ubd_add(int n, char **error_out)
 	blk_queue_write_cache(ubd_dev->queue, true, false);
 	blk_queue_max_segments(ubd_dev->queue, MAX_SG);
 	blk_queue_segment_boundary(ubd_dev->queue, PAGE_SIZE - 1);
-	ubd_disk_register(UBD_MAJOR, ubd_dev->size, n, disk);
+	err = ubd_disk_register(UBD_MAJOR, ubd_dev->size, n, disk);
+	if (err)
+		goto out_cleanup_disk;
+
 	ubd_gendisk[n] = disk;
 	return 0;
 
+out_cleanup_disk:
+	blk_cleanup_disk(disk);
 out_cleanup_tags:
 	blk_mq_free_tag_set(&ubd_dev->tag_set);
 out:
-- 
2.30.2

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

