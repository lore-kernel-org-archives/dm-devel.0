Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2DC3314374B;
	Tue, 30 Apr 2024 15:31:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714491113; cv=none; b=Vaq6DLV+jtpUm5Vnu2eKp9O/WvPrWvVMmQuD9hTCgk0qVfP1n87vvgMo5mMAIXn4HDcMvm7jL5gQbZhQvbsNp9ILKLUrL6TdPwdrvdhfcfRSwxAZED+L3K5OL9ualA1XtwyLcngfUimwY5w3ctqU9wxA2GNk8zBAvn4tezerJdE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714491113; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=kiM3y6bYntEX8xf8wWqvvVXZBwE/Xp7kEJCv1szHYzW8tHZz0BixMgJZv/K9k9R8nDdVxHs1KShW/1UAW4dobndATP6fuIBx8aTldngfnmPnXUke+G4kXQFMHLyisySR4vD/cYaY3LNXYsDrvjzKZKjNURN8uzCqK/J5HRuEvl4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=wlLBzDeJ; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="wlLBzDeJ"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=wlLBzDeJ21aYSXZR9NRQ9N6h13
	DVGliZqo+q938SIHDqUaurP11QlsBDNJioTLQglpKlut6STIgw7w0cuyvrf4CY5lb5XPwn9kln4T2
	WRUkKIKNMoJmkvP5xHZqxm9z4W8si8POO7CIg7caOT8digPFeN+xfN41f3g6nNRFspMXjquFZRH3D
	i5MeiQ2NA/VNegmDQoY4eeXg54qyXWj9rgQbra0WlISzVVXb2EumHVlf2yHuPThIEI4q5giTXWWk5
	Oue7cBBvANCqySbc/kmWjY/Pujj7nlBVuZmBhiH52WETrMaiaUz5cIxsM6CtOAPsGw4LpV5lWw0wo
	LnjmZ9DA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1s1pSR-000000073Yt-3H85;
	Tue, 30 Apr 2024 15:31:51 +0000
Date: Tue, 30 Apr 2024 08:31:51 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Damien Le Moal <dlemoal@kernel.org>
Cc: linux-block@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
	dm-devel@lists.linux.dev, Mike Snitzer <snitzer@redhat.com>
Subject: Re: [PATCH 06/13] block: Unhash a zone write plug only if needed
Message-ID: <ZjEO5wyZWa9S_AUl@infradead.org>
References: <20240430125131.668482-1-dlemoal@kernel.org>
 <20240430125131.668482-7-dlemoal@kernel.org>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240430125131.668482-7-dlemoal@kernel.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

