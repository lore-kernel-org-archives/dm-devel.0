Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6ADAC2528FC
	for <dm-devel@lists.linux.dev>; Wed,  9 Apr 2025 08:32:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744187541; cv=none; b=laKTeJnexfkoK++DIdvGHLHyB+xLRfCkcogBXdZHT1PHRQ6YXB0vNa7JS8coyWCeT8MkT80LuNzgsQR4KeE8ETvLv0Ys33gzyfWzoy/y3RQEgUBIoW5P1dYCCRUWg6t6KQUyiBgeRIeQwx+lb2MnfLlHslhURKsBb4Ovn0DmKaU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744187541; c=relaxed/simple;
	bh=imr/R0IdKcYs+VVd894mjJLrbqrM/WWrz2d60Bnn7YU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=N1V8tNbiJdJnaMlYBJsjdLaXlll/sScpyqJR40bJ/5d888nagEibfeJfDJJVKHlK7ueycec5OZS2yk3PlpGB9oKLpZoQ4MeJHoJ9KL7DFlRWSI+JQRXIkXGOGsJi+1/Ivt738w6PRylG1wKS+UX9hQACBRlO+AxDOTyqt307DTI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 201A168AA6; Wed,  9 Apr 2025 10:32:09 +0200 (CEST)
Date: Wed, 9 Apr 2025 10:32:08 +0200
From: Christoph Hellwig <hch@lst.de>
To: Yu Kuai <yukuai1@huaweicloud.com>
Cc: xni@redhat.com, colyli@kernel.org, axboe@kernel.dk, agk@redhat.com,
	snitzer@kernel.org, mpatocka@redhat.com, song@kernel.org,
	linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
	dm-devel@lists.linux.dev, linux-raid@vger.kernel.org,
	yi.zhang@huawei.com, yangerkun@huawei.com,
	"yukuai (C)" <yukuai3@huawei.com>, kbusch@kernel.org
Subject: Re: [PATCH RFC v2 00/14] md: introduce a new lockless bitmap
Message-ID: <20250409083208.GA2326@lst.de>
References: <20250328060853.4124527-1-yukuai1@huaweicloud.com> <Z-aCzTWXzFWe4oxU@infradead.org> <c6c608e2-23e7-486f-100a-d1fb6cfff4f2@huaweicloud.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c6c608e2-23e7-486f-100a-d1fb6cfff4f2@huaweicloud.com>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Sat, Mar 29, 2025 at 09:11:13AM +0800, Yu Kuai wrote:
> The purpose here is to hide the low level bitmap IO implementation to
> the API disk->submit_bio(), and the bitmap IO can be converted to buffer
> IO to the bdev_file. This is the easiest way that I can think of to
> resue the pagecache, with natural ability for dirty page writeback. I do
> think about creating a new anon file and implement a new
> file_operations, this will be much more complicated.

I've started looking at this a bit now, sorry for the delay.

As far as I can see you use the bitmap file just so that you have your
own struct address_space and thus page cache instance and then call
read_mapping_page and filemap_write_and_wait_range on it right?

For that you'd be much better of just creating your own trivial
file_system_type with an inode fully controlled by your driver
that has a trivial set of address_space ops instead of oddly
mixing with the block layer.

Note that either way I'm not sure using the page cache here is an
all that good idea, as we're at the bottom of the I/O stack and
thus memory allocations can very easily deadlock.

What speaks against using your own folios explicitly allocated at
probe time and then just doing manual submit_bio on that?  That's
probably not much more code but a lot more robust.

Also a high level note: the bitmap_operations aren't a very nice
interface.  A lot of methods are empty and should just be called
conditionally.  Or even better you'd do away with the expensive
indirect calls and just directly call either the old or new
bitmap code.

> Meanwhile, bitmap file for the old bitmap will be removed sooner or
> later, and this bdev_file implementation will compatible with bitmap
> file as well.

Which would also mean that at that point the operations vector would
be pointless, so we might as well not add it to start with.

