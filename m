Received: from mail-lf1-f42.google.com (mail-lf1-f42.google.com [209.85.167.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 572952592
	for <dm-devel@lists.linux.dev>; Sat, 18 Nov 2023 18:34:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Ad+VDvXi"
Received: by mail-lf1-f42.google.com with SMTP id 2adb3069b0e04-5094727fa67so4326211e87.3
        for <dm-devel@lists.linux.dev>; Sat, 18 Nov 2023 10:34:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google; t=1700332451; x=1700937251; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=iN30444otYgrHG7wXHjLQUqEXj0svyI3isTOZp0Uy+o=;
        b=Ad+VDvXiGbQBZyXxpMD8fPa8t7r5qA8WABf77fEwc4lVBpxUlsQIukt/o89LBQebEx
         Z3dSyejUa+OtbqQna5/sUzNwxjJ+jQTr7XHaslzDYjV1CCUVjBNY4MFA9P1VswmUR/q7
         Vf3wK2iC5uOtZqFcZzazKvsM6wF/pHrVkFTJw=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1700332451; x=1700937251;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=iN30444otYgrHG7wXHjLQUqEXj0svyI3isTOZp0Uy+o=;
        b=ctnxOT6untuG73l6euertnyyt5xoQ7yGYuSNxpWlivZp7WbtDg2ZcBhcCsyi1nl4fe
         pr8/4o/URTebZrPHpsJ+692mg8si3EwhAeHb/5qGrKaKpRfRrBrRS4XvEUESN8Li3BhJ
         l7y0aBC2OvGnl1HIP+xIR+XDWssbguG/oZtF2z4BFEGWIETdX0zsqePIgvQaXKlOj/NX
         bHa+nqLWObg6xG1qqGzcEqp8k2fySGhx0wYbLapYilEt8/10EuI+egoXYIy7keQY21Ks
         joNpN5cJzHMpTqWQPRQxwj5W9dv55oJZQpxJP2zKWtzDSgGBdHFap7vMjw8AkqixjUAg
         7+Yw==
X-Gm-Message-State: AOJu0YzleY+r2xPsvS+UOgjqFWpwfRQPjXPRxOJ4d43LU+4PBz+PZJhs
	5lr4trCh6w/Xk3kiLUOpOzUlIkeSohkXXFs2U+WmFzWp
X-Google-Smtp-Source: AGHT+IGawLEwbniBrJpP+bubzPccCn1m0dA1Js4h6MVAZRvRzRlpckxOwzdek1fgK0SPruW51l4l9Q==
X-Received: by 2002:a05:6512:485b:b0:503:905:c5a3 with SMTP id ep27-20020a056512485b00b005030905c5a3mr2091629lfb.35.1700332451085;
        Sat, 18 Nov 2023 10:34:11 -0800 (PST)
Received: from mail-ed1-f50.google.com (mail-ed1-f50.google.com. [209.85.208.50])
        by smtp.gmail.com with ESMTPSA id d18-20020aa7d5d2000000b0054554a7bbedsm1947046eds.24.2023.11.18.10.34.10
        for <dm-devel@lists.linux.dev>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 18 Nov 2023 10:34:10 -0800 (PST)
Received: by mail-ed1-f50.google.com with SMTP id 4fb4d7f45d1cf-543c3756521so4163442a12.2
        for <dm-devel@lists.linux.dev>; Sat, 18 Nov 2023 10:34:10 -0800 (PST)
X-Received: by 2002:aa7:d145:0:b0:547:540c:983 with SMTP id
 r5-20020aa7d145000000b00547540c0983mr1912920edo.30.1700332449803; Sat, 18 Nov
 2023 10:34:09 -0800 (PST)
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <ZVjgpLACW4/0NkBB@redhat.com>
In-Reply-To: <ZVjgpLACW4/0NkBB@redhat.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Sat, 18 Nov 2023 10:33:52 -0800
X-Gmail-Original-Message-ID: <CAHk-=wjV2S7xBcH2BGuDgfKcg3fjWwk5k74nq89SviMkH-YsJQ@mail.gmail.com>
Message-ID: <CAHk-=wjV2S7xBcH2BGuDgfKcg3fjWwk5k74nq89SviMkH-YsJQ@mail.gmail.com>
Subject: Re: [git pull] device mapper fixes for 6.7-rc2
To: Mike Snitzer <snitzer@kernel.org>, 
	"Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>, Michael Ellerman <mpe@ellerman.id.au>, 
	Andrew Morton <akpm@linux-foundation.org>
Cc: dm-devel@lists.linux.dev, linux-block@vger.kernel.org, 
	Alasdair G Kergon <agk@redhat.com>, Benjamin Marzinski <bmarzins@redhat.com>, 
	Mikulas Patocka <mpatocka@redhat.com>
Content-Type: text/plain; charset="UTF-8"

On Sat, 18 Nov 2023 at 08:04, Mike Snitzer <snitzer@kernel.org> wrote:
>
> - Update DM crypt target in response to the treewide change that made
>   MAX_ORDER inclusive.

Your fix is obviously correct, and was an unfortunate semantic
conflict that I (and in my defense, apparently linux-next) missed this
merge window.

But now that I notice the mis-merge I also think the original change
may just have been wrong.

Not only did it change MAX_ORDER semantics from their historical
definition, the *argument* for changing it is bogus.

That commit claims that the traditional MAX_ORDER definition was
counter-intuitive, and that was really the *only* argument for the
change.

But the thing is, the 0..MAX-1 is often the *norm* in the kernel
because we count from 0 and often have max values determined by
powers-of-two etc

Just in the mm, we have MPOL_MAX, MAX_NUMNODES, KM_MAX_IDX,
MAX_SWAPFILES, MAX_NR_GENS, COMPACT_CLUSTER_MAX, MAX_LRU_BATCH, and
probably others.  And as far as I can tell, *none* of them are any
kind of "inclusive" max (that's from a very quick grep for 'MAX', I'm
sure I missed some, and maybe I missed some case where it was actually
inclusive).

So the dm fix in commit 13648e04a9b8 ("dm-crypt: start allocating with
MAX_ORDER") is clearly and obviously a fix, and I have pulled this,
but the more I look at it, the more I think that commit 23baf831a32c
("mm, treewide: redefine MAX_ORDER sanely") was just *complete*
garbage.

Calling the old MAXORDER insane (by implication: "redefine sanely")
and counter-intuitive is clearly bogus. It's neither unusual, insane
_or_ counter-intuitive, just by all the other similar cases we have.

Andrew, Kirill - I'm inclined to just revert that commit (and the new
dm fix it resulted in), unless you can back it up with more than a
completely bogus commit message.

What are the alleged "number of bugs all over the kernel" that the old
MAX_ORDER definition had? In light of the other "MAX" definitions I
found from a second of grepping, I really think the argument for that
was just wrong.

And old MAX_ORDER it is. I went back in history, and the MAX_ORDER
define comes from 2.3.27pre6, where we renamed NR_MEM_LISTS to
MAX_ORDER.

And that was back in 1999.

So we have literally 24 years of MAX_ORDER that was upended for some
very questionable reasons. And changing the meaning of it
*immediately* caused a bug.

                   Linus
