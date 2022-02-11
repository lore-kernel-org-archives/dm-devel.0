Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 48D2AC433EF
	for <dm-devel@archiver.kernel.org>; Fri, 11 Feb 2022 21:44:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1644615878;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=C5TG54I06FF2Kb2K/g31cCdDQ+wIOb1zeO8UBpwebwg=;
	b=bf38YT3dLfHMKXJe9JXulH7lkDqluiO8o7UW+zaII2/6RFqicq4dtQs0Q7g3UM6SHrbpXC
	BHakRcRuiZLqKzLphil3/fTacFeI9eY0b7GGSlDZrg1VlMnMYh2bFIhQf9j77VTENyN/4A
	zWqKi+nTf3CdVFlIz8cyYO2YqAcBYOY=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-539-bMd7u1ueMdOoU1ruxpg3Jw-1; Fri, 11 Feb 2022 16:44:34 -0500
X-MC-Unique: bMd7u1ueMdOoU1ruxpg3Jw-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 2289A100CCDD;
	Fri, 11 Feb 2022 21:44:30 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id C498E1017E36;
	Fri, 11 Feb 2022 21:44:29 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 9DC751809CB8;
	Fri, 11 Feb 2022 21:44:29 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
	[10.11.54.6])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 21BLffJ5024809 for <dm-devel@listman.util.phx.redhat.com>;
	Fri, 11 Feb 2022 16:41:41 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id A35EB2167D68; Fri, 11 Feb 2022 21:41:40 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast04.extmail.prod.ext.rdu2.redhat.com [10.11.55.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 9C9B72167D63
	for <dm-devel@redhat.com>; Fri, 11 Feb 2022 21:41:34 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[207.211.31.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id CEDCE1066564
	for <dm-devel@redhat.com>; Fri, 11 Feb 2022 21:41:32 +0000 (UTC)
Received: from mail-ot1-f70.google.com (mail-ot1-f70.google.com
	[209.85.210.70]) by relay.mimecast.com with ESMTP with STARTTLS
	(version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
	us-mta-479-J9H7oruzP8a-77yyhluhrA-1; Fri, 11 Feb 2022 16:41:19 -0500
X-MC-Unique: J9H7oruzP8a-77yyhluhrA-1
Received: by mail-ot1-f70.google.com with SMTP id
	w16-20020a056830111000b005a3e1a958ccso6029991otq.11
	for <dm-devel@redhat.com>; Fri, 11 Feb 2022 13:41:19 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=1e100.net; s=20210112;
	h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
	:references;
	bh=faOHtfTWGQl15mu9cVGnYSzZzcsDZXq9izeb7DCgtfk=;
	b=nJIzDAGmXzmBxIRQ29sYmSI89ht9kjDVsacUfOXJAi4c8q68gCn9kLp1DSC1PqtH/r
	BXFb7aZwYNsWIZ9y5zqE9LtjXK+jOSsBRyYQ7f0VWoLQrLnpW6guuPwLvxfgABPMHGIZ
	Pm6enKOXX94XQfToV9eBlkTnx3V7wihLmbwuXckp+vfIdFmh0KhLGnpwgeYEgXXP+Mbv
	wh1BLVRzV9jj6vGeKnCi54pFEw/HsWEY1D4PM4quiCtxRz5V5LPpgYGIletaIw+fR8Ty
	n0j4ErSXoLKJkp4oim+fvWYOqfIrWTnb9sPIBiS60Xs/9uXbxglTCs38bKyUmhZ9W/Rx
	N6Ow==
X-Gm-Message-State: AOAM532nnoSrmu0PP8OkkYQkm7vkaQVeRsWQR2DTH7Y3/Khh++CUWPaX
	p8H6/uovfGA+8fPXChrNK9akgl3pvw5bViAd9JGm+hzgrBYWeAPvB3bAlIi4Tyxh8yekhmAdrJe
	PkTtxf2W0Hq/GdEZgfeXPXUUus9l36MgFqTbLeZsc3+e99Irj9qVOsX3fRZ4birSwGQ==
X-Received: by 2002:a05:6870:35c2:: with SMTP id
	c2mr769402oak.79.1644615678404; 
	Fri, 11 Feb 2022 13:41:18 -0800 (PST)
X-Google-Smtp-Source: ABdhPJyHF2eI3D/fU3NXr6t8JQgauezM5zXIlCfv0BTpbFhkCXv0M5fjNT7muszxcaIOFb2OGolKWg==
X-Received: by 2002:a05:6870:35c2:: with SMTP id
	c2mr769396oak.79.1644615678110; 
	Fri, 11 Feb 2022 13:41:18 -0800 (PST)
Received: from localhost (pool-68-160-176-52.bstnma.fios.verizon.net.
	[68.160.176.52])
	by smtp.gmail.com with ESMTPSA id k6sm9778837oop.28.2022.02.11.13.41.17
	(version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
	Fri, 11 Feb 2022 13:41:17 -0800 (PST)
From: Mike Snitzer <snitzer@redhat.com>
To: dm-devel@redhat.com
Date: Fri, 11 Feb 2022 16:40:51 -0500
Message-Id: <20220211214057.40612-9-snitzer@redhat.com>
In-Reply-To: <20220211214057.40612-1-snitzer@redhat.com>
References: <20220211214057.40612-1-snitzer@redhat.com>
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.6
X-loop: dm-devel@redhat.com
Cc: linux-block@vger.kernel.org
Subject: [dm-devel] [PATCH v2 08/14] dm: record old_sector in dm_target_io
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
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Prep for being able to defer trace_block_bio_remap() until when the
bio is remapped and submitted by the DM target.

Reviewed-by: Christoph Hellwig <hch@lst.de>
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
index 164cccf59297..2f2002348b26 100644
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

