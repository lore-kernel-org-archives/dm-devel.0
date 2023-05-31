Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DB384C77B7A
	for <dm-devel@archiver.kernel.org>; Wed, 31 May 2023 14:02:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1685541739;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=p2CWhDDXeRHgvJPSCIizp3lpe4GSPdOCAK1wSCvrJ5M=;
	b=WTj6dSLoW6YBlp8B2WP+wEwRYTkNB+f1zTqJN4nWuPHZIzgtgIBOAtY/AVcYDEx7cl47kq
	i08tO4vEPX30l4gelJWMsYyOtgKV8ma/5O6U2PwQVqXz7wGzI9bv0saxpTvQLlX9aoDnwz
	zrENe9SCygNp25y2b/CWVwBvouyFXSY=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-573-9Xcpy8GrOQeqaK8TXrXvrw-1; Wed, 31 May 2023 10:02:15 -0400
X-MC-Unique: 9Xcpy8GrOQeqaK8TXrXvrw-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 272F7101B046;
	Wed, 31 May 2023 14:02:04 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id D5EF4421C3;
	Wed, 31 May 2023 14:02:02 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id C303F1946595;
	Wed, 31 May 2023 14:02:02 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com
 [10.11.54.2])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 6354219465A0
 for <dm-devel@listman.corp.redhat.com>; Wed, 31 May 2023 13:53:03 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 4235840C6EC4; Wed, 31 May 2023 13:53:03 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast06.extmail.prod.ext.rdu2.redhat.com [10.11.55.22])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 3BB3040D1B61
 for <dm-devel@redhat.com>; Wed, 31 May 2023 13:53:03 +0000 (UTC)
Received: from us-smtp-inbound-1.mimecast.com (us-smtp-2.mimecast.com
 [205.139.110.61])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 2254C185A78E
 for <dm-devel@redhat.com>; Wed, 31 May 2023 13:53:03 +0000 (UTC)
Received: from bombadil.infradead.org (bombadil.infradead.org
 [198.137.202.133]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-646-g960v_50Nb2dF8Yg6eB-gw-1; Wed, 31 May 2023 09:53:01 -0400
X-MC-Unique: g960v_50Nb2dF8Yg6eB-gw-1
Received: from [2001:4bb8:182:6d06:2e49:a56:513a:92ee] (helo=localhost)
 by bombadil.infradead.org with esmtpsa (Exim 4.96 #2 (Red Hat Linux))
 id 1q4LNM-00HRHM-2B; Wed, 31 May 2023 12:56:29 +0000
From: Christoph Hellwig <hch@lst.de>
To: Jens Axboe <axboe@kernel.dk>
Date: Wed, 31 May 2023 14:55:20 +0200
Message-Id: <20230531125535.676098-10-hch@lst.de>
In-Reply-To: <20230531125535.676098-1-hch@lst.de>
References: <20230531125535.676098-1-hch@lst.de>
MIME-Version: 1.0
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by
 bombadil.infradead.org. See http://www.infradead.org/rpr.html
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.2
Subject: [dm-devel] [PATCH 09/24] init: don't remove the /dev/ prefix from
 error messages
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
Cc: Loic Poulain <loic.poulain@linaro.org>,
 Vignesh Raghavendra <vigneshr@ti.com>, "Rafael J. Wysocki" <rafael@kernel.org>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>, linux-pm@vger.kernel.org,
 Joern Engel <joern@lazybastard.org>, linux-kernel@vger.kernel.org,
 linux-block@vger.kernel.org, Richard Weinberger <richard@nod.at>,
 dm-devel@redhat.com, Mike Snitzer <snitzer@kernel.org>,
 Pavel Machek <pavel@ucw.cz>, Miquel Raynal <miquel.raynal@bootlin.com>,
 linux-mtd@lists.infradead.org
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.5
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: lst.de
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Remove the code that drops the /dev/ prefix from root_device_name, which
is only used for error messages when mounting the root device fails.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 init/do_mounts.c | 17 ++++++-----------
 1 file changed, 6 insertions(+), 11 deletions(-)

diff --git a/init/do_mounts.c b/init/do_mounts.c
index 1405ee7218bf00..74cc96bffbdd71 100644
--- a/init/do_mounts.c
+++ b/init/do_mounts.c
@@ -607,8 +607,6 @@ void __init mount_root(char *root_device_name)
  */
 void __init prepare_namespace(void)
 {
-	char *root_device_name;
-
 	if (root_delay) {
 		printk(KERN_INFO "Waiting %d sec before mounting root device...\n",
 		       root_delay);
@@ -627,19 +625,16 @@ void __init prepare_namespace(void)
 	md_run_setup();
 
 	if (saved_root_name[0]) {
-		root_device_name = saved_root_name;
-		if (!strncmp(root_device_name, "mtd", 3) ||
-		    !strncmp(root_device_name, "ubi", 3)) {
-			mount_root_generic(root_device_name, root_device_name,
+		if (!strncmp(saved_root_name, "mtd", 3) ||
+		    !strncmp(saved_root_name, "ubi", 3)) {
+			mount_root_generic(saved_root_name, saved_root_name,
 					   root_mountflags);
 			goto out;
 		}
-		ROOT_DEV = name_to_dev_t(root_device_name);
-		if (strncmp(root_device_name, "/dev/", 5) == 0)
-			root_device_name += 5;
+		ROOT_DEV = name_to_dev_t(saved_root_name);
 	}
 
-	if (initrd_load(root_device_name))
+	if (initrd_load(saved_root_name))
 		goto out;
 
 	/* wait for any asynchronous scanning to complete */
@@ -652,7 +647,7 @@ void __init prepare_namespace(void)
 		async_synchronize_full();
 	}
 
-	mount_root(root_device_name);
+	mount_root(saved_root_name);
 out:
 	devtmpfs_mount();
 	init_mount(".", "/", NULL, MS_MOVE, NULL);
-- 
2.39.2

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

