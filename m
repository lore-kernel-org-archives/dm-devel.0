Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 701D618DF80
	for <dm-devel@lists.linux.dev>; Tue, 15 Jul 2025 15:59:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752595184; cv=none; b=Ch2HYOM0UhIoxL5hmwbFiIcwuwu+u9cFt+oJSltsztVdxgQNfe74+AtQx15l814z9uC6hm6D1mUKPUekTdL8COrXq5xhNX+tdTrQgI95k2OJKcRKtNhr4m0eQEXsyRcpV5+lZG8lI90OuyHBPXQSC5h8LcCRpAx4/rpXbOfPQoY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752595184; c=relaxed/simple;
	bh=h04P6WBmErPAhxJavYCYGSYZCXxVtF9CgGCoVP8brGc=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=kJHjHnhxpRgx+GiYkV6M5EZ7P1S0CY/lvCNc14kQ4hMzKlkNGN1l1VjEkykIxaozciRYTdtYpluYy2i7DMkbdr1fq8+9gQOnQvjgMDozgHhBctRgj+VPGfqTWrh2eBwOGwiSnKZK41cUEbJNy/KKU7Q4cx1mRwgpSU0FA9KFyFg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=XWoidMqJ; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="XWoidMqJ"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1752595181;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=yucCQYwkwjky0mk+mh1Ojtp7ZRFBEeijG7flmfNKHgc=;
	b=XWoidMqJrFXGPCQbWagitQ26aFhCuRJPCf7lNMTdxP4DEuQfB0NYGM1q+kH7ZjawnmBZ5j
	ZCivOVCyYYyl5RYImwCQvyAgQJW/lJ/rJMxXOU3tfN88tWkFROjPFj70JK+eoJ+IaJYggt
	sARgmD2c10OX46fmXQQL8JZmbb/GIU4=
Received: from mail-oa1-f71.google.com (mail-oa1-f71.google.com
 [209.85.160.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-124-wVxNiTC0Mz-gkuh8p1Dtiw-1; Tue, 15 Jul 2025 11:59:40 -0400
X-MC-Unique: wVxNiTC0Mz-gkuh8p1Dtiw-1
X-Mimecast-MFC-AGG-ID: wVxNiTC0Mz-gkuh8p1Dtiw_1752595179
Received: by mail-oa1-f71.google.com with SMTP id 586e51a60fabf-2ff88395982so527138fac.2
        for <dm-devel@lists.linux.dev>; Tue, 15 Jul 2025 08:59:40 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1752595179; x=1753199979;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=yucCQYwkwjky0mk+mh1Ojtp7ZRFBEeijG7flmfNKHgc=;
        b=vN6BUxA0VOBg5VuQgBiHgGAjcygoOHX309k2ZwnBzI0l21zFV7ATal79fsgNht1MM9
         V3DOqPW8rgV250kyxDzMDoE6Gkzn1zIKb3Bf9XKmE5rWG7tWXgnvePScqAJxWVcGVlhn
         Dd5sYog9alEM7bH2qJ6lExP5UGJxa7C7vtVKNIShdemHRHDqjYLPdkAu2jXiVNF7zfGG
         WL8J/SaOp0ZlUhnUaAiJGobwBH2mOK+nAYg43aBxF7zNXULfRyG5e+Si+GN/xDa5K3mI
         B9MkXFoNBRCDvnbE+szzOl/wPNUPsKBvA7ZAfv+bYmSiQo/E/J7XaWNxecwASUIHlq17
         x0OA==
X-Gm-Message-State: AOJu0Yw9J1L+F6gtoe7m5n1pmfT1Xig65NTNOA1qFfBTzpwS19bf8R4z
	J57gHX9w2Ngxj9RqRBSeYiYw0nCM2+aOSRP8YMAf8f9CXuuEuasI9T122bgL39KiLTGT991azan
	8GPyi1MtfY5unHRU1OwD7hovDWkuRWEAPfM/CXiCqr6DzS2LwmW6Eo1ZSLIRKWig+YkmwbZODm/
	X8ssvnAwfxgpZo8ev2lSel4qGhuKGCFWb65brqmX7Xng==
X-Gm-Gg: ASbGncsWk48e4IW1ViOhhyFuy9V6Vosiqb6Z0aEH7GBcARsvO2H+yHkyexi7E/linFF
	3P6yD8tkygqqwgmNfaxkjoyO0CqMEBvBOkY3zBT5DgoxJJsHkHeZO9DzY+JUjEI5gR08D86ym0c
	8fes66XQ34KziIgqH40WLUNw==
X-Received: by 2002:a05:6870:e80b:b0:2b8:2f9c:d513 with SMTP id 586e51a60fabf-2ff26a259f3mr12352333fac.19.1752595178979;
        Tue, 15 Jul 2025 08:59:38 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IELUQajgyMqLvilm11KiBTulp450BGZGfS7cp8J/21t2LHJ+wUqUgGwoa8KXBz2gvuU55l9tUufI3jLFvrLRck=
X-Received: by 2002:a05:6870:e80b:b0:2b8:2f9c:d513 with SMTP id
 586e51a60fabf-2ff26a259f3mr12352314fac.19.1752595178602; Tue, 15 Jul 2025
 08:59:38 -0700 (PDT)
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <CAJhEC06nnd5kMSqkP8P_WoXOE1doMryt7R8JYpsm77bS6NF53A@mail.gmail.com>
In-Reply-To: <CAJhEC06nnd5kMSqkP8P_WoXOE1doMryt7R8JYpsm77bS6NF53A@mail.gmail.com>
From: Ming Hung Tsai <mtsai@redhat.com>
Date: Tue, 15 Jul 2025 23:59:26 +0800
X-Gm-Features: Ac12FXwOrHZyGK2L9i6kvq8901SiSCIrO8w0g8kkPEYWvcjQoagC-MH0iOGrQDI
Message-ID: <CALjSBEuq=fpKRfRJ_95ja_HDFum49AASa9mT9wMRrdm4zSwSAA@mail.gmail.com>
Subject: Re: Question about dm-cache promotion decision in dm-cache-policy-smq.c
 (commit b29d498)
To: Robert Pang <robertpang@google.com>
Cc: dm-devel@lists.linux.dev
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: q1PJMMEE1rEAuV_TGUxI3_u13OyawoAdcFNZ5NHRRZQ_1752595179
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sat, Jul 12, 2025 at 5:14=E2=80=AFAM Robert Pang <robertpang@google.com>=
 wrote:
>
> Here's a rewritten version of your email, aiming for clarity,
> conciseness, and a professional tone:
>
> Subject: Question about dm-cache promotion decision in dm-cache-policy-sm=
q.c
> Hi,
>
> I'm currently investigating how dm-cache makes promotion decisions and
> have a question regarding a specific line in the
> update_promote_levels() function within dm-cache-policy-smq.c.
>
> Specifically, I'm looking at line [1] in the code snippet below:
>
> static void update_promote_levels(struct smq_policy *mq)
> {
>   /*
>   * If there are unused cache entries then we want to be really
>   * eager to promote.
>   */
>   unsigned int threshold_level =3D allocator_empty(&mq->cache_alloc) ?
>   default_promote_level(mq) : (NR_HOTSPOT_LEVELS / 2u);
>
>   /* line [1] */
>   threshold_level =3D max(threshold_level, NR_HOTSPOT_LEVELS);
>   ...
>
>   mq->read_promote_level =3D NR_HOTSPOT_LEVELS - threshold_level;
>   mq->write_promote_level =3D (NR_HOTSPOT_LEVELS - threshold_level);
> }
>
> My understanding is that NR_HOTSPOT_LEVELS is defined as 64, and
> default_promote_level() returns a value between 1 and 8. If this is
> correct, then threshold_level (before line [1]) would always be less
> than or equal to NR_HOTSPOT_LEVELS (e.g., 8 or 32). Consequently,
> max(threshold_level, NR_HOTSPOT_LEVELS) would always evaluate to
> NR_HOTSPOT_LEVELS, effectively setting threshold_level to 64
> regardless of its initial calculation.
>
> I've traced line [1] back to commit b29d498 ("dm cache: significant
> rework to leverage dm-bio-prison-v2") [2]. It seems like the line's
> purpose is to cap threshold_level to prevent underflow in the
> subsequent subtractions for read_promote_level and
> write_promote_level.
>
> Given this intended purpose and the typical behavior of min() and
> max() functions, shouldn't line [1] instead be:
>
>   threshold_level =3D min(threshold_level, NR_HOTSPOT_LEVELS);
>
> This would ensure threshold_level doesn't exceed NR_HOTSPOT_LEVELS,
> while still allowing its initial calculated value to be used if it's
> lower.
>
> Could someone please clarify if my interpretation of this logic is
> correct, or if I'm missing something?
>
> Best regards
> Robert Pang
>
> [1] https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tr=
ee/drivers/md/dm-cache-policy-smq.c#n1057
> [2] https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/co=
mmit/?id=3Db29d498
>

Hi,

Currently, dm-cache makes promotion decisions based on short-term
access patterns. The read/write_promote_level determines how
frequently a missed block must be accessed before it is promoted. If
we modify line [1] to use min(threshold_level, NR_HOTSPOT_LEVELS), it
would increase the read/write_promote_level, making the cache less
responsive to varying IO patterns. That may be why commit b29d498
changed the behavior.

I=E2=80=99ve noticed this ambiguity before, just haven=E2=80=99t submitted =
a patch to
clean it up. The default_promote_level() might have been kept as a
reminder of the older approach.


Thanks,
Ming-Hung Tsai

