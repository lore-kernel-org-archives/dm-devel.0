Received: from mail-yx2-f12.google.com (mail-yx2-f12.google.com [74.125.224.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A42BF53B5ED
	for <dm-devel@lists.linux.dev>; Wed, 23 Sep 2026 15:42:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=74.125.224.140
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790178145; cv=pass; b=fp1ZU/PprmINGcxeDB8pbiK22+AP/96d7ROn1qkHBv/gcNLJSzKnAJkp4I6igdpY6HYbAnB6SHeQ9kfEYAFEA44TienLc0zEeDpC/ObZyz/VBkUSnvyMntYCUHRXLSDlP3Mhdln9y7WVny2/lYip8lUMzyC1SHVCVT0M3tPWYI8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790178145; c=relaxed/simple;
	bh=HtZ5CRWVFTgs794gP7zlyaxMmBWztJD4Ak7+nxa8lOc=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=kg0GgU3vMCmY+Mc6PYwmLcXN0YI4/TqCb1Yr1IWNYX6ScMYdesy5+OX996l83mFr259FFylxE4ehoWiB3kgLyA/ONVgCLh8oA4DJOm2PVzEqO7zpPQ/1VAmA8sKt2F0ctJogLQlmknbS4lFat2L1n5eNRWSI2JtXK27gh5ZK0zM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=m5DNQLKx; arc=pass smtp.client-ip=74.125.224.140
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="m5DNQLKx"
Received: by mail-yx2-f12.google.com with SMTP id 00721157ae682-86fbc2f4425so912047b3.3
        for <dm-devel@lists.linux.dev>; Wed, 23 Sep 2026 08:42:23 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1790178142; cv=none;
        d=google.com; s=arc-20260327;
        b=ApHbLrfRzNDKIDlUrtCQ1cUN/FLrWHFvBZz9/P7XTZHSaOwXfepoeW3yo4/UseHfvy
         H7mtByX246r+0YtUOg+PFoBL9zkGOVQhCfqZnkD/8nGkr06RZ/Jd7amAhj5BwnlbjUkk
         +TbGBTc90n0pJPLvqX/NKSNBxch41gvSj/RBgtL9XOCrx8IX2Qg2Rku45vRuFVQZ4giI
         stkJIm0Ib20dNBcxTnvpdOsos7hkWJNA4BZnN2iURDQ+I1C66VfdIORoT9/210EhJLpq
         rPqjr4znqnH7R/oupLAozictfDj3K3AD61A7CLx4DecDHPIFlDF1J708DlqQN3ZvKO39
         Fu+A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=HtZ5CRWVFTgs794gP7zlyaxMmBWztJD4Ak7+nxa8lOc=;
        fh=aEmq1+wMvetJthG541KWW2JCeLKJG4Dtl3D9gEGVz5s=;
        b=YGwdj6s5j/fnbm0zqbT8VRXQleFh6wuLbhD7ZrBh7ulORxzDxJL8gY/TAffSjIJR/B
         OtfudIRwLGxFdM4YqR412rbRyhoinB45r2dsfq1zo5ZtGbe9XV3YmIP9PmZfZUC9Vz6t
         qnPIcOv2PVutf4GC+cV0xyg6GRycxk97Ln9fnmHRjJVYpkURg2x76KM5jULOVQPliUCl
         RX2d6DTjS6g259p5fQFEY6xbVqaFZzl71GL3CTIvCf7GIJlAU3aXHFhslBt3Nl2vNuvD
         6jARQxe6tY0gaGnuyZpVELsuuYiCQNARNLNZw4gnpG0bkkE9u7bznjSQT3c1XaVHYbCd
         xuSw==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1790178142; x=1790782942; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=HtZ5CRWVFTgs794gP7zlyaxMmBWztJD4Ak7+nxa8lOc=;
        b=m5DNQLKxkf4kHcZqPFqkCJBacrq/x0IxWPmwsWcAEejRDn/NRKEecggfnrcdjreGum
         +tx0LAZh3NNR7AN8y+8x9cgG8FJ6rddUczd42CJtoQ9o29Vn+1kH4b1qQKn/Ho5fkHt9
         zTSFxwGzTXQRRnUfreBv0GWiPzeWs61XG8hnohMXdL8bWBKGVr/KABB1m6EWGz5lVZBx
         Zo43ZDBTLONSkpb9zAI1ZpZ99boLqHnaJHKOGiZlRtwuYjxnSf5KXy5EPYBcsrzZ8/rt
         qkc2D13e6Sh+vE5vRX16J4n2Ij3NMJM4eioHzhSLEpUZvRCjDuP7u1oLleO6GqqmcEQb
         kCNQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790178142; x=1790782942;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=HtZ5CRWVFTgs794gP7zlyaxMmBWztJD4Ak7+nxa8lOc=;
        b=eaQg+y2M8IG8zLbhIx23nUYnTSFFE/Tz/Y5NS/cMSXaIMAR6/qWbNj0ZnjBPumSHOb
         PtcB7/EBM+xyM24C+pbQML3r7L1zefWaOzdFKa/XOpTHV2vlwl8NCYpBEf+lOcOP0Egk
         HxFamYqssmtQvAiG9aWQ/gcQQlgNMDuOFafz/vKuvy8o3KN9dphV9gxRRcFJGD85ypSU
         xMJgUuBk3kQj+thLHT0r+MCpNYf/p24ZFX532uVAUT00IrsRYf092ob9n7qFCrfKXQgr
         zfchDcNGTRmM6T/knKYEJzNKdfp7ggs/aBP5e6CJUdIyqBynvHijRLIBdFF1jnli+Mft
         kR8A==
X-Forwarded-Encrypted: i=1; AKwUvBx5wsiUMd65h+4c/QRsx7jJodXpNCogGgfxF5KbtEPnQQZcU39H0TvyRfhADrRRGoM4bOdXlTxZMA==@lists.linux.dev
X-Gm-Message-State: AFuF++l3xpFqvS3DvIHGIae+r4HgTHt44Ro2Gk7sC3RrP5aKC2jh51ei
	491myzQyoR0gLlm9aV3xCVNsOsL3lL5YYf3OH6BE90ZKqVGc+KdmTYIbomNAwH09rLYdKB5fUPd
	q5ugpmNrtMQSu0ftNbv+ec/Bx1ZISDXI=
X-Gm-Gg: AYBFou0M7t3RRLZd8PKSh2btwba4olxgqUQDJRPCVj4kpqslatK0hkMvb5Fm+Ht8CQV
	nwUcR+1g75JfIV/yz5idPWj4ukMTwEYRxVVWMbcCSJK8Azb++Vi8Dm/1frSeSG5mrf0QthFbf4l
	KbinDTg1jk9ebDI/5t4pM9zcNjQJtUsfkkdDU1tARHIeyqADHGPoBgG/xFpcPPdnjtalE+D5O+t
	Lri8VSygypnoi7i7ZOYL0glRgTmsd9eqrlzcG1jjLyFq6XfFQlppU1+N9ysiUAtchv2S98k2hZY
	MGxzZVK+3zjEFKuLRc2fYNVBQx93hQgw/Ahzjc7UGayR5hLwmWo7WFsI
X-Received: by 2002:a05:690c:6709:b0:85e:3071:f103 with SMTP id
 00721157ae682-8a4574a521emr31049147b3.1.1790178142273; Wed, 23 Sep 2026
 08:42:22 -0700 (PDT)
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260922120330.127262-1-itai.handler@gmail.com>
 <20260922213457.GA3536981@google.com> <CAFpOueSjekxhjEosQGiZ9BiDh5tFOqBPX5w_2PVsrcN6pO+dHw@mail.gmail.com>
 <9a6c20da-4da9-4a8d-a6d4-f18900228bf6@redhat.com> <20260923113903.901245-1-itai.handler@gmail.com>
 <20260923162846.0d198104@pumpkin>
In-Reply-To: <20260923162846.0d198104@pumpkin>
From: Itai Handler <itai.handler@gmail.com>
Date: Wed, 23 Sep 2026 18:42:11 +0300
X-Gm-Features: AclHuK9w5roNsxyARXB-UwcciSSDhgydoszkxBjNj6J6hb6GTuZZRPklA1vjXqU
Message-ID: <CAFpOueRECZx=9XOniAAKQNDJGJ_s1FXLAOA+FeMhBNJK=aJzmA@mail.gmail.com>
Subject: Re: [PATCH v2 0/1] dm-crypt: allow encryption sector size up to PAGE_SIZE
To: David Laight <david.laight.linux@gmail.com>
Cc: Mikulas Patocka <mpatocka@redhat.com>, Eric Biggers <ebiggers@kernel.org>, 
	Milan Broz <gmazyland@gmail.com>, Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@kernel.org>, 
	Benjamin Marzinski <bmarzins@redhat.com>, Jonathan Corbet <corbet@lwn.net>, 
	Shuah Khan <skhan@linuxfoundation.org>, Randy Dunlap <rdunlap@infradead.org>, 
	dm-devel@lists.linux.dev, linux-doc@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Sep 23, 2026 at 6:28=E2=80=AFPM David Laight
<david.laight.linux@gmail.com> wrote:

> And you really better do 4k aligned 4k writes.
> Otherwise performance and device lifetime are likely to suffer badly.

Agreed. My point about the 512-byte logical/atomic unit was only about
what the device guarantees, not about what I/O size should normally be
used.

In particular, I don't think the fact that a device reports 512-byte
logical blocks is a reason to use 512-byte I/O. Filesystems and
applications should still normally issue appropriately aligned 4K (or
larger) I/O where that matches the device's characteristics.

The distinction I was trying to make is between the device's I/O
granularity/performance characteristics and its guaranteed atomic write
unit. The former may well be 4K or larger even when the latter is only
512 bytes (or is not advertised at all).

So I agree with your point, but I don't think it changes the argument
about the dm-crypt sector-size limit: a 4096-byte dm-crypt encryption
sector can already span multiple device-level atomic units, and the
proposed change only increases the maximum size when explicitly
requested.

Thanks,
Itai
