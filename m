Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 924E81A585;
	Fri,  3 Nov 2023 15:10:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="TJt0EXAN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5F993C433C8;
	Fri,  3 Nov 2023 15:10:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1699024222;
	bh=I4xDSq1ezZOAkiMznffHlRhBFTdfQ6d+HVaQqg2tD5g=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=TJt0EXANZ1OjfdJU6AU6q3gklQYkIFtCEkQ6esqW9Ysjw3fvvXwbWlHFHaTYSFw1K
	 uQZfo4O4dRUsOkzPj6GiBmoXmlCMfLnGqlVYCZfI5XXYfDh7XmV4vcysYh8/mn1svt
	 zCzu55NYX212Yjf85v6fzHa318WO3Qlx16h5Fc7u2GK28yT+UNxYZ4e2QIlt14NSXi
	 FwOkwSi/CUSnvfGPGgrirXyfi438VI6PdLIlucX9Tmx1M5X7F9GOebRAYHdLWUmggC
	 4EgDk9PoupSazA4bPMMR3OYd9W9c49KEINlQQr6nF56UiUjyWzgPyl/hfj5wKZtwHI
	 zLNZ4I8iJCg8w==
Date: Fri, 3 Nov 2023 09:10:18 -0600
From: Keith Busch <kbusch@kernel.org>
To: Marek =?us-ascii?Q?Marczykowski-G'orecki?= <marmarek@invisiblethingslab.com>
Cc: Mikulas Patocka <mpatocka@redhat.com>, Jens Axboe <axboe@fb.com>,
	Christoph Hellwig <hch@lst.de>, Sagi Grimberg <sagi@grimberg.me>,
	Jan Kara <jack@suse.cz>, Vlastimil Babka <vbabka@suse.cz>,
	Andrew Morton <akpm@linux-foundation.org>,
	Matthew Wilcox <willy@infradead.org>,
	Michal Hocko <mhocko@suse.com>, stable@vger.kernel.org,
	regressions@lists.linux.dev, Alasdair Kergon <agk@redhat.com>,
	Mike Snitzer <snitzer@kernel.org>, dm-devel@lists.linux.dev,
	linux-mm@kvack.org
Subject: Re: Intermittent storage (dm-crypt?) freeze - regression 6.4->6.5
Message-ID: <ZUUNWseQYdst6eoy@kbusch-mbp.dhcp.thefacebook.com>
References: <ZUB5HFeK3eHeI8UH@mail-itl>
 <20231031140136.25bio5wajc5pmdtl@quack3>
 <ZUEgWA5P8MFbyeBN@mail-itl>
 <8a35cdea-3a1a-e859-1f7c-55d1c864a48@redhat.com>
 <ebbc7ca7-5169-dbdc-9ea8-c6d8c3ae31e2@redhat.com>
 <ZULvkPhcpgAVyI8w@mail-itl>
 <ac5b5ac0-9e8-c1b0-a26-62f832f845f0@redhat.com>
 <ZUOL8kXVTF1OngeN@mail-itl>
 <3cb4133c-b6db-9187-a678-11ed8c9456e@redhat.com>
 <ZUULQBAwS2/KknwH@mail-itl>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZUULQBAwS2/KknwH@mail-itl>

On Fri, Nov 03, 2023 at 04:01:19PM +0100, Marek Marczykowski-G'orecki wrote:
> On Thu, Nov 02, 2023 at 06:06:33PM +0100, Mikulas Patocka wrote:
> > On Thu, 2 Nov 2023, Marek Marczykowski-G'orecki wrote:
> > 
> > > On Thu, Nov 02, 2023 at 10:28:57AM +0100, Mikulas Patocka wrote:
> > > 
> > > > Try lowring /sys/block/nvme0n1/queue/max_sectors_kb to some small value 
> > > > (for example 64) and test if it helps.
> > > 
> > > Yes, this helps too.
> > 
> > On a plain upstream kernel with no other modifications (and with default 
> > max_sectors_kb), set the value /sys/module/nvme/parameters/sgl_threshold 
> > to "0" and test it if it deadlocks. Then, set this value to "1" and test 
> > it again.
> 
> Got deadlock wit both values.
> 
> > Revert sgl_threshold back to the default (32768). Boot the kernel with the 
> > option "iommu=panic". Reproduce the deadlock and if you get a kernel 
> > panic, send us the panic log.
> 
> This is a Xen PV, so Linux is not in charge of IOMMU here. And there is
> SWIOTLB involved (64MB of it), I'm not sure if for every DMA, but
> definitely for some.

So it's using xen_swiotlb_dma_ops, right? That doesn't implmeent
.opt_mapping_size, and I'm guessing it should be equal to
swiotlb_max_mapping_size().
 
> > Then, try this patch (without "iommu=panic"), reproduce the deadlock and 
> > tell us which one of the "printk" statements is triggered during the 
> > deadlock.
> 
> I'll try this next.

Placing my bet now: you'll see a DMA mapping error.
