Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8FE0228C862
	for <dm-devel@lists.linux.dev>; Tue, 25 Nov 2025 06:34:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764052449; cv=none; b=jZvc9dFkyFp1WgheJlqhlOOwmMFK0Dl+uBOV2bNVQfWpv8+i7T39zgCpzwSL6Ozu/HN9vSMwTCdHSeQik519CBr+qi/fru0YX6i318VHwUnjB9m87vprCk5J3EbBo1rCE8rpQlLZzwj2Qbkmmxpe9t0rqtTJlhvtpCIE//ZEF+s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764052449; c=relaxed/simple;
	bh=ja/dybNRZjiFc4BwhelBUXC1g5mym/a7FtVQoXLnDWM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=bfCZdu3TmuVWTFEgeYnkpq6tqwAb6CBObp64epIFRFAYLs243oFuqO7e2qMLw2yh978SzZwWA76eKMEu2WwD/Fqg9Ge/69VwBR1/51wXTFStTLIsgvDjJ8Ww8ELXGmvroqearZ6u36Fz+2hn+9uqOtiJskJRg5x2qyJQt15nXvA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id BA0A868B05; Tue, 25 Nov 2025 07:33:58 +0100 (CET)
Date: Tue, 25 Nov 2025 07:33:58 +0100
From: Christoph Hellwig <hch@lst.de>
To: Chao Yu <chao@kernel.org>
Cc: Chaitanya Kulkarni <ckulkarnilinux@gmail.com>, axboe@kernel.dk,
	agk@redhat.com, snitzer@kernel.org, mpatocka@redhat.com,
	song@kernel.org, yukuai@fnnas.com, hch@lst.de, sagi@grimberg.me,
	kch@nvidia.com, jaegeuk@kernel.org, cem@kernel.org,
	linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
	dm-devel@lists.linux.dev, linux-raid@vger.kernel.org,
	linux-nvme@lists.infradead.org,
	linux-f2fs-devel@lists.sourceforge.net, linux-xfs@vger.kernel.org,
	bpf@vger.kernel.org,
	"Martin K . Petersen" <martin.petersen@oracle.com>,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>
Subject: Re: [PATCH V3 5/6] f2fs: ignore discard return value
Message-ID: <20251125063358.GA14801@lst.de>
References: <20251124234806.75216-1-ckulkarnilinux@gmail.com> <20251124234806.75216-6-ckulkarnilinux@gmail.com> <9c8a6b5f-74c8-4e9f-ae46-24e1df5fe4e0@kernel.org>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9c8a6b5f-74c8-4e9f-ae46-24e1df5fe4e0@kernel.org>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Tue, Nov 25, 2025 at 09:10:00AM +0800, Chao Yu wrote:
> Reviewed-by: Chao Yu <chao@kernel.org>

Sending these all as a series might be confusing - it would be good
if the individual patches get picked through the subsystem trees
so that the function signature can be cleaned up after -rc1.

Can we get this queued up in the f2fs tree?

