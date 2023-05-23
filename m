Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3B8ECC7EE26
	for <dm-devel@archiver.kernel.org>; Tue, 23 May 2023 08:54:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1684832083;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=uoBNAzSlxdM3VoeE+ia3zHj2FQ0mZDlgRfAFZ+zhUH4=;
	b=WiAh7Ei8RBMrT8vKfS+RvW8LWXhDyXa8aPd7qftpTuAVsg3+gCnd88ceVXfeSvn6wm6Vtx
	M2kxpQPVPVGVbfewiImk8xBSCL1fU773x5YLYM6frJW5tKB1q+AbkCx68Z1hDUJ42FmGF1
	+86yzIaWJ8dRdZUTtdpKZBFXH8AT8SA=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-88-6J0osx9NNWOiN_2DZAcPvw-1; Tue, 23 May 2023 04:54:41 -0400
X-MC-Unique: 6J0osx9NNWOiN_2DZAcPvw-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id D6B53101A55C;
	Tue, 23 May 2023 08:54:39 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id C3FA62166B25;
	Tue, 23 May 2023 08:54:39 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 9B3AF19465A0;
	Tue, 23 May 2023 08:54:39 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
 [10.11.54.4])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id A8B7E1946595
 for <dm-devel@listman.corp.redhat.com>; Tue, 23 May 2023 08:54:38 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 9653D20296C8; Tue, 23 May 2023 08:54:38 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast06.extmail.prod.ext.rdu2.redhat.com [10.11.55.22])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 8E0C620296C6
 for <dm-devel@redhat.com>; Tue, 23 May 2023 08:54:38 +0000 (UTC)
Received: from us-smtp-inbound-1.mimecast.com (us-smtp-1.mimecast.com
 [207.211.31.81])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 727D6185A78E
 for <dm-devel@redhat.com>; Tue, 23 May 2023 08:54:38 +0000 (UTC)
Received: from bombadil.infradead.org (bombadil.infradead.org
 [198.137.202.133]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-303-YWEFF88zNk29CNEhat_W6g-1; Tue, 23 May 2023 04:54:36 -0400
X-MC-Unique: YWEFF88zNk29CNEhat_W6g-1
Received: from [2001:4bb8:188:23b2:6ade:85c9:530f:6eb0] (helo=localhost)
 by bombadil.infradead.org with esmtpsa (Exim 4.96 #2 (Red Hat Linux))
 id 1q1Miu-009H5F-2p; Tue, 23 May 2023 07:46:26 +0000
From: Christoph Hellwig <hch@lst.de>
To: Jens Axboe <axboe@kernel.dk>
Date: Tue, 23 May 2023 09:45:28 +0200
Message-Id: <20230523074535.249802-18-hch@lst.de>
In-Reply-To: <20230523074535.249802-1-hch@lst.de>
References: <20230523074535.249802-1-hch@lst.de>
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
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.4
Subject: [dm-devel] [PATCH 17/24] dm-snap: simplify the origin_dev ==
 cow_dev check in snapshot_ctr
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
Cc: Vignesh Raghavendra <vigneshr@ti.com>,
 "Rafael J. Wysocki" <rafael@kernel.org>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>, linux-pm@vger.kernel.org,
 Joern Engel <joern@lazybastard.org>, linux-kernel@vger.kernel.org,
 linux-block@vger.kernel.org, Richard Weinberger <richard@nod.at>,
 dm-devel@redhat.com, Mike Snitzer <snitzer@kernel.org>,
 Pavel Machek <pavel@ucw.cz>, Miquel Raynal <miquel.raynal@bootlin.com>,
 linux-mtd@lists.infradead.org
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.6
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: lst.de
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Use the block_device acquired in dm_get_device for the check instead
of doing an extra lookup.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 drivers/md/dm-snap.c | 14 +++++---------
 1 file changed, 5 insertions(+), 9 deletions(-)

diff --git a/drivers/md/dm-snap.c b/drivers/md/dm-snap.c
index 9c49f53760d066..7832974b73eb03 100644
--- a/drivers/md/dm-snap.c
+++ b/drivers/md/dm-snap.c
@@ -1241,7 +1241,6 @@ static int snapshot_ctr(struct dm_target *ti, unsigned int argc, char **argv)
 	int i;
 	int r = -EINVAL;
 	char *origin_path, *cow_path;
-	dev_t origin_dev, cow_dev;
 	unsigned int args_used, num_flush_bios = 1;
 	fmode_t origin_mode = FMODE_READ;
 
@@ -1279,24 +1278,21 @@ static int snapshot_ctr(struct dm_target *ti, unsigned int argc, char **argv)
 		ti->error = "Cannot get origin device";
 		goto bad_origin;
 	}
-	origin_dev = s->origin->bdev->bd_dev;
 
 	cow_path = argv[0];
 	argv++;
 	argc--;
 
-	cow_dev = dm_get_dev_t(cow_path);
-	if (cow_dev && cow_dev == origin_dev) {
-		ti->error = "COW device cannot be the same as origin device";
-		r = -EINVAL;
-		goto bad_cow;
-	}
-
 	r = dm_get_device(ti, cow_path, dm_table_get_mode(ti->table), &s->cow);
 	if (r) {
 		ti->error = "Cannot get COW device";
 		goto bad_cow;
 	}
+	if (s->cow->bdev && s->cow->bdev == s->origin->bdev) {
+		ti->error = "COW device cannot be the same as origin device";
+		r = -EINVAL;
+		goto bad_store;
+	}
 
 	r = dm_exception_store_create(ti, argc, argv, s, &args_used, &s->store);
 	if (r) {
-- 
2.39.2

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

