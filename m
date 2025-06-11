Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D27226BFCE
	for <dm-devel@lists.linux.dev>; Wed, 11 Jun 2025 03:29:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749612551; cv=none; b=GfgOYn4JniJ7c40N2QUxE9lwn3S7OvmSjjB5tlEV4Ndv3TxALAwh5m6lJ2HNjO0SfG52dPkxYZmawYwSXxj3tet0izBlGkX9LPgqXw11yg5YfKXXZ4FBxWHjQDxAbWqyk0R7atNcNvOsh2JyTJQt6IKRgX39SHkQqy262Rpu7Qg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749612551; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Jz0lAMdeAHKKmkXl6bl55didCdwy3q5v+AAzas3hqIw7FOV7lyO2S/lItvNmkt0XLPajjhhevXeetHtrGhmUyOcKUNdebQpK2Cu6u3tSJPSoRU7X20rjd5pYjnnA0WtCKxsClETDt+KGdBExQZCAsflX1LhBeHQOAygp8fy0fRg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=xH+AK19C; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="xH+AK19C"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=xH+AK19Cl/XujB4SjkmrDvZp2p
	un7nnIXQajYO4fASeCsl4R+Xvujeh/vFuwMCCs+HUlp5o9NCEz738axqt5rQys57P15COi7IM+QPa
	KAHE80alMDCmg3lWnmD0mnbXWS7S7PJ+tHF+XAPXGfIZFnRTQZar14aUmo+aktHeDAsqRUlV5bOT5
	j2ewuENWey3sjfLubY1hNyZqbC2fnim4vaZtraHEFQMX0NBVT2fmBCqiGhEw2U1H/KefXNxs1NI/Q
	G5mQDyEDO46HV2fifbDE7vdZ5zJB6QAMP/PGIDpsPY3/FaEDuTfmqkpxMnXEZTGMQzp2lWIZ40mEe
	TRZ6VBdg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1uPC9F-00000008jpz-19uU;
	Wed, 11 Jun 2025 03:29:09 +0000
Date: Tue, 10 Jun 2025 20:29:09 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Damien Le Moal <dlemoal@kernel.org>
Cc: dm-devel@lists.linux.dev, Mike Snitzer <snitzer@kernel.org>,
	Mikulas Patocka <mpatocka@redhat.com>
Subject: Re: [PATCH 1/2] dm: Remove unnecessary return in dm_zone_endio()
Message-ID: <aEj4Beky0zdK4hmI@infradead.org>
References: <20250611011457.92309-1-dlemoal@kernel.org>
 <20250611011457.92309-2-dlemoal@kernel.org>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250611011457.92309-2-dlemoal@kernel.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

