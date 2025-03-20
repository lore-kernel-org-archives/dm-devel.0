Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F42201E32C6
	for <dm-devel@lists.linux.dev>; Thu, 20 Mar 2025 07:10:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742454618; cv=none; b=XmNv3s8TA4RFwy8FANho4PfdUf3ND5NiQ+3O9Rq7wPzjaTRc6OgtMmr21y0YdoETWy1k9VouJjITyAYLQdsaeqwoRJl8/z1N3HiMMEeRODpkNkMYtjzI5o7g+7XafLAfb1GmIPZSnjRC+TvmTYX0yk8lfPrqR9TyTsASEx2huwo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742454618; c=relaxed/simple;
	bh=IH3kxiwDdlX7YZxfAF/uigyJalxgJNLx+nj/k64j/o4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=q8nfJzx1wMmZG3YL4XiU/17+iKT6z0PlPrtN6eC3/LYizR6F9ddkzyGKI7RDdyqI9rd3x7jObP2yISFnlSzHMEvpuS//OaM67w9U6mm/KOXYAan3hTPov53vMHwAPnr1Xoo6IbAmI9YKKDk5t0+ryNFrWxAxkhLqi2siSqmxTTE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 2584D68AA6; Thu, 20 Mar 2025 08:10:12 +0100 (CET)
Date: Thu, 20 Mar 2025 08:10:11 +0100
From: Christoph Hellwig <hch@lst.de>
To: Ming Lei <ming.lei@redhat.com>
Cc: Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org,
	Christoph Hellwig <hch@lst.de>, Jooyung Han <jooyung@google.com>,
	Mike Snitzer <snitzer@kernel.org>, zkabelac@redhat.com,
	dm-devel@lists.linux.dev, Alasdair Kergon <agk@redhat.com>
Subject: Re: [PATCH V2 1/5] loop: simplify do_req_filebacked()
Message-ID: <20250320071011.GA14337@lst.de>
References: <20250314021148.3081954-1-ming.lei@redhat.com> <20250314021148.3081954-2-ming.lei@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250314021148.3081954-2-ming.lei@redhat.com>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Fri, Mar 14, 2025 at 10:11:41AM +0800, Ming Lei wrote:
> lo_rw_aio() is only called for READ/WRITE operation, which can be
> figured out from request directly, so remove 'rw' parameter from
> lo_rw_aio(), meantime rename the local variable as 'dir' which makes
> the check more readable in lo_rw_aio().
> 
> Meantime add lo_rw_simple() so that do_req_filebacked() can be
> simplified in the following way:

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

