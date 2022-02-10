Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C0A24C433F5
	for <dm-devel@archiver.kernel.org>; Thu, 10 Feb 2022 22:43:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1644533003;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=GQoQiUCky61fCO5LnsEHp/9Ota0FRD+SNhiu0tcRp9E=;
	b=IS/i39CjNk2QRbn5dchDdUFaRHVG7wtr6h1sFwQA4NDf2o+YDGQNhMpADS29BQJj6Ju2SB
	CvQgAtlCvFehaC4Qkj5k64TUlxhBlnpPWQmRBz/QIXwJRUIeVbXTukWk0Dfw8bRizFPBj9
	SqEfov4yP/+gA/t+y18oobL5R+HYPts=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-147-EiLFP2IUNlCZX1XxJAfymg-1; Thu, 10 Feb 2022 17:43:20 -0500
X-MC-Unique: EiLFP2IUNlCZX1XxJAfymg-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id DE386814253;
	Thu, 10 Feb 2022 22:43:15 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id C42C05C2EF;
	Thu, 10 Feb 2022 22:43:15 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 9DE464A706;
	Thu, 10 Feb 2022 22:43:15 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com
	[10.11.54.7])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 21AMcu6S014894 for <dm-devel@listman.util.phx.redhat.com>;
	Thu, 10 Feb 2022 17:38:56 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 14FD31454547; Thu, 10 Feb 2022 22:38:56 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast08.extmail.prod.ext.rdu2.redhat.com [10.11.55.24])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 116BB1454546
	for <dm-devel@redhat.com>; Thu, 10 Feb 2022 22:38:56 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [207.211.31.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
	bits)) (No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id D63093803916
	for <dm-devel@redhat.com>; Thu, 10 Feb 2022 22:38:55 +0000 (UTC)
Received: from mail-qk1-f200.google.com (mail-qk1-f200.google.com
	[209.85.222.200]) by relay.mimecast.com with ESMTP with STARTTLS
	(version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
	us-mta-627-ekQ1REnNOMOaIBfJGf4sbw-1; Thu, 10 Feb 2022 17:38:54 -0500
X-MC-Unique: ekQ1REnNOMOaIBfJGf4sbw-1
Received: by mail-qk1-f200.google.com with SMTP id
	b204-20020a3767d5000000b004b2a0d2e930so4545206qkc.15
	for <dm-devel@redhat.com>; Thu, 10 Feb 2022 14:38:45 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=1e100.net; s=20210112;
	h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
	:references;
	bh=DEABWOQAG5wChjoRVdmD9+4tJqi002FLqoS+HHDd0E8=;
	b=Vh6n4n+n2HsNCMZd1lNgl4qrwCxxHrpLdWNcEq1lTmrqfg39bzfugrsdBqejrAjcoK
	b+7N/FB0ZJYLKVGYm78JZ4P4Fchb33Kx+KdAKnuCgGA1g+RQorXR2/dl4mq6P/wYPvA3
	m5BnLbGGtLqURgawRs2cualJ+omv5PGqZ0jL/t7puAnRUhvLyh8fNL5YJdjV2EMYCtCp
	mdqKvlRbfnjIdh4zqicX8+yopDymnmx73qLB0hf/BdXvSr+uPsWGwH02wnwq/W2fr2z2
	TutKLPj2CWIVZcjqxQZr7hoXCc5b7uPXUPuTZ5FzcOzdNuCkCMl9xIy2CU4cjbBy6uBU
	mQMA==
X-Gm-Message-State: AOAM532wA/SoAHPJtwiP2mrL673XRl56KwL2qLKQYM0yXMPztokrIbOP
	oJeYWOULxY7V8DM+3cpH0tpqaDZBOq6W1Ry4/KR062oRGQWB2PEXuMI05Bb1Iqv5bi6w2nTwhUd
	uPDrWVA7mrm1rNrNQvW+mdA8JdYESBP3GB3LCvMBj5hxynIMnKPbIfgp4MGM+0jn0iQ==
X-Received: by 2002:a05:620a:2954:: with SMTP id
	n20mr4949258qkp.644.1644532723872; 
	Thu, 10 Feb 2022 14:38:43 -0800 (PST)
X-Google-Smtp-Source: ABdhPJwB/jwDj6FI1/7jk/S/HO15AQAsoYUPunogWnQegdbM0VkAmgE3KfBpXMwIwDBuvLYdBmPAtw==
X-Received: by 2002:a05:620a:2954:: with SMTP id
	n20mr4949253qkp.644.1644532723624; 
	Thu, 10 Feb 2022 14:38:43 -0800 (PST)
Received: from localhost (pool-68-160-176-52.bstnma.fios.verizon.net.
	[68.160.176.52]) by smtp.gmail.com with ESMTPSA id
	n7sm11816185qta.78.2022.02.10.14.38.42
	(version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
	Thu, 10 Feb 2022 14:38:43 -0800 (PST)
From: Mike Snitzer <snitzer@redhat.com>
To: dm-devel@redhat.com
Date: Thu, 10 Feb 2022 17:38:25 -0500
Message-Id: <20220210223832.99412-8-snitzer@redhat.com>
In-Reply-To: <20220210223832.99412-1-snitzer@redhat.com>
References: <20220210223832.99412-1-snitzer@redhat.com>
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.7
X-loop: dm-devel@redhat.com
Cc: linux-block@vger.kernel.org
Subject: [dm-devel] [PATCH 07/14] dm: remove code only needed before
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
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

Signed-off-by: Mike Snitzer <snitzer@redhat.com>
---
 drivers/md/dm.c | 11 ++---------
 1 file changed, 2 insertions(+), 9 deletions(-)

diff --git a/drivers/md/dm.c b/drivers/md/dm.c
index f091bbf8a8dc..5950d518e544 100644
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

