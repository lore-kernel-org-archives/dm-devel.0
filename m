Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9EDBF135401
	for <dm-devel@lists.linux.dev>; Wed,  6 Mar 2024 17:27:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709746038; cv=none; b=jOePBtHu8J7qO9q+QgU/4ZNgXsi43cYBtGE4Htggsw5d+BAKOrewOHu02jI+RQyE3vZTMwJzqof5+6aLfHWExIcL6iEc2Q4uVUrRZdPkbgmjhGnITYiRBaEu4Lxe06leqVHKmST5oaApw7yYkiXKSEP4HGV9f5Nu/MY/DXrwzcw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709746038; c=relaxed/simple;
	bh=NXr0AnHeJ97mB7/cLYhgjSBhdHMvpbRYcBqUDM/Rcxg=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=bYJJpSqRfUlfzyxMKuZ80k71/lrztZwoD4c3ILpHo2LDbHCyFurJXyVg8V4UWj9/5WDad1zmko4UkTqXzell66eSCCpkSFhognXGWWsE68+xvLzg0cdU/bQwQDEUUfC7oP3F+rrD01MWSxNTjCbBs83hQPlPr+d6jByXm8Hrlzw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=aAvmeXFZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="aAvmeXFZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3ACE8C43390
	for <dm-devel@lists.linux.dev>; Wed,  6 Mar 2024 17:27:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1709746038;
	bh=NXr0AnHeJ97mB7/cLYhgjSBhdHMvpbRYcBqUDM/Rcxg=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=aAvmeXFZTMCSFMo8tueh0lySo+/H3qW1q88gVuWrTUqfcdoGg4ChCqnjZDAX0gOaK
	 ogtbS9VxYSXmMXjnwq+xbENT6Y5miMlgz+m0uuuqrO9oVpLtBYmwrN8GKwn8EMr/Yw
	 WijZibmq/j+lJB6yp4uaSJJfMalXr+SoPLpRGYuQNUonbPr2OPksYhxK5iubghP4Yq
	 5JVPZF3Dettyoyk1b3ZHYHfLA6IFHobB9AVSs8fNlMqkBmnVzAi/uhXH6KDWdY946i
	 PywyV96jvXpyTzl/cS7dveJh3OKumoX5I0Ltg88gEIjRY5r+H6ccRAYkI+hjdlhtLe
	 DjGUgQ0MijgoA==
Received: by mail-lf1-f41.google.com with SMTP id 2adb3069b0e04-51340e89df1so4792219e87.1
        for <dm-devel@lists.linux.dev>; Wed, 06 Mar 2024 09:27:18 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCUypMTiBzVQ7BUmKiQXaCeejDkuCTnFmSYWzZVsK9u9RUtQBp7kcP/+1Gq46c/E5XqzTOtPENkmWSiIle/XfDIYQSU99a/kVFk=
X-Gm-Message-State: AOJu0YwM9udHXZNtM4E592sIO/T6rb4uV/8TEoPKVPQT+pUHXgLAb5Yg
	d1C6q7b8/VL7BIVduQ9uYrIYdwHxv859jpAcAe+OxBAQ+CJDYX3iXAaTa5VJCWNUreuKGB4tOVF
	vSjdfxA7fnviPID4QqkS/8Ksy5cQ=
X-Google-Smtp-Source: AGHT+IEoGIeRZKhGAs5/mTEr+/WPXdIJNReO22W+FhvXB3BN0aift3eTu8KVTFOVIBGJRT7VKnE39JfEE5ocXmXXWu4=
X-Received: by 2002:a19:f014:0:b0:512:f892:4985 with SMTP id
 p20-20020a19f014000000b00512f8924985mr3568248lfc.0.1709746036370; Wed, 06 Mar
 2024 09:27:16 -0800 (PST)
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <1C22EE73-62D9-43B0-B1A2-2D3B95F774AC@fb.com> <Zehh9BvpfsG0tAEs@infradead.org>
In-Reply-To: <Zehh9BvpfsG0tAEs@infradead.org>
From: Song Liu <song@kernel.org>
Date: Wed, 6 Mar 2024 09:27:04 -0800
X-Gmail-Original-Message-ID: <CAPhsuW4jfcYqpoPGT8gtyZsuYjLsWodC8UM9pL0dtnc4GSoumQ@mail.gmail.com>
Message-ID: <CAPhsuW4jfcYqpoPGT8gtyZsuYjLsWodC8UM9pL0dtnc4GSoumQ@mail.gmail.com>
Subject: Re: [GIT PULL] md-6.9 20240305
To: Christoph Hellwig <hch@infradead.org>
Cc: Song Liu <songliubraving@meta.com>, Jens Axboe <axboe@kernel.dk>, 
	linux-raid <linux-raid@vger.kernel.org>, 
	"dm-devel@lists.linux.dev" <dm-devel@lists.linux.dev>, Xiao Ni <xni@redhat.com>, 
	Mike Snitzer <snitzer@kernel.org>, Yu Kuai <yukuai3@huawei.com>, 
	Yu Kuai <yukuai1@huaweicloud.com>, Benjamin Marzinski <bmarzins@redhat.com>, 
	Mikulas Patocka <mpatocka@redhat.com>, Junxiao Bi <junxiao.bi@oracle.com>, Dan Moulding <dan@danm.net>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Christoph,

On Wed, Mar 6, 2024 at 4:30=E2=80=AFAM Christoph Hellwig <hch@infradead.org=
> wrote:
>
> Hi Song,
>
> can you also send the queue limits changes on?  I'd really like to
> have all non-scsi queue limits updates in 6.9 and have been working
> hard on that.

Sure! Here it is.

Jens, could you please also pull the following changes.

This set by Christoph converts md to the atomic queue limits update API.

Thanks,
Song


The following changes since commit 3a889fdce7e8927a7d81d11ca3d26608b3be1c31=
:

  Merge branch 'dmraid-fix-6.9' into md-6.9 (2024-03-05 12:53:55 -0800)

are available in the Git repository at:

  https://git.kernel.org/pub/scm/linux/kernel/git/song/md.git
tags/md-6.9-20240306

for you to fetch changes up to dd27a84b06aa9ea6a94b0f3e59dc768f981962e1:

  block: remove disk_stack_limits (2024-03-06 08:59:54 -0800)

----------------------------------------------------------------
Christoph Hellwig (11):
      md: add a mddev_trace_remap helper
      md: add a mddev_add_trace_msg helper
      md: add a mddev_is_dm helper
      md: add queue limit helpers
      md/raid0: use the atomic queue limit update APIs
      md/raid1: use the atomic queue limit update APIs
      md/raid5: use the atomic queue limit update APIs
      md/raid10: use the atomic queue limit update APIs
      md: don't initialize queue limits
      md: remove mddev->queue
      block: remove disk_stack_limits

 block/blk-settings.c   |  24 --------
 drivers/md/md-bitmap.c |   9 +--
 drivers/md/md.c        |  89 +++++++++++++++++++++--------
 drivers/md/md.h        |  28 ++++++++-
 drivers/md/raid0.c     |  42 +++++++-------
 drivers/md/raid1.c     |  51 ++++++++---------
 drivers/md/raid10.c    |  85 ++++++++++++++-------------
 drivers/md/raid5-ppl.c |   3 +-
 drivers/md/raid5.c     | 174
+++++++++++++++++++++++++++-----------------------------
 include/linux/blkdev.h |   2 -
 10 files changed, 265 insertions(+), 242 deletions(-)
