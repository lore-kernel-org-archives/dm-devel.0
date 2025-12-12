Received: from mail-ej1-f45.google.com (mail-ej1-f45.google.com [209.85.218.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F0193019D0
	for <dm-devel@lists.linux.dev>; Fri, 12 Dec 2025 18:22:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765563732; cv=none; b=ljlXumwjQxB0pWSEJT1s11Rv1O87BfnaBovcbp5nFszJHvMgioPLNAySEfa7rYTP3DQi0wQ1QrZEdiPc+AZf0e3NX605T/f2xkamXdr/nw6I4QlVsp4/4FBdc9AlI5oKQsDCUZa4YeCtzB0dNwoIANKrJ5vije/NefwquoqqBXw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765563732; c=relaxed/simple;
	bh=vpuUUIQ9k2laX5rFORpbrwD2mGb7OpMG7R0jZkuO8/A=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=AOq1swTiAF+NX+jCeX+h5siApQGJmHaAS5baEHiuyAy0QuaJgdz18SB+m1thLDl6hgD/tGTfhwe8IxCtLSScvfqmlPMhA4/OBti3P3+qngOaFW8WtNpv8EARF50C75QEIyp/3GIcm6P23ch/QCdMPNr2Q4g3QWPybUCIej4vHXE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=L1XwO5US; arc=none smtp.client-ip=209.85.218.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="L1XwO5US"
Received: by mail-ej1-f45.google.com with SMTP id a640c23a62f3a-b79f98adea4so235430766b.0
        for <dm-devel@lists.linux.dev>; Fri, 12 Dec 2025 10:22:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google; t=1765563727; x=1766168527; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=vEr4ZcKrKg9IpSmRzqy3w8OMMyNf/JsMRqWzFyXn948=;
        b=L1XwO5USoaHT/fX//TjGCfLenFqJE2sbBJIHVk86jclKjXTKG0tP/th36xXqKpuA36
         Z/eIKP2hFO2DnA10NDiCfnPwsqI3VjvxU6NvrC3hIc+90iBrdfV8u/ab6zKT551r/3Fm
         o4MmcuUV3Xi2GL0jZxk9Zp2U0QdWASmaeRKX0=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765563727; x=1766168527;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=vEr4ZcKrKg9IpSmRzqy3w8OMMyNf/JsMRqWzFyXn948=;
        b=aKeyNqWyOMJlph3jKHTBzZBZJzl79ZyeULjKUkb0sVqmfG1+G23bq33W6a5vO56ekb
         jHFaI2iu6vfOeF+Muf7xnwMPBNTunsTbpekmsjzIikAfK1GaaP0LAxAtoa+pyZsN9kBj
         M4DZDWuvtWujwYGYdhXhA6mjqPvUfBJfI9EHE92wu7+39fCr++MX/sNsm4dgknH2Ydyk
         TaRi6SJHbIh8FfWzrUpJTPpOqtL5Sg6n6mQ5bpM/dRZnRcGx/PD7P86Sahlc4tyF8xId
         qTOELjvLCBTthEgGv0Hb2ekAMc8nf+lBYoVn+gW7PSBnUZ38D1pNF4+nPFG551hRul5o
         WKiA==
X-Forwarded-Encrypted: i=1; AJvYcCVoykh39zv5aM6zWmq6COOQapEPZyO8shlawV6ghxjcEviLFFhrNs7N5GghZg/B2Jsf7vO0V9ifNg==@lists.linux.dev
X-Gm-Message-State: AOJu0YyQVI6rqRX1HR2f8kwx/dyzZ1ZNaQlH3Qn88NnTK9qVGapKxXH1
	MDdvjri5LykYwkDujTI3B6kuFp8umowo4oX1aj90XTigtlNxI35UgH0fmlvhelPvTVSg3+DAYwf
	ujlTXlPkXHQ==
X-Gm-Gg: AY/fxX4LV++pnGW3vjLO55PQNr0cKRwnv03bHStJacKgFKaKhNb9vubh8EiLb1WMEMi
	rWPXxmDLPctsBF6qPNXiBMhhADEqAnttyuB8gNouksOHo1JHnaCSuCzH+r3shHbakCZrTwLBqjY
	uRwUlrgJIuicQXUXAx2tsJy/gQGPt0GKnz7RaZQwgTlm/chQ/66xRerHogqO6rs1VKGX2stOajz
	Iy6sF/Ed75+R0mZfuGfhH38I8P6L1uis41zRCypbSCRpqv6ZSkZKr+aysW/vx80Xla2CAVfhspA
	MxgwBiQ+hIb1zLZsDJT37ZxYSRO3Xk7+2YV7YeymghUjhMbJrEocyptejQVix1x0ZNdNPBb0mw9
	chwOvrWMSQKG9hIubleJjQUKFNh/CJUl2dISoEZMTiK3bpfugI2z1K8lLkD8rgMVWQT8DB43mbi
	o2y7TH4OkgIh60CrddKosw/68m4N7Rs8VdNOIxbxLMzVBe3ZU+HxUun1qI0+GtbkxhAFbXQU0=
X-Google-Smtp-Source: AGHT+IG5ceHUqfHyY4r7XHuNCeKgJi2GZQ9va2PSra/7Q9eRFa2CGzzKgcsC+zY1L26ZGfrpfKciPw==
X-Received: by 2002:a17:907:7f23:b0:b72:588:2976 with SMTP id a640c23a62f3a-b7d23d1390bmr266425466b.60.1765563727509;
        Fri, 12 Dec 2025 10:22:07 -0800 (PST)
Received: from mail-ej1-f41.google.com (mail-ej1-f41.google.com. [209.85.218.41])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-64982040d14sm6037430a12.5.2025.12.12.10.22.06
        for <dm-devel@lists.linux.dev>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 12 Dec 2025 10:22:07 -0800 (PST)
Received: by mail-ej1-f41.google.com with SMTP id a640c23a62f3a-b728a43e410so240887466b.1
        for <dm-devel@lists.linux.dev>; Fri, 12 Dec 2025 10:22:06 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCWJlNG5Fy+7KjuDYgEmhjEcVZigQAWHz6229YZ/xCHEzfAiEymHmTvHG5RW0cb1ZIo/cZqwqFge/g==@lists.linux.dev
X-Received: by 2002:a17:907:9496:b0:b71:854:4e49 with SMTP id
 a640c23a62f3a-b7d23d042e7mr355463566b.56.1765563725883; Fri, 12 Dec 2025
 10:22:05 -0800 (PST)
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <2b7fa07e-cf1c-73a7-d1eb-5d6082e08b29@redhat.com>
 <CAHk-=wi4ckGEFjHhMHcSoWidgd+URdorcdt5KCP6rQvP_DDS5g@mail.gmail.com>
 <CAHk-=wjkgKyDHDpXJR7_fQ3AT3gohukyAGuxqOCU1yyiRradHw@mail.gmail.com> <b9a10a71-92a3-8e47-b842-46a30b1af82e@redhat.com>
In-Reply-To: <b9a10a71-92a3-8e47-b842-46a30b1af82e@redhat.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Sat, 13 Dec 2025 06:21:49 +1200
X-Gmail-Original-Message-ID: <CAHk-=wh-LQTLhD-vOqHfhb3cyust1aeU4UPmTyGkaD5kgDFLzg@mail.gmail.com>
X-Gm-Features: AQt7F2ov-My23MuUg1NoMrEjgwVq5DPsPWaVF_02EkT45IRLZHr7BlJdi3fpaEE
Message-ID: <CAHk-=wh-LQTLhD-vOqHfhb3cyust1aeU4UPmTyGkaD5kgDFLzg@mail.gmail.com>
Subject: Re: [git pull] device mapper changes for 6.19
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@kernel.org>, dm-devel@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"

On Fri, 12 Dec 2025 at 05:56, Mikulas Patocka <mpatocka@redhat.com> wrote:
>
> I rebased it just before sending it because the kernel test robot found
> grammatical errors in two commit messages.

That really isn't a strong enough reason to then rebase things late.

Rebasing is for *important* things, or for early development. Not for
the merge window, or at least not without explaining why the tree
contains a lot of very recent changes.

> What's your preferred time frame for submitting the device mapper pull
> request? One week since the merge window starts? Or less than one week?

The code should be ready *BEFORE* the merge window starts. Not "one
week after". Not one *HOUR* after.

Lots of people send me their pull requests the week before. This time
around I had something like 35 pull requests ready to go for the merge
window in my inbox when I released 3.18.

Other people wait for the actual release, so then on the first Monday
of the merge window that number had roughly doubled, and that's fairly
normal.

Does it *have* to come in that early? No. We have two weeks partly to
be able to be flexible. But those two weeks are *not* for development.

They are for me and "it takes time to merge", and they are for other
developers for "my goldfish ate my favorite stick bug, and now I'm
devastated and an emotional wreck, and it took me some time to get
over it".

So people have other things going on in their lives than just kernel
development, and two weeks gives some buffer for that.

And sometimes there's some trees that have dependencies where there's
a few "I need to go after that other tree" kinds of things, and the
two weeks gives some flexibility in that sense.

That last case used to be particularly true back when Andrew Morton
didn't use git, so his series depended on other peoples git trees and
couldn't use stable git branches where two or more trees shared some
common history.

But even with all those reasons for two weeks, the merge window is for
things that were ready *before* the merge window started.

Sure, late commits happen because maybe there were fixes that still
came in and people notice them and want to deal with fixes asap,  and
there might be a "one more thing" there, but the merge window is NOT
for new development.

And not for random late rebases that aren't explained. When I see lots
of recent commits, that just makes me go "what the heck happened
here?" exactly because that should *not* be happening. It should have
been ready to go.

And as always - you can *explain* things. The merge message should
have explanations for what the pull contains, but there can also be
notes about why something was slightly off. Like explaining why some
unusual late rebase happened.

But note the "unusual". It shouldn't be the pattern.

Basically, if a pull request comes in during the second week, you
should have a *reason* for it that you also explain. If it's too
personal to explain in public, feel free to just send me a separate
private email.

Things happen. We have rules, but at the same time very few rules are
black and white. Kernel development is supposed to be pretty flexible
- outside of the "no regression" rules, pretty much all other rules
can be bent.

But when the rules are bent, they should at least be explained.

            Linus
