Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C808E215F4E
	for <dm-devel@lists.linux.dev>; Mon,  9 Dec 2024 12:42:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733748144; cv=none; b=Vdug1EA+fgZ2zTXzCADMnXZc0deM/ohr3ScTOF4tIa/jTE2nTx3b9c3vfowFHbZHTL0+mNhGEEsGGdkf/MQ2CN9NMToeNsy8/BEyKNoHpJgYYxt9RvIIg7a5F7qEZ8GZfkkxh6AYYdxDEepGwD+H6j7CnqJ+pf6FYKLqUNQG6KU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733748144; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=syHszuAVVKwuqorj5cL++ONxds6peM0LzYw6lvNrOrM/kXy8Q456dDteQyOwbVi8xxk0N77bIChzm2RBwYFIqBJhErJeYh0gjIogY+LPor5lIIWB+ZNNrJfyMcr1N/4r/X4sFlhjHOI1wSHifhODUw6jWHBWGa7RI9XudqbPUpk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 7AF6368D13; Mon,  9 Dec 2024 13:42:18 +0100 (CET)
Date: Mon, 9 Dec 2024 13:42:18 +0100
From: Christoph Hellwig <hch@lst.de>
To: Damien Le Moal <dlemoal@kernel.org>
Cc: linux-block@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
	Mike Snitzer <snitzer@kernel.org>,
	Mikulas Patocka <mpatocka@redhat.com>, dm-devel@lists.linux.dev,
	Christoph Hellwig <hch@lst.de>,
	Bart Van Assche <bvanassche@acm.org>
Subject: Re: [PATCH v3 4/4] block: Prevent potential deadlocks in zone
 write plug error recovery
Message-ID: <20241209124218.GC13869@lst.de>
References: <20241209122357.47838-1-dlemoal@kernel.org> <20241209122357.47838-5-dlemoal@kernel.org>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241209122357.47838-5-dlemoal@kernel.org>
User-Agent: Mutt/1.5.17 (2007-11-01)

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
