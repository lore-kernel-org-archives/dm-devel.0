Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A16AA3DB89
	for <dm-devel@lists.linux.dev>; Mon, 11 Mar 2024 13:04:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710162279; cv=none; b=pbnCo8nK9Ibi0P6YXlGBj5jVJidURigPCluNqsK1WJ0NJ1FdoBQ6Vsc39RkAgbye4g1/cpmMTS1LkWJbc3o9Edogc6Wa/SRN570ndK0eVIqh15u2n7/A6mcXHvHNE1tlASw6H5tdDL5AUbb6FWrE+nvSyCXrxpnlDrK/g5As1b0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710162279; c=relaxed/simple;
	bh=++Gp6C42tzaKyWhOc5VDokIfmbYw8dobPaaMBRubeL4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=bjZa87QHivgCmtHdd0AXKCrlx8/uHwYteWsjrA1GKVV80w1DpL/zxa2Vl21tkz855+rpGMtWe3mNfSdjHXj2IyNHva9H7Ze2l8O8r6oinHCOleErdZHLxz2s48GcW8CxyKH9AA2u9L58JJmVJ37mtvJzOF4Jp/TI+t9N0PHirTU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id BC5B368B05; Mon, 11 Mar 2024 14:04:27 +0100 (CET)
Date: Mon, 11 Mar 2024 14:04:27 +0100
From: Christoph Hellwig <hch@lst.de>
To: Mike Snitzer <snitzer@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, axboe@kernel.dk, agk@redhat.com,
	mpatocka@redhat.com, dm-devel@lists.linux.dev,
	linux-block@vger.kernel.org
Subject: Re: dm: set the correct discard_sectors limit
Message-ID: <20240311130427.GA31285@lst.de>
References: <20240309164140.719752-1-hch@lst.de> <ZeyrYB-XKa08P-2F@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZeyrYB-XKa08P-2F@redhat.com>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Sat, Mar 09, 2024 at 01:33:04PM -0500, Mike Snitzer wrote:
> That 2015 commit (0034af036554) was really ham-handed, not sure how
> I've remained unaware of this duality (with soft and hard discard
> limits) until now BUT there is quite a bit of DM code that only
> concerns itself with max_discard_sectors and discard_granularity.

Yes.

> Anyway, I'm not quite sure what you're referring to, only code that is
> still setting max_discard_sectors is drivers/md/dm.c:disable_discard

I mean all the places that I've updated to set max_discard_sectors
really should be setting max_hw_discard_sectors.  The rutime-
disabling of discard/write_zeroes/secure_discard on failure will
get new helpers one the atomic queue limits conversion is finished.

> 
> > This fixes a regression where dm bio poison v1 warns about exceeding
> > the discard bio size when running xfstests generic/500.
> 
> Meaning max_discard_sectors > max_hw_discard_sectors? What changed to
> expose this?

queue_limits_set now always recalculates max_discard_sectors from
max_hw_discard_sectors and max_user_discard_sectors.  So if a driver
sets max_discard_sectors but not max_hw_discard_sectors it will
simply be overriden.
