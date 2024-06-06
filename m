Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 36FFC1D53C
	for <dm-devel@lists.linux.dev>; Thu,  6 Jun 2024 04:40:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717648805; cv=none; b=Ze/aYNBrGEX2V5fLIPFWHrLDaijXetAxCMOBwFtbWJgYOt8Rrznh1s3guu1DR56mH0tgMcpcmVa/GW7oasonWyk1UKY1rSc9/sbe9Lm+W33JFXwKoIUWxd5/qZ3CkiTWSKMDNTHl6Y/yiowm78L/Qn7Q42/PrZHsEzwMeRcRN54=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717648805; c=relaxed/simple;
	bh=s0+Rnw3BIOmtEHhpPlqWlyP+AUKh4K1YturoffD+jBI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=oSxxTFC7R3V9xl/2j3FmGv6XDoJvbEMCZ89j/Si0EZw1WKW8vB1jqVV4Il0nzjWH6pGf4Wt0hL+LN8zdR9OXXWo3Bt94J+jZ7DnGg2bnms24sofwq4an4M4z+E6nEzjYKRE1l0iwh3eOQMiT8yOZHCBKocvIq4+VdYh/nXdHNTQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 1C3E268CFE; Thu,  6 Jun 2024 06:39:59 +0200 (CEST)
Date: Thu, 6 Jun 2024 06:39:58 +0200
From: Christoph Hellwig <hch@lst.de>
To: Damien Le Moal <dlemoal@kernel.org>
Cc: Benjamin Marzinski <bmarzins@redhat.com>, Jens Axboe <axboe@kernel.dk>,
	linux-block@vger.kernel.org, dm-devel@lists.linux.dev,
	Mike Snitzer <snitzer@kernel.org>,
	Mikulas Patocka <mpatocka@redhat.com>,
	Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH v4 2/3] dm: Improve zone resource limits handling
Message-ID: <20240606043958.GA8331@lst.de>
References: <20240605075144.153141-1-dlemoal@kernel.org> <20240605075144.153141-3-dlemoal@kernel.org> <ZmDA5fmZMNGM1oFl@redhat.com> <90629a40-e45f-490b-bef6-436839d91b92@kernel.org>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <90629a40-e45f-490b-bef6-436839d91b92@kernel.org>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Thu, Jun 06, 2024 at 08:52:32AM +0900, Damien Le Moal wrote:
> Unless you have a better idea, I think we need to pass a queue_limits struct
> pointer to blk_revalidate_disk_zones() -> disk_update_zone_resources(). This
> pointer can be NULL, in which case disk_update_zone_resources() needs to do the
> limit start_update+commit. But if it is not NULL, then
> disk_update_zone_resources() must use the passed limits.

I think the right thing is to simply move the call to dm_revalidate_zones
out of dm_set_zones_restrictions and after the queue_limits_set call
in dm_table_set_restrictions.

