Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E221381AA;
	Thu, 16 Jan 2025 08:03:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737014608; cv=none; b=mGyCnDktO1FFyfhuy+u5ZkcWYINysbI1uFaj+7KwZ6+vZSxDQEelg6irXldtUERzv37TXsF1umRzL03QlXPvHvV+hdYhVQ1bIhyXztxUYYFXYDo/wz56BIG/f6f5qEllMYlbgNu0nKTmrAJDUgxiY40zVPSSxZOhFnslmpZe4ZU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737014608; c=relaxed/simple;
	bh=1iSg3yTdztfZBPQGGQo4Uhv9RbrtBxtxVePVd7qGBuk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=L8m1a3q/DSoHoCys+U9zWf3YWtWToZsXDf6zssACTJ1AUW+b06XEWyzJdaM2rhzOg7lyIXE5gZ0ydsYAOWW1GioQ9fJ8j5bsYslSfYhFMfIklnPwwP9ZQDaVHpxO0IQPqDJX9dca1MwQjUDUeokrBc7b6i3NvaJzsAr3puwKkTc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=TrX3gn5d; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="TrX3gn5d"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9EB40C4CED6;
	Thu, 16 Jan 2025 08:03:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1737014605;
	bh=1iSg3yTdztfZBPQGGQo4Uhv9RbrtBxtxVePVd7qGBuk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=TrX3gn5d848i0cPEr26UZlwdHN74ytj6007E7eU8YLGQirFC2ZWk8puN8SabDotrS
	 sWUQc6mqp340/OORAQB6evcRejXaYJhek1m4KBVFDOAr+Ez6IX+RSjKs5+xrWMlhXR
	 7gBJnJmlxYkrOBwxr+9hsK9gcqjJL5ClIU1pkmdnFjsy+GMCW2hheMWpFE7Zk8JRHe
	 pt6O3mclwft7Sc5u/zcXLFHdONt0lVU66zXAzIznRrcdiN8HyW3D5FjvE1d6sA+nOk
	 4nT1jrNYgDaqPXEu0iDlClVc6TpEm4bMLb4KSk5lsj+IgXaLpWI7Dmcz2Ai9OzFKAF
	 Vk2EpNQFrvM0Q==
Date: Thu, 16 Jan 2025 00:03:24 -0800
From: Eric Biggers <ebiggers@kernel.org>
To: Harald Freudenberger <freude@linux.ibm.com>
Cc: mpatocka@redhat.com, agk@redhat.com, snitzer@kernel.org,
	ifranzki@linux.ibm.com, linux-s390@vger.kernel.org,
	dm-devel@lists.linux.dev, herbert@gondor.apana.org.au,
	dengler@linux.ibm.com
Subject: Re: [PATCH v1 1/1] dm-integrity: Implement asynch digest support
Message-ID: <20250116080324.GA3910@sol.localdomain>
References: <20250115164657.84650-1-freude@linux.ibm.com>
 <20250115164657.84650-2-freude@linux.ibm.com>
 <20250115173736.GA3712753@google.com>
 <85ea487d37ec320ec5707bd249352b02@linux.ibm.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <85ea487d37ec320ec5707bd249352b02@linux.ibm.com>

On Thu, Jan 16, 2025 at 08:33:46AM +0100, Harald Freudenberger wrote:
> On 2025-01-15 18:37, Eric Biggers wrote:
> > On Wed, Jan 15, 2025 at 05:46:57PM +0100, Harald Freudenberger wrote:
> > > Use the async digest in-kernel crypto API instead of the
> > > synchronous digest API. This has the advantage of being able
> > > to use synchronous as well as asynchronous digest implementations
> > > as the in-kernel API has an automatic wrapping mechanism
> > > to provide all synchronous digests via the asynch API.
> > > 
> > > Tested with crc32, sha256, hmac-sha256 and the s390 specific
> > > implementations for hmac-sha256 and protected key phmac-sha256.
> > > 
> > > Signed-off-by: Harald Freudenberger <freude@linux.ibm.com>
> > 
> > As Mikulas mentioned, this reduces performance for everyone else, which
> > is not
> > great.  It also makes the code more complicated.
> > 
> > I also see that you aren't actually using the algorithm in an async
> > manner, but
> > rather waiting for it synchronously each time.  Thus the ability to
> > operate
> > asynchronously provides no benefit in this case, and this change is
> > purely about
> > allowing a particular driver to be used, presumably the s390 phmac one
> > from your
> > recent patchset.  Since s390 phmac seems to be new code, and furthermore
> > it is
> > CPU-based and thus uses virtual addresses (which makes the use of
> > scatterlists
> > entirely pointless), wouldn't it be easier to just make it implement
> > shash
> > instead of ahash, moving any wait that may be necessary into the driver
> > itself?
> > 
> > - Eric
> 
> Thanks for this feedback. I'll give it a try with some performance
> measurements.
> And I totally agree that a synchronous implementation of phmac whould have
> solved
> this also. But maybe you can see that this is not an option according to
> Herbert Xu's feedback about my first posts with implementing phmac as an
> shash.
> The thing is that we have to derive a hardware based key (pkey) from the
> given key material and that may be a sleeping call which a shash must not
> invoke.
> So finally the phmac implementation is now an ahash digest implementation
> as suggested by Herbert.
> 
> You are right, my patch is not really asynchronous. Or at least waiting for
> completion at the end of each function. However, opposed to the ahash
> invocation
> where there have been some update() calls this is now done in just one
> digest()
> giving the backing algorithm a chance to hash all this in one step (well it
> still
> needs to walk the scatterlist).
> 
> Is there a way to have dm-integrity accept both, a ahash() or a shash()
> digest?
> 

To properly support async algorithms, the users (e.g. dm-integrity and
dm-verity) really would need to have separate code paths anyway.  The
computation models are just too different.

But in this case, it seems you simply want it to be synchronous and use virtual
addresses.  The quirks of ahash, including its need for per-request allocations
and scatterlists, make it a poor match here.  The only thing you are getting
with it is, ironically, that it allows you to wait synchronously.  That could be
done with shash too if it was fixed to support algorithms that aren't atomic.
E.g. there could be a new CRYPTO_ALG_MAY_SLEEP flag that could be set in struct
shash_alg to indicate that the algorithm doesn't support atomic context, and a
flag could be passed to crypto_alloc_shash() to allow such an algorithm to be
selected (if the particular user never uses it in atomic context).

That would be faster and simpler than the proposed ahash based version.

- Eric
