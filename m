Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D52318F5C
	for <dm-devel@lists.linux.dev>; Sat,  2 Mar 2024 04:14:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709352900; cv=none; b=GzPDsAU6EbmPLloccuXL02QgtuqmI9DNIpgX18p1vKju6/5Tc8PReuhffnMUJJfJlaCIgzhkqAwNj0gOQ+mywBf4acCPulgmb2jZVUgduayaEvXl4rY4/BYJ5ZP5LN7NO4YWHojT5bleWn8ABzqTipPD74JsK/eJFICdhlQR8wo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709352900; c=relaxed/simple;
	bh=/1+GOGhh+pVjrKvmZWdMRnJ91uk2nvheq4wiSCQYdMY=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=YBRHMlG8Bx8R+4NLlqwY8pUgp0Bv5m2Eqp/f5Nkgs5CGwtLUDDWd8PST0YQa/sLzJjFjnTKPhtgs1jzEwzqqUVLBI0FGNk63qlSG9xxEv46t/iEJHN1EFSU/99QO6NnPlkLa40TaWqk4SIm5vBQ63rRYYo/1G2GDKJvZmcz35RA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=nOTZReGK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="nOTZReGK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 77AA4C43390
	for <dm-devel@lists.linux.dev>; Sat,  2 Mar 2024 04:14:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1709352899;
	bh=/1+GOGhh+pVjrKvmZWdMRnJ91uk2nvheq4wiSCQYdMY=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=nOTZReGKSzi46GnWESuSiAim8aTJzO7UDdGbSfbm5qita/gb1tzyb9Day0lkdLfYs
	 dlfutUE5oqOrSWgayPBOPqCRKYeymwqg0/h+JpaUHBADzSyQF27LflN2qabFvnqycV
	 PB2lbFI5Ou5lpZDU6orZvuAeZqSqcLHCup9t4KPJ2nAZo7oyPz9LE4JL4GDQxTubjw
	 GkTl4jxtHWHCFimI5LdHVvh7p6LTACfMLKaNi8uSgpHkK4jHhqNfYNUGY3m4Fqe0eo
	 4s6lH75cH3H4mgZAOwCkb7K3D+Sl0W4IRli9iza/HAhcA9wSSVmeOvcsGWeECrIKnI
	 SINjPiwmgjA5A==
Received: by mail-lf1-f53.google.com with SMTP id 2adb3069b0e04-5131c0691feso3411200e87.1
        for <dm-devel@lists.linux.dev>; Fri, 01 Mar 2024 20:14:59 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCW0uTZRAAtRy7zXHkFecFPLmuqAW2qyLbfygZq8qeLPv51BqbQqtROxJBAq4fIZ7qbX2mUrLBUKUACNnBXSYQuefd1OXEh5b0A=
X-Gm-Message-State: AOJu0YzD7eZH3uCpVkk9AhKFJx3BccMbiZA1rXXSTseAx4Yy2QfsOITd
	LpLVSdt4Q54XDYIb1lDpItNVSWJ154D1Hw8JB2jDTrJ0tJGuMEgqVp9iKJsdo2qJYncPnVGXMbH
	X3ORLrzZBf3zbFmvird/y744pT1I=
X-Google-Smtp-Source: AGHT+IGzEkC5phCMWP3/j+3P3V24f16c/9JVEIf7Pd9qN24XJAbpvsiezaeJP0xwK+jVMwA4q3BEa5NX2LLpUHf2eI8=
X-Received: by 2002:a19:6446:0:b0:512:fb30:aade with SMTP id
 b6-20020a196446000000b00512fb30aademr2447959lfj.3.1709352897565; Fri, 01 Mar
 2024 20:14:57 -0800 (PST)
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240228225653.947152-1-hch@lst.de> <170930853640.1084422.8284935730781819597.b4-ty@kernel.dk>
In-Reply-To: <170930853640.1084422.8284935730781819597.b4-ty@kernel.dk>
From: Song Liu <song@kernel.org>
Date: Fri, 1 Mar 2024 20:14:45 -0800
X-Gmail-Original-Message-ID: <CAPhsuW7c1dBJYP6=xG2z8_neODpM6bRuCKzNQ6H+zM1-EwGioQ@mail.gmail.com>
Message-ID: <CAPhsuW7c1dBJYP6=xG2z8_neODpM6bRuCKzNQ6H+zM1-EwGioQ@mail.gmail.com>
Subject: Re: (subset) atomic queue limit updates for stackable devices v3
To: Jens Axboe <axboe@kernel.dk>
Cc: Mike Snitzer <snitzer@kernel.org>, Mikulas Patocka <mpatocka@redhat.com>, 
	Yu Kuai <yukuai3@huawei.com>, Christoph Hellwig <hch@lst.de>, dm-devel@lists.linux.dev, 
	linux-block@vger.kernel.org, linux-raid@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Mar 1, 2024 at 7:55=E2=80=AFAM Jens Axboe <axboe@kernel.dk> wrote:
>
>
> On Wed, 28 Feb 2024 14:56:39 -0800, Christoph Hellwig wrote:
> > this series adds new helpers for the atomic queue limit update
> > functionality and then switches dm and md over to it.  The dm switch is
> > pretty trivial as it was basically implementing the model by hand
> > already, md is a bit more work.
> >
> > I've run the mdadm testsuite, and it has the same (rather large) number
> > of failures as the baseline, and the lvm2 test suite goes as far as
> > the baseline before handing in __md_stop_writes.
> >
> > [...]
>
> Applied, thanks!
>
> [01/14] block: add a queue_limits_set helper
>         commit: 631d4efb8009df64deae8c1382b8cf43879a4e22
> [02/14] block: add a queue_limits_stack_bdev helper
>         commit: c1373f1cf452e4c7553a9d3bc05d87ec15c4f85f
> [03/14] dm: use queue_limits_set
>         commit: 8e0ef412869430d114158fc3b9b1fb111e247bd3

For the set:

Reviewed-and-tested-by: Song Liu <song@kernel.org>
