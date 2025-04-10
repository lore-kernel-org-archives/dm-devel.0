Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 55B57204C1E
	for <dm-devel@lists.linux.dev>; Thu, 10 Apr 2025 07:16:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744269368; cv=none; b=eThSVKFkNsXGjHcArJtOTr0q0QhFgKa+dlCkwj2NG8DeQSktWQCaNSlllu8nahXu9254wK+uYXbm2TetjRlNrfruI7VR0QYZ+MvfbyxJfqvo1LCwxsJCt7szzPwzGPu0im8QEs8fWltv+6oNziuUFAlOMpr6cMfxhbZftAT/8Ps=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744269368; c=relaxed/simple;
	bh=Gtx8aCqVpDE0uKrhP9w1sLMJ31H86CXXHuAhM3qPh5E=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=FAoGVo9Q12GpC7V5artgvpVNoQ0spGkV0kFLqOcdhiPUt/ng48GQy8+VVF9mbYczDYhZ96dwOxmfL2C8SDkWUfoFcmzEUkqi4t0DzB2QetgYYablOrAysyi7oJT82H3d8QorOW3NzL7nzha+6TU9O+/RCPvTCgLZpfcGYo0/sWY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 4668E68BFE; Thu, 10 Apr 2025 09:16:00 +0200 (CEST)
Date: Thu, 10 Apr 2025 09:15:59 +0200
From: Christoph Hellwig <hch@lst.de>
To: Zhang Yi <yi.zhang@huaweicloud.com>
Cc: Christoph Hellwig <hch@lst.de>, linux-fsdevel@vger.kernel.org,
	linux-ext4@vger.kernel.org, linux-block@vger.kernel.org,
	dm-devel@lists.linux.dev, linux-nvme@lists.infradead.org,
	linux-scsi@vger.kernel.org, linux-xfs@vger.kernel.org,
	linux-kernel@vger.kernel.org, tytso@mit.edu, djwong@kernel.org,
	john.g.garry@oracle.com, bmarzins@redhat.com, chaitanyak@nvidia.com,
	shinichiro.kawasaki@wdc.com, yi.zhang@huawei.com,
	chengzhihao1@huawei.com, yukuai3@huawei.com, yangerkun@huawei.com
Subject: Re: [RFC PATCH -next v3 01/10] block: introduce
 BLK_FEAT_WRITE_ZEROES_UNMAP to queue limits features
Message-ID: <20250410071559.GA32420@lst.de>
References: <20250318073545.3518707-1-yi.zhang@huaweicloud.com> <20250318073545.3518707-2-yi.zhang@huaweicloud.com> <20250409103148.GA4950@lst.de> <43a34aa8-3f2f-4d86-be53-8a832be8532f@huaweicloud.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <43a34aa8-3f2f-4d86-be53-8a832be8532f@huaweicloud.com>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Thu, Apr 10, 2025 at 11:52:17AM +0800, Zhang Yi wrote:
> 
> Thank you for your review and comments. However, I'm not sure I fully
> understand your points. Could you please provide more details?
> 
> AFAIK, the NVMe protocol has the following description in the latest
> NVM Command Set Specification Figure 82 and Figure 114:
> 
> ===
> Deallocate (DEAC): If this bit is set to ‘1’, then the host is
> requesting that the controller deallocate the specified logical blocks.
> If this bit is cleared to ‘0’, then the host is not requesting that
> the controller deallocate the specified logical blocks...
> 
> DLFEAT:
> Write Zeroes Deallocation Support (WZDS): If this bit is set to ‘1’,
> then the controller supports the Deallocate bit in the Write Zeroes
> command for this namespace...

Yes.  The host is requesting, not the controller shall.  It's not
guaranteed behavior and the controller might as well actually write
zeroes to the media.  That is rather stupid, but still.

Also note that some write zeroes implementations in consumer devices
are really slow even when deallocation is requested so that we had
to blacklist them.

> Were you saying that what is described in this protocol is not a
> mandatory requirement? Which means the disks that claiming to support
> the UNMAP write zeroes command(WZDS=1,DRB=1), but in fact, they still
> write actual zeroes data to the storage media? Or were you referring
> to some irregular disks that do not obey the protocol and mislead
> users?

The are at least allowed to.

