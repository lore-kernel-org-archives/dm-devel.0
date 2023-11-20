Received: from mail-ej1-f45.google.com (mail-ej1-f45.google.com [209.85.218.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B101522308
	for <dm-devel@lists.linux.dev>; Mon, 20 Nov 2023 17:37:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="QL2rzV+m"
Received: by mail-ej1-f45.google.com with SMTP id a640c23a62f3a-a0029289b1bso109399766b.1
        for <dm-devel@lists.linux.dev>; Mon, 20 Nov 2023 09:37:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google; t=1700501825; x=1701106625; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=Sj7GhPSDbYDdw4iQB/bb+X84NDAwKJX0VXMHzUWyOhk=;
        b=QL2rzV+mIsH3SEe14sbQfs7JnMy6QBW3Wl0CFfvNKCkIbnZD5HNT91fJ78INLeDJej
         UHiyUHj6rVXTj7jFckcT5uZ9pPgkVjWb33+euUSo/H7va6WG7niDmVuMiCoOd8sgwaxv
         Xe9NyZYIxfDjiH+bB96rYUgBj7SKLbuSoyE4k=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1700501825; x=1701106625;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Sj7GhPSDbYDdw4iQB/bb+X84NDAwKJX0VXMHzUWyOhk=;
        b=PlxQximmGa6XgBFZsu9FDT3UzL4wpsUytmVVv//+c2i6tHjp2CXir875gP1+2DynW6
         VG1KVm+SayvRqN9Sq0q10s+huz0iQnvSrdXrpxYQXaMRazUsGhwBwbKl4bUl48O44aae
         1MvBIn+O8FdFA2fd9yiy8BGi8OSaDogSc8zRL25W5EDge1dvMVhOYzNL4aOZakNOkJ0U
         e+zlr3pC2nawOhUudr5oxEK5WTFL7AT0DPqISelFV8PegHeMw70mPeQUEHgd7lIAtle4
         vPImLZLXCzl03nzaCfBGUu5rFUhxAqW7aDEoTn0lYBCNF+7QNx7dPGyo9pQ8Re0OeVQ8
         2MQw==
X-Gm-Message-State: AOJu0Yzen1+Vfy5VF7uMm0lIlLT+hiAnClu1/mPbUamWk7w9ps5svhyh
	5QsWC3go+PNU7OWunmUU68R6zqPpOzpIGrtNVt1t5w==
X-Google-Smtp-Source: AGHT+IG3I0DzeYrhYvzaSPcUd5PkNASMCqm7WXdLWaYaelWaMpPUBtiiNayc3Tq19+JGWGKRhj1qdA==
X-Received: by 2002:a17:906:3f4e:b0:9fd:6818:9415 with SMTP id f14-20020a1709063f4e00b009fd68189415mr3226510ejj.66.1700501825565;
        Mon, 20 Nov 2023 09:37:05 -0800 (PST)
Received: from mail-ed1-f51.google.com (mail-ed1-f51.google.com. [209.85.208.51])
        by smtp.gmail.com with ESMTPSA id me23-20020a170906aed700b009e5c644e34dsm4037421ejb.82.2023.11.20.09.37.04
        for <dm-devel@lists.linux.dev>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 20 Nov 2023 09:37:05 -0800 (PST)
Received: by mail-ed1-f51.google.com with SMTP id 4fb4d7f45d1cf-548ce28fd23so1356441a12.3
        for <dm-devel@lists.linux.dev>; Mon, 20 Nov 2023 09:37:04 -0800 (PST)
X-Received: by 2002:a05:6402:2056:b0:548:d4fb:9c1f with SMTP id
 bc22-20020a056402205600b00548d4fb9c1fmr51556edb.40.1700501824606; Mon, 20 Nov
 2023 09:37:04 -0800 (PST)
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <ZVjgpLACW4/0NkBB@redhat.com> <CAHk-=wjV2S7xBcH2BGuDgfKcg3fjWwk5k74nq89SviMkH-YsJQ@mail.gmail.com>
 <CAHk-=wjCXvFme97sxix_zDfq4-oNRv7fNp+YzWEuUGH-gihA-g@mail.gmail.com>
 <20231119152136.ntnl3sfulo4tgbw3@box.shutemov.name> <20231120133145.y7ghl64bqfpeqtwd@box.shutemov.name>
In-Reply-To: <20231120133145.y7ghl64bqfpeqtwd@box.shutemov.name>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Mon, 20 Nov 2023 09:36:46 -0800
X-Gmail-Original-Message-ID: <CAHk-=wgarn2DnvMsZVfm+vDHyUXk7qGMbZHw+mxYvnc8i+SvKw@mail.gmail.com>
Message-ID: <CAHk-=wgarn2DnvMsZVfm+vDHyUXk7qGMbZHw+mxYvnc8i+SvKw@mail.gmail.com>
Subject: Re: [git pull] device mapper fixes for 6.7-rc2
To: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Cc: Mike Snitzer <snitzer@kernel.org>, Michael Ellerman <mpe@ellerman.id.au>, 
	Andrew Morton <akpm@linux-foundation.org>, dm-devel@lists.linux.dev, 
	linux-block@vger.kernel.org, Alasdair G Kergon <agk@redhat.com>, 
	Benjamin Marzinski <bmarzins@redhat.com>, Mikulas Patocka <mpatocka@redhat.com>
Content-Type: text/plain; charset="UTF-8"

On Mon, 20 Nov 2023 at 05:31, Kirill A. Shutemov
<kirill.shutemov@linux.intel.com> wrote:
>
> NR_ORDERS defines the number of page orders supported by the page
> allocator, ranging from 0 to MAX_ORDER, MAX_ORDER + 1 in total.
>
> NR_ORDERS assists in defining arrays of page orders and allows for more
> natural iteration over them.

Well, the thing is, I really think we need to rename or remove
"MAX_ORDER" entirely.

Because as-is, that #define now has completely different meaning than
it used to have for 24 years. Which is not only confusing to people
who might just remember the old semantics, it's a problem for
backporting (and for merging stuff, but that is a fairly temporary
pain and _maybe_ this one-time device mapper thing was the only time
it will ever happen)

               Linus
