Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F5BF3D34B5
	for <dm-devel@lists.linux.dev>; Fri, 10 Apr 2026 14:28:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775831301; cv=none; b=hRl6jMUf94nmEwdcD957YX711ZwWKNwwuZwhTx/VIySidQJ15NBCCUQ62rDI08O1+Daf07vF+gMH1JrMM1HrJV1Q9eQ/txPHu9YHkdZjLD9DvABeNnFo1Y2KgPQahMOfdo/8atqEGYKOm10cQCfzGYgyiVjpFkafAIOW58ms+bw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775831301; c=relaxed/simple;
	bh=GpSABa/FV+mKsBdnSa7yRSdtoHMGUQpyD+4eRAUP1WA=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=tJ1TdZd0OLL5jyf9rF7NMp9fW81SJ+dnI48ge4v5ihElBMhtxBomfXhSfCsCoNH3RuTuyN9LOCKDC3FKrpHg/EgxS7BXcYIPMN5/lP7MJyF/+p3+lsUsRL1ayjqcibwHZ3q+mJl5rTyQDTGzJdTvIRECVcBDTJeTQYRHLAyik0g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=HQWkrwgY; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="HQWkrwgY"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1775831296;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Q+GXTcjSqggmwthFX52K09dg/BWGfG29LIsbFmF4UBI=;
	b=HQWkrwgYF1Ii6UAQ0G4xwca71BZ4ZEKS4LKqrumnSTQCEucqG7E+CvrbnEaxIvy2LG5Yk7
	HPgmjDq642cYGdhnmIV1i5s+aIcIFI0fmxgqabcMm5g2Q7Pxc8UXQcKDlkVpsyiKkYCSYd
	L+DU40Wb0FeWSfTZqrRzJmY80J53L+Y=
