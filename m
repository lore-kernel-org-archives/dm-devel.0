Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 704F43603EB
	for <dm-devel@lists.linux.dev>; Fri, 13 Mar 2026 14:36:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773412569; cv=none; b=aQy4TjLliRFfoXX9y4k39GdHXnp3ocsFYcFD9qJD7z6GJf1EgSER3traXhSqBum/c93NnFuytYGxxPPB7NfBwjKpNGs0rPBgo/cYyaUvellz5p3+jzd9udVesGLDtIISbEaiHhYcuGpfXg0u8elZmDwujj6TVFCmGwnZERDtJCM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773412569; c=relaxed/simple;
	bh=ufun1Wcths+rb07VUe3k8d704B6RETyuxyIo09gQ9pQ=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=CKirTBntQD2Txlc5KKjibXF7OQ15mgoYfaQ3OrUCg0prGuGKZ0wZNjSs3KBW5T2MicobA6M1wVk7KkxpA0ITjZqssD9FQSnIV06ghpwqgtw3eZ2rJIWeNjj+I4aVWx84UTN+em8y+bAASnszx+rXrzJXiDqNax9jevZFkaBwhqs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Y6ZXGJTi; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Y6ZXGJTi"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1773412567;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=bJMneynKGatLodHqYQuBMM3+if+Rl1AvLNuNJYWpNo0=;
	b=Y6ZXGJTi753gPM/nt0f6JeBWBlrzyg1lHgAMsAqF0v7Sta55Lk8e6juo0cVe05CGr8Uvgl
	QnoWefYh8y8bcnXi7STTlt1Lt54N+7s8z2F0ZeIyl1GwY0XhsJryiivKcb7IjuSvUodyOR
	ZKXse1NAlIHbJ+/RzUGD3844KYxCvNk=
