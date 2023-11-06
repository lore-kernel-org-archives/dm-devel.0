Received: from mail-qt1-f181.google.com (mail-qt1-f181.google.com [209.85.160.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 70F9928E09
	for <dm-devel@lists.linux.dev>; Mon,  6 Nov 2023 15:30:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org; dkim=none
Received: by mail-qt1-f181.google.com with SMTP id d75a77b69052e-41cc0e9d92aso29544331cf.3
        for <dm-devel@lists.linux.dev>; Mon, 06 Nov 2023 07:30:48 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1699284647; x=1699889447;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=hrjYpFY8E2oiY2xxYzQ2GUG1YMJAJZ45VGuFmmeRh4c=;
        b=BSJCv762JLt//90i8KeoY7tihEuYx+2JgNlqM8Bs+c+6T1itt8GiPpJevPy23uvsTO
         FcrumpjuV6L0CVi5nP3nN+9wmf1lcShJEPOhNSXJ0ief1tMldHu6L0XonFPrR75TRYLp
         LWtoj2HOxqgLNSyl6g25ml1Jso5wH0dPl3ddl65pMtYe0vrOFSuno9FaRiuk4hX/ZcOr
         qF9ZfJ/THzRxdVvVwqGJ2QZ8APDQXT/DcTLh3yMRPgILjrMvoldvZsZ91XyPTNyjzMH6
         FROcLY0BF3irTED2ccGyMGgdtxBqY+sUffyZSpO3ZYqygToFHL459t2RGdTRhecly2OE
         oFJw==
X-Gm-Message-State: AOJu0Ywl89QNMOjCT8taPqmUSJ9oSaMoF+5xKKJ/BMdHh9P2V19kGlrP
	9c9y7bqXX0Xzx5TuaoyHLBtg
X-Google-Smtp-Source: AGHT+IEM/+zw76Fcxpj1WquMbJygUaMozC9Wk7yN5zbxmT5CSz4J9onVl5IQCkCNvJJhkdQNmfPFUA==
X-Received: by 2002:ac8:7d50:0:b0:41c:bbf3:b24b with SMTP id h16-20020ac87d50000000b0041cbbf3b24bmr35421169qtb.27.1699284647197;
        Mon, 06 Nov 2023 07:30:47 -0800 (PST)
Received: from localhost (pool-68-160-141-91.bstnma.fios.verizon.net. [68.160.141.91])
        by smtp.gmail.com with ESMTPSA id bb29-20020a05622a1b1d00b00418122186ccsm3481815qtb.12.2023.11.06.07.30.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 06 Nov 2023 07:30:46 -0800 (PST)
Date: Mon, 6 Nov 2023 10:30:45 -0500
From: Mike Snitzer <snitzer@kernel.org>
To: Keith Busch <kbusch@kernel.org>
Cc: Mikulas Patocka <mpatocka@redhat.com>, Christoph Hellwig <hch@lst.de>,
	Juergen Gross <jgross@suse.com>,
	Stefano Stabellini <sstabellini@kernel.org>,
	xen-devel@lists.xenproject.org, iommu@lists.linux.dev,
	Marek Marczykowski-G'orecki <marmarek@invisiblethingslab.com>,
	Jens Axboe <axboe@fb.com>, Sagi Grimberg <sagi@grimberg.me>,
	Jan Kara <jack@suse.cz>, Vlastimil Babka <vbabka@suse.cz>,
	Andrew Morton <akpm@linux-foundation.org>,
	Matthew Wilcox <willy@infradead.org>,
	Michal Hocko <mhocko@suse.com>, stable@vger.kernel.org,
	regressions@lists.linux.dev, Alasdair Kergon <agk@redhat.com>,
	dm-devel@lists.linux.dev, linux-mm@kvack.org
Subject: Re: swiotlb-xen: provide the "max_mapping_size" method
Message-ID: <ZUkGpblDX637QV9y@redhat.com>
References: <3cb4133c-b6db-9187-a678-11ed8c9456e@redhat.com>
 <ZUUctamEFtAlSnSV@mail-itl>
 <ZUUlqJoS6_1IznzT@kbusch-mbp.dhcp.thefacebook.com>
 <ZUVYT1Xp4+hFT27W@mail-itl>
 <ZUV3TApYYoh_oiRR@kbusch-mbp.dhcp.thefacebook.com>
 <11a9886d-316c-edcd-d6da-24ad0b9a2b4@redhat.com>
 <ZUZOKitOAqqKiJ4n@kbusch-mbp.dhcp.thefacebook.com>
 <20231106071008.GB17022@lst.de>
 <928b5df7-fada-cf2f-6f6a-257a84547c3@redhat.com>
 <ZUkDUXDF6g4P86F3@kbusch-mbp.dhcp.thefacebook.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZUkDUXDF6g4P86F3@kbusch-mbp.dhcp.thefacebook.com>

On Mon, Nov 06 2023 at 10:16P -0500,
Keith Busch <kbusch@kernel.org> wrote:

> On Mon, Nov 06, 2023 at 03:59:40PM +0100, Mikulas Patocka wrote:
> > There's a bug that when using the XEN hypervisor with dm-crypt on NVMe, 
> > the kernel deadlocks [1].
> > 
> > The deadlocks are caused by inability to map a large bio vector -
> > dma_map_sgtable always returns an error, this gets propagated to the block
> > layer as BLK_STS_RESOURCE and the block layer retries the request
> > indefinitely.
> > 
> > XEN uses the swiotlb framework to map discontiguous pages into contiguous
> > runs that are submitted to the PCIe device. The swiotlb framework has a
> > limitation on the length of a mapping - this needs to be announced with
> > the max_mapping_size method to make sure that the hardware drivers do not
> > create larger mappings.
> > 
> > Without max_mapping_size, the NVMe block driver would create large
> > mappings that overrun the maximum mapping size.
> > 
> > [1] https://lore.kernel.org/stable/ZTNH0qtmint%2FzLJZ@mail-itl/
> 
> This should be a "Link:" tag.
> 
> > Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
> > Reported-by: Marek Marczykowski-G'orecki <marmarek@invisiblethingslab.com>
> > Tested-by: Marek Marczykowski-G'orecki <marmarek@invisiblethingslab.com>
> > Suggested-by: Keith Busch <kbusch@kernel.org>
> 
> I was about to send the same thing. I did a little more than suggest
> this: it's is the very patch I wrote for testing, minus the redundant
> nvme bits! But since you already have a commit message for it...
> 
> Acked-by: Keith Busch <kbusch@kernel.org>

No, this patch should be attributed to you Keith.

Mikulas, I like that you ran with getting a fix prepared but please
update the patch so Keith is the author and use Link: as suggested for
the v2. Note: you'll still use your Signed-off-by since you had a role
in getting this patch together (but please move yours to the end of
the header).

Mike


> 
> > Suggested-by: Christoph Hellwig <hch@lst.de>
> > Cc: stable@vger.kernel.org
> > 
> > ---
> >  drivers/xen/swiotlb-xen.c |    1 +
> >  1 file changed, 1 insertion(+)
> > 
> > Index: linux-stable/drivers/xen/swiotlb-xen.c
> > ===================================================================
> > --- linux-stable.orig/drivers/xen/swiotlb-xen.c	2023-11-03 17:57:18.000000000 +0100
> > +++ linux-stable/drivers/xen/swiotlb-xen.c	2023-11-06 15:30:59.000000000 +0100
> > @@ -405,4 +405,5 @@ const struct dma_map_ops xen_swiotlb_dma
> >  	.get_sgtable = dma_common_get_sgtable,
> >  	.alloc_pages = dma_common_alloc_pages,
> >  	.free_pages = dma_common_free_pages,
> > +	.max_mapping_size = swiotlb_max_mapping_size,
> >  };
> 
