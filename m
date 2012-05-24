From: Vivek Goyal <vgoyal@redhat.com>
Subject: Re: [PATCH v2 08/14] block: Kill bi_destructor
Date: Thu, 24 May 2012 15:58:10 -0400
Message-ID: <20120524195810.GB28249@redhat.com>
References: <1337817771-25038-1-git-send-email-koverstreet@google.com>
	<1337817771-25038-9-git-send-email-koverstreet@google.com>
	<20120524195202.GG27550@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20120524195202.GG27550@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Kent Overstreet <koverstreet@google.com>
Cc: axboe@kernel.dk, linux-bcache@vger.kernel.org, linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, dm-devel@redhat.com, mpatocka@redhat.com, bharrosh@panasas.com, tj@kernel.org, yehuda@hq.newdream.net, drbd-dev@lists.linbit.com, agk@redhat.com, sage@newdream.net
List-Id: dm-devel.ids

On Thu, May 24, 2012 at 03:52:02PM -0400, Vivek Goyal wrote:
> On Wed, May 23, 2012 at 05:02:45PM -0700, Kent Overstreet wrote:
> 
> [..]
> > @@ -234,6 +234,13 @@ void bio_free(struct bio *bio, struct bio_set *bs)
> >  {
> >  	void *p;
> >  
> > +	if (!bs) {
> > +		if (bio_integrity(bio))
> > +			bio_integrity_free(bio, fs_bio_set);
> > +		kfree(bio);
> > +		return;
> > +	}
> > +
> 
> Ok, this seems to be the code which will take care of freeing kmalloced
> bio. I think putting little comment about the explicit assumption is not
> a bad idea.
> 
> Somehow we need to integrate two patches so that we don't have memory leak
> in bisection and reading code becomes easier.
> 
> Also then what's the need of bio_reset() in previous patch. That seems to
> be independent from getting rid of pkt_bio_destructor(). I would think
> that keep we can split the patch and keep bio_reset() logic in a separate
> patch. In fact I am not even sure that for one driver we should introduce
> bio_reset() in generic block layer. So to me we should get rid of bio_reset()
> and let all the gory details remain in driver.

Just noticed bio_kmalloc_destructor() will take care of freeing bio_kmalloc()
bios and it has been dropped in this patch. So memory leak point is moot.
bio_reset() question still remains though.

Thanks
Vivek
