Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4BA066CDB1
	for <dm-devel@lists.linux.dev>; Tue, 18 Jun 2024 06:51:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718693479; cv=none; b=slLLUlG0paAxGCgW/huQRmLD7i1gvxEeH9zY57R6abVTR0j311CEGcRKnmvXY7oLK5O9J3jQIBP5qyLGHjm9mjs7AIxtzNXO8LMsfwkxoOXrJ8k5fyVum7BYBvINjRf7ojcEOIuOdsSto3B+iCHXZB1aCHNnUAofg5Cn0jnh3aQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718693479; c=relaxed/simple;
	bh=6BLzS+xoHDbfqDDfZtzzccJPWKtG+Rip0IyP0GUJYTM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=NWTXCnkODePBT7pIe9AqIVLItZWOcfdkauwC5Mu8clNSsogV8NQAlA6mlypKu8dPnAjVRK9BgueMOiqwGUuNxqsALPnNUxZ/iPbW2tNChK+lpn6D8SEOi7RYkeI3mVOLC12YuOFvaEl5/QC4loSgJ3TzU2BfMtnayhhadtpo88Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 70B8D67373; Tue, 18 Jun 2024 08:51:12 +0200 (CEST)
Date: Tue, 18 Jun 2024 08:51:12 +0200
From: Christoph Hellwig <hch@lst.de>
To: Keith Busch <kbusch@kernel.org>
Cc: John Garry <john.g.garry@oracle.com>, axboe@kernel.dk, hch@lst.de,
	sagi@grimberg.me, jejb@linux.ibm.com, martin.petersen@oracle.com,
	viro@zeniv.linux.org.uk, brauner@kernel.org, dchinner@redhat.com,
	jack@suse.cz, djwong@kernel.org, linux-block@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-nvme@lists.infradead.org,
	linux-fsdevel@vger.kernel.org, tytso@mit.edu, jbongio@google.com,
	linux-scsi@vger.kernel.org, ojaswin@linux.ibm.com,
	linux-aio@kvack.org, linux-btrfs@vger.kernel.org,
	io-uring@vger.kernel.org, nilay@linux.ibm.com,
	ritesh.list@gmail.com, willy@infradead.org, agk@redhat.com,
	snitzer@kernel.org, mpatocka@redhat.com, dm-devel@lists.linux.dev,
	hare@suse.de, Himanshu Madhani <himanshu.madhani@oracle.com>
Subject: Re: [PATCH v8 05/10] block: Add core atomic write support
Message-ID: <20240618065112.GB29009@lst.de>
References: <20240610104329.3555488-1-john.g.garry@oracle.com> <20240610104329.3555488-6-john.g.garry@oracle.com> <ZnCGwYomCC9kKIBY@kbusch-mbp.dhcp.thefacebook.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZnCGwYomCC9kKIBY@kbusch-mbp.dhcp.thefacebook.com>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Mon, Jun 17, 2024 at 12:56:01PM -0600, Keith Busch wrote:
> I'm not sure I follow why these two need to be the same. I can see
> checking for 'chunk_sectors % boundary_sectors_hw == 0', but am I
> missing something else?
> 
> The reason I ask, zone block devices redefine the "chunk_sectors" to
> mean the zone size, and I'm pretty sure the typical zone size is much
> larger than the any common atomic write size.

Yeah.  Then again atomic writes in the traditional sense don't really
make sense for zoned devices anyway as the zoned devices never overwrite
and require all data up to the write pointer to be valid.  In theory
they could be interpreted so that you don't get a partical write failure
if you stick to the atomic write boundaries, but that is mostly
pointless.
