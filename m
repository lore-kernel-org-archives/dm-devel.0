From: Kent Overstreet <koverstreet@google.com>
Subject: Re: [PATCH v5 01/12] block: Generalized bio pool freeing
Date: Wed, 8 Aug 2012 17:26:53 -0700
Message-ID: <20120809002653.GF7262@moria.home.lan>
References: <1344290921-25154-1-git-send-email-koverstreet@google.com>
 <1344290921-25154-2-git-send-email-koverstreet@google.com>
 <20120808222515.GE6983@dhcp-172-17-108-109.mtv.corp.google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20120808222515.GE6983@dhcp-172-17-108-109.mtv.corp.google.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Tejun Heo <tj@kernel.org>
Cc: linux-bcache@vger.kernel.org, linux-kernel@vger.kernel.org, dm-devel@redhat.com, axboe@kernel.dk, agk@redhat.com, neilb@suse.de, drbd-dev@lists.linbit.com, vgoyal@redhat.com, mpatocka@redhat.com, sage@newdream.net, yehuda@hq.newdream.net
List-Id: dm-devel.ids

On Wed, Aug 08, 2012 at 03:25:15PM -0700, Tejun Heo wrote:
> On Mon, Aug 06, 2012 at 03:08:30PM -0700, Kent Overstreet wrote:
> > @@ -422,7 +409,11 @@ void bio_put(struct bio *bio)
> >  	if (atomic_dec_and_test(&bio->bi_cnt)) {
> >  		bio_disassociate_task(bio);
> >  		bio->bi_next = NULL;
> > -		bio->bi_destructor(bio);
> > +
> > +		if (bio->bi_pool)
> > +			bio_free(bio, bio->bi_pool);
> > +		else
> > +			bio->bi_destructor(bio);
> 
> So, this bi_pool overriding caller specified custom bi_destructor is
> rather unusual.  I know why it's like that - the patch series is
> gradually replacing bi_destructor with bi_pool and removes
> bi_destructor eventually, but it would be far better if at least patch
> description says why this is unusual like this.

Ok, I'll stick a comment in there:

	if (atomic_dec_and_test(&bio->bi_cnt)) {
		bio_disassociate_task(bio);
		bio->bi_next = NULL;

		/*
		 * This if statement is temporary - bi_pool is replacing
		 * bi_destructor, but bi_destructor will be taken out in another
		 * patch.
		 */
		if (bio->bi_pool)
			bio_free(bio, bio->bi_pool);
		else
			bio->bi_destructor(bio);
	}

> 
> Thanks.
> 
> -- 
> tejun
