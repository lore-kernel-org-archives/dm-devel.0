Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 701512594
	for <dm-devel@lists.linux.dev>; Sat,  1 Jun 2024 05:47:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717220830; cv=none; b=M4mYaOYbknZrD5PPT2j7YSerJBPEfCU4gyj2sznsaGekSG5ainDriGTunbUJce7d93E8MQ6t7VMu+WPSwGVnAFTWx6VH/qcbAX41MuZI3hbo1j8T+Y8UNeAMyNGsZsQVyl+A34vPTxaDP3hjvUkdBK0SUwLekFmRGdgbFPYOjfQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717220830; c=relaxed/simple;
	bh=CJ+CsOuKaOOry5C1Al6fTmEmJSHrJIOhjAx91ykVv6Q=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=JwODOnmyj7G4NMMzpbRLx0pgSoUyuR+zAs73Os4gSv2GRORwzs2qGE2YBgHFEqDMR03wbYRurCSJMGbN1XxfF3UnuPwKuDVHWItUArNUvAIWopYxLGkXlyIhqSy/QhD8ZTHU61gjLbbyWk/dSnLh/dSEWynZK6cMMlQWCBQ+V30=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 3EE1068D17; Sat,  1 Jun 2024 07:47:02 +0200 (CEST)
Date: Sat, 1 Jun 2024 07:47:01 +0200
From: Christoph Hellwig <hch@lst.de>
To: Nitesh Shetty <nj.shetty@samsung.com>
Cc: Jens Axboe <axboe@kernel.dk>, Jonathan Corbet <corbet@lwn.net>,
	Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@kernel.org>,
	Mikulas Patocka <mpatocka@redhat.com>,
	Keith Busch <kbusch@kernel.org>, Christoph Hellwig <hch@lst.de>,
	Sagi Grimberg <sagi@grimberg.me>,
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
Subject: Re: [PATCH v20 00/12] Implement copy offload support
Message-ID: <20240601054701.GA5613@lst.de>
References: <CGME20240520102747epcas5p33497a911ca70c991e5da8e22c5d1336b@epcas5p3.samsung.com> <20240520102033.9361-1-nj.shetty@samsung.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240520102033.9361-1-nj.shetty@samsung.com>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Mon, May 20, 2024 at 03:50:13PM +0530, Nitesh Shetty wrote:
> So copy offload works only for request based storage drivers.

I don't think that is actually true.  It just requires a fair amount of
code in a bio based driver to match the bios up.

I'm missing any kind of information on what this patch set as-is
actually helps with.  What operations are sped up, for what operations
does it reduce resource usage?

Part of that might be that the included use case of offloading
copy_file_range doesn't seem particularly useful - on any advance
file system that would be done using reflinks anyway.

Have you considered hooking into dm-kcopyd which would be an
instant win instead?  Or into garbage collection in zoned or other
log structured file systems?  Those would probably really like
multiple source bios, though.
