Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 365D939903C
	for <dm-devel@lists.linux.dev>; Tue, 24 Feb 2026 14:03:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771941799; cv=none; b=LT6DT0YpPEBq75xbm2ieiMz1WEPjzHadWnkyir7rqIK+oOykVDJOWQue6R2uidAwevDboNtiep3EvC/3YflAFn6SLJ1RUD8s76wdTcaL75bdHiLeiNxvo5fAMUhSk6m/B6a4RVbrqo8+jhbW/Elbp+FBfy3tVyjgnRLO6MkyWm8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771941799; c=relaxed/simple;
	bh=3ScI8KESTTAEAW5laz0VrxT1UjHicVx789xOAf1YCHc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=JGItqfNsrg6rYSCst/LqJb92tLPIGJGQuse7eTRP/urykfeaWj+9l6E0/lC/DLzXdykPc8KX6SbBUoLlXy3ez10HaazWMot7pIv5KNeUSIIMxgJ8X/hxZ9wxG7FiD48hTQAnaNjKPmbHIdcolUNvwyu3SrxZa/Sm2W/Dii3/ShQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=mvBU86ky; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="mvBU86ky"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=XgaqhpWFYGvROue4gL/TfoePBW3Q9dTD+bwqL6WL7RM=; b=mvBU86ky7lcd6I5HRE6fGvlYXJ
	uwBfVXfU5HIZuac/qboBp11jZkMJwtoEOsB5UP/9IC7UeHSvym5KoL7DGmOoZZhtSOSSoFbfc/UOc
	ToSEnISXcBFvarBZCGLFzZU07L0IqUOqIVTsB3DSwui1xXhb7yTEbpt0SfC+5Cv1DiQb/LZelx8W2
	/uJGEl4W5I/CXwx/E5qUcSpKUEBBHsyB7NZZyoHOJKjCNrEgGlFnxitvXO4EDty5jBl6MXKtLlJJ8
	o74PfH29QMfgyEc79fLI4lcPCOlYkCVqg3lkXNJ8D9hHD1Mfonx/i+Sm9gxfKQibqMpT8juPeGEOT
	G+fLUUIA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vut0L-00000002AsL-3V9s;
	Tue, 24 Feb 2026 14:03:13 +0000
Date: Tue, 24 Feb 2026 06:03:13 -0800
From: Christoph Hellwig <hch@infradead.org>
To: Michal Hocko <mhocko@suse.com>
Cc: Uladzislau Rezki <urezki@gmail.com>,
	Mikulas Patocka <mpatocka@redhat.com>,
	"Vishal Moola (Oracle)" <vishal.moola@gmail.com>,
	Christoph Hellwig <hch@infradead.org>,
	SeongJae Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>, zkabelac@redhat.com,
	Matthew Sakai <msakai@redhat.com>, linux-mm@kvack.org,
	dm-devel@lists.linux.dev
Subject: Re: [PATCH] mm: allow __GFP_RETRY_MAYFAIL in vmalloc
Message-ID: <aZ2voRA5VJytcfLp@infradead.org>
References: <ff48283b-be21-7f9a-d616-e303a4a1ebe6@redhat.com>
 <aZykWyxLy34o7PKr@fedora>
 <32bd9bed-a939-69c4-696d-f7f9a5fe31d8@redhat.com>
 <aZzPwsBp-Z4XM58U@tiehlicka>
 <aZ2N9a4XgxnurOhz@pc636>
 <aZ2YDD_l5JN78DJC@tiehlicka>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aZ2YDD_l5JN78DJC@tiehlicka>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Tue, Feb 24, 2026 at 01:22:36PM +0100, Michal Hocko wrote:
> One thing that we could do to improve __GFP_RETRY_MAYFAIL resp.
> __GFP_NORETRY is to use NOWAIT allocation semantic for page table
> allocations as those could be achieved by scoped allocation context.
> This could cause pre-mature failure after the whole bunch of memory has
> already been allocated for the backing pages but considering that page
> table allocations should be more and more rare over system runtime it
> might be just a reasonable workaround. WDYT?

Why bother?  __GFP_RETRY_MAYFAIL has pretty lose semantics.  Trying
too hard to allocate PTEs is not breaking the overall concept.

