Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 278E0C433F5
	for <dm-devel@archiver.kernel.org>; Fri, 11 Feb 2022 21:47:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1644616034;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=KqOMbmzf07yxQMw0jXQE+h4LJua9aGVGFgr4nhC42RQ=;
	b=T9bLIRQqg/nLac3iabnHmuRZW2tDgWqG9VxKmuv18qUpne513Nm6SQrDxrqzo74OiUx/Vw
	mm/tgErBp89kr50Cx+9QsB2+So3Rf+u/bebVGLHVpGMy7XEvafXnr1ZVH7SSoN/LqxhuBu
	f3JKzGdT8abwFB/XF5XEzADWRi1gCHE=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-264-vQ3LDh-gP_CdHlAY7ilGww-1; Fri, 11 Feb 2022 16:47:10 -0500
X-MC-Unique: vQ3LDh-gP_CdHlAY7ilGww-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 759A61091DA6;
	Fri, 11 Feb 2022 21:47:05 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 2F191108B7;
	Fri, 11 Feb 2022 21:47:05 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 7EE0E4BB7C;
	Fri, 11 Feb 2022 21:47:04 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com
	[10.11.54.9])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 21BLfSuU024762 for <dm-devel@listman.util.phx.redhat.com>;
	Fri, 11 Feb 2022 16:41:28 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 04588492D5A; Fri, 11 Feb 2022 21:41:28 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast04.extmail.prod.ext.rdu2.redhat.com [10.11.55.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 0061248FB01
	for <dm-devel@redhat.com>; Fri, 11 Feb 2022 21:41:27 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [205.139.110.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id D809B1066567
	for <dm-devel@redhat.com>; Fri, 11 Feb 2022 21:41:16 +0000 (UTC)
Received: from mail-oo1-f69.google.com (mail-oo1-f69.google.com
	[209.85.161.69]) by relay.mimecast.com with ESMTP with STARTTLS
	(version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
	us-mta-670-jrG2IcnzPjuBmQrEdYl3KA-1; Fri, 11 Feb 2022 16:41:15 -0500
X-MC-Unique: jrG2IcnzPjuBmQrEdYl3KA-1
Received: by mail-oo1-f69.google.com with SMTP id
	h7-20020a4aa287000000b002eb15de5797so6313906ool.23
	for <dm-devel@redhat.com>; Fri, 11 Feb 2022 13:41:15 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=1e100.net; s=20210112;
	h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
	:references;
	bh=2nmpafQ891zGruDm7dwh6CvU71ZYy/KSzMouVi0m1L4=;
	b=OFFYRdS/6mwK821E7x+tyGUBTxw08RqE/onZEJfWIoIrAP8mXv8haG70C/FAhjOngK
	citypFUkZnMjoN/otXg0FceUoJxAW5Ef/NMB/cGqlVos9QTyXKvOqkULJirFprVpqrgP
	VJOlTJsYhm7QHX8YQAcGtHXWpnC0glQOAnfuVw/RWooexrhXe+kG+C2chvqOrlToA9i6
	9VCRXoJeUMRcaKqACEjWzsfWhGtb+2i9oA4pWtzFFlbTTI68BKijO8zr5jtPNS6Tyzvl
	i5EKuoZHOdUAzklF6TqQILX0k8DzJlPFzD2dDuAH0pbV5rR86EM92zxLx747BwyJKyQT
	GaEQ==
X-Gm-Message-State: AOAM531vPJS3O5fds6XjOZAxwKwAFtHpPgw1LS7o751g+1W1I+38CDXe
	3fxwlI9RiJVW3yBNkzRySfX4YSCMr6wrRDjj/QDm/8+giPGz1oYHyW4LoqkrBXAgD6jvHW9I3wq
	M7a4SvEUxQZHLZw/CX1YRf1CUY/I0pWd8qZFooX4dtBduN/jkEstJRyQC+2A1XY9Nvw==
X-Received: by 2002:a05:6808:21aa:: with SMTP id
	be42mr1202433oib.181.1644615674318; 
	Fri, 11 Feb 2022 13:41:14 -0800 (PST)
X-Google-Smtp-Source: ABdhPJzPfXPPLsFfj5jCNwhbMCjHAtWwuF5IJFLhrkJvKUleXUnCO1B4gxuNTOXX8lKI2/HhrYfUdA==
X-Received: by 2002:a05:6808:21aa:: with SMTP id
	be42mr1202427oib.181.1644615674109; 
	Fri, 11 Feb 2022 13:41:14 -0800 (PST)
Received: from localhost (pool-68-160-176-52.bstnma.fios.verizon.net.
	[68.160.176.52]) by smtp.gmail.com with ESMTPSA id
	b20sm9518934otq.20.2022.02.11.13.41.13
	(version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
	Fri, 11 Feb 2022 13:41:13 -0800 (PST)
From: Mike Snitzer <snitzer@redhat.com>
To: dm-devel@redhat.com
Date: Fri, 11 Feb 2022 16:40:49 -0500
Message-Id: <20220211214057.40612-7-snitzer@redhat.com>
In-Reply-To: <20220211214057.40612-1-snitzer@redhat.com>
References: <20220211214057.40612-1-snitzer@redhat.com>
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.9
X-loop: dm-devel@redhat.com
Cc: linux-block@vger.kernel.org
Subject: [dm-devel] [PATCH v2 06/14] dm: remove unused mapped_device
	argument from free_tio
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
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Mike Snitzer <snitzer@redhat.com>
---
 drivers/md/dm.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/md/dm.c b/drivers/md/dm.c
index bd07ccadbf01..137e578785f6 100644
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

