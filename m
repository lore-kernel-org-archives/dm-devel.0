Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 57813C433F5
	for <dm-devel@archiver.kernel.org>; Thu, 10 Feb 2022 22:42:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1644532963;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=T6cBQeF6JP7i/vGvCfcIrm9RT+gIiYF23I97dsvKg9I=;
	b=HLAEpwgoAMtyDsEOPaibdMqPM4eC0YUJCn/qOnWNhDwr/krQcGDwMx4eyhhHOTn6oVbR7W
	fQ37bT6+G0vuQeRoT7RYOqlSy0x9babuyZ339JTd6EHpaN2tTeNK+krA+z0jX8et5mJMkR
	uZCn+vN28GsYbQFL7g9AarZgi+8UOEg=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-459-AplMnRewOe-qdeHH6xuK6Q-1; Thu, 10 Feb 2022 17:42:41 -0500
X-MC-Unique: AplMnRewOe-qdeHH6xuK6Q-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 49CF018C8C02;
	Thu, 10 Feb 2022 22:42:37 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 2EFE14CEF0;
	Thu, 10 Feb 2022 22:42:37 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id ED4571809CB9;
	Thu, 10 Feb 2022 22:42:36 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
	[10.11.54.6])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 21AMclR2014830 for <dm-devel@listman.util.phx.redhat.com>;
	Thu, 10 Feb 2022 17:38:47 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 0F2352166BB1; Thu, 10 Feb 2022 22:38:47 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast09.extmail.prod.ext.rdu2.redhat.com [10.11.55.25])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 0B5732166BDB
	for <dm-devel@redhat.com>; Thu, 10 Feb 2022 22:38:44 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[207.211.31.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 0683F29AA38B
	for <dm-devel@redhat.com>; Thu, 10 Feb 2022 22:38:44 +0000 (UTC)
Received: from mail-qv1-f69.google.com (mail-qv1-f69.google.com
	[209.85.219.69]) by relay.mimecast.com with ESMTP with STARTTLS
	(version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
	us-mta-319-muTFlH0ON-eUvdcqwuNz7w-1; Thu, 10 Feb 2022 17:38:42 -0500
X-MC-Unique: muTFlH0ON-eUvdcqwuNz7w-1
Received: by mail-qv1-f69.google.com with SMTP id
	e9-20020a0cf749000000b0042bf697ff6bso5031756qvo.5
	for <dm-devel@redhat.com>; Thu, 10 Feb 2022 14:38:42 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=1e100.net; s=20210112;
	h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
	:references;
	bh=TzXjPgdywpvS4JKTWEPuvG6S5tjQ0HqbosRT6X11Ckc=;
	b=0J1Ngyx3L3FMyqmr81u9/0QzIc80wSz2J0BXcaAXMeY33vpYhdipyRAtCgnFm+FD11
	I3X0NLa6ZR1ahwDkSjx6dS5v7ueuqzhAhd09TP1Krta2U7NuSB6hzPHYWkkk35FQgJ6t
	tZhApjsXxauGua5lB1+3jIWjDS8VBUqqATzHO2rOfcmHBXrTS6vuFJjQNLtC+v6mBVrR
	q0vDJv0dFjpqOJgcd4cgNmONqP598W7O4AcVD/RYUd3EDFjzPaTUyf4RKAHPYgHPB3xS
	XEOaTfXCwqujX71bFiHbwoAWe3d3gXt57UgN+H68V+eBl4bv6Y9F+yi3js1/C7wJsrdL
	rjBg==
X-Gm-Message-State: AOAM532ARb9tT5BSa+zEKLHuoLxe3ibdQ6XV8CdQOrw7ItGrGhDZm+/P
	BkWOxgpwxKsxiP84l/ryEf7+TNutMe9CzaNd8XfjE75o4ulIr5hMs2bm5s3GxE8mAofZQKrFA+t
	P9qRtXTE+y17l/hCHL5rWJN9b5Q/YO6s4xDnGgUix0fqSQji7BgXBOs842nbGSNRyRQ==
X-Received: by 2002:a05:6214:5084:: with SMTP id
	kk4mr6496959qvb.87.1644532722363; 
	Thu, 10 Feb 2022 14:38:42 -0800 (PST)
X-Google-Smtp-Source: ABdhPJwdUxlHbTKVegt7q96UOVkLZzblVev6PndTCx99qOFkY4DYSKF6tEc5hRZE8V6mEfZmaLcoVA==
X-Received: by 2002:a05:6214:5084:: with SMTP id
	kk4mr6496949qvb.87.1644532722175; 
	Thu, 10 Feb 2022 14:38:42 -0800 (PST)
Received: from localhost (pool-68-160-176-52.bstnma.fios.verizon.net.
	[68.160.176.52]) by smtp.gmail.com with ESMTPSA id
	v14sm10322732qkl.128.2022.02.10.14.38.41
	(version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
	Thu, 10 Feb 2022 14:38:41 -0800 (PST)
From: Mike Snitzer <snitzer@redhat.com>
To: dm-devel@redhat.com
Date: Thu, 10 Feb 2022 17:38:24 -0500
Message-Id: <20220210223832.99412-7-snitzer@redhat.com>
In-Reply-To: <20220210223832.99412-1-snitzer@redhat.com>
References: <20220210223832.99412-1-snitzer@redhat.com>
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.6
X-loop: dm-devel@redhat.com
Cc: linux-block@vger.kernel.org
Subject: [dm-devel] [PATCH 06/14] dm: remove unused mapped_device argument
	from free_tio
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
MIME-Version: 1.0
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Signed-off-by: Mike Snitzer <snitzer@redhat.com>
---
 drivers/md/dm.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/md/dm.c b/drivers/md/dm.c
index 1985fc3f2a95..f091bbf8a8dc 100644
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -539,7 +539,7 @@ static struct dm_io *alloc_io(struct mapped_device *md, struct bio *bio)
 	return io;
 }
 
-static void free_io(struct mapped_device *md, struct dm_io *io)
+static void free_io(struct dm_io *io)
 {
 	bio_put(&io->tio.clone);
 }
@@ -825,7 +825,7 @@ void dm_io_dec_pending(struct dm_io *io, blk_status_t error)
 		io_error = io->status;
 		start_time = io->start_time;
 		stats_aux = io->stats_aux;
-		free_io(md, io);
+		free_io(io);
 		end_io_acct(md, bio, start_time, &stats_aux);
 
 		if (io_error == BLK_STS_DM_REQUEUE)
-- 
2.15.0

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

