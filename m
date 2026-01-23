Received: from mail-ed1-f44.google.com (mail-ed1-f44.google.com [209.85.208.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B9E78256C70
	for <dm-devel@lists.linux.dev>; Fri, 23 Jan 2026 22:52:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.208.44
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769208760; cv=pass; b=B59JIkMeeMVu63tjJB84lQVfusA9zJ3BMiOgtnvm9H7qPM113X7ZWOEDs2Hm4fidmkE11Q7ryNx4Iiyu5TKIryyq7a3CKXTCebE0pmwr4fZpFGQCWBIoyBlMiydqvIWnVTjMd07JXUH2+Mo0TGqvohxsJLtT7antRXVfV0UBWus=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769208760; c=relaxed/simple;
	bh=R5NSNlkafolr4Gn3Pp4CG3nYqwIH+6zUMlxrPKySuJk=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Vk+uS6TldT/ysEQtPTmQVi8UHJzcTBikIaKTO8wsNpNMBkEIsPg9ONNiBY6DnJkSbbd8l2Gzbw2XYkkNwhz6xVmN8800s6q0axnqa2qYjdshmogYHf6hn+Deoeu7/OVFvTYK+NCrEwTD7TQA8IdI+4bMQauXPT6h83g43WKRBzc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=srJ9Cq+i; arc=pass smtp.client-ip=209.85.208.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="srJ9Cq+i"
Received: by mail-ed1-f44.google.com with SMTP id 4fb4d7f45d1cf-6581551aa88so3388a12.0
        for <dm-devel@lists.linux.dev>; Fri, 23 Jan 2026 14:52:38 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1769208757; cv=none;
        d=google.com; s=arc-20240605;
        b=PEk1+8+0rsK7oGfJB6UANu8YerSnBN41GjuF4FYMOoWWWjKTLo+8Mm8fWkEf/yD2UN
         uQhiuCNyUPe3hJJuzSpZ4c2nb+krlOEFqwj4d8f7d7gAwfjTNgnvJpKKuDTZ4+QUj2Iu
         CK64fpPl8xkpH1QC9+AhKePi4EGc4ovR0rZ8zyg4+dSSMiWGtzQBBmsSTY1v9lVqAL1X
         kCA5h7Ldi3rjaBLCFPnQ7SEus5Xfak1n7HSUEJoE97sjXUmKfNgJYiipgXpKLRLQh4Wp
         8LVwJANeRJJDv9WBh1uDD8otljJ6IVXX6dN7Nw9+CNEyXztL3bTW/PxRsbjmq//3GhrU
         aVFQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=7S285UKX3k2uaqjFXx2AbkG87Z2Sk++KSTjBPoDg7Wk=;
        fh=dTAHK+0abp6vtiCw8MzE2mrS5eqwMiO7Tz4d9qqUk/4=;
        b=fBf/0OROxh5AcSjY9nC1rruZVETAeJhQfHp4uDJxDtVT0oO/dKxnpHITPRZaZ0OLTy
         1tCJuxoVn6rClcqEUFRv3jtMPUitg8//6F6559LxIksp3l5s3MTUEKEs+RNCOC4R0jkK
         dyDm8U9opGZWCdqaAozgGLdi7Y0B2s1SnFHPs5M6UJTaqXmQB4NCWQ+HP4+KWfGDSf6R
         fDcaQZlA4zsSQhUDkrGH3HTCTSy2lUPpRBT2IbFvKj7xooyh6eqRgn4V+KIr7d1d6WrL
         l61F5LzFvHXij1Qi4iI/Mw+8cf1DAgSutuh/1f/J7jLZQbril5pp2wsrhIl1uhjkOrS7
         eSMA==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1769208757; x=1769813557; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=7S285UKX3k2uaqjFXx2AbkG87Z2Sk++KSTjBPoDg7Wk=;
        b=srJ9Cq+igUtaiwtvCLKy67shsZZn+MpsEs9rU2br4bnKpaD/3yaWblGcrnLhCA9wLN
         YvxSGhE+AAYlVDmm61ZKTgj2FZH/2of4rbjgqFKawcyp3x1aTRUkU+F5XVoHjg5r5sTh
         3UYjRZGVWBzef2USw92Rq94dWimOee4Dn1jV9Xp7U3d1gKE31N3Aubzqd6Al5yJj66MG
         /gS0F/DqQ6HYyz+kN690iSHOu2btmxU2D43f6wwdDOd0GHGZV0xAWyelf2QTk8ruszRh
         9pL4HcKv7VylBgS6RJSIR35KRIQsozTRetEhIqPCcX7uERNZQzJ4Y7dSvwHqS5w8soYw
         JEHw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769208757; x=1769813557;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=7S285UKX3k2uaqjFXx2AbkG87Z2Sk++KSTjBPoDg7Wk=;
        b=YMifcooTcd0uD0iVx9F3qpphR+s9v0NhVmtGxYb8JhpV9Ltl5duGCogB+xQ8BWQnjW
         aNhaWhNwEqUJ3ULFt2VKSkvantcR/+1971PHrREbp1Mi1+Oxgv7RgqSiqBiLp0ine3GZ
         NiS0xj2JECMNWB97/FQ+lXU5pOV7OKB8DG6W4Mfw3E88QN1+RO1oD9ENvxL7wmn1po6/
         kxM82pgwJe349qV6/zeXQpFEXMy4u1LPOohgdJELU9VtwKty6NAQGADv4KGS3caVi9RQ
         JG4jGzRfBaN+IdXoLP/Zs7yCxt8QlYMo6/M6arnHz+UboIyD0FFxgEvlEuWinPwlLFv6
         XKog==
X-Gm-Message-State: AOJu0YzqWb1424Z9Ipezta9SQIGYjJ+XTlr/auAGVlANSwHvsuzZ87GZ
	EINgPvCk8KqRTWXUQIba2IGAyk6I4/pNZHwf8IW2PYlzFVhNp44p1cKGpWYpd1IrpGY8EEmwMw5
	0WdQip3tUmtEESMT0YJ199FzLE+a4kSnM3ysWF5oi
X-Gm-Gg: AZuq6aLUYNml2erjvDS+bH8o3pz/5P+iOws0v4nBWl2kw2CLM/+FJ+LutLt2Gqp1qpR
	VJ091cni64jP4BTjGM1mHVLH01eS8JwMcdJzD37xTo3ZQQ4C1N68rtpMl0HQZyKyvQIEyoOQVfT
	ySPU2SUwnVm64nbo6bgENQ8vsc3Sluon3C3iQi+D+wabXKIrWO1XjTU4fRipkkFoW2LWgZmNsyN
	DaZUv6W0jv96Kw3f/StIv1sWrq1aZbYol6RJalz/e9ye3z1Bmrqyxrv9iKxrjYjCRYH
X-Received: by 2002:a05:6402:14c1:b0:64b:4494:6417 with SMTP id
 4fb4d7f45d1cf-6585d61a7a3mr11237a12.6.1769208756680; Fri, 23 Jan 2026
 14:52:36 -0800 (PST)
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260111202642.52850-1-ebiggers@kernel.org>
In-Reply-To: <20260111202642.52850-1-ebiggers@kernel.org>
From: Sami Tolvanen <samitolvanen@google.com>
Date: Fri, 23 Jan 2026 14:52:00 -0800
X-Gm-Features: AZwV_QjawnBFNeBhWZYKIQOYiX-QkcO6bOVY3XHgC7eKmzt_Qv45-xfNStdQg6I
Message-ID: <CABCJKufDzV+Qz6W2=Mr-Qc4EOawEbbPBSmT=OavLpCgQ_8f7UA@mail.gmail.com>
Subject: Re: [PATCH] dm-verity: fix up various workqueue-related comments
To: Eric Biggers <ebiggers@kernel.org>
Cc: dm-devel@lists.linux.dev, Alasdair Kergon <agk@redhat.com>, 
	Mike Snitzer <snitzer@kernel.org>, Mikulas Patocka <mpatocka@redhat.com>, 
	Benjamin Marzinski <bmarzins@redhat.com>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sun, Jan 11, 2026 at 12:27=E2=80=AFPM Eric Biggers <ebiggers@kernel.org>=
 wrote:
>
> Replace obsolete mentions of "tasklets" with "softirq context", and
> "workqueue" with "kworker".

Nit: The patch seems to replace tasklet / BH workqueue references with
just "softirq" instead of "softirq context".

> This reflects the fact that the implementation of the
> "try_verify_in_tasklet" dm-verity option now accesses softirq context
> using either the BH workqueue API or inline execution, not the tasklet
> API.  The old names conflated the API with the intended execution
> context, so they became outdated when the APIs changed.
>
> Signed-off-by: Eric Biggers <ebiggers@kernel.org>

Either way, looks cleaner to me:

Reviewed-by: Sami Tolvanen <samitolvanen@google.com>

Sami
