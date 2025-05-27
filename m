Received: from mail-il1-f170.google.com (mail-il1-f170.google.com [209.85.166.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 259861F17EB
	for <dm-devel@lists.linux.dev>; Tue, 27 May 2025 23:43:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748389435; cv=none; b=dhZt76JasZbYVPIaYfdYXk4fMLjhNaxPTP6mUdmvU7dKo43Aero9h1h3RjA6VaF2doGfCO5AudCOHUcdtmcOUaT4TkG8TeqhxHX/ONyKJp9FgCE+wuCgYIx/dA9PGal47gEXMlYxXRVgBrAdDhRLdpM57GP3D1v8NuyNxJ1+80A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748389435; c=relaxed/simple;
	bh=f08em9DA6QU6JbQhqbKs8TXBg5LZ+UoUHjXE6+ZDNPI=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=NZl4IHrFPFnM25XAtFJAf6AgukrthNYPhG1Ut2idCvufCVQqOjyepMUZm7j/Jl3bl+XmJStS+uJ2XG+EB9PVaBRrwCF5tkES0tVxQc+V0ompmO5QzOMWgXKQ83CUcxWm0R49NhUMWIIPydfGslzfoG5W+vbLR+40vZYuMdi939k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=apymLiCy; arc=none smtp.client-ip=209.85.166.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="apymLiCy"
Received: by mail-il1-f170.google.com with SMTP id e9e14a558f8ab-3da73df6b6bso11042835ab.3
        for <dm-devel@lists.linux.dev>; Tue, 27 May 2025 16:43:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1748389433; x=1748994233; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=f08em9DA6QU6JbQhqbKs8TXBg5LZ+UoUHjXE6+ZDNPI=;
        b=apymLiCyClNqV1DIDMVePVxaS21hXZE3sMW12oRi3xANiFw7cXCa7n199xLIUUH/Tu
         J16DetL+NdAo5QzH+pVYtx8I/6bM+CrBgKxDaiqdU0QFTODmAF7SUN12V4c88aLpJ+AC
         Z4Ny+9SGMnknoJwWXaNZ9qDNNBw0vdowEls1uZ76ZMpucg2njTlclKNarHr7pKda9MlM
         rBrvuuVJAPFNAAS+10YK4K6D6JbWvlZtLwhghps7eCmc0//T6aYjYGlxOfG5F8+r9i7w
         fkH6mzl5zk5Qh29lYLRRRyJiDzEgIzPZwfynVe77kDm4C1ZaSVMTONqxyY5K73OGY/mI
         6W2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1748389433; x=1748994233;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=f08em9DA6QU6JbQhqbKs8TXBg5LZ+UoUHjXE6+ZDNPI=;
        b=E+Qm1z7VgHl5A9gbb1YVn5KjjLRvhn+jBenvluHb6QDXnoReoKP6379B+ZO9Ux9lxK
         Tz4MR0K9htCbPWmz37PR+L7CsfiOs2NT4Gf+a1q17eAgbjGM+SPCHwrM2Wd/2/AIETp7
         MlLk23hbimsVszoD/vQSVGiJSS1MnmBIWEERKSA+/2wp5ZEHsQyzsBhNhinGztUaWNvT
         kJ8HHFc4MefgR4ADoTyfmF4jjVfx80bV2W/jguy9Lpq+8xK4RTYHhX0QsjHWYctWDcq5
         rb7iiYsy3JLutPxgPTg8TkqfgkJccLhz6RTNULpyWc2xRmRKE3rcfFyOY3M4F+iOF9zJ
         0/DQ==
X-Forwarded-Encrypted: i=1; AJvYcCXdis22E7sXaH3K6jqbVB0msV6KpxdEZkS3I9VtFl4YfqxusVrwIG5tGULiPsuLvtQ1PnH4ozCOBw==@lists.linux.dev
X-Gm-Message-State: AOJu0YzcpBSLoKUtW5+PvJSV+yhbr/Bpg65HvCpHbqlcjS1zD5hhPPqI
	LEXcm6YbpTGPvqVtQj4TZzHpWnAtbv6uZww7eOoPOrK3oL5T6F2oGzKF9xoDkeA1bv06EAR9RF/
	TIvcPIe+2qVVKr1Gy2FvH/kJHJC6obP0=
X-Gm-Gg: ASbGnct/zLarbzLu/m2U8lyGam3/KLzDhnGSuBWuRHOhQR6YvbJE58ycjCjfxI8NHjA
	Ssq4Rtb2sfW9g9VjbloOXNutJjg/0QmG7HtWX8DduAJ74xAOo1nlPrkD75CIKUYPXn3I4SWfRWc
	W48zI6s1SuPMDA6f9FzEu304zyBnkrsLo=
X-Google-Smtp-Source: AGHT+IFNQN4+WL6glmxs8lAJDLu8MmuG4dogdioqikdxkZTzmQFS3OIBQSPDH+mrcAEyBGGegg4u6eiOYwHdcptWq+8=
X-Received: by 2002:a05:6e02:348f:b0:3dc:76ad:7990 with SMTP id
 e9e14a558f8ab-3dc9b706abbmr145701725ab.15.1748389433167; Tue, 27 May 2025
 16:43:53 -0700 (PDT)
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240130091300.2968534-1-tj@kernel.org> <20240130091300.2968534-7-tj@kernel.org>
 <CAL+tcoCKqs1m4bAWTWv9aoQKs7ZpC5PXtMS2ooi6xEB6CbxN1w@mail.gmail.com> <aDYKoA8lpX_Zxrhh@slm.duckdns.org>
In-Reply-To: <aDYKoA8lpX_Zxrhh@slm.duckdns.org>
From: Jason Xing <kerneljasonxing@gmail.com>
Date: Wed, 28 May 2025 07:43:16 +0800
X-Gm-Features: AX0GCFsb4ySh9tHeNVChD-RPYFuj3Sh8LOL_jgy3hcYZQuZgVtS4GposQzjOWkg
Message-ID: <CAL+tcoCjaq=CxXdFtCqF4LdwCfenrHi7Nu-XHm+u--phuoC+EA@mail.gmail.com>
Subject: Re: [PATCH 6/8] net: tcp: tsq: Convert from tasklet to BH workqueue
To: Tejun Heo <tj@kernel.org>
Cc: torvalds@linux-foundation.org, mpatocka@redhat.com, 
	linux-kernel@vger.kernel.org, dm-devel@lists.linux.dev, msnitzer@redhat.com, 
	ignat@cloudflare.com, damien.lemoal@wdc.com, bob.liu@oracle.com, 
	houtao1@huawei.com, peterz@infradead.org, mingo@kernel.org, 
	netdev@vger.kernel.org, allen.lkml@gmail.com, kernel-team@meta.com, 
	Eric Dumazet <edumazet@google.com>, "David S. Miller" <davem@davemloft.net>, 
	David Ahern <dsahern@kernel.org>, Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, May 28, 2025 at 2:55=E2=80=AFAM Tejun Heo <tj@kernel.org> wrote:
>
> Hello,
>
> On Sun, May 25, 2025 at 11:51:55AM +0800, Jason Xing wrote:
> > Sorry to revive the old thread! I noticed this change because I've
> > been doing an investigation around TSQ recently. I'm very cautious
> > about the change in the core/sensitive part of the networking area
> > because it might affect some corner cases beyond our limited test,
> > even though I've tested many rounds and no regression results
> > (including the latency between tcp_wfree and tcp_tsq_handler) show up.
> > My main concern is what the exact benefit/improvement it could bring
> > with the change applied since your BH workqueue commit[1] says the
> > tasklet mechanism has some flaws. I'd like to see if I can
> > reproduce/verify it.
>
> There won't be any behavioral benefits. It's mostly that it'd be great to
> get rid of tasklets with something which is more generic, so if BH workqu=
eue
> doesn't regress, we want to keep moving users to BH workqueue until all
> tasklet users are gone and then remove tasklet.

I see. So far I haven't see any side effect especially with testing
bulk transfer/multi-thread transfer, so if you're willing to repost it
after the merge window, please feel free to add:

Reviewed-by: Jason Xing <kerneljasonxing@gmail.com>

Thanks,
Jason
