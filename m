From: Vitaly Chikunov <vt@altlinux.org>
Subject: Re: dm: add secdel target
Date: Fri, 19 Oct 2018 15:02:10 +0300
Message-ID: <20181019120209.osicx2v3vebvsxqr@sole.flsd.net>
References: <20181014112439.8119-1-vt@altlinux.org>
 <20181018200124.GA6996@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=koi8-r
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20181018200124.GA6996@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Mike Snitzer <snitzer@redhat.com>
Cc: Alasdair Kergon <agk@redhat.com>, dm-devel@redhat.com, Jonathan Corbet <corbet@lwn.net>, Shaohua Li <shli@kernel.org>, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org
List-Id: dm-devel.ids

On Thu, Oct 18, 2018 at 04:01:25PM -0400, Mike Snitzer wrote:
> On Sun, Oct 14 2018 at  7:24am -0400,
> Vitaly Chikunov <vt@altlinux.org> wrote:
> 
> > Report to the upper level ability to discard, and translate arriving
> > discards to the writes of random or zero data to the underlying level.
> > 
> > Signed-off-by: Vitaly Chikunov <vt@altlinux.org>
> > ---
> >   This target is the same as the linear target except that is reports ability to
> >   discard to the upper level and translates arriving discards into sector
> >   overwrites with random (or zero) data.
> 
> There is a fair amount of code duplication between dm-linear.c and this
> new target.
> 
> Something needs to give, ideally you'd factor out methods that are
> shared by both targets, but those methods must _not_ introduce overhead
> to dm-linear.

I see three possible solutions:
 - integrate 'secdel' into dm-linear;
 - export functions like linear_dax_copy_to_iter and fill them into
   secdel's `struct target_type`;
 - call methods of linear's `struct target_type` from secdel's one.

> Could be that dm-linear methods just get called by the wrapper
> dm-sec-erase target (more on the "dm-sec-erase" name below).

> > diff --git a/drivers/md/dm-secdel.c b/drivers/md/dm-secdel.c
> > new file mode 100644
> > index 000000000000..9aeaf3f243c0
> > --- /dev/null
> > +++ b/drivers/md/dm-secdel.c
> ... 
> > +			if (mode == SECDEL_MODE_RAND) {
> > +				page = alloc_page(gfp_mask);
> > +				if (!page) {
> > +					DMERR("%s %lu[%lu]: no memory to allocate page for random data",
> > +					      __func__, sector, nr_sects);
> > +					/* will fallback to zero filling */
> 
> In general, performing memory allocations to service IO is something all
> DM core and DM targets must work to avoid.  This smells bad.
> 
> ...

Yes, but we need to create and write random data, so I don't see other
solution. In zero overwriting mode page is not allocated. And it's fall
back to zero overwriting if page allocation fails for random data.

> Mike

I will address these and other your concerns in v2.

Thanks!
