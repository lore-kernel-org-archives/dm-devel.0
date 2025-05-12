Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 32C4F18035
	for <dm-devel@lists.linux.dev>; Mon, 12 May 2025 05:09:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747026596; cv=none; b=UwUXxewCRMXLS8d2QllwJLmtMMKhhu5Z1n9jIiNScsYf/QEQgi8+yu8Mi4oNbdkdnSeRgueupIzq9dmafcilYm+m63RUkpOPLfc7EAv0Wpy6XXJBaRBSxexx5/+467tLY8MINCwJvpQaC6RCoHpRj3FURiPVajnepeBuhZC/wcE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747026596; c=relaxed/simple;
	bh=krCBPUCKSwWIn/pc4QoNLW7zHdKwaLbZ8PYVMXQq3KM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=EiHWpTBoAu/L21qBO4rOtspf5uPaSmi/EF2D7ry2pFY0S8i7kCypGAo+9U2Z6O5FTQ4MIs0v0k0BZeA7aD/nuqf0NSbvwFWXqW2MyI2ZBZcUw5+w1yWTLXNBX3x1BRP9JBAuTB8pqLy6XjxHOkTKo4GPz7v5F6o6cT7CCa5T410=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id A8DB968AA6; Mon, 12 May 2025 07:09:50 +0200 (CEST)
Date: Mon, 12 May 2025 07:09:50 +0200
From: Christoph Hellwig <hch@lst.de>
To: Yu Kuai <yukuai1@huaweicloud.com>
Cc: hch@lst.de, xni@redhat.com, colyli@kernel.org, agk@redhat.com,
	snitzer@kernel.org, mpatocka@redhat.com, song@kernel.org,
	yukuai3@huawei.com, linux-kernel@vger.kernel.org,
	dm-devel@lists.linux.dev, linux-raid@vger.kernel.org,
	yi.zhang@huawei.com, yangerkun@huawei.com, johnny.chenyi@huawei.com
Subject: Re: [PATCH RFC md-6.16 v3 10/19] md/md-llbitmap: add data
 structure definition and comments
Message-ID: <20250512050950.GJ868@lst.de>
References: <20250512011927.2809400-1-yukuai1@huaweicloud.com> <20250512011927.2809400-11-yukuai1@huaweicloud.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250512011927.2809400-11-yukuai1@huaweicloud.com>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Mon, May 12, 2025 at 09:19:18AM +0800, Yu Kuai wrote:
> From: Yu Kuai <yukuai3@huawei.com>
> 
> Signed-off-by: Yu Kuai <yukuai3@huawei.com>

You'll need a commit message here.  Also given how tiny this is
vs the rest of the file I'm not entirely sure there is much of a
point in splittng it out.

> +#include <linux/buffer_head.h>

This shouldn't be needed here I think.

> + * llbitmap state machine: transitions between states

Can you split the table below into two columns so that it's easily
readabe?

> +#define LLBITMAP_MAJOR_HI 6

I think you'll want to consolidate all the different version in
md-bitmap.h and document them.

> +#define BITMAP_MAX_SECTOR (128 * 2)

This appears unused even with the later series.

> +#define BITMAP_MAX_PAGES 32

Can you comment on how we ended up with this number?

> +#define BITMAP_SB_SIZE 1024

I'd add this to md-bitmap.h as it's part of the on-disk format, and
also make md-bitmap.c use it.

> +#define DEFAULT_DAEMON_SLEEP 30
> +
> +#define BARRIER_IDLE 5

Can you document these?

> +enum llbitmap_action {
> +	/* User write new data, this is the only acton from IO fast path */

s/acton/action/

> +/*
> + * page level barrier to synchronize between dirty bit by write IO and clean bit
> + * by daemon.

Overly lon line.  Also please stat full sentences with a capitalized
word.

> + */
> +struct llbitmap_barrier {
> +	char *data;

This is really a states array as far as I can tell.  Maybe name it
more descriptively and throw in a comment.

> +	struct percpu_ref active;
> +	unsigned long expire;
> +	unsigned long flags;
> +	/* Per block size dirty state, maximum 64k page / 512 sector = 128 */
> +	DECLARE_BITMAP(dirty, 128);
> +	wait_queue_head_t wait;
> +} ____cacheline_aligned_in_smp;
> +
> +struct llbitmap {
> +	struct mddev *mddev;
> +	int nr_pages;
> +	struct page *pages[BITMAP_MAX_PAGES];
> +	struct llbitmap_barrier barrier[BITMAP_MAX_PAGES];

Should the bitmap and the page be in the same array to have less
cache line sharing between the users/  The above
____cacheline_aligned_in_smp suggests you are at least somewhat
woerried about cache line sharing.

> +static char state_machine[nr_llbitmap_state][nr_llbitmap_action] = {
> +	[BitUnwritten] = {BitDirty, BitNone, BitNone, BitNone, BitNone, BitNone, BitNone, BitNone},

Maybe used named initializers to make this more readable.  In fact that
might remove the need for the big table in the comment at the top of the
file because it would be just as readable.