Received: from mail-lj1-f197.google.com (mail-lj1-f197.google.com
 [209.85.208.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-354-r30sf4e2NTOf3Tv_nNipkA-1; Fri, 10 Apr 2026 10:28:15 -0400
X-MC-Unique: r30sf4e2NTOf3Tv_nNipkA-1
X-Mimecast-MFC-AGG-ID: r30sf4e2NTOf3Tv_nNipkA_1775831294
Received: by mail-lj1-f197.google.com with SMTP id 38308e7fff4ca-38e21bbb5eeso12438941fa.1
        for <dm-devel@lists.linux.dev>; Fri, 10 Apr 2026 07:28:15 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775831294; x=1776436094;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=Q+GXTcjSqggmwthFX52K09dg/BWGfG29LIsbFmF4UBI=;
        b=BF/cnQ2WwHEEZqVVGof/yeCJnr5VqtAKEk5yJklbYa4sJd9ulOW7DF3RLbkBXhfFVy
         37N73Eebz6kvxZJkk6iq7UfCXNQu5K0zBK0edC9DslfvUOmXEvqOB9gMSASw/zh3dkGf
         kAkvpHWjuiFvpjwAy+nSJ6G+7dONiaTD431AP9PC++Izq/Cl1xKY/wg7di995TeBcaYu
         HWQ9+ZMDZ6WlTC6sepqPR1/xba52AkD1roBGSQNqmkFuSYmtdD4lC8Ng/xnV/idu3fOs
         928lsx4gnbRfW/yzS95HzV3AaY5yw4Ldyt+t7wOtlF2B/4txsWER+I3zhVbYB41jUf6i
         XJdA==
X-Gm-Message-State: AOJu0Yx8GnvMXU1N/ACUUnvOtHmSnbcaEIkNsfghreJYJr8wWY6VuJ23
	88XIcb/C2DKGIeVvtllMMgQL5yTRBLL7k5Iq6V9hFWaXvVjSBzN25uW/XqXXqkP3wptRIWM4LEA
	2dL7LFlROpNaHr9Zii4h13l6Jrtstmivt7QrkoJQPcUAkAVtjWAI6oWRWzs9cDa+RvnFLEyFDKz
	DoopH0Ckm3XYqF6PeCRp3lJDKxGOH8VrISdg==
X-Gm-Gg: AeBDietsTGkw9Mn0Ri3y2Bv19Uu009Ox38OsFdunCv/FQzIJxPuIhQBhukVugFjTBXy
	oKzDNnbBEp1dhGHA8GEpGUMGHkrFPRjVh0++WUBUSjAS0gV8vgpJ61W5P8EanBrWn3IssXXM+G1
	803XPmp0CbmRsrl+cGDrR4drqc+BgL/3YxuUAOQLMCnGLUtHHW9M5U7BNn+Y+ZmD6LFI+rpfj25
	H9D
X-Received: by 2002:a05:651c:3259:b0:38c:bea4:d7f9 with SMTP id 38308e7fff4ca-38e4bbe35cdmr10265441fa.4.1775831293645;
        Fri, 10 Apr 2026 07:28:13 -0700 (PDT)
X-Received: by 2002:a05:651c:3259:b0:38c:bea4:d7f9 with SMTP id
 38308e7fff4ca-38e4bbe35cdmr10265341fa.4.1775831293069; Fri, 10 Apr 2026
 07:28:13 -0700 (PDT)
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <adjMq6T5RRjv_uxM@stanley.mountain>
In-Reply-To: <adjMq6T5RRjv_uxM@stanley.mountain>
From: Ming Hung Tsai <mtsai@redhat.com>
Date: Fri, 10 Apr 2026 22:28:01 +0800
X-Gm-Features: AQROBzBQYyXc5pWBm6UchAjbBvKslDLuL2GhcGr9EzQ2vbroOSWvctJlJTeULLE
Message-ID: <CALjSBEuRFe_tt4iVwMHGY_cs8g4RsNC05tMPt9_n45-Kykis4w@mail.gmail.com>
Subject: Re: [bug report] dm cache: fix write hang in passthrough mode
To: Dan Carpenter <error27@gmail.com>
Cc: dm-devel@lists.linux.dev
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: 46AixogKBPjKsqwom5sRIidmur8O9U2bGg4G3oJnyck_1775831294
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Apr 10, 2026 at 6:11=E2=80=AFPM Dan Carpenter <error27@gmail.com> w=
rote:
>
> Hello Ming-Hung Tsai,
>
> Commit 4ca8b8bd952d ("dm cache: fix write hang in passthrough mode")
> from Feb 9, 2026 (linux-next), leads to the following Smatch static
> checker warning:
>
>         drivers/md/dm-cache-target.c:1527 invalidate_committed()
>         error: dereferencing freed memory 'mg' (line 1525)
>
> drivers/md/dm-cache-target.c
>     1517 static void invalidate_committed(struct work_struct *ws)
>     1518 {
>     1519         struct dm_cache_migration *mg =3D ws_to_mg(ws);
>     1520         struct cache *cache =3D mg->cache;
>     1521         struct bio *bio =3D mg->overwrite_bio;
>     1522         struct per_bio_data *pb =3D get_per_bio_data(bio);
>     1523
>     1524         if (mg->k.input)
>     1525                 invalidate_complete(mg, false);
>                                              ^^
> This frees mg.
>
>     1526
> --> 1527         init_continuation(&mg->k, invalidate_completed);
>                                     ^^
>     1528         remap_to_origin_clear_discard(cache, bio, mg->invalidate=
_oblock);
>                                                            ^^
>     1529         dm_hook_bio(&pb->hook_info, bio, overwrite_endio, mg);
>                                                                    ^^
> But we still dereference it later.
>
>     1530         dm_submit_bio_remap(bio, NULL);
>     1531 }
>
> This email is a free service from the Smatch-CI project [smatch.sf.net].
>
> regards,
> dan carpenter
>

Thanks for the report. I've fixed this and added your Reported-by:

https://lore.kernel.org/dm-devel/20260410130801.232180-1-mtsai@redhat.com/


Ming-Hung Tsai

