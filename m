From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: [PATCH 2/2] dm thin: support for non power of 2 pool
	blocksize
Date: Mon, 30 Apr 2012 13:33:47 -0400
Message-ID: <20120430173347.GB19033@redhat.com>
References: <1335588269-807-1-git-send-email-snitzer@redhat.com>
	<1335588269-807-2-git-send-email-snitzer@redhat.com>
	<20120430095555.GA5955@ubuntu>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20120430095555.GA5955@ubuntu>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: dm-devel@redhat.com, ejt@redhat.com, agk@redhat.com
List-Id: dm-devel.ids

On Mon, Apr 30 2012 at  5:55am -0400,
Joe Thornber <thornber@redhat.com> wrote:

> Hi Mike,
> 
> In general this looks good.  A lot cleaner now you've dropped the
> specialisation of the division.  A few nit-picks below.
> 
> - Joe
> 
> On Sat, Apr 28, 2012 at 12:44:29AM -0400, Mike Snitzer wrote:
> > +/*
> > + * do_div wrappers that don't modify the dividend
> > + */
> > +static inline sector_t dm_thin_do_div(sector_t a, __u32 b)
> > +{
> > +	sector_t r = a;
> > +
> > +	do_div(r, b);
> > +	return r;
> > +}
> > +
> > +static inline sector_t dm_thin_do_mod(sector_t a, __u32 b)
> > +{
> > +	sector_t tmp = a;
> > +
> > +	return do_div(tmp, b);
> > +}
> 
> Please don't inline static functions.  Let the compiler make the
> decision.

But in this instance we certainly want it inlined; regardless of whether
the compiler might do it anyway.   Why would we ever want to allow the
compiler to not inline it?

> Also those sector_t's are passed by value, so you don't need to
> declare r or tmp.  eg, it's enough to do this:
> 
> static sector_t dm_thin_do_div(sector_t a, __u32 b)
> {
> 	do_div(a, b);
> 	return a;
> }
> 
> static sector_t dm_thin_do_mod(sector_t a, __u32 b)
> {
> 	return do_div(a, b);
> }

OK, makes sense.

> > @@ -1941,12 +1954,18 @@ static int pool_ctr(struct dm_target *ti, unsigned argc, char **argv)
> 
> ...
> 
> > +	if (dm_thin_do_mod(ti->len, block_size)) {
> > +		ti->error = "Data device is not a multiple of block size";
> > +		r = -EINVAL;
> > +		goto out;
> > +	}
> 
> I don't see the need for this check.  If I have a disk that isn't a
> multiple of the block size why should I have to layer a linear mapping
> on it to truncate it before I can use it as a data volume?  Any
> partial block at the end of the device is already ignored (see the
> data_size calculation in pool_preresume).  Is this restriction causing
> some of the changes you made to the test-suite?

Yes.  But imposing this restriction was motivated by and the "attempt to
access beyond end of device" failures I saw with test_origin_unchanged
(I shared more details about this in private mail to you and kabi on
4/25 -- making the pool size a multiple of the non power of 2 blocksize
resolved that failure).
