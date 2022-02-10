Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 82804C4332F
	for <dm-devel@archiver.kernel.org>; Thu, 10 Feb 2022 22:42:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1644532975;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=WErM0niRakstBq3WeILpk4wiX/Dn1VVES8Q295MGsBI=;
	b=VJubCCmEIAqa3pH/yt52Qgy974tAd6k6HzNu3ZFFtPh2f74QGgOrsD14ja8MgHem7V46oa
	LAB/9K4rXdksRHtFtmqtJ5Zge7lz79pUv2iJAQLIHOnmTISvBSyAUipNxB0/krz9/GcPqt
	gFUzLBlvoBQqdD5uo0SnPbN/wCptXhc=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-339-IEgqXqDlOsGwB3iRc2hqCg-1; Thu, 10 Feb 2022 17:42:52 -0500
X-MC-Unique: IEgqXqDlOsGwB3iRc2hqCg-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id A56DC1091DA8;
	Thu, 10 Feb 2022 22:42:45 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 8A3EB56A81;
	Thu, 10 Feb 2022 22:42:45 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 635861802E34;
	Thu, 10 Feb 2022 22:42:45 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com
	[10.11.54.3])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 21AMcwoG014912 for <dm-devel@listman.util.phx.redhat.com>;
	Thu, 10 Feb 2022 17:38:58 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 17B501120AA9; Thu, 10 Feb 2022 22:38:58 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast03.extmail.prod.ext.rdu2.redhat.com [10.11.55.19])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 138711121335
	for <dm-devel@redhat.com>; Thu, 10 Feb 2022 22:38:47 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [207.211.31.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
	bits)) (No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 8E45A811E78
	for <dm-devel@redhat.com>; Thu, 10 Feb 2022 22:38:47 +0000 (UTC)
Received: from mail-qv1-f69.google.com (mail-qv1-f69.google.com
	[209.85.219.69]) by relay.mimecast.com with ESMTP with STARTTLS
	(version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
	us-mta-609-sQCUI-eZMbOfplKf1RTc-w-1; Thu, 10 Feb 2022 17:38:46 -0500
X-MC-Unique: sQCUI-eZMbOfplKf1RTc-w-1
Received: by mail-qv1-f69.google.com with SMTP id
	g2-20020a0562141cc200b004123b0abe18so5059707qvd.2
	for <dm-devel@redhat.com>; Thu, 10 Feb 2022 14:38:46 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=1e100.net; s=20210112;
	h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
	:references;
	bh=IfXmk5i0i3prdNRYxcELXekeRQ6SpDfxxN4oTGtZnNk=;
	b=pszJpHUNH3NdiXem168qTaxwaBzTGG58jF6+YSsie9gCA1D6J2Z+O4FbbeeuoemuQq
	YrtzloNr1+Ueb5h637CSwdha9G4bde4/GxfeefTOJie5RXMQs9uekl/HU0JmN/SXdS0I
	tR4ZHIk/pWxXx6j6zUcwFdgw8kxh6nOZ98GRXFqFdW7bw9r0p418cyWjCbkheoboG22i
	117TB9l4xRO2OW267ot2Bt97/ZpH5cNi3kSHuba7yMTv7/sLd/PWEGlPi84JGuKc5NM+
	mdQbuFts0SUNYgiWzmgo5JPBfnSfj8/V8rO4kwPnMx3H8r/5X75wUFuFmxTnfLq1VzIC
	xsDA==
X-Gm-Message-State: AOAM532mU2Wp2D8ygxC8eVbesyYLrEcEOx6e7OoWvPkuaNF2YC90mCJP
	NmLr2H/syWgiyjjZyV786PjAIA+cdN1AUaEf3lkgwzTQ/7a2YFxf8ScQkO73yOUnatDhlY9/ead
	G6qO9/RADCjjlbFKFnbOJ0IsvNDtHu2i/IYW2q636RS+f4FLkTdCL2eXqD8X5I9mc8Q==
X-Received: by 2002:a05:620a:4012:: with SMTP id
	h18mr5121618qko.421.1644532725559; 
	Thu, 10 Feb 2022 14:38:45 -0800 (PST)
X-Google-Smtp-Source: ABdhPJw/WuBM1MWf014PQYWdlKPzXr9gGf3iIEk91KFNZ30dmljK3pCiGA6TTM3Dqo0OPQkq2MwW1w==
X-Received: by 2002:a05:620a:4012:: with SMTP id
	h18mr5121607qko.421.1644532725259; 
	Thu, 10 Feb 2022 14:38:45 -0800 (PST)
Received: from localhost (pool-68-160-176-52.bstnma.fios.verizon.net.
	[68.160.176.52])
	by smtp.gmail.com with ESMTPSA id c3sm6575052qkp.39.2022.02.10.14.38.44
	(version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
	Thu, 10 Feb 2022 14:38:44 -0800 (PST)
From: Mike Snitzer <snitzer@redhat.com>
To: dm-devel@redhat.com
Date: Thu, 10 Feb 2022 17:38:26 -0500
Message-Id: <20220210223832.99412-9-snitzer@redhat.com>
In-Reply-To: <20220210223832.99412-1-snitzer@redhat.com>
References: <20220210223832.99412-1-snitzer@redhat.com>
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.3
X-loop: dm-devel@redhat.com
Cc: linux-block@vger.kernel.org
Subject: [dm-devel] [PATCH 08/14] dm: record old_sector in dm_target_io
	before calling map function
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

Prep for being able to defer trace_block_bio_remap() until when the
bio is remapped and submitted by the DM target.

Signed-off-by: Mike Snitzer <snitzer@redhat.com>
---
 drivers/md/dm-core.h | 1 +
 drivers/md/dm.c      | 7 ++++---
 2 files changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/md/dm-core.h b/drivers/md/dm-core.h
index 72d18c3fbf1f..f40be01cca81 100644
--- a/drivers/md/dm-core.h
+++ b/drivers/md/dm-core.h
@@ -214,6 +214,7 @@ struct dm_target_io {
 	unsigned int target_bio_nr;
 	unsigned int *len_ptr;
 	bool inside_dm_io;
+	sector_t old_sector;
 	struct bio clone;
 };
 
diff --git a/drivers/md/dm.c b/drivers/md/dm.c
index 5950d518e544..3bd872b0e891 100644
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -567,6 +567,7 @@ static struct bio *alloc_tio(struct clone_info *ci, struct dm_target *ti,
 	tio->ti = ti;
 	tio->target_bio_nr = target_bio_nr;
 	tio->len_ptr = len;
+	tio->old_sector = 0;
 
 	return &tio->clone;
 }
@@ -1120,7 +1121,6 @@ static void __map_bio(struct bio *clone)
 {
 	struct dm_target_io *tio = clone_to_tio(clone);
 	int r;
-	sector_t sector;
 	struct dm_io *io = tio->io;
 	struct dm_target *ti = tio->ti;
 
@@ -1132,7 +1132,7 @@ static void __map_bio(struct bio *clone)
 	 * this io.
 	 */
 	dm_io_inc_pending(io);
-	sector = clone->bi_iter.bi_sector;
+	tio->old_sector = clone->bi_iter.bi_sector;
 
 	if (unlikely(swap_bios_limit(ti, clone))) {
 		struct mapped_device *md = io->md;
@@ -1157,7 +1157,8 @@ static void __map_bio(struct bio *clone)
 		break;
 	case DM_MAPIO_REMAPPED:
 		/* the bio has been remapped so dispatch it */
-		trace_block_bio_remap(clone, bio_dev(io->orig_bio), sector);
+		trace_block_bio_remap(clone, bio_dev(io->orig_bio),
+				      tio->old_sector);
 		submit_bio_noacct(clone);
 		break;
 	case DM_MAPIO_KILL:
-- 
2.15.0

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

