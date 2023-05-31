Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C7A12C77B73
	for <dm-devel@archiver.kernel.org>; Wed, 31 May 2023 13:31:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1685539881;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=439NkDslW1Xa31/L8A9kBro0iGM8arDw3jqi/BPfcX8=;
	b=IeM/30uKgSjN8NfL22G2UGWhtMyV556X6Y0tFbYJcg4Yg9EGMBYfoaWab1DyIplzXaTxHl
	WgZy+L92N6jmGFfpmZdaCPicQvPl3ANIo/c0IzkjhdPRtvcsbxUPfr24nIYps1UHGc0rJT
	tiC2xjxpvMaEEn+lsRB/wD7ANVidaEk=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-146-FBj4yw7hN_aMAZjPo5p76A-1; Wed, 31 May 2023 09:31:18 -0400
X-MC-Unique: FBj4yw7hN_aMAZjPo5p76A-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 06C76101A55C;
	Wed, 31 May 2023 13:31:09 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id EA25E170ED;
	Wed, 31 May 2023 13:31:08 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id A908119465A0;
	Wed, 31 May 2023 13:31:08 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com
 [10.11.54.7])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id CCAA619465BA
 for <dm-devel@listman.corp.redhat.com>; Wed, 31 May 2023 12:57:30 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id B1B6C140E963; Wed, 31 May 2023 12:57:30 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast06.extmail.prod.ext.rdu2.redhat.com [10.11.55.22])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id AA796140E962
 for <dm-devel@redhat.com>; Wed, 31 May 2023 12:57:30 +0000 (UTC)
Received: from us-smtp-inbound-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [207.211.31.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 5324C185A791
 for <dm-devel@redhat.com>; Wed, 31 May 2023 12:57:30 +0000 (UTC)
Received: from bombadil.infradead.org (bombadil.infradead.org
 [198.137.202.133]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-29-bAHeJSXfPvGN0jO1aYSUxA-1; Wed, 31 May 2023 08:57:28 -0400
X-MC-Unique: bAHeJSXfPvGN0jO1aYSUxA-1
Received: from [2001:4bb8:182:6d06:2e49:a56:513a:92ee] (helo=localhost)
 by bombadil.infradead.org with esmtpsa (Exim 4.96 #2 (Red Hat Linux))
 id 1q4LOC-00HS1f-0T; Wed, 31 May 2023 12:57:20 +0000
From: Christoph Hellwig <hch@lst.de>
To: Jens Axboe <axboe@kernel.dk>
Date: Wed, 31 May 2023 14:55:31 +0200
Message-Id: <20230531125535.676098-21-hch@lst.de>
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
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.7
Subject: [dm-devel] [PATCH 20/24] dm: only call early_lookup_bdev from early
 boot context
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

early_lookup_bdev is supposed to only be called from the early boot
code, but dm_get_device calls it as a general fallback when lookup_bdev
fails, which is problematic because early_lookup_bdev bypasses all normal
path based permission checking, and might cause problems with certain
container environments renaming devices.

Switch to only call early_lookup_bdev when dm is built-in and the system
state in not running yet.  This means it is still available when tables
are constructed by dm-init.c from the kernel command line, but not
otherwise.

Note that this strictly speaking changes the kernel ABI as the PARTUUID=
and PARTLABEL= style syntax is now not available during a running
systems.  They never were intended for that, but this breaks things
we'll have to figure out a way to make them available again.  But if
avoidable in any way I'd rather avoid that.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Mike Snitzer <snitzer@kernel.org>
---
 drivers/md/dm-table.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/drivers/md/dm-table.c b/drivers/md/dm-table.c
index 1576b408768d4b..2fd5826bfce175 100644
--- a/drivers/md/dm-table.c
+++ b/drivers/md/dm-table.c
@@ -326,8 +326,11 @@ static int upgrade_mode(struct dm_dev_internal *dd, fmode_t new_mode,
 /*
  * Add a device to the list, or just increment the usage count if
  * it's already present.
+ *
+ * Note: the __ref annotation is because this function can call the __init
+ * marked early_lookup_bdev when called during early boot code from dm-init.c.
  */
-int dm_get_device(struct dm_target *ti, const char *path, fmode_t mode,
+int __ref dm_get_device(struct dm_target *ti, const char *path, fmode_t mode,
 		  struct dm_dev **result)
 {
 	int r;
@@ -346,8 +349,10 @@ int dm_get_device(struct dm_target *ti, const char *path, fmode_t mode,
 			return -EOVERFLOW;
 	} else {
 		r = lookup_bdev(path, &dev);
-		if (r)
+#ifndef MODULE
+		if (r && system_state < SYSTEM_RUNNING)
 			r = early_lookup_bdev(path, &dev);
+#endif
 		if (r)
 			return r;
 	}
-- 
2.39.2

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

