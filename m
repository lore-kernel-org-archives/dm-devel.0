Return-Path: <SRS0=/g2B=HM=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 61F2AC433DB
	for <dm-devel@archiver.kernel.org>; Wed, 10 Feb 2021 18:49:03 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id DB29C64E26
	for <dm-devel@archiver.kernel.org>; Wed, 10 Feb 2021 18:49:02 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org DB29C64E26
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1612982941;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=pgZxiyZ71uDNG2kGKiVpf83eDHmEhpkNFRUUtJKiYe8=;
	b=WwHU1tNkXKoRaE4sh+JU/C7s2kJ/6fVfczcfidiIMEV1qE5V1KcQkmtIWpyW7oX8a8q8kn
	s+gxo/m68wFU34TQh6rKXXu6ZuMvYc/1YuWlpAxFxa1ptnrI6uwRIQfURQ4YziVz3/gl9I
	g4aLMAhKXKbFP9vtOP+FIy+rWQdOfEs=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-211-8IWEnS8fMXuqQLnZHnsvVQ-1; Wed, 10 Feb 2021 13:48:59 -0500
X-MC-Unique: 8IWEnS8fMXuqQLnZHnsvVQ-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id C44AF1936B69;
	Wed, 10 Feb 2021 18:48:53 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 9AA1219809;
	Wed, 10 Feb 2021 18:48:53 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 398AD18095C9;
	Wed, 10 Feb 2021 18:48:53 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
	[10.11.54.5])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 11AImptI032207 for <dm-devel@listman.util.phx.redhat.com>;
	Wed, 10 Feb 2021 13:48:51 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id E0796EAF92; Wed, 10 Feb 2021 18:48:50 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast04.extmail.prod.ext.rdu2.redhat.com [10.11.55.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id DB234ED15D
	for <dm-devel@redhat.com>; Wed, 10 Feb 2021 18:48:48 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[207.211.31.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 9D8B8101A53A
	for <dm-devel@redhat.com>; Wed, 10 Feb 2021 18:48:48 +0000 (UTC)
Received: from mail-qk1-f173.google.com (mail-qk1-f173.google.com
	[209.85.222.173]) (Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-403-_tHYcBQMMTani0ty3L6o6g-1; Wed, 10 Feb 2021 13:48:44 -0500
X-MC-Unique: _tHYcBQMMTani0ty3L6o6g-1
Received: by mail-qk1-f173.google.com with SMTP id t63so2713358qkc.1;
	Wed, 10 Feb 2021 10:48:44 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=1e100.net; s=20161025;
	h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
	:references:mime-version:content-disposition:in-reply-to;
	bh=Ao3wY8+fOOb7xqabTB1quMITdoXuuKn4x/hiLYN+Iv4=;
	b=oLDBrk0/FpYixBQSztps65lVAf7IZ66yUdkiC1ygF9P/2DrW+JweEKzVmQ1OmhW290
	WX24ZHoEF6PWRmaL00X/RWNPxuDHRt66MCc411ZaskvPmyG3P4K0WGhRb8irtxLZE8Hu
	vphXxhSS5qpnCrLQOiNgB97Fnqpeg2lvYFXWyBrn0aqN5fLogHgXi3riWroHlEcSbq52
	cOjSf3yqPwsoGHyxBehyN6xXJDgxXsHtYnTQeOWUbqXJnAvNBsQaUTGOShdoIAl3lzgh
	KJnGXgS2GIVWbUvI4TWCzIeeG7XfKanpHrPWwIRsKzYQQHGdjO9btCINID0oxGXzrY5/
	X52Q==
X-Gm-Message-State: AOAM530jAm3xrhnNxpajZBExkmogsQR0wrNwxP3HqjjjsOhE6Zp3AgzI
	7ZQ1JbafMP2sH0t7MeiTtPfG5uVyuB963Q==
X-Google-Smtp-Source: ABdhPJyEehPEZh0rQA3Zg7GNpL0wxIYUZPAaGIwf37KB4xd0SLCNL+KEPTCHO56x0QM3IkYwRghMmQ==
X-Received: by 2002:a05:620a:2041:: with SMTP id
	d1mr4675671qka.326.1612982923618; 
	Wed, 10 Feb 2021 10:48:43 -0800 (PST)
Received: from localhost (pool-68-160-176-52.bstnma.fios.verizon.net.
	[68.160.176.52]) by smtp.gmail.com with ESMTPSA id
	d22sm1840126qtp.34.2021.02.10.10.48.42
	(version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
	Wed, 10 Feb 2021 10:48:42 -0800 (PST)
Date: Wed, 10 Feb 2021 13:48:42 -0500
From: Mike Snitzer <snitzer@redhat.com>
To: Nikos Tsironis <ntsironis@arrikto.com>
Message-ID: <20210210184842.GA6689@lobo>
References: <20210122152556.24822-1-ntsironis@arrikto.com>
	<20210122152556.24822-5-ntsironis@arrikto.com>
	<20210210181205.GA7904@redhat.com>
MIME-Version: 1.0
In-Reply-To: <20210210181205.GA7904@redhat.com>
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
Cc: dm-devel@redhat.com, ejt@redhat.com, agk@redhat.com
Subject: Re: [dm-devel] [PATCH 4/4] dm era: Remove unreachable resize
 operation in pre-resume function
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Wed, Feb 10 2021 at  1:12P -0500,
Mike Snitzer <snitzer@redhat.com> wrote:

> On Fri, Jan 22 2021 at 10:25am -0500,
> Nikos Tsironis <ntsironis@arrikto.com> wrote:
> 
> > The device metadata are resized in era_ctr(), so the metadata resize
> > operation in era_preresume() never runs.
> > 
> > Also, note, that if the operation did ever run it would deadlock, since
> > the worker has not been started at this point.

It wouldn't have deadlocked, it'd have queued the work (see wake_worker)

> > 
> > Fixes: eec40579d84873 ("dm: add era target")
> > Cc: stable@vger.kernel.org # v3.15+
> > Signed-off-by: Nikos Tsironis <ntsironis@arrikto.com>
> > ---
> >  drivers/md/dm-era-target.c | 9 ---------
> >  1 file changed, 9 deletions(-)
> > 
> > diff --git a/drivers/md/dm-era-target.c b/drivers/md/dm-era-target.c
> > index 104fb110cd4e..c40e132e50cd 100644
> > --- a/drivers/md/dm-era-target.c
> > +++ b/drivers/md/dm-era-target.c
> > @@ -1567,15 +1567,6 @@ static int era_preresume(struct dm_target *ti)
> >  {
> >  	int r;
> >  	struct era *era = ti->private;
> > -	dm_block_t new_size = calc_nr_blocks(era);
> > -
> > -	if (era->nr_blocks != new_size) {
> > -		r = in_worker1(era, metadata_resize, &new_size);
> > -		if (r)
> > -			return r;
> > -
> > -		era->nr_blocks = new_size;
> > -	}
> >  
> >  	start_worker(era);
> >  
> > -- 
> > 2.11.0
> > 
> 
> Resize shouldn't actually happen in the ctr.  The ctr loads a temporary
> (inactive) table that will only become active upon resume.  That is why
> resize should always be done in terms of resume.
> 
> I'll look closer but ctr shouldn't do the actual resize, and the
> start_worker() should be moved above the resize code you've removed
> above.

Does this work for you?  If so I'll get it staged (like I've just
staged all your other dm-era fixes for 5.12).

 drivers/md/dm-era-target.c | 13 ++-----------
 1 file changed, 2 insertions(+), 11 deletions(-)

diff --git a/drivers/md/dm-era-target.c b/drivers/md/dm-era-target.c
index d0e75fd31c1e..ec198e9cdafb 100644
--- a/drivers/md/dm-era-target.c
+++ b/drivers/md/dm-era-target.c
@@ -1501,15 +1501,6 @@ static int era_ctr(struct dm_target *ti, unsigned argc, char **argv)
 	}
 	era->md = md;
 
-	era->nr_blocks = calc_nr_blocks(era);
-
-	r = metadata_resize(era->md, &era->nr_blocks);
-	if (r) {
-		ti->error = "couldn't resize metadata";
-		era_destroy(era);
-		return -ENOMEM;
-	}
-
 	era->wq = alloc_ordered_workqueue("dm-" DM_MSG_PREFIX, WQ_MEM_RECLAIM);
 	if (!era->wq) {
 		ti->error = "could not create workqueue for metadata object";
@@ -1583,6 +1574,8 @@ static int era_preresume(struct dm_target *ti)
 	struct era *era = ti->private;
 	dm_block_t new_size = calc_nr_blocks(era);
 
+	start_worker(era);
+
 	if (era->nr_blocks != new_size) {
 		r = in_worker1(era, metadata_resize, &new_size);
 		if (r)
@@ -1591,8 +1584,6 @@ static int era_preresume(struct dm_target *ti)
 		era->nr_blocks = new_size;
 	}
 
-	start_worker(era);
-
 	r = in_worker0(era, metadata_era_rollover);
 	if (r) {
 		DMERR("%s: metadata_era_rollover failed", __func__);

--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel

