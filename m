Received: from mail-qk1-f170.google.com (mail-qk1-f170.google.com [209.85.222.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 577243F8251
	for <dm-devel@lists.linux.dev>; Thu,  6 Aug 2026 08:29:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786004967; cv=none; b=vGt36HmZ8dWJ9KtRr3qKkHaxHXi1YVf2nyNryVkpy90nZSjYV6ybOogCGYQYhq6SgVQS75iTeHBkDJYppz3eArzcjtfJQ/xCVq2R8dC7SnLLJuK1uLnJxiAi/Ipco/xSvGT7hS0jkwz9d6lGDmDZVx4OF8rON7UqQjrJdrYZOYg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786004967; c=relaxed/simple;
	bh=uPTGsqwqW72fV9uO1Q1bBszUUqt+DIw0cPITC9fmsxI=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=tfQVZNeFT+tq5vPMZBszjoLeArX+eH+vg+t8eCn/1PWTn2t0NWs2qdS6LsdpH9QRJJ1I4ClyvkJo2yRUJyRu0bYHFDkow9/UCONjsJ272Qfc41UB72Y2aAjygJy5Gw8JLykW9KSzoD93+/LCK5ZpW7WpeiEN4buR5KHI2UypZEw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=0b1t.tech; spf=pass smtp.mailfrom=gmail.com; arc=none smtp.client-ip=209.85.222.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=0b1t.tech
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-qk1-f170.google.com with SMTP id af79cd13be357-936623c6dd3so8645985a.0
        for <dm-devel@lists.linux.dev>; Thu, 06 Aug 2026 01:29:25 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786004964; x=1786609764;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=8L67UEittnM3U78kuIxDIhdFKAHMIN1W6YC5oHWi9ks=;
        b=IG5bQHLIQ1dvDMpBYEpizLhAhlVl+nWLFA0gAfk/ulXpHyRyZHztv9RCKi17r9e1WJ
         JNsmE9hWuCTAFSskbIUsUDomui0caJvJ4APbxdQCLQM5AfGm4zKV7XAC1TJPjxmofYF+
         WKdA0Re+EeXVuz0lbgbtLLqiRJGkzHycRm10sBmS1E1cqCtebVHa+o8ZrYNEgonv2LIG
         VaN7hQoQLPgCo8TMutgL1UYUnhNHBVKHjxMykuvCT27QLiuF7eYPqQfEz6JUwIipoTTI
         evKYlb7anqjbCBTbggHqf+hlsa2Ni68pa2RdqZuC3dMvMWrOgkHnJEVfkYmfQq3zG/Ju
         irQA==
X-Forwarded-Encrypted: i=1; AHgh+RrD4GCHlM6RV0x5SGkuRMwvCNEKvciyuvdflYh+0I2Mj6En05u6WaTCvUNC6D6rrtlsPGtftAMxHw==@lists.linux.dev
X-Gm-Message-State: AOJu0YxeZKxngAQf/wKHScQlmZZbyBiBrH7fd7n27SWqXIFemWrrQxPU
	dJIfxzHxTmKb1cY9Xxs3ftDrAo/PvbNtdybcmiqXEF+UFpFYCVLj9NWnasrmxLV/8pWmF79a
X-Gm-Gg: AR+sD13KPwHe4ixpoMwcf3mGkGtPdNGqci0zJt10Ek+5TzWIFpL0jzmDqJcPUDat/H0
	stcPXhoBV74wQ5Q9loLYGhgQfthKaRWwzNrrrDJKlDTaUNv+jD7wD9MUDMIWziBqVFxRx7UI/FR
	fEJ20BgOOQKm4mwhdQHx89Y1U2dXgG8yg4QwZlhK4a82v9tAPqWpzNd2D4CvWLYqll4RpsNVCYb
	9zfjovyt6UXmnRW2C+MHjS3k+owbtz/8gTcahn1Ri3QaHkDu9LVQ3JyxnThL0FJBJhChiHCfMJY
	lIr8J8Bg3XW21Jtt7Q9UZLUzm5XUacZyxM8iR8B05+VbXa3pqrjsWMilrk8xoErJXe0avPMy2Bi
	l1QSe9IQVMnKxf2kFLY4dMJMZdrgLu/qlQB0rYP/9PsDM1eLhYd5Oc8OD9G1fAYmojORPUPhby/
	qAtY2G/xH7nlizrGXIrRwbEkyQZ9hdvcGyXBWHT+K41VwZ+lTz/BOFY4sqxoBDshtstXe6fsm3T
	ZitivPXBO5wN7rwcWsi
X-Received: by 2002:a05:620a:2681:b0:92e:5949:3567 with SMTP id af79cd13be357-9365959e194mr531001385a.14.1786004963995;
        Thu, 06 Aug 2026 01:29:23 -0700 (PDT)
Received: from mail-qt1-f173.google.com (mail-qt1-f173.google.com. [209.85.160.173])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-9365840363dsm195529785a.39.2026.08.06.01.29.22
        for <dm-devel@lists.linux.dev>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 06 Aug 2026 01:29:22 -0700 (PDT)
Received: by mail-qt1-f173.google.com with SMTP id d75a77b69052e-51c149c5722so5788101cf.0
        for <dm-devel@lists.linux.dev>; Thu, 06 Aug 2026 01:29:22 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AHgh+Rp970W8+uVl51Vbs6a9qphIgTNG/x5CUb/ozqPbEDWc9Gp5bVMPcYnUunL6mwFpTPAVZ85owU7+FQ==@lists.linux.dev
X-Received: by 2002:a05:622a:4d86:b0:51c:b91a:33f9 with SMTP id
 d75a77b69052e-52cfb00255dmr55127701cf.13.1786004962328; Thu, 06 Aug 2026
 01:29:22 -0700 (PDT)
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260720201057.1862857-1-kbusch@meta.com> <20260720201057.1862857-6-kbusch@meta.com>
 <anMscoGkR5BYjSGy@shinmob> <anQ-28nxOqBmQjxu@shinmob>
In-Reply-To: <anQ-28nxOqBmQjxu@shinmob>
From: 0wnerD1ed <l7z@0b1t.tech>
Date: Thu, 6 Aug 2026 16:29:10 +0800
X-Gmail-Original-Message-ID: <CAKTh27_RnTA_Q8qAbQ60gBo9Op_OQm7J8KyamQ_tbuTRb4XF2w@mail.gmail.com>
X-Gm-Features: AUfX_mw5QWwwkKt-kO8BytpUZdN-dhibuCeCRe8GGvMpBbYSL4fmaxKXk8xK3Mc
Message-ID: <CAKTh27_RnTA_Q8qAbQ60gBo9Op_OQm7J8KyamQ_tbuTRb4XF2w@mail.gmail.com>
Subject: Re: [PATCH RESEND 5/5] block: validate user space vectors during extraction
To: "Shin'ichiro Kawasaki" <shinichiro.kawasaki@wdc.com>
Cc: Keith Busch <kbusch@meta.com>, linux-block@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, dm-devel@lists.linux.dev, hch@lst.de, 
	axboe@kernel.dk, brauner@kernel.org, djwong@kernel.org, 
	viro@zeniv.linux.org.uk, Keith Busch <kbusch@kernel.org>, stable@vger.kernel.org, 
	Hannes Reinecke <hare@kernel.org>
Content-Type: text/plain; charset="UTF-8"

On Aug 06, 2026 / 16:04, Shin'ichiro Kawasaki wrote:
> I took a closer look. I modified the test case to respect the dma alignment [*],
> and now the test case passes. This approach looks working. Will post the change
> as a formal patch for review.

Sorry for the slow reply, I have been busy lately.

Thanks for chasing this down. The test is mine and its assumption is
wrong, not the kernel, src/bio-full-trim puts the destination at
p + page_size - 1, and null_blk advertises dma_alignment = 1 since
commit 3451cf34f51b ("null_blk: allow byte aligned memory offsets"),
so iov_iter_extract_bvecs() now rejects that odd address before
anything is extracted and bio_iov_iter_align_down() is never reached.
That restores the behaviour we had until 5ff3f74e145a ("block:
simplify direct io validity check"), so the test is what has to
respect dma_alignment. Your approach is the right one.

One problem in the trial patch, the guard has to be against the
logical block size, not the page size. What the test needs is a
fragment that bio_iov_iter_align_down() removes completely, i.e. one
smaller than the block size, and the read has to reach the PROT_NONE
page. With dma_alignment = 511 and a 512 byte block size (the block
layer default for drivers that do not set dma_alignment),
dma_aligned_offset becomes 512, which is below page_size and passes
the check, but the read then lies entirely within the first page,
succeeds, and the helper reports

      pread returned 512 (errno 0)

instead of taking the "unexpected dma_alignment" exit. block/045 only
uses null_blk so this cannot bite today, but the check does not do
what it intends. block_size comes from BLKSSZGET, so it also has to
move below that ioctl:

      if (dma_aligned_offset >= block_size)
              errx(EXIT_FAILURE,
                   "unexpected dma_alignment %u for block size %u",
                   dma_alignment, block_size);

While there, err() should be errx(), errno is not meaningful at that
point.

I am short on time at the moment, so please go ahead with the formal
posting. I will send a Tested-by once I get a chance to run it.

Regards,

0wnerD1ed
l7z@0b1t.tech
