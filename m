Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 947DF185E4A
	for <dm-devel@lists.linux.dev>; Mon,  3 Nov 2025 13:46:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762177603; cv=none; b=uUQQEaZDBSZg9yZHGLN0Flk/DeCZagw2Jo00IqlPdjJzFyLYmgnvdm2mjRUJ/wmaFDT4f6QCe5Uv39Dz5W6+UViUkt6391imPem+445d6RepfiVJFH+9oKsQWJzQMW71AOcGyCfejP0RfwPHbEFe5WjZoOtRumMEZAhSqs8NynI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762177603; c=relaxed/simple;
	bh=R3c3VoyXxv+yIE4Z1qhuL8CmP/vDMOZ0RfOmwCVkqJI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=VhDJ4uo/rHGi6VoWI/kZrEIqcWj4+kP8+CfeaVag6M2wo/BuXpntTP8OKN9nhfpRgzOovs5r5rPsUCEb4/D4bkaypOmsGUOp9xAGxfGbQn2AG2xZNm3+wF/NhFP01uYltzwK9vpqycxDnTMlLRLfLRfRjnb11CdxVccQHYGHAxw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 55C98227AAA; Mon,  3 Nov 2025 14:46:37 +0100 (CET)
Date: Mon, 3 Nov 2025 14:46:36 +0100
From: Christoph Hellwig <hch@lst.de>
To: Damien Le Moal <dlemoal@kernel.org>
Cc: Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org,
	linux-nvme@lists.infradead.org, Keith Busch <keith.busch@wdc.com>,
	Christoph Hellwig <hch@lst.de>, dm-devel@lists.linux.dev,
	Mike Snitzer <snitzer@kernel.org>,
	Mikulas Patocka <mpatocka@redhat.com>,
	"Martin K . Petersen" <martin.petersen@oracle.com>,
	linux-scsi@vger.kernel.org, linux-xfs@vger.kernel.org,
	Carlos Maiolino <cem@kernel.org>, linux-btrfs@vger.kernel.org,
	David Sterba <dsterba@suse.com>
Subject: Re: [PATCH v2 02/15] block: freeze queue when updating zone
 resources
Message-ID: <20251103134636.GA25126@lst.de>
References: <20251103133123.645038-1-dlemoal@kernel.org> <20251103133123.645038-3-dlemoal@kernel.org>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251103133123.645038-3-dlemoal@kernel.org>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Mon, Nov 03, 2025 at 10:31:10PM +0900, Damien Le Moal wrote:
> Modify disk_update_zone_resources() to freeze the device queue before
> updating the number of zones, zone capacity and other zone related
> resources. The locking order resulting from the call to
> queue_limits_commit_update_frozen() is preserved, that is, the queue
> limits lock is first taken by calling queue_limits_start_update() before
> freezing the queue, and the queue is unfrozen after executing
> queue_limits_commit_update(), which replaces the call to
> queue_limits_commit_update_frozen().
> 
> This change ensures that there are no in-flights I/Os when the zone
> resources are updated due to a zone revalidation. In case of error when
> the limits are applied, directly call disk_free_zone_resources() from
> disk_update_zone_resources() while the disk queue is still frozen to
> avoid needing to freeze & unfreeze the queue again in
> blk_revalidate_disk_zones(), thus simplifying that function code a
> little.
> 
> Fixes: 0b83c86b444a ("block: Prevent potential deadlock in blk_revalidate_disk_zones()")
> Cc: stable@vger.kernel.org
> Signed-off-by: Damien Le Moal <dlemoal@kernel.org>

Still looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

