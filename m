Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 86DE5129A71
	for <dm-devel@lists.linux.dev>; Tue, 26 Mar 2024 07:08:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711436926; cv=none; b=Fv64q0g3Pl01IU6mifd5ozE8EI+JttjbTY9GlxfbWKRORZ+eUT1Wwd5YGHdxvakKzOTQS4fBZuRtRdX3yA7+//Iba4xbfv0JvGNi7ZlM2X+u+0JkQA/YP43GdoW6Z6LC8CIA4AiNf6ZyqWhL8Yr6jKBGW3DfDB+SLeKlzyAh548=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711436926; c=relaxed/simple;
	bh=2pybxWgI9/v8JH1oxbOlq0Vrixo/FGASPZm0L+AgdPU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ZpjDgTUXUdFyE0QfzxTCjLz7evJgjHHJlP8mN3j4OecQ2q8hcoWl3QLuo1pTU6t9iWlXlBjDOE/Ee/a0mHsieLbF6NykNQBIA/FTf4n0EtjZv/7Mf/inIDMbmffYIb528/rPURXxvAgRDmcGd0i0x5qxxYgsOZgZoY3QjZAktsI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 3EE9768D45; Tue, 26 Mar 2024 08:08:40 +0100 (CET)
Date: Tue, 26 Mar 2024 08:08:38 +0100
From: Christoph Hellwig <hch@lst.de>
To: Damien Le Moal <dlemoal@kernel.org>
Cc: linux-block@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
	linux-scsi@vger.kernel.org,
	"Martin K . Petersen" <martin.petersen@oracle.com>,
	dm-devel@lists.linux.dev, Mike Snitzer <snitzer@redhat.com>,
	Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH v2 12/28] block: Allow BIO-based drivers to use
 blk_revalidate_disk_zones()
Message-ID: <20240326070838.GA8402@lst.de>
References: <20240325044452.3125418-1-dlemoal@kernel.org> <20240325044452.3125418-13-dlemoal@kernel.org>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240325044452.3125418-13-dlemoal@kernel.org>
User-Agent: Mutt/1.5.17 (2007-11-01)

> +	/*
> +	 * For devices using a BIO-based driver, we need zone resources only
> +	 * if zone append emulation is required.
> +	 */
> +	if (!queue_is_mq(disk->queue) &&
> +	    !queue_emulates_zone_append(disk->queue))
> +		return 0;
> +

This code and the comment is duplicated in two places.  It also fails
to capture why bio drivers don't need zoned resources - that is that
we can't enforce QD=1 per zone for them.  Maybe add a little helper
to encapsulate this check and expand the comment a little?

Otherwise looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
