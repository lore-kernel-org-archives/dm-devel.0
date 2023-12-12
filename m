Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 245486167C
	for <dm-devel@lists.linux.dev>; Tue, 12 Dec 2023 13:13:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="uD68zqhA"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=0Dfuz2M62ropeVCnMi+DeMixqMy40tI6fG5R+q0UR1c=; b=uD68zqhAUEPOL3jg0OQPdz1c+n
	Q+zPotfLguZ/NzMpo87/5NFm/wD5z4gHcd+3w3XF7WjFldowFP6/vwwYEwysRc+1hrV7iI8E2kUPz
	bHBgU36QPKuLWG+GbHkUERm1OmYXtOYu6/FkJVLY455exS6mJXiFjhrh8NsKuXRBFB1LFqjKhlOLe
	OTC05wvqgbEEN30DGz7T1QodEcJ24RHKmqkFsiRtjfyrgU00EMb5yVYOJADNihSuxNUKbSLUfJ6QB
	kSuG2/6RpslfdLtXD76LW4vImZgkrmftXI4LfMiXjQqUiAWc2DUkA2nhlEYcxxZ4Ujz0fq5aBBOXP
	0rK++uig==;
Received: from hch by bombadil.infradead.org with local (Exim 4.96 #2 (Red Hat Linux))
	id 1rD2ZV-00BlUt-0Y;
	Tue, 12 Dec 2023 13:13:13 +0000
Date: Tue, 12 Dec 2023 05:13:13 -0800
From: Christoph Hellwig <hch@infradead.org>
To: Hongyu Jin <hongyu.jin.cn@gmail.com>
Cc: agk@redhat.com, snitzer@kernel.org, mpatocka@redhat.com,
	axboe@kernel.dk, ebiggers@kernel.org, zhiguo.niu@unisoc.com,
	ke.wang@unisoc.com, yibin.ding@unisoc.com, hongyu.jin@unisoc.com,
	linux-kernel@vger.kernel.org, dm-devel@lists.linux.dev,
	linux-block@vger.kernel.org
Subject: Re: [PATCH v4 1/5] block: Fix bio IO priority setting
Message-ID: <ZXhcaQh3UFZmyFmQ@infradead.org>
References: <ZXeJ9jAKEQ31OXLP@redhat.com>
 <20231212111150.18155-1-hongyu.jin.cn@gmail.com>
 <20231212111150.18155-2-hongyu.jin.cn@gmail.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231212111150.18155-2-hongyu.jin.cn@gmail.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Tue, Dec 12, 2023 at 07:11:46PM +0800, Hongyu Jin wrote:
> From: Hongyu Jin <hongyu.jin@unisoc.com>
> 
> Move bio_set_ioprio() into submit_bio():
> 1. Only call bio_set_ioprio() once to set the priority of original bio,
>    the bio that cloned and splited from original bio will auto inherit
>    the priority of original bio in clone process.
> 
> 2. The IO priority can be passed to module that implement
>    struct gendisk::fops::submit_bio, help resolve some
>    of the IO priority loss issues.

Can we reword this a bit.  AFAICS what this primarily does it to ensure
the priority is set before dispatching to submit_bio based drivers or
blk-mq instead of just blk-mq, and the rest follows from that.

> +static void bio_set_ioprio(struct bio *bio)
> +{
> +	/* Nobody set ioprio so far? Initialize it based on task's nice value */
> +	if (IOPRIO_PRIO_CLASS(bio->bi_ioprio) == IOPRIO_CLASS_NONE)
> +		bio->bi_ioprio = get_current_ioprio();
> +	blkcg_set_ioprio(bio);
> +}

I don't think we need the check here as anyone resubmitting a bio should
be using submit_bio_noact.
