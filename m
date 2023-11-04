Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 796FB3D6C;
	Sat,  4 Nov 2023 13:59:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="KG3xZ24g"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A1F88C433C7;
	Sat,  4 Nov 2023 13:59:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1699106349;
	bh=ngBgbPjGe4VY0Szfr2ipMZungHmONQzt8eNm8Edd7KM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=KG3xZ24g4Ms6FoAbNpBwwlbXSEpCSghDUU+fDRae+OdLWpsin4az0vCy6r8t0IynX
	 Ms26ILWTYmmM/OqNh7nFgxdyD2K4CHSQBztulYHjiVwoF8yM2KZPtugp9o3XN5yFRj
	 fNxuW7ALkEZ17/Ujy3nn+avLV3YOP0NQwLPLWuiT7ghkZY59qRXl6xmMPsogLhrTVP
	 Wvj+grpXl/EASsVcR+TiRNBcwRuTo/8C7YafC7qdESsEbYISlQDH1QLGdSoHPhCQhH
	 Ci67QLIMLP3AeN0hCKZo66ixY6JFtQwwRZ40Agr2GSrBJOe4P32sJzeGO/NJwwQwKd
	 6VRw2CIosBc4w==
Date: Sat, 4 Nov 2023 07:59:06 -0600
From: Keith Busch <kbusch@kernel.org>
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: Marek Marczykowski-G'orecki <marmarek@invisiblethingslab.com>,
	Jens Axboe <axboe@fb.com>, Christoph Hellwig <hch@lst.de>,
	Sagi Grimberg <sagi@grimberg.me>, Jan Kara <jack@suse.cz>,
	Vlastimil Babka <vbabka@suse.cz>,
	Andrew Morton <akpm@linux-foundation.org>,
	Matthew Wilcox <willy@infradead.org>,
	Michal Hocko <mhocko@suse.com>, stable@vger.kernel.org,
	regressions@lists.linux.dev, Alasdair Kergon <agk@redhat.com>,
	Mike Snitzer <snitzer@kernel.org>, dm-devel@lists.linux.dev,
	linux-mm@kvack.org
Subject: Re: Intermittent storage (dm-crypt?) freeze - regression 6.4->6.5
Message-ID: <ZUZOKitOAqqKiJ4n@kbusch-mbp.dhcp.thefacebook.com>
References: <ebbc7ca7-5169-dbdc-9ea8-c6d8c3ae31e2@redhat.com>
 <ZULvkPhcpgAVyI8w@mail-itl>
 <ac5b5ac0-9e8-c1b0-a26-62f832f845f0@redhat.com>
 <ZUOL8kXVTF1OngeN@mail-itl>
 <3cb4133c-b6db-9187-a678-11ed8c9456e@redhat.com>
 <ZUUctamEFtAlSnSV@mail-itl>
 <ZUUlqJoS6_1IznzT@kbusch-mbp.dhcp.thefacebook.com>
 <ZUVYT1Xp4+hFT27W@mail-itl>
 <ZUV3TApYYoh_oiRR@kbusch-mbp.dhcp.thefacebook.com>
 <11a9886d-316c-edcd-d6da-24ad0b9a2b4@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <11a9886d-316c-edcd-d6da-24ad0b9a2b4@redhat.com>

On Sat, Nov 04, 2023 at 10:27:32AM +0100, Mikulas Patocka wrote:
> On Fri, 3 Nov 2023, Keith Busch wrote:
> > On Fri, Nov 03, 2023 at 09:30:07PM +0100, Marek Marczykowski-G'orecki wrote:
> > > On Fri, Nov 03, 2023 at 10:54:00AM -0600, Keith Busch wrote:
> > > > On Fri, Nov 03, 2023 at 05:15:49PM +0100, Marek Marczykowski-G'orecki wrote:
> > > > > On Thu, Nov 02, 2023 at 06:06:33PM +0100, Mikulas Patocka wrote:
> > > > > > Then, try this patch (without "iommu=panic"), reproduce the deadlock and 
> > > > > > tell us which one of the "printk" statements is triggered during the 
> > > > > > deadlock.
> > > > > 
> > > > > The "821" one - see below.
> > > > 
> > > > Thanks for confirming!
> > > > 
> > > > Could you try this patch?
> > > 
> > > Besides min3() being unhappy about types, it works.
> > 
> > Oops, should have changed the constant to "ul" instead of just "u".
> > 
> > Anyway, the overall idea makes sense to me, but I don't know the swiotlb
> > stuff well.
> > 
> > Christoph, does that patch make sense? For reference:
> > 
> >    https://lore.kernel.org/linux-mm/ZUOr-vp0yRkLyvyi@kbusch-mbp.dhcp.thefacebook.com/T/#m8d34245e0eef43f8e9fe6cba6038d77ed2a93ad6
> 
> dma_opt_mapping_size returns "min(dma_max_mapping_size(dev), size)". So 
> you don't have to call dma_max_mapping_size explicitly, you can leave the 
> file drivers/nvme/host/pci.c as it is.

Indeed.
 
> What about the other block device drivers (AHCI, SCSI...)? Should there be 
> some generic framework that restricts max_hw_sectors according to 
> dma_opt_mapping_size?

I think it's just like any other request_queue limits and the individual
drivers have to set up these.

Thinking on this again, this feels more like a max_segment_size limit
rather than a max_hw_sectors.
