Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E927A38FA6
	for <dm-devel@lists.linux.dev>; Tue, 18 Mar 2025 06:56:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742280970; cv=none; b=q/Xvjl1HYUVJLG+1yeAeK++6e6+2rXzII8DcwY7NPDPHFytcl5oQ/5pq6Mxc4c2bASy5mugfECmvBMEuSzd2CSq8nYWjQZ61TsRsE31GE81tN09hAs0W4P9HLnhH4p4wL1Ht2wp3ktvQo352bfXc6KA8AzzYMFMWE0HULLiJ7wo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742280970; c=relaxed/simple;
	bh=aRyJA/UjGdbf/EBp1G8/i1DE3KvtKDiRKzJR6mkoqRA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=XVr3dFPZYp9rXhtoMeiwlkg5XOGGQLefVP2zb180/YjXNTDqeS3zvtDLsRPSH8TibPGbIryMHqrpk8qNXW8CRaj3XSf1s717grdILO+VoDgoqfZbHkDt6pemcDv9yYVHhx4rY07CcoaFxkjN5IMvCxePDqI3sgUkp+LjStYTQu8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 1C02468AA6; Tue, 18 Mar 2025 07:56:04 +0100 (CET)
Date: Tue, 18 Mar 2025 07:56:03 +0100
From: Christoph Hellwig <hch@lst.de>
To: Benjamin Marzinski <bmarzins@redhat.com>
Cc: Mikulas Patocka <mpatocka@redhat.com>,
	Mike Snitzer <snitzer@redhat.com>, Jens Axboe <axboe@kernel.dk>,
	dm-devel@lists.linux.dev, linux-block@vger.kernel.org,
	Damien Le Moal <dlemoal@kernel.org>, Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH v2 3/6] block: make queue_limits_set() optionally
 return old limits
Message-ID: <20250318065603.GA16259@lst.de>
References: <20250317044510.2200856-1-bmarzins@redhat.com> <20250317044510.2200856-4-bmarzins@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250317044510.2200856-4-bmarzins@redhat.com>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Mon, Mar 17, 2025 at 12:45:07AM -0400, Benjamin Marzinski wrote:
> A future device-mapper patch will make use of this new argument. No
> functional changes intended in this patch.

If you care about the old limits just use a queue_limits_start_update +
queue_limits_commit_update{,frozen} pair.

