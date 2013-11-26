From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 1/5] block: Make generic_make_request handle arbitrary
 sized bios
Date: Mon, 25 Nov 2013 22:09:21 -0800
Message-ID: <20131126060921.GB6434@infradead.org>
References: <1385418633-9753-1-git-send-email-kmo@daterainc.com>
 <1385418633-9753-2-git-send-email-kmo@daterainc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1385418633-9753-2-git-send-email-kmo@daterainc.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Kent Overstreet <kmo@daterainc.com>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, axboe@kernel.dk, Neil Brown <neilb@suse.de>, Alasdair Kergon <agk@redhat.com>, dm-devel@redhat.com
List-Id: dm-devel.ids

> +	q->bio_split = bioset_create(4, 0);
> +	if (!q->bio_split)
> +		goto fail_id;

How did we arrive at a mempool size of 4 to make sure we can always make
progress with arbitrarily sized bios?  Shouldn't we document the design
decision somewhere?

> +static struct bio *blk_bio_discard_split(struct request_queue *q,
> +					 struct bio *bio,
> +					 struct bio_set *bs)
> +{

One fallout of this should be that it would allows us to impement
a range UNMAP/TRIP much more easily, which would help dramatically
with TRIM performance!
