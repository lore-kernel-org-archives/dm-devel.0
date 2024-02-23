Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7AA137FBC8
	for <dm-devel@lists.linux.dev>; Fri, 23 Feb 2024 13:49:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708696198; cv=none; b=UCmvBCdE3Cf5h7ckKBAUj5xrnlystybot2JR5haf3VNZtK4Z/pKFNM0+w8zwb+aWCQK7an3jKVN0q5e9CeUdCKA93njb3OXTFemFS4qFmW7vIb8zC3CgsZOOAwAil3aDINL+URfSQooIDzRK6AcsPonNavh4cRhvyQX/JJevZvo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708696198; c=relaxed/simple;
	bh=EUy3OE1tf6D7N57nMeA/9FZvI1nqisSpUaKPM/1NR14=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=L2ASA4aDC5nle3r5oZxrlJX6iQJvWf+/1WJn/1uAYzpg08YMmmooJER4Myk/c/1qlBMKXStGE2tTRLDUYLhxMa/HrooEfXd5vLywmok2QMGuAnQE0IHhJqcHLKyxiibuOy48Pz8EswB/Dq+uk5122JzllhrHsRMFWcwoiksyarE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=VQghUeGM; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="VQghUeGM"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1708696195;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=qRJGiEK2y2n/ne+i7hF7lrmOvkwWDv1nO09eJH8xkiI=;
	b=VQghUeGMJMKNTQG3dG8ZfzOTmwOhC0dFqJBbwhyi96ZT1ukwR9Ja6Fxyb3vZyPLCfu1Gw0
	QFFDKFvEtyUammqjfAQt3SLYB8PzPlU3bnPMxY8S/hm4AAvic11mph8PjvsRsyRsT3IgFH
	Sh/ZK0noyEMckVNeDFWy6v+a3kjNDB0=
