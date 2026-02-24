Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9385339E18A
	for <dm-devel@lists.linux.dev>; Tue, 24 Feb 2026 14:26:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771943207; cv=none; b=GpeFSps5BV1GgDZ/dLP6f1Clrh6+dAv2bSAuFWrC8UxlqFswnlV7a/Xbh0flBeN5pfpoGoxG2J7kKAV/qVBedOQjEvMoeXuByN6DcMI3CW2iSxww6wQfRwjJa17NCZvS8pi1TuJx+fUHkXSTGesK07iPtVYd3Peg6NLtW61VCKo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771943207; c=relaxed/simple;
	bh=MRrZ7iIqm5mO4NKC6/Jt4jMAoNQ3ya+ZciBkJN400Sk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=EEK2rzU576uTEPPtxI1FdIcilWPQ4Vy1cVoLxguY3ymQ+orQPxx+zKs+2mCl177lu1axR+RFpG9WfpitVTuHiPPgM1/APNCDcOUEMKyy5O9nPd0SSWxnHXzVpVj9haKW9BPFGmjxTIrEUCLWRaa12QjlqrcS6Sf7QKR5btp7PwI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=0RTj2x4H; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="0RTj2x4H"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=hvbaCOtedkXc45t9+1HNJ5IrJX/bSLKiSUSZ8gJ1fA8=; b=0RTj2x4HDWwZaKTb1l/nq/X/hr
	a9T4CYtWZQ4vQP+mj1ZXkk/jjw4MxLE/TplYyPeKNPxhffCFWcvT1e3Hdr/PsNfpLRd680vB05Lhg
	RrTeu6/waJwF7KARU0WA85jGm9Yey6TNxTTfTKYggHHqmwesayGhdRdSVP4FARjgxmJTVStgaf8uH
	9SCQ0DwbUDF/YyBsE1LOThGKBGXoDgc6n9XqZ6lQ8okI+wZzUXQlQ2IQ7BcUqOWhK6KMiZkb5JSVw
	x5q4SnhWbdDB5qVNhHR5DIcV3oUHw/tt4AeTNekQrErba4e9xNv5QvN70gfNxybFa1eVlcwhZzpQB
	/h8YKi5Q==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vutN5-00000002ChY-00IX;
	Tue, 24 Feb 2026 14:26:43 +0000
Date: Tue, 24 Feb 2026 06:26:42 -0800
From: Christoph Hellwig <hch@infradead.org>
To: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Christoph Hellwig <hch@infradead.org>, Michal Hocko <mhocko@suse.com>,
	Uladzislau Rezki <urezki@gmail.com>,
	Mikulas Patocka <mpatocka@redhat.com>,
	"Vishal Moola (Oracle)" <vishal.moola@gmail.com>,
	SeongJae Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>, zkabelac@redhat.com,
	Matthew Sakai <msakai@redhat.com>, linux-mm@kvack.org,
	dm-devel@lists.linux.dev
Subject: Re: [PATCH] mm: allow __GFP_RETRY_MAYFAIL in vmalloc
Message-ID: <aZ21Ij0hT6VyDg_J@infradead.org>
References: <ff48283b-be21-7f9a-d616-e303a4a1ebe6@redhat.com>
 <aZykWyxLy34o7PKr@fedora>
 <32bd9bed-a939-69c4-696d-f7f9a5fe31d8@redhat.com>
 <aZzPwsBp-Z4XM58U@tiehlicka>
 <aZ2N9a4XgxnurOhz@pc636>
 <aZ2YDD_l5JN78DJC@tiehlicka>
 <aZ2voRA5VJytcfLp@infradead.org>
 <aZ2zPzyoFUUNWdJ7@linux.dev>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aZ2zPzyoFUUNWdJ7@linux.dev>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Tue, Feb 24, 2026 at 06:22:15AM -0800, Shakeel Butt wrote:
> > Why bother?  __GFP_RETRY_MAYFAIL has pretty lose semantics.  Trying
> > too hard to allocate PTEs is not breaking the overall concept.
> > 
> 
> One thing __GFP_RETRY_MAYFAIL is very clear about is to not trigger the
> oom-killer which is not the case for GFP_KERNEL. There are users who explicitly
> use __GFP_RETRY_MAYFAIL to avoid oom-killer.

That is a good point.  Compared to other options documenting that it
might would still seem like the best option after just not using
__GFP_RETRY_MAYFAIL with vmalloc.

