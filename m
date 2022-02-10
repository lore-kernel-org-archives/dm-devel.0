Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 38FC8C433F5
	for <dm-devel@archiver.kernel.org>; Thu, 10 Feb 2022 22:40:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1644532842;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=IyPpLgMREOqA3BM0HBw5sLyblf7xNDnvGV+U//yHL1g=;
	b=YnRB792xVBhn9VP8huoK2B/XtsLxZxoolqtK2ylXezevtJzfJIrwzAW4nKKuDz8VgdsTzy
	jdZexzZbT3Vj+iCAANtUcMuMIOIf8M+qTAIJdc+c6x0jCTmJltrvXjcTQXo5KiAqDO2sVh
	WqAQOnLZK0h/aWAYJ80bYnWPowwbQDY=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-543-GnGrIFCeNV6jTFRsJHIThA-1; Thu, 10 Feb 2022 17:40:38 -0500
X-MC-Unique: GnGrIFCeNV6jTFRsJHIThA-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 91CB985EE74;
	Thu, 10 Feb 2022 22:40:34 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 3218D79588;
	Thu, 10 Feb 2022 22:40:34 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id EA48C4BB7C;
	Thu, 10 Feb 2022 22:40:33 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com
	[10.11.54.9])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 21AMcf5U014791 for <dm-devel@listman.util.phx.redhat.com>;
	Thu, 10 Feb 2022 17:38:41 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id AEBDD492D51; Thu, 10 Feb 2022 22:38:41 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast05.extmail.prod.ext.rdu2.redhat.com [10.11.55.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id AAF66492D47
	for <dm-devel@redhat.com>; Thu, 10 Feb 2022 22:38:41 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [205.139.110.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 909DC8032EB
	for <dm-devel@redhat.com>; Thu, 10 Feb 2022 22:38:41 +0000 (UTC)
Received: from mail-qk1-f200.google.com (mail-qk1-f200.google.com
	[209.85.222.200]) by relay.mimecast.com with ESMTP with STARTTLS
	(version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
	us-mta-636-2CkyFYC7P_-VEUvNqi9Zfw-1; Thu, 10 Feb 2022 17:38:40 -0500
X-MC-Unique: 2CkyFYC7P_-VEUvNqi9Zfw-1
Received: by mail-qk1-f200.google.com with SMTP id
	bl5-20020a05620a1a8500b005088d061be4so4539011qkb.21
	for <dm-devel@redhat.com>; Thu, 10 Feb 2022 14:38:40 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=1e100.net; s=20210112;
	h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
	:references;
	bh=N1ZtWuQD/2MiqgkrjoL8yazkFH5KXeFDL5OjLo4UsiQ=;
	b=wq1IXyPvLNTM4hCVBv/OuYI/CYFfgSJ68hAkgwehteJg2ajKjcJMK8hPJou2MEaRLt
	fqFjLZnNXW8RaKB/tsnN9zzz7+xXcBwWjLFUiqpT9zOIHc8BWhrTgOhNbEihXAi3R20c
	/SOvYmt4qdcG/oE40eeytZlckaXIypqwCFkncx5cFQshn0IbaO9uzA4iN6MVXwNP+Wjc
	dF3ioxUGvyPRPu6lP90IPpI0bDgWC6T8BdUd1jAoAplNIroCYoH+J96IoTBcYI8bHgKD
	+RL4gFIeOWO6lzZh04r6wMzZfKR+hknJWAkSZ6Rg1MHbq7hxLzfBuNgtUThXPHRCHBAJ
	asTA==
X-Gm-Message-State: AOAM5334B5xYbFD+pZN2GwiF4T0Tk1i++kOs4yZzR7FYRsQHrYD18Sq1
	tiMIYny1YStRG2caojbLsaRp9S+olLYERM/pS5Lhorpwc/XLJ45GiXCYnuhtZLQQh1Wx0RzyxZZ
	2tArJDGQIk/MTXT4Q4S3ejVvE4p+mkzwcWbncweP4WomxvNcP0EfC1wOLDo+j2vOpEw==
X-Received: by 2002:ac8:7771:: with SMTP id h17mr6568563qtu.454.1644532719627; 
	Thu, 10 Feb 2022 14:38:39 -0800 (PST)
X-Google-Smtp-Source: ABdhPJxVQD4DjXjI2TI6RHlCNfSHCzJOeMiWv0AytqCY43O5jsmCNUHGzFo0EsTCPdXZui5wk8R+dw==
X-Received: by 2002:ac8:7771:: with SMTP id h17mr6568552qtu.454.1644532719407; 
	Thu, 10 Feb 2022 14:38:39 -0800 (PST)
Received: from localhost (pool-68-160-176-52.bstnma.fios.verizon.net.
	[68.160.176.52]) by smtp.gmail.com with ESMTPSA id
	h11sm2556932qkp.89.2022.02.10.14.38.38
	(version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
	Thu, 10 Feb 2022 14:38:39 -0800 (PST)
From: Mike Snitzer <snitzer@redhat.com>
To: dm-devel@redhat.com
Date: Thu, 10 Feb 2022 17:38:22 -0500
Message-Id: <20220210223832.99412-5-snitzer@redhat.com>
In-Reply-To: <20220210223832.99412-1-snitzer@redhat.com>
References: <20220210223832.99412-1-snitzer@redhat.com>
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.9
X-loop: dm-devel@redhat.com
Cc: linux-block@vger.kernel.org
Subject: [dm-devel] [PATCH 04/14] dm: reduce code duplication in __map_bio
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Error path code (for handling DM_MAPIO_REQUEUE and DM_MAPIO_KILL) is
effectively identical.

Signed-off-by: Mike Snitzer <snitzer@redhat.com>
---
 drivers/md/dm.c | 18 ++++++------------
 1 file changed, 6 insertions(+), 12 deletions(-)

diff --git a/drivers/md/dm.c b/drivers/md/dm.c
index 56734aae718d..cc014e56252e 100644
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -1161,20 +1161,14 @@ static void __map_bio(struct bio *clone)
 		submit_bio_noacct(clone);
 		break;
 	case DM_MAPIO_KILL:
-		if (unlikely(swap_bios_limit(ti, clone))) {
-			struct mapped_device *md = io->md;
-			up(&md->swap_bios_semaphore);
-		}
-		free_tio(clone);
-		dm_io_dec_pending(io, BLK_STS_IOERR);
-		break;
 	case DM_MAPIO_REQUEUE:
-		if (unlikely(swap_bios_limit(ti, clone))) {
-			struct mapped_device *md = io->md;
-			up(&md->swap_bios_semaphore);
-		}
+		if (unlikely(swap_bios_limit(ti, clone)))
+			up(&io->md->swap_bios_semaphore);
 		free_tio(clone);
-		dm_io_dec_pending(io, BLK_STS_DM_REQUEUE);
+		if (r == DM_MAPIO_KILL)
+			dm_io_dec_pending(io, BLK_STS_IOERR);
+		else
+			dm_io_dec_pending(io, BLK_STS_DM_REQUEUE);
 		break;
 	default:
 		DMWARN("unimplemented target map return value: %d", r);
-- 
2.15.0

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

