Received: from mail-ed1-f46.google.com (mail-ed1-f46.google.com [209.85.208.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 807251DF261
	for <dm-devel@lists.linux.dev>; Fri, 18 Jul 2025 18:07:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752862026; cv=none; b=IgowNyKy4EPI0f7qTUfvk7jzsI1kJeW0IWCS9ZAEzaHFlJj4lg3vrMJWyyNa4cjAc9s3RyuNAhS3GZMQytfzVADTwsKdsVoZ55/3dMBGLpQ17Z3EB4Tw65DEM2+F5vBXHicBUqKRnRoVeQ7MvN33B6F5d90s2AZc4NAe++IW0MM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752862026; c=relaxed/simple;
	bh=jfBOAKqRqCPb86pqlwG51uTwqEkmrZ3uVDa3ES3eKNQ=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=uTrefaHMJEzcDiBhOKREA/NvH28L5ezOXBldC/XangBXzzD/EMeKGqJymmSOjq5tLozUR+YQOetkNbpmjwUrfduvznfK9qhG04HJLGTvOH1I27gZ4lMGck5Q7bFqYDWONLsQS4f9V33LyIRdDBkNsrFYUOCFlF2BAbwznCApOA8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=yE1Uczrj; arc=none smtp.client-ip=209.85.208.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="yE1Uczrj"
Received: by mail-ed1-f46.google.com with SMTP id 4fb4d7f45d1cf-611d32903d5so1503a12.0
        for <dm-devel@lists.linux.dev>; Fri, 18 Jul 2025 11:07:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1752862023; x=1753466823; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Sl4zXK5L4PLgrJ/KWcvnxJQsvGAy50yod1UnBHSEmFk=;
        b=yE1Uczrj+HCRVwWcmuvKACIvQKktY0m6WEXnDzNrT8VbAgg3qx5+YfdS5pYd+tKFiU
         7NWl8RnOukwXj8yhY06dG/HI6qXYeAI4PPWVcEKS86ub8ciEzoc6gqbBg07yW+24IOFM
         fMzSEMhqnyUBl3s6c42TKXiaStAdpzRNNHHb4a8Um/xV5pyKTLiMRHPnfOAKRAsssW1E
         ONACW6hnwxUnQzDB6us36dvWlRtE1nREvaDBT3EEvKfsA1KDHVStuoMY2OM0rtPuP/SD
         o9RHJF7C4p42STmN8hwx5HBAMUYKas7Xdhzv6dS/lexeqAK5DDduqobe5EcqZOXpt/m+
         G/JQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1752862023; x=1753466823;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Sl4zXK5L4PLgrJ/KWcvnxJQsvGAy50yod1UnBHSEmFk=;
        b=tTA1DwFnoWq7k97bxZLLUk+GXRgAxSCZPF9/FGULxg6tXZhxe6QAczhwpIGoqq10ov
         DX7ZljcgrwlAX3vo22oyp3fs6xgFvpYcOlNbuELD3rKoYmVqJMSshQx6TUzF/k3noLBy
         MpbhgfQGr5al7Vj68WP4i/9iERvqxx7cbQn/6jhdGyyENgIubt+Hr4Z9xgv4BeHuLc6G
         jmGKROpAJV8roZBRs+ppnHHr3etoEsqOZF7/VGUEBcUCoQCpX/L2Apxk2Q0W85qiX5Er
         fTbWUrd+UaG3Cx3MwkR/34O/d0rzrsiD12Y+/athTFlzFRZ1HoZzj4lGJDwN1P+w9EHK
         uD9Q==
X-Gm-Message-State: AOJu0YwHp9I9bD+Is9Sbn7Oao2+ZkjHvuBTAuP1YpWVGUF3mJ0LIbYHw
	Yu3hJkU6ASG8CG3E/h1lFxyko1z6HjUOhvWBu96CBseHzQruvVcW0U2cBnm+GMzBmhLJAkMf5Te
	GhDEU0PIQc/i9xkRqFCH9/pQIuysYaeb1gyJDZBFbqC95SHeDxNL2vJLgc+Y=
X-Gm-Gg: ASbGncvEZawT6hENzgX4vvsfOhKqgnLk8+NKL3Tqetedc0wTjiJi2tABNdLak0ol3aI
	BdVlftXO5+aFxfEriSXHqymUfY5NNfi406Au52y59zOwuSbCY/+85Xa5WLaQBtDL37AivxVCsAF
	65TFjmZNzMsXK9bAHR5QJ58+1Wsa+UopRzVwmkBXNS6H5mYOxcMEcqoBGj5emAFBCpi5XMZETni
	OYMz0FzYgOg7B8ikWXIO8A9awR2OC4hoORORQ==
X-Google-Smtp-Source: AGHT+IHKLo1s8cFHkfx1p4Mgnh8+HXRdvi8Sdxc/EsEL2N/Vcx0fwlzJXZZ6Pvvx7gEBousvHXN8gjtlz7P4jDEEkNw=
X-Received: by 2002:a05:6402:22f2:b0:607:bd2:4757 with SMTP id
 4fb4d7f45d1cf-612e73e9450mr2531a12.1.1752862022381; Fri, 18 Jul 2025 11:07:02
 -0700 (PDT)
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <CAJhEC06nnd5kMSqkP8P_WoXOE1doMryt7R8JYpsm77bS6NF53A@mail.gmail.com>
 <CALjSBEuq=fpKRfRJ_95ja_HDFum49AASa9mT9wMRrdm4zSwSAA@mail.gmail.com>
In-Reply-To: <CALjSBEuq=fpKRfRJ_95ja_HDFum49AASa9mT9wMRrdm4zSwSAA@mail.gmail.com>
From: Robert Pang <robertpang@google.com>
Date: Fri, 18 Jul 2025 11:06:49 -0700
X-Gm-Features: Ac12FXwVRvnLv0H-L84xOBDAOwdPb5KYb3OgBJpA0AyscQHuiBvi-co-RLcN5cY
Message-ID: <CAJhEC04Rw5yxY-zh4kmsDO+ScjzLAqoO1wWMDUV=t_TdK2paPA@mail.gmail.com>
Subject: Re: Question about dm-cache promotion decision in dm-cache-policy-smq.c
 (commit b29d498)
To: Ming Hung Tsai <mtsai@redhat.com>
Cc: dm-devel@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Ming-Hung,

Thanks for clarifying the cache decision and the rationale behind
using max() in update_promote_levels(). That helped me understand the
whole min() vs. max() effect on the latter read/write_promote_level I
was wondering about.

Regarding promotion decisions, I read about dm-cache's slow approach
to promoting candidates, as described in [1]. What are your thoughts
on good dm-cache setup and configuration to achieve optimal cache
performance?

Thanks,
Robert Pang

[1] https://www.redhat.com/en/blog/improving-read-performance-dm-cache

On Tue, Jul 15, 2025 at 8:59=E2=80=AFAM Ming Hung Tsai <mtsai@redhat.com> w=
rote:
>
> On Sat, Jul 12, 2025 at 5:14=E2=80=AFAM Robert Pang <robertpang@google.co=
m> wrote:
> >
> > Hi,
> >
> > I'm currently investigating how dm-cache makes promotion decisions and
> > have a question regarding a specific line in the
> > update_promote_levels() function within dm-cache-policy-smq.c.
> >
> > Specifically, I'm looking at line [1] in the code snippet below:
> >
> > static void update_promote_levels(struct smq_policy *mq)
> > {
> >   /*
> >   * If there are unused cache entries then we want to be really
> >   * eager to promote.
> >   */
> >   unsigned int threshold_level =3D allocator_empty(&mq->cache_alloc) ?
> >   default_promote_level(mq) : (NR_HOTSPOT_LEVELS / 2u);
> >
> >   /* line [1] */
> >   threshold_level =3D max(threshold_level, NR_HOTSPOT_LEVELS);
> >   ...
> >
> >   mq->read_promote_level =3D NR_HOTSPOT_LEVELS - threshold_level;
> >   mq->write_promote_level =3D (NR_HOTSPOT_LEVELS - threshold_level);
> > }
> >
> > My understanding is that NR_HOTSPOT_LEVELS is defined as 64, and
> > default_promote_level() returns a value between 1 and 8. If this is
> > correct, then threshold_level (before line [1]) would always be less
> > than or equal to NR_HOTSPOT_LEVELS (e.g., 8 or 32). Consequently,
> > max(threshold_level, NR_HOTSPOT_LEVELS) would always evaluate to
> > NR_HOTSPOT_LEVELS, effectively setting threshold_level to 64
> > regardless of its initial calculation.
> >
> > I've traced line [1] back to commit b29d498 ("dm cache: significant
> > rework to leverage dm-bio-prison-v2") [2]. It seems like the line's
> > purpose is to cap threshold_level to prevent underflow in the
> > subsequent subtractions for read_promote_level and
> > write_promote_level.
> >
> > Given this intended purpose and the typical behavior of min() and
> > max() functions, shouldn't line [1] instead be:
> >
> >   threshold_level =3D min(threshold_level, NR_HOTSPOT_LEVELS);
> >
> > This would ensure threshold_level doesn't exceed NR_HOTSPOT_LEVELS,
> > while still allowing its initial calculated value to be used if it's
> > lower.
> >
> > Could someone please clarify if my interpretation of this logic is
> > correct, or if I'm missing something?
> >
> > Best regards
> > Robert Pang
> >
> > [1] https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/=
tree/drivers/md/dm-cache-policy-smq.c#n1057
> > [2] https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/=
commit/?id=3Db29d498
> >
>
> Hi,
>
> Currently, dm-cache makes promotion decisions based on short-term
> access patterns. The read/write_promote_level determines how
> frequently a missed block must be accessed before it is promoted. If
> we modify line [1] to use min(threshold_level, NR_HOTSPOT_LEVELS), it
> would increase the read/write_promote_level, making the cache less
> responsive to varying IO patterns. That may be why commit b29d498
> changed the behavior.
>
> I=E2=80=99ve noticed this ambiguity before, just haven=E2=80=99t submitte=
d a patch to
> clean it up. The default_promote_level() might have been kept as a
> reminder of the older approach.
>
>
> Thanks,
> Ming-Hung Tsai
>
