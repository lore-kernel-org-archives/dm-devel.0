Received: from mail-oi1-f172.google.com (mail-oi1-f172.google.com [209.85.167.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CCA301CAA4
	for <dm-devel@lists.linux.dev>; Thu,  4 Dec 2025 03:10:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764817804; cv=none; b=paXhVuO2uKc0uRIhFvXRmrkv/3YW27pNJUqQjRPkpFoeMQ2acMWPkjO2oxdgkaZdLJuflAQp63hzC1YZWmzrpDF1dYv/HneRaQMgu/SOoP3Ua34YVNAKG9dkvMrbNTmtCROYtV/HW0aNX0OsYNIfe2ZONnC/0FoEEvJJXJS9icw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764817804; c=relaxed/simple;
	bh=We8j8V1JbhyheOj1mb3dscZ4Pupw9kQRzJKM70LoMUc=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=mcBPa4Cf6R75arg0RlSOtKdpdFWuHJQ7Pg+Zoco166cXNRkhGzW3VLtTGhpieBKuG9yGVjFEjUs99BwvQER7fXoFrDHQX8Ls+k+w7/HC6eYPbYB6hUmP7ZJeDMyAP1G/X2unY7Z20Y//KQNJQdh+k5BK0U3kOVbxSV0hThKcgV4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=eFDCX1EM; arc=none smtp.client-ip=209.85.167.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="eFDCX1EM"
Received: by mail-oi1-f172.google.com with SMTP id 5614622812f47-4537c9405ecso56810b6e.1
        for <dm-devel@lists.linux.dev>; Wed, 03 Dec 2025 19:10:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1764817801; x=1765422601; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=OCGjWA8IP2+w5K7P0BwxlGh7AHXpbtuY6D19IhpYuYI=;
        b=eFDCX1EMOuXedA+g5cofk2TOQbYOXvVkmxpQqRrxnSuwxcHhjca0HwRW/RLzaYA5BC
         oOOfBuY0rEnTvRiB72RqYuRMdHguh1QQZgo5r1kI5xSuBBIi6K4gZ9n39JXdk3tvPt7j
         d5vZhhPDFIAnNR7ifqk1T45etj8FqDV9jS/vbG+JvFfv+tGjwkjxd7dv+PXBUAKooab1
         P5cutf+Scdqspa/nk7I4ATeX1WHRMOKjds1NaZCxlvfIIyc/U2VI2MxF1DuJySOJodRy
         U0gmWgPkCYIRakjn8VknpEl2DktK3s9sN6JbhmFiRKXPXHEasW65hawVMcI/lE1FOeay
         GB9A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764817801; x=1765422601;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=OCGjWA8IP2+w5K7P0BwxlGh7AHXpbtuY6D19IhpYuYI=;
        b=I6l0yWQZtN2/1rmJOvC8IX25dR91pG5ejZAAAGv4zjT8grV2dTt9qWng3n2i9/QOYA
         A8UJ5qBDPvrP4k0rBkzdCiOGBbyHw8+wYZ8yjhmbD1j83jQAaLrH8lgk8kx7+lKNlw7L
         KMgvZM/f3PkSL/yw5DhZYJtiXaXraykGsBBqEusdJA5xg/18lWw8pu7QZs2oqoDX19Gj
         tLJMIGSS7HRLEXnYKY/9t7EI4d0XTfx0ggq3Au05vv8Z9NGo258w2p/cT7ODYcuYf/+b
         OiXpcEX4Ur8KPpMndJpmkpxNrPJt/QdTB7oCo3TDURVbP1NWQZevOufRX3cP1vsGwcx0
         HmjQ==
X-Gm-Message-State: AOJu0YyYU7siS2oo47c79fdxgA585GjhlR/hMOtRNzbYKbjLUueSmdLG
	YYPVpMvhbuHvlpP/4C3eBCXLrcgpOGbShjQKCixJxweVVQoIAQf6GVW8jjvQhyrqW9cz3grPp+l
	lhejMEM6dp9JO+IXl9wFEPLOKE955POA=
X-Gm-Gg: ASbGncu0tvKqbWPixhJrfW4/4QWFPMWMt4yq44WLeEtgZBUbjAyn0qxgjEvvTdp3CIP
	nXL3mBmgvam0V2wUO2qUXhLXhYplo5d6NEmi6NnJGRjuJVfUUTHPTbO7H2/girVjIBSoor9vFFR
	PYfe8qssZ8SR98LEV0YG5Le+lvHKQqIMd9psoIkCNNwA7JROJWHcfbz8FjkzrQBaE/MS8KZyLlD
	6dvTwGF9MSplmeZD/7lHrxL57vutDkZaF9wiy7iVMSsV6rbbSnKYTOOFv8/8ejEFH8i8sAnDmwo
	3xX76ji12X7Uz5JKNRmSppodQSccZwpJXsJEug==
X-Google-Smtp-Source: AGHT+IGQA8W8PXrmVBrbq7fkCbPtMfe9U9Lpp93X+0mjTNl7ODtRhzfNQH3nZbWnCXQSxFQAP8YAl9c+qhcPJo5O0XQ=
X-Received: by 2002:a05:6808:1443:b0:444:1450:c1 with SMTP id
 5614622812f47-4536e5bad8bmr2475447b6e.64.1764817800742; Wed, 03 Dec 2025
 19:10:00 -0800 (PST)
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20251204025323.2901775-1-dongsheng.yang@linux.dev> <20251204025323.2901775-2-dongsheng.yang@linux.dev>
In-Reply-To: <20251204025323.2901775-2-dongsheng.yang@linux.dev>
From: Zheng Gu <cengku@gmail.com>
Date: Thu, 4 Dec 2025 11:09:49 +0800
X-Gm-Features: AWmQ_bkn-AjWP8YyTVG_UqMYgU-hkRzPPxHfT9K7hZ2nuKDLhn4aNOyZfDO9pOs
Message-ID: <CADSj-Vp-B9SCYPLW5XoWqTN9gapyq-JqtSYEJYb8d-Qt+TQ3Vg@mail.gmail.com>
Subject: Re: [PATCH 2/3] dm pcache: fix cache info indexing
To: Dongsheng Yang <dongsheng.yang@linux.dev>
Cc: dm-devel@lists.linux.dev, chenl311@chinatelecom.cn, mpatocka@redhat.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Dec 4, 2025 at 10:57=E2=80=AFAM Dongsheng Yang <dongsheng.yang@linu=
x.dev> wrote:
>
> From: Li Chen <chenl311@chinatelecom.cn>
>
> The on-media cache_info index used sizeof(struct) instead of the
> 4K metadata stride, so gc_percent updates from dmsetup message
> were written between slots and lost after reboot. Use
> PCACHE_CACHE_INFO_SIZE in get_cache_info_addr() and align
> info_index with the slot returned by pcache_meta_find_latest().
>
> Signed-off-by: Li Chen <chenl311@chinatelecom.cn>
> Signed-off-by: Dongsheng Yang <dongsheng.yang@linux.dev>
> ---
>  drivers/md/dm-pcache/cache.c | 8 ++++++--
>  1 file changed, 6 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/md/dm-pcache/cache.c b/drivers/md/dm-pcache/cache.c
> index 9289c016b7c9..bcc4e509aa69 100644
> --- a/drivers/md/dm-pcache/cache.c
> +++ b/drivers/md/dm-pcache/cache.c
> @@ -8,9 +8,11 @@
>
>  struct kmem_cache *key_cache;
>
> -static inline struct pcache_cache_info *get_cache_info_addr(struct pcach=
e_cache *cache)
> +static inline struct pcache_cache_info *
> +get_cache_info_addr(struct pcache_cache *cache)
>  {
> -       return cache->cache_info_addr + cache->info_index;
> +       return (struct pcache_cache_info *)((char *)cache->cache_info_add=
r +
> +                                               (size_t)cache->info_index=
 * PCACHE_CACHE_INFO_SIZE);
>  }
>
>  static void cache_info_write(struct pcache_cache *cache)
> @@ -49,6 +51,8 @@ static int cache_info_init(struct pcache_cache *cache, =
struct pcache_cache_optio
>                         return -EINVAL;
>                 }
>
> +               cache->info_index =3D ((char *)cache_info_addr - (char *)=
cache->cache_info_addr) / PCACHE_CACHE_INFO_SIZE;
> +
>                 return 0;
>         }
>
> --
> 2.43.0
>

Reviewed-by:  Zheng Gu <cengku@gmail.com>

Regards,
Gu
