Received: from mail-ej1-f41.google.com (mail-ej1-f41.google.com [209.85.218.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5372B26ED5D
	for <dm-devel@lists.linux.dev>; Wed, 11 Mar 2026 01:15:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773191712; cv=none; b=fdDAwOgh70eG664gT4LqjSwOr9LmB1MtQ24VZuuyUwXrBThL83r2ReKnEmkD1izHocvfhFQDS+GukfVvv6UgKNJVWm4ydHZbBAQE2bDUq0mH85xLxQV6ixK8H+Lv582nFpjhfOTGUAraJoXUjNeNpf5vWEFeKpwNgQKGIss3I24=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773191712; c=relaxed/simple;
	bh=/oF/doq6oyWwDTCyW1l4hS1E5POtzgyvQYrb/7hmVZg=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=PMe28gpVNDKJrYk5f+zoFjLeEXlZBduD6NdOHS/FfvbcWknGgL3yTGnFhOTEXLY7iG1odUeo+rfQ4jcxaA4WffRsrNX3AQS3PjwZ3IUZ06N4n0+XabSFXlT26Ovx0/faAu9v3YntiR6ywlHO7axqI1oF0fgJ6EbV9A2QGRTYqtM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=sung-woo.kim; spf=pass smtp.mailfrom=gmail.com; arc=none smtp.client-ip=209.85.218.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=sung-woo.kim
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ej1-f41.google.com with SMTP id a640c23a62f3a-b96dc65b886so77451266b.0
        for <dm-devel@lists.linux.dev>; Tue, 10 Mar 2026 18:15:11 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1773191709; x=1773796509;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=/oF/doq6oyWwDTCyW1l4hS1E5POtzgyvQYrb/7hmVZg=;
        b=EW9e1qQLw8Lw3k1OqkttxtisyKXUd4eUpVfbf4wdq9hz/TYYPW/mbkSuS7vJbyc0kJ
         /fo+pv+2Q1S98cJSJMBzfNfpWYX7gTBY3yqPxO4Upb9y4Kb0aZJEJXYm5AwTAmnswGSg
         WeHHAyrj61i9cLiIyLsyiZNZSSsjzwzzuAT/aMRtqgneQaUyWM5ftUeOqGysHMhhhx7w
         e9CsQrlb+vBCTl4bccvTlqCpRWrMxRHotxXFaaE70qSd4s6srgBrQGPdqlAM6ocgHNZ+
         Og/EH5/+3MD++c2K+xGNY77Lv2rcHkJowffpvsDmgJlz+QOUIXBmJZYcEzMMkLrEP8ON
         0WdA==
X-Forwarded-Encrypted: i=1; AJvYcCUbTfaP5WwgK5OFsoTjG3nhhofD43YPqoaQc0fM0n3r9Gt8OLMeiQcU6WNuMRNp0OUPDEYUNZKVfw==@lists.linux.dev
X-Gm-Message-State: AOJu0YzIJ3gk2b28+JoVm8gUvpTtbJp2N4vBpDzEnUkeb7qGGXoaSFJH
	7+XjbDwUAP0KMogqNfu5PGgXJywhBKyuRIoVO1DPPRJT0Ezweyptl28+BGyx1ldTvsg=
X-Gm-Gg: ATEYQzxSSv7+BA1VZmztCW+/mcmgkUOTjdNOFYAyaG+fl2/1r+uQjNvMQoM0SNIat7+
	yynYo4iUII1Uu+4ewClE9Or6Q+r/xwxNT8QocFQXZ7PvVHiuEJezuoj0mvZ2mmumuVKrymHWJBr
	PMynollQTAXVd4h9H2FrTC1UMXDQIYeCu8Ccr6tEG98i3yv3XtHICbRkc5RLvNLgPulDgNK7Mtt
	gi7n98bSGnVSkgQ/pYJw//J33vPglRm/WALyg/sh32urbKAITd9IrjhEDJxj6fM8UI/L7RNzQ8Z
	iFdsrW0GsW/5mmSMxymanNm5wu336SVDwY/ATJ2MmEYpSkI8IW4uFD+0itvheNqlAlbg35xZpKi
	TWfWR9tsNWVnjy6ikgCT/07y4GigfwNd4gOT1u044fIeeqI14B+q3rCPUv/VEPqvnIp6oxbIdNs
	BUh6FtSXwA2IRMDg9z23ycQELc+76X4Oo/EBAmStm8M0iwI9I3hhE4e5o=
X-Received: by 2002:a17:907:7211:b0:b8f:d2a0:c283 with SMTP id a640c23a62f3a-b972d3cf087mr34611966b.1.1773191709486;
        Tue, 10 Mar 2026 18:15:09 -0700 (PDT)
Received: from mail-wr1-f41.google.com (mail-wr1-f41.google.com. [209.85.221.41])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-b97313230desm5065266b.26.2026.03.10.18.15.08
        for <dm-devel@lists.linux.dev>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 10 Mar 2026 18:15:09 -0700 (PDT)
Received: by mail-wr1-f41.google.com with SMTP id ffacd0b85a97d-439bc14dcf4so330579f8f.1
        for <dm-devel@lists.linux.dev>; Tue, 10 Mar 2026 18:15:08 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCUckiW57KhvPI1JyY3lO8DEhGzJlJE97pxi6jvxiilta89UVrtnyW6JSrVrT5wzXNXuF/hi1E1wXA==@lists.linux.dev
X-Received: by 2002:a5d:5d05:0:b0:439:bb46:7457 with SMTP id
 ffacd0b85a97d-439eff518c7mr10359487f8f.16.1773191708627; Tue, 10 Mar 2026
 18:15:08 -0700 (PDT)
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260309062840.2937858-2-iam@sung-woo.kim> <CADUfDZorSQCVtQyfjBuaziwG2Jo28yZiiqLKbp9PkFFw-9VgfQ@mail.gmail.com>
 <CAJNyHp+i3M_ko7rhgTz=nxP=MZYM3oQf3L-y=7YnhnRyeUxayA@mail.gmail.com> <CADUfDZppWyOOPME0eJbmO1q+qvehxGiCk8Zz_nVxaQk08aukFw@mail.gmail.com>
In-Reply-To: <CADUfDZppWyOOPME0eJbmO1q+qvehxGiCk8Zz_nVxaQk08aukFw@mail.gmail.com>
From: Sungwoo Kim <iam@sung-woo.kim>
Date: Tue, 10 Mar 2026 21:14:52 -0400
X-Gmail-Original-Message-ID: <CAJNyHpLU7sTJRtDqTbczTz0iayj-Nm8bPHrPaOcsKVb6nQyw1A@mail.gmail.com>
X-Gm-Features: AaiRm51cz7xo1V1erpi09gKFdY9TTILawmEFCzQE55oadwxdss7qBUImRUPZq3I
Message-ID: <CAJNyHpLU7sTJRtDqTbczTz0iayj-Nm8bPHrPaOcsKVb6nQyw1A@mail.gmail.com>
Subject: Re: [PATCH] blk-mq: nvme: Fix general protection fault in nvme_setup_descriptor_pools()
To: Caleb Sander Mateos <csander@purestorage.com>
Cc: Jens Axboe <axboe@kernel.dk>, Josef Bacik <josef@toxicpanda.com>, 
	Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@kernel.org>, 
	Mikulas Patocka <mpatocka@redhat.com>, dm-devel@lists.linux.dev, 
	Ulf Hansson <ulf.hansson@linaro.org>, Richard Weinberger <richard@nod.at>, 
	Miquel Raynal <miquel.raynal@bootlin.com>, Vignesh Raghavendra <vigneshr@ti.com>, 
	Hector Martin <marcan@marcan.st>, Sven Peter <sven@svenpeter.dev>, 
	Alyssa Rosenzweig <alyssa@rosenzweig.io>, Keith Busch <kbusch@kernel.org>, Christoph Hellwig <hch@lst.de>, 
	Sagi Grimberg <sagi@grimberg.me>, James Smart <james.smart@broadcom.com>, 
	Chaitanya Kulkarni <kch@nvidia.com>, "James E.J. Bottomley" <jejb@linux.ibm.com>, 
	"Martin K. Petersen" <martin.petersen@oracle.com>, Chao Shi <cshi008@fiu.edu>, 
	Weidong Zhu <weizhu@fiu.edu>, Dave Tian <daveti@purdue.edu>, linux-block@vger.kernel.org, 
	linux-kernel@vger.kernel.org, nbd@other.debian.org, linux-mmc@vger.kernel.org, 
	linux-mtd@lists.infradead.org, asahi@lists.linux.dev, 
	linux-arm-kernel@lists.infradead.org, linux-nvme@lists.infradead.org, 
	linux-scsi@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Mar 10, 2026 at 11:57=E2=80=AFAM Caleb Sander Mateos
<csander@purestorage.com> wrote:
>
> On Mon, Mar 9, 2026 at 4:55=E2=80=AFPM Sungwoo Kim <iam@sung-woo.kim> wro=
te:
> >
> > On Mon, Mar 9, 2026 at 11:31=E2=80=AFAM Caleb Sander Mateos
> > <csander@purestorage.com> wrote:
> > >
> > > On Sun, Mar 8, 2026 at 11:30=E2=80=AFPM Sungwoo Kim <iam@sung-woo.kim=
> wrote:
> > > >
> > > > The numa_node can be < 0 since NUMA_NO_NODE =3D -1. However,
> > > > struct blk_mq_hw_ctx{} defines numa_node as unsigned int. As a resu=
lt,
> > > > numa_node is set to UINT_MAX for NUMA_NO_NODE in blk_mq_alloc_hctx(=
).
> > >
> > > The node argument to blk_mq_alloc_hctx() comes from
> > > blk_mq_alloc_and_init_hctx(), which is called by
> > > blk_mq_alloc_and_init_hctx() with int node =3D blk_mq_get_hctx_node(s=
et,
> > > i). node =3D NUMA_NO_NODE would suggest that blk_mq_hw_queue_to_node(=
)
> > > doesn't find any CPU affinitized to the queue. Is that even possible?
> >
> > Thanks for your review, Celeb.
>
> While I'm flattered you consider me a celebrity, my name is Caleb :)

My apologies, Caleb. I'll be more careful.

>
> >
> > blk_mq_hw_queue_to_node() can return NUMA_NO_NODE if the device queues
> > exceed the
> > number of CPUs. Afterward, it is adjusted on the caller side to
> > numa_node =3D set->numa_node.
>
> I thought the NVMe driver capped the number of queues so every queue
> is affinitized to some CPU (see nvme_max_io_queues()). What am I
> missing?
>
> Best,
> Caleb

You are right, every hw queue should be affinitized. It seems I'm
missing a lot. I'll look into the reasons and get back with V2.

I appreciate your review again.

Sungwoo.
