Received: from mail-ot1-f47.google.com (mail-ot1-f47.google.com [209.85.210.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA369143753
	for <dm-devel@lists.linux.dev>; Tue, 12 Mar 2024 22:22:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710282145; cv=none; b=sAJ1L+HHYizHL5sAjAlaFIJhr+HkVEWSxdRvAjR0IpC2xVGvXoo4rDs+2EGywOIzwd1DYLDjl83PUHtw1cUpjRogpcT/nVu0pYq/7qJW+A06D2awwAAwoU7ZIA3rqE9qd7kWNMaCwXe1WDXItCrAV1Jaet1yUckJzb3fnxPS4/M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710282145; c=relaxed/simple;
	bh=GD9Y0Y/aRYEfzegiQHX6Lie6FIxnb9EUQBca2O5UDbQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=fbabloDTRhUl861c4Z8vcFDNXSlyNmWvfmdjKLpp4hvW4SpFRYAg7oCjeIuHbBcvTlcAGyqt/cBCei87pcPyKCie2B13HGXTeD3fAgxMWKAIP6lrlLi12RT2LUZqxWSfXzrWJ3XNZuhLy2zJrP5Vq1ICPkJSppjaFdqR2mbxFyE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org; spf=pass smtp.mailfrom=redhat.com; arc=none smtp.client-ip=209.85.210.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Received: by mail-ot1-f47.google.com with SMTP id 46e09a7af769-6e513700636so1593442a34.1
        for <dm-devel@lists.linux.dev>; Tue, 12 Mar 2024 15:22:23 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710282143; x=1710886943;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=0F5QBp75Nt5yt9KIOFYH3KbyyaonOmB5y1YzHGy0sLQ=;
        b=EGBZxiHI8Qld0a8yT13VoR0wGYo2Rury+Em7lvReP+CCTx+C2Y9vyyB4/tKhpKC/hX
         R/G801DmVvwqVAarP22i2kqq4TiQP5zry07BX/c1nqZWO80f4EtL1LrfufSkAj5O0Cfn
         pIU8z+Fv/N4cpCWEIzoHl3h7jmjh93h9LG8J5uwWPI4IMLOiK9xKbGoWMbM8AywZMGd4
         3msCcQ32WW/bHqKI+Q+Ifyo4mLJcEgTT4w0XZlXdtkaPyS3fz+qve6ZsNApfPyluAmwx
         SDOI6TwomcdMqvPl3dturJru0oVywTKgtzkLlozK5Z8zlomDDXZj5oGmRD5EDWiR+2jX
         gHzQ==
X-Forwarded-Encrypted: i=1; AJvYcCWQQ/3BKdZq1xi//JP2L98KIVHULY7yBrMeJUo9HVG+jmiNDb6VjpIniRbPaKxolv0VYm7UnhOAWL8hmZ9bztSZNM2kw9HH5qA=
X-Gm-Message-State: AOJu0YzSoz8RosPsldsSPrxnv5dWabI1HBxFl2pLau6ZXXwPcB4bfwat
	22lmopFnGH6Obr7D283RnSYF1z7pnkGZIs21Z8XigCeoNZMJbVvoudFjrZ/dNg==
X-Google-Smtp-Source: AGHT+IEiDgu2AH/cTRJGdQj4gxh9fPNhTa2QQybcdt4CdtQEhHbSYD7abjxi2wnfNwybhvE+CTNOoQ==
X-Received: by 2002:a05:6830:1498:b0:6e5:2fe1:dec0 with SMTP id s24-20020a056830149800b006e52fe1dec0mr6564105otq.23.1710282143028;
        Tue, 12 Mar 2024 15:22:23 -0700 (PDT)
Received: from localhost (pool-68-160-141-91.bstnma.fios.verizon.net. [68.160.141.91])
        by smtp.gmail.com with ESMTPSA id l2-20020ae9f002000000b0078860cacdefsm3735134qkg.77.2024.03.12.15.22.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 Mar 2024 15:22:22 -0700 (PDT)
Date: Tue, 12 Mar 2024 18:22:21 -0400
From: Mike Snitzer <snitzer@kernel.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
	Jens Axboe <axboe@kernel.dk>, Johannes Weiner <hannes@cmpxchg.org>,
	"linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
	dm-devel@lists.linux.dev
Subject: Re: [GIT PULL] Block updates for 6.9-rc1
Message-ID: <ZfDVnVuDYwzDVnDx@redhat.com>
References: <eaeec3b6-75c2-4b65-8c50-2d37450ccdd9@kernel.dk>
 <20240311235023.GA1205@cmpxchg.org>
 <CAHk-=wgOfw8NBQ2Qyh8QUjhp5z4v--PuciLE7drn5LJkTtgPVw@mail.gmail.com>
 <e3fea6c3-7704-46cd-b078-0c6e8d966474@kernel.dk>
 <CAHk-=wgXZ6dE1yHK_jQmnSjbEbndyzZHC5dJNsmQYTD2K-m61w@mail.gmail.com>
 <Ze-hwnd3ocfJc9xU@redhat.com>
 <Ze-rRvKpux44ueao@infradead.org>
 <ZfBzTWM7NBbGymsY@redhat.com>
 <ZfDEtchBNeFLG-GV@infradead.org>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZfDEtchBNeFLG-GV@infradead.org>

On Tue, Mar 12 2024 at  5:10P -0400,
Christoph Hellwig <hch@infradead.org> wrote:

> On Tue, Mar 12, 2024 at 11:22:53AM -0400, Mike Snitzer wrote:
> > blk_validate_limits() is currently very pedantic. I discussed with Jens
> > briefly and we're thinking it might make sense for blk_validate_limits()
> > to be more forgiving by _not_ imposing hard -EINVAL failure.  That in
> > the interim, during this transition to more curated and atomic limits, a
> > WARN_ON_ONCE() splat should serve as enough notice to developers (be it
> > lower level nvme or higher-level virtual devices like DM).
> 
> I guess.  And it more closely matches the status quo.  That being said
> I want to move to hard rejection eventually to catch all the issues.
> 
> > BUT for this specific max_segment_size case, the constraints of dm-crypt
> > are actually more conservative due to crypto requirements.
> 
> Honestly, to me the dm-crypt requirement actually doesn't make much
> sense: max_segment_size is for hardware drivers that have requirements
> for SGLs or equivalent hardware interfaces.  If dm-crypt never wants to
> see more than a single page per bio_vec it should just always iterate
> them using bio_for_each_segment.
> 
> > Yet nvme's
> > more general "don't care, but will care if non-nvme driver does" for
> > this particular max_segment_size limit is being imposed when validating
> > the combined limits that dm-crypt will impose at the top-level.
> 
> The real problem is that we combine the limits while we shouldn't.
> Every since we've supported immutable biovecs and do the splitting
> down in blk-mq there is no point to even inherit such limits in the
> upper drivers.

immutable biovecs, late splitting and blk-mq aren't a factor.

dm-crypt has to contend with the crypto subsystem and HW crypto
engines that have their own constraints.
