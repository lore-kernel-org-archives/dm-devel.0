Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 68D9314EFD4
	for <dm-devel@lists.linux.dev>; Tue, 27 Feb 2024 21:55:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709070904; cv=none; b=D7I4KwFDYswn5UPMp2gpuFWP2u8R8faJyeA1bfvagHFdeOry6bEviW7/Ij0JAOAgwEpuCVbNIS5VUVmDIaU7Ik7mXvto07iTTVEzwQVuYtbhLO2joYnPiLGyt1lVKQlntC/jYNPQGdhHi2d1kAPZLNVWR8yjewKJ/hjEzUhcxCI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709070904; c=relaxed/simple;
	bh=3/RfPqLDBq2vduXCxtn+wVcLC2MeaCqjWafrmlfzQ8Y=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=d8aUoEyuh5pC7eHbropJT110zd0uEIe4dThl/effuj3NKiCk+hcukY55xJ1oKOfbE3a2BeH/srRjDUNPN5GhQlUJDYcDJuduol2jvyXx3VHXMUtfe8NEDmDrTedlH+mhrQ/uX8fE1qt4Hq5wOScHHpF007JwqOPYoZOAukZqFxE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=jpGMil46; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="jpGMil46"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 00298C433F1
	for <dm-devel@lists.linux.dev>; Tue, 27 Feb 2024 21:55:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1709070904;
	bh=3/RfPqLDBq2vduXCxtn+wVcLC2MeaCqjWafrmlfzQ8Y=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=jpGMil46p6GqVRZCu84P+c06uHDWgOH12QdM4jaCSQ0ockAS3EaabTLyUuqwTYmw4
	 OC2mOJkEOmE8hhOLCme6nd7zNX0NGRDfFTrPNdjnYGgkJILslvSp7h7ty1C/pXTv1D
	 PHvU53csggehUlFV1fZzocZRwLOyLWXfovNfwvzTCYN4aWnf6VSc9WuQ+n+YqY0SJ2
	 zMSQq+eOrGl1tN0d+HEvHitFV6hcdHAcJ4VCYEoU/RWPTa+8OWjLrbGrsR3BVMzDTE
	 5PGYiD3RNhruSer6bb6QDb155wghQWExyniiLl3g4wHvRc6r5bUKp6t/1aqxjC4GgV
	 Pscn9B/HILXDg==
Received: by mail-lf1-f47.google.com with SMTP id 2adb3069b0e04-512f6f263a6so2939972e87.2
        for <dm-devel@lists.linux.dev>; Tue, 27 Feb 2024 13:55:03 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCW1cG6oxIi7SlGVaJf93iwBiew5pkWYBG3eE2egaK3Yoda2oUVlHFfGu22ps9T7AhIWUvWF+aByO6U2TtO6EschtIbzVnqKYdE=
X-Gm-Message-State: AOJu0YxahxK1yYwQ1d53ucqLjRxLxpYJ2gxZYRu3tGEPTCFkHpc6TndV
	GjFAndzaUqP5Nc3AAQISO7nX4QWwpmHHG7XkbP/266OufkJZtIEC+rNmltW16BQMs0+Qk3EpwMk
	8zDINCOpydXZe1y1SxYhbIXI6R/Y=
X-Google-Smtp-Source: AGHT+IHPxa2DdiuJIouYc51MEi39KJBs69dc432JIqCMoP62t/zoip/3+rIeVMh1JnR4ItsfvwyijLn41RUlo5ksKEw=
X-Received: by 2002:ac2:46ee:0:b0:513:124:b36 with SMTP id q14-20020ac246ee000000b0051301240b36mr3668098lfo.29.1709070902249;
 Tue, 27 Feb 2024 13:55:02 -0800 (PST)
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240226103004.281412-1-hch@lst.de> <20240226103004.281412-7-hch@lst.de>
 <b4828284-87ec-693b-e2c3-84bdafcbda65@huaweicloud.com> <20240227152609.GA14782@lst.de>
In-Reply-To: <20240227152609.GA14782@lst.de>
From: Song Liu <song@kernel.org>
Date: Tue, 27 Feb 2024 13:54:50 -0800
X-Gmail-Original-Message-ID: <CAPhsuW5xaK=WR1RKGpYkSzHW8TOMbUwY-KeTD=kD3otQFZZV0Q@mail.gmail.com>
Message-ID: <CAPhsuW5xaK=WR1RKGpYkSzHW8TOMbUwY-KeTD=kD3otQFZZV0Q@mail.gmail.com>
Subject: Re: [PATCH 06/16] md/raid1: use the atomic queue limit update APIs
To: Christoph Hellwig <hch@lst.de>
Cc: Yu Kuai <yukuai1@huaweicloud.com>, Jens Axboe <axboe@kernel.dk>, 
	Mike Snitzer <snitzer@kernel.org>, Mikulas Patocka <mpatocka@redhat.com>, 
	Philipp Reisner <philipp.reisner@linbit.com>, Lars Ellenberg <lars.ellenberg@linbit.com>, 
	=?UTF-8?Q?Christoph_B=C3=B6hmwalder?= <christoph.boehmwalder@linbit.com>, 
	drbd-dev@lists.linbit.com, dm-devel@lists.linux.dev, 
	linux-block@vger.kernel.org, linux-raid@vger.kernel.org, 
	"yukuai (C)" <yukuai3@huawei.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Feb 27, 2024 at 7:26=E2=80=AFAM Christoph Hellwig <hch@lst.de> wrot=
e:
>
> On Mon, Feb 26, 2024 at 07:29:08PM +0800, Yu Kuai wrote:
> > Hi,
> >
> > =E5=9C=A8 2024/02/26 18:29, Christoph Hellwig =E5=86=99=E9=81=93:
> >> Build the queue limits outside the queue and apply them using
> >> queue_limits_set.  Also remove the bogus ->gendisk and ->queue NULL
> >> checks in the are while touching it.
> >
> > The checking of mddev->gendisk can't be removed, because this is used t=
o
> > distinguish dm-raid and md/raid. And the same for following patches.
>
> Ah.  Well, we should make that more obvious then.  This is what I
> currently have:
>
> http://git.infradead.org/?p=3Dusers/hch/block.git;a=3Dshortlog;h=3Drefs/h=
eads/md-blk-limits
>
> particularly:
>
> http://git.infradead.org/?p=3Dusers/hch/block.git;a=3Dcommitdiff;h=3D24b2=
fd15f57f06629d2254ebec480e1e28b96636

Yes! I was thinking about something like mddev_is_dm() to make these
checks less confusing. Thanks!

Song
