Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C6EE171E65;
	Thu, 30 May 2024 12:52:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717073527; cv=none; b=kpiRH7S/B7pJK+txGn4oZYrAF4JpvFGeDJFThyhovY2lmJ3/ek7131/OyoMEpf1WCrHg1ehI5AAH1C7wDgOgnoBbVVjc2nFHs3MIH+nirh6WH10vqc/RLyLZDK01tq+kxBe+sQe177/XF7xoQ41SACF+gPd2GB7DhYCBiDNWeEM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717073527; c=relaxed/simple;
	bh=HEjrOJ4P9QQZ7244l3EwvA0UsW9jHOlEhmi7fJ1nWU4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=FtyUx+HsekViOjQLQxdmtidnEZ/XheC6qNpBjFohRmtfHZls49ebH0MGuyHFIVUPbFqpUtxF1OMksPUxIM7mxWj+7pmwN5lpNqVYF6A+RG057XZRDqriRHrE7yQ9HqR67HJpVIjgzMNivwJN7kVJvbgpVlZrmRqaZSnsG909RkE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=sbIizUUK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="sbIizUUK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 87F2AC3277B;
	Thu, 30 May 2024 12:52:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1717073527;
	bh=HEjrOJ4P9QQZ7244l3EwvA0UsW9jHOlEhmi7fJ1nWU4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=sbIizUUKS/d3WH2PHcdRhR7ea6UYz16f+Y3hXHkwM+yqc2gpkoGgGzLEmXnZgAKsP
	 Xw1VRPAaSzeZSzQzbh5n5QtCk8F0vrhbgBNTbZ2Ep5RqtJHYpjrDDMe9JY7btPysGy
	 KGrguoePmXN83jTO5QQ51j2ghIH1ypyrv4jnZfdofjudoe/62j/eHgLzWHeZTkyOrk
	 esjQrLJwvSYEAoxdOlyBcM1u50w1SNdmfnKrWy9C3/vKRBrGMcDXhR36DcTaVa4/CA
	 15DjdoSHY5pEHK5sx3QnJNHOoz1TCude4wFurDkxoz2G3BFcW0nNNFyg3ZPwLquoq5
	 Jqyj8Qp1cleCg==
Date: Thu, 30 May 2024 14:51:58 +0200
From: Niklas Cassel <cassel@kernel.org>
To: Damien Le Moal <dlemoal@kernel.org>
Cc: Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org,
	dm-devel@lists.linux.dev, Mike Snitzer <snitzer@kernel.org>,
	Mikulas Patocka <mpatocka@redhat.com>
Subject: Re: [PATCH 3/4] block: Fix zone write plugging handling of devices
 with a runt zone
Message-ID: <Zlh2bj1uuDUZuFgH@ryzen.lan>
References: <20240530054035.491497-1-dlemoal@kernel.org>
 <20240530054035.491497-4-dlemoal@kernel.org>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240530054035.491497-4-dlemoal@kernel.org>

On Thu, May 30, 2024 at 02:40:34PM +0900, Damien Le Moal wrote:
> A zoned device may have a last sequential write required zone that is
> smaller than other zones. However, all tests to check if a zone write
> plug write offset exceeds the zone capacity use the same capacity
> value stored in the gendisk zone_capacity field. This is incorrect for a
> zoned device with a last runt (smaller) zone.
> 
> Add the new field last_zone_capacity to struct gendisk to store the
> capacity of the last zone of the device. blk_revalidate_seq_zone() and
> blk_revalidate_conv_zone() are both modified to get this value when
> disk_zone_is_last() returns true. Similarly to zone_capacity, the value
> is first stored using the last_zone_capacity field of struct
> blk_revalidate_zone_args. Once zone revalidation of all zones is done,
> this is used to set the gendisk last_zone_capacity field.
> 
> The checks to determine if a zone is full or if a sector offset in a
> zone exceeds the zone capacity in disk_should_remove_zone_wplug(),
> disk_zone_wplug_abort_unaligned(), blk_zone_write_plug_init_request(),
> and blk_zone_wplug_prepare_bio() are modified to use the new helper
> functions disk_zone_is_full() and disk_zone_wplug_is_full().
> disk_zone_is_full() uses the zone index to determine if the zone being
> tested is the last one of the disk and uses the either the disk
> zone_capacity or last_zone_capacity accordingly.
> 
> Fixes: dd291d77cc90 ("block: Introduce zone write plugging")
> Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
> ---

Reviewed-by: Niklas Cassel <cassel@kernel.org>
