Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 76C021E51A
	for <dm-devel@lists.linux.dev>; Fri, 23 Feb 2024 17:41:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708710073; cv=none; b=nlnUDANPqp5SBB9z3xJVSTTAi1rhvHr6njfqlqNphpm3keY2zsmycK/qaohuEUZqfG+1+hD9ecWgDOSLZIURHSP24rf24GMbMES+U+YOCD+UMD7xBoc5GGw7RaVhLeFlHQFobmvcjRus9lejIc4qN40dDMD0/64/JeumlEoJMHY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708710073; c=relaxed/simple;
	bh=nH527Z6uZQjSMCf5Ca2ur6vZP8nbuTasR+ws194bvH4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=HyLJ6aCoUDBF+xss8r9/Ug89x9UHcdWsA1mwDD7MgcGWoBju6C00NZoYKqo2vQXM3J4Y2GJtcyxXfIR4JKhE8bVhEG5OatqlM1DkUM4J6P7OmxEvOQhAvymZyMiDwxLNQuQUol5U7i6E45bm1TSq45sylx4joD9N/3efnUnJP1Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id AD2FB68B05; Fri, 23 Feb 2024 18:41:05 +0100 (CET)
Date: Fri, 23 Feb 2024 18:41:05 +0100
From: Christoph Hellwig <hch@lst.de>
To: Mike Snitzer <snitzer@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>,
	Mikulas Patocka <mpatocka@redhat.com>, Song Liu <song@kernel.org>,
	Yu Kuai <yukuai3@huawei.com>, dm-devel@lists.linux.dev,
	linux-block@vger.kernel.org, linux-raid@vger.kernel.org
Subject: Re: atomic queue limit updates for stackable devices
Message-ID: <20240223174105.GA5687@lst.de>
References: <20240223161247.3998821-1-hch@lst.de> <ZdjXsm9jwQlKpM87@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZdjXsm9jwQlKpM87@redhat.com>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Fri, Feb 23, 2024 at 12:36:50PM -0500, Mike Snitzer wrote:
> Which DM testsuite are you trying?  There is the old ruby-based
> "device-mapper-test-suite",

Yes.

> and a newer one written in python which
> should hopefully be less hassle to setup and run, see:
> https://github.com/jthornber/dmtest-python

Oh, I didn't know that one.  I'll give it a spin, and maybe the
lvm2 one as well.
