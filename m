Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A79E1411EB
	for <dm-devel@lists.linux.dev>; Wed, 22 May 2024 14:25:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716387905; cv=none; b=jjxic/dChX3TUh09uv6kGgevPwBtriE+dl5rVILHjNVeoDsWhzrGtHEpLaAE/zcvJu95vEA9UQqseY6RrAbHXouLqTqqi8G4F48HKJ2WB696nB4/i0RIpc1WISVr3SDufVGcVLOxxhR65uI30aef0KDgpoxBpSDcfplsw33+oR8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716387905; c=relaxed/simple;
	bh=jGkNM8PNzc8L/4cZlVygWeGJw13aAYtwIqd49Vly4IE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=TgPmQYDGfyJvqRoJgoMjrCNfuWz7OJPy3TlaPUHa9aZ+bC+yH4aEGHN6gRyWwpB5/h/5JC9VjjHTWLfhCG7Sm7G9s1+RG7CXetVT1WtBsV2iCsxTqXplm2c2tdsc6wxebE+BOGDC9mYJ18SvVg2nSY8CXFGY1I5pA6LUMDvaMxI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 8725A68BFE; Wed, 22 May 2024 16:24:58 +0200 (CEST)
Date: Wed, 22 May 2024 16:24:58 +0200
From: Christoph Hellwig <hch@lst.de>
To: Mike Snitzer <snitzer@kernel.org>
Cc: dm-devel@lists.linux.dev, linux-block@vger.kernel.org, hch@lst.de,
	Marco Patalano <mpatalan@redhat.com>,
	Ewan Milne <emilne@redhat.com>
Subject: Re: [PATCH] dm: retain stacked max_sectors when setting
 queue_limits
Message-ID: <20240522142458.GB7502@lst.de>
References: <20240522025117.75568-1-snitzer@kernel.org>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240522025117.75568-1-snitzer@kernel.org>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Tue, May 21, 2024 at 10:51:17PM -0400, Mike Snitzer wrote:
> Otherwise, blk_validate_limits() will throw-away the max_sectors that
> was stacked from underlying device(s). In doing so it can set a
> max_sectors limit that violates underlying device limits.

Hmm, yes it sort of is "throwing the limit away", but it really
recalculates it from max_hw_sectors, max_dev_sectors and user_max_sectors.

> 
> This caused dm-multipath IO failures like the following because the
> underlying devices' max_sectors were stacked up to be 1024, yet
> blk_validate_limits() defaulted max_sectors to BLK_DEF_MAX_SECTORS_CAP
> (2560):

I suspect the problem is that SCSI messed directly with max_sectors instead
and ignores max_user_sectors (and really shouldn't touch either, but that's
a separate discussion).  Can you try the patch below and maybe also provide
the sysfs output for max_sectors_kb and max_hw_sectors_kb for all involved
devices?

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index 332eb9dac22d91..f6c822c9cbd2d3 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -3700,8 +3700,10 @@ static int sd_revalidate_disk(struct gendisk *disk)
 	 */
 	if (sdkp->first_scan ||
 	    q->limits.max_sectors > q->limits.max_dev_sectors ||
-	    q->limits.max_sectors > q->limits.max_hw_sectors)
+	    q->limits.max_sectors > q->limits.max_hw_sectors) {
 		q->limits.max_sectors = rw_max;
+		q->limits.max_user_sectors = rw_max;
+	}
 
 	sdkp->first_scan = 0;
 
