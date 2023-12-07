Received: from zeniv.linux.org.uk (zeniv.linux.org.uk [62.89.141.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F86812B79;
	Thu,  7 Dec 2023 06:42:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zeniv.linux.org.uk
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=ftp.linux.org.uk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linux.org.uk header.i=@linux.org.uk header.b="ZqyASLyd"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=linux.org.uk; s=zeniv-20220401; h=Sender:In-Reply-To:Content-Type:
	MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=1QgoyT0tgQXYPReqLUaAyvop4QBCwrIs7+A2t8zzCtQ=; b=ZqyASLydyd37Ejn7vrHKf1q6jD
	lmVSyysCizw3w+6wnVcD4+VaiIAvv8IRgLzBgLsp81Qyh4tHemn4ztiShuZO5A1l2q68FUl37JjLJ
	ZHbMObLpkTr85VoFq+qg3CvhMbXr9cn/wqIVmNfuvUbQ6NnbD06BWm9iDMxYumAqkFu4KqvWj20m7
	rlqWS18Q1ruFemUBBzJJ4+zXJ4q9sPc2MON6XUH1NoP0/39DAuMbHiO2aCAYUoFXX6K2DVQCmP3s+
	pe5Yo/AKz/B8PUaBsGI7M/0nXdO6Rvdf96HBrDQhTJZUDajjKsgZzVv+k0CULnyzK5sTZCbPSRt40
	vDkDeJRA==;
Received: from viro by zeniv.linux.org.uk with local (Exim 4.96 #2 (Red Hat Linux))
	id 1rB85A-0087jv-0f;
	Thu, 07 Dec 2023 06:42:00 +0000
Date: Thu, 7 Dec 2023 06:42:00 +0000
From: Al Viro <viro@zeniv.linux.org.uk>
To: Dave Chinner <david@fromorbit.com>
Cc: linux-fsdevel@vger.kernel.org, linux-block@vger.kernel.org,
	linux-cachefs@redhat.com, dhowells@redhat.com, gfs2@lists.linux.dev,
	dm-devel@lists.linux.dev, linux-security-module@vger.kernel.org,
	selinux@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 08/11] vfs: inode cache conversion to hash-bl
Message-ID: <20231207064200.GY1674809@ZenIV>
References: <20231206060629.2827226-1-david@fromorbit.com>
 <20231206060629.2827226-9-david@fromorbit.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231206060629.2827226-9-david@fromorbit.com>
Sender: Al Viro <viro@ftp.linux.org.uk>

On Wed, Dec 06, 2023 at 05:05:37PM +1100, Dave Chinner wrote:

> +	/*
> +	 * There are some callers that come through here without synchronisation
> +	 * and potentially with multiple references to the inode. Hence we have
> +	 * to handle the case that we might race with a remove and insert to a
> +	 * different list. Coda, in particular, seems to have a userspace API
> +	 * that can directly trigger "unhash/rehash to different list" behaviour
> +	 * without any serialisation at all.
> +	 *
> +	 * Hence we have to handle the situation where the inode->i_hash_head
> +	 * might point to a different list than what we expect, indicating that
> +	 * we raced with another unhash and potentially a new insertion. This
> +	 * means we have to retest the head once we have everything locked up
> +	 * and loop again if it doesn't match.
> +	 */

coda_replace_fid() is an old headache, but it's thankfully unique - nobody else
does that kind of shit (just rechecked).

Note that coda_replace_fid() is not going to have the sucker racing with
removal from another source, and I'm 100% sure that they really want
some serialization for handling those requests.

remove_inode_hash() is misused there - "in the middle of hash key change"
is not the same state as "unhashed".

Any races between insert and unhash are bugs, not something to support.
