Return-Path: <SRS0=/Nun=EY=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D5462C5519F
	for <dm-devel@archiver.kernel.org>; Wed, 18 Nov 2020 08:53:04 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 3C43A20719
	for <dm-devel@archiver.kernel.org>; Wed, 18 Nov 2020 08:53:04 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 3C43A20719
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-521-FcwxHds0MjqMfDqyI9672g-1; Wed, 18 Nov 2020 03:52:21 -0500
X-MC-Unique: FcwxHds0MjqMfDqyI9672g-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id C37B76D24A;
	Wed, 18 Nov 2020 08:52:10 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id A930060C05;
	Wed, 18 Nov 2020 08:52:10 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 7D8D0181A07C;
	Wed, 18 Nov 2020 08:52:10 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
	[10.11.54.5])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 0AI8pt6D019099 for <dm-devel@listman.util.phx.redhat.com>;
	Wed, 18 Nov 2020 03:51:55 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 2353DB0790; Wed, 18 Nov 2020 08:51:55 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast06.extmail.prod.ext.rdu2.redhat.com [10.11.55.22])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 19181B07AE
	for <dm-devel@redhat.com>; Wed, 18 Nov 2020 08:51:52 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[205.139.110.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id EAB2E185A78B
	for <dm-devel@redhat.com>; Wed, 18 Nov 2020 08:51:51 +0000 (UTC)
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-148-KX_pOak6POOkwY5hwqlryA-1; Wed, 18 Nov 2020 03:51:50 -0500
X-MC-Unique: KX_pOak6POOkwY5hwqlryA-1
Received: from [2001:4bb8:18c:31ba:32b1:ec66:5459:36a] (helo=localhost)
	by casper.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
	id 1kfJ8T-0007lo-R0; Wed, 18 Nov 2020 08:48:18 +0000
From: Christoph Hellwig <hch@lst.de>
To: Jens Axboe <axboe@kernel.dk>
Date: Wed, 18 Nov 2020 09:47:49 +0100
Message-Id: <20201118084800.2339180-10-hch@lst.de>
In-Reply-To: <20201118084800.2339180-1-hch@lst.de>
References: <20201118084800.2339180-1-hch@lst.de>
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
X-Scanned-By: MIMEDefang 2.79 on 10.11.54.5
X-loop: dm-devel@redhat.com
Cc: linux-bcache@vger.kernel.org, Mike Snitzer <snitzer@redhat.com>,
	Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
	Richard Weinberger <richard@nod.at>,
	Josef Bacik <josef@toxicpanda.com>, Coly Li <colyli@suse.de>,
	linux-block@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	dm-devel@redhat.com, linux-mtd@lists.infradead.org,
	Jan Kara <jack@suse.com>, Tejun Heo <tj@kernel.org>,
	xen-devel@lists.xenproject.org, linux-mm@kvack.org
Subject: [dm-devel] [PATCH 09/20] init: cleanup match_dev_by_uuid and
	match_dev_by_label
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Avoid a totally pointless goto label, and use the same style of
comparism for both helpers.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 init/do_mounts.c | 18 ++++++------------
 1 file changed, 6 insertions(+), 12 deletions(-)

diff --git a/init/do_mounts.c b/init/do_mounts.c
index afa26a4028d25e..5879edf083b318 100644
--- a/init/do_mounts.c
+++ b/init/do_mounts.c
@@ -79,15 +79,10 @@ static int match_dev_by_uuid(struct device *dev, const void *data)
 	const struct uuidcmp *cmp = data;
 	struct hd_struct *part = dev_to_part(dev);
 
-	if (!part->info)
-		goto no_match;
-
-	if (strncasecmp(cmp->uuid, part->info->uuid, cmp->len))
-		goto no_match;
-
+	if (!part->info ||
+	    strncasecmp(cmp->uuid, part->info->uuid, cmp->len))
+		return 0;
 	return 1;
-no_match:
-	return 0;
 }
 
 /**
@@ -174,10 +169,9 @@ static int match_dev_by_label(struct device *dev, const void *data)
 	const char *label = data;
 	struct hd_struct *part = dev_to_part(dev);
 
-	if (part->info && !strcmp(label, part->info->volname))
-		return 1;
-
-	return 0;
+	if (!part->info || strcmp(label, part->info->volname))
+		return 0;
+	return 1;
 }
 
 static dev_t devt_from_partlabel(const char *label)
-- 
2.29.2

--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel

