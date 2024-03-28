Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3155038388
	for <dm-devel@lists.linux.dev>; Thu, 28 Mar 2024 04:13:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711599208; cv=none; b=iw73bXQrPOtfn+coq9+JEWGjdO2nQoJmOHKyKbEN686gOgkdonuk4oEd103iBJxTi2G4VjPwvLxxi8F6j56IuzuKR31mFQWKkHP/AIFfY1QRXazLhwqPXOhSuCqGuL6gC/7WNE96bgsDJW0Hn7WulvTNMA6J8ZQM2wwnPdri0j0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711599208; c=relaxed/simple;
	bh=97n0l9Cye3dcMu//qmNro8xE7Ur6T9BhpinOtQjNjaw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=G0HEIBmow8ff0qgs9SK8zsVU/OE/wLdoFaEiIaX83MblfgMPlyi+b5VVNDK45/2n2KmmLidAzTXjZ1b0tHiMhQV0/cqwVjYwilzGH1Yq3uSSp38ocomrowpZyyHYQccHLQ83O5Af55TGZdTuJATqmqU1rCEnNNAjLHjLkaJpHms=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 3218868B05; Thu, 28 Mar 2024 05:13:23 +0100 (CET)
Date: Thu, 28 Mar 2024 05:13:23 +0100
From: Christoph Hellwig <hch@lst.de>
To: Damien Le Moal <dlemoal@kernel.org>
Cc: linux-block@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
	linux-scsi@vger.kernel.org,
	"Martin K . Petersen" <martin.petersen@oracle.com>,
	dm-devel@lists.linux.dev, Mike Snitzer <snitzer@redhat.com>,
	linux-nvme@lists.infradead.org, Keith Busch <kbusch@kernel.org>,
	Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH v3 03/30] block: Remove req_bio_endio()
Message-ID: <20240328041323.GB13510@lst.de>
References: <20240328004409.594888-1-dlemoal@kernel.org> <20240328004409.594888-4-dlemoal@kernel.org>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240328004409.594888-4-dlemoal@kernel.org>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Thu, Mar 28, 2024 at 09:43:42AM +0900, Damien Le Moal wrote:
> Moving req_bio_endio() code into its only caller, blk_update_request(),
> allows reducing accesses to and tests of bio and request fields. Also,
> given that partial completions of zone append operations is not
> possible and that zone append operations cannot be merged, the update
> of the BIO sector using the request sector for these operations can be
> moved directly before the call to bio_endio().

Note that we should actually be able to support merging zone appends.

And this patch actually moves the assignment to the right place to be
able to deal with it, we'll just need to track the start offset to the
start of the request so that we can assign the right bi_sector.

Reviewed-by: Christoph Hellwig <hch@lst.de>
