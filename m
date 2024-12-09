Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EAC875588B
	for <dm-devel@lists.linux.dev>; Mon,  9 Dec 2024 07:57:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733731069; cv=none; b=Tfg3FSBf3Xq2qDcce/Qz8CwJ5t/RMoXBbWLloR1mKS+P6OOgfh3MTesFUkrYV3rbtZn/otrpcwShbIgwYmVm6ghfz7JigMUjs28uOUhPKirAeURt7Ihg/HkIfMZ/Pt3qj0kKwfA/pAj6dpYTyCn0065vPrI31egxhORQ+rkLNEI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733731069; c=relaxed/simple;
	bh=VVEj0K8Z+l4MpU+NXXzeoFNJVSbUfDx5x1trX7CLHd4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=d3cQvp+tN4WTJWnox+6CdIcYfIh3abd1UiFBHDDjZ3kiXz0Zv2OzCxyJ+y0DYXh9s+y/zu8SbAhM0H+kTb/GqPD7U3YYvjkAuqGMpWj3SDrJbwEiRZ57fSIu6W1Ya5pMMx1ArH4CdD2jOf7+z5VrUIPN6NDrxUrHTjWnLqKUfSc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 0B7DB68AA6; Mon,  9 Dec 2024 08:57:44 +0100 (CET)
Date: Mon, 9 Dec 2024 08:57:43 +0100
From: Christoph Hellwig <hch@lst.de>
To: Damien Le Moal <dlemoal@kernel.org>
Cc: linux-block@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
	Mike Snitzer <snitzer@kernel.org>,
	Mikulas Patocka <mpatocka@redhat.com>, dm-devel@lists.linux.dev,
	Christoph Hellwig <hch@lst.de>,
	Bart Van Assche <bvanassche@acm.org>
Subject: Re: [PATCH v2 3/4] block: Prevent potential deadlocks in zone
 write plug error recovery
Message-ID: <20241209075743.GD24323@lst.de>
References: <20241208225758.219228-1-dlemoal@kernel.org> <20241208225758.219228-4-dlemoal@kernel.org>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241208225758.219228-4-dlemoal@kernel.org>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Mon, Dec 09, 2024 at 07:57:57AM +0900, Damien Le Moal wrote:
> Avoid this problem by completely getting rid of the need for executing a
> report zone from within the zone write plugging code, instead relying on
> the user either executing a report zones, resetting the zone or
> finishing the zone of a failed write. This is not an unresannable

s/unresannable/unreasonable/ ?

> requirement as all well-behaved applications, FSes and device mapper
> already use report zones to recover from write errors whenever possible.

I think the real question here is what errors the file system (or other
submitter) can even recover from.  The next patch deals with the not
support case for a "special" operation, and that's of course a valid one.
The first patch already excludes EAGAIN from nowait, and the drivers
already retry anything that they think is retryable by just resubmitting
without bubbling it up to the submitter.  That mostly leaves fatal
media errors as all modern hardware that supports zones just remaps
on write media failures.  I.e. for those the most sane answer is to
simply shut down the file system for single-device file systems, or
treat the device as faulty for multi-device file systems.  This might
change when we support logical depop on a per-zone basis, but I don't
think anyone is there yet.  We also really should test this case.
I'll add a testcase with error injection for zoned xfs, and someone
should do the same for btrfs (including multi-device handling) and
f2fs.

Sorry for the long rant - not a comment on the code itself but maybe
the commit log could use a little update.

Also we probably need to recover this information somewhere in the
docs.

