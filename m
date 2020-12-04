Return-Path: <SRS0=D9Ri=FI=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-22.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6A23EC433FE
	for <dm-devel@archiver.kernel.org>; Fri,  4 Dec 2020 22:39:13 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id CD9B422287
	for <dm-devel@archiver.kernel.org>; Fri,  4 Dec 2020 22:39:12 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org CD9B422287
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1607121551;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=BGl0Epd0CSQSy3s2fj6hukFCs1mcTVAvxsHOofsLwrg=;
	b=hkPZOTpKzwkvvm3bRcAosoJbo15xGLiilf/fiefpBvyBqjiQX7Nujv6KJg8UFyShdi2H62
	tdDWQPJNSMZuUyMtWtajQUxYgb60FCmeIBT+amCYTiEf7C/K4XOpVLSd3g3i//M0oxMrbZ
	tQRrkYAvIeBTQBMqQPJbhy5Klxu/z/U=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-463-6whI8doLOz-tFdy5dYt5XA-1; Fri, 04 Dec 2020 17:39:07 -0500
X-MC-Unique: 6whI8doLOz-tFdy5dYt5XA-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 28200180A086;
	Fri,  4 Dec 2020 22:39:01 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 88F675D6A1;
	Fri,  4 Dec 2020 22:39:00 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 021254BB7B;
	Fri,  4 Dec 2020 22:38:57 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com
	[10.11.54.3])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 0B4MboGu014736 for <dm-devel@listman.util.phx.redhat.com>;
	Fri, 4 Dec 2020 17:37:51 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id C643010CD6C3; Fri,  4 Dec 2020 22:37:50 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast05.extmail.prod.ext.rdu2.redhat.com [10.11.55.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id C231610CD6C2
	for <dm-devel@redhat.com>; Fri,  4 Dec 2020 22:37:48 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[205.139.110.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 848D6800157
	for <dm-devel@redhat.com>; Fri,  4 Dec 2020 22:37:48 +0000 (UTC)
Received: from mail-qk1-f196.google.com (mail-qk1-f196.google.com
	[209.85.222.196]) (Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-448-AFdDsUSLP1yjLYQpb6MJSQ-1; Fri, 04 Dec 2020 17:37:44 -0500
X-MC-Unique: AFdDsUSLP1yjLYQpb6MJSQ-1
Received: by mail-qk1-f196.google.com with SMTP id h20so7067358qkk.4;
	Fri, 04 Dec 2020 14:37:44 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=1e100.net; s=20161025;
	h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
	:references:mime-version:content-disposition:in-reply-to;
	bh=p5K117AYD5GD1c15NVXEU6O5XZ1i8FYadTHkksQyzQE=;
	b=PwwRq30XAAghRDOumgiZ3D9G2/oJxDlRKvykkrhrirMq6Y+8Vns+zVBsCVZyZzlwMn
	9+6IgO1jsyoWv9PmM8Bi0+LbhNTaO5Z753+H2RpzTLXSPj7RMnk1MxHv57/4vuaDPMmT
	1Ucdkln1Kjx6wvF4MjJecdmFroB49t4W864HorXQHNg4N4hETcvEroOuRLjW6/uGAsBF
	Dq6PjcaEoRH/JvZ/b/ipy5LhN1VDJk4Q3jJocySbssekVdFGjdSKsX9mLEhQM31mPtlB
	aeQUzGFlyYWWpAAjAwn+LxxAnhZAUjwhit5GMrzoPy778h02ae706e1d3NTulhOwbora
	2YPg==
X-Gm-Message-State: AOAM530xGvZ7XMyZ6kAyo59W42dFDK+HLatimcjXcavaeTao1OjFxb9p
	pfowebOOrSKZ+4ZW2hxfDrQ=
X-Google-Smtp-Source: ABdhPJzScZ4fRkmi0dCDQnj8l0wQKmLngV0DHzmdhA3Y8Ebv0S2d79RUTchGM/20QlCukDc3lvI2PA==
X-Received: by 2002:a37:4816:: with SMTP id v22mr11658697qka.42.1607121463767; 
	Fri, 04 Dec 2020 14:37:43 -0800 (PST)
Received: from localhost (pool-68-160-176-52.bstnma.fios.verizon.net.
	[68.160.176.52]) by smtp.gmail.com with ESMTPSA id
	x24sm5952934qkx.23.2020.12.04.14.37.42
	(version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
	Fri, 04 Dec 2020 14:37:43 -0800 (PST)
Date: Fri, 4 Dec 2020 17:37:42 -0500
From: Mike Snitzer <snitzer@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Message-ID: <20201204223742.GA82260@lobo>
References: <20201204210521.GA3937@redhat.com>
	<160711773655.16738.13830016046956700847.pr-tracker-bot@kernel.org>
MIME-Version: 1.0
In-Reply-To: <160711773655.16738.13830016046956700847.pr-tracker-bot@kernel.org>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.3
X-loop: dm-devel@redhat.com
Cc: axboe@kernel.dk, Nick Desaulniers <ndesaulniers@google.com>,
	linux-block@vger.kernel.org, dm-devel@redhat.com,
	Mikulas Patocka <mpatocka@redhat.com>, vgoyal@redhat.com,
	Sergei Shtepa <sergei.shtepa@veeam.com>,
	Thomas Gleixner <tglx@linutronix.de>, Alasdair G Kergon <agk@redhat.com>
Subject: [dm-devel] [PATCH] block: fix incorrect branching in
 blk_max_size_offset() [was: Re: [git pull] device mapper fixes for
 5.10-rc7]
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
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Fri, Dec 04 2020 at  4:35P -0500,
pr-tracker-bot@kernel.org <pr-tracker-bot@kernel.org> wrote:

> The pull request you sent on Fri, 4 Dec 2020 16:05:21 -0500:
> 
> > git://git.kernel.org/pub/scm/linux/kernel/git/device-mapper/linux-dm.git tags/for-5.10/dm-fixes
> 
> has been merged into torvalds/linux.git:
> https://git.kernel.org/torvalds/c/b3298500b23f0b53a8d81e0d5ad98a29db71f4f0
> 
> Thank you!

Hi Linus,

This is _really_ embarrassing; but I screwed up the branching at the top
of blk_max_size_offset(), here is the fix:

From: Mike Snitzer <snitzer@redhat.com>
Date: Fri, 4 Dec 2020 17:21:03 -0500
Subject: [PATCH] block: fix incorrect branching in blk_max_size_offset()

If non-zero 'chunk_sectors' is passed in to blk_max_size_offset() that
override will be incorrectly ignored.

Old blk_max_size_offset() branching, prior to commit 3ee16db390b4,
must be used only if passed 'chunk_sectors' override is zero.

Fixes: 3ee16db390b4 ("dm: fix IO splitting")
Cc: stable@vger.kernel.org # 5.9
Reported-by: John Dorminy <jdorminy@redhat.com>
Signed-off-by: Mike Snitzer <snitzer@redhat.com>
---
 include/linux/blkdev.h | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index 24ae504cf77d..033eb5f73b65 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -1076,10 +1076,12 @@ static inline unsigned int blk_max_size_offset(struct request_queue *q,
 					       sector_t offset,
 					       unsigned int chunk_sectors)
 {
-	if (!chunk_sectors && q->limits.chunk_sectors)
-		chunk_sectors = q->limits.chunk_sectors;
-	else
-		return q->limits.max_sectors;
+	if (!chunk_sectors) {
+		if (q->limits.chunk_sectors)
+			chunk_sectors = q->limits.chunk_sectors;
+		else
+			return q->limits.max_sectors;
+	}
 
 	if (likely(is_power_of_2(chunk_sectors)))
 		chunk_sectors -= offset & (chunk_sectors - 1);
-- 
2.15.0

--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel

