Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C45CB1F76D7;
	Fri, 17 Jan 2025 07:57:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737100634; cv=none; b=st3dk7nKBSH+235x2Xsd8Gxfe1Nu3kcaWtxqkBnA9cz+PEn4XcxljL5G/5iUy/22oDBL8bmGPijVeFBvcjgzLCpGK8xBeCJ2geEloKpgG2NLkQ/vsq87UBju5bYilFUJhaMnYr+zu8GoSvYQ7IPOvB1es/irA0h+wtM9OfESyWQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737100634; c=relaxed/simple;
	bh=wlpygHBdUEFdrG/g8scTqCu83NlxtOJlFG+4iNHfyJ4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ESl5z+qWT2te3Gm1w81ama5YHLCLb/0rFWVF9qKQb35W6OeUi0M0bC2UuTYvG09/vVSDs6RVClCGDR5mPGGlGfFC30/N/xJy+QwdM0FNJmDT8VsbEiZu+xjSvDzt5WzG17YnHBdL28F8gJgwBoWHVv5IPH3FssZH3oHhPOsPBKc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=FgVaX9ZH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="FgVaX9ZH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 109C9C4CEDD;
	Fri, 17 Jan 2025 07:57:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1737100634;
	bh=wlpygHBdUEFdrG/g8scTqCu83NlxtOJlFG+4iNHfyJ4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=FgVaX9ZHhoLn/8O2T9v/cdmBVl+l8UPLm92hODkA8SqN87OYslFmiOPTk4L6pWktP
	 Mu5bW0PvLXGPegXzfIAJ0sAA4Gwuv9bSeAdjvHK32Es/GoSOvbeEaRtOAtQuTW4hlc
	 DDo0twxpct+WTp4GW2TcLgSJsQJO2nDa5/z4bm5IzlS0FNacvDsrfZ5HVY8NRdpOed
	 3uCRLD383myhTTv9hG1o2I4Uu+j/E/e7E9itYRTm0a5+Xyf/CDob5TTWva+pN02GOv
	 gR4q7so3PSP3beQC2DeOLb//HCrvit2P1DwfIkW9bwKz4NaHT65E2Ua7ayFDt101pT
	 52xL5NqMt6SCw==
Date: Thu, 16 Jan 2025 23:57:12 -0800
From: Eric Biggers <ebiggers@kernel.org>
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Harald Freudenberger <freude@linux.ibm.com>, mpatocka@redhat.com,
	agk@redhat.com, snitzer@kernel.org, ifranzki@linux.ibm.com,
	linux-s390@vger.kernel.org, dm-devel@lists.linux.dev,
	dengler@linux.ibm.com
Subject: Re: [PATCH v1 1/1] dm-integrity: Implement asynch digest support
Message-ID: <20250117075712.GA46042@sol.localdomain>
References: <20250115164657.84650-1-freude@linux.ibm.com>
 <20250115164657.84650-2-freude@linux.ibm.com>
 <20250115173736.GA3712753@google.com>
 <85ea487d37ec320ec5707bd249352b02@linux.ibm.com>
 <20250116080324.GA3910@sol.localdomain>
 <94e11912f1e1413ac2d13c7e5dc0ed35@linux.ibm.com>
 <Z4jNmdb4Bacom3-j@gondor.apana.org.au>
 <20250116175451.GA3772706@google.com>
 <Z4n238ML4fdFsFAw@gondor.apana.org.au>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Z4n238ML4fdFsFAw@gondor.apana.org.au>

On Fri, Jan 17, 2025 at 02:21:19PM +0800, Herbert Xu wrote:
> On Thu, Jan 16, 2025 at 05:54:51PM +0000, Eric Biggers wrote:
> >
> > But in practice it's the opposite.  Making it an ahash forces users who would
> > otherwise just be using shash to use ahash instead.
> 
> I think that's a good thing.  shash was a mistake and I intend to
> get rid of it.

I intend to keep using it, as it's a much better API.  Even if virtual address
support were to be added to ahash, shash will still be a simpler interface that
does not require dynamically allocated per-request memory.

> If it was possible to shoehorn phmac/paes into a synchronous
> algorithm I'd love to do it.  But the fact is that this requires
> asynchronous communication in the *unlikely* case which means
> that the best way to model is with an optional async interface.
> 
> 	if (unlikely(crypto_ahash_op(...) == -EINPROGRESS))
> 		do async
> 	else
> 		op completed synchronously

Of course it's possible for it to be a synchronous algorithm.  The proposed user
waits synchronously for the request to complete anyway.

> 
> > That won't solve all the problems with ahash, for example the per-request
> > allocation.  We'll still end up with something that is worse for 99% of users,
> > while also doing a very poor job supporting the 1% (even assuming it's 1% and
> > not 0% which it very well might be) who actually think they want off-CPU
> > hardware crypto acceleration.  Not to mention the nonsense like having
> > "synchronous asynchronous hashes".
> 
> I disagree.  I want the users to start feeding ahash with more
> than one unit of input.  So rather than splitting up a folio
> into page-size or sector-size units, you feed the whole thing
> to ahash and the data should be split up automatically and hashed
> in parallel.

That sort of fits the {dm,fs}-verity use case specifically, but it seems like a
weird hack to avoid the simpler approach that I proposed, and it would introduce
unnecessary restrictions like the input data would have to be a folio.

> > The primary API needs to be designed around and optimized for software crypto,
> > which is what nearly everyone wants.
> 
> I agree with that completely.

Yet you continue to push for APIs that are hard to use and slow because they are
designed for an obsolete form of hardware offload and have software crypto
support bolted on as an afterthought.

> However, what triggered this thread is in fact something that is not purely
> software crypto because it involves system-wide communication which could take
> seconds to complete.

Sure, but it's possible for it to use the same API.

> The original patch tried to shoehorn this into a synchronous implementation
> that would just fail randomly after waiting.

The async version has that same timeout, so the effect is exactly the same; the
hash operation can fail after a few seconds of waiting.

- Eric
