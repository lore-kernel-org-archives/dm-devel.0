Received: from mail-qv1-f54.google.com (mail-qv1-f54.google.com [209.85.219.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 577397A71D
	for <dm-devel@lists.linux.dev>; Tue, 12 Mar 2024 15:22:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710256978; cv=none; b=YIrViwvVhYzVSHIGwsi05rbTvRuyN43CcSnST6wBE11vFGx2QOthICsL/dqshXGIvNtGzwgs0RpiAP5CSe3VGsTFYXonHncfhzvUZ1t3E6W+BhdMpfUhghxv1UWEhUpsQSYp3b1ZxYY6CTb3oa6vAL3SZmc3ibUYXXVN7Piy+yg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710256978; c=relaxed/simple;
	bh=0vAcxSLi4l6fH5H4bviOsVgBTA4mchz310ZUv7aGtbw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=n5mXh65VV9x+bVTWhAiPO1Q+sMDZn/tfqbam32UmtAgdNIYb3HaAaw2JOrO1i/oWtD59ZZFaeRcc7UcACOZkvgOwSg33LS4/dTdIx87311vZokO+I/cRhrMKwbjdmpU2WDz6xN8TkpjoDSO49mENGMKfj0oA6BM6WP0HJSORsx8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org; spf=pass smtp.mailfrom=redhat.com; arc=none smtp.client-ip=209.85.219.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Received: by mail-qv1-f54.google.com with SMTP id 6a1803df08f44-690d7a8f904so708796d6.1
        for <dm-devel@lists.linux.dev>; Tue, 12 Mar 2024 08:22:56 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710256975; x=1710861775;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=NbU/Lvz7BQx5TO6vgoeKsNgZwne0imjTwQjOCDWQeDY=;
        b=Q7+Hbi7Xaj6X3KDkEe+pi3cwcVdSFrNrmG7kLLUoxJGurCFzFa6HHuFo0T6LOisFWK
         3KF7x25gk9nOJoq/EDsr5DxShUKG/Ue3o6WU5GnZC6ciBLGy8C/9k2DHGJhDakQkz8DG
         6yMgSTcbgWSA+aV3mvjTGaihOxCw77Uj0YL7euAw3+aynSQeSGzAVwtZ6x1fxepMdgZs
         39wIixjwZeA09/hGWPXZq+3z3n2L/bjtLwJ0Wu6r8fAUXpFkk0tnuZW8tlkks5WculQX
         npjtcssx8bjTGBkiadOBEZUpZ9wlg6KnCnCiAkJPYHweqnhTMtDpO/9k1+oguiG+fnEN
         /OJg==
X-Forwarded-Encrypted: i=1; AJvYcCW0dwzeEzOfeQ4zZbWNNFzF0TiPHo2gJ0CDvqdKiNpwa2csnTvxnfe0vwazzeQL5SqI6Bt69ESaT1GRxNlnpNIIjfqtzcMCodc=
X-Gm-Message-State: AOJu0Yz4Dr21vgxfGp08uooDCtq7bvtirKI0WnuPIx19vMqxxYnHKK0Q
	yi+hIsX4xve9UYtypONoZfr8Vrg4pqACwqhg0A/uaY9wV+JpzfKAud2vgRuJlw==
X-Google-Smtp-Source: AGHT+IGtVWgFY7B4+YAvxT4k6duzuHD1e1UcI/bjxCc7plFQt62r5xk0tRu1KWZhE5pXeQVZsOUyYg==
X-Received: by 2002:ad4:5de9:0:b0:690:2069:d413 with SMTP id jn9-20020ad45de9000000b006902069d413mr17952899qvb.6.1710256975288;
        Tue, 12 Mar 2024 08:22:55 -0700 (PDT)
Received: from localhost (pool-68-160-141-91.bstnma.fios.verizon.net. [68.160.141.91])
        by smtp.gmail.com with ESMTPSA id ek19-20020ad45993000000b006907e34d029sm3771891qvb.2.2024.03.12.08.22.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 Mar 2024 08:22:54 -0700 (PDT)
Date: Tue, 12 Mar 2024 11:22:53 -0400
From: Mike Snitzer <snitzer@kernel.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
	Jens Axboe <axboe@kernel.dk>, Johannes Weiner <hannes@cmpxchg.org>,
	"linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
	dm-devel@lists.linux.dev
Subject: Re: [GIT PULL] Block updates for 6.9-rc1
Message-ID: <ZfBzTWM7NBbGymsY@redhat.com>
References: <eaeec3b6-75c2-4b65-8c50-2d37450ccdd9@kernel.dk>
 <20240311235023.GA1205@cmpxchg.org>
 <CAHk-=wgOfw8NBQ2Qyh8QUjhp5z4v--PuciLE7drn5LJkTtgPVw@mail.gmail.com>
 <e3fea6c3-7704-46cd-b078-0c6e8d966474@kernel.dk>
 <CAHk-=wgXZ6dE1yHK_jQmnSjbEbndyzZHC5dJNsmQYTD2K-m61w@mail.gmail.com>
 <Ze-hwnd3ocfJc9xU@redhat.com>
 <Ze-rRvKpux44ueao@infradead.org>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Ze-rRvKpux44ueao@infradead.org>

On Mon, Mar 11 2024 at  9:09P -0400,
Christoph Hellwig <hch@infradead.org> wrote:

> On Mon, Mar 11, 2024 at 08:28:50PM -0400, Mike Snitzer wrote:
> > All for Jens being made to suffer with dm-crypt but I think we need a
> > proper root cause of what is happening for you and Johannes ;)
> 
> I'm going to try to stay out of the cranking, but I think the reason is
> that the limits stacking inherits the max_segment_size, nvme has weird
> rules for them due their odd PRPs, and dm-crypt set it's own
> max_segment_size to split out each page.  The regression here is
> that we now actually verify that conflict.
> 
> So this happens only for dm-crypt on nvme.  The fix is probably
> to not inherit low-level limits like max_segment_size, but I need
> to think about it a bit more and come up with an automated test case
> using say nvme-loop.

Yeah, I generally agree.

I looked at the latest code to more fully understand why this failed.

1) dm-crypt.c:crypt_io_hints() sets limits->max_segment_size = PAGE_SIZE;

