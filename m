From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: linux-next dm-thinp regression due to "bio: skip
 atomic inc/dec of ->bi_remaining for non-chains"
Date: Wed, 13 May 2015 22:49:53 -0400
Message-ID: <20150514024953.GA17947@redhat.com>
References: <20150513192827.GA15831@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20150513192827.GA15831@redhat.com>
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

On Wed, May 13 2015 at  3:28pm -0400,
Mike Snitzer <snitzer@redhat.com> wrote:

> The device-mapper-test-suite (dmts) thinp tests no longer run due to
> linux-block.git commit c4cf5261 ("bio: skip atomic inc/dec of
> ->bi_remaining for non-chains")
> 
> That commit has been the focus of some other work I have pending because
> I was forced to adapt it due to bi_remaining no longer being accessible
> directly.  So it was surprising/interesting for this commit to take
> center stage in the context of dm-thinp regression.
> 
> bios don't get submitted (simplest reproducer is the 'dd_benchmark' test
> in the dmts thin-provisioning suite which just uses dd with oflag=direct
> immediately after the DM thin device is created).  The top-level DM
> device stays at 100% utilization but no progress is made.  Reverting
> the commit in question resolves the problem.
> 
> But I'm able to use lvm2 to create thin devices that allow IO to
> complete; so I haven't figured out what is so special about dmts (which
> uses dmsetup directly instead of lvm2).
> 
> I'll see if I can figure out what might be happening... but would
> welcome more eyes on this to see if anything stands out relative to the
> dm-thin.c changes.

I've added some tracing.  This issue is isolated to the bio-chain that
is used for dm-thinp's overwrite support -- and other code that follows
this bio-chain pattern (so all non-blk-core bio_inc_remaining() callers
in commit c4cf5261.

In dm-thin.c replace bi_end_io to point to overwrite_endio, at that time
__bi_remaining is 1 (but the new BIO_CHAIN flag is _not_ set):

 device-mapper: thin: save_and_set_endio: before overwrite sector=1536 bi_remaining=1

overwrite_endio() is called and the original end_io restored with
accompanying call to bio_inc_remaining():

 device-mapper: thin: overwrite_endio: before inc sector=1536 bi_remaining=1 
 device-mapper: thin: overwrite_endio:  after inc sector=1536 bi_remaining=2

Then bio_endio() is later called but the original endio won't get called
since __bi_remaining=2 (endio would only drop it to 1).

As you know commit c4cf5261 avoids the atomic operations during endio
unless BIO_CHAIN is set.  It only gets set if bio_inc_remaining() is
used.  But bio_inc_remaining() is only used _after_ the initial endio --
we needed BIO_CHAIN set earlier for these cases.  Seems we need a new
function to register the intent to cascade endios (to allow for proper
accounting)?

We could then switch callers to something like:

  bio_set_chain(bio); // establishes BIO_CHAIN iff __bio_remaining is 1?
  old = io->bi_end_io;
  bio->bi_end_io = new;

 in new():
  bio->bi_end_io = old;
  bio_inc_remaining(bio)

Anyway, not sure about the proper fix -- I do know this commit is a
definite regression (but it does nicely avoid the costly atomics ;)
