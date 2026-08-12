Received: from mail-pf1-f171.google.com (mail-pf1-f171.google.com [209.85.210.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3522242FCA1
	for <dm-devel@lists.linux.dev>; Wed, 12 Aug 2026 14:13:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.210.171
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786544000; cv=pass; b=W3il4PKqPUfJ/I9JkcFY7AmZw8kbT04orUFzKlLhMHTff+GPdloggB4ZoXFb/Uepz4Lzkvawd7IxnnVFwKSdJ55gVBCbUMQ7MC5PK8wzQheLZT1nAhjFoW6VZdcKcu/1v5TdQBFDROKVSu8kHCj4/+C4NoYG6OnZpUYI9w11l+0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786544000; c=relaxed/simple;
	bh=Qp5UpWvd+sZgLVxPWSiH/DwBnHjOyM74Owmh1LDV2qo=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=HF0lY6bdyg29CIDPJmFlo0R7DyAS7J6nXwldlhaj2bC4EB+mOVKjoYspvvohDRKiooi4zGpTX73O928CTXOmtr3wcniijlFvogb7vf0w0YTE3wYwK2ioc7jyT7kEGjD0w48gCPEBjS2RFrtd75voEM0/Umyf56H4Op9sEVXtxf4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=kkjZjedh; arc=pass smtp.client-ip=209.85.210.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="kkjZjedh"
Received: by mail-pf1-f171.google.com with SMTP id d2e1a72fcca58-84faf0fa17eso1179371b3a.2
        for <dm-devel@lists.linux.dev>; Wed, 12 Aug 2026 07:13:18 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1786543998; cv=none;
        d=google.com; s=arc-20260327;
        b=SV+OP2NnaVA3WaMo68fvNGuH14LN3SEipaHoGc3Ik3mAd4AkQzh0YKeVYBDvhlB2xr
         oOJ1Rj14EGN95WEQMOnqCmho8FmCVgHahpgm9dEeurkMRmLmPWI730jT1JO5V4evMVvX
         CEeNvOnArP0B/AojMv+HLM7U29r8086MXeAfYk8SjbVLU+NrKmzNSnblf64hzIKJ0NIy
         DUn26lPzuVNhwsphcLfBY7do9OJiGIJ7QzLGboSOhQBGvKZvOwWdGcYTL9j5SfJicecZ
         r6ZLIoV066KofwMWpEMSYNXUcYDI+MwvwM80Di9fFMUgoD9tsCsnShYnbOJw2wymxpNB
         T86A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=CmG/Uptof4bNWWsnYjR58EMgQIHdGvYH6ZApc+gNdhU=;
        fh=U5J/uFIWYYYkynrE5bafa1y1uD9IP0zVFtQeZJpC1aI=;
        b=NxrgWPf4ezSxwiDKyQOSB2uGKTuc/N9XH2EZoO1VoEnUHFlTOZewt0pZRzfnaqAyLT
         HGibBU69fcLP0stZ9JhgWdNdCZ1HIYkm+D3Lqu95VInR9/jwSSh/vqr5c07sqlgMfC0x
         MkiTayniov/pF5PU9owayzZaeOke1AZQz+pP4EIga7u231NZVPKl5Wb2IuiWEtiqrCDD
         TDy6gktfw4AReqUA3XOfmMTIL0EUvM+DqqCyQfCEI+YKBBHpWaS0zR6kMUpATkjWJ5kZ
         jKYK+ZwkIq8GDU5wHqp14Fu0OdaSQLk75adhjMjqIAbew6/iy0jOQmCQ2nwiH76XGQHx
         KsYg==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1786543998; x=1787148798; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=CmG/Uptof4bNWWsnYjR58EMgQIHdGvYH6ZApc+gNdhU=;
        b=kkjZjedhtqxUAmBoBavmXXfEmOlSjK1BCsJ+yrqlBdYtAusoH06c5mjRQtGOHXtoSB
         P+YHYVtmet41cEX6OKt0Ot/1JaVdOwrb3lhSiB11hGCfMXNluoxUyDrEramPhUYDR/A0
         L21vzmftxoaF2MGlTc5UF9efLBCjzZPzvFm9puBO1BcD9Xp1yDsSf+b/JlD8G2Hb5I0m
         NOeFiYLn7Ky/gAtYUhCocw8VBKN/5U9feqLZ1QW0+vdZwpLWMEhPyt6NLTM1J3+dUm6R
         f71/b85Scg6EaFWGr8erzTXZ5ncpzPArgjH/E4zaOEkF5pkOokIK6NxbXq9TR89ikANJ
         GCAg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786543998; x=1787148798;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=CmG/Uptof4bNWWsnYjR58EMgQIHdGvYH6ZApc+gNdhU=;
        b=SPXcj2LUmD+/zkcQiiXmljDME2WE5Z99WJsSMdW247L2JGXuOIPNUkQuCjzniJkMKz
         r0POD7f4R4Uff456fx60v6eFIOtIiQ4StIXseXS6M7ouoBRSqS8PeMa1b/EHYc9+u0Sw
         friFo3LUDjhssCUsMOPmrIgKo0mZu/TctGrbgBrMSJt2TfnWbb2Tad4JWm4VhGtLLpTh
         7TJcgJhfUU8ekWn1W2gUM0+x+IaYgyiThFzGUYF2Z0N3R5282DRp59n5dW4uFPviKGPX
         G8/c1nq+ebspvi3C1qvMWN27Kv9eIIw2UsGj6GZyk1lh8OmrZnFD2c/FvWON2amwVqdC
         CWiQ==
X-Forwarded-Encrypted: i=1; AHgh+RqiAxLaGOLE1aFBAUUJxglGcYtAX/WMWStlb0Oo9ncwq6gPncb/aNOqQZLKBKOoPXooEferTlFNfw==@lists.linux.dev
X-Gm-Message-State: AOJu0Ywm5PvnYzKyTEbLoHIPQtaJDhcCjbJ3+gjTzGJ6UrY6OFvqbJkI
	a2CY3+Bt4N1h34DhIvaog272dDLWgP5v6h85HQH18B5IW0wCs4ilh9eWZBxOlMOI0YeWJ96ssij
	vyqOVUtHwwV9UBpyOccjbydY0FEVXh15YRjygTKk=
X-Gm-Gg: AR+sD10n3rZCRx13vhBInWGBLSgZmHR0HMNXIb0ZqX58+POMbz+UUbjhOnHPPiouC2H
	5999ktlU3Z0UADin5O138Qw28kJ4ZZImLWsl/cUevLco9O1JpewdZixoUhm/Z8tQ/L/KnfkO4Bh
	z/5I9ms7Uy1S4JUfgHwxcAQo4fqsHMnXcdEmD4wV9SKoiUDZodmGajJDW99WJDme6n2ONzRcipv
	dvyCFzrSteUUjS0JdfPsXqhjj+uWgR4q8ncgfstpxi6LuO4dtZkTEOa/LmphyKkkvs/lY3eQyj3
	ihuY37oMiw9k6eV1oKoXaz9yzBa1SlIsVyatRCS+ZyvMIKBfwg==
X-Received: by 2002:a05:6a21:6007:b0:398:7ed3:a001 with SMTP id
 adf61e73a8af0-3cc3f52b9e9mr6263412637.2.1786543997783; Wed, 12 Aug 2026
 07:13:17 -0700 (PDT)
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <a139443-d6de-7be1-c59b-c099b0b32884@redhat.com> <CAPBLoAdgefcQ=otsy4GMsCCAgzY=7E1bDBtZsKMFy+Af0nPVfQ@mail.gmail.com>
In-Reply-To: <CAPBLoAdgefcQ=otsy4GMsCCAgzY=7E1bDBtZsKMFy+Af0nPVfQ@mail.gmail.com>
From: "H.J. Lu" <hjl.tools@gmail.com>
Date: Wed, 12 Aug 2026 22:12:41 +0800
X-Gm-Features: AUfX_mxmm_JsmXBKv-cz0y9tr6aIHb1hE2J_CCsWii9jRO-zgmlXMi7k5LJRJcQ
Message-ID: <CAMe9rOpir_s44Jv_DCMW34RFkh1WQtJ01fd0X+128yc_fzPvRA@mail.gmail.com>
Subject: Re: memcpy is leaking secret data through ZMM vector registers
To: Cristian Rodriguez <yo@cristianrodriguez.net>
Cc: Mikulas Patocka <mpatocka@redhat.com>, libc-alpha@sourceware.org, 
	Zdenek Kabelac <zkabelac@redhat.com>, Ondrej Kozina <okozina@redhat.com>, 
	Milan Broz <gmazyland@gmail.com>, dm-devel@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Aug 12, 2026 at 10:04=E2=80=AFPM Cristian Rodriguez
<yo@cristianrodriguez.net> wrote:
>
> c
>
> On Fri, Apr 19, 2024 at 10:08=E2=80=AFAM Mikulas Patocka <mpatocka@redhat=
.com> wrote:
> >
> > Hi
> >
> > As a part of LVM2, we are developing the libdevmapper library. The libr=
ary
> > may be used to load cryptographic keys to the kernel, so it avoids leak=
ing
> > the data to kernel memory and to the swap partition.
> >
> > After the use of cryptographic data, the libdevmapper library clears th=
em
> > with memset and frees them afterwards. It executes __asm__ volatile("" =
:::
> > "memory") to thwart some compiler optimization regarding writing to
> > to-be-freed memory.
> >
> > We have a test "dmsecuretest.sh" that loads cryptographic keys into the
> > kernel, dumps a core, the core file is analyzed and if it contains the
> > key, the test fails.
> >
> > This test fails on AMD Zen 4 - the reason for the failure is that the
> > "memcpy" function uses ZMM registers for data copying. When memcpy exit=
s,
> > the encryption key is present in the ZMM registers and the key remains
> > there even after both source and destination buffers of memcpy were
> > cleared.
>
> Isn't this what  -fzero-call-used-regs thing is all about? can-t you
> just apply the same technique in the memcpy implementation and zero
> them out on return?
> vector registers are volatile after all.

This isn't limited to vector registers.   If you don't want to leave anythi=
ng
behind, you should use -fzero-call-used-regs in functions where keys
are accessed.

--=20
H.J.
