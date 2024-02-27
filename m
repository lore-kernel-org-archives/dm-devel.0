Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A57C513B797
	for <dm-devel@lists.linux.dev>; Tue, 27 Feb 2024 15:17:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709047061; cv=none; b=ECgXqK/0ADOw3IU7ksUkmwqvPzlrhJPoX9x6lms+GE/Q8BwNjlId2DDCxn5PlQ8+yGF4V0NBpWDWGw2Oo4+OA70ppCfhWOGiCZEJ9VZj3B6r96Lae0srXG95JAsN5s3dYmn1Xe4OvP123+ZtjMxaRpfdWrZF1IGi5gSAhod5gqM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709047061; c=relaxed/simple;
	bh=4I4cVszX3kYJgYAK/hiA2vKPVdn/wWDSO8Q+cbMnPjc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Y3VtmcaroRP1hezfDNxwX3+RrS0r4PGPTyGmwTogVrwdtToSsrajHAPGR/uVqGnkvLJEaBUkSyyIls2lQW2Wf02GeJ4kBm5z3cHbbozK+CnMCftvhiCLoq9/1j5bxJpK8Yz1hj3MtVpar9dEvUC9GQQp/n6Wf0iYSB0NP2EpCTw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 21A4E68D07; Tue, 27 Feb 2024 16:17:35 +0100 (CET)
Date: Tue, 27 Feb 2024 16:17:34 +0100
From: Christoph Hellwig <hch@lst.de>
To: Mike Snitzer <snitzer@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>,
	Mikulas Patocka <mpatocka@redhat.com>, Song Liu <song@kernel.org>,
	Yu Kuai <yukuai3@huawei.com>, dm-devel@lists.linux.dev,
	linux-block@vger.kernel.org, linux-raid@vger.kernel.org
Subject: Re: atomic queue limit updates for stackable devices
Message-ID: <20240227151734.GA14628@lst.de>
References: <20240223161247.3998821-1-hch@lst.de> <ZdjXsm9jwQlKpM87@redhat.com> <ZdjYJrKCLBF8Gw8D@redhat.com> <20240227151016.GC14335@lst.de> <Zd38193LQCpF3-D0@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Zd38193LQCpF3-D0@redhat.com>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Tue, Feb 27, 2024 at 10:16:39AM -0500, Mike Snitzer wrote:
> That's the mainline issue a bunch of MD (and dm-raid) oriented
> engineers are working hard to fix, they've been discussing on
> linux-raid (with many iterations of proposed patches).
> 
> It regressed due to 6.8 MD changes (maybe earlier).


Do you know if there is a way to skip specific tests to get a useful
baseline value (and to complete the run?)
