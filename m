Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E5B45134A8
	for <dm-devel@lists.linux.dev>; Thu, 23 May 2024 15:44:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716479083; cv=none; b=cn9MSb7MgIBYLjvHMco+9DbhhGUaf/99XTv6F12o9eUooAq4Sec9E3uTVI93G+Sy4e3EAFaJkMpHqBqC+9mdZqty3nfztXHNtMGHG3F5h0gYurWXanFh0yKomblWiIieFtduQcHPq2KxRqnGWzZ1xVCcdZhc8y23/XBsvUznMh0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716479083; c=relaxed/simple;
	bh=iopavRPbhnH+EHMJrXECqzF9kHqjZsi99nb9brY79SM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=lO5K5HQXyz9xmphHeYdDpbRdOuQjpuRuOn66LTnSUZFNQZK/1raiH6FPPF9Uvfesl94aEn8aC1L4TDeE72zK7RGV64Rm7EHDzRumG8tfbCuXfVM/NpG/bMrAEmf76Bi9B2QAl5+NYRmuMvnQLRcg/A0JYIRHmtooygULIEbZL5s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 10CE568BFE; Thu, 23 May 2024 17:44:36 +0200 (CEST)
Date: Thu, 23 May 2024 17:44:35 +0200
From: Christoph Hellwig <hch@lst.de>
To: Mike Snitzer <snitzer@kernel.org>
Cc: Ming Lei <ming.lei@redhat.com>, Christoph Hellwig <hch@lst.de>,
	axboe@kernel.dk, dm-devel@lists.linux.dev,
	linux-block@vger.kernel.org, Marco Patalano <mpatalan@redhat.com>,
	Ewan Milne <emilne@redhat.com>, linux-raid@vger.kernel.org
Subject: Re: [PATCH for-6.10-rc1] block: fix blk_validate_limits() to
 properly handle stacked devices
Message-ID: <20240523154435.GA1783@lst.de>
References: <20240522025117.75568-1-snitzer@kernel.org> <20240522142458.GB7502@lst.de> <Zk4h-6f2M0XmraJV@kernel.org> <Zk6haNVa5JXxlOf1@fedora> <Zk9i7V2GRoHxBPRu@kernel.org>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Zk9i7V2GRoHxBPRu@kernel.org>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Thu, May 23, 2024 at 11:38:21AM -0400, Mike Snitzer wrote:
> Sure, we could elevate it to blk_validate_limits (and callers) but
> adding a 'stacking' parameter is more intrusive on an API level.
> 
> Best to just update blk_set_stacking_limits() to set a new 'stacking'
> flag in struct queue_limits, and update blk_stack_limits() to stack
> that flag up.
> 
> I've verified this commit to work and have staged it in linux-next via
> linux-dm.git's 'for-next', see:
> 
> https://git.kernel.org/pub/scm/linux/kernel/git/device-mapper/linux-dm.git/commit/?h=for-next&id=cedc03d697ff255dd5b600146521434e2e921815
> 
> Jens (and obviously: Christoph, Ming and others), I'm happy to send
> this to Linus tomorrow morning if you could please provide your
> Reviewed-by or Acked-by.  I'd prefer to keep the intermediate DM fix
> just to "show the work and testing".

A stacking flag in the limits is fundamentally wrong, please don't
do this.
