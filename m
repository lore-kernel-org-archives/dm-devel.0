Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F156AC433EF
	for <dm-devel@archiver.kernel.org>; Thu, 10 Feb 2022 22:43:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1644533000;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=W2C6x8UJu4uwobx2ZmRUKu4PwpxS0ZnGGdeei6J52I0=;
	b=H6umjTSpAOYHnLHERJOC/cymIRO+6wvZobk2cp8CN9112ptacBIS3DvfPfGKK5BNVT4B0h
	KmHnl20En3vBAxJPYTMtJP39rxfoHFIUB8KIhe2aII9uKQ1HyjAkinZi/ySKIULAsga9ki
	xxz8bZd2c846cq1aLmak8D4Lxh2Nmrw=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-610-d4Vt0zHUPEeTUg-FKetWaQ-1; Thu, 10 Feb 2022 17:43:16 -0500
X-MC-Unique: d4Vt0zHUPEeTUg-FKetWaQ-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 79C5B1018725;
	Thu, 10 Feb 2022 22:43:12 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 5C1E4E73F;
	Thu, 10 Feb 2022 22:43:12 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 36F221806D2F;
	Thu, 10 Feb 2022 22:43:12 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
	[10.11.54.5])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 21AMcicR014812 for <dm-devel@listman.util.phx.redhat.com>;
	Thu, 10 Feb 2022 17:38:44 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id F39C17ACA; Thu, 10 Feb 2022 22:38:43 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast02.extmail.prod.ext.rdu2.redhat.com [10.11.55.18])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id EE8177AC6
	for <dm-devel@redhat.com>; Thu, 10 Feb 2022 22:38:39 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [205.139.110.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 03AFF80120D
	for <dm-devel@redhat.com>; Thu, 10 Feb 2022 22:38:39 +0000 (UTC)
Received: from mail-qt1-f200.google.com (mail-qt1-f200.google.com
	[209.85.160.200]) by relay.mimecast.com with ESMTP with STARTTLS
	(version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
	us-mta-64-Tx_Rg5SIP9iOkOzeaQajCg-1; Thu, 10 Feb 2022 17:38:37 -0500
X-MC-Unique: Tx_Rg5SIP9iOkOzeaQajCg-1
Received: by mail-qt1-f200.google.com with SMTP id
	x10-20020ac8700a000000b002c3ef8fc44cso5550406qtm.8
	for <dm-devel@redhat.com>; Thu, 10 Feb 2022 14:38:37 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=1e100.net; s=20210112;
	h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
	:references;
	bh=gASqrtvOszXul4kd0cd64/f9seYYh7m9E4wnSmr4aF8=;
	b=ZQL+L5uvYjEol4P8i/jJIDsOqhfSHfLnphOU2pGPkq7bOY3j/YF+86Aq26WCGRZeU9
	iCJSklP0bXi630BLicw+yHXjVQbQwGL7xJHDItFfudWHN4yfNyAiIf/cq9wYqWUhiiEB
	qemOTWyTthrm3ga4hv2ScOFgWIQuYyHZUxuOkK8fJwYb/uGEo342RNTxHcQp5ZBzvg5s
	yE3easDQGUJN7VTSD9vN8Dpb6IcyUMwtfLFsLwTN7sKyXA95EOb0aK4793IgHOZTqfVB
	uHIqg5tQOPnA4sY6p3iQDLe+s94p0O0PuPWfRq6B4bPl2jGOzG6sscWsHBefLYT4D8Lh
	sQpQ==
X-Gm-Message-State: AOAM5339waRLUWiZ2KZxj7AapAv/DGiRZEPjMWv7D6GXgPlD6PuUHptA
	/lVUi+fRN5HqocQ156hIFeotFvwFlua2yw7hfHZxOWjpyHQyK6Pdx1CGkRWvEb5qLfqChsM0o2o
	8CymC7wErc9IH6uhoTKTMThn/5ckmZf5T0JYAzVtn58/+zj10DIX2JMPmnGEjHyXErw==
X-Received: by 2002:a05:6214:262a:: with SMTP id
	gv10mr6836045qvb.98.1644532717157; 
	Thu, 10 Feb 2022 14:38:37 -0800 (PST)
X-Google-Smtp-Source: ABdhPJzshop5rhMcKKQyyYkS5tpUkVizfBc4b1Us/DFjfwBMEjhEWnkmSha5lLdwwyHGYJ/E/eeeTw==
X-Received: by 2002:a05:6214:262a:: with SMTP id
	gv10mr6836035qvb.98.1644532716895; 
	Thu, 10 Feb 2022 14:38:36 -0800 (PST)
Received: from localhost (pool-68-160-176-52.bstnma.fios.verizon.net.
	[68.160.176.52]) by smtp.gmail.com with ESMTPSA id
	y15sm10527083qko.133.2022.02.10.14.38.36
	(version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
	Thu, 10 Feb 2022 14:38:36 -0800 (PST)
From: Mike Snitzer <snitzer@redhat.com>
To: dm-devel@redhat.com
Date: Thu, 10 Feb 2022 17:38:20 -0500
Message-Id: <20220210223832.99412-3-snitzer@redhat.com>
In-Reply-To: <20220210223832.99412-1-snitzer@redhat.com>
References: <20220210223832.99412-1-snitzer@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.11.54.5
X-loop: dm-devel@redhat.com
Cc: linux-block@vger.kernel.org
Subject: [dm-devel] [PATCH 02/14] dm: fold __clone_and_map_data_bio into
	__split_and_process_bio
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

Fold __clone_and_map_data_bio into its only caller.

Signed-off-by: Mike Snitzer <snitzer@redhat.com>
---
 drivers/md/dm.c | 30 ++++++++----------------------
 1 file changed, 8 insertions(+), 22 deletions(-)

diff --git a/drivers/md/dm.c b/drivers/md/dm.c
index 2cecb8832936..2f1942b61d48 100644
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -1188,25 +1188,6 @@ static void bio_setup_sector(struct bio *bio, sector_t sector, unsigned len)
 	bio->bi_iter.bi_size = to_bytes(len);
 }
 
-/*
- * Creates a bio that consists of range of complete bvecs.
- */
-static int __clone_and_map_data_bio(struct clone_info *ci, struct dm_target *ti,
-				    sector_t sector, unsigned *len)
-{
-	struct bio *bio = ci->bio, *clone;
-
-	clone = alloc_tio(ci, ti, 0, len, GFP_NOIO);
-	bio_advance(clone, to_bytes(sector - clone->bi_iter.bi_sector));
-	clone->bi_iter.bi_size = to_bytes(*len);
-
-	if (bio_integrity(bio))
-		bio_integrity_trim(clone);
-
-	__map_bio(clone);
-	return 0;
-}
-
 static void alloc_multiple_bios(struct bio_list *blist, struct clone_info *ci,
 				struct dm_target *ti, unsigned num_bios,
 				unsigned *len)
@@ -1361,6 +1342,7 @@ static bool __process_abnormal_io(struct clone_info *ci, struct dm_target *ti,
  */
 static int __split_and_process_bio(struct clone_info *ci)
 {
+	struct bio *clone;
 	struct dm_target *ti;
 	unsigned len;
 	int r;
@@ -1374,9 +1356,13 @@ static int __split_and_process_bio(struct clone_info *ci)
 
 	len = min_t(sector_t, max_io_len(ti, ci->sector), ci->sector_count);
 
-	r = __clone_and_map_data_bio(ci, ti, ci->sector, &len);
-	if (r < 0)
-		return r;
+	clone = alloc_tio(ci, ti, 0, &len, GFP_NOIO);
+	bio_advance(clone, to_bytes(ci->sector - clone->bi_iter.bi_sector));
+	clone->bi_iter.bi_size = to_bytes(len);
+	if (bio_integrity(clone))
+		bio_integrity_trim(clone);
+
+	__map_bio(clone);
 
 	ci->sector += len;
 	ci->sector_count -= len;
-- 
2.15.0

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

