Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EABF413B78F
	for <dm-devel@lists.linux.dev>; Wed, 26 Jun 2024 05:22:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719379365; cv=none; b=YGpf4Fq9iYPvq1pW+LRD28ZuHKgz3x+MHs+RdXkCU5NFCCyt/GFn6AkHs6K5gJYX1/ZDpiIlvk5hRwN1tCGzQ4GPKk3QbzpzNxYUjVyYazZcZlDLgA2upTHufGNPGwAFJkDi5fBjLIv3MkamUuww7Kla0sTDcQ6HowRnBmUX8t4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719379365; c=relaxed/simple;
	bh=4J1gRg7GEgUIDrpBJA7ovYIvxdiLeq8+P2V7QmUaA58=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=eR94zQiQvDjw7P/JakCdFb2SVuxv5CTxLpVoQ9tVTCUz+htbxAXnSwxajX7iQPGtx1bwqVt4iEUqmGp0HlTe6e6gt/P6dcy/kxy5FE274K6DK2e02bp4U7sJ2cOTZmUVvpI7BV4rU/18wbzU/2EDlwFjHpCAFLdtg3wAXpPPb7Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 04B43227A87; Wed, 26 Jun 2024 07:22:39 +0200 (CEST)
Date: Wed, 26 Jun 2024 07:22:38 +0200
From: Christoph Hellwig <hch@lst.de>
To: Damien Le Moal <dlemoal@kernel.org>
Cc: Bart Van Assche <bvanassche@acm.org>,
	Nitesh Shetty <nj.shetty@samsung.com>,
	Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>,
	Jonathan Corbet <corbet@lwn.net>, Alasdair Kergon <agk@redhat.com>,
	Mike Snitzer <snitzer@kernel.org>,
	Mikulas Patocka <mpatocka@redhat.com>,
	Keith Busch <kbusch@kernel.org>, Sagi Grimberg <sagi@grimberg.me>,
	Chaitanya Kulkarni <kch@nvidia.com>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>,
	martin.petersen@oracle.com, david@fromorbit.com, hare@suse.de,
	damien.lemoal@opensource.wdc.com, anuj20.g@samsung.com,
	joshi.k@samsung.com, nitheshshetty@gmail.com, gost.dev@samsung.com,
	linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-doc@vger.kernel.org, dm-devel@lists.linux.dev,
	linux-nvme@lists.infradead.org, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH v20 02/12] Add infrastructure for copy offload in block
 and request layer.
Message-ID: <20240626052238.GC21996@lst.de>
References: <d7ae00c8-c038-4bed-937e-222251bc627a@acm.org> <20240604044042.GA29094@lst.de> <4ffad358-a3e6-4a88-9a40-b7e5d05aa53c@acm.org> <20240605082028.GC18688@lst.de> <CGME20240624105121epcas5p3a5a8c73bd5ef19c02e922e5829a4dff0@epcas5p3.samsung.com> <6679526f.170a0220.9ffd.aefaSMTPIN_ADDED_BROKEN@mx.google.com> <4ea90738-afd1-486c-a9a9-f7e2775298ff@acm.org> <de54c406-9270-4145-ab96-5fc3dd51765e@kernel.org> <b5d93f2c-29fc-4ee4-9936-0f134abc8063@acm.org> <05c7c08d-f512-4727-ae3c-aba6e8f2973f@kernel.org>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <05c7c08d-f512-4727-ae3c-aba6e8f2973f@kernel.org>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Wed, Jun 26, 2024 at 06:18:18AM +0900, Damien Le Moal wrote:
> 
> DM can deal with "abnormal" BIOs on its own. There is code for that.
> See is_abnormal_io() and __process_abnormal_io(). Sure, that will need more code
> compared to a bio sector+size based simple split, but I do not think it is a big
> deal given the potential benefits of the offloading.

It's not just dm.  You also need it in the partition remapping code
(mandatory), md (nice to have), etc.

And then we have the whole mess of what is in the payload for the I/O
stack vs what is in the payload for the on the wire protocol, which
will have different formatting and potentially also different sizes.
