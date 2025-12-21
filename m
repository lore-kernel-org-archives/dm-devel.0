Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 53B292F9C39
	for <dm-devel@lists.linux.dev>; Sun, 21 Dec 2025 15:40:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766331605; cv=none; b=qwLPI+VBwUJ2LcOW6HWSlCvVtFAuCpddrG8V9dBkJN9EtcxTlIFg35EltXx68GzgSDaFQn+ko69nPBBA2QRhGzLm8cflc12sWQTGqwIszANu7zoO/l2JTLrtAXg5SafeJv3c3wL5JL3EGV2nbAVKuTRD6LUndKi4ARez221Jy8M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766331605; c=relaxed/simple;
	bh=mnZjXNK0u+HP/XUiaDYnE60D1RSlqmCcOGyEHMy6J80=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=WMnj6IiXTjNj+TRKHFCMobZxZNgsQYLAovsyGi4AhQ3w49hc8rJvoQVx9NpGywa1Ap1R63cAx2BKswW1gehtbs45oyh0ikDG+RJTLAkRieC0qEmzrOnPh24vvkBwVDNY46IEOjw7q7b95KxaU1cDdkrGkCeXT0wrsD6ltUrZwyc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=fttG2Je7; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="fttG2Je7"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1766331601;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=+KE66w4YWw6ndgVPN9WJoeENuvGjofTuSeoIQ9xGNDM=;
	b=fttG2Je7tdPOfLijYFhXFq3PE3AKCw6AQNJoJS1mI71qQq+TxQDEPYBBt6SS1Dp57w5qD7
	UYCri/YFtUkTv2MRs6daOTYs5v2OUv8HvFYCcr7jN0dEfgATrZwVtAhZ4MNRg0LCX20bjY
	xUoPIgUQDJrr+9L+UnTYemEK8FkcUxw=
