Received: from mail-wr1-f43.google.com (mail-wr1-f43.google.com [209.85.221.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 908F41CA9B
	for <dm-devel@lists.linux.dev>; Wed,  3 Jan 2024 19:21:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="VgvlVedM"
Received: by mail-wr1-f43.google.com with SMTP id ffacd0b85a97d-336788cb261so9662683f8f.3
        for <dm-devel@lists.linux.dev>; Wed, 03 Jan 2024 11:21:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google; t=1704309697; x=1704914497; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=kuSPw6mXUMTFdNiYTm4KoFsMIe3cS+d/OHO02eB5MAQ=;
        b=VgvlVedME5anaNDrl62Pn/58JqkCHAfGqwEVteLqgJExTdzgszlDZOkpBMsR7CGpdN
         SVQsOnpr1lQSU+GikwErRl13IrcnLWwylvRXzQ5T+05a7t/x4/mhnC6Zr9Y8BizHXu5v
         4KXL66m9T8VrCqCCMIJ7e4/Q73sRdD93qdfpI=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1704309697; x=1704914497;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=kuSPw6mXUMTFdNiYTm4KoFsMIe3cS+d/OHO02eB5MAQ=;
        b=D2U9JJYyi/7fz6o8kZvP/JANhdbz5fl6eVT89YXB41ZBO/iZQg3o/tjqlRpxizFiyB
         dc58Ctw95yxTbqmWq1Lx5umehZ8zyMHzsir/Q4fFJFQ5+5PzxcVYFx69xJdjx4re182W
         sehT1P6Ol4y2Pf2OqDUoeBqPVPTOqm0VjbyiVWZLnHNrieUzXfTm/hvhpI9DJbszI5t7
         dOFQylWq7fvH6lIMHGyMPX+MzmBQHDeTzov32K2KvtQGpWj57oNz2dBY71hmLPCO1ICp
         EmDEZvd6GJoWRdQPPnsK6fXMGgL5syxxbwiCTSic6C5BcvFNa41vJyD/Mlispuwuxpdq
         omrg==
X-Gm-Message-State: AOJu0Yyihrx1fWdVSdQj6CTf5kwoeLMpQkX12aVXMQZd/Rah45FLRpu7
	stjlLc3EOC2oCpaufwMKfDQbaa2yoFhz2a3SRegXWa4eBeCbNsqH
X-Google-Smtp-Source: AGHT+IGxxhMJIBUiWFRDG2ZiLDi2+aUMLqLBkOayhqcrez0NzCjCo0f8YdtQ7Qv6UEa3J/DTb07w5w==
X-Received: by 2002:a5d:5645:0:b0:336:c3c7:75ce with SMTP id j5-20020a5d5645000000b00336c3c775cemr7569047wrw.68.1704309697570;
        Wed, 03 Jan 2024 11:21:37 -0800 (PST)
Received: from mail-ej1-f48.google.com (mail-ej1-f48.google.com. [209.85.218.48])
        by smtp.gmail.com with ESMTPSA id t15-20020a056402020f00b005534057c72dsm17588045edv.18.2024.01.03.11.21.36
        for <dm-devel@lists.linux.dev>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 03 Jan 2024 11:21:37 -0800 (PST)
Received: by mail-ej1-f48.google.com with SMTP id a640c23a62f3a-a282cb36d37so240194766b.3
        for <dm-devel@lists.linux.dev>; Wed, 03 Jan 2024 11:21:36 -0800 (PST)
X-Received: by 2002:a17:907:61a2:b0:a26:8ee9:9b31 with SMTP id
 mt34-20020a17090761a200b00a268ee99b31mr1615950ejc.4.1704309695796; Wed, 03
 Jan 2024 11:21:35 -0800 (PST)
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <PH7PR11MB576877FF72A9B2D43EAA1AEBA093A@PH7PR11MB5768.namprd11.prod.outlook.com>
 <2023121655-exporter-deed-6fcb@gregkh> <b7e39bbd-356e-8bae-7fca-e71ff067149@redhat.com>
In-Reply-To: <b7e39bbd-356e-8bae-7fca-e71ff067149@redhat.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Wed, 3 Jan 2024 11:21:19 -0800
X-Gmail-Original-Message-ID: <CAHk-=wi8Zer6tnqO-bz+WxFpMv9sPc-LxGRm_3poOtZegjhfrg@mail.gmail.com>
Message-ID: <CAHk-=wi8Zer6tnqO-bz+WxFpMv9sPc-LxGRm_3poOtZegjhfrg@mail.gmail.com>
Subject: Re: [LInux Kernel Crash] "WARNING: kmalloc bug in ctl_ioctl"
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: Greg KH <gregkh@linuxfoundation.org>, "Yang, Chenyuan" <cy54@illinois.edu>, 
	"security@kernel.org" <security@kernel.org>, "dm-devel@lists.linux.dev" <dm-devel@lists.linux.dev>, 
	"agk@redhat.com" <agk@redhat.com>, "snitzer@kernel.org" <snitzer@kernel.org>, 
	"syzkaller@googlegroups.com" <syzkaller@googlegroups.com>, "Zhang, Lingming" <lingming@illinois.edu>, 
	"Marinov, Darko" <marinov@illinois.edu>, "Zhao, Zijie" <zijie4@illinois.edu>
Content-Type: text/plain; charset="UTF-8"

On Wed, 3 Jan 2024 at 11:15, Mikulas Patocka <mpatocka@redhat.com> wrote:
>
> Should we use __GFP_NOWARN? (but this would shut up also genuine
> warnings).

This can only be fixed in the *caller*, which need to either

 (a) have saen limit checking that checks for an obviously safe limit
(please don't just make it INT_MAX to handle this one case - make it
something *reasonable*)

_or_

 (b) the __GPF_NOWARN with a very obvious "I handle a failed return
gracefully" handling all the way out to user space (error returns
and/or things like "fall back to smaller sizes")./

because a caller that just passes in a random value to kmalloc()
should continue to warn if that random value is unreasonable.

Exactly *because* we want all those crazy random tester robots to
actually find cases where people just randomly take untrusted lengths
from user space.

                     Linus
