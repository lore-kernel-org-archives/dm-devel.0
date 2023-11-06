Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6978A28DD8;
	Mon,  6 Nov 2023 15:16:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="p1efQTYv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 97714C433BC;
	Mon,  6 Nov 2023 15:16:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1699283796;
	bh=/HAwmovzMZdoeZvZsHcdokGslREftSrFRuxNINmZTNE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=p1efQTYvGf8rVFkUIm2klEwzrW2mtKPa5EF8rwprtr9zH5WwvnNajfJl+shtHJF50
	 /ZnBBtxAYwFDXG51JGihfmCzTaX4OxyMbmJEk3SUsAA17/dTb9U9/QQvh52VD84FTM
	 VfEN6nj25Eenlmdmzjt6BJwNVvI+dgDFpIybQyLD9c+5Ee4exOLb3CTy9naiQDXXhU
	 Cw/TfswQygCrntLmNHPTMdYdv3g15hW+NIhMfAYqmc2HfwvR4gsKunhB1q+pSmO1C1
	 Pz32FeIJO3uX+B6Vw1z/QG9JVxwaQX4FzOdrrkHTjHSL4DFDV5YjUDxfCNKfOStlS5
	 LYvEnkgAbPC1A==
Date: Mon, 6 Nov 2023 08:16:33 -0700
From: Keith Busch <kbusch@kernel.org>
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: Christoph Hellwig <hch@lst.de>, Juergen Gross <jgross@suse.com>,
	Stefano Stabellini <sstabellini@kernel.org>,
	xen-devel@lists.xenproject.org, iommu@lists.linux.dev,
	Marek Marczykowski-G'orecki <marmarek@invisiblethingslab.com>,
	Jens Axboe <axboe@fb.com>, Sagi Grimberg <sagi@grimberg.me>,
	Jan Kara <jack@suse.cz>, Vlastimil Babka <vbabka@suse.cz>,
	Andrew Morton <akpm@linux-foundation.org>,
	Matthew Wilcox <willy@infradead.org>,
	Michal Hocko <mhocko@suse.com>, stable@vger.kernel.org,
	regressions@lists.linux.dev, Alasdair Kergon <agk@redhat.com>,
	Mike Snitzer <snitzer@kernel.org>, dm-devel@lists.linux.dev,
	linux-mm@kvack.org
Subject: Re: [PATCH] swiotlb-xen: provide the "max_mapping_size" method
Message-ID: <ZUkDUXDF6g4P86F3@kbusch-mbp.dhcp.thefacebook.com>
References: <ZUOL8kXVTF1OngeN@mail-itl>
 <3cb4133c-b6db-9187-a678-11ed8c9456e@redhat.com>
 <ZUUctamEFtAlSnSV@mail-itl>
 <ZUUlqJoS6_1IznzT@kbusch-mbp.dhcp.thefacebook.com>
 <ZUVYT1Xp4+hFT27W@mail-itl>
 <ZUV3TApYYoh_oiRR@kbusch-mbp.dhcp.thefacebook.com>
 <11a9886d-316c-edcd-d6da-24ad0b9a2b4@redhat.com>
 <ZUZOKitOAqqKiJ4n@kbusch-mbp.dhcp.thefacebook.com>
 <20231106071008.GB17022@lst.de>
 <928b5df7-fada-cf2f-6f6a-257a84547c3@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <928b5df7-fada-cf2f-6f6a-257a84547c3@redhat.com>

On Mon, Nov 06, 2023 at 03:59:40PM +0100, Mikulas Patocka wrote:
> There's a bug that when using the XEN hypervisor with dm-crypt on NVMe, 
> the kernel deadlocks [1].
> 
> The deadlocks are caused by inability to map a large bio vector -
> dma_map_sgtable always returns an error, this gets propagated to the block
> layer as BLK_STS_RESOURCE and the block layer retries the request
> indefinitely.
> 
> XEN uses the swiotlb framework to map discontiguous pages into contiguous
> runs that are submitted to the PCIe device. The swiotlb framework has a
> limitation on the length of a mapping - this needs to be announced with
> the max_mapping_size method to make sure that the hardware drivers do not
> create larger mappings.
> 
> Without max_mapping_size, the NVMe block driver would create large
> mappings that overrun the maximum mapping size.
> 
> [1] https://lore.kernel.org/stable/ZTNH0qtmint%2FzLJZ@mail-itl/

This should be a "Link:" tag.

> Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
> Reported-by: Marek Marczykowski-G'orecki <marmarek@invisiblethingslab.com>
> Tested-by: Marek Marczykowski-G'orecki <marmarek@invisiblethingslab.com>
> Suggested-by: Keith Busch <kbusch@kernel.org>

I was about to send the same thing. I did a little more than suggest
this: it's is the very patch I wrote for testing, minus the redundant
nvme bits! But since you already have a commit message for it...

Acked-by: Keith Busch <kbusch@kernel.org>

> Suggested-by: Christoph Hellwig <hch@lst.de>
> Cc: stable@vger.kernel.org
> 
> ---
>  drivers/xen/swiotlb-xen.c |    1 +
>  1 file changed, 1 insertion(+)
> 
> Index: linux-stable/drivers/xen/swiotlb-xen.c
> ===================================================================
> --- linux-stable.orig/drivers/xen/swiotlb-xen.c	2023-11-03 17:57:18.000000000 +0100
> +++ linux-stable/drivers/xen/swiotlb-xen.c	2023-11-06 15:30:59.000000000 +0100
> @@ -405,4 +405,5 @@ const struct dma_map_ops xen_swiotlb_dma
>  	.get_sgtable = dma_common_get_sgtable,
>  	.alloc_pages = dma_common_alloc_pages,
>  	.free_pages = dma_common_free_pages,
> +	.max_mapping_size = swiotlb_max_mapping_size,
>  };

