Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 777531C6AF;
	Mon, 10 Jun 2024 07:16:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718003786; cv=none; b=VKmiBRs2DktFtjUcfXWf2y5amjLdjH9mpQoo7pv8m3FLYKNWNoUXNfzoyp9pOcK+Xp4KToIMjugIR4Xh5Vbzj6Luq+p4WvTnn5gSGIk6uGuc4Dv6QLYvBMUvPUXgcUwVKAXDLCEJUIIjYboWGpaLtSJm4RHYaqMBFLlNik997vQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718003786; c=relaxed/simple;
	bh=qtmUO86AcmSlvVOJg52PdTpaxeVfLygDDb8f1PprTxQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=SvvUQhv47m3xil9gqRzRM4umO0Iw0xwRGlLklIvkalYPGw5SsKvOnx/Bq0/XpE87J+xr0hWjZRGY6XomHrvX0C8Bno8xhYlfVBl1wzLWzbeCISeZtokrLTm5kcq7GqZ5q/74Xm5a0hP0Nevs5piQNYXFWh1qt6U8jnUDdYOCmfo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=FzETLtvf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="FzETLtvf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 69F11C2BBFC;
	Mon, 10 Jun 2024 07:16:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1718003786;
	bh=qtmUO86AcmSlvVOJg52PdTpaxeVfLygDDb8f1PprTxQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=FzETLtvfUfsXzYSRwf3H4KVHChLSUvH5msfgKDbBfOyi1Ov3FEh1ouKotw7g1Y5M5
	 kmuAzvZBgC95qJE5ks0JlMYLT53axZfcHMrDSREn7YMDzM8GwGT1T01/4yNgAGc9G0
	 fy/ECg5QeSO+Knhc+e1iHKPKhFOyQ8DYr5/G8xCZefOi7NpfCbMsj+zLvAy5zltJwy
	 Yej/l1u1wDBrswjSWuKsvPusyKXRlAzu8giGFEyPUFUJnNoyT0gfv/YcI0fyMv1Qdw
	 vQt3ftoU7+9I5NCisUhcecwwEzQhn3RfPP2Rwh+Bh8ysANxcRA10xew80Ra2aFs3YE
	 Qw2eR97j4fzMA==
Date: Mon, 10 Jun 2024 09:16:21 +0200
From: Niklas Cassel <cassel@kernel.org>
To: Damien Le Moal <dlemoal@kernel.org>
Cc: Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org,
	dm-devel@lists.linux.dev, Mike Snitzer <snitzer@kernel.org>,
	Mikulas Patocka <mpatocka@redhat.com>,
	Christoph Hellwig <hch@lst.de>,
	Benjamin Marzinski <bmarzins@redhat.com>
Subject: Re: [PATCH v6 2/4] dm: Call dm_revalidate_zones() after setting the
 queue limits
Message-ID: <ZmaoRbmid0WSrmof@ryzen.lan>
References: <20240606082147.96422-1-dlemoal@kernel.org>
 <20240606082147.96422-3-dlemoal@kernel.org>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240606082147.96422-3-dlemoal@kernel.org>

On Thu, Jun 06, 2024 at 05:21:45PM +0900, Damien Le Moal wrote:
> dm_revalidate_zones() is called from dm_set_zone_restrictions() when the
> mapped device queue limits are not yet set. However,
> dm_revalidate_zones() calls blk_revalidate_disk_zones() and this
> function consults and modifies the mapped device queue limits. Thus,
> currently, blk_revalidate_disk_zones() operates on limits that are not
> yet initialized.
> 
> Fix this by moving the call to dm_revalidate_zones() out of
> dm_set_zone_restrictions() and into dm_table_set_restrictions() after
> executing queue_limits_set().
> 
> To further cleanup dm_set_zones_restrictions(), the message about the
> type of zone append (native or emulated) is also moved inside
> dm_revalidate_zones().
> 
> Fixes: 1c0e720228ad ("dm: use queue_limits_set")
> Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> ---

Reviewed-by: Niklas Cassel <cassel@kernel.org>
