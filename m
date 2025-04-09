Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7DF5F25C6EE
	for <dm-devel@lists.linux.dev>; Wed,  9 Apr 2025 10:35:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744194954; cv=none; b=hwGoeulsD745JcRylBeCMzKBV9horBSUy2hd0kKg+wK4ml1Z3XsXsIwvJjCwFK1ySfYhqIXgyeCdtoeEemndzcO7uEo5bHqkOrIJo99wn0YRdWsPPXhpJ7O7OP4W1oChYhLq+2Ax9nBIRInPT25MM9vZ04loJuJpoGp8FXT8YDc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744194954; c=relaxed/simple;
	bh=IHiHhIuYP9SAzOslZwOE2KYY14rqvkvRl05SFm5a9uI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Nd90FM9AaKebfHL3rfHz5HvDjQRQ6HG7fG2dxsa2AOcP00s9e2mjmgMxQG1N//j5Z/xbSMHi/7pI5m4rwpkiR39I/TbhDUxuuQrczT51bpbUN6JXaHcRd17LYcOfdG037qqsBhDudoelJYHz7zhk3rch/B+tta74Yz125CxNdhg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 7D9EE68AA6; Wed,  9 Apr 2025 12:35:48 +0200 (CEST)
Date: Wed, 9 Apr 2025 12:35:48 +0200
From: Christoph Hellwig <hch@lst.de>
To: Zhang Yi <yi.zhang@huaweicloud.com>
Cc: linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
	linux-block@vger.kernel.org, dm-devel@lists.linux.dev,
	linux-nvme@lists.infradead.org, linux-scsi@vger.kernel.org,
	linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org, hch@lst.de,
	tytso@mit.edu, djwong@kernel.org, john.g.garry@oracle.com,
	bmarzins@redhat.com, chaitanyak@nvidia.com,
	shinichiro.kawasaki@wdc.com, yi.zhang@huawei.com,
	chengzhihao1@huawei.com, yukuai3@huawei.com, yangerkun@huawei.com
Subject: Re: [RFC PATCH -next v3 07/10] fs: introduce
 FALLOC_FL_WRITE_ZEROES to fallocate
Message-ID: <20250409103548.GC4950@lst.de>
References: <20250318073545.3518707-1-yi.zhang@huaweicloud.com> <20250318073545.3518707-8-yi.zhang@huaweicloud.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250318073545.3518707-8-yi.zhang@huaweicloud.com>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Tue, Mar 18, 2025 at 03:35:42PM +0800, Zhang Yi wrote:
> Users can check the disk support of unmap write zeroes command by
> querying:
> 
>     /sys/block/<disk>/queue/write_zeroes_unmap

No, that is not in any way a good user interface.  Users need to be
able to query this on a per-file basis.

> Finally, this flag should not be specified in conjunction with the
> FALLOC_FL_KEEP_SIZE since allocating written extents beyond file EOF is
> not permitted, and filesystems that always require out-of-place writes
> should not support this flag since they still need to allocated new
> blocks during subsequent overwrites.

Should not or can't?  You're returning an error if this happens, so it
doesn't look like should is the right word here.

