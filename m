Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C7F8F79D2
	for <dm-devel@lists.linux.dev>; Mon,  8 Apr 2024 05:55:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712555754; cv=none; b=U8iM5uKWjkuNR2njq/KRD8eS0DCz0L+mkokkAlHXITX/u1h9kkp0TsH5tmE8X0ktzFR4f6AO35gs4hheM6Q3FIfXmUjYDSJc8o652ElKyNaLQpOwX3ZiQE4yaLgOe7BgIf92xuwQqaWR/n1ecZMhkaCyRHrA6hNAHKkRWF/A+KA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712555754; c=relaxed/simple;
	bh=b+VkKA2yQo6n7SotgcslEbc+sX5DKfbisRA6JJHlkzQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=rfvM6IJE+P/ZPhBEttFnlERnWkyviisDuGHbVYDKX0gouzA1cslZNbPcfB4tyi2TDZk3dXZLSGUd22gMgIYlSY3yw9TqwhSRyKkWw3zffKE48XxZASLp+Eb6vbg74Zq3DPpt8cr3URJxkrjuXUDoorwYmNYF+K0k3a8Pns2U1aM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id C70E068C4E; Mon,  8 Apr 2024 07:55:42 +0200 (CEST)
Date: Mon, 8 Apr 2024 07:55:42 +0200
From: Christoph Hellwig <hch@lst.de>
To: Ming Lei <ming.lei@redhat.com>
Cc: Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org,
	janpieter.sollie@edpnet.be, Christoph Hellwig <hch@lst.de>,
	Mike Snitzer <snitzer@kernel.org>, dm-devel@lists.linux.dev,
	Song Liu <song@kernel.org>, linux-raid@vger.kernel.org
Subject: Re: [PATCH] block: allow device to have both virt_boundary_mask
 and max segment size
Message-ID: <20240408055542.GA15653@lst.de>
References: <20240407131931.4055231-1-ming.lei@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240407131931.4055231-1-ming.lei@redhat.com>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Sun, Apr 07, 2024 at 09:19:31PM +0800, Ming Lei wrote:
> When one stacking device is over one device with virt_boundary_mask and
> another one with max segment size, the stacking device have both limits
> set. This way is allowed before d690cb8ae14b ("block: add an API to
> atomically update queue limits").
> 
> Relax the limit so that we won't break such kind of stacking setting.

No, this is broken as discussed before.  With a virt_boundary_mask
we create a segment for every page (that is device page, which usually
but not always is the same as the Linux page size).  If we now also
limit the segment size, we fail to produce valid I/O.

The problem is that that neither the segment_size nor the
virtual_boundary should be inherited by a stackable device and we
need to fix that.