Received: from mail-pl1-f197.google.com (mail-pl1-f197.google.com
 [209.85.214.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-388-pX1q59YZNDCH7uBnzjv1kw-1; Fri, 23 Feb 2024 08:49:54 -0500
X-MC-Unique: pX1q59YZNDCH7uBnzjv1kw-1
Received: by mail-pl1-f197.google.com with SMTP id d9443c01a7336-1dbcbffd853so2324125ad.3
        for <dm-devel@lists.linux.dev>; Fri, 23 Feb 2024 05:49:53 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708696193; x=1709300993;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=qRJGiEK2y2n/ne+i7hF7lrmOvkwWDv1nO09eJH8xkiI=;
        b=UoWHP5O1PuV29U0AWSuxFdO+nGN47Xh+YOZOxP5d6bp4K6u+GuaHdfncooGMd8xEVY
         9FpkNKwbZcid4dqc3q2BSPPRE9yWzovrwMRSewt7Fvj2D+05jNz817DIhUYoiXcuE/Du
         QDqyDuKNZk5jg/bvhf9ei2HRNhvVfr18dLNRcJpEPWFtxGjGoaEdbmbrEB19e5zcuTO1
         OHmWP2Soz7ny/yVjRXy5XqdQDSkFFwM63+DDFGuaurzhaPQfHcz66rElJlu2/VY31A5C
         vYACSOXguWPp21iBuhr9EVQRT1tAxVugYrDCqma4sJ5B6QnBQ1itZWG2L/qx2ZsGknYr
         FtCA==
X-Forwarded-Encrypted: i=1; AJvYcCUjnwtRmGCQN6Kntbfy7rUiwx4lKnk2w8g4B+ISkQX/Y5a20Rmiou8qR3+RaVMpnhGByeMgnbaV0LYThUjGmB+DVsoiOlEXy1I=
X-Gm-Message-State: AOJu0YyI1JRqZkJpQncAOmeLNpY5AV672BQ1bi1dJ+Ft9U0jq+E7NG3X
	8CoUjA8Ao3P41ZEmIvbocIx/B9GEmtksRdELYtOq5tQIWXtnPueOphjuSVHTNxxTSxpyZ9E7dat
	O+sejDeJ+Zzz8mM5oDa7UEJZBbJg99UubmcMekIVR041litFfkQ730GWrhrdBB4kMEPgK+mP4N0
	MoB052ZxL2wWpHE3AINpa2hXl/fgq1A0Y=
X-Received: by 2002:a17:903:24e:b0:1dc:4a8b:2e21 with SMTP id j14-20020a170903024e00b001dc4a8b2e21mr1934118plh.19.1708696193004;
        Fri, 23 Feb 2024 05:49:53 -0800 (PST)
X-Google-Smtp-Source: AGHT+IHg4XuRNe5wpL7uz2gKLB2aFRvKxdipIv+peW02sFUpWSChz8uYkhouqKGDAIG3nZ/GKZRngfiCM1WSQ9fNzhM=
X-Received: by 2002:a17:903:24e:b0:1dc:4a8b:2e21 with SMTP id
 j14-20020a170903024e00b001dc4a8b2e21mr1934094plh.19.1708696192681; Fri, 23
 Feb 2024 05:49:52 -0800 (PST)
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240220153059.11233-1-xni@redhat.com> <20240220153059.11233-4-xni@redhat.com>
 <773e5948-79a6-1270-4b74-cb1a3a60d243@huaweicloud.com>
In-Reply-To: <773e5948-79a6-1270-4b74-cb1a3a60d243@huaweicloud.com>
From: Xiao Ni <xni@redhat.com>
Date: Fri, 23 Feb 2024 21:49:41 +0800
Message-ID: <CALTww2-iPKrujozWRSGJQsJtN0QJS3risegCuZLUXGAm2FOLjw@mail.gmail.com>
Subject: Re: [PATCH RFC 3/4] md: Missing decrease active_io for flush io
To: Yu Kuai <yukuai1@huaweicloud.com>
Cc: song@kernel.org, bmarzins@redhat.com, heinzm@redhat.com, 
	snitzer@kernel.org, ncroxon@redhat.com, neilb@suse.de, 
	linux-raid@vger.kernel.org, dm-devel@lists.linux.dev, 
	"yukuai (C)" <yukuai3@huawei.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Feb 23, 2024 at 11:06=E2=80=AFAM Yu Kuai <yukuai1@huaweicloud.com> =
wrote:
>
> Hi,
>
> =E5=9C=A8 2024/02/20 23:30, Xiao Ni =E5=86=99=E9=81=93:
> > If all flush bios finish fast, it doesn't decrease active_io. And it wi=
ll
> > stuck when stopping array.
> >
> > This can be reproduced by lvm2 test shell/integrity-caching.sh.
> > But it can't reproduce 100%.
> >
> > Fixes: fa2bbff7b0b4 ("md: synchronize flush io with array reconfigurati=
on")
> > Signed-off-by: Xiao Ni <xni@redhat.com>
>
> Same patch is already applied:
>
> 855678ed8534 md: Fix missing release of 'active_io' for flush

Thanks for the information. I used Linus's tree so I missed this one.

Regards
Xiao
>
> Thanks,
> Kuai
>
> > ---
> >   drivers/md/md.c | 6 +++++-
> >   1 file changed, 5 insertions(+), 1 deletion(-)
> >
> > diff --git a/drivers/md/md.c b/drivers/md/md.c
> > index 77e3af7cf6bb..a41bed286fd2 100644
> > --- a/drivers/md/md.c
> > +++ b/drivers/md/md.c
> > @@ -579,8 +579,12 @@ static void submit_flushes(struct work_struct *ws)
> >                       rcu_read_lock();
> >               }
> >       rcu_read_unlock();
> > -     if (atomic_dec_and_test(&mddev->flush_pending))
> > +     if (atomic_dec_and_test(&mddev->flush_pending)) {
> > +             /* The pair is percpu_ref_get() from md_flush_request() *=
/
> > +             percpu_ref_put(&mddev->active_io);
> > +
> >               queue_work(md_wq, &mddev->flush_work);
> > +     }
> >   }
> >
> >   static void md_submit_flush_data(struct work_struct *ws)
> >
>

