Return-Path: <SRS0=TigA=PD=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 58584C433F5
	for <dm-devel@archiver.kernel.org>; Fri, 15 Oct 2021 23:31:20 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id B388E611C1
	for <dm-devel@archiver.kernel.org>; Fri, 15 Oct 2021 23:31:19 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org B388E611C1
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-219-fXdTsqXuOl240ABWVybLIQ-1; Fri, 15 Oct 2021 19:31:14 -0400
X-MC-Unique: fXdTsqXuOl240ABWVybLIQ-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 005A7801ADA;
	Fri, 15 Oct 2021 23:31:10 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id DBD725BAE6;
	Fri, 15 Oct 2021 23:31:09 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id B286D4EA30;
	Fri, 15 Oct 2021 23:31:09 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
	[10.11.54.4])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 19FNUhgx015317 for <dm-devel@listman.util.phx.redhat.com>;
	Fri, 15 Oct 2021 19:30:43 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id A1FF92026D46; Fri, 15 Oct 2021 23:30:43 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast05.extmail.prod.ext.rdu2.redhat.com [10.11.55.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 9C67D2026D48
	for <dm-devel@redhat.com>; Fri, 15 Oct 2021 23:30:40 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [207.211.31.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
	bits)) (No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id CC16E802A67
	for <dm-devel@redhat.com>; Fri, 15 Oct 2021 23:30:40 +0000 (UTC)
Received: from bombadil.infradead.org (bombadil.infradead.org
	[198.137.202.133]) (Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-201-fDkejuHHPxeVo13Rs7mQIA-1; Fri, 15 Oct 2021 19:30:39 -0400
X-MC-Unique: fDkejuHHPxeVo13Rs7mQIA-1
Received: from mcgrof by bombadil.infradead.org with local (Exim 4.94.2 #2
	(Red Hat Linux)) id 1mbWej-0095uz-9F; Fri, 15 Oct 2021 23:30:29 +0000
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
Date: Fri, 15 Oct 2021 16:30:23 -0700
Message-Id: <20211015233028.2167651-5-mcgrof@kernel.org>
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
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.4
X-loop: dm-devel@redhat.com
Cc: linux-m68k@vger.kernel.org, linux-scsi@vger.kernel.org,
	linux-um@lists.infradead.org, linux-bcache@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-block@vger.kernel.org,
	dm-devel@redhat.com, Luis Chamberlain <mcgrof@kernel.org>,
	xen-devel@lists.xenproject.org
Subject: [dm-devel] [PATCH 4/9] bcache: add error handling support for
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

We never checked for errors on add_disk() as this function
returned void. Now that this is fixed, use the shiny new
error handling.

This driver doesn't do any unwinding with blk_cleanup_disk()
even on errors after add_disk() and so we follow that
tradition.

Acked-by: Coly Li <colyli@suse.de>
Signed-off-by: Luis Chamberlain <mcgrof@kernel.org>
---
 drivers/md/bcache/super.c | 17 ++++++++++++-----
 1 file changed, 12 insertions(+), 5 deletions(-)

diff --git a/drivers/md/bcache/super.c b/drivers/md/bcache/super.c
index f2874c77ff79..f0c32cdd6594 100644
--- a/drivers/md/bcache/super.c
+++ b/drivers/md/bcache/super.c
@@ -1082,7 +1082,9 @@ int bch_cached_dev_run(struct cached_dev *dc)
 		closure_sync(&cl);
 	}
 
-	add_disk(d->disk);
+	ret = add_disk(d->disk);
+	if (ret)
+		goto out;
 	bd_link_disk_holder(dc->bdev, dc->disk.disk);
 	/*
 	 * won't show up in the uevent file, use udevadm monitor -e instead
@@ -1534,10 +1536,11 @@ static void flash_dev_flush(struct closure *cl)
 
 static int flash_dev_run(struct cache_set *c, struct uuid_entry *u)
 {
+	int err = -ENOMEM;
 	struct bcache_device *d = kzalloc(sizeof(struct bcache_device),
 					  GFP_KERNEL);
 	if (!d)
-		return -ENOMEM;
+		goto err_ret;
 
 	closure_init(&d->cl, NULL);
 	set_closure_fn(&d->cl, flash_dev_flush, system_wq);
@@ -1551,9 +1554,12 @@ static int flash_dev_run(struct cache_set *c, struct uuid_entry *u)
 	bcache_device_attach(d, c, u - c->uuids);
 	bch_sectors_dirty_init(d);
 	bch_flash_dev_request_init(d);
-	add_disk(d->disk);
+	err = add_disk(d->disk);
+	if (err)
+		goto err;
 
-	if (kobject_add(&d->kobj, &disk_to_dev(d->disk)->kobj, "bcache"))
+	err = kobject_add(&d->kobj, &disk_to_dev(d->disk)->kobj, "bcache");
+	if (err)
 		goto err;
 
 	bcache_device_link(d, c, "volume");
@@ -1567,7 +1573,8 @@ static int flash_dev_run(struct cache_set *c, struct uuid_entry *u)
 	return 0;
 err:
 	kobject_put(&d->kobj);
-	return -ENOMEM;
+err_ret:
+	return err;
 }
 
 static int flash_devs_run(struct cache_set *c)
-- 
2.30.2

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