Received: from mail-yw1-f200.google.com (mail-yw1-f200.google.com
 [209.85.128.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-569-mtQRiK5sNga5vl6iHuDBgg-1; Fri, 13 Mar 2026 10:36:06 -0400
X-MC-Unique: mtQRiK5sNga5vl6iHuDBgg-1
X-Mimecast-MFC-AGG-ID: mtQRiK5sNga5vl6iHuDBgg_1773412565
Received: by mail-yw1-f200.google.com with SMTP id 00721157ae682-7987281c3cdso23783667b3.2
        for <dm-devel@lists.linux.dev>; Fri, 13 Mar 2026 07:36:06 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773412565; x=1774017365;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=bJMneynKGatLodHqYQuBMM3+if+Rl1AvLNuNJYWpNo0=;
        b=UGq2oeMqiulaGenhirSEabPT8Alc1UiVmq96romZAJJHsGpmW9E2Rq+4wM9eqxdrw5
         hKbdEJ1cNkmVoZrLoZ6Vb3lMwy+7E3TY/ISm/r5xadgc9p0GDJTBvi7HlFGHIks7YRVb
         zVRDeFCpS3wacPRFz045gcn00+XI+3YfIhSGac1PgTnDiJ5s6/tcP9elKOLUCkUmynUE
         ooCcSUsIwVe970iMh4wCouL33PydUn2nlH1Qfs5MlB7q0afQ7LxG1ktBWZA2CAeU840Z
         5B2iGVBzIVikwV8ZYyuqrKeJvHbsICVgbwfRGtVBdg5VZ98S88oZx/mWIroV/H+kT12Z
         SBnQ==
X-Forwarded-Encrypted: i=1; AJvYcCVu8fty0bjc9Au1DxAsQeCqlKHpiXXURsfqqmRNm4gSQin32r4tuRvigER1tPw/RHPI2iLgIIVXFQ==@lists.linux.dev
X-Gm-Message-State: AOJu0YwRhbM+lfxMznefZgrBwUoKfKTLQ7EFud/aJnMsMydtFMIgvc2M
	o+ZE6QVuhIK5Sj+HdPp60mPqdIskIfKmjRKLcM/TLmyP+FIYyAObtujXVoRIhi6/dA6tk4qKSm5
	tJsqfDLqRE5FXQ3Ie26hFzJT6XUbNk1Mvc2o8e0+0mfpOhO/vW+tSi/qIQI2kelyLFRYuV42rNC
	Q3yEiX/zdo/tkLUQ/IiE5C+Ptyl7qERb/7rLY=
X-Gm-Gg: ATEYQzwJEf639fGknQPenJXJLTDl4hTB19sDeXP5WFVSSYOVCBr9x/6YK7shfoiOCot
	SmKdlyEVqS8/NnV1orYcCdLaZPLbGOaUJYzQOvEipkmgG4T6UoCJSpbPb8Ad0Zxz+NlyuTqKOSn
	c07HvDkMexjAa9QxTakdFea6jXr3H3B4q9EM91TPu8CRFFPLYVYhwtafw2WCAeuxt0oRXl5cxQH
	IIKv5AotEo7k6Tt9cbdtBkF63ZabvSexAvQhfxPxdYnf+bgJB9HZhbnZ7zJXUm7hA==
X-Received: by 2002:a05:690c:c1d5:b0:798:711f:a0a5 with SMTP id 00721157ae682-79a1c10febemr31150437b3.29.1773412565245;
        Fri, 13 Mar 2026 07:36:05 -0700 (PDT)
X-Received: by 2002:a05:690c:c1d5:b0:798:711f:a0a5 with SMTP id
 00721157ae682-79a1c10febemr31150237b3.29.1773412564819; Fri, 13 Mar 2026
 07:36:04 -0700 (PDT)
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260304190424.291743-1-agruenba@redhat.com> <abQHNzJ0FR1EF0NX@shinmob>
In-Reply-To: <abQHNzJ0FR1EF0NX@shinmob>
From: Andreas Gruenbacher <agruenba@redhat.com>
Date: Fri, 13 Mar 2026 15:35:53 +0100
X-Gm-Features: AaiRm50KyYlBUXDBLdnEEHXDx37wzlGjPP-UmRDDKX74QQoo2rYJKifETYROgh4
Message-ID: <CAHc6FU7bab0+snOVBog-FZkn_sy3AHoEP2SNFxdZ-n13tAE5Ng@mail.gmail.com>
Subject: Re: [PATCH 0/4] simple bio cleanups
To: Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Cc: Jens Axboe <axboe@kernel.dk>, 
	"linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, 
	"drbd-dev@lists.linbit.com" <drbd-dev@lists.linbit.com>, 
	"linux-bcache@vger.kernel.org" <linux-bcache@vger.kernel.org>, 
	"dm-devel@lists.linux.dev" <dm-devel@lists.linux.dev>, 
	"linux-f2fs-devel@lists.sourceforge.net" <linux-f2fs-devel@lists.sourceforge.net>, 
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: 7rdH1SegTvfAsueV6rU2yq_xi3a0MVV2ue2MUvmjMJo_1773412565
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Mar 13, 2026 at 1:54=E2=80=AFPM Shinichiro Kawasaki
<shinichiro.kawasaki@wdc.com> wrote:
> On Mar 04, 2026 / 20:04, Andreas Gruenbacher wrote:
> > Jens,
> >
> > here are some simple bio related cleanups.  Any thoughts?  Can those go
> > in via your tree?
> >
> > Thanks,
> > Andreas
> >
> > Andreas Gruenbacher (4):
> >   block: consecutive blk_status_t error codes
> >   block: get rid of blk_status_to_{errno,str} inconsistency
> >   bio: rename bio_chain arguments
> >   bio: use bio_io_error more often
>
> Hello Andreas, during blktests CI trial runs, I noticed that this patch s=
eries
> triggered failures of three blktests test cases: scsi/004, scsi/007 and
> throtl/004. Do you see which patch triggered these failures?

Hello Shinichiro,

thanks a lot for the report. I now see that patch "block: get rid of
blk_status_to_{errno,str} inconsistency" is broken in its current
form.

Andreas

>
>
> scsi/004 (ensure repeated TASK SET FULL results in EIO on timing out comm=
and) [failed]
>     runtime    ...  3.855s
>     --- tests/scsi/004.out      2026-03-12 15:23:54.664435639 +0000
>     +++ /home/fedora/blktests/results/nodev/scsi/004.out.bad    2026-03-1=
2 18:13:40.059747989 +0000
>     @@ -1,3 +1,2 @@
>      Running scsi/004
>     -Input/output error
>      Test complete
>
> scsi/007 (Trigger the SCSI error handler)                    [failed]
>     runtime    ...  115.385s
>     --- tests/scsi/007.out      2026-03-12 15:23:54.668435644 +0000
>     +++ /home/fedora/blktests/results/nodev/scsi/007.out.bad    2026-03-1=
2 18:15:55.054944537 +0000
>     @@ -1,3 +1,3 @@
>      Running scsi/007
>     -Reading from scsi_debug failed
>     +Reading from scsi_debug succeeded
>      Test complete
>
> throtl/004 (nullb) (delete disk while IO is throttled)       [failed]
>     runtime    ...  1.643s
>     --- tests/throtl/004.out    2026-03-12 15:23:54.710435695 +0000
>     +++ /home/fedora/blktests/results/nodev_nullb/throtl/004.out.bad    2=
026-03-12 18:20:46.314368581 +0000
>     @@ -1,3 +1,2 @@
>      Running throtl/004
>     -Input/output error
>      Test complete
>

