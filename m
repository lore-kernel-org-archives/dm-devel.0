Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 379CA3B798
	for <dm-devel@lists.linux.dev>; Fri,  1 Mar 2024 02:23:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709259794; cv=none; b=R6VWCMsMUQsFA5TlCJu5ktMGFCKqXmt6TC9LVAI6cRDVrjGzAgR0fzPl8rpoCGAFZt4dZBFe85joHNeqYsr0VTlslg9gqHeKRZazLX6sX3IEoueOM6V+E/IBOC8GekgW2oNWDLySEnR+D7W9N1egOEQcLdZJN4+rAl//Peqqcl8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709259794; c=relaxed/simple;
	bh=lxA9E/HgL3rWHrL/zgR0PQeEP3/EVV9QcLUKdWql9NE=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Skw5D1mb9Ee/XOyDr2qNHtWU7m6V3QWnugoIupVhGjMkCYrRFH/LpNbzve/lNFE0/PL9iAqJqSTzrUYLNPEDoS+lDpiyRAWWovQMPMgbXlM/lDeKfqVJwj2tQ8z0qGIFmQyRMbQ8FS2nSlSUorzi/3kwh9DIfdFKvLJ5qDmo6Dw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=KdzyTdMN; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="KdzyTdMN"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1709259792;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=kh8iC3sudEtLxx4ofyHk4pRU3TqhlCi6raTs/IKSgd4=;
	b=KdzyTdMNwyTmY9qZYaafDLUp8n8J0L9qthprKXKuSLrdZO9gA+ke1f5odximjls3FyFpFj
	wX9M20VUlbCCmEfQR22TQWmIk54CaS0dcH3caPDTGXzRaKDsI5HzSaTJyzc+B6stv51npa
	liXdctBljEysL3rJ7yhyB17EBBPJ9Aw=
