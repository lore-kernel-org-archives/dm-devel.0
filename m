Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 31B3F1FC8
	for <dm-devel@lists.linux.dev>; Thu,  9 Jul 2026 06:10:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783577405; cv=none; b=qlWESverOhLrS2osd+XoQwyJS+rQY839W7Evp5Q5UUKmww7wUWt14tIDKZdHmsab10OgP1cOBBMzQqQIpn4PPc/6cv1lGG8q59EgqXuEcrgW4bwyXlMuOUE6KGLpR4oyWiLuRLBn+szBY6CZa2ODvVMrHxpTdPymNd/Q7iWJGbk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783577405; c=relaxed/simple;
	bh=1Y1eyeNlFUGjdAJHev+uOkCq1cdaOXCCdtk/jL2KcLE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=aOsUezWo0A43R0FDXVV6CRQI+qUJNuWnhQSBg3ClPNp0ycMptXbw39aQhNI0xMU+iSjbNGgxdmZ4IFLkg1CrXTnfjV3h5SyokhBgV29WWnRcDegfZr3Ccmo6GqNVK6D8Lzuv6749Qteoz104wyRfPqFnS8prFCyoXn6FgQNSic4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 07E5D68BFE; Thu,  9 Jul 2026 08:10:00 +0200 (CEST)
Date: Thu, 9 Jul 2026 08:09:59 +0200
From: Christoph Hellwig <hch@lst.de>
To: Yu Kuai <yukuai@kernel.org>
Cc: Jens Axboe <axboe@kernel.dk>, Tejun Heo <tj@kernel.org>,
	Christoph Hellwig <hch@lst.de>, Keith Busch <kbusch@kernel.org>,
	Sagi Grimberg <sagi@grimberg.me>, Alasdair Kergon <agk@redhat.com>,
	Benjamin Marzinski <bmarzins@redhat.com>,
	Mike Snitzer <snitzer@kernel.org>,
	Mikulas Patocka <mpatocka@redhat.com>,
	Dongsheng Yang <dongsheng.yang@linux.dev>,
	Zheng Gu <cengku@gmail.com>, Coly Li <colyli@fygo.io>,
	Kent Overstreet <kent.overstreet@linux.dev>,
	Josef Bacik <josef@toxicpanda.com>, Yu Kuai <yukuai@fygo.io>,
	Nilay Shroff <nilay@linux.ibm.com>, linux-block@vger.kernel.org,
	cgroups@vger.kernel.org, linux-nvme@lists.infradead.org,
	dm-devel@lists.linux.dev, linux-bcache@vger.kernel.org
Subject: Re: [RFC PATCH v1 00/17] blk-cgroup: protect blkgs with blkcg_mutex
Message-ID: <20260709060959.GA16504@lst.de>
References: <20260704195124.1375075-1-yukuai@kernel.org>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260704195124.1375075-1-yukuai@kernel.org>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Sun, Jul 05, 2026 at 03:51:07AM +0800, Yu Kuai wrote:
> From: Yu Kuai <yukuai@fygo.io>
> 
> This RFC moves queue-local blkg topology synchronization from
> q->queue_lock to q->blkcg_mutex.
> 
> q->queue_lock is a hot block-layer spinlock used by request queue runtime
> paths,

I don't think it is hot any more.  If it is in one of your workloads
we have a deep problem somewhere.  That being said, futher removing
uses of his old catch-all lock is always good, hopefully we can
eventually remove it entirely.

So this series looks great to me conceptually, but I'm unfortunately
not a very qualified reviewer for the blk-cgroup code.

