Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 83D35C05027
	for <dm-devel@archiver.kernel.org>; Fri,  3 Feb 2023 16:40:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1675442414;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=xXNis+k0S+Dp9tIIjcoSi4HIYoi5oksSJEjv3Psq+Ic=;
	b=FlOUuQTxgDwMHH5xLAbaDxJUNkERJ2VfA+XQ1eOMrECfoJSymVSLXsD1H5yWtop/U0HvDI
	1D0m0+cFxYQTdbyZfULn6xEMtQkCxaC+mNzAmwh1gqArrDC6+Oi1vkBQPs16YfZjnrXlZz
	ux88e34hgpmfxnxapIUPN0/Nd8h7e54=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-224-0z3el2OiMwiVHnr7QVgwSw-1; Fri, 03 Feb 2023 11:40:10 -0500
X-MC-Unique: 0z3el2OiMwiVHnr7QVgwSw-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 9C1F7857A81;
	Fri,  3 Feb 2023 16:40:08 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 4C542492B15;
	Fri,  3 Feb 2023 16:40:07 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 3CE6A194658C;
	Fri,  3 Feb 2023 16:40:07 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com
 [10.11.54.7])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id B6CD11946586
 for <dm-devel@listman.corp.redhat.com>; Fri,  3 Feb 2023 16:39:40 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id A71601410F36; Fri,  3 Feb 2023 16:39:40 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast04.extmail.prod.ext.rdu2.redhat.com [10.11.55.20])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 9F370140EBF4
 for <dm-devel@redhat.com>; Fri,  3 Feb 2023 16:39:40 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [207.211.31.81])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 81608101A52E
 for <dm-devel@redhat.com>; Fri,  3 Feb 2023 16:39:40 +0000 (UTC)
