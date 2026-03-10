Received: from mail-oa1-f47.google.com (mail-oa1-f47.google.com [209.85.160.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 625B63A6B77
	for <dm-devel@lists.linux.dev>; Tue, 10 Mar 2026 15:57:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.160.47
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773158222; cv=pass; b=hl/f8u9o2gvvkuKXbenH0f430SbjhUaZariZbG92v0RO70FnoNsd0hGPEolfv2qCBaxKTlj6u4WnkZywez37FRm5fMIDdbGi2yHVb4RQ7CGK4gUfqAk2zoCqBa3/DM0sIVKIB6RAl0I6tPq6PFWC3FXVXVYKymgaYB11mPB/UvU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773158222; c=relaxed/simple;
	bh=aZ3QAAiJWKfJPFdOqgfaghwjaxM2wYZxCugoj3b5jMM=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=HPkAb/94uLgk4gbGKSDaRZ+Rd+OMDdLEg4DaNPuurwEj1ZPeBJdMNvVb89TrYqHBKVxstHW8HFi/lABZvMpDWtsE8r583CUD2/8lkIAI1uawYSdZxmvkNUM3BKCc+RnvPR5695got8dJ9/1tXiMqful+cEUUaU89Y5bioScHhHw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=purestorage.com; spf=fail smtp.mailfrom=purestorage.com; dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b=Gzd2dwmQ; arc=pass smtp.client-ip=209.85.160.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=purestorage.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=purestorage.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b="Gzd2dwmQ"
Received: by mail-oa1-f47.google.com with SMTP id 586e51a60fabf-4170dc73280so308860fac.0
        for <dm-devel@lists.linux.dev>; Tue, 10 Mar 2026 08:57:01 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1773158220; cv=none;
        d=google.com; s=arc-20240605;
        b=G/qHAM1WNPTNTV0bZNF+qtb0VFF1xFXAwuAem81Kyj3YrYDKPIfqlUAfZRN60d+KMp
         AnvmWN+zUzNCmDyIksvZOyJ1+MhrjhgssAnjqpLpboozjVlqhJHx1brxZyNVdZWr4Ld9
         4CoXCT5WUVQ2K+10Xo4J5GcFi6WUDETD9ByMueNII+YOI5Ln0MQ0UUx/+Ig9Bf+7qK+r
         rzaI5DSd7HTpbYloBl3Mr2hpYH2LyBTDyafoRrUfIDPgb9S3Xy5Tqzy5/Wk/qShlFtT8
         jiBJrr4jE+G62e294L8H8XRyrn1X8OasVd1h0yj0tnYU2E5emzPKgtJcAkMFFkqFFWSp
         Yj1Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=k0ZfmdoKETAu32CUc6DaYZn/AQfT5ZtxxhfQJEgADr8=;
        fh=PEAU4bxlFnbGxuHxGl93nz1skwpb3v2LEDxZs2kM7Pk=;
        b=H/2tXDX+cUd859Rplx8B3evyP74v3XraWKvs+at4yZOk7ZG9uP/VhWAZpSFznhwJLo
         LWNEOaCyRgbB83/KhtuML2NvAMNuw5M8mdiggc28o1Y9SXLov2JlPv/df2wkQqznfJJ5
         DfHNxDKu04THdJyMoaP5ah0ERN6UtZaLAFE1aNlUmunjPhp3tPcVAy893JzkHaHgpF/G
         IjOkSW0pq/CUvgy9WdiAfc6/PvrqYh0mJu8NSTmenlqoznlxV7SryrLaUUZERSJUSWHQ
         Nd0nOjH/wG9FQk2kM0sZebhjPf5ML0YzzvJlUB5NrWyHSM8dA37+DR7bWrn3caHQezam
         SyHw==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=purestorage.com; s=google2022; t=1773158220; x=1773763020; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=k0ZfmdoKETAu32CUc6DaYZn/AQfT5ZtxxhfQJEgADr8=;
        b=Gzd2dwmQLiPFszNphY9ZzbUPyyRUUdG7N9o4ZcA9ef4hbGaHL8v15SWIviDvUxCW/3
         DH/ePZtnYvqq8QJHWbJvbA2Ht6c2InI+Flt8UKAh3jFvWjZHFuPz8MQXIvdN64d1+HGb
         uPRkjadLbDwVioP9irMQjxBYDlJTbvwoCLGNBUQ6gANwJln0g9IJu4PYM9ZJ/Tl7vnFR
         onf3URMO58CglJ7O+wWN6kQ3PXjXkcnTS5U+xrs5okqayHy+b2g5aVxrv2GkE12aumLQ
         d2LviAC0OaDoa6XaGL17uAYoGmCLJPwQ4bGLO986EqyEMoGPQTd8XfHs8r2nZwDZDWjg
         l/GA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1773158220; x=1773763020;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=k0ZfmdoKETAu32CUc6DaYZn/AQfT5ZtxxhfQJEgADr8=;
        b=G4UxmuVlGgTPkrq5sIcbqs4YYp4/aou+0q+rBc6epssXe7FyJkxxqbLjk0O9smP4hk
         hVjJ+0sTARuhzoheQe8o0EFdzLY6SKI3hlYoiEweM+ybkJ6SGn7rwsfCM0QoMyodSVJy
         g+/d1JMKjaAhL9U8dmx5a52numvtNRi7QyVXSkbATOQNMIls5fXEJKtHWfSZPNRySEai
         LoGDmU4at7OpHups2ZtybQen7s3ucYKNsDUqv9FyNtpbjp9NTNOXC2nwqrM5AdiCyxlb
         PWCj6EmgD5BFr1gVWjJ9plJLJ76wOggJMIOJ9Z8y0uVvir2kIhbNlp98Vouy4pV3uB0/
         pNvA==
X-Forwarded-Encrypted: i=1; AJvYcCVlVS8Vll75D+H7DacWAnz6mkflRyXM0cOOWhCqYIJmDKflCQUe7ziEcgUv9k4C8H8+k2/Hd1eR9g==@lists.linux.dev
X-Gm-Message-State: AOJu0YzzRXvNfiUzU6Nlv2uJFxO+yq1fN8kmoQmWRPwnUIlRzMMm5E7f
	pPYiag/61TT+UOSKDfr3+6OlD54n9nZI7cFYxTyjnqR1zb0EduD5JYzAzwaRmYTT7/cLGF6/nRT
	wPzzeKJ/ZVf4Rq1BiY7RRSGH9q+TGk3EVUon9GPucEg==
X-Gm-Gg: ATEYQzwWW2dQOx44cRMW9+u9KfIykcf70lxDbr17UY3wyTQPVbbyXAwM+sTrrWEri6E
	rorUrMCJH3nWYIOAIbQzVTBONgtPLM274UngiIjvYolsNAdoCZuC+geyYhZ+zdk9gbCxKVs3rga
	KNHXIs1q8+XTDOcO1GaSBZONG4HKwe2ZFVbZLMrI8lGXJBlgCjdfqIQkHH28gApnezvEOV5Kkaq
	kHKrX9yLnluos/YYn+aR6JJ1NSWJXGMpXLOn7tTbn2drOVvYYaNIW4nbOGq9rlJH/jyxL6kdOqS
	SDArmXlm
X-Received: by 2002:a05:6870:854b:b0:416:3f50:ea2 with SMTP id
 586e51a60fabf-416e45c1dc6mr7199342fac.8.1773158220092; Tue, 10 Mar 2026
 08:57:00 -0700 (PDT)
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260309062840.2937858-2-iam@sung-woo.kim> <CADUfDZorSQCVtQyfjBuaziwG2Jo28yZiiqLKbp9PkFFw-9VgfQ@mail.gmail.com>
 <CAJNyHp+i3M_ko7rhgTz=nxP=MZYM3oQf3L-y=7YnhnRyeUxayA@mail.gmail.com>
In-Reply-To: <CAJNyHp+i3M_ko7rhgTz=nxP=MZYM3oQf3L-y=7YnhnRyeUxayA@mail.gmail.com>
From: Caleb Sander Mateos <csander@purestorage.com>
Date: Tue, 10 Mar 2026 08:56:48 -0700
X-Gm-Features: AaiRm52sHfM1lLReXhJ6K_-eQeuNMsoWbyv4AHit6rY5_ursGYcV9eDpU-ihUic
Message-ID: <CADUfDZppWyOOPME0eJbmO1q+qvehxGiCk8Zz_nVxaQk08aukFw@mail.gmail.com>
Subject: Re: [PATCH] blk-mq: nvme: Fix general protection fault in nvme_setup_descriptor_pools()
To: Sungwoo Kim <iam@sung-woo.kim>
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

On Mon, Mar 9, 2026 at 4:55=E2=80=AFPM Sungwoo Kim <iam@sung-woo.kim> wrote=
:
>
> On Mon, Mar 9, 2026 at 11:31=E2=80=AFAM Caleb Sander Mateos
> <csander@purestorage.com> wrote:
> >
> > On Sun, Mar 8, 2026 at 11:30=E2=80=AFPM Sungwoo Kim <iam@sung-woo.kim> =
wrote:
> > >
> > > The numa_node can be < 0 since NUMA_NO_NODE =3D -1. However,
> > > struct blk_mq_hw_ctx{} defines numa_node as unsigned int. As a result=
,
> > > numa_node is set to UINT_MAX for NUMA_NO_NODE in blk_mq_alloc_hctx().
> >
> > The node argument to blk_mq_alloc_hctx() comes from
> > blk_mq_alloc_and_init_hctx(), which is called by
> > blk_mq_alloc_and_init_hctx() with int node =3D blk_mq_get_hctx_node(set=
,
> > i). node =3D NUMA_NO_NODE would suggest that blk_mq_hw_queue_to_node()
> > doesn't find any CPU affinitized to the queue. Is that even possible?
>
> Thanks for your review, Celeb.

While I'm flattered you consider me a celebrity, my name is Caleb :)

>
> blk_mq_hw_queue_to_node() can return NUMA_NO_NODE if the device queues
> exceed the
> number of CPUs. Afterward, it is adjusted on the caller side to
> numa_node =3D set->numa_node.

I thought the NVMe driver capped the number of queues so every queue
is affinitized to some CPU (see nvme_max_io_queues()). What am I
missing?

Best,
Caleb

>
> set->numa_node can still be NUMA_NO_NODE if CONFIG_NUMA=3Dn (trivial) or
> pcibus_to_node() returns NUMA_NO_NODE if ACPI doesn't provide
> proximity information.
> But I'm not sure if this is usual in the real machines. We found the
> crash in QEMU.
>
> > >  static struct nvme_descriptor_pools *
> > > -nvme_setup_descriptor_pools(struct nvme_dev *dev, unsigned numa_node=
)
> > > +nvme_setup_descriptor_pools(struct nvme_dev *dev, int numa_node)
> > >  {
> > > -       struct nvme_descriptor_pools *pools =3D &dev->descriptor_pool=
s[numa_node];
> > > +       struct nvme_descriptor_pools *pools;
> > >         size_t small_align =3D NVME_SMALL_POOL_SIZE;
> > >
> > > +       if (numa_node =3D=3D NUMA_NO_NODE)
> > > +               pools =3D &dev->descriptor_pools[numa_node_id()];
> > > +       else
> > > +               pools =3D &dev->descriptor_pools[numa_node];
> >
> > Simpler: if (numa_node =3D=3D NUMA_NO_NODE) numa_node =3D numa_node_id(=
);
> >
>
> Thanks, I will modify it in V2.
>
> Sungwoo.
