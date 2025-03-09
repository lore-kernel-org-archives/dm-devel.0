Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC6EE1DE3B3
	for <dm-devel@lists.linux.dev>; Sun,  9 Mar 2025 15:44:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741535080; cv=none; b=ccE3O26//uWcoV9L1RVbEKqrwCLuS/Ha3OUABqb4vub5wzTO+1P0gK2jQk/vOakrv0nKJ43b8AAPQ2/GwMCPBXd2ZNdjPYoq7A9mstU3FAUTgiMzRr40z03UahZt2aQl8TrFixW8ponaq1bDtcGewz3bUJp9hI4BYCw0StCL8CM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741535080; c=relaxed/simple;
	bh=8f+n48vQhAp88R0bRIGDF0A5tYd5644SJ0e8RL/SX7o=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=t09mLsNBFwVcQsUunRpUv391GnnmW828++K/Yax7Ag1Pp8V9yDqxOiY2IAblZjON+Pob/4gNOthJ6kSYafc1+5nxgFvH0VBGLlGoD7150AK+cz5Kfn8X82MmYMLFz8cW/hSs9AqVchJqS4FGeWd7/T2URqfUGVaccAfJBkz6NoY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=lREDcA1/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="lREDcA1/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 03BDEC4CEE3;
	Sun,  9 Mar 2025 15:44:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1741535080;
	bh=8f+n48vQhAp88R0bRIGDF0A5tYd5644SJ0e8RL/SX7o=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=lREDcA1/2953WuiOu+u7jh3NuaA+YAwHU/3x+2IhmZ9Sa5PautIeh3QFIaCLPPQq3
	 Ick6u8XfTGi2mMt7tttdI/fE/lbT7ZPNgrlVGfmJ0QOcVZQh+CKMUDtJ9WW6EaaHU6
	 9L7K8i5HX+txaT9upJN5qUbaFn9WXP5hbTyMcew4tNRHOyYyvV75pPjxS3B3siQ30n
	 +nxDS50CMd18uH/EXCQylPV9w23YQavDqaB5MZVQZxGunkDSbPFfbtZvrilkf0W6M9
	 LLBDlzkfyj0I2p4zeEPatTRu6w1WlmR7hP/ropQz+AWHK8yNGA0Ods+pFxt1cnNGyZ
	 iXuVoiK7OL4vQ==
Date: Sun, 9 Mar 2025 11:44:38 -0400
From: Mike Snitzer <snitzer@kernel.org>
To: Kent Overstreet <kent.overstreet@linux.dev>
Cc: dm-devel@lists.linux.dev, Mikulas Patocka <mpatocka@redhat.com>,
	Alasdair Kergon <agk@redhat.com>
Subject: Re: dm-flakey: Fix memory corruption
Message-ID: <Z823ZmamUoGO8P6I@kernel.org>
References: <20250308155011.1742461-1-kent.overstreet@linux.dev>
 <Z8yKMlhd-Z0sf6tG@kernel.org>
 <ij3pre7rlgez3ybsfrsj2i3ohoeb5ma5rgz3tfuv63h7rv6uoo@2hw6452r4qbn>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ij3pre7rlgez3ybsfrsj2i3ohoeb5ma5rgz3tfuv63h7rv6uoo@2hw6452r4qbn>

On Sat, Mar 08, 2025 at 04:50:05PM -0500, Kent Overstreet wrote:
> On Sat, Mar 08, 2025 at 01:19:30PM -0500, Mike Snitzer wrote:
> > On Sat, Mar 08, 2025 at 10:50:08AM -0500, Kent Overstreet wrote:
> > > So, this code clearly isn't getting tested - at all. Besides this bug,
> > > the parsing for the "corrupt" modes is also broken.
> > > 
> > > Guys, don't push broken crap, and figure out how to write some tests.
> > 
> > Thank you sir, may we have another?
> > 
> > Like you never introduced a bug in your life?
> > 
> > Not going to tolerate your entitled primadonna attitude here.  You are
> > capable of being better, you've chosen not to be on this issue (twice)
> 
> Talking about basic engineering standards is in no way "being a prima
> donna". Testing your changes is as basic as it gets, and this code
> wasn't tested _at all_.

"entitled primadonna attitude" was me pulling punches.

I don't disagree that this is a bug that was missed and that proper
testing hasn't been performed (I'd quibble with the no testing part
only because I cannot speak for Mikulas and don't like to assume I
know it all).

But you're missing the very problematic detail: you used a bug in an
optional feature of the test-only dm-flakey target to try to take a
pound of flesh while preaching from your high horse.  That is
unacceptable behaviour that won't be tolerated here.  Be cool and
others will be in return (unless you keep setting fire to bridges).

Fin.
