Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 777C017729
	for <dm-devel@lists.linux.dev>; Tue, 27 Feb 2024 14:36:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709044592; cv=none; b=Iefr4SrfQ6n9L8WKM/6YrFQBhBJsKv903jJ0nmVjLeLhs4beu1vpUFSm9hlC0FqbGixH7IyAmymXDpdr/pVJ7rHwxrHsnoy59U6sogHxemavMlInBd/t/PfKZPA3drb8XRIFx/vR1z3DqvhapIaMlTcdUIKbIlH+BMI3Rtu+lY4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709044592; c=relaxed/simple;
	bh=6nSmZPwtPfoXD6gDTr/6NvKuDQP2FkJUdq8tBsnfMCY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=TZuzTIHHf4r12Kh8tm7NgWuF/v+mPdWVsIHKqTA/XF2hse2Uo4jiRZv7XG1zi4f+yYGd7azeKt9ke+e9HzE5lXxV5AKuWWNqXVlIqRm1F1rdHUqrExiOF6ACKCRCkwiJ+5gtM17MK+/JVfAd58ZPx9Jk2OND2qaqTBuHhfEz4IY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 06FAC68D05; Tue, 27 Feb 2024 15:36:19 +0100 (CET)
Date: Tue, 27 Feb 2024 15:36:18 +0100
From: Christoph Hellwig <hch@lst.de>
To: Yu Kuai <yukuai1@huaweicloud.com>
Cc: Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>,
	Mike Snitzer <snitzer@kernel.org>,
	Mikulas Patocka <mpatocka@redhat.com>, Song Liu <song@kernel.org>,
	Philipp Reisner <philipp.reisner@linbit.com>,
	Lars Ellenberg <lars.ellenberg@linbit.com>,
	Christoph =?iso-8859-1?Q?B=F6hmwalder?= <christoph.boehmwalder@linbit.com>,
	drbd-dev@lists.linbit.com, dm-devel@lists.linux.dev,
	linux-block@vger.kernel.org, linux-raid@vger.kernel.org,
	"yukuai (C)" <yukuai3@huawei.com>
Subject: Re: [PATCH 04/16] md: add queue limit helpers
Message-ID: <20240227143618.GA13570@lst.de>
References: <20240226103004.281412-1-hch@lst.de> <20240226103004.281412-5-hch@lst.de> <6eb1741e-f336-bfb1-6549-21374ee667fc@huaweicloud.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6eb1741e-f336-bfb1-6549-21374ee667fc@huaweicloud.com>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Mon, Feb 26, 2024 at 07:38:17PM +0800, Yu Kuai wrote:
> Any reason to use blk_mq_freeze/unfreeze_queue ? I don't think this is
> meaningful for raid, this only wait for IO submission, not IO done.
>
> raid should already handle concurrent IO with reshape, so I think this
> can just be removed.

We can't just change limits under the driver if I/Os are being sumitted.
That is one of the points of the whole queue limits exercises.

