Return-Path: <SRS0=voF8=GZ=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E8E9FC433E0
	for <dm-devel@archiver.kernel.org>; Fri, 22 Jan 2021 15:27:43 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 2C6BC23A84
	for <dm-devel@archiver.kernel.org>; Fri, 22 Jan 2021 15:27:42 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 2C6BC23A84
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=arrikto.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-9-Om_nD7j2MceLj1gpHxhELw-1; Fri, 22 Jan 2021 10:27:38 -0500
X-MC-Unique: Om_nD7j2MceLj1gpHxhELw-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id E784D18C89C4;
	Fri, 22 Jan 2021 15:27:32 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id B991D5D6CF;
	Fri, 22 Jan 2021 15:27:32 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 582544BB40;
	Fri, 22 Jan 2021 15:27:32 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
	[10.11.54.5])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 10MFQCq1028605 for <dm-devel@listman.util.phx.redhat.com>;
	Fri, 22 Jan 2021 10:26:12 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id DDF2CEE39A; Fri, 22 Jan 2021 15:26:11 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast04.extmail.prod.ext.rdu2.redhat.com [10.11.55.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id D84D2EE84E
	for <dm-devel@redhat.com>; Fri, 22 Jan 2021 15:26:11 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[207.211.31.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id C5A94101A565
	for <dm-devel@redhat.com>; Fri, 22 Jan 2021 15:26:11 +0000 (UTC)
Received: from mail-wr1-f53.google.com (mail-wr1-f53.google.com
	[209.85.221.53]) (Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-453-MLu-W6AAOpSdJaRFDQgMuA-1; Fri, 22 Jan 2021 10:26:07 -0500
X-MC-Unique: MLu-W6AAOpSdJaRFDQgMuA-1
Received: by mail-wr1-f53.google.com with SMTP id l12so5466950wry.2
	for <dm-devel@redhat.com>; Fri, 22 Jan 2021 07:26:07 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=1e100.net; s=20161025;
	h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
	:references;
	bh=RKude94Zrh4ADG0Do//PpQ+RSbgumBAyrqGV2UNHdtA=;
	b=Z6f1XwjGPmS9cuCSd8EmIaGKskWXbE9qYa+S8+dnIYY9LWuOijfFZ2xGn5gHOXa6tY
	GTsLXzwPpzCgp7nOAC1lHfp9cLa4Gb55D6d5SGNrW+0w7+GwtLPDc0sFEPRKpoLXAe/6
	xDguFc7HH2sxuWXOI7PPz+UqLEoOIuVK5cgtGiPJHLQ9fvDFSQGVFXMapbBVmFoEzKB6
	W+ccdYH1tgsKN/Tb5QDn1PiXcy33L7NnrAQ7SqtxkSU1mE58GNidWYRrQM+XjKzTV7Ne
	ZEcIrX3MH95Uf6ql0x9KV/LQinEscvsJDyXGUA0Gl4lZtkpHNQ/h9+gVwrCgWTXgrzXC
	Otig==
X-Gm-Message-State: AOAM532LgzgyhA7iR5i19aGw2AfQHeA8YLv2QywVHwZBCWRC8hF5yjUt
	A5BOfSuS/Ad8gGDc9BR5a1jh1w==
X-Google-Smtp-Source: ABdhPJymlsbgT0j0R/pJwt5MBDGrWK8VaVpqZsVbxk34j+5pdsJr00nj+3m+e02xFKSRfj5B+LCtgQ==
X-Received: by 2002:a5d:54cc:: with SMTP id x12mr5094959wrv.132.1611329166676; 
	Fri, 22 Jan 2021 07:26:06 -0800 (PST)
Received: from snf-864.vm.snf.arr ([31.177.62.212])
	by smtp.gmail.com with ESMTPSA id
	r1sm12685159wrl.95.2021.01.22.07.26.04
	(version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
	Fri, 22 Jan 2021 07:26:05 -0800 (PST)
From: Nikos Tsironis <ntsironis@arrikto.com>
To: snitzer@redhat.com, agk@redhat.com, dm-devel@redhat.com
Date: Fri, 22 Jan 2021 17:25:56 +0200
Message-Id: <20210122152556.24822-5-ntsironis@arrikto.com>
In-Reply-To: <20210122152556.24822-1-ntsironis@arrikto.com>
References: <20210122152556.24822-1-ntsironis@arrikto.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.79 on 10.11.54.5
X-loop: dm-devel@redhat.com
Cc: ejt@redhat.com, ntsironis@arrikto.com
Subject: [dm-devel] [PATCH 4/4] dm era: Remove unreachable resize operation
	in pre-resume function
X-BeenThere: dm-devel@redhat.com
X-Mailman-Version: 2.1.12
Precedence: junk
List-Id: device-mapper development <dm-devel.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
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

The device metadata are resized in era_ctr(), so the metadata resize
operation in era_preresume() never runs.

Also, note, that if the operation did ever run it would deadlock, since
the worker has not been started at this point.

Fixes: eec40579d84873 ("dm: add era target")
Cc: stable@vger.kernel.org # v3.15+
Signed-off-by: Nikos Tsironis <ntsironis@arrikto.com>
---
 drivers/md/dm-era-target.c | 9 ---------
 1 file changed, 9 deletions(-)

diff --git a/drivers/md/dm-era-target.c b/drivers/md/dm-era-target.c
index 104fb110cd4e..c40e132e50cd 100644
--- a/drivers/md/dm-era-target.c
+++ b/drivers/md/dm-era-target.c
@@ -1567,15 +1567,6 @@ static int era_preresume(struct dm_target *ti)
 {
 	int r;
 	struct era *era = ti->private;
-	dm_block_t new_size = calc_nr_blocks(era);
-
-	if (era->nr_blocks != new_size) {
-		r = in_worker1(era, metadata_resize, &new_size);
-		if (r)
-			return r;
-
-		era->nr_blocks = new_size;
-	}
 
 	start_worker(era);
 
-- 
2.11.0

--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel

