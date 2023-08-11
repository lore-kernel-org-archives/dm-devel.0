Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1634AC07E8A
	for <dm-devel@archiver.kernel.org>; Fri, 11 Aug 2023 11:05:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1691751925;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=7aamnTGtwMIkAOsaRynIO7Wd+x6bahQqwdxIOPXkH9Q=;
	b=EH8Opex72qjekugr5ECjfDlrKjh9kYUSYWhKcSt8W0wqpeE8FqoXpRcYmwny4IU/5lBwqK
	pQGeJ2R4Gnm8S7IObUKsSBhO1qWl+iTVVZHnED3sMNPVrA6LGn+lCpvjH4477Cb0Cj3ELS
	FJCPadrFJk4GPR5W+qx7WGhpmC3oTOM=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-633-7pCb7PhmMmShHIghsWqFRw-1; Fri, 11 Aug 2023 07:05:22 -0400
X-MC-Unique: 7pCb7PhmMmShHIghsWqFRw-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id EC826823D69;
	Fri, 11 Aug 2023 11:05:20 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 280C7111DCE3;
	Fri, 11 Aug 2023 11:05:18 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id DE53B1946595;
	Fri, 11 Aug 2023 11:05:17 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com
 [10.11.54.3])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id A4A511946595
 for <dm-devel@listman.corp.redhat.com>; Fri, 11 Aug 2023 11:05:10 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 57618111E414; Fri, 11 Aug 2023 11:05:10 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast06.extmail.prod.ext.rdu2.redhat.com [10.11.55.22])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 509CF111E413
 for <dm-devel@redhat.com>; Fri, 11 Aug 2023 11:05:10 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [205.139.110.61])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 35B28185A7AB
 for <dm-devel@redhat.com>; Fri, 11 Aug 2023 11:05:10 +0000 (UTC)
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-582-bEjFbFG2PlKzFnC3R2T1Rw-1; Fri,
 11 Aug 2023 07:05:07 -0400
