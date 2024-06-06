Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E2C8440C
	for <dm-devel@lists.linux.dev>; Thu,  6 Jun 2024 05:56:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717653376; cv=none; b=dS8RzT2nprUePkittJqcQxExgN2nYONrWRjz8aMVyRxsjg9T++eiNTO0MZNSsg5GbBSnFxWbIOUhrbr8rNVAQapjYWS9+2uMDeJdQ42MO0PB4gnVO1SAdTTQarMecW6pp6eyO+p3DzHlk/o8tE9Uot2E7DvjFrNAuGz20zaTtgg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717653376; c=relaxed/simple;
	bh=+onNZkVXBC2e2U49WLtGBQYSo60QizKXolbb1+gx7Z0=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=Ga/ndjamE4dfbG3IGZxfYawh6t5ZILvUxBby1ozCxlXRO7WE56zGosfGPafCkK2HyKlZ6d75Ho3Cm6/fhe6XyJN328Pv7jI4YxYfToKNl2fguBzYd2wzYLxykiywi5Ctyn2l8TOR5ojww3Vibmh+6GEKkl4ArXqc110eEDXY488=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 6AACE68CFE; Thu,  6 Jun 2024 07:56:11 +0200 (CEST)
Date: Thu, 6 Jun 2024 07:56:11 +0200
From: Christoph Hellwig <hch@lst.de>
To: Nitesh Shetty <nj.shetty@samsung.com>
Cc: Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>,
	Jonathan Corbet <corbet@lwn.net>, Alasdair Kergon <agk@redhat.com>,
	Mike Snitzer <snitzer@kernel.org>,
	Mikulas Patocka <mpatocka@redhat.com>,
	Keith Busch <kbusch@kernel.org>, Sagi Grimberg <sagi@grimberg.me>,
	Chaitanya Kulkarni <kch@nvidia.com>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>,
	martin.petersen@oracle.com, bvanassche@acm.org, david@fromorbit.com,
	hare@suse.de, damien.lemoal@opensource.wdc.com,
	anuj20.g@samsung.com, joshi.k@samsung.com, nitheshshetty@gmail.com,
	gost.dev@samsung.com, linux-block@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
	dm-devel@lists.linux.dev, linux-nvme@lists.infradead.org,
	linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH v20 03/12] block: add copy offload support
Message-ID: <20240606055611.GA9404@lst.de>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17 (2007-11-01)

On Tue, Jun 04, 2024 at 10:50:26AM +0000, Nitesh Shetty wrote:
>>> +	if (!cio)
>>> +		return -ENOMEM;
>>> +	atomic_set(&cio->refcount, 1);
>>> +	cio->waiter = current;
>>> +	cio->endio = endio;
>>> +	cio->private = private;
>>
>> For the main use this could be allocated on-stack.  Is there any good
>> reason to not let callers that really want an async version to implement
>> the async behavior themselves using suitable helpers?
>>
> We cannot do on-stack allocation of cio as we use it in endio handler.
> cio will be used to track partial IO completion as well.
> Callers requiring async implementation would need to manage all this
> bookkeeping themselves, leading to duplication of code. We felt it is
> better to do it here onetime.
> Do you see it any differently ?

We don't really to these async variants for other in-kernel I/O,
so unless we have a really good reason I'd not do here.  The usual
approach is to just have a submission helper for async in-kernel
special bios types, and the let the caller handle the rest.

