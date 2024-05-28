Received: from mail-vk1-f180.google.com (mail-vk1-f180.google.com [209.85.221.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 67D5917E8E4
	for <dm-devel@lists.linux.dev>; Tue, 28 May 2024 03:48:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716868099; cv=none; b=WrdR1kpqJiNb03wRqo297ir5fA+OTJsOyRhG+1KxeQX8cwd6azY4Fki9XB1N5eK1OXgCCDCi2QX7tjdZ4NkVUL69I6WnCRJGC8r5gZ2dfkCVgMCgI1mrZXmgkbnaUBpMJyNOi4OVYkCQQGAMD7DR61i2DgxJhJzWzuhtlUuw7IQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716868099; c=relaxed/simple;
	bh=yyeBDjI04HvU5PJEMYDx4SQI7kbJQ7UbZoy41Jy4YF0=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=KksJP5KNWPJ1qlJ7esdY1zrjdBiPHfwlfofms1ZU5W5Q7Mt25OrEtCzHZavPiPcxJ/EVVnoGZ2ye/0P0MsWmISaEK56aGxyektswt2UtBIhV2FRP+LQNbNG+U8wotcsSdTv9gWFPjmOYuE5lTE3tk/csagYUPD1+q/ylozqgoMM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Ql8zNILN; arc=none smtp.client-ip=209.85.221.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Ql8zNILN"
Received: by mail-vk1-f180.google.com with SMTP id 71dfb90a1353d-4e4efbc3218so150616e0c.0
        for <dm-devel@lists.linux.dev>; Mon, 27 May 2024 20:48:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1716868097; x=1717472897; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=tMwY3jSjxqwMDaKFlhd/s9pzladNU9TjXZV/5WHBypU=;
        b=Ql8zNILNskt4QBoRQYYqsmfyI07dz50LOtJnogkUI2cM7aMDWdzrCqF5dxRSpNhyeg
         yGqaxrFP+CakjSao2/KYPaxOMZVTtHoSz1wPqc22n5VNne/LNaGTUZRVK+f3keekYow+
         Y79UK2+7dVlTAkWLBcVJOZR8bmxYz+yZHllAa1G6fsckDbzB/OiSB2QvOPwofmphP/MA
         FkeSGrB8VDHPLdFdqT1E+DMPzWXRcJ/PvsbMhvS6oBRKBqGp379uZh9mMP3rPDQ0zQHs
         VGqLeNu6yhmXBPL8DeorCAdf1VrXAvwciKI7EVhteXmT52eupr6Pf5HALa4AgpnQ5KoG
         rjXw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1716868097; x=1717472897;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=tMwY3jSjxqwMDaKFlhd/s9pzladNU9TjXZV/5WHBypU=;
        b=G5Hfwt8Ecw91WEAueWpn7/fBXxubUtkqz25Vv7gWxjG8Ub+nhpLrqF1zHcCMlkv50Y
         yFzFDywWE7vpKTwhroj1nxJvgyWFmrS46IXZsLwbqv7LnIkYFkzXWEWkIpx3NyuOK0HF
         F3qObsyxn3CcLD+t1LBDrGBtHW6PAm05TJ7Gwz1iR56jgUzLErJkDePR5abw+HIC4DA5
         s7YR13aJT5d9rz/qqvYGgyftqP3dNoF6e3mzgAjen7FUw31huaRWXdCJTU+vcP+bstKd
         vgME/kwPtHl+0zW6KClUcj7MxWTwiYtWIqv5iT453u4mIYA+HwpaIFb8j12ibgv/jQTS
         SAKA==
X-Forwarded-Encrypted: i=1; AJvYcCUxB18fD4ImgiVhn40fDycelq8nITtXQtYbiHmeVDXEwD5ziOWN21VSg8V1zBYznJc/g2nq6vCHxwRJ/0bGtsY+fPmx2pIAvFE=
X-Gm-Message-State: AOJu0Yyqb1JbnBg0N2YrnAzn6qq2dQZTgKtH26mTlnJYQ4QoC/jRWLRg
	TkS0wXEDzR5Hd5lrF9B4lVf2jzEfm8ZDKmRV/uRsCaw/frhQAfW+lw9xmIJNoMXV+i4mW9Ce6nq
	ZImVX8x26UPEfs+NO1LGsfZRVrw==
X-Google-Smtp-Source: AGHT+IEebTthiV+k9KwZYbfA6UqXjceghKuE5RhC9df1UxBYQNbJVxSNh4yrualQ39ZzH38xtnqX/A3NTiH2tP5u528=
X-Received: by 2002:a05:6122:3c54:b0:4e4:e998:bf88 with SMTP id
 71dfb90a1353d-4e4f02e3f3dmr10489613e0c.13.1716868097258; Mon, 27 May 2024
 20:48:17 -0700 (PDT)
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <719d2e-b0e6-663c-ec38-acf939e4a04b@redhat.com> <49d1afaa-f934-6ed2-a678-e0d428c63a65@redhat.com>
In-Reply-To: <49d1afaa-f934-6ed2-a678-e0d428c63a65@redhat.com>
From: Anuj gupta <anuj1072538@gmail.com>
Date: Tue, 28 May 2024 09:17:40 +0530
Message-ID: <CACzX3AvanzKyVFsyWOLyQMXo8oYOX=fggPaW_Uej+KUNfhMmFA@mail.gmail.com>
Subject: Re: [PATCH 1/2 v4] block: change rq_integrity_vec to respect the iterator
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: Axboe <axboe@kernel.dk>, Keith Busch <kbusch@kernel.org>, Christoph Hellwig <hch@lst.de>, 
	Sagi Grimberg <sagi@grimberg.me>, Mike Snitzer <snitzer@kernel.org>, Milan Broz <gmazyland@gmail.com>, 
	linux-block@vger.kernel.org, dm-devel@lists.linux.dev, 
	linux-nvme@lists.infradead.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, May 27, 2024 at 9:10=E2=80=AFPM Mikulas Patocka <mpatocka@redhat.co=
m> wrote:
>
> If we allocate a bio that is larger than NVMe maximum request size,
> attach integrity metadata to it and send it to the NVMe subsystem, the
> integrity metadata will be corrupted.
>
> Splitting the bio works correctly. The function bio_split will clone the
> bio, trim the iterator of the first bio and advance the iterator of the
> second bio.
>
> However, the function rq_integrity_vec has a bug - it returns the first
> vector of the bio's metadata and completely disregards the metadata
> iterator that was advanced when the bio was split. Thus, the second bio
> uses the same metadata as the first bio and this leads to metadata
> corruption.
>
> This commit changes rq_integrity_vec, so that it calls mp_bvec_iter_bvec
> instead of returning the first vector. mp_bvec_iter_bvec reads the
> iterator and uses it to build a bvec for the current position in the
> iterator.
>
> The "queue_max_integrity_segments(rq->q) > 1" check was removed, because
> the updated rq_integrity_vec function works correctly with multiple
> segments.
>
> Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
>
> ---
>  drivers/nvme/host/pci.c       |    6 +++---
>  include/linux/blk-integrity.h |   14 +++++++-------
>  2 files changed, 10 insertions(+), 10 deletions(-)
>
> Index: linux-2.6/drivers/nvme/host/pci.c
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> --- linux-2.6.orig/drivers/nvme/host/pci.c
> +++ linux-2.6/drivers/nvme/host/pci.c
> @@ -825,9 +825,9 @@ static blk_status_t nvme_map_metadata(st
>                 struct nvme_command *cmnd)
>  {
>         struct nvme_iod *iod =3D blk_mq_rq_to_pdu(req);
> +       struct bio_vec bv =3D rq_integrity_vec(req);
>
> -       iod->meta_dma =3D dma_map_bvec(dev->dev, rq_integrity_vec(req),
> -                       rq_dma_dir(req), 0);
> +       iod->meta_dma =3D dma_map_bvec(dev->dev, &bv, rq_dma_dir(req), 0)=
;
>         if (dma_mapping_error(dev->dev, iod->meta_dma))
>                 return BLK_STS_IOERR;
>         cmnd->rw.metadata =3D cpu_to_le64(iod->meta_dma);
> @@ -966,7 +966,7 @@ static __always_inline void nvme_pci_unm
>                 struct nvme_iod *iod =3D blk_mq_rq_to_pdu(req);
>
>                 dma_unmap_page(dev->dev, iod->meta_dma,
> -                              rq_integrity_vec(req)->bv_len, rq_dma_dir(=
req));
> +                              rq_integrity_vec(req).bv_len, rq_dma_dir(r=
eq));
>         }
>
>         if (blk_rq_nr_phys_segments(req))
> Index: linux-2.6/include/linux/blk-integrity.h
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> --- linux-2.6.orig/include/linux/blk-integrity.h
> +++ linux-2.6/include/linux/blk-integrity.h
> @@ -106,14 +106,13 @@ static inline bool blk_integrity_rq(stru
>  }
>
>  /*
> - * Return the first bvec that contains integrity data.  Only drivers tha=
t are
> - * limited to a single integrity segment should use this helper.
> + * Return the current bvec that contains the integrity data. bip_iter ma=
y be
> + * advanced to iterate over the integrity data.
>   */
> -static inline struct bio_vec *rq_integrity_vec(struct request *rq)
> +static inline struct bio_vec rq_integrity_vec(struct request *rq)
>  {
> -       if (WARN_ON_ONCE(queue_max_integrity_segments(rq->q) > 1))
> -               return NULL;
> -       return rq->bio->bi_integrity->bip_vec;
> +       return mp_bvec_iter_bvec(rq->bio->bi_integrity->bip_vec,
> +                                rq->bio->bi_integrity->bip_iter);
>  }
>  #else /* CONFIG_BLK_DEV_INTEGRITY */
>  static inline int blk_rq_count_integrity_sg(struct request_queue *q,
> @@ -179,7 +178,8 @@ static inline int blk_integrity_rq(struc
>
>  static inline struct bio_vec *rq_integrity_vec(struct request *rq)
>  {
> -       return NULL;
> +       /* the optimizer will remove all calls to this function */
> +       return (struct bio_vec){ };
>  }
>  #endif /* CONFIG_BLK_DEV_INTEGRITY */
>  #endif /* _LINUX_BLK_INTEGRITY_H */
>

Reviewed-by: Anuj Gupta <anuj20.g@samsung.com>