Received: from mail-yx1-f69.google.com (mail-yx1-f69.google.com
 [74.125.224.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-321-c52bcWArN52gsVN9UeRfVA-1; Sun, 21 Dec 2025 10:39:59 -0500
X-MC-Unique: c52bcWArN52gsVN9UeRfVA-1
X-Mimecast-MFC-AGG-ID: c52bcWArN52gsVN9UeRfVA_1766331599
Received: by mail-yx1-f69.google.com with SMTP id 956f58d0204a3-6446c91addfso4464558d50.3
        for <dm-devel@lists.linux.dev>; Sun, 21 Dec 2025 07:39:59 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766331599; x=1766936399;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=+KE66w4YWw6ndgVPN9WJoeENuvGjofTuSeoIQ9xGNDM=;
        b=G34w+PT7YoQ7CTnlMwxYZJ9hL9JRzNQUzTccGutdjPEWDABUvdDRoEK0omjj4h1OOL
         i3UkPHhM+RJ9bJcTwY4IQMdOQY+aTs1gSWys68N8CC0jgD4byx2YAKSeaS8AgUy0xpib
         eDTW3ay0pbbcbXsyhmw9SYV5W4uOog+2uys94Z6JHOEgYex+4r4hFouKGUCY21gchPUp
         CzAZLHCbsZZ3kQ1rBxadiBb1J/ghmxxrTel+OZjNy2JQus/WcxNy5HdokcDNQfdwqZTF
         UvijZMU7mLpYWtb3S6aTv04WvL2ddFNeOV69+OEwlnk19PqAR2lTWKKUDvGnDf+eE11R
         Fr1Q==
X-Forwarded-Encrypted: i=1; AJvYcCW0zyqcACJtunhJlDkdvlkGBmJcXqmtmBqDFb0sDwintvu6M4WUv+ibS8oOVsFumoyNnxN6vxIoSA==@lists.linux.dev
X-Gm-Message-State: AOJu0YymT+ko1frdSl12S/Bz59zX2mym/SbUH7JshFCuaSZk4IzGSGPu
	KqcUoU0h05Ft1283WVAL4ajzCGPtGMVfZNm2GEfJPSEIwGW1FqN4XaxpOXWhoqcjAEXKI5ScQyh
	31JUuvbIrNv06W+X+SNtbNbkA+mf2nH7iU57G6jCpwJ56L+qPBbwcKsGr4tn1AnkJ14TFzcAVtv
	4+AvZzrKtb6iR9Gp0HQ58iF9pNdg1tn2Vs4F0=
X-Gm-Gg: AY/fxX69wj26wzf2e7h123Zr1FLekqsvogw2PPUn3zYIMWg2H0RVw+hQSIIRj62UpXW
	7VDHf7Tta7LVdoxsC7Is+iB6LzxOWeJsKWZH1aJvf8AabS6tQTfXc3AapzeiPdJ6crSt0xu9DQ8
	YVbfOMdUT9RZ9W54gUy5eQ3z5f9EniQ+QaosUuTZdAVIKSIcux/0geGWRGyZt+o/D7Jowrse+hr
	CGG9WwIYxX9HqJq6uaJ3YUhXQY7+UEIbq/IsAu6lpc11EHMLI66Tg==
X-Received: by 2002:a05:690e:1284:b0:644:60d9:866c with SMTP id 956f58d0204a3-6466a92dc91mr6656838d50.93.1766331599149;
        Sun, 21 Dec 2025 07:39:59 -0800 (PST)
X-Google-Smtp-Source: AGHT+IFC7mRAlf3U3160pFy0QO4PEVMCEcrUcemZaiGKUncjGrA9BOh5VcTiZvbH4/xJJSP0FWrca5aMSKuDJG3O3Q8=
X-Received: by 2002:a05:690e:1284:b0:644:60d9:866c with SMTP id
 956f58d0204a3-6466a92dc91mr6656830d50.93.1766331598821; Sun, 21 Dec 2025
 07:39:58 -0800 (PST)
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20251221025233.87087-1-agruenba@redhat.com> <20251221025233.87087-2-agruenba@redhat.com>
In-Reply-To: <20251221025233.87087-2-agruenba@redhat.com>
From: Andreas Gruenbacher <agruenba@redhat.com>
Date: Sun, 21 Dec 2025 16:39:47 +0100
X-Gm-Features: AQt7F2o4CmeFGTIojqbpS0PVmjVAd-d4HUDEVdSFp54dsbxM3ZckXV6-nNPzQZs
Message-ID: <CAHc6FU6vAokT9ugX1DA8iQLbeu7=Eixr9bq6z0o77_Nq+PyXvw@mail.gmail.com>
Subject: Re: [RFC v2 01/17] xfs: don't clobber bi_status in xfs_zone_alloc_and_submit
To: Christoph Hellwig <hch@infradead.org>, Jens Axboe <axboe@kernel.dk>, Chris Mason <clm@fb.com>, 
	David Sterba <dsterba@suse.com>
Cc: linux-block@vger.kernel.org, linux-btrfs@vger.kernel.org, 
	linux-raid@vger.kernel.org, dm-devel@lists.linux.dev, 
	linux-kernel@vger.kernel.org
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: HymA3XPHWHFD9eWmj6AbCiE8M5banNllCYPvcrLANII_1766331599
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sun, Dec 21, 2025 at 3:52=E2=80=AFAM Andreas Gruenbacher <agruenba@redha=
t.com> wrote:
> Function xfs_zone_alloc_and_submit() sets bio->bi_status and then it
> calls bio_io_error(), which overwrites that value again.  Fix that by
> completing the bio separately after setting bio->bi_status.

By the way, this bug makes me wonder if we shouldn't just get rid of
bio_io_error() in favour of bio_endio_status(bio, BLK_STS_IOERR). The
latter would be a lot more obvious.

Andreas

> Signed-off-by: Andreas Gruenbacher <agruenba@redhat.com>
> ---
>  fs/xfs/xfs_zone_alloc.c | 3 +++
>  1 file changed, 3 insertions(+)
>
> diff --git a/fs/xfs/xfs_zone_alloc.c b/fs/xfs/xfs_zone_alloc.c
> index ef7a931ebde5..bd6f3ef095cb 100644
> --- a/fs/xfs/xfs_zone_alloc.c
> +++ b/fs/xfs/xfs_zone_alloc.c
> @@ -897,6 +897,9 @@ xfs_zone_alloc_and_submit(
>
>  out_split_error:
>         ioend->io_bio.bi_status =3D errno_to_blk_status(PTR_ERR(split));
> +       bio_endio(&ioend->io_bio);
> +       return;
> +
>  out_error:
>         bio_io_error(&ioend->io_bio);
>  }
> --
> 2.52.0
>