Received: from mail-qt1-f169.google.com (mail-qt1-f169.google.com
 [209.85.160.169]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-5-ebgDHbFnOimlFg6q6VEokg-1; Fri, 03 Feb 2023 11:39:38 -0500
X-MC-Unique: ebgDHbFnOimlFg6q6VEokg-1
Received: by mail-qt1-f169.google.com with SMTP id w3so6072715qts.7
 for <dm-devel@redhat.com>; Fri, 03 Feb 2023 08:39:38 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=in-reply-to:content-disposition:mime-version:references:message-id
 :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
 :message-id:reply-to;
 bh=7unWJupLeIDjrGZl3VZgizWn6+wr+P4lFU0CB+KM2WM=;
 b=xHysA+DBm+JIHfKSNI0zSaOyiRGzsmAMTk4sP9MROVJWnnYHHzlAkRTZIYvvMZXrvg
 kT+cRfWrBBuRKkbJ7mpN8kK4AxtCIZGRWNpTTf9bywy5p5itAT0wtwa0sy9adODOFOZP
 l/UBE33F8Nrp8ntOTtUvms0FjBPefefzlAF2ODfNBT2Ga50mkvPc3l0u4ek998QSxM8k
 LuwRSGKehwl4a7RE0yAUXtmPtnOe1cVqSAUqiGr2UCzLdJfsV9FTwZlwecFbyDk4wX1b
 Eo3eIL9Gr8X1Sk4DUJ4swP8vSkFU/dWTbeQhYEoUTNJrrI5QcHZLRZ/3Pi7fD14NoJVu
 Sjmg==
X-Gm-Message-State: AO0yUKUwqnkzZGV1GJgqKAgzbMepoTP5vOu8ikSP+DGufyo1S9sjTGrZ
 HEDCs2ne4HpaibKfzqBq5HM1U8k=
X-Google-Smtp-Source: AK7set8OFXsF0AA97fa7d3weiTcI91kTVTafm0mjUfja5YF8VkQYV4bUyeR8C+B4Abew/VjJFXvb2Q==
X-Received: by 2002:a05:622a:14d4:b0:3b8:41f4:94e7 with SMTP id
 u20-20020a05622a14d400b003b841f494e7mr20101341qtx.17.1675442378102; 
 Fri, 03 Feb 2023 08:39:38 -0800 (PST)
Received: from localhost (pool-68-160-166-30.bstnma.fios.verizon.net.
 [68.160.166.30]) by smtp.gmail.com with ESMTPSA id
 s16-20020a05622a179000b003b8391b7736sm1914669qtk.25.2023.02.03.08.39.37
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Fri, 03 Feb 2023 08:39:37 -0800 (PST)
Date: Fri, 3 Feb 2023 11:39:36 -0500
From: Mike Snitzer <snitzer@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Message-ID: <Y904yA+mS9go9XKP@redhat.com>
References: <20230202181423.2910619-1-hch@lst.de> <Y9xqvF6nTptzHwpv@redhat.com>
 <Y9x8pagVnO7Xtnbn@redhat.com> <20230203150053.GA28516@lst.de>
MIME-Version: 1.0
In-Reply-To: <20230203150053.GA28516@lst.de>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.7
Subject: Re: [dm-devel] block: remove submit_bio_noacct
X-BeenThere: dm-devel@redhat.com
X-Mailman-Version: 2.1.29
Precedence: list
List-Id: device-mapper development <dm-devel.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/dm-devel>,
 <mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <http://listman.redhat.com/archives/dm-devel/>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/dm-devel>,
 <mailto:dm-devel-request@redhat.com?subject=subscribe>
Cc: axboe@kernel.dk, linux-block@vger.kernel.org, dm-devel@redhat.com,
 linux-raid@vger.kernel.org
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.10
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Fri, Feb 03 2023 at 10:00P -0500,
Christoph Hellwig <hch@lst.de> wrote:

> On Thu, Feb 02, 2023 at 10:16:53PM -0500, Mike Snitzer wrote:
> > > > The current usage of submit_bio vs submit_bio_noacct which skips the
> > > > VM events and task account is a bit unclear.  It seems to be mostly
> > > > intended for sending on bios received by stacking drivers, but also
> > > > seems to be used for stacking drivers newly generated metadata
> > > > sometimes.
> > > 
> > > Your lack of confidence conveyed in the above shook me a little bit
> > > considering so much of this code is attributed to you -- I mostly got
> > > past that, but I am a bit concerned about one aspect of the
> > > submit_bio() change (2nd to last comment inlined below).
> 
> The confidence is about how it is used.  And that's up to the driver
> authors, not helped by them not having any guidelines.  And while
> I've touched this code a lot, the split between the two levels of API
> long predates me.
> 
> > > > Remove the separate API and just skip the accounting if submit_bio
> > > > is called recursively.  This gets us an accounting behavior that
> > > > is very similar (but not quite identical) to the current one, while
> > > > simplifying the API and code base.
> > > 
> > > Can you elaborate on the "but not quite identical"? This patch is
> > > pretty mechanical, just folding code and renaming.. but you obviously
> > > saw subtle differences.  Likely worth callign those out precisely.
> 
> The explanation was supposed to be in the Lines above.  Now accounting
> is skipped if in a ->submit_bio recursion.  Before that it dependent
> on drivers calling either submit_bio or submit_bio_noacct, for which
> there was no clear guideline and drivers have been a bit sloppy about.

OK, but afaict the code is identical after your refactoring.
Side-effect is drivers that were double accounting will now be fixed.
 
> > > 
> > > How have you tested this patch?  Seems like I should throw all the lvm
> > > and DM tests at it.
> 
> blktests and the mdadm tests (at least as far as they got upstream, md
> or it's tests always seem somewhat broken).  dmtests is something
> I've never managed to get to actually run due it's insistence on
> using not packaged ruby stuff.

Yeah, device-mapper-test-suite (dmts) is a PITA due to ruby dep. And
the tests have gotten a bit stale relative to recent kernels. I'm
aware of this and also about how others would like to see more DM
coverage in blktests. We'll be looking to improve DM testing but it
does always tend to get put on back-burner (but I'll be getting some
help from Ben Marzinski to assess what tests we do have, see where we
have gaps and also put effort to making DM testing part of blktests).

I'm actually now pretty interested to see which (if any) DM tests
would have caught the missing bio checks issue in your initial patch.
 
> > > In practice this will manifest as delaying the negative checks, until
> > > returning from active submit_bio, but they will still happen.
> > 
> > Actually, I don't think those checks are done at all now.
> 
> Yes, the branch needs to be later as in this version below.

Thanks.

> > Unless I'm missing something, this seems like it needs proper
> > justification and a lot of review and testing.
> > 
> > So why do this change?
> 
> Because I once again got a question from an auther of a driver that
> is planned to be upstreamed on which one to use.  And the answer
> was it's complicated, and you really should not have to think about
> it, let me dig out my old patch so that driver authors don't have
> to care.

That's fair, and as I tried to say in my first reply: I agree it does
clear up that confusion nicely.

Please fold this incremental patch in, with that you can add:

Reviewed-by: Mike Snitzer <snitzer@kernel.org>
Signed-off-by: Mike Snitzer <snitzer@kernel.org>

(not sure if my Signed-off-by needed but there you have it if so).

diff --git a/block/bio.c b/block/bio.c
index ea143fd825d7..aa0586012b0d 100644
--- a/block/bio.c
+++ b/block/bio.c
@@ -475,7 +475,7 @@ static struct bio *bio_alloc_percpu_cache(struct block_device *bdev,
  *
  * Note that when running under submit_bio() (i.e. any block driver),
  * bios are not submitted until after you return - see the code in
- * submit_bio() that converts recursion into iteration, to prevent
+ * submit_bio_nocheck() that converts recursion into iteration, to prevent
  * stack overflows.
  *
  * This would normally mean allocating multiple bios under submit_bio()
diff --git a/block/blk-core.c b/block/blk-core.c
index f755ac1a2931..c41f086cb183 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -687,7 +687,7 @@ void submit_bio_nocheck(struct bio *bio)
 	/*
 	 * We only want one ->submit_bio to be active at a time, else stack
 	 * usage with stacked devices could be a problem.  Use current->bio_list
-	 * to collect a list of requests submited by a ->submit_bio method while
+	 * to collect a list of requests submitted by a ->submit_bio method while
 	 * it is active, and then process them after it returned.
 	 */
 	if (current->bio_list)
@@ -720,13 +720,13 @@ void submit_bio(struct bio *bio)
 
 	might_sleep();
 
-	if (blkcg_punt_bio_submit(bio))
-		return;
-
 	/*
 	 * Do not double account bios that are remapped and resubmitted.
 	 */
 	if (!current->bio_list) {
+		if (blkcg_punt_bio_submit(bio))
+			return;
+
 		if (bio_op(bio) == REQ_OP_READ) {
 			task_io_account_read(bio->bi_iter.bi_size);
 			count_vm_events(PGPGIN, bio_sectors(bio));

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

