Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8E67EEB64D8
	for <dm-devel@archiver.kernel.org>; Thu, 22 Jun 2023 06:40:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1687416014;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=+jr5AeoxhzOY2jS6n1fYoZ4GGGqdW4GqvdEk0gTaMMM=;
	b=iVMpC3zspiRDbZIMSkwmP8JxXGapnhO0xZsILaprGIW23LZBQX1zjNZY0JEnLtX/nb5Q6W
	SFyRHJk7Ddoghm20DPlMpdWh+a9s8ZFRTbJAGx2Pm6d4SSKVJ2TWHRlkg2arQS8gzG0SLN
	aeCCk3OsJZ0bHrMRvjnRCmA+zuUO+1s=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-636-JjDPjJp0OWaiyEn89QkLCw-1; Thu, 22 Jun 2023 02:40:10 -0400
X-MC-Unique: JjDPjJp0OWaiyEn89QkLCw-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 13CC21C332B0;
	Thu, 22 Jun 2023 06:40:09 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id C28FC492C13;
	Thu, 22 Jun 2023 06:40:07 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id A128E1946595;
	Thu, 22 Jun 2023 06:40:07 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com
 [10.11.54.10])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 708971946587
 for <dm-devel@listman.corp.redhat.com>; Thu, 22 Jun 2023 06:00:10 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 4DBE040D1A4; Thu, 22 Jun 2023 06:00:10 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast10.extmail.prod.ext.rdu2.redhat.com [10.11.55.26])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 471A8492C13
 for <dm-devel@redhat.com>; Thu, 22 Jun 2023 06:00:10 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [207.211.31.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 2CD1B1C05EA8
 for <dm-devel@redhat.com>; Thu, 22 Jun 2023 06:00:10 +0000 (UTC)
Received: from verein.lst.de (verein.lst.de [213.95.11.211]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-119-QPW87l5XNiiMzKDLBX-d8Q-1; Thu, 22 Jun 2023 02:00:07 -0400
X-MC-Unique: QPW87l5XNiiMzKDLBX-d8Q-1
Received: by verein.lst.de (Postfix, from userid 2407)
 id 4E6A467373; Thu, 22 Jun 2023 08:00:01 +0200 (CEST)
Date: Thu, 22 Jun 2023 08:00:01 +0200
From: Christoph Hellwig <hch@lst.de>
To: Guenter Roeck <linux@roeck-us.net>
Message-ID: <20230622060001.GA8351@lst.de>
References: <20230523074535.249802-1-hch@lst.de>
 <20230523074535.249802-15-hch@lst.de>
 <8c1992bc-110a-4dad-8643-766c14bf6fd4@roeck-us.net>
 <20230622035149.GA4667@lst.de>
 <2205ef1e-9bb6-fb1e-9ca3-367c1afe12ac@roeck-us.net>
MIME-Version: 1.0
In-Reply-To: <2205ef1e-9bb6-fb1e-9ca3-367c1afe12ac@roeck-us.net>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.10
Subject: Re: [dm-devel] [PATCH 14/24] init: clear root_wait on all invalid
 root= strings
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
Cc: Jens Axboe <axboe@kernel.dk>, Vignesh Raghavendra <vigneshr@ti.com>,
 "Rafael J. Wysocki" <rafael@kernel.org>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>, linux-pm@vger.kernel.org,
 Joern Engel <joern@lazybastard.org>, linux-kernel@vger.kernel.org,
 linux-block@vger.kernel.org, Richard Weinberger <richard@nod.at>,
 dm-devel@redhat.com, Mike Snitzer <snitzer@kernel.org>,
 Pavel Machek <pavel@ucw.cz>, Miquel Raynal <miquel.raynal@bootlin.com>,
 linux-mtd@lists.infradead.org, Christoph Hellwig <hch@lst.de>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.10
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: lst.de
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Hi Guenter,

can you try this patch?

diff --git a/block/early-lookup.c b/block/early-lookup.c
index a5be3c68ed079c..66e4514d671179 100644
--- a/block/early-lookup.c
+++ b/block/early-lookup.c
@@ -174,7 +174,7 @@ static int __init devt_from_devname(const char *name, dev_t *devt)
 	while (p > s && isdigit(p[-1]))
 		p--;
 	if (p == s || !*p || *p == '0')
-		return -EINVAL;
+		return -ENODEV;
 
 	/* try disk name without <part number> */
 	part = simple_strtoul(p, NULL, 10);

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

