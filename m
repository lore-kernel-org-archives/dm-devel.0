Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 99BF78626E
	for <dm-devel@lists.linux.dev>; Fri, 24 May 2024 16:40:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716568858; cv=none; b=nGdnsNOMjsK9kS9oMqJbfcsYmsUEajDgGXeXSeYFWhUB0uZA0cCFkTT6whnTJyEZjTFBa9lA8NHGmn+BHNIq0M3ZvvZpxZGcuXh0MtbUlQXaY+C9ROGt2TcsIEdv0ucwPf7geIt/Y6sSHTecB2WKGNy3W3YdfWd7c6XFP6q7ZhI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716568858; c=relaxed/simple;
	bh=Su2LVNpncEp2S8zjUHr2qCjPyRgK8MH7UcINObsMKyw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=LH46Trl3TEgLZ6s40xGp9zQJVSniz9XQnTd5y3iFbJ5+uEFTG2RHvjcPaoU1wLbcSuNJydTUlTIDq4VyfpUxpXl6HIoTJGZ9jGE5SMPKFJEeRVs9d3M6B0k3/F2MqJEb+3mniNvNoyZYTAGga4kXekq0W2YnajFGTH3RNGZqR9M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id A38EF68B05; Fri, 24 May 2024 18:40:51 +0200 (CEST)
Date: Fri, 24 May 2024 18:40:51 +0200
From: Christoph Hellwig <hch@lst.de>
To: Mike Snitzer <snitzer@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, Mikulas Patocka <mpatocka@redhat.com>,
	Damien Le Moal <dlemoal@kernel.org>, dm-devel@lists.linux.dev
Subject: Re: [PATCH 1/3] dm: move setting zoned_enabled to
 dm_table_set_restrictions
Message-ID: <20240524164051.GA21444@lst.de>
References: <20240524142929.817565-1-hch@lst.de> <20240524142929.817565-2-hch@lst.de> <ZlCtT0FadH4I8dFb@kernel.org>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZlCtT0FadH4I8dFb@kernel.org>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Fri, May 24, 2024 at 11:07:59AM -0400, Mike Snitzer wrote:
> > +	ret = dm_revalidate_zones(md, t);
> > +	if (ret < 0)
> > +		return 0;
> 
> Not following why you're return 0 if r < 0.
> 
> blk_revalidate_disk_zones() has quite a few negative checks that
> return regular error codes, so why drop those validation errors?

Because I messed this up..

