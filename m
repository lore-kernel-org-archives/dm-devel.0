Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 899F612E48;
	Mon, 10 Jun 2024 06:59:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718002740; cv=none; b=e4kyUNj2MAQxfR4T1Ev4TB5Emyi78/+3xO3j5W7nxkZV3tcDOaCUmWvvmYZgSBZG9jIqFm4Fh9BWwWgKZRJoSp/1p4Xn+my0dkaFsCjcI9gbOZpHj9YEfyMhj0BrYrvp94i1rADq0ByW/DZYNhPOOT2vu8LDGeESjBDscWg3zlQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718002740; c=relaxed/simple;
	bh=ivnGVeMbxFHaIZSxfMPDQu8PhpHK+D98ERkqQAbXv7I=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=PCn8eFvdZg/kdIM2It92I8HiNJlaVcwMM780STQEa6k058bKudZ7aaMw24zLPTdVJPKHZyStlbolRIS1xAD18dJbSHoc4T0Twl+YzlD3VcxKOQp1RyXGciA9tYJ0R1HVPdbJX+75xLgKHvdrqGZWHmgeDlFyYrsS8fLhQHjBaBE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=u4Zwp5WZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="u4Zwp5WZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7A23FC2BBFC;
	Mon, 10 Jun 2024 06:58:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1718002740;
	bh=ivnGVeMbxFHaIZSxfMPDQu8PhpHK+D98ERkqQAbXv7I=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=u4Zwp5WZfN3JbnULfaBvjFdQu8zg2HDbZjeqxqkZOfK4/gZdIMpaIPsO0+068sf0Y
	 ridVelfr18qM27RfkZ/oisq0CJuuFtol6EIOGsUzjwsUWZOwe9858Hb/gFsJsLs4xx
	 LhaEOZmerB/uuz4AUyngB3oHZABVC6A2B+Gs3cCkZp2OG1mfhM0zwLQpDRuUzUfN1Q
	 3dQdW9fO+LnqtDcgQGLdnLxYzD+PeME/nuplqlf0KcGpI7dVz/oqWL3YFJjtrUoMF/
	 VIVzK3AddXGO7oA7s16BBWSy/H39WGb9WAMGD9tA5qaGUgjhbXv7qpgSSZ1RCS/rjj
	 MVBbLKKSHRZ6w==
Date: Mon, 10 Jun 2024 08:58:55 +0200
From: Niklas Cassel <cassel@kernel.org>
To: Damien Le Moal <dlemoal@kernel.org>
Cc: Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org,
	dm-devel@lists.linux.dev, Mike Snitzer <snitzer@kernel.org>,
	Mikulas Patocka <mpatocka@redhat.com>
Subject: Re: [PATCH] block: Optimize disk zone resource cleanup
Message-ID: <ZmakLyHAFQmiAgmx@ryzen.lan>
References: <20240607002126.104227-1-dlemoal@kernel.org>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240607002126.104227-1-dlemoal@kernel.org>

On Fri, Jun 07, 2024 at 09:21:26AM +0900, Damien Le Moal wrote:
> For zoned block devices using zone write plugging, an rcu_barrier() call
> is needed in disk_free_zone_resources() to synchronize freeing of zone
> write plugs and the destrution of the mempool used to allocate the
> plugs. The barrier call does slow down a little teardown of zoned block
> devices but should not affect teardown of regular block devices or zoned
> block devices that do not use zone write plugging (e.g. zoned DM devices
> that do not require zone append emulation).
> 
> Modify disk_free_zone_resources() to return early if we do not have a
> mempool to start with, that is, if the device does not use zone write
> plugging. This avoids the costly rcu_barrier() and speeds up disk
> teardown.
> 
> Reported-by: Mikulas Patocka <mpatocka@redhat.com>
> Fixes: dd291d77cc90 ("block: Introduce zone write plugging")
> Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
> ---
>  block/blk-zoned.c | 3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/block/blk-zoned.c b/block/blk-zoned.c
> index 8f89705f5e1c..137842dbb59a 100644
> --- a/block/blk-zoned.c
> +++ b/block/blk-zoned.c
> @@ -1552,6 +1552,9 @@ static void disk_destroy_zone_wplugs_hash_table(struct gendisk *disk)
>  
>  void disk_free_zone_resources(struct gendisk *disk)
>  {
> +	if (!disk->zone_wplugs_pool)
> +		return;
> +
>  	cancel_work_sync(&disk->zone_wplugs_work);
>  
>  	if (disk->zone_wplugs_wq) {
> -- 
> 2.45.2
> 

Reviewed-by: Niklas Cassel <cassel@kernel.org>
