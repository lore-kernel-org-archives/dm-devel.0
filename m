Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1BDC4156F45
	for <dm-devel@lists.linux.dev>; Wed, 19 Nov 2025 05:45:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763531129; cv=none; b=mGf9otfeXy4W5iFcxCS0qcZrY2W2BJdbvRYYTQKw7buTLsuznV8OcR54/Qb0kVbkIOhaLR9mmIZ200brbINSzE6gB1jrambZGMvsBxMdS2CONyHqarbCOR6ylwKgAn4vnLY3ZNb345WyaRpoloRkUA16UwsORvtIUvEfzjrfTcQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763531129; c=relaxed/simple;
	bh=2XqUI3MomDjHJPknIlxLQThtQkhHwXMUCTBv2gbfUfY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=EhPYaLFgknGXUgy7pu0eX/uiC4Qyz8eIHM+5ikL0Fe7D9PW8NcEmOkgIFWvnefad1bqvRE8tZT74B8uV39qLfQok4SnbUwk4POnTsBkXhBCcBijVfz7PTU1MNrhQvnl3zvfogpwqyKJhbelssJaCc4/USK0QZw19l8mMLQqx7mY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id B0AD368AFE; Wed, 19 Nov 2025 06:45:24 +0100 (CET)
Date: Wed, 19 Nov 2025 06:45:24 +0100
From: Christoph Hellwig <hch@lst.de>
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: Benjamin Marzinski <bmarzins@redhat.com>,
	"Uladzislau Rezki (Sony)" <urezki@gmail.com>,
	Alasdair Kergon <agk@redhat.com>, DMML <dm-devel@lists.linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>,
	Mike Snitzer <snitzer@redhat.com>, Christoph Hellwig <hch@lst.de>,
	LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] dm-bufio: align write boundary on
 bdev_logical_block_size
Message-ID: <20251119054524.GA19993@lst.de>
References: <20251020123350.2671495-1-urezki@gmail.com> <cdb598ce-88ec-0c3c-8e4b-b557093bea92@redhat.com> <aRvvSvyG8AK9hiCX@redhat.com> <faafd90d-e41c-dcfc-cc25-7f29ff4f958c@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <faafd90d-e41c-dcfc-cc25-7f29ff4f958c@redhat.com>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Tue, Nov 18, 2025 at 06:45:55PM +0100, Mikulas Patocka wrote:
> I changed the patch below, so that it aligns write bios on 
> max3(DM_BUFIO_WRITE_ALIGN, bdev_logical_block_size(b->c->bdev), 
> bdev_physical_block_size(b->c->bdev)); - so that if physical block size is 
> greater than logical block size, the writes are aligned so that the device 
> doesn't do read-modify-write.

That doesn't make any sense whatsoever.  The physical block size must
be >= logical block size, and the block enforces that.

