Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8425EC433FE
	for <dm-devel@archiver.kernel.org>; Fri, 11 Feb 2022 21:47:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1644616035;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=e5VZ/Zl4NGR61X3HRW3MWuOAJBKTB7N0pktjciQYVH8=;
	b=g7TIzvhrSQZD/M2+fNRd2I7Qejo23Mdu2UlNu58M+DQL3xwiYzVuJQMZoKc642jJ26pWeP
	tpMhjHp6jkdgEG2uWHJwnO1MLqvZ4wa2yo/RkD7PYoqdih3/mMgxW0luMIP08tPUuTzvAL
	ieIpZ+5eAjyHSYxqUAbleGL3eoB7RFw=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-42-wCseQYp1Nh-b-9mNTe5tYQ-1; Fri, 11 Feb 2022 16:47:11 -0500
X-MC-Unique: wCseQYp1Nh-b-9mNTe5tYQ-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 067518144ED;
	Fri, 11 Feb 2022 21:47:07 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id ABDC156F83;
	Fri, 11 Feb 2022 21:47:06 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 587CC4CA9B;
	Fri, 11 Feb 2022 21:47:06 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
	[10.11.54.4])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 21BLfUqu024770 for <dm-devel@listman.util.phx.redhat.com>;
	Fri, 11 Feb 2022 16:41:30 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 3C6522024CBC; Fri, 11 Feb 2022 21:41:29 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast07.extmail.prod.ext.rdu2.redhat.com [10.11.55.23])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 38786200A4E8
	for <dm-devel@redhat.com>; Fri, 11 Feb 2022 21:41:26 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[207.211.31.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 8428E3C00122
	for <dm-devel@redhat.com>; Fri, 11 Feb 2022 21:41:19 +0000 (UTC)
Received: from mail-ot1-f72.google.com (mail-ot1-f72.google.com
	[209.85.210.72]) by relay.mimecast.com with ESMTP with STARTTLS
	(version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
	us-mta-325-3r_giUaZNbeIOYgNUE-l-A-1; Fri, 11 Feb 2022 16:41:17 -0500
X-MC-Unique: 3r_giUaZNbeIOYgNUE-l-A-1
Received: by mail-ot1-f72.google.com with SMTP id
	g6-20020a9d6b06000000b005abea86957eso4827436otp.14
	for <dm-devel@redhat.com>; Fri, 11 Feb 2022 13:41:17 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=1e100.net; s=20210112;
	h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
	:references;
	bh=f2o5ohPI2HuG5wRnh3mt12sAQPRqGLpu4c/5MftkwBY=;
	b=x2+YrAlYsnPs2VSrACyMsHpht2J7aHA0vnXu2vDYnk0w3P2N32l9+KNrgwcuMNFfik
	AqW5m9Z041TvxitYG8v8RqebHw6AGTfkILmizKICMV1AtNbMGkzWOA6JBIWj0LzrIJRl
	PwSt7zTcZ6oe1UCV0HAmWXWzm3QdnLKkO4HWohTVyw5pOwyo62wulZSEX7elpvPfEYb6
	lxXxIu+eeiwPVaI0t2ypE1HIOsd0vh5AfkLbcIJ1a6u18mqrG0Q5f5d3M1tn9Sd5zEIY
	p7yu2VYLGKZW1aAXS1YkoaTUIMG2lnphQfCnCok8zpCyvsxz6q/k7dhFMf0y/1hi1YS1
	2fVQ==
X-Gm-Message-State: AOAM531gywUiYIdceV3KGJ62ZEwm4mitbo5sQaOq1OlXIVS9tIIHrgDw
	IaXv8j1bUZNb2pJDlnvPf84Cfrf3qBS32Zb0Qv0muj6z17GXl/0U6SGXXWLJW4UxLOVjy00+cWW
	02VeFH8PaSnDgM6jdVw+W6ALEqgD1zBtZv+mUP/0qxywuF/UZgMVMdUQTanl/Ifc59w==
X-Received: by 2002:a05:6870:8784:: with SMTP id
	r4mr784943oam.274.1644615676729; 
	Fri, 11 Feb 2022 13:41:16 -0800 (PST)
X-Google-Smtp-Source: ABdhPJzmRjUtja3RP0gsAIOMggI4AOA1jQTFBsYiSLmauHnRAgEORh5WQj00HCwcy/wmJj5xdWtFcQ==
X-Received: by 2002:a05:6870:8784:: with SMTP id
	r4mr784936oam.274.1644615676503; 
	Fri, 11 Feb 2022 13:41:16 -0800 (PST)
Received: from localhost (pool-68-160-176-52.bstnma.fios.verizon.net.
	[68.160.176.52]) by smtp.gmail.com with ESMTPSA id
	y3sm10183932oix.41.2022.02.11.13.41.15
	(version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
	Fri, 11 Feb 2022 13:41:16 -0800 (PST)
From: Mike Snitzer <snitzer@redhat.com>
To: dm-devel@redhat.com
Date: Fri, 11 Feb 2022 16:40:50 -0500
Message-Id: <20220211214057.40612-8-snitzer@redhat.com>
In-Reply-To: <20220211214057.40612-1-snitzer@redhat.com>
References: <20220211214057.40612-1-snitzer@redhat.com>
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.4
X-loop: dm-devel@redhat.com
Cc: linux-block@vger.kernel.org
Subject: [dm-devel] [PATCH v2 07/14] dm: remove code only needed before
	submit_bio recursion
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Commit 8615cb65bd63 ("dm: remove useless loop in
__split_and_process_bio") showcased that we no longer loop.

Remove the bio_advance() in __split_and_process_bio() that was only
needed when looping was possible.

Similarly there is no need to advance the bio, using ci->sector
cursor, in __send_duplicate_bios().

Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Mike Snitzer <snitzer@redhat.com>
---
 drivers/md/dm.c | 11 ++---------
 1 file changed, 2 insertions(+), 9 deletions(-)

diff --git a/drivers/md/dm.c b/drivers/md/dm.c
index 137e578785f6..164cccf59297 100644
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -1176,12 +1176,6 @@ static void __map_bio(struct bio *clone)
 	}
 }
 
-static void bio_setup_sector(struct bio *bio, sector_t sector, unsigned len)
-{
-	bio->bi_iter.bi_sector = sector;
-	bio->bi_iter.bi_size = to_bytes(len);
-}
-
 static void alloc_multiple_bios(struct bio_list *blist, struct clone_info *ci,
 				struct dm_target *ti, unsigned num_bios,
 				unsigned *len)
@@ -1224,14 +1218,14 @@ static void __send_duplicate_bios(struct clone_info *ci, struct dm_target *ti,
 	case 1:
 		clone = alloc_tio(ci, ti, 0, len, GFP_NOIO);
 		if (len)
-			bio_setup_sector(clone, ci->sector, *len);
+			clone->bi_iter.bi_size = to_bytes(*len);
 		__map_bio(clone);
 		break;
 	default:
 		alloc_multiple_bios(&blist, ci, ti, num_bios, len);
 		while ((clone = bio_list_pop(&blist))) {
 			if (len)
-				bio_setup_sector(clone, ci->sector, *len);
+				clone->bi_iter.bi_size = to_bytes(*len);
 			__map_bio(clone);
 		}
 		break;
@@ -1350,7 +1344,6 @@ static int __split_and_process_bio(struct clone_info *ci)
 	len = min_t(sector_t, max_io_len(ti, ci->sector), ci->sector_count);
 
 	clone = alloc_tio(ci, ti, 0, &len, GFP_NOIO);
-	bio_advance(clone, to_bytes(ci->sector - clone->bi_iter.bi_sector));
 	clone->bi_iter.bi_size = to_bytes(len);
 	if (bio_integrity(clone))
 		bio_integrity_trim(clone);
-- 
2.15.0

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

