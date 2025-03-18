Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE0533CF58
	for <dm-devel@lists.linux.dev>; Tue, 18 Mar 2025 06:57:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742281047; cv=none; b=AXUyKnpf8us0P6CBGHPo1BnfKc5sRER/HEYa2DoYnheVQ1e+pwgDankNv+F6iZWSvrPXz2eZ6/WrasCMfVXpETdAU04l4nZfc5SDwycNjDxAL0ZJp7jOKYXCine1sQr6zEHiO/Mfwn2W5sV/lWxKMDRemoG6TcWJDbMrSbNMSeQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742281047; c=relaxed/simple;
	bh=YRwarG1OFjNmx3/ag5OOVXC2S/PiZbX9Cxrz0Y6HGGw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=IYBk6Xv4inkCDUIXuY2JO1Aszz0txA/Cpnsu+Rse3/LVEoXHjvvRl14V0EsVgOjur0RONe1n0V2hEzrYnaZP0RAncGEysCX4NHgJbtONMskQAhlgG/IwAJbGcCbf4nRiaQJg+bps4fWTrhROJgLGrzeOig96V8ixsu+Y294+3cs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 0B24168B05; Tue, 18 Mar 2025 07:57:22 +0100 (CET)
Date: Tue, 18 Mar 2025 07:57:21 +0100
From: Christoph Hellwig <hch@lst.de>
To: Benjamin Marzinski <bmarzins@redhat.com>
Cc: Mikulas Patocka <mpatocka@redhat.com>,
	Mike Snitzer <snitzer@redhat.com>, Jens Axboe <axboe@kernel.dk>,
	dm-devel@lists.linux.dev, linux-block@vger.kernel.org,
	Damien Le Moal <dlemoal@kernel.org>, Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH v2 5/6] dm: fix dm_blk_report_zones
Message-ID: <20250318065721.GB16259@lst.de>
References: <20250317044510.2200856-1-bmarzins@redhat.com> <20250317044510.2200856-6-bmarzins@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250317044510.2200856-6-bmarzins@redhat.com>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Mon, Mar 17, 2025 at 12:45:09AM -0400, Benjamin Marzinski wrote:
> __bind(). Otherwise the zone resources could change while accessing
> them. Finally, it is possible that md->zone_revalidate_map will change
> while calling this function. Only read it once, so that we are always
> using the same value. Otherwise we might miss a call to
> dm_put_live_table().

This checking for calling context is pretty ugly.  Can you just use
a separate report zones helper or at least a clearly documented flag
for it?