X-MC-Unique: bEjFbFG2PlKzFnC3R2T1Rw-1
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
 (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
 (No client certificate requested)
 by smtp-out2.suse.de (Postfix) with ESMTPS id CC3C21F892;
 Fri, 11 Aug 2023 11:05:05 +0000 (UTC)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
 (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
 (No client certificate requested)
 by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id BCEE413592;
 Fri, 11 Aug 2023 11:05:05 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
 by imap2.suse-dmz.suse.de with ESMTPSA id DKAbLuEV1mRLRQAAMHmgww
 (envelope-from <jack@suse.cz>); Fri, 11 Aug 2023 11:05:05 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
 id F1EC7A0787; Fri, 11 Aug 2023 13:05:04 +0200 (CEST)
From: Jan Kara <jack@suse.cz>
To: <linux-fsdevel@vger.kernel.org>
Date: Fri, 11 Aug 2023 13:04:41 +0200
Message-Id: <20230811110504.27514-10-jack@suse.cz>
In-Reply-To: <20230810171429.31759-1-jack@suse.cz>
References: <20230810171429.31759-1-jack@suse.cz>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=2781; i=jack@suse.cz;
 h=from:subject; bh=1VOU3CkMGlp+i7J1EQTr/mwlJ000GHJe0nvLxz7C+PU=;
 b=owEBbQGS/pANAwAIAZydqgc/ZEDZAcsmYgBk1hXLfyqL/Cdlsb+FyHs7jZSeQqr1jjiHgmFVjzZO
 KYqZOriJATMEAAEIAB0WIQSrWdEr1p4yirVVKBycnaoHP2RA2QUCZNYVywAKCRCcnaoHP2RA2SoBCA
 DrypllXpIYkaj+I5zAXIOMHS31i0ECTnDMKN9TI3Ps+HAnxTwxwAfibGIerqXHsT5XzQSJqOu9Npah
 SbIcPzQAVact7tRh3cOWS3qAhq2ZZjdpgocMiWAKgPPEpSTAUVe58mz1tGV9w/1SjMwdOveyol0sBq
 x8WZ1rHGQuz7pmSZqxaft799OwULEB3bW6eKBAk8aiDsDSpRjLph1U74EA0qCebZAkGw2Ld0S4vWkf
 GA0r8nkvjgxDXOb7ymdT61dutaxrLLDa4EBD86yC/Csh/sMka2IN5qK2MLRFrEyMvIPBuVQAbT+pCM
 BGrqrZvZDwWSgzysrX9B0cZ9xo2McN
X-Developer-Key: i=jack@suse.cz; a=openpgp;
 fpr=93C6099A142276A28BBE35D815BC833443038D8C
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.3
Subject: [dm-devel] [PATCH 10/29] dm: Convert to bdev_open_by_dev()
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
Cc: Christoph Hellwig <hch@infradead.org>, Jan Kara <jack@suse.cz>,
 Mike Snitzer <snitzer@kernel.org>, linux-block@vger.kernel.org,
 dm-devel@redhat.com, Alasdair Kergon <agk@redhat.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.3
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: suse.cz
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Convert device mapper to use bdev_open_by_dev() and pass the handle
around.

CC: Alasdair Kergon <agk@redhat.com>
CC: Mike Snitzer <snitzer@kernel.org>
CC: dm-devel@redhat.com
Signed-off-by: Jan Kara <jack@suse.cz>
---
 drivers/md/dm.c               | 20 +++++++++++---------
 include/linux/device-mapper.h |  1 +
 2 files changed, 12 insertions(+), 9 deletions(-)

diff --git a/drivers/md/dm.c b/drivers/md/dm.c
index f0f118ab20fa..efde77d34f15 100644
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -742,7 +742,7 @@ static struct table_device *open_table_device(struct mapped_device *md,
 		dev_t dev, blk_mode_t mode)
 {
 	struct table_device *td;
-	struct block_device *bdev;
+	struct bdev_handle *bdev_handle;
 	u64 part_off;
 	int r;
 
@@ -751,9 +751,9 @@ static struct table_device *open_table_device(struct mapped_device *md,
 		return ERR_PTR(-ENOMEM);
 	refcount_set(&td->count, 1);
 
-	bdev = blkdev_get_by_dev(dev, mode, _dm_claim_ptr, NULL);
-	if (IS_ERR(bdev)) {
-		r = PTR_ERR(bdev);
+	bdev_handle = bdev_open_by_dev(dev, mode, _dm_claim_ptr, NULL);
+	if (IS_ERR(bdev_handle)) {
+		r = PTR_ERR(bdev_handle);
 		goto out_free_td;
 	}
 
@@ -763,20 +763,22 @@ static struct table_device *open_table_device(struct mapped_device *md,
 	 * called.
 	 */
 	if (md->disk->slave_dir) {
-		r = bd_link_disk_holder(bdev, md->disk);
+		r = bd_link_disk_holder(bdev_handle->bdev, md->disk);
 		if (r)
 			goto out_blkdev_put;
 	}
 
 	td->dm_dev.mode = mode;
-	td->dm_dev.bdev = bdev;
-	td->dm_dev.dax_dev = fs_dax_get_by_bdev(bdev, &part_off, NULL, NULL);
+	td->dm_dev.bdev = bdev_handle->bdev;
+	td->dm_dev.bdev_handle = bdev_handle;
+	td->dm_dev.dax_dev = fs_dax_get_by_bdev(bdev_handle->bdev, &part_off,
+						NULL, NULL);
 	format_dev_t(td->dm_dev.name, dev);
 	list_add(&td->list, &md->table_devices);
 	return td;
 
 out_blkdev_put:
-	blkdev_put(bdev, _dm_claim_ptr);
+	bdev_release(bdev_handle);
 out_free_td:
 	kfree(td);
 	return ERR_PTR(r);
@@ -789,7 +791,7 @@ static void close_table_device(struct table_device *td, struct mapped_device *md
 {
 	if (md->disk->slave_dir)
 		bd_unlink_disk_holder(td->dm_dev.bdev, md->disk);
-	blkdev_put(td->dm_dev.bdev, _dm_claim_ptr);
+	bdev_release(td->dm_dev.bdev_handle);
 	put_dax(td->dm_dev.dax_dev);
 	list_del(&td->list);
 	kfree(td);
diff --git a/include/linux/device-mapper.h b/include/linux/device-mapper.h
index 69d0435c7ebb..772ab4d74d94 100644
--- a/include/linux/device-mapper.h
+++ b/include/linux/device-mapper.h
@@ -165,6 +165,7 @@ void dm_error(const char *message);
 
 struct dm_dev {
 	struct block_device *bdev;
+	struct bdev_handle *bdev_handle;
 	struct dax_device *dax_dev;
 	blk_mode_t mode;
 	char name[16];
-- 
2.35.3

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

