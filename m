Received: from mail-ej1-f50.google.com (mail-ej1-f50.google.com [209.85.218.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7542E20DCD
	for <dm-devel@lists.linux.dev>; Tue, 21 Nov 2023 17:47:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="eIUvxWA5"
Received: by mail-ej1-f50.google.com with SMTP id a640c23a62f3a-a0064353af8so2380366b.0
        for <dm-devel@lists.linux.dev>; Tue, 21 Nov 2023 09:47:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google; t=1700588835; x=1701193635; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=GWpUH6i/TWiULkSXxy7JKYlrCmr9Zd67SZ1skaJHNkw=;
        b=eIUvxWA54gDsZC83UZAFB+wQt6Xa90u0USR3e7+U/2QUeTsGFPh3OJK5PVcsIo1u4q
         NsQM2QcXK6wHsQHmnpgWRf9tOHyJQQURavtRfIt44Prlb1kdkgMj//qiFQRbb+i1I0t2
         e3fXD5sMIcdRCb2r39LmQvusEapac2R/AivPw=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1700588835; x=1701193635;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=GWpUH6i/TWiULkSXxy7JKYlrCmr9Zd67SZ1skaJHNkw=;
        b=o9NwQEK9zFGmpPQ/LcvYKVJTf8Znyi9nt5yDtwf/2YwC35I8AK7FO6WABgT1wm00lj
         JSJj1qcSV4PL4JhIDeT7rZmTvkuOSyeoEovG7uslmz086th8F8IcoEG0lwj35ocXnXXW
         CgDOCpqk7yFGu4PzfyHQg27VsljWNEarTCIKQALmqyEsPmCEJb8Xwi33A7Ju39JiSHEU
         BiYy6frA7Vh60hzpUDQWhsPtE4F+XaC3dqvrh5WLHUfBiIRIMoh312sPiFUunwdmY4T/
         mHEeqeMMsLiv1epfbExPw9D9S5gUBNaTzlAVs/ewUr4dEP+MUR3D+y8NxQbBxVIZEpJQ
         lQow==
X-Gm-Message-State: AOJu0YzKfWdbuxHNZRJxaoEWE8w+nEE2tS3vIyyYMbVG+Mgdullzv7VV
	bS08GdaKQxx12391JwGQc9gZENoCHJCzyxeKzeTQVw==
X-Google-Smtp-Source: AGHT+IFInsgb6//zvQQ0ENKQCCAUuacBv97kFH7Zlmlt2DN8x9KBjG+uv+53Hk3taqN91m8qYWI4aQ==
X-Received: by 2002:a17:906:4e57:b0:9e5:1db7:3199 with SMTP id g23-20020a1709064e5700b009e51db73199mr95260ejw.4.1700588835538;
        Tue, 21 Nov 2023 09:47:15 -0800 (PST)
Received: from mail-ed1-f54.google.com (mail-ed1-f54.google.com. [209.85.208.54])
        by smtp.gmail.com with ESMTPSA id s10-20020a170906060a00b009efe6fdf615sm5387614ejb.150.2023.11.21.09.47.14
        for <dm-devel@lists.linux.dev>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 21 Nov 2023 09:47:14 -0800 (PST)
Received: by mail-ed1-f54.google.com with SMTP id 4fb4d7f45d1cf-547e7de7b6fso21028a12.0
        for <dm-devel@lists.linux.dev>; Tue, 21 Nov 2023 09:47:14 -0800 (PST)
X-Received: by 2002:a50:ec8d:0:b0:545:27f5:3bd8 with SMTP id
 e13-20020a50ec8d000000b0054527f53bd8mr33687edr.20.1700588834427; Tue, 21 Nov
 2023 09:47:14 -0800 (PST)
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20231120221735.k6iyr5t5wdlgpxui@box.shutemov.name> <20231121122712.31339-1-kirill.shutemov@linux.intel.com>
In-Reply-To: <20231121122712.31339-1-kirill.shutemov@linux.intel.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Tue, 21 Nov 2023 09:46:57 -0800
X-Gmail-Original-Message-ID: <CAHk-=wiqu14v=RdTYZwF60gpBb0gYdN++u-e-jnqkjEm0m6UdA@mail.gmail.com>
Message-ID: <CAHk-=wiqu14v=RdTYZwF60gpBb0gYdN++u-e-jnqkjEm0m6UdA@mail.gmail.com>
Subject: Re: [PATCH 1/2] mm, treewide: Introduce NR_PAGE_ORDERS
To: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Cc: akpm@linux-foundation.org, agk@redhat.com, bmarzins@redhat.com, 
	dm-devel@lists.linux.dev, linux-block@vger.kernel.org, mpatocka@redhat.com, 
	mpe@ellerman.id.au, snitzer@kernel.org
Content-Type: text/plain; charset="UTF-8"

On Tue, 21 Nov 2023 at 04:27, Kirill A. Shutemov
<kirill.shutemov@linux.intel.com> wrote:
>
> NR_PAGE_ORDERS defines the number of page orders supported by the page
> allocator, ranging from 0 to MAX_ORDER, MAX_ORDER + 1 in total.
>
> NR_PAGE_ORDERS assists in defining arrays of page orders and allows for
> more natural iteration over them.

These two patches look much better to me, but I think you missed one area.

Most of the Kconfig changes by commit 23baf831a32c ("mm, treewide:
redefine MAX_ORDER sanely") should also be basically reverted to use
this new NR_PAGE_ORDERS.

IOW, I think the ARCH_FORCE_MAX_ORDER #defines etc should also be done
in "number of page orders". I suspect from a documentation standpoint
that also makes more sense in places, eg I think that right now your
patch says

                        amount of memory for normal system use. The maximum
-                       possible value is MAX_ORDER/2.  Setting this parameter
+                       possible value is MAX_PAGE_ORDER/2.  Setting this

and that's actually nonsensical, because it's NR_PAGE_ORDERS that was
at least historically the boundary (and historically the one that was
an even number that can be halved cleanly).

So that kernel parameter should be in terms of NR_PAGE_ORDERS.

But yes, I do think the naming now makes more sense, so other than
that reaction I think these changes are good.

                  Linus
