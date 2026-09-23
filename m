Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 53072393DE6
	for <dm-devel@lists.linux.dev>; Wed, 23 Sep 2026 04:51:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790139112; cv=none; b=owjZCm1jxSFsOapW7gm9xQ0uag21JDAm4oRphMCg7HkVQKBLGlQCj5m9bdky29k3oFCKbRpaXlpJhjfUY2hS8/4YU+r2NNHEMR/IeWAf1ESn7YI+7CiB7XM1bVqAlYElFI9DQkJ7+Oy7UBI3WBxU0lKYPPJP8Fq9FjvHA9G2bvA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790139112; c=relaxed/simple;
	bh=pu/mpkCqXSxgYN59HbS0UJuN1/RXNva8bBq3n7KmNpk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=eYpUjT/ADjUXOO/flICe8sIq7/ZPYA0r6ARmRJ+65JQiRquhb9dE8cQcwRE3iTvE+i7Xscco0KcavzHiJY+a1lKu6RYTSQj1cPuOKMJZKMrCZAoGRRhrp0npunvKxVMIZxnWofiUj/lfv0VgRpEeb6fidBfUTYIfv6XTLcebCVc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 2B01F68BFE; Wed, 23 Sep 2026 06:51:44 +0200 (CEST)
Date: Wed, 23 Sep 2026 06:51:43 +0200
From: Christoph Hellwig <hch@lst.de>
To: Pavel Begunkov <asml.silence@gmail.com>
Cc: Christoph Hellwig <hch@lst.de>, linux-block@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-media@vger.kernel.org,
	dri-devel@lists.freedesktop.org, linaro-mm-sig@lists.linaro.org,
	linux-nvme@lists.infradead.org, linux-fsdevel@vger.kernel.org,
	io-uring@vger.kernel.org, Sumit Semwal <sumit.semwal@linaro.org>,
	Christian =?iso-8859-1?Q?K=F6nig?= <christian.koenig@amd.com>,
	Keith Busch <kbusch@kernel.org>, Sagi Grimberg <sagi@grimberg.me>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>,
	Andrew Morton <akpm@linux-foundation.org>,
	Jens Axboe <axboe@kernel.dk>, Nitesh Shetty <nj.shetty@samsung.com>,
	Kanchan Joshi <joshi.k@samsung.com>,
	Anuj Gupta <anuj20.g@samsung.com>,
	Tushar Gohad <tushar.gohad@intel.com>,
	William Power <william.power@intel.com>,
	Phil Cayton <phil.cayton@intel.com>,
	Matthew Brost <matthew.brost@intel.com>,
	Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@kernel.org>,
	Mikulas Patocka <mpatocka@redhat.com>,
	Benjamin Marzinski <bmarzins@redhat.com>, dm-devel@lists.linux.dev
Subject: Re: [PATCH v6 04/13] block: introduce dma map backed bio type
Message-ID: <20260923045143.GA26231@lst.de>
References: <cover.1789997898.git.asml.silence@gmail.com> <a3ee719abc440ca139f1a945fdaf43a45f0c6b57.1789997898.git.asml.silence@gmail.com> <20260922131610.GA30468@lst.de> <cce62c72-278a-44d1-9cf7-e0beb0b72688@gmail.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cce62c72-278a-44d1-9cf7-e0beb0b72688@gmail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Tue, Sep 22, 2026 at 02:54:25PM +0100, Pavel Begunkov wrote:
>>
>> Can you please expland on the splitting considerations a bit?  Preferably
>> both in a comment for the details, and in the commit log for how we
>> arrived at them and why they are fine for now?
>
> I'll add something to the commit log, but not sure which specific
> details in comments you mean. Do you want me to expand the comment
> above limiting the number of segments? Maybe I should add there that
> it's stricter than necessary and might cause more splitting than
> necessary? This one:

Yes, explain why we apply a relatively arbitrary limit not fully
exploiting the hardware capabilities, and why we thing that is okay.

