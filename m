Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D36C21D3EA
	for <dm-devel@lists.linux.dev>; Wed, 26 Nov 2025 10:37:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764153427; cv=none; b=OWpWty5k3pRaGVoh65Sybxj1RMx6GYspBA9e/SVzvX03N99uJ5bUJR6K7WIfMZHT5arEcnrBBYzPOYGPOVGF9+2f882DhxL4TeHzT9UAu/Jxr1zpH0Z54npYa7CgEgTF+hVAD3SfKRnzrSAmjrIRI2uqQXXV5kHhZiIMHiFUXsU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764153427; c=relaxed/simple;
	bh=ukBIqhXL124A1LC4/GYfmWEEH/Usi1jbg10qg9sUhKY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=sT1BGdNY2YmsFSiEypJI+ivMO4Lay2qpYrF9rZCa34wENOYFTqs7F+BAK3N6NdTuZ5DVIrJ4XODxZXV5Cz63crD+4Lo17XDq7f+G0eQDaaDSSTh5d82jCdn0yVKGqxP1WC+cuhOfhRpfXcIxkjIM6Zqdr4VZ4uBWmJKkD7yVM4k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id E56676732A; Wed, 26 Nov 2025 11:37:00 +0100 (CET)
Date: Wed, 26 Nov 2025 11:37:00 +0100
From: Christoph Hellwig <hch@lst.de>
To: Yongpeng Yang <yangyongpeng.storage@gmail.com>
Cc: Chaitanya Kulkarni <ckulkarnilinux@gmail.com>, axboe@kernel.dk,
	agk@redhat.com, snitzer@kernel.org, mpatocka@redhat.com,
	song@kernel.org, yukuai@fnnas.com, hch@lst.de, sagi@grimberg.me,
	kch@nvidia.com, jaegeuk@kernel.org, chao@kernel.org, cem@kernel.org,
	dm-devel@lists.linux.dev, linux-raid@vger.kernel.org,
	"Martin K . Petersen" <martin.petersen@oracle.com>,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>,
	linux-kernel@vger.kernel.org, linux-nvme@lists.infradead.org,
	linux-f2fs-devel@lists.sourceforge.net, linux-block@vger.kernel.org,
	bpf@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [f2fs-dev] [PATCH V3 4/6] nvmet: ignore discard return value
Message-ID: <20251126103700.GA28056@lst.de>
References: <20251124234806.75216-1-ckulkarnilinux@gmail.com> <20251124234806.75216-5-ckulkarnilinux@gmail.com> <e40cb47c-9f92-4982-bf3f-45ec9f2a1681@gmail.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e40cb47c-9f92-4982-bf3f-45ec9f2a1681@gmail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Wed, Nov 26, 2025 at 06:14:32PM +0800, Yongpeng Yang wrote:
> We also need to check for memory allocation errors in
> __blkdev_issue_discard().

No, we still don't.  What is so hard to grasp about mempool allocations
even after repeated explanations?

