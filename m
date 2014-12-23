From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [RFC PATCH 01/17] block: make generic_make_request handle
 arbitrarily sized bios
Date: Tue, 23 Dec 2014 02:16:14 -0800
Message-ID: <20141223101614.GA13138@infradead.org>
References: <cover.1419241597.git.dongsu.park@profitbricks.com>
 <d26a9a0fc9a7d1529c115785ee5935d5750782bd.1419241597.git.dongsu.park@profitbricks.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <d26a9a0fc9a7d1529c115785ee5935d5750782bd.1419241597.git.dongsu.park@profitbricks.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Dongsu Park <dongsu.park@profitbricks.com>
Cc: linux-kernel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>, Kent Overstreet <kmo@daterainc.com>, Ming Lin <mlin@minggr.net>, Christoph Hellwig <hch@infradead.org>, Al Viro <viro@zeniv.linux.org.uk>, Ming Lei <ming.lei@canonical.com>, Neil Brown <neilb@suse.de>, Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@redhat.com>, dm-devel@redhat.com, drbd-dev@lists.linbit.com, Jiri Kosina <jkosina@suse.cz>, Geoff Levand <geoff@infradead.org>, Jim Paris <jim@jtan.com>, Joshua Morris <josh.h.morris@us.ibm.com>, Philip Kelleher <pjk1939@linux.vnet.ibm.com>, Minchan Kim <minchan@kernel.org>, Nitin Gupta <ngupta@vflare.org>, Oleg Drokin <oleg.drokin@intel.com>, Andreas Dilger <andreas.dilger@intel.com>
List-Id: dm-devel.ids

> +void blk_queue_split(struct request_queue *q, struct bio **bio,
> +		     struct bio_set *bs)
> +{
> +	struct bio *split;
> +
> +	if ((*bio)->bi_rw & REQ_DISCARD)
> +		split = blk_bio_discard_split(q, *bio, bs);
> +	else if ((*bio)->bi_rw & REQ_WRITE_SAME)
> +		split = blk_bio_write_same_split(q, *bio, bs);
> +	else
> +		split = blk_bio_segment_split(q, *bio, q->bio_split);
> +
> +	if (split) {
> +		bio_chain(split, *bio);
> +		generic_make_request(*bio);
> +		*bio = split;
> +	}
> +}
> +EXPORT_SYMBOL(blk_queue_split);

I think blk_queue_split needs to explicitly skip BLOCK_PC bios.  Those
are SCSI pass through ioctls that we can't split due to their opaque
nature.
