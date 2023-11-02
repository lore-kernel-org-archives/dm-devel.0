Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3ED631BDC6;
	Thu,  2 Nov 2023 14:02:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="SX4WtNKm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 55B93C433C9;
	Thu,  2 Nov 2023 14:02:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1698933759;
	bh=fgOZjn0WdFzXtcn8lGgDLoPHzxr8QdP2NR/ys5t0Tbc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=SX4WtNKm5pDj9w492ahqKstWDnWh6M4sJIDEesfWnzHG+qb9Q4yNf6O/VTmBrzQ+B
	 J+lN6pLndYpPJ2///jW3lO8ULdP1cvkId8z0QLLU9SCD1Vn3MCh+blaB22zqDAiR/o
	 XR4l+VlEP7zQokYYie6zAycHpAphfEalcKMzDRGBY7DIFdzBxEoSIM1JcGC8CJxbij
	 F9Ali9mUj5nbbM9wS1hvCdR6/H4SvGkafHYkIN0s4b7pqOGcZS/Zcm6+PYMZJDJNev
	 2MmTfCZEAoTWDPXuEvghazEUvKAcFhgHBcECGGT8wd3jtYaMQqEyBmgULjji+2X7SU
	 nEdY57VcxKcNQ==
Date: Thu, 2 Nov 2023 08:02:34 -0600
From: Keith Busch <kbusch@kernel.org>
To: Ming Lei <ming.lei@redhat.com>
Cc: Hannes Reinecke <hare@suse.de>, Ming Lei <tom.leiming@gmail.com>,
	Marek =?us-ascii?Q?Marczykowski-G'orecki?= <marmarek@invisiblethingslab.com>,
	Jan Kara <jack@suse.cz>, Mikulas Patocka <mpatocka@redhat.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	Andrew Morton <akpm@linux-foundation.org>,
	Matthew Wilcox <willy@infradead.org>,
	Michal Hocko <mhocko@suse.com>, stable@vger.kernel.org,
	regressions@lists.linux.dev, Alasdair Kergon <agk@redhat.com>,
	Mike Snitzer <snitzer@kernel.org>, dm-devel@lists.linux.dev,
	linux-mm@kvack.org, linux-block@vger.kernel.org,
	linux-nvme@lists.infradead.org
Subject: Re: Intermittent storage (dm-crypt?) freeze - regression 6.4->6.5
Message-ID: <ZUOr-vp0yRkLyvyi@kbusch-mbp.dhcp.thefacebook.com>
References: <ZT/e/EaBIkJEgevQ@mail-itl>
 <98aefaa9-1ac-a0e4-fb9a-89ded456750@redhat.com>
 <ZUB5HFeK3eHeI8UH@mail-itl>
 <20231031140136.25bio5wajc5pmdtl@quack3>
 <ZUEgWA5P8MFbyeBN@mail-itl>
 <CACVXFVOEWDyzasS7DWDvLOhC3Hr6qOn5ks3HLX+fbRYCxYv26w@mail.gmail.com>
 <ZUG0gcRhUlFm57qN@mail-itl>
 <ZUHE52SznRaZQxnG@fedora>
 <ab02413f-4bf2-4d92-baf7-62fbd106f5df@suse.de>
 <ZUI1GSSL4vdsFVHq@fedora>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZUI1GSSL4vdsFVHq@fedora>

On Wed, Nov 01, 2023 at 07:23:05PM +0800, Ming Lei wrote:
> On Wed, Nov 01, 2023 at 11:15:02AM +0100, Hannes Reinecke wrote:
> > > nvme_queue_rq() on the above request.
> > > 
> > And that is something I've been wondering (for quite some time now):
> > What _is_ the appropriate error handling for -ENOMEM?
> 
> It is just my guess.
> 
> Actually it shouldn't fail since the sgl allocation is backed with
> memory pool, but there is also dma pool allocation and dma mapping.
> 
> > At this time, we assume it to be a retryable error and re-run the queue
> > in the hope that things will sort itself out.
> 
> It should not be hard to figure out why nvme_queue_rq() can't move on.

There's only a few reasons nvme_queue_rq would return BLK_STS_RESOURCE
for a typical read/write command:

  DMA mapping error
  Can't allocate SGL from mempool
  Can't allocate PRP from dma_pool
  Controller stuck in resetting state

We should always be able to get at least one allocation from the memory
pools, so I think the only one the driver doesn't have a way to
guarantee eventual forward progress are the DMA mapping error
conditions. Is there some other limit that the driver needs to consider
when configuring it's largest supported transfers?
