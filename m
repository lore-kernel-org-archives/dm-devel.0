Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F21C33C53F;
	Mon, 25 May 2026 06:03:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779689000; cv=none; b=MHZ2M9Flr8+JgEQU4SXZaWc+5cYl0Vlz0bXh74QIF5Ev/1NAkP1F14yLxPQk4YW/gh5PLYY+BGOq9RaJ1GdWbCisaK3nX3dgngUewkyxUvfEVsGloNjsxb+uBMSiuemZfHT2vg3tvOtyqeiq2DUohhGrG8IU/jWY2DQ3XrcUaLA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779689000; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=sTmF5y3RWnhr1DWVd8Or0ZEFJaznlzQv1pW6chpHXDzEMYUkQpAl7rNAPToOw3yQ81TPL1SxcxVPJHlvEbrEYkYZABtdYsSctmnffZBsfwNrFXl4jVmJc5b1QR18i0rH6FhzX7LEQ11Oko+UmCkV7u4E7LgPVCipnYKZg8qxZtI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id B108368C4E; Mon, 25 May 2026 08:03:14 +0200 (CEST)
Date: Mon, 25 May 2026 08:03:14 +0200
From: Christoph Hellwig <hch@lst.de>
To: Mateusz Nowicki <mateusz.nowicki@posteo.net>
Cc: Jens Axboe <axboe@kernel.dk>,
	Caleb Sander Mateos <csander@purestorage.com>,
	Sung-woo Kim <iam@sung-woo.kim>, Josef Bacik <josef@toxicpanda.com>,
	Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@kernel.org>,
	Mikulas Patocka <mpatocka@redhat.com>,
	Benjamin Marzinski <bmarzins@redhat.com>,
	Ulf Hansson <ulfh@kernel.org>, Richard Weinberger <richard@nod.at>,
	Zhihao Cheng <chengzhihao1@huawei.com>,
	Miquel Raynal <miquel.raynal@bootlin.com>,
	Vignesh Raghavendra <vigneshr@ti.com>, Sven Peter <sven@kernel.org>,
	Janne Grunau <j@jannau.net>, Neal Gompa <neal@gompa.dev>,
	Keith Busch <kbusch@kernel.org>, Christoph Hellwig <hch@lst.de>,
	Sagi Grimberg <sagi@grimberg.me>,
	Justin Tee <justin.tee@broadcom.com>,
	Naresh Gottumukkala <nareshgottumukkala83@gmail.com>,
	Paul Ely <paul.ely@broadcom.com>,
	Chaitanya Kulkarni <kch@nvidia.com>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Thomas Fourier <fourier.thomas@gmail.com>,
	Al Viro <viro@zeniv.linux.org.uk>, Luke Wang <ziniu.wang_1@nxp.com>,
	Kees Cook <kees@kernel.org>, linux-block@vger.kernel.org,
	linux-kernel@vger.kernel.org, nbd@other.debian.org,
	dm-devel@lists.linux.dev, linux-mmc@vger.kernel.org,
	linux-mtd@lists.infradead.org, asahi@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	linux-nvme@lists.infradead.org, linux-scsi@vger.kernel.org
Subject: Re: [PATCH v1] block: switch numa_node to int in blk_mq_hw_ctx and
 init_request
Message-ID: <20260525060313.GA3586@lst.de>
References: <20260523125210.272274-1-mateusz.nowicki@posteo.net>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260523125210.272274-1-mateusz.nowicki@posteo.net>
User-Agent: Mutt/1.5.17 (2007-11-01)

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

