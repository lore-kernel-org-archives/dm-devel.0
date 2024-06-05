Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 928E7200CD
	for <dm-devel@lists.linux.dev>; Wed,  5 Jun 2024 07:55:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717574117; cv=none; b=DQLDiDI27qwZ9QWT6zbT2RZ/xeR4vPphq1+y6xQr5Zis+WRt4oFPv4be9Z0kqm0i+Gqanvwjb5Mb9dZmGfE5kmpcfCXkNbzgOIB8qoINKfOimayQUivnM4UapMxPQHqtUKIVzkryavjoW8AoVrw1WTaiEp8Ep1J8i2tps4skhmg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717574117; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=CU8AKkckXfvr5TpiNkP3cHYVn50IcTVx4qCFxx8qdw+dSXBIsqGqmozdPzTapHMpJvzTcTWivkIC5eMlPB++BBl5Sw7OrzYzBqxeBZ2uXWGXRAz6uqLu9cJbdiUqXGmzDJkeWgsXr2fGNoh2Ja9LrMvzVyzuN0Xo+HYHblZHWKc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 9BBBA68D0D; Wed,  5 Jun 2024 09:55:13 +0200 (CEST)
Date: Wed, 5 Jun 2024 09:55:13 +0200
From: Christoph Hellwig <hch@lst.de>
To: Damien Le Moal <dlemoal@kernel.org>
Cc: Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org,
	dm-devel@lists.linux.dev, Mike Snitzer <snitzer@kernel.org>,
	Mikulas Patocka <mpatocka@redhat.com>,
	Christoph Hellwig <hch@lst.de>,
	Benjamin Marzinski <bmarzins@redhat.com>
Subject: Re: [PATCH v4 2/3] dm: Improve zone resource limits handling
Message-ID: <20240605075513.GB18465@lst.de>
References: <20240605075144.153141-1-dlemoal@kernel.org> <20240605075144.153141-3-dlemoal@kernel.org>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240605075144.153141-3-dlemoal@kernel.org>
User-Agent: Mutt/1.5.17 (2007-11-01)

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
