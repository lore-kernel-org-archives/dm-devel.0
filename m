Received: from mail-qt1-f170.google.com (mail-qt1-f170.google.com [209.85.160.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB990219EA
	for <dm-devel@lists.linux.dev>; Thu, 23 May 2024 03:51:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716436282; cv=none; b=kpcyWEL8VdPBEATxJMKiEMyXIwvo+9XfugMoOb1otu/H6WYRvnJ72X7KisDpZ2zi8jfUXAcr+/c8Jk92eGiz95ZsZc8db5Ia40W8Bg2uYxdFCqbFRebLa7vcGPaPo8ml02Etp54LEIakoKfaLkx/GhL7hWqLTk0kFc1Sm4pbodg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716436282; c=relaxed/simple;
	bh=iMGgLAI0RnofLrCqsYJdrGkFEOjJ+L4/MwpJ02XpNdI=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=LC9lKe/GP2xGiSM4kaFF7DKT0Df6VyIh792PR4AvEBGFfzzbtuIsGnU9dMThCprBPOqbX7LMWGJTN2Z6Zo33n6R8NUzNQd/hwzSElTMRmI3aPXireikCDo13qiu4BrVTMGjERxd+cEyikO+63xwsJ9lwYvW7ec4S8bAUhuNxHWk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=DTYiTGng; arc=none smtp.client-ip=209.85.160.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="DTYiTGng"
Received: by mail-qt1-f170.google.com with SMTP id d75a77b69052e-43dfe020675so299601cf.0
        for <dm-devel@lists.linux.dev>; Wed, 22 May 2024 20:51:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1716436279; x=1717041079; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=b/0+KdIOmws+ZrFm/pd5ZcN2+OOmnR4z08zZunaz/hw=;
        b=DTYiTGng8QfVrJjCD5UbMyULfVWpKLXd++gqHl0qV/3FlkOxEtd6gnvyW9s7uLUsl+
         QPhluAA9/hv7PTXzEz26YgOUluXEu3QgffTX6acdhK4fjgsSZE4BEyLyCJMLsm4KGNG4
         WkYP+QFzDQ4GWK2huYFQITCfwPomnU+8Xnt4evVfThccKBzKFp++by1Js60ljvtDRFOo
         2DDQnrXC0avmxcDx9v1TD3bLXUvBZavss8o2BUugoRFDcCxF7LIv5Pf6EbkWEP0nS9pv
         tXvk3EEEXxVWrkau+xlsezEF4E1d+4NMYkMe6hv/yOBEXJfpZUO6YUGP4rq6IPN1JPLI
         PquQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1716436279; x=1717041079;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=b/0+KdIOmws+ZrFm/pd5ZcN2+OOmnR4z08zZunaz/hw=;
        b=OjfgHnGUMn1rt7NVBrZiSK0Ndzv+N5ay7wNcY4TsRaAWJwcVW20chJhDKpsPpEhtAx
         KCwX1oPvLmBqwrq3dd+dFnn4Vk78LDpzkuC8rcCJEAMKznc/wb1GBPr8aJ9n8XFTTAnO
         HNd9y9IMgB0CBYvnKeXyhvtVPiy3I8gcCIIFZ4tJJfe/dlmEKigcmJkPbR2qpC6aEDHW
         csv0e7xVmA2TEXkPhwNAHP1GrlVbSdsBVsgWTh1ytC9/bQ8fLcSI4SvGpKU/+B46zUZz
         +e4riIPFOYb1E+HVczIYozesgDKhZNqTphz5nfRm8W6+ve/Kty99pzf0ATzpUkmyfig3
         UQiw==
X-Forwarded-Encrypted: i=1; AJvYcCVTyWu6KXn1s0seYIcZ8N45LLw32j2hN0SDU3zBtW6+lJSpXDUmcM6tivlwVSQrdkSp2wdt2b3UfjbrnbHo6mjhvSW3eZ8hF50=
X-Gm-Message-State: AOJu0YyltXV7s2Ngt/lKOsePWEDCPYzLebm0Yioj6lXf0OLzNqjYoanz
	2moFg7vBHlfjlkHPfX+f0AMnjjwlL9P/UyWpbxOJxX9AkABoYppX0Gu9U1XT0tVkBdL7WhkDLeS
	oVPEiW71nEPf33+Zjaw6IywMwQwAUIf3dIFe4
X-Google-Smtp-Source: AGHT+IEF7U0eAjRtPE1F4LSZ58RNB/uzqr2Lsi+zESRmuUtZJz08s97jQaPWmV6NfwanHAB+CCDsqLwqgE/Vu0ZL9GY=
X-Received: by 2002:a05:622a:1b16:b0:43e:cb4:1d10 with SMTP id
 d75a77b69052e-43fa745b199mr1765661cf.14.1716436278572; Wed, 22 May 2024
 20:51:18 -0700 (PDT)
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240514084724.557100-1-visitorckw@gmail.com> <20240514084724.557100-5-visitorckw@gmail.com>
 <20240522161048.8d8bbc7b153b4ecd92c50666@linux-foundation.org> <gch7c2merdegxvqwpbb5ean7uj35tnh62fyviggjglftlfjs3i@jhbnllco5kau>
In-Reply-To: <gch7c2merdegxvqwpbb5ean7uj35tnh62fyviggjglftlfjs3i@jhbnllco5kau>
From: Ian Rogers <irogers@google.com>
Date: Wed, 22 May 2024 20:51:06 -0700
Message-ID: <CAP-5=fWn8AmE=0Y15Y3fm71zK0jsdgvH3UdmKUq5Pe6SAAsKCQ@mail.gmail.com>
Subject: Re: [RESEND PATCH v5 04/16] lib min_heap: Add type safe interface
To: Kent Overstreet <kent.overstreet@linux.dev>
Cc: Andrew Morton <akpm@linux-foundation.org>, Kuan-Wei Chiu <visitorckw@gmail.com>, colyli@suse.de, 
	msakai@redhat.com, peterz@infradead.org, mingo@redhat.com, acme@kernel.org, 
	namhyung@kernel.org, bfoster@redhat.com, mark.rutland@arm.com, 
	alexander.shishkin@linux.intel.com, jolsa@kernel.org, adrian.hunter@intel.com, 
	bagasdotme@gmail.com, jserv@ccns.ncku.edu.tw, linux-bcache@vger.kernel.org, 
	linux-kernel@vger.kernel.org, dm-devel@lists.linux.dev, 
	linux-bcachefs@vger.kernel.org, linux-perf-users@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, May 22, 2024 at 4:33=E2=80=AFPM Kent Overstreet
<kent.overstreet@linux.dev> wrote:
>
> On Wed, May 22, 2024 at 04:10:48PM -0700, Andrew Morton wrote:
> > On Tue, 14 May 2024 16:47:12 +0800 Kuan-Wei Chiu <visitorckw@gmail.com>=
 wrote:
> >
> > > Implement a type-safe interface for min_heap using strong type
> > > pointers instead of void * in the data field. This change includes
> > > adding small macro wrappers around functions, enabling the use of
> > > __minheap_cast and __minheap_obj_size macros for type casting and
> > > obtaining element size. This implementation removes the necessity of
> > > passing element size in min_heap_callbacks. Additionally, introduce t=
he
> > > MIN_HEAP_PREALLOCATED macro for preallocating some elements.
> >
> > I guess it's a nice change, although it's unclear how valuable all this
> > is.  Being able to remove the local implementations in bcache and
> > bcachefs is good.
>
> Yes, and now the standard kernel version is type safe. I suggested it to
> Kuan as a good starting project, I find (well picked) refactorings and
> cleanups are a great place for people to start.
>
> >
> > > --- a/drivers/md/dm-vdo/repair.c
> > > +++ b/drivers/md/dm-vdo/repair.c
> > > @@ -51,6 +51,8 @@ struct recovery_point {
> > >     bool increment_applied;
> > >  };
> > >
> > > +MIN_HEAP(struct numbered_block_mapping, replay_heap);
> > >
> > > ...
> > >
> > > -struct min_heap {
> > > -   void *data;
> > > -   int nr;
> > > -   int size;
> > > -};
> > > +#define MIN_HEAP_PREALLOCATED(_type, _name, _nr)   \
> > > +struct _name {     \
> > > +   int nr; \
> > > +   int size;       \
> > > +   _type *data;    \
> > > +   _type preallocated[_nr];        \
> > > +}
> >
> > I think that the MIN_HEAP() macro would be better named
> > DEFINE_MIN_HEAP().  There's a lot of precedent for this and it's
> > unclear whether "MIN_HEAP" actually implements storage.  I looked at
> > the repair.c addition and thought "hm, shouldn't that be static"!
>
> Agreed
>
> > >  /* Sift the element at pos down the heap. */
> > >  static __always_inline
> > > -void min_heapify(struct min_heap *heap, int pos,
> > > +void __min_heapify(min_heap_char *heap, int pos, size_t elem_size,
> > >             const struct min_heap_callbacks *func)
> > >  {
> >
> > It's a separate project, but min_heap.h has some crazily huge inlined
> > functions.  I expect we'd have a smaller and faster kernel if those
> > were moved into a new lib/min_heap.c.
>
> good thought - Kuan, want to do that too? Since we missed the merge
> window, may as well :)

Just to mention that the perf events use of the min heap is during a
context switch, so it is somewhat performance sensitive for people
context switching with perf events opened/enabled.

Thanks,
Ian
