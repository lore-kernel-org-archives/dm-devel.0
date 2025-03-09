Received: from out-172.mta1.migadu.com (out-172.mta1.migadu.com [95.215.58.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 651652AE95
	for <dm-devel@lists.linux.dev>; Sun,  9 Mar 2025 17:04:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741539874; cv=none; b=q6WldkWhQWYFBDKUh/kzu6wKRbvJNeTJT61r+PtqsqiA9XxIla3/va+PsnUuNEw4KzrseRtWXRhKRs8Na/POEd88jpdWjAB4WnIV719a+0KCYl6tUBhKjLGyDbRQTC40GBW23O3gRPKX8JukDQAlnUP//snLMdCEyJO66XXsqec=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741539874; c=relaxed/simple;
	bh=5F9GMK+dh0RLB41h5cOrqscqckOnfTZ2PetY+a9Kfrc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=eL0eA0As7F8lFZDUWnugyI9PVIxzmQKYiQpT5Ls8U12WkO/nQSrIWGRV4V0XVi9XxuSlfAXgIHL7BwTLY2/kt3ksk73Sih9iEY6qhgJDfhbmFBeJzjJGU8vJ2jp3C2YdLq4WKYH/IULI+Ltna3M/x6H0tbQQgHDwbiAWkpPYGA0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=iZE47u+L; arc=none smtp.client-ip=95.215.58.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="iZE47u+L"
Date: Sun, 9 Mar 2025 13:04:22 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1741539869;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=JN2+3PxWzjJWZY3E01tDTQ/yxuQF1+/hXqt42PsFsCQ=;
	b=iZE47u+LZypnqrhSWr2cDhml+RN5iJ81/O7ZOWANbRLu5TuG1yWZfOq5KKp0zSPd92TmQu
	EYsr+Us8I0qLIqKgbID5ZjQ0DXMpOB0BfCygnpM2NpWMz7QmnQrbLt2ZmPD1bUwWNvr9gg
	0gYVPHznCDM3BOWqg2uo/pHCPCB/v0U=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kent Overstreet <kent.overstreet@linux.dev>
To: Mike Snitzer <snitzer@kernel.org>
Cc: dm-devel@lists.linux.dev, Mikulas Patocka <mpatocka@redhat.com>, 
	Alasdair Kergon <agk@redhat.com>, linux-block@vger.kernel.org, Josef Bacik <josef@redhat.com>, 
	axboe@kernel.dk, Linus Torvalds <torvalds@linux-foundation.org>
Subject: Bring back md-faulty? (was Re: dm-flakey: Fix memory corruption)
Message-ID: <xt5b22a3i6klpdsysz4ds3fubu3p6s22redu56w6ewc7mmcter@kcgbz3ccoedf>
References: <20250308155011.1742461-1-kent.overstreet@linux.dev>
 <Z8yKMlhd-Z0sf6tG@kernel.org>
 <ij3pre7rlgez3ybsfrsj2i3ohoeb5ma5rgz3tfuv63h7rv6uoo@2hw6452r4qbn>
 <Z823ZmamUoGO8P6I@kernel.org>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Z823ZmamUoGO8P6I@kernel.org>
X-Migadu-Flow: FLOW_OUT

On Sun, Mar 09, 2025 at 11:44:38AM -0400, Mike Snitzer wrote:
> On Sat, Mar 08, 2025 at 04:50:05PM -0500, Kent Overstreet wrote:
> > On Sat, Mar 08, 2025 at 01:19:30PM -0500, Mike Snitzer wrote:
> > > On Sat, Mar 08, 2025 at 10:50:08AM -0500, Kent Overstreet wrote:
> > > > So, this code clearly isn't getting tested - at all. Besides this bug,
> > > > the parsing for the "corrupt" modes is also broken.
> > > > 
> > > > Guys, don't push broken crap, and figure out how to write some tests.
> > > 
> > > Thank you sir, may we have another?
> > > 
> > > Like you never introduced a bug in your life?
> > > 
> > > Not going to tolerate your entitled primadonna attitude here.  You are
> > > capable of being better, you've chosen not to be on this issue (twice)
> > 
> > Talking about basic engineering standards is in no way "being a prima
> > donna". Testing your changes is as basic as it gets, and this code
> > wasn't tested _at all_.
> 
> "entitled primadonna attitude" was me pulling punches.
> 
> I don't disagree that this is a bug that was missed and that proper
> testing hasn't been performed (I'd quibble with the no testing part
> only because I cannot speak for Mikulas and don't like to assume I
> know it all).
> 
> But you're missing the very problematic detail: you used a bug in an
> optional feature of the test-only dm-flakey target to try to take a
> pound of flesh while preaching from your high horse.  That is
> unacceptable behaviour that won't be tolerated here.  Be cool and
> others will be in return (unless you keep setting fire to bridges).
> 
> Fin.

Mike, saying code needs to be tested is not an "entitled primadonna
attitude". Pushing completely broken code because you made no attempt to
test it and then flipping out when called out over it - that is.

To recap, we're not talking about some obscure corner cases, we're
talking about core documentated functionality in dm-flakey that is
completely broken in ways that show up immediately if you run it - and
there's at least three bugs that I saw; the parsing code, the
clone_bio() memory corruption, and the read side corruption still wasn't
working when I fixed or worked around the other two (write side did).

This isn't your personal project, this is the kernel - there are
standards, and other people depend on your work. dm-flakey is used
heavily by filesystem folks, and additionally, md-faulty was recently
removed because, supposedly, dm-flakey was sufficient.

And that's what I was using before, and it worked fine, so I'm willing
to bring it back and maintain it if dm-flakey can't be relied on.
