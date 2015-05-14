From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: linux-next dm-thinp regression due to "bio: skip
 atomic inc/dec of ->bi_remaining for non-chains"
Date: Wed, 13 May 2015 23:29:53 -0400
Message-ID: <20150514032953.GB17947@redhat.com>
References: <20150513192827.GA15831@redhat.com>
	<20150514024953.GA17947@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20150514024953.GA17947@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: axboe@kernel.dk
Cc: Robert Elliott <elliott@hp.com>, dm-devel@redhat.com, Jan Kara <jack@suse.cz>, hch@lst.de, Kent Overstreet <kent.overstreet@gmail.com>
List-Id: dm-devel.ids

On Wed, May 13 2015 at 10:49pm -0400,
Mike Snitzer <snitzer@redhat.com> wrote:
 
> As you know commit c4cf5261 avoids the atomic operations during endio
> unless BIO_CHAIN is set.  It only gets set if bio_inc_remaining() is
> used.  But bio_inc_remaining() is only used _after_ the initial endio --
> we needed BIO_CHAIN set earlier for these cases.  Seems we need a new
> function to register the intent to cascade endios (to allow for proper
> accounting)?
> 
> We could then switch callers to something like:
> 
>   bio_set_chain(bio); // establishes BIO_CHAIN iff __bio_remaining is 1?
>   old = io->bi_end_io;
>   bio->bi_end_io = new;
> 
>  in new():
>   bio->bi_end_io = old;
>   bio_inc_remaining(bio)
> 
> Anyway, not sure about the proper fix -- I do know this commit is a
> definite regression (but it does nicely avoid the costly atomics ;)

Just adding this to dm-thin.c:save_and_set_endio() fixed it:
 bio->bi_flags |= (1 << BIO_CHAIN);

(setting a bit doesn't need a bio_set_chain fn like I suggested above).

But, all relevant callers would need this treatment (I'd imagine
bio_endio_nodec callers need help too? -- either that or __bi_remaining
is completely irrelevant for all old users except for bio_chain()).
