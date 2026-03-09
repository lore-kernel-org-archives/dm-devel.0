Received: from mail-ej1-f54.google.com (mail-ej1-f54.google.com [209.85.218.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 139EB3793D7
	for <dm-devel@lists.linux.dev>; Mon,  9 Mar 2026 23:55:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773100507; cv=none; b=h7XLDdgIc7tRvjLfJslyFdgnqoUah+mYH5/0XeAj/4GrEKlvhsYbXb5ITvRIm7Nxuo+p0rnx/j0X/V8DDJ1XkLpts2NyiCiG1Pb5GWhMDsZGiF8Ppx1aRVRop64iGlkr3Pp1oMRExWKh/fSrs8v6UsT8IpFvm8mFUKTNyFYLK38=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773100507; c=relaxed/simple;
	bh=6Vofe/6ZWdzfe1bQhwcok7tc5hua1lVSK0g1U2J3b8Y=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=My9Qo3NkBxiN9m6kkA4EI13zbzwjfDFc6FTQbt/KYpOQrU69c9AZT9NXmabARGziDU+swww6XImNqwVhIrXxAIb0axlvdU/95UQb2Qujfu1JchObPhnFBAX7RjxYf0ByShsXyir8lo9IVEWGBx3V5C53NlYJl9HaeVj62i6uxns=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=sung-woo.kim; spf=pass smtp.mailfrom=gmail.com; arc=none smtp.client-ip=209.85.218.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=sung-woo.kim
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ej1-f54.google.com with SMTP id a640c23a62f3a-b940f962a82so765428566b.2
        for <dm-devel@lists.linux.dev>; Mon, 09 Mar 2026 16:55:05 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1773100504; x=1773705304;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=wUJ62UzriDRExITrg9iBzNvEWYzDINBTrPfASD/nLws=;
        b=HLmeXOKI+5tQq4LndyAma/2uY8k8Azbgd5sLrXvhgzrMnNvDEnKKFzkdYijggv/Jqp
         /WVbeS4wlhGLRxGKG/mp38QhJ4s5v9szabZBV+m0rcFH6wL1j+AjY4GpC+c4CpGHCMjv
         5ic9Q7/CC9STG/3RVt8TSqJArz+FW/LHJmPVBkgLe2aSmWN8V1t87aqJw7JCCOQfIseK
         3t4rFI/ORel9z9xAqVtYOPbmjIu3V4CISB8LeH3XVilSUSr4RBF1DBC4S3JgDcpx+8uh
         LCFurGF5AiNvquC6+tZpCOG98cRfhoZToXV9cFUyApC/6IC4CVXeKNOEoPiF07ZPoYwL
         Njbw==
X-Forwarded-Encrypted: i=1; AJvYcCUJxFNBLcr0st9r3tuPzfOEpb0F6N1d9HqULEeaUOj5W0YiRQCpx7EWG3UxVmAVK0C1T7sXzPjlcg==@lists.linux.dev
X-Gm-Message-State: AOJu0Yx1+p1BH5XypB95UY5Oz0APqgwstK8a/2lO+jlIAxrB7UPz5PVv
	Cfo6ZPcA9Oew0qnA8EqICzg8zm/m3xciqErO6c6RxEc2UAvr8HKv975RLLN9FMR6cU8=
X-Gm-Gg: ATEYQzwPmrbpS5Qi8O7+M2kFWjUk18WzVKyjC4sX/IftK28nrZDzeteTs/oPFRfg4vT
	UKRrnU96EVQikbm8tpbX8V2T6hXMvYtBda44MY83IqMRz9QOhZiLlkcu3QTMZy5goGTO3UGvj+O
	6JzKizPbM9Crqf7r3NsfjB/poPfwabkcOTi8D1V3KyVpunAnXFhbM0MDKNu1XuU4vWBOghYpezh
	dDhxEsS/kWpKsfRbLQUhHVTJCVj4nOfaxNn76kPHl25zxGXqH8vESkLEoGaM4z6TIyNhpjkFOBD
	x0dl3Z2XmGc66YzlFEf0nHVcd2XA3vb/xD7DXUVtERd7HBOV/x0QhUO941utiyoWZUToIsdt+MC
	2KxNM32qnrmRvPqKXXkchnoXJKRRMdvzE8+hw0EjjCBMMjTsR/0Em93YCyeS5JSuLPwKVBTvU0D
	GxAv0Z2kJAyTJ3c/ErjI182yLhJccTq1nxWYO829EH8rkK3dncYd7yJog=
X-Received: by 2002:a17:907:fd18:b0:b93:c5a9:a5e8 with SMTP id a640c23a62f3a-b942da4ba28mr747024466b.7.1773100504309;
        Mon, 09 Mar 2026 16:55:04 -0700 (PDT)
Received: from mail-wr1-f47.google.com (mail-wr1-f47.google.com. [209.85.221.47])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-b942ef8b67dsm419029566b.15.2026.03.09.16.55.03
        for <dm-devel@lists.linux.dev>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 09 Mar 2026 16:55:04 -0700 (PDT)
Received: by mail-wr1-f47.google.com with SMTP id ffacd0b85a97d-439ce3605ecso3532037f8f.0
        for <dm-devel@lists.linux.dev>; Mon, 09 Mar 2026 16:55:03 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCUZxoITXK6eK3RADfFSObuLt4wHE9OtE8XH+AZPZkrXnJ469pYTbyRLcJ/cJJ7ogB+VrHfXSbXKow==@lists.linux.dev
X-Received: by 2002:a05:6000:144b:b0:439:ac33:5082 with SMTP id
 ffacd0b85a97d-439da66b72cmr23928350f8f.26.1773100503051; Mon, 09 Mar 2026
 16:55:03 -0700 (PDT)
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260309062840.2937858-2-iam@sung-woo.kim> <CADUfDZorSQCVtQyfjBuaziwG2Jo28yZiiqLKbp9PkFFw-9VgfQ@mail.gmail.com>
In-Reply-To: <CADUfDZorSQCVtQyfjBuaziwG2Jo28yZiiqLKbp9PkFFw-9VgfQ@mail.gmail.com>
From: Sungwoo Kim <iam@sung-woo.kim>
Date: Mon, 9 Mar 2026 19:54:47 -0400
X-Gmail-Original-Message-ID: <CAJNyHp+i3M_ko7rhgTz=nxP=MZYM3oQf3L-y=7YnhnRyeUxayA@mail.gmail.com>
X-Gm-Features: AaiRm53vE5uEinTHUYE1aa6bIvdkwyOpz0dn9fOlsjLR4PN8Z_3w05vllGJ47mw
Message-ID: <CAJNyHp+i3M_ko7rhgTz=nxP=MZYM3oQf3L-y=7YnhnRyeUxayA@mail.gmail.com>
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

On Mon, Mar 9, 2026 at 11:31=E2=80=AFAM Caleb Sander Mateos
<csander@purestorage.com> wrote:
>
> On Sun, Mar 8, 2026 at 11:30=E2=80=AFPM Sungwoo Kim <iam@sung-woo.kim> wr=
ote:
> >
> > The numa_node can be < 0 since NUMA_NO_NODE =3D -1. However,
> > struct blk_mq_hw_ctx{} defines numa_node as unsigned int. As a result,
> > numa_node is set to UINT_MAX for NUMA_NO_NODE in blk_mq_alloc_hctx().
>
> The node argument to blk_mq_alloc_hctx() comes from
> blk_mq_alloc_and_init_hctx(), which is called by
> blk_mq_alloc_and_init_hctx() with int node =3D blk_mq_get_hctx_node(set,
> i). node =3D NUMA_NO_NODE would suggest that blk_mq_hw_queue_to_node()
> doesn't find any CPU affinitized to the queue. Is that even possible?

Thanks for your review, Celeb.

blk_mq_hw_queue_to_node() can return NUMA_NO_NODE if the device queues
exceed the
number of CPUs. Afterward, it is adjusted on the caller side to
numa_node =3D set->numa_node.

set->numa_node can still be NUMA_NO_NODE if CONFIG_NUMA=3Dn (trivial) or
pcibus_to_node() returns NUMA_NO_NODE if ACPI doesn't provide
proximity information.
But I'm not sure if this is usual in the real machines. We found the
crash in QEMU.

> >  static struct nvme_descriptor_pools *
> > -nvme_setup_descriptor_pools(struct nvme_dev *dev, unsigned numa_node)
> > +nvme_setup_descriptor_pools(struct nvme_dev *dev, int numa_node)
> >  {
> > -       struct nvme_descriptor_pools *pools =3D &dev->descriptor_pools[=
numa_node];
> > +       struct nvme_descriptor_pools *pools;
> >         size_t small_align =3D NVME_SMALL_POOL_SIZE;
> >
> > +       if (numa_node =3D=3D NUMA_NO_NODE)
> > +               pools =3D &dev->descriptor_pools[numa_node_id()];
> > +       else
> > +               pools =3D &dev->descriptor_pools[numa_node];
>
> Simpler: if (numa_node =3D=3D NUMA_NO_NODE) numa_node =3D numa_node_id();
>

Thanks, I will modify it in V2.

Sungwoo.
