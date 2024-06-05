Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8832918F2EA
	for <dm-devel@lists.linux.dev>; Wed,  5 Jun 2024 08:14:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717575254; cv=none; b=fIxVmJtB7ad0WREPTOfWDdliaiAYOgUlV41UtiJT5mSDXlTtI2q+jUIbtBSkd1eOE9QfGSePmPURvZHPNBHE/abmhUt7vqK5PyC4dtHv5K4mtqe+9G1XfGUvlUYJG++aov3JOia3t5NYOEHQ9aycmSnhKQfH0XxQuCnlQh0L+TU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717575254; c=relaxed/simple;
	bh=82v2m1L+3skRACTF6tKIP0huvHsWjzrf7dlcSWAmHso=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=eJTVPJFV+EP0GUJrSRnf+OH2wp3SaBlakIudz2+YM2yxVx2+27bUCjc90Isk2++IBOaveSDZaVryasAfh54plXZxBeqDGHL+686VQdiJArTe72codDFUKwXHTqk3sC+oFbV2VkNj8wFcNdaO+SzHMEn2rZJbS4K94Kwyzdd2Z8g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 14B8567373; Wed,  5 Jun 2024 10:14:08 +0200 (CEST)
Date: Wed, 5 Jun 2024 10:14:07 +0200
From: Christoph Hellwig <hch@lst.de>
To: Damien Le Moal <dlemoal@kernel.org>
Cc: Hannes Reinecke <hare@suse.de>, Christoph Hellwig <hch@lst.de>,
	Nitesh Shetty <nj.shetty@samsung.com>, Jens Axboe <axboe@kernel.dk>,
	Jonathan Corbet <corbet@lwn.net>, Alasdair Kergon <agk@redhat.com>,
	Mike Snitzer <snitzer@kernel.org>,
	Mikulas Patocka <mpatocka@redhat.com>,
	Keith Busch <kbusch@kernel.org>, Sagi Grimberg <sagi@grimberg.me>,
	Chaitanya Kulkarni <kch@nvidia.com>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>,
	martin.petersen@oracle.com, bvanassche@acm.org, david@fromorbit.com,
	damien.lemoal@opensource.wdc.com, anuj20.g@samsung.com,
	joshi.k@samsung.com, nitheshshetty@gmail.com, gost.dev@samsung.com,
	linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-doc@vger.kernel.org, dm-devel@lists.linux.dev,
	linux-nvme@lists.infradead.org, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH v20 00/12] Implement copy offload support
Message-ID: <20240605081407.GA18688@lst.de>
References: <20240604043242.GC28886@lst.de> <393edf87-30c9-48b8-b703-4b8e514ac4d9@suse.de> <5441b256-494a-4344-89fd-ee8c5a073f8b@kernel.org>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5441b256-494a-4344-89fd-ee8c5a073f8b@kernel.org>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Tue, Jun 04, 2024 at 04:39:25PM +0900, Damien Le Moal wrote:
> > But I wasn't aware that this approach is limited to copying within a 
> > single block devices; that would be quite pointless indeed.
> 
> Not pointless for any FS doing CoW+Rebalancing of block groups (e.g. btrfs) and
> of course GC for FSes on zoned devices. But for this use case, an API allowing
> multiple sources and one destination would be better.

Yes.
