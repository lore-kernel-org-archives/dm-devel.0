From: Jens Axboe <jens.axboe@oracle.com>
Subject: Re: 2.6.23-mm1
Date: Mon, 15 Oct 2007 09:45:01 +0200
Message-ID: <20071015074500.GE5380@kernel.dk>
References: <47110500.8050503@garzik.org>
	<64bb37e0710131105m7c64fca0kb71f3955170e8bec@mail.gmail.com>
	<20071013111853.7e67c6c3.akpm@linux-foundation.org>
	<64bb37e0710140454s61325fdfya43179b14ea26dc4@mail.gmail.com>
	<20071014113914.7654759d.akpm@linux-foundation.org>
	<64bb37e0710141212k58c5fc66s620d1f28e80bb40@mail.gmail.com>
	<20071014122613.5bbe4fc3.akpm@linux-foundation.org>
	<4712922F.6010005@redhat.com> <20071015065022.GC5380@kernel.dk>
	<18195.5992.545271.871100@notabene.brown>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <18195.5992.545271.871100@notabene.brown>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Neil Brown <neilb@suse.de>
Cc: linux-kernel@vger.kernel.org, Torsten Kaiser <just.for.lkml@googlemail.com>, dm-devel@redhat.com, Andrew Morton <akpm@linux-foundation.org>, Alasdair G Kergon <agk@redhat.com>
List-Id: dm-devel.ids

On Mon, Oct 15 2007, Neil Brown wrote:
> On Monday October 15, jens.axboe@oracle.com wrote:
> > On Mon, Oct 15 2007, Milan Broz wrote:
> > > 
> > > clone->bi_size is zero here now, so crypt_free_buffer_pages will not
> > > work correctly (previously there was count of processed bytes).
> > > 
> > > But because it seems that bio cannot be processed partially now, we can
> > > simplify crypt_free_buffer_pages to always remove all allocated pages.
> > 
> > Neil, this doesn't look very good. dm-crypt needs to know the clone io
> > size, so ->bi_size was definitely used properly in this context before.
> > Now it's gone. Suggestions on how to fix that up?
> 
> How about the following - even more code simplification gained by this
> approach :-)

Looks good to me.

> I originally had the patch for removing the 'size' argument after a
> patch (series) that made bi_size unchanged.   It seemed that patch
> would face a harder path upstream so I re-ordered them and missed this
> dependency.  Mea Culpa.
> 
> > 
> > I've been less than impressed with the bi_end_io() patchset so far, it's
> > been full of typos and bad conversions. I'm tempted to revert the whole
> > thing, clearly it wasn't ready for merge.
> 
> I must have missed something ....
> 
> I've seen:  A fix for a bi_end_io in jfs that I missed.
>             A correction for that fix ("return 0" was remove instead
>                of just the '0' removed)
>             Some fixed for code that is only in -mm (which I didn't do
>               because I thought you wanted it against a non-mm tree).

XFS update, s390 block driver, gfs2 update, ocfs2 update, powerpc
axonram block driver.

> I think it was definitely ready for merging in -mm.  Possibly not for
> mainline just yet.

What's done is done, I just hope we've seen the last of it now.

-- 
Jens Axboe
