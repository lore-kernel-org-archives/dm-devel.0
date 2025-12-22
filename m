Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E50D342527
	for <dm-devel@lists.linux.dev>; Mon, 22 Dec 2025 22:21:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766442098; cv=none; b=F3hyNsTGVDye+sPloDsbQQSSn80Wg0WeIJWx+cNXCox6j9pw62b9BIGX8Xj0AsiYFXRXaBcoVFA6W8ejl7A9cHSiOjP3npmKN/XkXK4tOX8CjaK3ToeuiUFhUOFlGygoFLjskeYEZIYV9De3YvIIm7hRG4/qWrxyCZ/GlLwV0BI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766442098; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=UgEPZ/y5pekf9dhZhk1fG44yspCPsRa27b+Jk5nJyOBdddUjGJffc18EeUUxQU4bB0NFfI9wcqpdeV6Ku4DhQthHDd+hglfeL6q3lPPOuwBrPI8/ZgP9LXLBDnTJxGHkNB8JemrRM2/xhOO5lCriixiiy2L2mVP9mBcQOdDcnW4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id BB554227A87; Mon, 22 Dec 2025 23:21:33 +0100 (CET)
Date: Mon, 22 Dec 2025 23:21:33 +0100
From: Christoph Hellwig <hch@lst.de>
To: Ding Hui <dinghui@sangfor.com.cn>
Cc: linux-kernel@vger.kernel.org, dm-devel@lists.linux.dev,
	bmarzins@redhat.com, mpatocka@redhat.com, snitzer@kernel.org,
	agk@redhat.com, hch@lst.de
Subject: Re: [PATCH] dm: remove fake timeout to avoid leak request
Message-ID: <20251222222133.GB17565@lst.de>
References: <20251220120350.10750-1-dinghui@sangfor.com.cn>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251220120350.10750-1-dinghui@sangfor.com.cn>
User-Agent: Mutt/1.5.17 (2007-11-01)

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

