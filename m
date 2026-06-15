Received: from mail-wm1-f47.google.com (mail-wm1-f47.google.com [209.85.128.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 91A1940B6EE
	for <dm-devel@lists.linux.dev>; Mon, 15 Jun 2026 16:44:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781541888; cv=none; b=tTEOzLsBsbrOmynMmTDVTvvPCh6H38vskszobBpoC0+cKvy49RkR/TpgU2kky77m1+3NLYrcQSqWVBDC/7WDWDRWpunT0YGxsiakHDNfyGHS9K9nH2qTazi4BOFBd0XVuQ9PNfMnS3sKd3POckTrhBZrKZ0yqscS/olCAiFSRc8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781541888; c=relaxed/simple;
	bh=otoo/nKOgNau4pA5qFf4amlIzo52hCvaA76metTC/jU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=jKC3NdqOHB8R22mIa6kMd8OIJ1LETz3SP521CoFAWlY3BrFxaQGaVCglh2Hnt2gg3Mv2ov2mvZ4PaR7bMKZuhkkHZaBeRb5guhm+o1wUGQZOzMZrognGUY+m9GX6ymKIsEuJkRnIRxjRS3jTg2URhwynWvm9Onf+MAwzDNuVrVU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=VI+HXpGx; arc=none smtp.client-ip=209.85.128.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="VI+HXpGx"
Received: by mail-wm1-f47.google.com with SMTP id 5b1f17b1804b1-490b8adf813so4479085e9.1
        for <dm-devel@lists.linux.dev>; Mon, 15 Jun 2026 09:44:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1781541885; x=1782146685; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:mime-version:date:message-id:from:to:cc
         :subject:date:message-id:reply-to;
        bh=4J4lzczMYyvCVq4P61MsFBfF8OaQf05q3jvWzSwK2Rw=;
        b=VI+HXpGx0fHyVPAYf1ye49Hqn8pzhghZf5J8QngyqVEbw1O7CLF5VDFHhOyoovz0Wm
         phYwl2MxFMXGU8kNODbigA0rMqYd2gjlqEQXyrS7Xao6gY9VX4y8JHpyBPSU/J/j14Or
         Wx73is4Gck7j0dCVUHNpJrWNrQY4mgCSODq7zbIQ2VqTrnKjay+P0ohdH4dCM7BXypph
         k0VlMs1nGee/9CEfefeN35meiGk0/Ol/pJ+3CGOT1nm4eqWpgYr0H1pocZ3QMSCmKoRG
         e5LWrXH1JfSn7x5AT3VtMoBJHVVU3IpSqcIqyHzRd0LWh1/4tG+TURGFPsZNmMdWG8wq
         NU1g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781541885; x=1782146685;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:mime-version:date:message-id:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=4J4lzczMYyvCVq4P61MsFBfF8OaQf05q3jvWzSwK2Rw=;
        b=W9xP1+5sl75XnE/1/x5lK86WR2heeu0bffWCFz9EeCc0dnnjLq7mMNFdexKXGq97M+
         6h/HSgAyix1npi4TJkn+/eNeCKnZyAOkPJXz8a8ODyoHtnqIi3y7jf9vzd4e8KIyb4PC
         20u2sA1L0xrzKrbmpFna1LGl7YNXGpm/7nlcdyqS87mBQ1ntEULXa17ZdSlmaXenN83N
         mMPnTz9I3EUzoujjoyfrEIBOpD/UR2whUzKUGKYWFYVqwnABvPjOiCWHActxz72e61mg
         gvSn4OUmS8HK+/IQRlLUExF2CCluU8WoVjaaYxKDB/EZxOloAulwCSpy4nttLVRA8DVu
         3Avw==
X-Forwarded-Encrypted: i=1; AFNElJ9JvCc9DYlkRlmcYWuj+pj6LyZ/Yvev8fJUoPRr11D3rovi863O3BzGvJQdYn7bkz7F1OyWOes95g==@lists.linux.dev
X-Gm-Message-State: AOJu0Yx/zr3cQgq91hVf4UGR0g6ha/AgOB8af155Xu26HAsWwJr6NsIz
	V6ElU4ezHtoE6sx9yjDg9RVVKRsppdkxJNLWkbtcNuLZhB9Z+XvMoY4=
X-Gm-Gg: Acq92OGRjIWlBg9cO+DF6skt4jpTrIv4QeBfNan4Z3XXaO1CriYaznNCAOTY8bhulII
	ROrIOAU5CnCyHPZit+rrC9ZiWdhWO9QfLfSz0nkfkEYEKzDMDeOvHV0qkKX0KJM9G2jYhV2Ftvd
	gHPk1GHZXCesU7Z0OXcvxWIj5tXxFzfu07WSHd4z+njFcRZw1w1Xffi20ozsJjGXsOaFtLuUQsE
	kS8L1hOYCrTKDNWAKlseKXcIH1zBW1OSJ5q+NEv0qf+f9wV4iW/8kLHNoH39jxzcrZ2wvxKdudz
	MLEZLx7isLC159J8lmf3Oap0x6ZTN1tfTyEY7MdhGpyODy3zXNyVbO6W8Rmzt2WMuPgIaPEDWpK
	eVcXcFb73Fz1IZmGbnj0Svv6DNAUbt+F2On8M4IsFLry9FPVKCQGE4CaC+lAY54Cta3IHZWk6X4
	w5/rkiH8Fp8dVgaZJiBgG9xHf+i2hBAcX41z4VQBa40I2BS+lL8Hij6DAXQLhA16sx
X-Received: by 2002:a05:600c:6384:b0:490:e5c1:b8c1 with SMTP id 5b1f17b1804b1-490ec338741mr89845105e9.0.1781541884750;
        Mon, 15 Jun 2026 09:44:44 -0700 (PDT)
Received: from localhost (32.red-80-39-29.staticip.rima-tde.net. [80.39.29.32])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4922fa891acsm5332325e9.9.2026.06.15.09.44.44
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 15 Jun 2026 09:44:44 -0700 (PDT)
Message-ID: <8a34e0aa-d9ee-4f1b-bb02-7464b56566fc@gmail.com>
Date: Mon, 15 Jun 2026 18:44:43 +0200
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Subject: Re: [PATCH 2/5] multipath-tools: clarify path selector descriptions
 in multipath.conf.5
To: Martin Wilck <mwilck@suse.com>
Cc: Benjamin Marzinski <bmarzins@redhat.com>,
 Christophe Varoqui <christophe.varoqui@opensvc.com>,
 DM_DEVEL-ML <dm-devel@lists.linux.dev>
References: <20260613131002.144263-1-xose.vazquez@gmail.com>
 <20260613131002.144263-3-xose.vazquez@gmail.com>
 <7c28dd835abebb6f9e4ff69159e417cac323409f.camel@suse.com>
 <994b66b1-68fb-4dd6-90e4-8fcd6f894f62@gmail.com>
 <43b7869e56668aff117cc376dea71855f73b70fa.camel@suse.com>
Content-Language: en-US, en-GB, es-ES
From: Xose Vazquez Perez <xose.vazquez@gmail.com>
In-Reply-To: <43b7869e56668aff117cc376dea71855f73b70fa.camel@suse.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 6/15/26 11:15 AM, Martin Wilck wrote:

> On Mon, 2026-06-15 at 10:26 +0200, Xose Vazquez Perez wrote:
>> On 6/15/26 10:16 AM, Martin Wilck wrote:
>>
>>> On Sat, 2026-06-13 at 15:09 +0200, Xose Vazquez Perez wrote:
>>>> Selectors operate on the next individual I/O request rather
>>>> than a "bunch" of I/O.
>>>
>>> This patch doesn't apply cleanly to any of my branches (master,
>>> queue,
>>> tip).
>> That quote is from the patch series I sent earlier. You might have
>> missed it:
>>
>> Xose Vazquez Perez (3):
>>     multipath-tools: delete obsolete information from multipath.conf.5
>>     multipath-tools: remove explicit width from .TP macros in
>> multipath.conf.5
>>     multipath-tools: remove explicit widths from macros in the
>> remaining man pages
> 
> I was about to apply this (5-part) series to the queue branch. But I do
> have an issue with the other series, as I just wrote, so I'm postponing
> this again. I would like to ask you to send a consolidated series. But
> first I guess we need to reach consensus what to do with the rr_minio
> patch.
With git 2.54.0 and a clean environment (no ~/.gitconfig), all parches
apply cleanly on my end over the queue branch:

$ git clone https://github.com/openSUSE/multipath-tools.git
Cloning into 'multipath-tools'...
remote: Enumerating objects: 40696, done.
remote: Counting objects: 100% (240/240), done.
remote: Compressing objects: 100% (126/126), done.
remote: Total 40696 (delta 141), reused 180 (delta 114), pack-reused 40456 (from 1)
Receiving objects: 100% (40696/40696), 8.00 MiB | 23.14 MiB/s, done.
Resolving deltas: 100% (31803/31803), done.

$ cd multipath-tools/

$ git branch
* queue

$ git am /mnt/datos/curre/arrays/p/enviados/cambios_man_tab/*.patch
Committer identity unknown

*** Please tell me who you are.

Run

   git config --global user.email "you@example.com"
   git config --global user.name "Your Name"

to set your account's default identity.
Omit --global to set the identity only in this repository.

fatal: empty ident name (for <you@example.com>) not allowed

$ git config --global user.email "you@example.com"

$ git config --global user.name "Your Name"

$ git am /mnt/datos/curre/arrays/p/enviados/cambios_man_tab/*.patch
Applying: multipath-tools: delete obsolete information from multipath.conf.5
Applying: multipath-tools: remove explicit width from .TP macros in multipath.conf.5
Applying: multipath-tools: remove explicit widths from macros in the remaining man pages

$ git am /mnt/datos/curre/arrays/p/enviados/cambios_man_II/*.patch
Applying: multipath-tools: remove syntax check comments from man pages
Applying: multipath-tools: clarify path selector descriptions in multipath.conf.5
Applying: multipath-tools: specify file paths using variables and add FILES section in multipath.conf.5
Applying: multipath-tools: clarify user_friendly_names prefix behavior in multipath.conf.5
Applying: multipath-tools: fix mandoc errors/warnings in man pages

$ git log -8 --oneline
fdd4549f (HEAD -> queue) multipath-tools: fix mandoc errors/warnings in man pages
b487df0e multipath-tools: clarify user_friendly_names prefix behavior in multipath.conf.5
cfe8681a multipath-tools: specify file paths using variables and add FILES section in multipath.conf.5
f6a59c26 multipath-tools: clarify path selector descriptions in multipath.conf.5
bf9e518c multipath-tools: remove syntax check comments from man pages
faf4dcb4 multipath-tools: remove explicit widths from macros in the remaining man pages
2b33e306 multipath-tools: remove explicit width from .TP macros in multipath.conf.5
fd084d8f multipath-tools: delete obsolete information from multipath.conf.5
