Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 35C0676F17
	for <dm-devel@lists.linux.dev>; Thu, 23 May 2024 17:03:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716483812; cv=none; b=evRTaHzunCwmxtTgiSNNu9IaHHRLB6qrWf3K6GuNVwbpG2c73zts87zO0GoixyqlOtpSxEvm9VISbvW8wqC0LxQyV+/cZ6jLRZFznGD/CuCGuMe5SSi/1GucMPoNzAzmIHO49tpYXVpZYm+6UXLi6Z9xUfNZ74Bth8z4eM/tCEY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716483812; c=relaxed/simple;
	bh=JxsPNVkNP0IRxvAPam/kmjAtO5iImvGIa515q7AmfiY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=dW24XliIxwsvwpmdyQ+HLs7DFPtdrZZ7LMYxHfesgEAiSwnKHMIv+qYK78rasPKcXp0NjkAgPMbS4/TEK/m6MKMiqtuZHZ7Ke5ieRfxIS2hlxnQFefUqVd9GW2/uvpGWmjk2sLZXWPb2W+OKu/SlGL1YxXZjFYh7J9A5/NwDGBo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id AC47568BFE; Thu, 23 May 2024 19:03:25 +0200 (CEST)
Date: Thu, 23 May 2024 19:03:25 +0200
From: Christoph Hellwig <hch@lst.de>
To: Mike Snitzer <snitzer@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, dm-devel@lists.linux.dev,
	linux-block@vger.kernel.org, Marco Patalano <mpatalan@redhat.com>,
	Ewan Milne <emilne@redhat.com>
Subject: Re: dm: retain stacked max_sectors when setting queue_limits
Message-ID: <20240523170325.GA5736@lst.de>
References: <20240522025117.75568-1-snitzer@kernel.org> <20240522142458.GB7502@lst.de> <Zk4h-6f2M0XmraJV@kernel.org> <20240523082731.GA3010@lst.de> <Zk9OyGTESlHXu6Wa@kernel.org> <20240523144938.GA30227@lst.de> <Zk9kRYgwhu49c8YY@kernel.org> <20240523155009.GB1783@lst.de> <Zk9yVfZ8TEeEQJbw@kernel.org>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Zk9yVfZ8TEeEQJbw@kernel.org>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Thu, May 23, 2024 at 12:44:05PM -0400, Mike Snitzer wrote:
> This "works" but it doesn't safeguard blk_stack_limits() and
> blk_validate_limits() from other drivers that weren't trained to
> (ab)use max_user_sectors to get blk_validate_limits() to preserve the
> underlying device's max_sectors.

It does in that sd/sr are the only remaining places directly setting
queue limits without the commit API.  And I am working on converting
them for 6.11.

