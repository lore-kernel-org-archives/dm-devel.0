Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1BF5C2F6922;
	Wed, 18 Mar 2026 17:01:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773853277; cv=none; b=hXdqthhY1yItyoWlHQGyPewvQHMlArV8yJOzpcn0QEEw6v7zYTI8/D12ZWLZIl00XojDNCp5TAzE2F7gh13iaa/HPDfV0iwqeH/u3hRNRhzWoa9qtbyhqx4TtBXHQdCBfgSQ3+zJMaYutFwclOp5UPEPMA7T0x+Hm0YcApwA+SQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773853277; c=relaxed/simple;
	bh=20mJmBB3SaecDG2JqcS0cOmUVcCOcH8rUNBLVK/9WkA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=lW2hntz4Azmj2zd1hN/SpOKR7bu6R221zBtfEYz+pxremZ/jJ9tVGx4cxplJBhKrEB10ayDeAlEU7Go9a5tdkZsDgxOJRo8zT+o9sNcQZcFbu/jrDuaPniGEeaPiaPY8yaxiZyjSHMqw33sU0ESbpejj9+EOdN9ytriihovzPGY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=eX/QisCZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="eX/QisCZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6E109C19421;
	Wed, 18 Mar 2026 17:01:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773853276;
	bh=20mJmBB3SaecDG2JqcS0cOmUVcCOcH8rUNBLVK/9WkA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=eX/QisCZrRpE/d5Dc1xM11OkaaMJn4aALE+kkYCvDJDdrrbiumQwP2xvyV8q2IGGt
	 4dslEHhu7XJFoSqEl8k8xIMDW32bICnbQmAsiBc5B98EOWIKdoscLzeEgBvA91bFoG
	 Z9/RcDOUrV3FgW504k5cj+an5iakkWOQeFlniswfy/0YJk6So7MWtDiQ2lgHtifH9o
	 6u2JH1zOQ/9745VSPHFwsYrnlN7NQwlY2KskVM68TVrvWD4MedNsCPle0cYa9UZ+jb
	 NewuyvahUMwcoaeUPEdSoEmI3lLqOodMB0z0RO9U1lUK1id0v2AYykSnFvZiWowA5S
	 H0vsC902OBWKg==
Date: Wed, 18 Mar 2026 11:01:14 -0600
From: Keith Busch <kbusch@kernel.org>
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: Keith Busch <kbusch@meta.com>, dm-devel@lists.linux.dev,
	linux-block@vger.kernel.org, snitzer@kernel.org
Subject: Re: [RESEND PATCHv3 2/2] dm-crypt: dynamic scatterlist for many
 segments
Message-ID: <abraWvuLlTjHF-9q@kbusch-mbp>
References: <20260316150229.1771884-1-kbusch@meta.com>
 <20260316150941.1813568-1-kbusch@meta.com>
 <08fbfa54-0e19-82b5-01ba-216a4202d2e5@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <08fbfa54-0e19-82b5-01ba-216a4202d2e5@redhat.com>

On Wed, Mar 18, 2026 at 05:34:47PM +0100, Mikulas Patocka wrote:
> On Mon, 16 Mar 2026, Keith Busch wrote:
> > +static int crypt_build_sgl(struct crypt_config *cc, struct scatterlist **psg,
> >  			   struct bvec_iter *iter, struct bio *bio,
> >  			   int max_segs)
> >  {
> >  	unsigned int bytes = cc->sector_size;
> > +	struct scatterlist *sg = *psg;
> >  	struct bvec_iter tmp = *iter;
> >  	int segs, i = 0;
> >  
> >  	bio_advance_iter(bio, &tmp, bytes);
> >  	segs = tmp.bi_idx - iter->bi_idx + !!tmp.bi_bvec_done;
> > -	if (segs > max_segs)
> > -		return -EIO;
> > +	if (segs > max_segs) {
> > +		sg = kmalloc_array(segs, sizeof(struct scatterlist), GFP_NOIO);
> > +		if (!sg)
> > +			return -ENOMEM;
> > +	}
> >  
> >  	sg_init_table(sg, segs);
> >  	do {
> 
> GFP_NOIO allocations may be unavailable when you are swapping to the 
> dm-crypt device and the machine runs out of memory temporarily. There 
> should be:
> 
> sg = kmalloc_array(segs, sizeof(struct scatterlist), GFP_NOWAIT | __GFP_NOMEMALLOC);
> 
> and if it fails, allocate "sg" from a mempool with GFP_NOIO (mempool_alloc 
> with GFP_NOIO can't fail, it waits until someone frees some entries into 
> the mempool).

Thanks for the suggestion, this sounds good. Just to note, the use case
for swap always writes out pages, so it's always aligned and would never
take this path. The use case in mind where this path could happen is
just for zero-copy direct io applications.

But even then, the only thing I know of that really wants this has an
offset that straddles two pages per block, so I never need more than 2
segments, and the inline scatterlist has four. There's just currently no
way for the block layer to report a max-segments-per-block limit, so I'm
including this patch to be consistent with the reportable limits.
