Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E740524A06D
	for <dm-devel@lists.linux.dev>; Tue, 13 Oct 2026 14:10:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791900656; cv=none; b=pqC+4OsGCUaKClpjJnP0vf02SXiaool8CmVgkSmjzvGzlNdKxPzp17n8sbXPYGIxmDF31d9enPlTPDGQ8K+WlM9kq/0yl5FTwH8lD0BOLksLmCkjdt5gWRKHvJ8jF4+ZVh0CBmDLto5AxFHBLPKPZeB63ERLPqNCeqLZnp2bnHk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791900656; c=relaxed/simple;
	bh=e+FpJuKqPpYqOvdhreGz9VLQkNbHeVeXvjheMQqCMHw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=QVgGIFnC2rya0URPdq1xFbBOiFnEKfBN0vKnFVLCBIxYrO5rFavcxDr6DE6+SemGxE4Hyv1KOL6lzB+cS2Zfk6hcg/XuNtmq+CcVm8YShssr1bBg9d4NU6q5mCqXdcix+8WeIdE332NbzZE62O2mClT+uOaTwCcxgrzEapiuJio=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 5D86B227A88; Tue, 13 Oct 2026 16:10:47 +0200 (CEST)
Date: Tue, 13 Oct 2026 16:10:47 +0200
From: Christoph Hellwig <hch@lst.de>
To: Jens Axboe <axboe@kernel.dk>
Cc: Pavel Begunkov <asml.silence@gmail.com>, linux-block@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-media@vger.kernel.org,
	dri-devel@lists.freedesktop.org, linaro-mm-sig@lists.linaro.org,
	linux-nvme@lists.infradead.org, linux-fsdevel@vger.kernel.org,
	io-uring@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
	Sumit Semwal <sumit.semwal@linaro.org>,
	Christian =?iso-8859-1?Q?K=F6nig?= <christian.koenig@amd.com>,
	Keith Busch <kbusch@kernel.org>, Sagi Grimberg <sagi@grimberg.me>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>,
	Andrew Morton <akpm@linux-foundation.org>,
	Nitesh Shetty <nj.shetty@samsung.com>,
	Kanchan Joshi <joshi.k@samsung.com>,
	Anuj Gupta <anuj20.g@samsung.com>,
	Tushar Gohad <tushar.gohad@intel.com>,
	William Power <william.power@intel.com>,
	Matthew Brost <matthew.brost@intel.com>,
	Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@kernel.org>,
	Mikulas Patocka <mpatocka@redhat.com>,
	Benjamin Marzinski <bmarzins@redhat.com>, dm-devel@lists.linux.dev
Subject: Re: [PATCH v9 00/13] Add dmabuf read/write via io_uring
Message-ID: <20261013141046.GA12680@lst.de>
References: <cover.1791336930.git.asml.silence@gmail.com> <d00e43fa-8f5b-4a8b-8b83-421d637ba519@kernel.dk>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d00e43fa-8f5b-4a8b-8b83-421d637ba519@kernel.dk>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Mon, Oct 12, 2026 at 02:21:41PM -0600, Jens Axboe wrote:
> I've queued this series up for some testing, in a separate branch. JFYI.

More testing it obviously good.  I've been waiting for addressing
of the Sashiko comments on the nvme patches before doing more ACKs,
and while I can't really judge the code those in the dma-buf code
also look somewhat serious.  So it would be useful to get them addressed
and the series reposted.  Same for folding in the PI vs dmabuf fix
from Anuj, although making the combination work would of course be
even better.

