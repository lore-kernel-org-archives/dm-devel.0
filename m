Received: from mail-qt1-f172.google.com (mail-qt1-f172.google.com [209.85.160.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5658D3D0AF
	for <dm-devel@lists.linux.dev>; Sun,  7 Apr 2024 19:11:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712517107; cv=none; b=XKm/fgoyhSG423p76i83l7kDb+3HplpXDXh3rKIK/7xstx3ygJf/+uKYulL0DvqI2v0S3APGQY89GYwXTPMH8McTWFaAykYIn6Q9w4xlXYWFvfSJ0Ymf1nR0znOrvbviYygG7AjYL5f6dtJzhtdpZUBjuSGjDQzw9i4iaJm8mb0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712517107; c=relaxed/simple;
	bh=5+ZSDJ1c1wayZpu3rSXMMx/gAZAOYnaNUAMMmnOCKrs=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=E/rYNmvdFgx/IcbryYEY6SG01xRd9d0LsPDnuugAfHGD4faB1DDGrWN7hipj2xpHE+H1WPZ6aKRmxvdHrIg0m7ncr6LlaXdxfLlXTmQNGWeJB8orHcLmnwlLw246BukH47m276gy2ELzhVSkWDcSnryDG2pa5bo/zynp1DZfJpc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=yWrI7tqo; arc=none smtp.client-ip=209.85.160.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="yWrI7tqo"
Received: by mail-qt1-f172.google.com with SMTP id d75a77b69052e-431347c6c99so317181cf.0
        for <dm-devel@lists.linux.dev>; Sun, 07 Apr 2024 12:11:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1712517103; x=1713121903; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=lNNV1iViAab2iT4F4Gl3z4rLSdw9SuHLMYt6mT0uMl8=;
        b=yWrI7tqo8gs0Zlfp7jnPNFV3G68I1hAZDFIXQyCfAIfK2RJ3kC75YXKOzYfLKQqu+L
         x7tDg4iq7/eXioiz/Wfbg//3mt/IMtgG2V+N/32+bofmnfJgALRl7K6MFktIU0eJc7bt
         Qbk5K6GM/YsR2t2wdLMoaTOj6NB64UUZb7tLGJDKWOg+YbbdmzLl808TIoukf8T2xkLX
         x89gfBSgUqXHDuGvMTjbOGlDfg9aBIxSp0oZpCTrfFjJgVpQrS8OJzJXj6x+Wm2RNuLv
         aSG80UKayc0UJsheW4aHFsMV49a3d4zUVX5AeOa9xNTT/1PoE5jpaXSnTykR4zpucqmk
         0aKg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712517103; x=1713121903;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=lNNV1iViAab2iT4F4Gl3z4rLSdw9SuHLMYt6mT0uMl8=;
        b=CBy0tDSSwCuHEBEgI6ajFIcV7jxaPC4Ol7T7w+QT/PXYfY3NftxE/NDJ828IzEwBYe
         VHFO1U7oNmzmTWIFHo+NsZdYOn00v1mOpBMxoOjaCTTN4q/HlRUOFc1PJ7MClXhLtaOh
         y/mqveLuLvkHkwqjGV4XwyetWstzMFIphoVtkrDJNKvVJV3Dl/fS2P1qxtsJkyJiccsx
         iul3Rf59xHVG0CsJsHWqDVH0nihOoJyM6IUTAVhl6c8TyzGvn6UY5Ff6B/lmMsdNGU3V
         jjmjv5iVTfI3+mGchnd0Xp6m7D33IKV2rcJDHWqfeZA9f3wTQNUMYxu5J8po7vEdTiUY
         3UEQ==
X-Forwarded-Encrypted: i=1; AJvYcCV+xB9LnT8ITYeQcCWeoqrne0XSFZmoPhiOFq1Gv8WOY8HY1kzQOhzh2aNOwrbBTsMoC84FPYly13CcD79/MShJ999fWbQh+aA=
X-Gm-Message-State: AOJu0YxTMKsFPo2anPkoCY0kqOl7WVt/Vf3VpEeFg5ZRUDXlQ0vmBh/I
	F2A0/ytabMcKmH2/3s8tjRhTzKm7Ilu8p4EKXhrjBswPQCL7fVFxzjI52WzU3MOOq1bLbbMjY2k
	l0yElIQ8XS4+mzgbL+efE8MJw0ZwOxnudJd7/
X-Google-Smtp-Source: AGHT+IEbVQ6rh/yVlB3vPD78DUbrZCMUoVH6z6E9ojPzKJf/d8f7GOzVNi588miJW/ClBy/V8n3f5DvHgoDRclWzJ3s=
X-Received: by 2002:a05:622a:4812:b0:434:7bb9:f231 with SMTP id
 fb18-20020a05622a481200b004347bb9f231mr176338qtb.12.1712517103175; Sun, 07
 Apr 2024 12:11:43 -0700 (PDT)
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240406164727.577914-1-visitorckw@gmail.com> <20240406164727.577914-14-visitorckw@gmail.com>
In-Reply-To: <20240406164727.577914-14-visitorckw@gmail.com>
From: Ian Rogers <irogers@google.com>
Date: Sun, 7 Apr 2024 12:11:31 -0700
Message-ID: <CAP-5=fXYVBeT0Egypq8Ja4DMX=csWBhMoKuuz=WQxsd7iPBAxw@mail.gmail.com>
Subject: Re: [PATCH v3 13/17] lib min_heap: Update min_heap_push() to use min_heap_sift_up()
To: Kuan-Wei Chiu <visitorckw@gmail.com>
Cc: colyli@suse.de, kent.overstreet@linux.dev, msakai@redhat.com, 
	peterz@infradead.org, mingo@redhat.com, acme@kernel.org, namhyung@kernel.org, 
	akpm@linux-foundation.org, bfoster@redhat.com, mark.rutland@arm.com, 
	alexander.shishkin@linux.intel.com, jolsa@kernel.org, adrian.hunter@intel.com, 
	jserv@ccns.ncku.edu.tw, linux-bcache@vger.kernel.org, 
	linux-kernel@vger.kernel.org, dm-devel@lists.linux.dev, 
	linux-bcachefs@vger.kernel.org, linux-perf-users@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sat, Apr 6, 2024 at 9:48=E2=80=AFAM Kuan-Wei Chiu <visitorckw@gmail.com>=
 wrote:
>
> Update min_heap_push() to use min_heap_sift_up() rather than its origin
> inline version.
>
> Signed-off-by: Kuan-Wei Chiu <visitorckw@gmail.com>

Reviewed-by: Ian Rogers <irogers@google.com>

Thanks,
Ian

> ---
>  include/linux/min_heap.h | 9 +--------
>  1 file changed, 1 insertion(+), 8 deletions(-)
>
> diff --git a/include/linux/min_heap.h b/include/linux/min_heap.h
> index 3086612d7cd5..fe037eb5952e 100644
> --- a/include/linux/min_heap.h
> +++ b/include/linux/min_heap.h
> @@ -190,7 +190,6 @@ bool __min_heap_push(min_heap_char *heap, const void =
*element, size_t elem_size,
>                 const struct min_heap_callbacks *func, void *args)
>  {
>         void *data =3D heap->data;
> -       void *child, *parent;
>         int pos;
>
>         if (WARN_ONCE(heap->nr >=3D heap->size, "Pushing on a full heap")=
)
> @@ -202,13 +201,7 @@ bool __min_heap_push(min_heap_char *heap, const void=
 *element, size_t elem_size,
>         heap->nr++;
>
>         /* Sift child at pos up. */
> -       for (; pos > 0; pos =3D (pos - 1) / 2) {
> -               child =3D data + (pos * elem_size);
> -               parent =3D data + ((pos - 1) / 2) * elem_size;
> -               if (func->less(parent, child, args))
> -                       break;
> -               func->swp(parent, child, args);
> -       }
> +       __min_heap_sift_up(heap, elem_size, pos, func, args);
>
>         return true;
>  }
> --
> 2.34.1
>