2) drivers/nvme/host/core.c:nvme_set_ctrl_limits() sets:
   lim->virt_boundary_mask = NVME_CTRL_PAGE_SIZE - 1;
   lim->max_segment_size = UINT_MAX;

3) blk_stack_limits(t=dm-crypt, b=nvme-pci) will combine limits:
        t->virt_boundary_mask = min_not_zero(t->virt_boundary_mask,
                                            b->virt_boundary_mask);
        t->max_segment_size = min_not_zero(t->max_segment_size,
                                           b->max_segment_size);

4) blk_validate_limits() will reject the limits that
   blk_stack_limits() created:
        /*
         * Devices that require a virtual boundary do not support scatter/gather
         * I/O natively, but instead require a descriptor list entry for each
         * page (which might not be identical to the Linux PAGE_SIZE).  Because
         * of that they are not limited by our notion of "segment size".
         */
	if (lim->virt_boundary_mask) {
                if (WARN_ON_ONCE(lim->max_segment_size &&
                                 lim->max_segment_size != UINT_MAX))
                        return -EINVAL;
                lim->max_segment_size = UINT_MAX;
	} else {
                /*
                 * The maximum segment size has an odd historic 64k default that
                 * drivers probably should override.  Just like the I/O size we
                 * require drivers to at least handle a full page per segment.
                 */
		if (!lim->max_segment_size)
                        lim->max_segment_size = BLK_MAX_SEGMENT_SIZE;
                if (WARN_ON_ONCE(lim->max_segment_size < PAGE_SIZE))
                	return -EINVAL;
        }

blk_validate_limits() is currently very pedantic. I discussed with Jens
briefly and we're thinking it might make sense for blk_validate_limits()
to be more forgiving by _not_ imposing hard -EINVAL failure.  That in
the interim, during this transition to more curated and atomic limits, a
WARN_ON_ONCE() splat should serve as enough notice to developers (be it
lower level nvme or higher-level virtual devices like DM).

BUT for this specific max_segment_size case, the constraints of dm-crypt
are actually more conservative due to crypto requirements. Yet nvme's
more general "don't care, but will care if non-nvme driver does" for
this particular max_segment_size limit is being imposed when validating
the combined limits that dm-crypt will impose at the top-level.

All said, the above "if (lim->virt_boundary_mask)" check in
blk_validate_limits() looks bogus for stacked device limits.

Mike
