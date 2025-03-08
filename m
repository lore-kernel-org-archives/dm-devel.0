Received: from out-177.mta1.migadu.com (out-177.mta1.migadu.com [95.215.58.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 505A9192D68
	for <dm-devel@lists.linux.dev>; Sat,  8 Mar 2025 21:50:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741470614; cv=none; b=Hu48ExO4twlygzSDQHNPdYUomlaWGvBX2hanl4f58IoIVobeASOJkiMLyCQjmuaYj0+VRrcxpzx/zUqlVi/quKrlNVODdAXx5iZlVY5OqTsiok4cRFG8s7XcQisKoTuh3BTqsoxxphOp3AxxJVh1V/hZDkaOgYDr19fLlb+Cw0U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741470614; c=relaxed/simple;
	bh=r8t8wcN3sPsnTIIwhJvTzP9R8VF4WMOR0gea6kq8rRM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=WweX05zdLHIOmz7F5IzFu2isfurCOyC+BAEVvUFdxMh83yojDeetPCFnUImQWaDgNrgkM/sKTQa3NaKOwt9srLExRAo+LpTjZ7KuP0VWeOgrmVi0oFqaYY1JnSBs/RYFVqTQH+pwwIkwikcUQzcFU2XSX4vvxSpDjcwXUTnMEo4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=Bo2G+zzf; arc=none smtp.client-ip=95.215.58.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="Bo2G+zzf"
Date: Sat, 8 Mar 2025 16:50:05 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1741470609;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=B1Riqc2hKMfdgbBF8fpFOOSe6eBYlAqa80q1pjYJBEM=;
	b=Bo2G+zzfA3i3u0Ch1HuzwGqyFuty1d8TZabd4JUgDcCpDcAqxPCrRgEJr6P7b5ffvWy27z
	jYwFoZBfs+RnTKBp+R66PjyohXzeeb9230WKczaUYN6Ad6FPbZCVMfsQGebP5HdsB6Ycw8
	qT9j2shewSeg4OvlgWJQLb2Nqu/ulIw=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kent Overstreet <kent.overstreet@linux.dev>
To: Mike Snitzer <snitzer@kernel.org>
Cc: dm-devel@lists.linux.dev, Mikulas Patocka <mpatocka@redhat.com>, 
	Alasdair Kergon <agk@redhat.com>
Subject: Re: dm-flakey: Fix memory corruption
Message-ID: <ij3pre7rlgez3ybsfrsj2i3ohoeb5ma5rgz3tfuv63h7rv6uoo@2hw6452r4qbn>
References: <20250308155011.1742461-1-kent.overstreet@linux.dev>
 <Z8yKMlhd-Z0sf6tG@kernel.org>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Z8yKMlhd-Z0sf6tG@kernel.org>
X-Migadu-Flow: FLOW_OUT

On Sat, Mar 08, 2025 at 01:19:30PM -0500, Mike Snitzer wrote:
> On Sat, Mar 08, 2025 at 10:50:08AM -0500, Kent Overstreet wrote:
> > So, this code clearly isn't getting tested - at all. Besides this bug,
> > the parsing for the "corrupt" modes is also broken.
> > 
> > Guys, don't push broken crap, and figure out how to write some tests.
> 
> Thank you sir, may we have another?
> 
> Like you never introduced a bug in your life?
> 
> Not going to tolerate your entitled primadonna attitude here.  You are
> capable of being better, you've chosen not to be on this issue (twice)

Talking about basic engineering standards is in no way "being a prima
donna". Testing your changes is as basic as it gets, and this code
wasn't tested _at all_.
