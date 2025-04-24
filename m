Received: from mail-ed1-f53.google.com (mail-ed1-f53.google.com [209.85.208.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CAED71C6FF3
	for <dm-devel@lists.linux.dev>; Thu, 24 Apr 2025 07:14:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745478898; cv=none; b=Uo133PRamw+mE01EIO/F0hZVpX9UtOvDhzTbtJt6+9691qVKYdnCT6ReUOKtCrDk4RlJv2hgTU/jvgz53VrXusws5ePIPJNelQ7VKvQHZylr2fVyL7xmp5/H98eDEahbnhladsAuEPLUxQepPoTZQQ8k2NMsEEcZi7YE8wPfOjs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745478898; c=relaxed/simple;
	bh=6soEZQ4kJUtvIiqK5puOZE2rScJp6QCdTzCCiUGiRxg=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=CJ6c/d/n4Xvd2tsKk1qxFjkQChR/clrGBJT8giJoFSOeWPUTNRZjDNFTvqH4sYU1JrUzxOWC70pwH02O/58sifU6cRwmTnX/hauPrPFVVtPXxwTM2Q5zF5z2zpYi3AAMGIKT0wSC8Rsy6qltWyXfljflM3Tb5r7T1ELsEqoq+z8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ionos.com; spf=pass smtp.mailfrom=ionos.com; dkim=pass (2048-bit key) header.d=ionos.com header.i=@ionos.com header.b=DZAg3xQq; arc=none smtp.client-ip=209.85.208.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ionos.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ionos.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ionos.com header.i=@ionos.com header.b="DZAg3xQq"
Received: by mail-ed1-f53.google.com with SMTP id 4fb4d7f45d1cf-5f6f3f2af91so4100a12.2
        for <dm-devel@lists.linux.dev>; Thu, 24 Apr 2025 00:14:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ionos.com; s=google; t=1745478894; x=1746083694; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=o+B8Lq9RDCcRwOgfM91avCJcgWbWbGSMVAU80sQQPWI=;
        b=DZAg3xQqbGPzC2av15BVYWseIHarLXHM/wlTrk9TrNtrGFZMH08/5xSgZqU8kOZd/i
         Re+TUc1yQTPK6N2uWoftcr8s9INHebYT5oU/baf7XV2XJtdER9JbIZikrqMV0U83zsIP
         OEFHH9nAb8Jj/2huDDDUQZcVfyG9HRvMfW7jX3kTrxi/LzUchQzCjGFZ3sTyqTdXPLK/
         FPFf8UE5/ime5Zjv+jz60IVISzPtyM1rKiNrhLbCgeK+befNHq0U9Ac1S8ujavVnaWOl
         JOPj8d/3vuA+f3ocmuCxjIH+G98Ak8H+1IfwTVzGO8vsUkWr+RJwIOj1NzHcXqLWcFbW
         nz4w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1745478894; x=1746083694;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=o+B8Lq9RDCcRwOgfM91avCJcgWbWbGSMVAU80sQQPWI=;
        b=FZl6wHL9sSHVnXpm+ywkBN7EVQ42ulJcH7cVeY0hxdlVHHTF60vmEGqTbhSjLHrbXX
         N0XAGt+idHd1XpHMMAfAW3/vPOunF2WlyILVw9mdkHy5QpmRsZ1rU1s1faTDnSayiSJ0
         C98rPZfPhpFUIF2D8nnD5lFGyXPNwbyJQ62m8rMLuXOJEgajX34QmUPnc7+foTPUl+EA
         dMi4kXH44VR0Gw5r+KtEDzLD707KNU4ZB7FZ5mYm5SaAi7CG8lR2qhJn31XE/eVizJ0i
         btxetM4iBMJdK8QXmJsNmU6W30HWHzKF2632Z5r7qfYDoPJqc1ggM/PfTWelcHTfLCdK
         68ag==
X-Forwarded-Encrypted: i=1; AJvYcCVXrcc6O1fsIeUXtZ8BAN5+IOXYA7mo6LrRF/6x27jfh6oEqxh2XB0WSUcn7iYLDRz0zDqWdff1Wg==@lists.linux.dev
X-Gm-Message-State: AOJu0YyfmQjyzOmxs2Y1Ev02zTDIasEVi3CEruqnSYRQFEonhd7iWH6w
	/R6DD7IlOqzcsfjkQAgtZRaa2lsjqgncvBiWTbv9ptRleex/JCdGDuO2VYUHcEpPFQ9/tnG9aAK
	4g6UF3rFPblw/em+41aYaTFYknFi5WCQBKT1/Ag==
X-Gm-Gg: ASbGncsDyd/J5UIZz6Vq94if7tSV+yY974juxKQhi3NRTQog+xMeXkpSEnTUoOMQNmk
	DMl5z89Wu2gWZnE149om4VlYhUCDABN7vY2TQEcDucQRZgsbac1g5LFxmVzhMagAuH6ZecflgJp
	h3AxEUqXLlSmGtHBZm/+mkW+m1ctKb4RY775zr2n6tOSX2HGfqm+2yFX0=
X-Google-Smtp-Source: AGHT+IEyAiUyJ2mt3265jGzrXL9ewNYPCotZUNj9QN43I8BqsNkYBnMDkmlm1PZ/N97S/0QtxYx3zQ6j0NbtPT1J4KM=
X-Received: by 2002:a05:6402:35cd:b0:5ed:9811:dfdc with SMTP id
 4fb4d7f45d1cf-5f6ddcf7f9emr548541a12.2.1745478894059; Thu, 24 Apr 2025
 00:14:54 -0700 (PDT)
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20250422142628.1553523-1-hch@lst.de> <20250422142628.1553523-11-hch@lst.de>
In-Reply-To: <20250422142628.1553523-11-hch@lst.de>
From: Jinpu Wang <jinpu.wang@ionos.com>
Date: Thu, 24 Apr 2025 09:14:43 +0200
X-Gm-Features: ATxdqUFceKzqfCTaFW1t2hUyaQzIpI3Ey7xNjxMyLwpQpyjJSAnOh5Bm8Qq-E8M
Message-ID: <CAMGffEmB1Y22T6JosV+aJrTf9NWAabuJqovy65+mMLsOcx1ktQ@mail.gmail.com>
Subject: Re: [PATCH 10/17] rnbd-srv: use bio_add_virt_nofail
To: Christoph Hellwig <hch@lst.de>
Cc: Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org, 
	"Md. Haris Iqbal" <haris.iqbal@ionos.com>, Coly Li <colyli@kernel.org>, 
	Kent Overstreet <kent.overstreet@linux.dev>, Mike Snitzer <snitzer@kernel.org>, 
	Mikulas Patocka <mpatocka@redhat.com>, Chris Mason <clm@fb.com>, Josef Bacik <josef@toxicpanda.com>, 
	David Sterba <dsterba@suse.com>, Andreas Gruenbacher <agruenba@redhat.com>, Carlos Maiolino <cem@kernel.org>, 
	Damien Le Moal <dlemoal@kernel.org>, Naohiro Aota <naohiro.aota@wdc.com>, 
	Johannes Thumshirn <jth@kernel.org>, "Rafael J. Wysocki" <rafael@kernel.org>, Pavel Machek <pavel@kernel.org>, 
	linux-bcache@vger.kernel.org, dm-devel@lists.linux.dev, 
	linux-btrfs@vger.kernel.org, gfs2@lists.linux.dev, 
	linux-fsdevel@vger.kernel.org, linux-xfs@vger.kernel.org, 
	linux-pm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Apr 22, 2025 at 4:27=E2=80=AFPM Christoph Hellwig <hch@lst.de> wrot=
e:
>
> Use the bio_add_virt_nofail to add a single kernel virtual address
> to a bio as that can't fail.
>
> Signed-off-by: Christoph Hellwig <hch@lst.de>
Acked-by: Jack Wang <jinpu.wang@ionos.com>
> ---
>  drivers/block/rnbd/rnbd-srv.c | 7 +------
>  1 file changed, 1 insertion(+), 6 deletions(-)
>
> diff --git a/drivers/block/rnbd/rnbd-srv.c b/drivers/block/rnbd/rnbd-srv.=
c
> index 2ee6e9bd4e28..2df8941a6b14 100644
> --- a/drivers/block/rnbd/rnbd-srv.c
> +++ b/drivers/block/rnbd/rnbd-srv.c
> @@ -147,12 +147,7 @@ static int process_rdma(struct rnbd_srv_session *srv=
_sess,
>
>         bio =3D bio_alloc(file_bdev(sess_dev->bdev_file), 1,
>                         rnbd_to_bio_flags(le32_to_cpu(msg->rw)), GFP_KERN=
EL);
> -       if (bio_add_page(bio, virt_to_page(data), datalen,
> -                       offset_in_page(data)) !=3D datalen) {
> -               rnbd_srv_err_rl(sess_dev, "Failed to map data to bio\n");
> -               err =3D -EINVAL;
> -               goto bio_put;
> -       }
> +       bio_add_virt_nofail(bio, data, datalen);
>
>         bio->bi_opf =3D rnbd_to_bio_flags(le32_to_cpu(msg->rw));
>         if (bio_has_data(bio) &&
> --
> 2.47.2
>
