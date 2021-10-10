Return-Path: <SRS0=qbPE=O7=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6F0C7C433F5
	for <dm-devel@archiver.kernel.org>; Mon, 11 Oct 2021 05:53:12 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 0409460EE7
	for <dm-devel@archiver.kernel.org>; Mon, 11 Oct 2021 05:53:10 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 0409460EE7
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=wanadoo.fr
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-555-iJdYgElwNA2I8bUUqUDSdA-1; Mon, 11 Oct 2021 01:53:06 -0400
X-MC-Unique: iJdYgElwNA2I8bUUqUDSdA-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id E33A4801A93;
	Mon, 11 Oct 2021 05:52:59 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 8E663100E809;
	Mon, 11 Oct 2021 05:52:57 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id DFD311800B9E;
	Mon, 11 Oct 2021 05:52:56 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com
	[10.11.54.1])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 19AExbSN018222 for <dm-devel@listman.util.phx.redhat.com>;
	Sun, 10 Oct 2021 10:59:37 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id 4975C40CFD10; Sun, 10 Oct 2021 14:59:37 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast06.extmail.prod.ext.rdu2.redhat.com [10.11.55.22])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 4428A40CFD07
	for <dm-devel@redhat.com>; Sun, 10 Oct 2021 14:59:37 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [207.211.31.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
	bits)) (No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 2B61A185A7A4
	for <dm-devel@redhat.com>; Sun, 10 Oct 2021 14:59:37 +0000 (UTC)
Received: from smtp.smtpout.orange.fr (smtp13.smtpout.orange.fr
	[80.12.242.135]) by relay.mimecast.com with ESMTP id
	us-mta-75-FtjnsZlNNzqXO7ksR-GlUg-1; Sun, 10 Oct 2021 10:59:35 -0400
X-MC-Unique: FtjnsZlNNzqXO7ksR-GlUg-1
Received: from pop-os.home ([90.126.248.220]) by mwinf5d78 with ME
	id 4EVW260074m3Hzu03EVWPz; Sun, 10 Oct 2021 16:29:31 +0200
X-ME-Helo: pop-os.home
X-ME-Auth: Y2hyaXN0b3BoZS5qYWlsbGV0QHdhbmFkb28uZnI=
X-ME-Date: Sun, 10 Oct 2021 16:29:31 +0200
X-ME-IP: 90.126.248.220
From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
To: colyli@suse.de, kent.overstreet@gmail.com, agk@redhat.com,
	snitzer@redhat.com, dm-devel@redhat.com
Date: Sun, 10 Oct 2021 16:29:28 +0200
Message-Id: <65c7c385af7b3f825ace8803b1bc6b6403269813.1633876058.git.christophe.jaillet@wanadoo.fr>
MIME-Version: 1.0
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.1
X-loop: dm-devel@redhat.com
X-Mailman-Approved-At: Mon, 11 Oct 2021 01:52:12 -0400
Cc: Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
	linux-bcache@vger.kernel.org, kernel-janitors@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [dm-devel] [PATCH] dm: Remove redundant 'flush_workqueue()' calls
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
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

'destroy_workqueue()' already drains the queue before destroying it, so
there is no need to flush it explicitly.

Remove the redundant 'flush_workqueue()' calls.

This was generated with coccinelle:

@@
expression E;
@@
- 	flush_workqueue(E);
	destroy_workqueue(E);

Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
---
 drivers/md/bcache/writeback.c | 4 +---
 drivers/md/dm-bufio.c         | 1 -
 drivers/md/dm-zoned-target.c  | 1 -
 3 files changed, 1 insertion(+), 5 deletions(-)

diff --git a/drivers/md/bcache/writeback.c b/drivers/md/bcache/writeback.c
index 8120da278161..dbb6cb8069d9 100644
--- a/drivers/md/bcache/writeback.c
+++ b/drivers/md/bcache/writeback.c
@@ -790,10 +790,8 @@ static int bch_writeback_thread(void *arg)
 		}
 	}
 
-	if (dc->writeback_write_wq) {
-		flush_workqueue(dc->writeback_write_wq);
+	if (dc->writeback_write_wq)
 		destroy_workqueue(dc->writeback_write_wq);
-	}
 	cached_dev_put(dc);
 	wait_for_kthread_stop();
 
diff --git a/drivers/md/dm-bufio.c b/drivers/md/dm-bufio.c
index 50f3e673729c..fc8f8e9f9e39 100644
--- a/drivers/md/dm-bufio.c
+++ b/drivers/md/dm-bufio.c
@@ -2082,7 +2082,6 @@ static void __exit dm_bufio_exit(void)
 	int bug = 0;
 
 	cancel_delayed_work_sync(&dm_bufio_cleanup_old_work);
-	flush_workqueue(dm_bufio_wq);
 	destroy_workqueue(dm_bufio_wq);
 
 	if (dm_bufio_client_count) {
diff --git a/drivers/md/dm-zoned-target.c b/drivers/md/dm-zoned-target.c
index ae1bc48c0043..dfc822295c25 100644
--- a/drivers/md/dm-zoned-target.c
+++ b/drivers/md/dm-zoned-target.c
@@ -967,7 +967,6 @@ static void dmz_dtr(struct dm_target *ti)
 	struct dmz_target *dmz = ti->private;
 	int i;
 
-	flush_workqueue(dmz->chunk_wq);
 	destroy_workqueue(dmz->chunk_wq);
 
 	for (i = 0; i < dmz->nr_ddevs; i++)
-- 
2.30.2

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

