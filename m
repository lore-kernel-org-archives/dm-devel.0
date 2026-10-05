Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E78F44334D8
	for <dm-devel@lists.linux.dev>; Mon,  5 Oct 2026 09:12:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791191544; cv=none; b=E3iIFFTdVhiPJRwBDnWXOas/bFUsMmAcoFNKHeE4k8KfdAfKHx6CDuZBcUP2Wcy3pLhiJHNAgQeZTPIp5dyNUts07b/n1gi6LdrugLZZkp7qDnmlsO4pSculCel/3P6W4z2Naa4bAWVxXPKZR3y6SZITEDdu9+d1RKtTWRgG0cs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791191544; c=relaxed/simple;
	bh=FvFbmcoqy+CS1e+9F4qS80J5W1BvvY9zD9RwiyhJe2w=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=B4KpP6p2zHxxbWKl1L3O2iz9lc/XzIYR50nX9mwZq6c2TjPwDsInCQAHh368fuxy5nrMzU22oIRK8aNQiLRepn+sRu5vXAy2ERGfzJkr7P4qODwDGYBEStNtmgC1zz6jxoWciZVyMC7oMkEsgd9V1yeThXBjQLk/RuoFhR49Ctc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 86A1B68BFE; Mon,  5 Oct 2026 11:12:19 +0200 (CEST)
Date: Mon, 5 Oct 2026 11:12:19 +0200
From: Christoph Hellwig <hch@lst.de>
To: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Cc: Pavel Begunkov <asml.silence@gmail.com>, agk@redhat.com,
	akpm@linux-foundation.org, anuj20.g@samsung.com, axboe@kernel.dk,
	bmarzins@redhat.com, brauner@kernel.org, christian.koenig@amd.com,
	dm-devel@lists.linux.dev, dri-devel@lists.freedesktop.org,
	hch@lst.de, io-uring@vger.kernel.org, jack@suse.cz,
	joshi.k@samsung.com, kbusch@kernel.org,
	linaro-mm-sig@lists.linaro.org, linux-block@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-media@vger.kernel.org, linux-nvme@lists.infradead.org,
	matthew.brost@intel.com, mpatocka@redhat.com, nj.shetty@samsung.com,
	phil.cayton@intel.com, sagi@grimberg.me, snitzer@kernel.org,
	sumit.semwal@linaro.org, tushar.gohad@intel.com,
	viro@zeniv.linux.org.uk, william.power@intel.com
Subject: Re: [PATCH v7 06/13] nvme-pci: implement dma-buf backed requests
Message-ID: <20261005091219.GC10727@lst.de>
References: <cover.1790602223.git.asml.silence@gmail.com> <e99dd5221c71cbf9aafb5737468d814cb83b9174.1790602223.git.asml.silence@gmail.com> <5a35ad21-c9d4-4dab-a4f0-97baee6e2301@wanadoo.fr>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5a35ad21-c9d4-4dab-a4f0-97baee6e2301@wanadoo.fr>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Tue, Sep 29, 2026 at 05:45:39PM +0200, Christophe JAILLET wrote:
>> @@ -27,6 +27,8 @@
>>   #include <linux/io-64-nonatomic-lo-hi.h>
>>   #include <linux/io-64-nonatomic-hi-lo.h>
>>   #include <linux/sed-opal.h>
>> +#include <linux/dma-buf-io.h>
>> +#include <linux/dma-resv.h>
>
> Move up, to keep better alphabetical order ?

Doesn't really matter.

>>   +struct nvme_dmabuf_map {
>> +	struct dma_buf_io_map base;
>> +	struct sg_table *sgt;
>> +	unsigned nr_entries;
>> +	dma_addr_t dma_list[];
>
> Add __counted_by(nr_entries) and update nvme_dma_buf_io_map() so that 
> nr_entries is set at the right time ?

Yeah, that would be useful.

