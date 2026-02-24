Received: from out-179.mta1.migadu.com (out-179.mta1.migadu.com [95.215.58.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC5183A0B20
	for <dm-devel@lists.linux.dev>; Tue, 24 Feb 2026 14:22:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771942953; cv=none; b=VpRElNoIhJQcszaBg88dx+4DWAnxaNe8MpqyzA1KbWbZhV96Thv18+QvhjFKUDL9l2S0UJx6h0Msi7AORQSy4NcrYyWSfA3gQ20/S7sgCzcRCaBDymAkKtrGbsEgJ8Q+/4XKaw3ZuN17lvPSoEepKkfDPwKjGMyraO8jxgjRn+k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771942953; c=relaxed/simple;
	bh=LVmxVYyNWfNKgW3OAoq7kt9FUm3BrnfaS2eKZMg96zY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=VYZ246VPBws45Ggi2AqcGm7GxJIzkNXQKuCR3hLz9mZRHSsmhtCWhqi7/omf5AJ5PwnA0SKuVlHihAU9nkTa6Ad9/jVtwBdd8TDg5LY5x++9mXbvPSPR1GaxKVsiUoSCBA4KSu5ivI4qbpKqfXNuXw94cChktIv1w6L33TFgr60=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=DSXljtQ7; arc=none smtp.client-ip=95.215.58.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="DSXljtQ7"
Date: Tue, 24 Feb 2026 06:22:15 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1771942949;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=NSb31zFXmK9huknQhI+p55nBi97KODseWc5XOPajHSo=;
	b=DSXljtQ7lsBTnmwjZ18REZE2xI7apciPNHdp8TJGqD3fiGLjl/CTpFIZ6tSdMr8d2YNRdy
	KjurZzBJDehgCTdqfTjvi0+nyK6n80lcuGVLkkyKIqwHYrByfUBb+61f/QFl+VluET0f5r
	RRgzpvV7/vJnbd4ycQBLGqIS1guzdt4=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Christoph Hellwig <hch@infradead.org>
Cc: Michal Hocko <mhocko@suse.com>, Uladzislau Rezki <urezki@gmail.com>, 
	Mikulas Patocka <mpatocka@redhat.com>, "Vishal Moola (Oracle)" <vishal.moola@gmail.com>, 
	SeongJae Park <sj@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, zkabelac@redhat.com, 
	Matthew Sakai <msakai@redhat.com>, linux-mm@kvack.org, dm-devel@lists.linux.dev
Subject: Re: [PATCH] mm: allow __GFP_RETRY_MAYFAIL in vmalloc
Message-ID: <aZ2zPzyoFUUNWdJ7@linux.dev>
References: <ff48283b-be21-7f9a-d616-e303a4a1ebe6@redhat.com>
 <aZykWyxLy34o7PKr@fedora>
 <32bd9bed-a939-69c4-696d-f7f9a5fe31d8@redhat.com>
 <aZzPwsBp-Z4XM58U@tiehlicka>
 <aZ2N9a4XgxnurOhz@pc636>
 <aZ2YDD_l5JN78DJC@tiehlicka>
 <aZ2voRA5VJytcfLp@infradead.org>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aZ2voRA5VJytcfLp@infradead.org>
X-Migadu-Flow: FLOW_OUT

On Tue, Feb 24, 2026 at 06:03:13AM -0800, Christoph Hellwig wrote:
> On Tue, Feb 24, 2026 at 01:22:36PM +0100, Michal Hocko wrote:
> > One thing that we could do to improve __GFP_RETRY_MAYFAIL resp.
> > __GFP_NORETRY is to use NOWAIT allocation semantic for page table
> > allocations as those could be achieved by scoped allocation context.
> > This could cause pre-mature failure after the whole bunch of memory has
> > already been allocated for the backing pages but considering that page
> > table allocations should be more and more rare over system runtime it
> > might be just a reasonable workaround. WDYT?
> 
> Why bother?  __GFP_RETRY_MAYFAIL has pretty lose semantics.  Trying
> too hard to allocate PTEs is not breaking the overall concept.
> 

One thing __GFP_RETRY_MAYFAIL is very clear about is to not trigger the
oom-killer which is not the case for GFP_KERNEL. There are users who explicitly
use __GFP_RETRY_MAYFAIL to avoid oom-killer.

Mikulas, is that the reason you are using __GFP_RETRY_MAYFAIL in your use-case?
