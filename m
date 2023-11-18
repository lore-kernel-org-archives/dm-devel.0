Received: from mail-ej1-f48.google.com (mail-ej1-f48.google.com [209.85.218.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 470B61BDC0
	for <dm-devel@lists.linux.dev>; Sat, 18 Nov 2023 19:14:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Rxrru6DI"
Received: by mail-ej1-f48.google.com with SMTP id a640c23a62f3a-9d10972e63eso423305766b.2
        for <dm-devel@lists.linux.dev>; Sat, 18 Nov 2023 11:14:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google; t=1700334884; x=1700939684; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=R5xCKG+dPMG8F3WMME/kbqVh8kLHwHJKzVbHpwM9FHU=;
        b=Rxrru6DITd1LUAgyc0kzxMmm9pGNhZ6X2/p4g0C5hYikvjZE54j2RdIykxgNnrIJov
         Yyfp6v6OD5iLc91gMDB5xHgdj9sItAo+RkThbLLhAxUy0aFqwwp0ZmWdFwIcm3qxjOHJ
         mM2k2GNTM8aBxxrbdGuge/dgaJJRRN8Mb22zg=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1700334884; x=1700939684;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=R5xCKG+dPMG8F3WMME/kbqVh8kLHwHJKzVbHpwM9FHU=;
        b=YMz748xoMiGGVpympB2T+M2UwFVnyFxk3PBQ+P6VuKkkHYxZE11/Ik8E+0iAGE0/By
         Wr8OLh+/LgxdCVvcSd9nveyHFGj06owuC8BVGMM+mjWy7Xwi7/6AjORtWNAXqnb08atX
         zzN/6UwlfdLXGVGUvvhmMDv1T74nE/Bjp2SExHTqA60/ZNRnK/OE3uwxLMdXSp1+wUxf
         kKd0C2SWl+dyqKXPDqXq5CPv6NfmBODI/G/BXtHwI5JdQS0/LbXDglQG8cH9dzd1C7SQ
         x2iYg6O9U4Ejur45I9/4hl/C9muyUF54zg/ugishSw7Pv2PhMq5ShTtjLWw+ETulIzMk
         urjg==
X-Gm-Message-State: AOJu0YxJArQ9W3rxKCrRzZ0C0vuTrhtISg+LkVShr9COBwTiGLbjDdq/
	hbDluzo5ke7+qdXuip4PqEnYh8MjvZ2NvP/NtOkYCw==
X-Google-Smtp-Source: AGHT+IGD+abhHjBTIerrx6w2+y5xHvhY22U1L8pZaAIPvmnrTO3wi8+XhxJBZBS8RUm73qESOV22qw==
X-Received: by 2002:a17:906:51c5:b0:9e7:2d0b:8c41 with SMTP id v5-20020a17090651c500b009e72d0b8c41mr2229047ejk.0.1700334884164;
        Sat, 18 Nov 2023 11:14:44 -0800 (PST)
Received: from mail-ed1-f53.google.com (mail-ed1-f53.google.com. [209.85.208.53])
        by smtp.gmail.com with ESMTPSA id n17-20020a17090673d100b009f55119af1dsm2159391ejl.47.2023.11.18.11.14.43
        for <dm-devel@lists.linux.dev>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 18 Nov 2023 11:14:43 -0800 (PST)
Received: by mail-ed1-f53.google.com with SMTP id 4fb4d7f45d1cf-544455a4b56so4258070a12.1
        for <dm-devel@lists.linux.dev>; Sat, 18 Nov 2023 11:14:43 -0800 (PST)
X-Received: by 2002:a05:6402:64f:b0:543:7e9b:5cc9 with SMTP id
 u15-20020a056402064f00b005437e9b5cc9mr2096703edx.31.1700334882947; Sat, 18
 Nov 2023 11:14:42 -0800 (PST)
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <ZVjgpLACW4/0NkBB@redhat.com> <CAHk-=wjV2S7xBcH2BGuDgfKcg3fjWwk5k74nq89SviMkH-YsJQ@mail.gmail.com>
In-Reply-To: <CAHk-=wjV2S7xBcH2BGuDgfKcg3fjWwk5k74nq89SviMkH-YsJQ@mail.gmail.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Sat, 18 Nov 2023 11:14:25 -0800
X-Gmail-Original-Message-ID: <CAHk-=wjCXvFme97sxix_zDfq4-oNRv7fNp+YzWEuUGH-gihA-g@mail.gmail.com>
Message-ID: <CAHk-=wjCXvFme97sxix_zDfq4-oNRv7fNp+YzWEuUGH-gihA-g@mail.gmail.com>
Subject: Re: [git pull] device mapper fixes for 6.7-rc2
To: Mike Snitzer <snitzer@kernel.org>, 
	"Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>, Michael Ellerman <mpe@ellerman.id.au>, 
	Andrew Morton <akpm@linux-foundation.org>
Cc: dm-devel@lists.linux.dev, linux-block@vger.kernel.org, 
	Alasdair G Kergon <agk@redhat.com>, Benjamin Marzinski <bmarzins@redhat.com>, 
	Mikulas Patocka <mpatocka@redhat.com>
Content-Type: text/plain; charset="UTF-8"

On Sat, 18 Nov 2023 at 10:33, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
> What are the alleged "number of bugs all over the kernel" that the old
> MAX_ORDER definition had? In light of the other "MAX" definitions I
> found from a second of grepping, I really think the argument for that
> was just wrong.

Bah. I looked at the commits leading up to it, and I really think that
"if that's the fallout from 24 years of history, then it wasn't a huge
deal".

Compared to the inevitable problems that the semantic change will
cause for backports (and already caused for this merge window), I
still think this was all likely a mistake.

In fact, the biggest takeaway from those patches is that we probably
should have introduced some kind of "this is the max _size_ you can
allocate", because a few of them were related to that particular
calculation.

The floppy driver example is actually a good example, in that that is
*exactly* what it wanted, but it had been just done wrong as

  #define MAX_LEN (1UL << MAX_ORDER << PAGE_SHIFT)

and variations of that is what half the fixes were..

IOW, I really think we should just have added a

  #define MAX_GFP_SIZE (1UL << (PAGE_SHIFT+MAX_ORDER-1))

and the rest were basically all just the trivial off-by-one things.

The __iommu_dma_alloc_pages() code is just so odd that any MAX_ORDER
issues are more about "WTH is this code doing" And the "fix" is just
more of the same.

The *whole* point of having the max for a power-of-two thing is that
you can do things like

        mask = (1<<MAX)-1;

and that's exactly what the iommu code was trying to do. Except for
some *unfathomable* reason the iommu code did

        order_mask &= (2U << MAX_ORDER) - 1;

and honestly, you can't blame MAX_ORDER for the confusion. What a
strange off-by-one. MAX_ORDER was *literally* designed to be easy for
this case, and people screwed it up.

And no, it's *not* because "inclusive is more intuitive". As
mentioned, this whole "it's past the end* is the common case for MAX
values in the mm, for exactly these kinds of reasons. I already
listted several other cases.

The reason there were 9 bugs is because MAX_ORDER is an old thing, and
testing doesn't catch it because nobody triggers the max case. The
crazy iommu code goes back to 2016, for example.

That

    84 files changed, 223 insertions(+), 253 deletions(-)

really seems bogus for the 9 fixes that had accumulated in this area
in the last 24 years.

Oh well. Now we have places with 'MAX_ORDER + 1' instead of 'MAX_ORDER
- 1'. I'm not seeing that it's a win, and I do think "semantic change
after 24 years" is a loss and is going to cause problems.

               Linus
