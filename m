Received: from mail-oo1-f52.google.com (mail-oo1-f52.google.com [209.85.161.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BDCED3F4CA
	for <dm-devel@lists.linux.dev>; Tue, 24 Oct 2023 21:33:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org; dkim=none
Received: by mail-oo1-f52.google.com with SMTP id 006d021491bc7-581ed744114so1991566eaf.0
        for <dm-devel@lists.linux.dev>; Tue, 24 Oct 2023 14:33:15 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1698183194; x=1698787994;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ydoeA8bMPTFfL7KIyd2iImmXpydvV8NCmR/UYsYbpxw=;
        b=A182l+dbERz8RyP3kE2aYlHuD1J2IsH/cCm/nQpuYDUUnDxFPjgTIq6mHkI4Bz7x1E
         JUTDj32fL3sIiSZCnPN6gFOLGm8tRMlG/tb4gApcyOU6kexiZ1WQwUQoWrNq2PMCPY8i
         9t9VNSka0It/D2ou/f/vXHZXjydcxAzICoh2QyiAMyvhtfb7LSzSUqh5B0PYgCAcQg9u
         8V7dmAjwD7H/cfyzioRvBW8bzKYXTJ76Mc/Qt12daq+ubJFtHzbr17+a93pl9staIe2o
         YK3V/faXi/B7WV8YNZiqTDDh9tCgdlg1tNKRxr2OnT5gRgBHWZm2t9Dutf3+fNTKr70W
         UaQw==
X-Gm-Message-State: AOJu0YxWoh5nbDH/f05XGth7JkL+R8M/j79/d9Xl5CR/fPDYI+/oRsrd
	ERjiaJu4Vs2bjMw10bfD/bZk
X-Google-Smtp-Source: AGHT+IFqScwwPuBCfU8gLwXESZj/TMXWuFnwg6pun1lrsaq6xPSm0Hu7AUgBAWsoFigBdJfZnWdsrw==
X-Received: by 2002:a05:6358:72a3:b0:168:e707:2e56 with SMTP id w35-20020a05635872a300b00168e7072e56mr4769109rwf.16.1698183194698;
        Tue, 24 Oct 2023 14:33:14 -0700 (PDT)
Received: from localhost (pool-68-160-141-91.bstnma.fios.verizon.net. [68.160.141.91])
        by smtp.gmail.com with ESMTPSA id e20-20020ad442b4000000b0065d1380dd17sm3840065qvr.61.2023.10.24.14.33.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 24 Oct 2023 14:33:14 -0700 (PDT)
Date: Tue, 24 Oct 2023 17:33:12 -0400
From: Mike Snitzer <snitzer@kernel.org>
To: Kees Cook <keescook@chromium.org>
Cc: Alasdair Kergon <agk@redhat.com>, dm-devel@lists.linux.dev,
	Justin Stitt <justinstitt@google.com>,
	linux-hardening@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: dm crypt: replace open-coded kmemdup_nul
Message-ID: <ZTg4GA005km7mmgC@redhat.com>
References: <20230925-strncpy-drivers-md-dm-crypt-c-v1-1-eef875e4f9b2@google.com>
 <169818232968.2100071.5806064081646325604.b4-ty@chromium.org>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <169818232968.2100071.5806064081646325604.b4-ty@chromium.org>

On Tue, Oct 24 2023 at  5:18P -0400,
Kees Cook <keescook@chromium.org> wrote:

> On Mon, 25 Sep 2023 06:35:54 +0000, Justin Stitt wrote:
> > kzalloc() followed by strncpy() on an expected NUL-terminated string is
> > just kmemdup_nul(). Let's simplify this code (while also dropping a
> > deprecated strncpy() call [1]).
> > 
> > 
> 
> Applied to for-next/hardening, thanks!
> 
> [1/1] dm crypt: replace open-coded kmemdup_nul
>       https://git.kernel.org/kees/c/17348b0a6a6d
> 
> Take care,
> 
> -- 
> Kees Cook
> 

Hey,

I had picked up this patch and the 3 others in my local tree
yesterday, was going to push shortly... do you still want them to go
through your hardening tree?

Mike


