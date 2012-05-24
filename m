From: Vivek Goyal <vgoyal@redhat.com>
Subject: Re: [PATCH v2 08/14] block: Kill bi_destructor
Date: Thu, 24 May 2012 15:52:02 -0400
Message-ID: <20120524195202.GG27550@redhat.com>
References: <1337817771-25038-1-git-send-email-koverstreet@google.com>
 <1337817771-25038-9-git-send-email-koverstreet@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1337817771-25038-9-git-send-email-koverstreet@google.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Kent Overstreet <koverstreet@google.com>
Cc: linux-kernel@vger.kernel.org, linux-bcache@vger.kernel.org, dm-devel@redhat.com, linux-fsdevel@vger.kernel.org, tj@kernel.org, axboe@kernel.dk, agk@redhat.com, neilb@suse.de, drbd-dev@lists.linbit.com, bharrosh@panasas.com, mpatocka@redhat.com, sage@newdream.net, yehuda@hq.newdream.net
List-Id: dm-devel.ids

On Wed, May 23, 2012 at 05:02:45PM -0700, Kent Overstreet wrote:

[..]
> @@ -234,6 +234,13 @@ void bio_free(struct bio *bio, struct bio_set *bs)
>  {
>  	void *p;
>  
> +	if (!bs) {
> +		if (bio_integrity(bio))
> +			bio_integrity_free(bio, fs_bio_set);
> +		kfree(bio);
> +		return;
> +	}
> +

Ok, this seems to be the code which will take care of freeing kmalloced
bio. I think putting little comment about the explicit assumption is not
a bad idea.

Somehow we need to integrate two patches so that we don't have memory leak
in bisection and reading code becomes easier.

Also then what's the need of bio_reset() in previous patch. That seems to
be independent from getting rid of pkt_bio_destructor(). I would think
that keep we can split the patch and keep bio_reset() logic in a separate
patch. In fact I am not even sure that for one driver we should introduce
bio_reset() in generic block layer. So to me we should get rid of bio_reset()
and let all the gory details remain in driver.

Thanks
Vivek
