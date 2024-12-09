Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A5711E86E
	for <dm-devel@lists.linux.dev>; Mon,  9 Dec 2024 08:39:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733733583; cv=none; b=RIAh5jL9RjLpxtiu5C2EYfRZNPyaWQm+y0kuSGpnRpZqPOkG/AJ72AWyHEhGqxV90CFAr9omuB3K5pN51QHjwYe9Ecv30sdEpQrPpAatGUDVINUE+gDsvPONgPaMoMC5f2ymxtZb235oapQHqDGurzylRxQ/V4hpDj4NfdT48zk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733733583; c=relaxed/simple;
	bh=SdKByV1OrkA0r/x7DWPqeCfXiE8mmQ4wms4zU/ptbTQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Y93m2StId1qT510UkAmt9RTj8RPzj0fJVpLSrsGOIZxTVhdg4Z7w3x9n5F8JLxKo4JMfbWDooE6xx0RB3unuHBJk/2ZWfoHSSYaD5h2ME7JwAcLKmo2OwiRJ5X81VgXFkASZW1j783VTOAer+QSn+kJW5L9h1WB98l1fUEDocFE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 7C46868AA6; Mon,  9 Dec 2024 09:39:38 +0100 (CET)
Date: Mon, 9 Dec 2024 09:39:38 +0100
From: Christoph Hellwig <hch@lst.de>
To: Damien Le Moal <dlemoal@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, linux-block@vger.kernel.org,
	Jens Axboe <axboe@kernel.dk>, Mike Snitzer <snitzer@kernel.org>,
	Mikulas Patocka <mpatocka@redhat.com>, dm-devel@lists.linux.dev,
	Bart Van Assche <bvanassche@acm.org>
Subject: Re: [PATCH v2 4/4] dm: Fix dm-zoned-reclaim zone write pointer
 alignment
Message-ID: <20241209083938.GA27113@lst.de>
References: <20241208225758.219228-1-dlemoal@kernel.org> <20241208225758.219228-5-dlemoal@kernel.org> <20241209074408.GA24323@lst.de> <56ee11bb-0dbc-4498-a529-b2f47e92e934@kernel.org>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <56ee11bb-0dbc-4498-a529-b2f47e92e934@kernel.org>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Mon, Dec 09, 2024 at 05:38:40PM +0900, Damien Le Moal wrote:
> 
> The problem with doing that is that there is absolutely nothing to patch/fix
> before the previous patch, since the "recovery/report zones" was done
> automatically. So if anything, maybe I should just squash this patch together
> with the previous one to be consistent against bisect ? That does make sense
> since this patch is needed *because* of the previous patch change.

But it's also harmless to do the extra zone report.  So just state that
in the commit log.

