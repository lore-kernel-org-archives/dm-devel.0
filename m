Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C740156F3C
	for <dm-devel@lists.linux.dev>; Wed,  9 Apr 2025 09:40:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744191627; cv=none; b=gNMzDpuecoDi6bEv1djHMmQoONYPUmI0rxmwi9l9Jg5a9zomRqIVrPcPGK5FTAIlADKLizVac6J3DSmavEDXi7+cqE9b/pl1a2z5fX8okltUWVz/S9RI/J/xog+c/X7RK+7UrlxKJb6NHjKBLA3HwyfK9oiprrP+WJCVBmHN3ik=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744191627; c=relaxed/simple;
	bh=s8le5K3ysdQonKV3GUCEEMOPpA28yvkSOKT2HFNe3sU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=L2Ny5D0NR2a1mUhjDNnWEKdC93LCXA5jI0F8LPTEdFhO146AZz1gbjiaAi+zc0bWOBOGflTK/m/4LYP3Jorg5ZVSxrRV5XzOknTt+zUXhjq3qfR4lLx7/h5/aiU9RFXEmOwr2bfFztQBi2VsgPLrNP29qRzThwN9eZga/6QW94E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 23F5E68BFE; Wed,  9 Apr 2025 11:40:20 +0200 (CEST)
Date: Wed, 9 Apr 2025 11:40:19 +0200
From: Christoph Hellwig <hch@lst.de>
To: Yu Kuai <yukuai1@huaweicloud.com>
Cc: Christoph Hellwig <hch@lst.de>, xni@redhat.com, colyli@kernel.org,
	axboe@kernel.dk, agk@redhat.com, snitzer@kernel.org,
	mpatocka@redhat.com, song@kernel.org, linux-block@vger.kernel.org,
	linux-kernel@vger.kernel.org, dm-devel@lists.linux.dev,
	linux-raid@vger.kernel.org, yi.zhang@huawei.com,
	yangerkun@huawei.com, kbusch@kernel.org,
	"yukuai (C)" <yukuai3@huawei.com>
Subject: Re: [PATCH RFC v2 00/14] md: introduce a new lockless bitmap
Message-ID: <20250409094019.GA3890@lst.de>
References: <20250328060853.4124527-1-yukuai1@huaweicloud.com> <Z-aCzTWXzFWe4oxU@infradead.org> <c6c608e2-23e7-486f-100a-d1fb6cfff4f2@huaweicloud.com> <20250409083208.GA2326@lst.de> <115c3b08-aff1-dd97-fe6a-7901452ce62c@huaweicloud.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <115c3b08-aff1-dd97-fe6a-7901452ce62c@huaweicloud.com>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Wed, Apr 09, 2025 at 05:27:11PM +0800, Yu Kuai wrote:
>> For that you'd be much better of just creating your own trivial
>> file_system_type with an inode fully controlled by your driver
>> that has a trivial set of address_space ops instead of oddly
>> mixing with the block layer.
>
> Yes, this is exactly what I said implement a new file_operations(and
> address_space ops), I wanted do this the easy way, just reuse the raw
> block device ops, this way I just need to implement the submit_bio ops
> for new hidden disk.
>
> I can try with new fs type if we really think this solution is too
> hacky, however, the code line will be much more. :(

I don't think it should be much more.  It'll also remove the rather
unexpected indirection through submit_bio.  Just make sure you use
iomap for your operations, and implement the submit_io hook.  That
will also be more efficient than the buffer_head based block ops
for writes.

>>
>> Note that either way I'm not sure using the page cache here is an
>> all that good idea, as we're at the bottom of the I/O stack and
>> thus memory allocations can very easily deadlock.
>
> Yes, for the page from bitmap, this set do the easy way just read and
> ping all realted pages while loading the bitmap. For two reasons:
>
> 1) We don't need to allocate and read pages from IO path;(In the first
> RFC version, I'm using a worker to do that).

You still depend on the worker, which will still deadlock.

>> What speaks against using your own folios explicitly allocated at
>> probe time and then just doing manual submit_bio on that?  That's
>> probably not much more code but a lot more robust.
>
> I'm not quite sure if I understand you correctly. Do you means don't use
> pagecache for bitmap IO, and manually create BIOs like the old bitmap,
> meanwhile invent a new solution for synchronism instead of the global
> spin_lock from old bitmap?

Yes.  Alternatively you need to pre-populate the page cache and keep
extra page references.

