Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 00DC1947F;
	Mon,  6 Nov 2023 07:10:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Authentication-Results: smtp.subspace.kernel.org; dkim=none
Received: by verein.lst.de (Postfix, from userid 2407)
	id 7AFC868AA6; Mon,  6 Nov 2023 08:10:08 +0100 (CET)
Date: Mon, 6 Nov 2023 08:10:08 +0100
From: Christoph Hellwig <hch@lst.de>
To: Keith Busch <kbusch@kernel.org>
Cc: Mikulas Patocka <mpatocka@redhat.com>,
	Marek Marczykowski-G'orecki <marmarek@invisiblethingslab.com>,
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
Message-ID: <20231106071008.GB17022@lst.de>
References: <ZULvkPhcpgAVyI8w@mail-itl> <ac5b5ac0-9e8-c1b0-a26-62f832f845f0@redhat.com> <ZUOL8kXVTF1OngeN@mail-itl> <3cb4133c-b6db-9187-a678-11ed8c9456e@redhat.com> <ZUUctamEFtAlSnSV@mail-itl> <ZUUlqJoS6_1IznzT@kbusch-mbp.dhcp.thefacebook.com> <ZUVYT1Xp4+hFT27W@mail-itl> <ZUV3TApYYoh_oiRR@kbusch-mbp.dhcp.thefacebook.com> <11a9886d-316c-edcd-d6da-24ad0b9a2b4@redhat.com> <ZUZOKitOAqqKiJ4n@kbusch-mbp.dhcp.thefacebook.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZUZOKitOAqqKiJ4n@kbusch-mbp.dhcp.thefacebook.com>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Sat, Nov 04, 2023 at 07:59:06AM -0600, Keith Busch wrote:
> > dma_opt_mapping_size returns "min(dma_max_mapping_size(dev), size)". So 
> > you don't have to call dma_max_mapping_size explicitly, you can leave the 
> > file drivers/nvme/host/pci.c as it is.
> 
> Indeed.
>  
> > What about the other block device drivers (AHCI, SCSI...)? Should there be 
> > some generic framework that restricts max_hw_sectors according to 
> > dma_opt_mapping_size?
> 
> I think it's just like any other request_queue limits and the individual
> drivers have to set up these.

Yes, or in case of SCSI the scsi midlayer, which already does it.
The block layer itself doesn't even know that we're using DMA to
transfer data.

> Thinking on this again, this feels more like a max_segment_size limit
> rather than a max_hw_sectors.

No, it's an overall limit.  If we'd have a lot of segments using the
max size we'd still starve the swiotlb pool.
