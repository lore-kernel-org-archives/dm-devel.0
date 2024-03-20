Received: from mail-pl1-f182.google.com (mail-pl1-f182.google.com [209.85.214.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7005E69E0A
	for <dm-devel@lists.linux.dev>; Wed, 20 Mar 2024 17:15:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710954921; cv=none; b=DdmjoFlXgZ8XPZCF0cva0rssqZK953ZFVUKO7279cnzwiuVRQZyjI9IYDN4NU/cQbJPiGncY8/wmZA0Hgl+D+m4Au4598ZSJWyqiDAeljF2mVuyJRGdvPyr6caoSkqGFkrKg6fBKGGev5lPPNxMNWXqVO5MiFbTnxzUM2jtUxHQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710954921; c=relaxed/simple;
	bh=XgLLe/0HidMplx5GiFezhsQrFnXrNoWbzeUa4QSU3u4=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=jx2EOH47BtRK/AtfmMIh4NXjoBx0feWfnneFhXlNP95OtJuFLiDkKRRcnDpiNdfx95KAd67jmJMZAExENV0istw8ImdMr+wOUolikafYiNQdere3KYmUWXAA3TBWwHpPGOSaZEJPhYknUszw7Wnl+W7opJycZi2ffF4ZNVKMi1o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=M65BGRxc; arc=none smtp.client-ip=209.85.214.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="M65BGRxc"
Received: by mail-pl1-f182.google.com with SMTP id d9443c01a7336-1deddb82b43so8875ad.0
        for <dm-devel@lists.linux.dev>; Wed, 20 Mar 2024 10:15:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1710954920; x=1711559720; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=oIp5RcXnXJ7qPYcrKHILUGb2p95lzF1Zlt+aRd98e2s=;
        b=M65BGRxcv0FwdDu+yXm6zte8Fw1UYwyYUR8Ot12PmhhbDc2qmNYAcnA1RSVyhD5NZI
         8CKKmjsJ2fGntFTGD+CAYj732LLkCx/m4QFe7lux3Mv3M+FRH3bCblUPbjTh7m2iQidG
         vm2Gh/qi92DT2/gU6WVwN3MDnS85+6lal27vOiQTazyVunZdVoCql6TXPY9Y3vDukgks
         KBMx7kAfu1buH3wsQVqucOD2Jb6hLEqpvxyyT2mYRzq5lyoxS1hCLnNYZ5rYkjI2jrsx
         v+E0nBqlS5fHPWc8fGy4313SYviz79tPWjErxbWEUC3EsN513UBnHC5Ckaix1WiY3dmI
         jveQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710954920; x=1711559720;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=oIp5RcXnXJ7qPYcrKHILUGb2p95lzF1Zlt+aRd98e2s=;
        b=dC7s8SPLBXk3C6zqn6+MeniwqyHyHHp9oQBFiR3gDojll3nV0IhCIcf8KJWHhBMQH1
         coe51JT7gLtS6jxSufM9W/arFLxbj51g98HBUO6rFNnQRU0kTskDcWVDNwqt+Wla2xtu
         LjDxh29vGCN0jHDGS3ZYqIfFsH+m+CAZmdUZy/wiEtApCB/Qi2/WhIwEAzpSLRunx+us
         RtWMNhtHcZxMrvH5OTJ0GCjeBuerfStzYYHvrV0srFmmL+axOVDn4luPKGa+7+4yWuKT
         HAt5wF5p+pv9eoooFN8OiACuV/Dv1LDrF3Qqbri6TNRF3OYdmiI6w5eDGdLqKSFDtCKG
         AKnA==
X-Forwarded-Encrypted: i=1; AJvYcCXFLEm60Ul3WsiS472eSmKugz6QzPZ2cUDOZN7OC8+83Aduq1eiv25NRAzZyI2nF1JYpTQNthzhA7TE4qWtYPiBKR6L8PuDnPk=
X-Gm-Message-State: AOJu0Ywu2B4uZBUljMI25QiGeU7sAh7B0YrxiV00sv69MRh4dK4rRhaG
	8utl+M++Z026IgfZRYRsF5i8V8czSo6e0HVwqLHOMqfwacP0dPXzu/vF2owBqGbcB9ApaJPt7wX
	wlnjYxnb7WcfyYcRjiEcViQhaZzli9S8Xq8lS
X-Google-Smtp-Source: AGHT+IGD/YlWW3iEs0IrRWmm6hXwC9f92VNOJhCPilELzQoK/i7dejWld8froyLEaz/lQCnkq961NX8v3FntamPL7Gw=
X-Received: by 2002:a17:902:e74d:b0:1dd:9e99:f6b2 with SMTP id
 p13-20020a170902e74d00b001dd9e99f6b2mr306294plf.20.1710954919511; Wed, 20 Mar
 2024 10:15:19 -0700 (PDT)
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240320145417.336208-1-visitorckw@gmail.com> <20240320145417.336208-10-visitorckw@gmail.com>
In-Reply-To: <20240320145417.336208-10-visitorckw@gmail.com>
From: Ian Rogers <irogers@google.com>
Date: Wed, 20 Mar 2024 10:15:08 -0700
Message-ID: <CAP-5=fWAF33f+RnaXNQd6NNJUr=UQzNGAEo_-G07CD5q8Xmrow@mail.gmail.com>
Subject: Re: [PATCH v2 09/15] lib min_heap: Add min_heap_sift_up()
To: Kuan-Wei Chiu <visitorckw@gmail.com>
Cc: colyli@suse.de, kent.overstreet@linux.dev, msakai@redhat.com, 
	peterz@infradead.org, mingo@redhat.com, acme@kernel.org, namhyung@kernel.org, 
	akpm@linux-foundation.org, bfoster@redhat.com, mark.rutland@arm.com, 
	alexander.shishkin@linux.intel.com, jolsa@kernel.org, adrian.hunter@intel.com, 
	jserv@ccns.ncku.edu.tw, dm-devel@lists.linux.dev, 
	linux-bcache@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-bcachefs@vger.kernel.org, linux-perf-users@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Mar 20, 2024 at 7:55=E2=80=AFAM Kuan-Wei Chiu <visitorckw@gmail.com=
> wrote:
>
> Add min_heap_sift_up() to sift up the element at index 'idx' in the
> heap.

Thanks, should min_heap_push be updated to use this sift up rather
than its inline version?

Ian

> Signed-off-by: Kuan-Wei Chiu <visitorckw@gmail.com>
> ---
>  include/linux/min_heap.h | 20 ++++++++++++++++++++
>  1 file changed, 20 insertions(+)
>
> diff --git a/include/linux/min_heap.h b/include/linux/min_heap.h
> index 36023e0be232..af12531474a4 100644
> --- a/include/linux/min_heap.h
> +++ b/include/linux/min_heap.h
> @@ -194,6 +194,26 @@ void __min_heap_push(struct __min_heap *heap, const =
void *element, size_t elem_s
>  #define min_heap_push(_heap, _element, _func)  \
>         __min_heap_push(&(_heap)->heap, _element, __minheap_obj_size(_hea=
p), _func)
>
> +/* Sift up ith element from the heap, O(log2(nr)). */
> +static __always_inline
> +void __min_heap_sift_up(struct __min_heap *heap, size_t elem_size, size_=
t idx,
> +               const struct min_heap_callbacks *func, void *args)
> +{
> +       void *data =3D heap->data;
> +       size_t parent;
> +
> +       while (idx) {
> +               parent =3D (idx - 1) / 2;
> +               if (func->less(data + parent * elem_size, data + idx * el=
em_size, args))
> +                       break;
> +               func->swp(data + parent * elem_size, data + idx * elem_si=
ze, args);
> +               idx =3D parent;
> +       }
> +}
> +
> +#define min_heap_sift_up(_heap, _idx, _func, _args)    \
> +       __min_heap_sift_up(&(_heap)->heap, __minheap_obj_size(_heap), _id=
x, _func, _args)
> +
>  /* Remove ith element from the heap, O(log2(nr)). */
>  static __always_inline
>  bool __min_heap_del(struct __min_heap *heap, size_t elem_size, size_t id=
x,
> --
> 2.34.1
>
