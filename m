Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 84D7E18646
	for <dm-devel@lists.linux.dev>; Thu, 28 Mar 2024 04:15:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711599303; cv=none; b=Hw9/3nawhSGAxIK8uLlSgKQgnVV08Nn9rZWgxBKfnnNM10Nf9/sOL+mfXAy3YgFhDyAOoBIiAAtn4pwztKnFiYm2KjVbVprmHdrwDl7bzBifLOO6DPWCv8wbojq4zzdD7ujR1/ne3MNsxpN0tW7GWIR2H1741JWU/8TU+TgjMuA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711599303; c=relaxed/simple;
	bh=Nz2EwgrdhWxI5qI5qy3JP33wYLDuo/vc1tXUvRTKNJ0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=e2P3ixe2eStNIV+JyZBzod4697t+0Mlu7/96SXJfMsZG5X0Ob6KUcktEXsBKoqTkSzAGsZnNNKDd404BAsw33nrdPX6AfbYY4CVGBnLnVKS+Lo1siJRkq9x+zmf5SJyjfQa9M0zxBXWGhCZ0PcSuUjMC81yYF1hT2rI6LiI/PTc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id C984368B05; Thu, 28 Mar 2024 05:14:57 +0100 (CET)
Date: Thu, 28 Mar 2024 05:14:57 +0100
From: Christoph Hellwig <hch@lst.de>
To: Damien Le Moal <dlemoal@kernel.org>
Cc: linux-block@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
	linux-scsi@vger.kernel.org,
	"Martin K . Petersen" <martin.petersen@oracle.com>,
	dm-devel@lists.linux.dev, Mike Snitzer <snitzer@redhat.com>,
	linux-nvme@lists.infradead.org, Keith Busch <kbusch@kernel.org>,
	Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH v3 04/30] block: Introduce blk_zone_update_request_bio()
Message-ID: <20240328041457.GC13510@lst.de>
References: <20240328004409.594888-1-dlemoal@kernel.org> <20240328004409.594888-5-dlemoal@kernel.org>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240328004409.594888-5-dlemoal@kernel.org>
User-Agent: Mutt/1.5.17 (2007-11-01)

> -		if (req_op(req) == REQ_OP_ZONE_APPEND)
> -			bio->bi_iter.bi_sector = req->__sector;
> -
> -		if (!is_flush)
> +		if (!is_flush) {
> +			blk_zone_update_request_bio(req, bio);
>  			bio_endio(bio);
> +		}

As noted by Bart last time around, the blk_zone_update_request_bio
really should stay out of the !is_flush check, as otherwise we'd
break zone appends going through the flush state machine.

Otherwise this looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
