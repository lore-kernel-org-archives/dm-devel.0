Received: from mail-oo1-f51.google.com (mail-oo1-f51.google.com [209.85.161.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 594152FD673
	for <dm-devel@lists.linux.dev>; Thu,  4 Dec 2025 03:10:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764817859; cv=none; b=UpftOwj2Cn3s4Z+iBWxssKccgmj5zkpfPmckub5kdpwIlJbDbVrmctDX1x7SzU/a6jd+fNF6hBQXkO89ses9MnJ9OcvGwnbL9ARDsU8PAfalyfSujJFnjDZRWs2JAN9VAiUvWMDzMQPokRWAPjDT1olgPzCC9rIk0ubun6Y7ULQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764817859; c=relaxed/simple;
	bh=dJEZqQzlsesQ7R+i4RbFmr/oIIfC4jPgKPDRCqgSHs4=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=i0+bAK+XMYXGPHfMDz2IyxHdU6v7roUhxh4FkNzpMY3wjTZ6ER8rkHIVXLAc5nSiRbR00LaYViqEjhiAij154yVC7s7M3tUzWpu+AImymrxK6WVF/xUQ0UdAQt5FZbvTT+I8SAY+krjUqhEQX9rg266BV45CjKj/LnQWFyIB0+c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=eyvoebv7; arc=none smtp.client-ip=209.85.161.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="eyvoebv7"
Received: by mail-oo1-f51.google.com with SMTP id 006d021491bc7-65745a436f7so233411eaf.3
        for <dm-devel@lists.linux.dev>; Wed, 03 Dec 2025 19:10:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1764817857; x=1765422657; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=6CDFb0bpksESE4/J8Wb7CxB/SOjxeLFnrYs4RenKTTE=;
        b=eyvoebv7OsOKcVDlvUDdklkI/d1rU/06/m2GwtRj/tjxnv/rqC/G7SIrWot7nSr4bV
         Xn9iQRtUirUE5ODh0DbkoIm+r4OEFgebq4E6YDzPGrXgLvLIu6cXKoWgAd6FbZQ8xWX7
         5XyEqBAL1+Uz/rMPX9mlu4ixcNcakDbMbFqRKEptbgo3cRBdAPT4rMV+0aHz3uplIIZU
         e+TlNRoJoShI9TZkrACFR65JF8KBYckRyuHqv+DzWveNPJT8BoLQYEZS+PD8iJMia8p6
         hVXxyrFqU4vUvD7mvC84MgWB2YG+njtcBBTZxWRctJwLG34yIiarW87olyPiZhHQR8Je
         B+QA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764817857; x=1765422657;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=6CDFb0bpksESE4/J8Wb7CxB/SOjxeLFnrYs4RenKTTE=;
        b=VnDGWH3KnfawTJavtcbzz0GHFQKfIHLm9+jMYbj5eE3OJuNPjQLs7pyWqum1f80rAA
         i79R5Xe/qaoZgWDwHXKoX3kMBcLq3olOdc3FXs0W3s00A8O+rSEr8NqzmsI1ar1ilS9O
         24Hala7mMf4Oo9jgvHbQ9axgW9Acmcdff7Jt9X43g3NXRD6gdy8fzl9cYumG3WjkpPKk
         L5pIs/cAtCQq7sr90yYShW+otsvlkJ3OrrIVyhHfyOg/hYdrPs4lHhC/rqRO4MNUL+58
         QJDxZQOKHawDe2nklCiLhTmREE4DaY10bYtpRF5ldVPI8+70FCb3EFkY2qCTJHEgSqyl
         Mbyw==
X-Gm-Message-State: AOJu0Yx0ILwTgd3h6BseEKUhfgzbueHQQkUjgXng2OEQ1kK9M4d9eU04
	lgX6KLWI6wloy7NVDbudA6uAkCbKHGoO4L21D5WQvTxHyQDBCA1y8/bXU+Myf/MJIwGUN6xp6LW
	a8hiaJlI7Q6fUTQo2RNqiBN21E/pOpAA=
X-Gm-Gg: ASbGncvr1LL/rEAvwOm1FcLukAwFKEWQdSEBN3X8xmGB5gfDx9zqFB+srbvBy3pH7xl
	2G1rZco4yet1ue+WoOe+rZnEmTgoHowVNwz8YllCoXgUuqwS89Vacan7ffmXxKtJAfAvW3GLlDg
	dgT2VjfDupHq2/sqhab9+Mpk/GqGkuFGdJdLISVxkgdknzy6GBXWk3QSoLw2LsjTG5kav8aOXay
	45D9m/d3hMdhxeBpkjjAI2Xbcuzvr+PkWELjTfpmh7i4InTcK+otp60DtfLRD5IHm2vjqs5pdsN
	2M+oKxEpaFmBfy9DvxmS6Vq0Bfw=
X-Google-Smtp-Source: AGHT+IGbIruATuS5rSTjmVmpO6MZFaUcub6X9qn0WBFkSZuQaFfrYRuM6t07BCCB715D+TcmA1ie5G0KzrP2IUy4SD0=
X-Received: by 2002:a05:6820:f016:b0:654:f77a:1a5c with SMTP id
 006d021491bc7-65972713912mr2382771eaf.3.1764817857423; Wed, 03 Dec 2025
 19:10:57 -0800 (PST)
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20251204025323.2901775-1-dongsheng.yang@linux.dev> <20251204025323.2901775-3-dongsheng.yang@linux.dev>
In-Reply-To: <20251204025323.2901775-3-dongsheng.yang@linux.dev>
From: Zheng Gu <cengku@gmail.com>
Date: Thu, 4 Dec 2025 11:10:47 +0800
X-Gm-Features: AWmQ_bmxujgU04VwDAhZqvxc8WjJ5qP94IOEoHVFFf6XNqKpx2jar6GvNxiEZHw
Message-ID: <CADSj-VqxriEVLGSDbtyW8SUj5+wxzk9t=LUjof923KvkfGThgg@mail.gmail.com>
Subject: Re: [PATCH 3/3] dm pcache: fix segment info indexing
To: Dongsheng Yang <dongsheng.yang@linux.dev>
Cc: dm-devel@lists.linux.dev, chenl311@chinatelecom.cn, mpatocka@redhat.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Dec 4, 2025 at 10:57=E2=80=AFAM Dongsheng Yang <dongsheng.yang@linu=
x.dev> wrote:
>
> From: Li Chen <chenl311@chinatelecom.cn>
>
> Segment info indexing also used sizeof(struct) instead of the
> 4K metadata stride, so info_index could point between slots and
> subsequent writes would advance incorrectly. Derive info_index
> from the pointer returned by the segment meta search using
> PCACHE_SEG_INFO_SIZE and advance to the next slot for future
> updates.
>
> Signed-off-by: Li Chen <chenl311@chinatelecom.cn>
> Signed-off-by: Dongsheng Yang <dongsheng.yang@linux.dev>
> ---
>  drivers/md/dm-pcache/cache_segment.c | 5 ++++-
>  1 file changed, 4 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/md/dm-pcache/cache_segment.c b/drivers/md/dm-pcache/=
cache_segment.c
> index ae57cc261422..9d92e2b067ed 100644
> --- a/drivers/md/dm-pcache/cache_segment.c
> +++ b/drivers/md/dm-pcache/cache_segment.c
> @@ -56,7 +56,10 @@ static int cache_seg_info_load(struct pcache_cache_seg=
ment *cache_seg)
>                 ret =3D -EIO;
>                 goto out;
>         }
> -       cache_seg->info_index =3D cache_seg_info_addr - cache_seg_info_ad=
dr_base;
> +
> +       cache_seg->info_index =3D
> +               ((char *)cache_seg_info_addr - (char *)cache_seg_info_add=
r_base) /
> +               PCACHE_SEG_INFO_SIZE;
>  out:
>         mutex_unlock(&cache_seg->info_lock);
>
> --
> 2.43.0
>

Reviewed-by:  Zheng Gu <cengku@gmail.com>

Regards,
Gu
