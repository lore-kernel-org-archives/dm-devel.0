Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4301A26296;
	Mon, 10 Mar 2025 01:13:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741569211; cv=none; b=SMPPpR+l7LH+TxtwTYExLYVsDLTe+d4DDTS3+SFs6O/DBRPrBbM8ihLKSzERF7HtYaHRF4ECPSowvW/BOQtZeQLK5Woof35a2HxFM6/T+2rCRPo17hqxAPxZ1Clno4zDj5yJV8pdeB2BL6mdzyeoOqoZlzsTMGI8AJZNLAKasLw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741569211; c=relaxed/simple;
	bh=soyTNczKLXceFGzIrc9GsPLorNN8OpES+pQcgj/cgMg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=mPQ0jRDvDo7T3kUNO3SZX4ZPfUsUknwPOVaqWWbAWttMzU9mclBl7nCSuF+DpA8f/XPW82H5a/oQj9QbetOrk0D8ASBbX134InxPf9qLUE6fYFnSv5JKUtIV7JHrDXmBihLi3fsDMPpvxCPmVL19cvGjJyOQ5/sffeBD70vPfe8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=jndHNvdK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="jndHNvdK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7124CC4CEE3;
	Mon, 10 Mar 2025 01:13:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1741569210;
	bh=soyTNczKLXceFGzIrc9GsPLorNN8OpES+pQcgj/cgMg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=jndHNvdKU0cAW+3i1gXI/NRumE5RevL5HhmRgsxC6shN6komkjcWovvxzH+Ul6bAZ
	 smD105ebrVJOJE+6nKKWIu4b+xXxp2KXrIj8eX8C2Vy8O9l29nvIJA4mNJ/zKsxqMo
	 l2Hr6DntbV5Mb0TPy3KXQcJsBjV1ciwTqdoZix6bSuBbr0IefHvN7SkLliy9BEWX/F
	 0USwQa+aVPhtjXiSoQrYZUEMltRA1WtVYzBAyNFDI96VnQJm+g9qz+bfmVYt5RNEZs
	 jiH9uSTqcocsfDJAbgH6xm9kqNGKgGc2LxnbO+Qyw0qW848GAqxhklQ0MjwOdBQ82U
	 woJ/LKymwxVIA==
Date: Sun, 9 Mar 2025 21:13:29 -0400
From: Mike Snitzer <snitzer@kernel.org>
To: Kent Overstreet <kent.overstreet@linux.dev>
Cc: dm-devel@lists.linux.dev, Mikulas Patocka <mpatocka@redhat.com>,
	Alasdair Kergon <agk@redhat.com>, linux-block@vger.kernel.org,
	Josef Bacik <josef@redhat.com>, Jens Axboe <axboe@kernel.dk>,
	Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: Bring back md-faulty? (was Re: dm-flakey: Fix memory corruption)
Message-ID: <CAF3mmA=-xSKpW6M+0L0DVGO0dHugyoiGNNBdJQ9BcbEjocDRrw@mail.gmail.com>
References: <20250308155011.1742461-1-kent.overstreet@linux.dev>
 <Z8yKMlhd-Z0sf6tG@kernel.org>
 <ij3pre7rlgez3ybsfrsj2i3ohoeb5ma5rgz3tfuv63h7rv6uoo@2hw6452r4qbn>
 <Z823ZmamUoGO8P6I@kernel.org>
 <xt5b22a3i6klpdsysz4ds3fubu3p6s22redu56w6ewc7mmcter@kcgbz3ccoedf>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <xt5b22a3i6klpdsysz4ds3fubu3p6s22redu56w6ewc7mmcter@kcgbz3ccoedf>

On Sun, Mar 09, 2025 at 01:04:22PM -0400, Kent Overstreet wrote:
> On Sun, Mar 09, 2025 at 11:44:38AM -0400, Mike Snitzer wrote:
> > On Sat, Mar 08, 2025 at 04:50:05PM -0500, Kent Overstreet wrote:
> > > On Sat, Mar 08, 2025 at 01:19:30PM -0500, Mike Snitzer wrote:
> > > > On Sat, Mar 08, 2025 at 10:50:08AM -0500, Kent Overstreet wrote:
> > > > > So, this code clearly isn't getting tested - at all. Besides this 
bug,
> > > > > the parsing for the "corrupt" modes is also broken.
> > > > > 
> > > > > Guys, don't push broken crap, and figure out how to write some 
tests.
> > > > 
> > > > Thank you sir, may we have another?
> > > > 
> > > > Like you never introduced a bug in your life?
> > > > 
> > > > Not going to tolerate your entitled primadonna attitude here.  You 
are
> > > > capable of being better, you've chosen not to be on this issue 
(twice)
> > > 
> > > Talking about basic engineering standards is in no way "being a prima
> > > donna". Testing your changes is as basic as it gets, and this code
> > > wasn't tested _at all_.
> > 
> > "entitled primadonna attitude" was me pulling punches.
> > 
> > I don't disagree that this is a bug that was missed and that proper
> > testing hasn't been performed (I'd quibble with the no testing part
> > only because I cannot speak for Mikulas and don't like to assume I
> > know it all).
> > 
> > But you're missing the very problematic detail: you used a bug in an
> > optional feature of the test-only dm-flakey target to try to take a
> > pound of flesh while preaching from your high horse.  That is
> > unacceptable behaviour that won't be tolerated here.  Be cool and
> > others will be in return (unless you keep setting fire to bridges).
> > 
> > Fin.
> 
> Mike, saying code needs to be tested is not an "entitled primadonna
> attitude".

Definition of primadonna: 
"a very temperamental person with an inflated view of their own talent
or importance."

My issue from the start on Friday night (in private) has always been
how holier-than-thou yet abusive you've been since having discovered
this bug in dm-flakey's optional "corrupt_bio_byte" feature.

> Pushing completely broken code because you made no attempt to
> test it and then flipping out when called out over it - that is.

I didn't push commit 1d9a94389853 _because_ I "made no attempt to test
it".  Commit 1d9a94389853 sought to fix a similar but different
corruption in the original "corrupt_bio_byte" implementation (which
proved useful for the specific case it was first developed for).

> To recap, we're not talking about some obscure corner cases, we're
> talking about core documentated functionality in dm-flakey that is
> completely broken in ways that show up immediately if you run it - and
> there's at least three bugs that I saw; the parsing code, the
> clone_bio() memory corruption, and the read side corruption still wasn't
> working when I fixed or worked around the other two (write side did).
> 
> This isn't your personal project, this is the kernel - there are
> standards, and other people depend on your work. dm-flakey is used
> heavily by filesystem folks, and additionally, md-faulty was recently
> removed because, supposedly, dm-flakey was sufficient.
> 
> And that's what I was using before, and it worked fine, so I'm willing
> to bring it back and maintain it if dm-flakey can't be relied on.

This dm-flakey corrupt_bio_byte bug will be fixed upstream this week.

But your recap is devoid of any understanding that my responses to
this dm-devel thread, and your private messages, have primarily taken
issue with how you've chosen to conduct yourself.

I'm not aware of dm-flakey's corrupt_bio_byte being used in upstream
testing frameworks (xfstests only uses flakey's basic capabilities).

Any willingness to elevate dm-flakey's corrupt_bio_byte to wider use
in upstream testing frameworks would have uncovered the need for your
fix.  You were first to notice it.  Rather than be cool about it,
you've been hostile from the start and completely misrepresented the
significance of the bug given the limited scope of who is impacted.

I really am done responding to your escalating campaign of self-owns.
