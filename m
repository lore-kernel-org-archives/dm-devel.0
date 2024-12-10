Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 36488207E0C
	for <dm-devel@lists.linux.dev>; Tue, 10 Dec 2024 16:36:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733848579; cv=none; b=IerxHEgzby7R3oA8gAaMQ2kU1OTuA3YvbibVpnIhczFS5Rm3kGxRL7/jSB9XwivZFYz09b0tId48AS8njcUlnrXs88avdvRb+LeWYssMqHGetVo/xCZGpTXz5fFjEnKDKAJYLXetq//1b7SXsldZhLV/CZ1i0FGr1NFZgfZFmxI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733848579; c=relaxed/simple;
	bh=NEGY1vDHrUkziO8TQq242p6/kS/e6KnmLt/yt6hlsZM=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=HX5BycAsCnh8Jx8iVJoMne0cYKCs+SkH1z3k1ztgEj2FkYGVgWmZMcIYpbHuos/g9+ec+zAg/iOZBGJjGFmBwhkZyYa3EElBOW04bk3POXnrNX1PnQJvrbkouMVFatGQOWFfKVYr5uGmHculwjkLKtiRjtHdYRPtzerDDcdXFOA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=UG/UAeq4; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="UG/UAeq4"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1733848575;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=G1O+Y+fDJOm6NPpQ61eXRCnR50tkVaABUR4Vl4zbDxw=;
	b=UG/UAeq4wIdFoXe/WzPH42xf6BqD/k4z8rB0mIESHqV5RVvFU2tkpnvt2ZCONXOOA5NEsz
	CXBgw6uY5jnQ0m86hmUA95NA6J6pWMknVg/CLCCCmEBQjFj/ZO8a53HuXrwa0iAP138Us2
	uoOD/sfEX/p9FPOEIqTEIq9eH9TtsdM=
Received: from mail-yb1-f199.google.com (mail-yb1-f199.google.com
 [209.85.219.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-326-yDEBD8UmPMy04EPgX6b2sw-1; Tue, 10 Dec 2024 11:36:14 -0500
X-MC-Unique: yDEBD8UmPMy04EPgX6b2sw-1
X-Mimecast-MFC-AGG-ID: yDEBD8UmPMy04EPgX6b2sw
Received: by mail-yb1-f199.google.com with SMTP id 3f1490d57ef6-e3984b68708so10551975276.0
        for <dm-devel@lists.linux.dev>; Tue, 10 Dec 2024 08:36:14 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1733848574; x=1734453374;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=G1O+Y+fDJOm6NPpQ61eXRCnR50tkVaABUR4Vl4zbDxw=;
        b=tOU3DoVkUjmx50hQqfeXOMrURQPmSlkwUO6aWXKM3ntKoK4J2jjYGQ2otZ9dkazpKc
         s68mLywP1XWgm1cTvBMVs7sYyuh1CoD8YUwD3JAptP8zJOzovSh1ticj7A/YD1MKNBdz
         6+ro9Ra5d7XyZscbakGBp8l+LaJw7GYiTvhx0En8SggJvp0JOn8DwnL+SS3AIPm8Hm0W
         8ZbDfMGnyTm4x5Lq+hPW1spUTP7GiDKygMINqiKP4dfzvfkAfRiKxLm9LfCzHFKdgbEn
         vMcZvVxUzT1mq2ed5WIBaYGzYEUmW5jbOGUX/18W3b/7UPRxJxkJvz61wo3uqVX7/59D
         G4Ng==
X-Gm-Message-State: AOJu0YyxJ4va19w3RD+Tch7TjnT2PMhaPJQM4N4TuFl8gNsYKqeG7jBO
	/SGuVyu2V6PXPCm57lB8ABymfmMjzzk2F3L6671l6rUxkjnjk23nVrG4Up/ZMqs7/vm1ErBpsZu
	HFchLYOOe2trZKIQtFf9QiZFOdxrD6644RlnbSy9xVxHdV/NcqbH44ufrza3jfdYQm44dZSVc8R
	S26F77WDPRXsFKTT2Xe4x2qxRj44E0Pns=
X-Gm-Gg: ASbGncvBM1Jp+SntpuAM7WeqgjQl4BKJAy4jSUmDjQLgeWndyGpaclcMaUQc17vaf0Z
	1ab3wbf20pI5Du3TrQV2Tb9AVfS+LNGZTtfs=
X-Received: by 2002:a05:6902:c0a:b0:e3a:2011:19a5 with SMTP id 3f1490d57ef6-e3a20111a1bmr9154037276.3.1733848574265;
        Tue, 10 Dec 2024 08:36:14 -0800 (PST)
X-Google-Smtp-Source: AGHT+IGW976EYY8+72/xs4ztQFCBR9AZgvludxwbp6LAgYkeE/Z4KZloXVdIS8jXdH6rLXU5zP8zHVyfNjEas7fgbnw=
X-Received: by 2002:a05:6902:c0a:b0:e3a:2011:19a5 with SMTP id
 3f1490d57ef6-e3a20111a1bmr9154016276.3.1733848574003; Tue, 10 Dec 2024
 08:36:14 -0800 (PST)
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20241203173756.1257967-1-mtsai@redhat.com> <20241203175029.1259542-1-mtsai@redhat.com>
In-Reply-To: <20241203175029.1259542-1-mtsai@redhat.com>
From: Joe Thornber <thornber@redhat.com>
Date: Tue, 10 Dec 2024 16:35:34 +0000
Message-ID: <CAJ0trDbOk0DVdBCVtBkW-q+OYdeqLnO0NMDktSXQFraUt1hkew@mail.gmail.com>
Subject: Re: [PATCH 3/3] dm array: fix cursor index when skipping across block boundaries
To: Ming-Hung Tsai <mtsai@redhat.com>
Cc: dm-devel@lists.linux.dev, Mikulas Patocka <mpatocka@redhat.com>, 
	Heinz Mauelshagen <heinzm@redhat.com>, Mike Snitzer <snitzer@kernel.org>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: _Lml0ct1qZcpQ0ZeSQcTnShGbxcZcjv_huCmNFtItF0_1733848574
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Reviewed-by: thornber@redhat.com

On Tue, Dec 3, 2024 at 5:50=E2=80=AFPM Ming-Hung Tsai <mtsai@redhat.com> wr=
ote:
>
> dm_array_cursor_skip() seeks to the target position by loading array
> blocks iteratively until the specified number of entries to skip is
> reached. When seeking across block boundaries, it uses
> dm_array_cursor_next() to step into the next block.
> dm_array_cursor_skip() must first move the cursor index to the end
> of the current block; otherwise, the cursor position could incorrectly
> remain in the same block, causing the actual number of skipped entries
> to be much smaller than expected.
>
> This bug affects cache resizing in v2 metadata and could lead to data
> loss if the fast device is shrunk during the first-time resume. For
> example:
>
> 1. create a cache metadata consists of 32768 blocks, with a dirty block
>    assigned to the second bitmap block. cache_restore v1.0 is required.
>
> cat <<EOF >> cmeta.xml
> <superblock uuid=3D"" block_size=3D"64" nr_cache_blocks=3D"32768" \
> policy=3D"smq" hint_width=3D"4">
>   <mappings>
>     <mapping cache_block=3D"32767" origin_block=3D"0" dirty=3D"true"/>
>   </mappings>
> </superblock>
> EOF
> dmsetup create cmeta --table "0 8192 linear /dev/sdc 0"
> cache_restore -i cmeta.xml -o /dev/mapper/cmeta --metadata-version=3D2
>
> 2. bring up the cache while attempt to discard all the blocks belonging
>    to the second bitmap block (block# 32576 to 32767). The last command
>    is expected to fail, but it actually succeeds.
>
> dmsetup create cdata --table "0 2084864 linear /dev/sdc 8192"
> dmsetup create corig --table "0 65536 linear /dev/sdc 2105344"
> dmsetup create cache --table "0 65536 cache /dev/mapper/cmeta \
> /dev/mapper/cdata /dev/mapper/corig 64 2 metadata2 writeback smq \
> 2 migration_threshold 0"
>
> Signed-off-by: Ming-Hung Tsai <mtsai@redhat.com>
> Fixes: 9b696229aa7d ("dm persistent data: add cursor skip functions to th=
e cursor APIs")
> ---
>  drivers/md/persistent-data/dm-array.c | 1 +
>  1 file changed, 1 insertion(+)
>
> diff --git a/drivers/md/persistent-data/dm-array.c b/drivers/md/persisten=
t-data/dm-array.c
> index 1c3af717ee4f..b293da766fb1 100644
> --- a/drivers/md/persistent-data/dm-array.c
> +++ b/drivers/md/persistent-data/dm-array.c
> @@ -1004,6 +1004,7 @@ int dm_array_cursor_skip(struct dm_array_cursor *c,=
 uint32_t count)
>                 }
>
>                 count -=3D remaining;
> +               c->index +=3D (remaining - 1);
>                 r =3D dm_array_cursor_next(c);
>
>         } while (!r);
> --
> 2.47.0
>

