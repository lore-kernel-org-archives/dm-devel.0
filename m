From: Kent Overstreet <koverstreet@google.com>
Subject: Re: [PATCH v3 01/26] block: Fix a buffer overrun in
 bio_integrity_split()
Date: Tue, 2 Oct 2012 14:01:43 -0700
Message-ID: <20121002210143.GT26488@google.com>
References: <1348526106-17074-1-git-send-email-koverstreet@google.com>
	<1348526106-17074-2-git-send-email-koverstreet@google.com>
	<20121001212336.GA17165@redhat.com>
	<20121001214241.GE26488@google.com>
	<20121002140847.GD758@redhat.com>
	<20121002202643.GQ26488@google.com>
	<20121002203253.GA14471@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20121002203253.GA14471@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Vivek Goyal <vgoyal@redhat.com>
Cc: axboe@kernel.dk, "Martin K. Petersen" <martin.petersen@oracle.com>, dm-devel@redhat.com, linux-kernel@vger.kernel.org, linux-bcache@vger.kernel.org, tj@kernel.org
List-Id: dm-devel.ids

On Tue, Oct 02, 2012 at 04:32:53PM -0400, Vivek Goyal wrote:
> On Tue, Oct 02, 2012 at 01:26:43PM -0700, Kent Overstreet wrote:
> > On Tue, Oct 02, 2012 at 10:08:47AM -0400, Vivek Goyal wrote:
> > > On Mon, Oct 01, 2012 at 02:42:41PM -0700, Kent Overstreet wrote:
> > > 
> > > [..]
> > > > Here's the new patch:
> > > > 
> > > > 
> > > > commit e270c9ca843b5c86d59431b0d7a676b7846946d6
> > > > Author: Kent Overstreet <koverstreet@google.com>
> > > > Date:   Mon Oct 1 14:41:08 2012 -0700
> > > > 
> > > >     block: Fix a buffer overrun in bio_integrity_split()
> > > >     
> > > >     bio_integrity_split() seemed to be confusing pointers and arrays -
> > > >     bip_vec in bio_integrity_payload is an array appended to the end of the
> > > >     payload, so the bio_vecs in struct bio_pair need to come immediately
> > > >     after the bio_integrity_payload they're for, and there was an assignment
> > > >     in bio_integrity_split() that didn't make any sense.
> > > >     
> > > >     Also, changed bio_integrity_split() to not refer to the bvecs embedded
> > > >     in struct bio_pair, in case there's padding between them and
> > > >     bip->bip_vec.
> > > >     
> > > >     Signed-off-by: Kent Overstreet <koverstreet@google.com>
> > > >     CC: Jens Axboe <axboe@kernel.dk>
> > > >     CC: Martin K. Petersen <martin.petersen@oracle.com>
> > > > 
> > > > diff --git a/fs/bio-integrity.c b/fs/bio-integrity.c
> > > > index a3f28f3..4ae22a8 100644
> > > > --- a/fs/bio-integrity.c
> > > > +++ b/fs/bio-integrity.c
> > > > @@ -694,15 +694,12 @@ void bio_integrity_split(struct bio *bio, struct bio_pair *bp, int sectors)
> > > >  	bp->bio1.bi_integrity = &bp->bip1;
> > > >  	bp->bio2.bi_integrity = &bp->bip2;
> > > >  
> > > > -	bp->iv1 = bip->bip_vec[0];
> > > > -	bp->iv2 = bip->bip_vec[0];
> > > > +	*bp->bip1.bip_vec = bip->bip_vec[0];
> > > > +	*bp->bip2.bip_vec = bip->bip_vec[0];
> > > 
> > > I think this is horrible. Why not introduce bvec pointer in bip (like bio),
> > > to cover the case when bvec are not inline.
> > 
> > That's... exactly what the next patch in the series does.
> 
> Yes, but if you want to push some of the these bug fixes in stable (as martin
> had said), we need to introduce that bip->bio_vec pointer early. Also that
> next patch is doing lot other other things like getting rid of bip_slabs
> and we don't require all that to fix this particular bug.
> 
> In fact I would say that it is beter to fix this blk integrity bug in a
> separate patchset so that it can be pushed out earlier.

I'm honestly not sure what your complaint about my bugfix patch was -
it's small and complete, it does fix the bug. I don't follow why you
think we need to introduce the bip->bio_vec pointer early...
