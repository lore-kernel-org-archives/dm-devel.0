Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 79A5D13B2BF;
	Tue, 12 Mar 2024 21:10:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710277817; cv=none; b=AUyg8mHFUPsipcW904NwB547mZFDqIxq5VdsjCM2JRZLoswJZX+9p69gpHdU6wfZ83nJJm6s+Zgx2knsDU8ZztUJzhHQcic5LGHq0qApIl8a1lEsS6qS9KnHu1yIs4n+UerLbjEIzFnna+ltM3rOdgMdRuVToEBfnDlfIHYRr2I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710277817; c=relaxed/simple;
	bh=CEVyQEMC8+7AKjJbmafHANVS16qNlHhnIKkHehP9aMc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=bwvaWE9CQ22iHr5mSjqh7JQOYAmXZUdf2Uz6y/YbYuFqD/Hu3hX3g7twPB3800k0IPtyMpGsDRpwEdYVeEY82Nu70Un+FQQ4V7wnrNTg37v2/5JxGibMYKqtR5fw9gq/CBdgDDtdDRWnKimXxCeYu8heCanodl2uXtqQWCZUlzE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=jMRxq9bf; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="jMRxq9bf"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=FWYlh4Wpsx4MC2nm0TVI5dJoC4f/dhPj7+++MqceolQ=; b=jMRxq9bf7l3t+BzI1ugEcT/T88
	BN5NdvLJ+Z/7OFjRXsfqHalQGPTuk+TAdx4m/lZsNK3BcYPj8bcoXrOnl1HQ8otwqBct+c8nZNvWF
	xjO6V6jIWMS8UexAQmeGr0cGGXUM1jk5EffaWQ8qohno2jSUalz7Yibwexs+3AN3kbpAa7uPXA13c
	iRjSVvReYJCtWP9kDtoqwnQXpYOJXtgPflMrnOxeFWkgOXBPnO8VF2YkecgsBRQuU6lluVO0CVQ7C
	rrvGVB2Gb6qRnSO4aQhyl20FTUJpfqXlNTz34TpCqCLoJkkkfaTmHVP0EpIqXG/FKgd54Ka58/irP
	nXlxU8gA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1rk9O2-00000007YqS-00d5;
	Tue, 12 Mar 2024 21:10:14 +0000
Date: Tue, 12 Mar 2024 14:10:13 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Mike Snitzer <snitzer@kernel.org>
Cc: Christoph Hellwig <hch@infradead.org>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Jens Axboe <axboe@kernel.dk>, Johannes Weiner <hannes@cmpxchg.org>,
	"linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
	dm-devel@lists.linux.dev
Subject: Re: [GIT PULL] Block updates for 6.9-rc1
Message-ID: <ZfDEtchBNeFLG-GV@infradead.org>
References: <eaeec3b6-75c2-4b65-8c50-2d37450ccdd9@kernel.dk>
 <20240311235023.GA1205@cmpxchg.org>
 <CAHk-=wgOfw8NBQ2Qyh8QUjhp5z4v--PuciLE7drn5LJkTtgPVw@mail.gmail.com>
 <e3fea6c3-7704-46cd-b078-0c6e8d966474@kernel.dk>
 <CAHk-=wgXZ6dE1yHK_jQmnSjbEbndyzZHC5dJNsmQYTD2K-m61w@mail.gmail.com>
 <Ze-hwnd3ocfJc9xU@redhat.com>
 <Ze-rRvKpux44ueao@infradead.org>
 <ZfBzTWM7NBbGymsY@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZfBzTWM7NBbGymsY@redhat.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Tue, Mar 12, 2024 at 11:22:53AM -0400, Mike Snitzer wrote:
> blk_validate_limits() is currently very pedantic. I discussed with Jens
> briefly and we're thinking it might make sense for blk_validate_limits()
> to be more forgiving by _not_ imposing hard -EINVAL failure.  That in
> the interim, during this transition to more curated and atomic limits, a
> WARN_ON_ONCE() splat should serve as enough notice to developers (be it
> lower level nvme or higher-level virtual devices like DM).

I guess.  And it more closely matches the status quo.  That being said
I want to move to hard rejection eventually to catch all the issues.

> BUT for this specific max_segment_size case, the constraints of dm-crypt
> are actually more conservative due to crypto requirements.

Honestly, to me the dm-crypt requirement actually doesn't make much
sense: max_segment_size is for hardware drivers that have requirements
for SGLs or equivalent hardware interfaces.  If dm-crypt never wants to
see more than a single page per bio_vec it should just always iterate
them using bio_for_each_segment.

> Yet nvme's
> more general "don't care, but will care if non-nvme driver does" for
> this particular max_segment_size limit is being imposed when validating
> the combined limits that dm-crypt will impose at the top-level.

The real problem is that we combine the limits while we shouldn't.
Every since we've supported immutable biovecs and do the splitting
down in blk-mq there is no point to even inherit such limits in the
upper drivers.

