Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E17641A5BAA
	for <dm-devel@lists.linux.dev>; Fri,  4 Apr 2025 09:27:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743758867; cv=none; b=Ad5q7ksHEHgpK0JzZGtnS2h6D7VnhBc4Rm+IfHzPiNy4FM9j8cf6QcrwOSA71o0+M6K+XhwRsqYFF7l1J/sX3zvAwMhjQUwcVHI386t1b8FHLwf2XRHwJi/8HdlGAELN+cNF7XGDdXFfbARg3ghEpZByewe+paE6NWxgYtoRc8s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743758867; c=relaxed/simple;
	bh=aAD5iFrq3/jJIUHExCWlYV/HCg1lmL3zH3x/zCqIb2A=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=hu3RVG9PThV/np2QsB4PX8pPU8ywotSk3zCWkWtcWZ+DVqXEFFI0BSnEDHM0pGL3oS01q/09s3PAL7C2FOP7yFul4q/kXEXoQpCqT/xo5Ag8L2rstlWBRZqpVTHj/sF/sAzFH/GmDF0yfuqPf1hxOj0xJ8K1DWM2tKuvQgxlUCc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 1635B68B05; Fri,  4 Apr 2025 11:27:40 +0200 (CEST)
Date: Fri, 4 Apr 2025 11:27:39 +0200
From: Christoph Hellwig <hch@lst.de>
To: Yu Kuai <yukuai1@huaweicloud.com>
Cc: hch@lst.de, xni@redhat.com, colyli@kernel.org, axboe@kernel.dk,
	agk@redhat.com, snitzer@kernel.org, mpatocka@redhat.com,
	song@kernel.org, yukuai3@huawei.com, linux-block@vger.kernel.org,
	linux-kernel@vger.kernel.org, dm-devel@lists.linux.dev,
	linux-raid@vger.kernel.org, yi.zhang@huawei.com,
	yangerkun@huawei.com
Subject: Re: [PATCH RFC v2 00/14] md: introduce a new lockless bitmap
Message-ID: <20250404092739.GA14046@lst.de>
References: <20250328060853.4124527-1-yukuai1@huaweicloud.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250328060853.4124527-1-yukuai1@huaweicloud.com>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Fri, Mar 28, 2025 at 02:08:39PM +0800, Yu Kuai wrote:
> 1) user must apply the following mdadm patch, and then llbitmap can be
> enabled by --bitmap=lockless
> https://lore.kernel.org/all/20250327134853.1069356-1-yukuai1@huaweicloud.com/
> 2) this set is cooked on the top of my other set:
> https://lore.kernel.org/all/20250219083456.941760-1-yukuai1@huaweicloud.com/

I tried to create a tree to review the entire thing but failed.  Can you
please also provide a working git branch?

