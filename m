Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7804213D612
	for <dm-devel@lists.linux.dev>; Tue,  4 Jun 2024 04:40:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717476048; cv=none; b=QWNJWq/SJbGdRNaplGFLHXb+cAAK1QeNoCyrZkfsVDxWBUOcj9jLtl/RXLaiqIhm4sdOB6SCG8/WLI2bQOMaJ2ZZwf9ybCAEf4SAVEcgs8Fy6ec6Qj0zssWU7PCB3rxo92y6Hx0XNXzo8+cuA9gPUPtuX4yQYcSukjgI8OIX9OY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717476048; c=relaxed/simple;
	bh=YspLg/oZO+NECETpz3U99drDYtBVvMb6eMXzhEQZu1I=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=A/8mTVcM7rK+vbC8IIay1mkTEQxKF70mHMYVNw4ITYqgeX9xX8pfqlpjcvwCakcE1Foxqk6PxGjg3dWA3idJibKCuwVl9bKohkh343GnEfScaDlhAxpN3MTLE6hE/h9bJI217xdC65tB0kh5psMTmIM6+K5VCN4DCGKoP5q71mY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id EAF7068D12; Tue,  4 Jun 2024 06:40:42 +0200 (CEST)
Date: Tue, 4 Jun 2024 06:40:42 +0200
From: Christoph Hellwig <hch@lst.de>
To: Bart Van Assche <bvanassche@acm.org>
Cc: Christoph Hellwig <hch@lst.de>, Nitesh Shetty <nj.shetty@samsung.com>,
	Damien Le Moal <dlemoal@kernel.org>, Jens Axboe <axboe@kernel.dk>,
	Jonathan Corbet <corbet@lwn.net>, Alasdair Kergon <agk@redhat.com>,
	Mike Snitzer <snitzer@kernel.org>,
	Mikulas Patocka <mpatocka@redhat.com>,
	Keith Busch <kbusch@kernel.org>, Sagi Grimberg <sagi@grimberg.me>,
	Chaitanya Kulkarni <kch@nvidia.com>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>,
	martin.petersen@oracle.com, david@fromorbit.com, hare@suse.de,
	damien.lemoal@opensource.wdc.com, anuj20.g@samsung.com,
	joshi.k@samsung.com, nitheshshetty@gmail.com, gost.dev@samsung.com,
	linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-doc@vger.kernel.org, dm-devel@lists.linux.dev,
	linux-nvme@lists.infradead.org, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH v20 02/12] Add infrastructure for copy offload in block
 and request layer.
Message-ID: <20240604044042.GA29094@lst.de>
References: <20240520102033.9361-1-nj.shetty@samsung.com> <CGME20240520102842epcas5p4949334c2587a15b8adab2c913daa622f@epcas5p4.samsung.com> <20240520102033.9361-3-nj.shetty@samsung.com> <eda6c198-3a29-4da4-94db-305cfe28d3d6@acm.org> <9f1ec1c1-e1b8-48ac-b7ff-8efb806a1bc8@kernel.org> <a866d5b5-5b01-44a2-9ccb-63bf30aa8a51@acm.org> <665850bd.050a0220.a5e6b.5b72SMTPIN_ADDED_BROKEN@mx.google.com> <abe8c209-d452-4fb5-90eb-f77b5ec1a2dc@acm.org> <20240601055931.GB5772@lst.de> <d7ae00c8-c038-4bed-937e-222251bc627a@acm.org>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d7ae00c8-c038-4bed-937e-222251bc627a@acm.org>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Mon, Jun 03, 2024 at 10:12:48AM -0700, Bart Van Assche wrote:
> Consider the following use case:
> * Task A calls blk_start_plug()
> * Task B calls blk_start_plug()
> * Task A submits a REQ_OP_COPY_DST bio and a REQ_OP_COPY_SRC bio.
> * Task B submits a REQ_OP_COPY_DST bio and a REQ_OP_COPY_SRC bio.
> * The stacking driver to which all REQ_OP_COPY_* operations have been
>   submitted processes bios asynchronusly.
> * Task A calls blk_finish_plug()
> * Task B calls blk_finish_plug()
> * The REQ_OP_COPY_DST bio from task A and the REQ_OP_COPY_SRC bio from
>   task B are combined into a single request.
> * The REQ_OP_COPY_DST bio from task B and the REQ_OP_COPY_SRC bio from
>   task A are combined into a single request.
>
> This results in silent and hard-to-debug data corruption. Do you agree
> that we should not restrict copy offloading to stacking drivers that
> process bios synchronously and also that this kind of data corruption
> should be prevented?

There is no requirement to process them synchronously, there is just
a requirement to preserve the order.  Note that my suggestion a few
arounds ago also included a copy id to match them up.  If we don't
need that I'm happy to leave it away.  If need it it to make stacking
drivers' lifes easier that suggestion still stands.

>
> Thanks,
>
> Bart.
---end quoted text---
