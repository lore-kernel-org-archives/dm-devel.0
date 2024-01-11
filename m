Received: from mail-qk1-f175.google.com (mail-qk1-f175.google.com [209.85.222.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 55DCB5100C
	for <dm-devel@lists.linux.dev>; Thu, 11 Jan 2024 16:34:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Received: by mail-qk1-f175.google.com with SMTP id af79cd13be357-783182d4a09so595663285a.2
        for <dm-devel@lists.linux.dev>; Thu, 11 Jan 2024 08:34:11 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1704990850; x=1705595650;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=2esTMRQCzcCE33PwQuXk2vauR9yVH94MN9kiOCQ9tzs=;
        b=lHpMvdSg2t6Lz36jcCMUyKKJ/JsZtnveEpD1C8xjfDtkdJE8FM852TlIBnFPT7lGIz
         zJ1YQfAd7GKGwL1DCP3c4FpGDViIfn3su1fmzEYJntkRyXJxQ4UVo7OR2TZz8Fuj6Uss
         C0IMGdg25n/gQFcdDmP5xt9BOjJUf0cd3Qjm6XFF2g0aMOKz0oKxNtga3bl4saKgth7H
         Oq2jJCObZmQYsnmIfoq0xyTixgh7AKFgS9XAmNo108AoOHzMN7CjfJs9p+4q5DO0voNA
         EsTdgMpkvqt7s+0GT1D1t7Y6bot/v2USJwBkxnAspJPvbl2KJZYHi+WEVcgY5G4ak2sq
         R9/w==
X-Gm-Message-State: AOJu0YxlERX7bd1eVLpoFiKDC++AMqOzo3K+kMJa51z4HvGkw20KzlRh
	rzucvWjn4/YcKv52Vqcjk01H4Ir3d6p2
X-Google-Smtp-Source: AGHT+IGAh+m+cNuLkjQr5nL2ko+JrU4YzyDesGitRYonCpP3ZLibLfsaD9Pfaqk12FGIoWeW6hVhbw==
X-Received: by 2002:a05:620a:2fb:b0:783:14df:3d2e with SMTP id a27-20020a05620a02fb00b0078314df3d2emr32292qko.151.1704990850136;
        Thu, 11 Jan 2024 08:34:10 -0800 (PST)
Received: from localhost (pool-68-160-141-91.bstnma.fios.verizon.net. [68.160.141.91])
        by smtp.gmail.com with ESMTPSA id q9-20020a05620a038900b00783237b3330sm444937qkm.31.2024.01.11.08.34.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 11 Jan 2024 08:34:09 -0800 (PST)
Date: Thu, 11 Jan 2024 11:34:08 -0500
From: Mike Snitzer <snitzer@kernel.org>
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Christoph Hellwig <hch@infradead.org>, Jens Axboe <axboe@kernel.dk>,
	linux-block@vger.kernel.org, Mikulas Patocka <mpatocka@redhat.com>,
	dm-devel@lists.linux.dev
Subject: Re: [PATCHSET 0/3] Integrity cleanups and optimization
Message-ID: <ZaAYgJ+xK6c5p1/L@redhat.com>
References: <20240111160226.1936351-1-axboe@kernel.dk>
 <ZaASdg+NkFFy8Khx@infradead.org>
 <yq1o7dr6e09.fsf@ca-mkp.ca.oracle.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <yq1o7dr6e09.fsf@ca-mkp.ca.oracle.com>

On Thu, Jan 11 2024 at 11:24P -0500,
Martin K. Petersen <martin.petersen@oracle.com> wrote:

> 
> > Bw, can someone help with what dm_integrity_profile is for?
> > It is basically identical to the no-op one, just with a different
> > name.  With the no-op removal it is the only one outside of the pi
> > once, and killing it would really help with some de-virtualization
> > I've looked at a while ago.
> 
> No particular objections from me wrt. using a flag.
> 
> However, I believe the no-op profile and associated plumbing was a
> requirement for DM. I forget the details. Mike?

I'll have to take a closer look.. staking device always complicates
things.

But the dummy functions that got wired up with this commit are suspect:
54d4e6ab91eb block: centralize PI remapping logic to the block layer

Effectively the entirety of the dm_integrity_profile is "we don't do
anything special".. so yes it would be nice to not require indirect
calls to accomplish what dm-integrity needs from block core.

Mike