Received: from mail-pg1-f199.google.com (mail-pg1-f199.google.com
 [209.85.215.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-10-1gSvdCZiNo-m0Z_NPABN-Q-1; Thu, 29 Feb 2024 21:23:09 -0500
X-MC-Unique: 1gSvdCZiNo-m0Z_NPABN-Q-1
Received: by mail-pg1-f199.google.com with SMTP id 41be03b00d2f7-5d8bdadc79cso1397474a12.2
        for <dm-devel@lists.linux.dev>; Thu, 29 Feb 2024 18:23:08 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709259788; x=1709864588;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=kh8iC3sudEtLxx4ofyHk4pRU3TqhlCi6raTs/IKSgd4=;
        b=ISYYZGP5N9ET5p3hI13onZMSyTfaN3gofhGmFkxpZMpfbtiQrYRA5dSM5m+2pseFKg
         lsgNaQnFOdu1HkbZ5lVft3WFlENDFLEP9OtCh96VMLiSoOpfIyNzlow1QuDIAXKbFvFJ
         nIT0sdhaLSzLCl1q6OH/JR6WS+LXyDke3KOA0fA5PuLn1riuMVcUk1PtWLduhKDKz6Rj
         lMu2LvZzyD/+PYc+GDsnBAjH1jFV9f6wm4llc3o53/WFOmRbLP7zDlqw+PfxuvKmFRYn
         UFKq7//V56apJ9VBIdCS/wO/HmvJo43RsyIrneDZV+Ju1WhpA8sWq9XUfw5eKNezuq9y
         pcYg==
X-Forwarded-Encrypted: i=1; AJvYcCUH2SzrgOg13DJvMTdFaJic5/9HcTDDDiWXkUUYGE/52km/LKLAgaOckG48KBsz1WEheJsQYcmHskC4HVemBv2cTLol2C/JQ2E=
X-Gm-Message-State: AOJu0YwGvhmJfT4VwrvRkLr8mDdP3LlJAR5IH4j0iwIfRsGv9JLCAO1D
	CqG6LKKaIrAUVoHsr7lJ77718Aq6WvK2aCyUQeDRAmMZ06aJT844wrRdZqUGXfCu39q9gzDH6ES
	Tnbaj4vc7jSbzPUbuf7pejHMOZ2nDARcCnuIIRUVamnM/DZPTyINQoBVhfAMtzajOP4crmySG8l
	dbdnsOf3LwfBfKW2EknIXJy4DvemiBaek=
X-Received: by 2002:a05:6a20:6a24:b0:1a1:ebd:12a9 with SMTP id p36-20020a056a206a2400b001a10ebd12a9mr309385pzk.1.1709259787841;
        Thu, 29 Feb 2024 18:23:07 -0800 (PST)
X-Google-Smtp-Source: AGHT+IGV1m3kPMLYZ4ZKss1QBj9EApP9ScCT9i83zKFGi6wjop9Qoe0ynTzKGRNffV4RD/OD9izhJh+gN8Zku9YqLPM=
X-Received: by 2002:a05:6a20:6a24:b0:1a1:ebd:12a9 with SMTP id
 p36-20020a056a206a2400b001a10ebd12a9mr309367pzk.1.1709259787590; Thu, 29 Feb
 2024 18:23:07 -0800 (PST)
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240229154941.99557-1-xni@redhat.com> <e884fd5d-aec2-f2f2-6b22-583576d3106f@huaweicloud.com>
In-Reply-To: <e884fd5d-aec2-f2f2-6b22-583576d3106f@huaweicloud.com>
From: Xiao Ni <xni@redhat.com>
Date: Fri, 1 Mar 2024 10:22:56 +0800
Message-ID: <CALTww29H+tcXtdowb1P3TjCBs5t=9M1M-R39NR6U-frb9RK+GQ@mail.gmail.com>
Subject: Re: [PATCH 0/6] Fix dmraid regression bugs
To: Yu Kuai <yukuai1@huaweicloud.com>
Cc: song@kernel.org, bmarzins@redhat.com, heinzm@redhat.com, 
	snitzer@kernel.org, ncroxon@redhat.com, linux-raid@vger.kernel.org, 
	dm-devel@lists.linux.dev, "yukuai (C)" <yukuai3@huawei.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Mar 1, 2024 at 10:12=E2=80=AFAM Yu Kuai <yukuai1@huaweicloud.com> w=
rote:
>
> Hi,
>
> =E5=9C=A8 2024/02/29 23:49, Xiao Ni =E5=86=99=E9=81=93:
> > Hi all
> >
> > This patch set tries to fix dmraid regression problems when we recently=
.
> > After talking with Kuai who also sent a patch set which is used to fix
> > dmraid regression problems, we decide to use a small patch set to fix
> > these regression problems. This patch is based on song's md-6.8 branch.
> >
> > This patch set has six patches. It reverts three patches. The fourth on=
e
> > and the fifth one resolve deadlock problems. With these two patches, it
> > can resolve most deadlock problem. The last one fixes the raid5 reshape
> > deadlock problem.
> >
> > I have run lvm2 regression test. There are 4 failed cases:
> > shell/dmsetup-integrity-keys.sh
> > shell/lvresize-fs-crypt.sh
> > shell/pvck-dump.sh
> > shell/select-report.sh
>
> You might need to run the test suite in a loop to make sure there are no
> tests that will fail occasionally.

I'll let the tests run today to check if there are more errors.

Regards
Xiao
>
> Thanks,
> Kuai
>
> >
> > And lvconvert-raid-reshape.sh can fail sometimes. But it fails in 6.6
> > kernel too. So it can return back to the same state with 6.6 kernel.
> >
> > Xiao Ni (6):
> >    Revert "md: Don't register sync_thread for reshape directly"
> >    Revert "md: Make sure md_do_sync() will set MD_RECOVERY_DONE"
> >    Revert "md: Don't ignore suspended array in md_check_recovery()"
> >    dm-raid/md: Clear MD_RECOVERY_WAIT when stopping dmraid
> >    md: Set MD_RECOVERY_FROZEN before stop sync thread
> >    md/raid5: Don't check crossing reshape when reshape hasn't started
> >
> >   drivers/md/dm-raid.c |  2 ++
> >   drivers/md/md.c      | 22 +++++++++----------
> >   drivers/md/raid10.c  | 16 ++++++++++++--
> >   drivers/md/raid5.c   | 51 ++++++++++++++++++++++++++++++++-----------=
-
> >   4 files changed, 63 insertions(+), 28 deletions(-)
> >
>

