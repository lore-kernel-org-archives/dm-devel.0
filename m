Return-Path: <SRS0=D9Ri=FI=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A4519C433FE
	for <dm-devel@archiver.kernel.org>; Fri,  4 Dec 2020 23:03:47 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [63.128.21.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 1CD8D22C9E
	for <dm-devel@archiver.kernel.org>; Fri,  4 Dec 2020 23:03:46 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 1CD8D22C9E
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-536-NwaLK7F2NSC_dRfx5QNm-g-1; Fri, 04 Dec 2020 18:03:43 -0500
X-MC-Unique: NwaLK7F2NSC_dRfx5QNm-g-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 6F0A5858180;
	Fri,  4 Dec 2020 23:03:38 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 0953E60C04;
	Fri,  4 Dec 2020 23:03:38 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 7855B180954D;
	Fri,  4 Dec 2020 23:03:36 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
	[10.11.54.4])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 0B4N3YMR016310 for <dm-devel@listman.util.phx.redhat.com>;
	Fri, 4 Dec 2020 18:03:34 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 0257B2026611; Fri,  4 Dec 2020 23:03:34 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast06.extmail.prod.ext.rdu2.redhat.com [10.11.55.22])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id F2282200AD4D
	for <dm-devel@redhat.com>; Fri,  4 Dec 2020 23:03:31 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [205.139.110.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id AFBE2185A794
	for <dm-devel@redhat.com>; Fri,  4 Dec 2020 23:03:31 +0000 (UTC)
Received: from mail-ua1-f66.google.com (mail-ua1-f66.google.com
	[209.85.222.66]) (Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-6-xeKC36yfOiWhzmlL-ZSsNA-1; Fri, 04 Dec 2020 18:03:27 -0500
X-MC-Unique: xeKC36yfOiWhzmlL-ZSsNA-1
Received: by mail-ua1-f66.google.com with SMTP id n18so2412334ual.9
	for <dm-devel@redhat.com>; Fri, 04 Dec 2020 15:03:26 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=1e100.net; s=20161025;
	h=x-gm-message-state:mime-version:references:in-reply-to:from:date
	:message-id:subject:to:cc;
	bh=ajNBuI58XCJeYzgWulSyNWGBrGqQy7dypnvZGeNu7cc=;
	b=HPIsRxpSCx+VPZd/4dgFZGqY2HIWCi92D44xxYAKGfeBBUym15rkAaFq9A7X4Y0sv/
	RzipnObZqBbf0+I0qEQM0t5G4Nim6MuYDDBb2RM13PElyVQCE0IgKZuAR4rmwC6szqrc
	qNwjoM4b1zWieLAjSp6o0vERvlKIoJ1igIRwiv2kfUB3yHi8Wd5Tghtk4ipE2houKJ4B
	xcFRz1CTT5Q10IGP82NtJEMJW79L3QC+EhJWZn+uOjozefyVSxyJM5ueRdEgJ3tIfPgh
	mxUwNwoWIDnBUgv9i2FwvlckAf7/2SyVC1zVaNxUBCVqJAZMwle5bzgcElo72JJpeiGw
	Aekg==
X-Gm-Message-State: AOAM531cox03a9h9SNiDTKQ06a6mF3heyF3dGMfUZuxbOoLys+WV1fDg
	TIcu54G2L9bVaY6IdXb8GKKsBiOsoeDWoxx0du42wDEVIzw=
X-Google-Smtp-Source: ABdhPJzYbwso0uzukuujleOx4Fvz9P7QA4bmd1f4Cy004Qh/2pK4gswT5b70ojrKvzXADqZxaWeuKS+szzOjdw4pbQM=
X-Received: by 2002:ab0:b15:: with SMTP id b21mr5948976uak.52.1607123006214;
	Fri, 04 Dec 2020 15:03:26 -0800 (PST)
MIME-Version: 1.0
References: <20201203004659.95708-1-hyeongseok@gmail.com>
	<CABCJKufCS+hbXkGyO9uU3EBscfCpU1f7pi77uzR_+cjo97g=YQ@mail.gmail.com>
	<1939b1ec-b605-8a1a-8ff9-e50c36d60f66@gmail.com>
In-Reply-To: <1939b1ec-b605-8a1a-8ff9-e50c36d60f66@gmail.com>
From: Sami Tolvanen <samitolvanen@google.com>
Date: Fri, 4 Dec 2020 15:03:15 -0800
Message-ID: <CABCJKueAPHNqdq=k6AhhxDR-oQdNs8+=BhmY8wGdgNcwr_-KMQ@mail.gmail.com>
To: hyeongseok <hyeongseok@gmail.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.4
X-loop: dm-devel@redhat.com
Cc: device-mapper development <dm-devel@redhat.com>,
	=?UTF-8?B?6rmA7ZiV7ISd?= <hyeongseok.kim@lge.com>,
	Mike Snitzer <snitzer@redhat.com>, Alasdair Kergon <agk@redhat.com>
Subject: Re: [dm-devel] [PATCH] dm verity: skip verity work on I/O errors
 when system is shutting down
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Thu, Dec 3, 2020 at 3:46 PM hyeongseok <hyeongseok@gmail.com> wrote:
>
> On 12/4/20 2:22 AM, Sami Tolvanen wrote:
> > Hi,
> >
> > On Wed, Dec 2, 2020 at 4:48 PM Hyeongseok Kim <hyeongseok@gmail.com> wrote:
> >> If emergency system shutdown is called, like by thermal shutdown,
> >> dm device could be alive when the block device couldn't process
> >> I/O requests anymore. In this status, the handling of I/O errors
> >> by new dm I/O requests or by those already in-flight can lead to
> >> a verity corruption state, which is misjudgment.
> >> So, skip verity work for I/O error when system is shutting down.
> > Thank you for the patch. I agree that attempting to correct I/O errors
> > when the system is shutting down, and thus generating more I/O that's
> > likely going to fail, is not a good idea.
> >
> >> Signed-off-by: Hyeongseok Kim <hyeongseok@gmail.com>
> >> ---
> >>   drivers/md/dm-verity-target.c | 12 +++++++++++-
> >>   1 file changed, 11 insertions(+), 1 deletion(-)
> >>
> >> diff --git a/drivers/md/dm-verity-target.c b/drivers/md/dm-verity-target.c
> >> index f74982dcbea0..ba62c537798b 100644
> >> --- a/drivers/md/dm-verity-target.c
> >> +++ b/drivers/md/dm-verity-target.c
> >> @@ -64,6 +64,15 @@ struct buffer_aux {
> >>          int hash_verified;
> >>   };
> >>
> >> +/*
> >> + * While system shutdown, skip verity work for I/O error.
> >> + */
> >> +static inline bool verity_is_system_shutting_down(void)
> >> +{
> >> +       return system_state == SYSTEM_HALT || system_state == SYSTEM_POWER_OFF
> >> +               || system_state == SYSTEM_RESTART;
> >> +}
> > Which of these states does the system get to during an emergency
> > shutdown? Can we simplify this by changing the test to system_state >
> > SYSTEM_RUNNING?
>
> I only saw that it was SYSTEM_POWER_OFF or SYSTEM_RESTART, I wonder if
> I/O error can occur in SYSTEM_SUSPEND state.

OK, so think the current version is fine then.

> As far as I know, this could be happen in emergency shutdown case,
> can you explain if you have a case when I/O error can occur by
> SYSTEM_SUSPEND?

No, I don't have a case where that would happen.

> > Otherwise, this looks good to me. However, I'm now wondering if an I/O
> > error should ever result in verity_handle_err() being called. Without
> > FEC, dm-verity won't call verity_handle_err() when I/O fails, but with
> > FEC enabled, it currently does, assuming error correction fails. Any
> > thoughts?
>
> Yes, I have thought about this, and to be honest, I think verity or FEC
> should not call verity_handle_error() in case of I/O errors.

I tend to agree. We could simply check the original bio->bi_status in
verity_verify_io() and if we failed to correct an I/O error, return an
error instead of going into verity_handle_err(). Any thoughts?

> But, because I couldn't know the ability of FEC, I only focused on not
> breaking curent logics other than system shutdown && I/O errors case.

Sure, makes sense. We can address that separately.

Reviewed-by: Sami Tolvanen <samitolvanen@google.com>

Sami

--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel

