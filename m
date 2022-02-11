Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4F23BC433FE
	for <dm-devel@archiver.kernel.org>; Fri, 11 Feb 2022 21:47:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1644616031;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=xhucd8CmQsrQd+yeAx3f9mfVqX2iZGJJokwl6c1QrAA=;
	b=eQw170JtSEQ4ZC7IXUP/ObUwq0bqW5jAH0Bw//+sZayv/lUIEhc7R5/L7a500JLLhY8PpO
	06ERkda3dwZIFQxrmtpsMsJxrApztXXHpbZ5GTHlGvf4MZ12CzdDMuCkEEP8dfEur0cAw7
	BeeiTElrLq0GJHweoBGy31rv0HxqJdU=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-652-AUCbLRfNNt2XMh_avdwhNg-1; Fri, 11 Feb 2022 16:47:07 -0500
X-MC-Unique: AUCbLRfNNt2XMh_avdwhNg-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 65390190B2B1;
	Fri, 11 Feb 2022 21:47:03 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 1CC73108A1;
	Fri, 11 Feb 2022 21:47:03 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id DBF891806D2B;
	Fri, 11 Feb 2022 21:47:02 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com
	[10.11.54.2])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 21BLfPE8024742 for <dm-devel@listman.util.phx.redhat.com>;
	Fri, 11 Feb 2022 16:41:25 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 9F67240E80EA; Fri, 11 Feb 2022 21:41:24 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast08.extmail.prod.ext.rdu2.redhat.com [10.11.55.24])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 9B36B40E80E0
	for <dm-devel@redhat.com>; Fri, 11 Feb 2022 21:41:24 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [207.211.31.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
	bits)) (No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 642CE38008A3
	for <dm-devel@redhat.com>; Fri, 11 Feb 2022 21:41:18 +0000 (UTC)
Received: from mail-oo1-f72.google.com (mail-oo1-f72.google.com
	[209.85.161.72]) by relay.mimecast.com with ESMTP with STARTTLS
	(version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
	us-mta-247-4KHIrhxbMuydbspXZ5cHSg-1; Fri, 11 Feb 2022 16:41:12 -0500
X-MC-Unique: 4KHIrhxbMuydbspXZ5cHSg-1
Received: by mail-oo1-f72.google.com with SMTP id
	k10-20020a4ad98a000000b003185c75574dso3732383oou.1
	for <dm-devel@redhat.com>; Fri, 11 Feb 2022 13:41:12 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=1e100.net; s=20210112;
	h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
	:references;
	bh=mv03BNY+xdulNavhI7whyVhl6SEZfhNGRgDBWAdqIBo=;
	b=RIC+qQPz8KUjZov0A3xdRDJK+c9lp6sxhJ0pBLdiPXzBG9PByv8bJNIqlcm+WWPHIn
	Tc60ZEFDfCN+9eVz8u0iPJZwXFuIRYxjLCDDD3LgpXsdBq0Mu+cvycB47AOJHx6p+8VX
	15DmqzHT0gl6hO6dAImU9NG60mVSz/jCZHbOud8vdnNB87aPYH2AMs7iaf8gasO6EMZV
	oTxht0ZHNR+AU4Uk7dRXTVI6MUP6begPUmXQcJOK35CNpg+QeF7xmdhWWit3B2nAj5pq
	yqD6LIVAazSsP137ta1uifTBzeZpwNbHgeSlHcqj9kgDYILSSmYye8MfnfQtWfwe3kmj
	f6Xg==
X-Gm-Message-State: AOAM533KX/xP+XD8FfLqQRFj+rUlvMpUKggmiGGUtuHqZHNgScSsa0kA
	G4v+sBtBI3d7AsImhjQYW1Kr/+1gA2Xcn4ddgimBvhX4laMtyFdjXWBt8XZ+RWatvZVecBWLY7b
	0G92En1TelTUB4VmHoWK9tz2joVLC0hNIMiFPo19D2jji5kNcB80s1NXyfZAOX6oXTw==
X-Received: by 2002:a05:6830:448e:: with SMTP id
	r14mr1299848otv.102.1644615671138; 
	Fri, 11 Feb 2022 13:41:11 -0800 (PST)
X-Google-Smtp-Source: ABdhPJx6SaEVfuBnc3P3ZkrUt/Pa1m5PKMHPu72Tk0s5Ge6mbotnvK/0AprRlTrDn7upIV5AdGhz6w==
X-Received: by 2002:a05:6830:448e:: with SMTP id
	r14mr1299835otv.102.1644615670766; 
	Fri, 11 Feb 2022 13:41:10 -0800 (PST)
Received: from localhost (pool-68-160-176-52.bstnma.fios.verizon.net.
	[68.160.176.52])
	by smtp.gmail.com with ESMTPSA id 21sm9610956otj.71.2022.02.11.13.41.10
	(version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
	Fri, 11 Feb 2022 13:41:10 -0800 (PST)
From: Mike Snitzer <snitzer@redhat.com>
To: dm-devel@redhat.com
Date: Fri, 11 Feb 2022 16:40:47 -0500
Message-Id: <20220211214057.40612-5-snitzer@redhat.com>
In-Reply-To: <20220211214057.40612-1-snitzer@redhat.com>
References: <20220211214057.40612-1-snitzer@redhat.com>
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.2
X-loop: dm-devel@redhat.com
Cc: linux-block@vger.kernel.org
Subject: [dm-devel] [PATCH v2 04/14] dm: reduce code duplication in __map_bio
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

Error path code (for handling DM_MAPIO_REQUEUE and DM_MAPIO_KILL) is
effectively identical.

Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Mike Snitzer <snitzer@redhat.com>
---
 drivers/md/dm.c | 18 ++++++------------
 1 file changed, 6 insertions(+), 12 deletions(-)

diff --git a/drivers/md/dm.c b/drivers/md/dm.c
index 60a047de620f..8f2288a3b35b 100644
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

