Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C2BFAD48;
	Sat,  1 Jun 2024 05:33:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717219994; cv=none; b=NDYA3DFlpWTBBNa7V0RpYcY/frrUBj8d7XabYjbsSGj6MhWa7xuID4jSokiFn3Cup0auY2kcgrXWjz/ih4uowaAmlbOtmYqeo9zU5FqJ4ZGMynw3wLeXn8WXBWAMRM3p/GS29QmgfZS0+9uhrV2is/mV4J71G7VTtHQlcFI3PC0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717219994; c=relaxed/simple;
	bh=o4pHWcHtgJxiyyy708U3PriU5bOsZ7OLzfRvP92xDvU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Kk8APe/IX804TTXvw3YCWyJEqrmZsN4t6jtH93ArGTP0oJuX6PX+2lG4WjBM97l21qaGaONPSYznf1UgXuVje3/P/c9I1NMwBZqazpeXfG8S8Dri/yo8jW/SdEUZIhrRBXMatP+1sGdPxgq7UEJqfJSmcUmGZhcUO+EOAIVS4xo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=T0tkQnMV; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="T0tkQnMV"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=t2ftrZMTlC34K7RpgH4uiUpTXnEh/Jdia8mg/MgpRug=; b=T0tkQnMVlNWw4+z6Puu6UlBqdg
	D1O8gVEW5MspyayJBrsc9TFGd19LmYcYn0WPk8GVo/QgHinbWJ0uMgZ4UM7eF2AhK8bycNdRy0+2L
	m+petQ3Zkf46dlE+RF0/WI78J6wxombXLq/+MmuYccNFl63VN85EE0s/kiq0c0Nd4uuyzrEkIXS4j
	RBePfZQSsy2NDe16BzV4d2Aa1ao0ehAd0pYWiY9/6/CZc1vpWP8Nijp17TMfHgtcbow/N0eegR49L
	6O8Ihk/JnYSdWQdI8u5mF5dnBK2ZEN21vrbLUxuG3RZuRN1Xs6WbTv/OdXk/3vtBDaYVQy9Vj2E8V
	2P/O+97A==;
Received: from hch by bombadil.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1sDHMe-0000000C0jc-27FL;
	Sat, 01 Jun 2024 05:33:12 +0000
Date: Fri, 31 May 2024 22:33:12 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Benjamin Marzinski <bmarzins@redhat.com>
Cc: Damien Le Moal <dlemoal@kernel.org>, Jens Axboe <axboe@kernel.dk>,
	linux-block@vger.kernel.org, dm-devel@lists.linux.dev,
	Mike Snitzer <snitzer@kernel.org>,
	Mikulas Patocka <mpatocka@redhat.com>
Subject: Re: [PATCH 4/4] dm: Improve zone resource limits handling
Message-ID: <ZlqymFGC8Wy4Hp7v@infradead.org>
References: <20240530054035.491497-1-dlemoal@kernel.org>
 <20240530054035.491497-5-dlemoal@kernel.org>
 <ZlokTjm-l-7NWyhV@redhat.com>
 <ZlqxqZqixQ_POHvc@infradead.org>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZlqxqZqixQ_POHvc@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Fri, May 31, 2024 at 10:29:13PM -0700, Christoph Hellwig wrote:
> On Fri, May 31, 2024 at 03:26:06PM -0400, Benjamin Marzinski wrote:
> > Does this mean that if a dm device was made up of two linear targets,
> > one of which mapped an entire zoned device, and one of which mapped a
> > single zone of another zoned device, the max active zone limit of the
> > entire dm device would be 1? That seems wrong.
> 
> In this particular case it is a bit supoptimal as the limit could be
> 2, but as soon as you add more than a single zone of the second
> device anything more would be wrong.

Actually even for this case it's the only valid one, sorry.
