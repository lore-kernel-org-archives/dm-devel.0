From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: dm-crypt: Fix error with too large bios
Date: Sat, 13 Aug 2016 20:07:40 -0400
Message-ID: <20160814000740.GA5317@redhat.com>
References: <alpine.LRH.2.11.1608102050200.10662@mail.ewheeler.net>
	<alpine.LRH.2.02.1608131342250.3291@file01.intranet.prod.int.rdu2.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <alpine.LRH.2.02.1608131342250.3291@file01.intranet.prod.int.rdu2.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: Eric Wheeler <dm-devel@lists.ewheeler.net>, dm-devel@redhat.com, hch@lst.de, johnstonj.public@codenest.com
List-Id: dm-devel.ids

[top-posting just because others went wild with it]

I don't have a strong opinion but I just assumed the local dm-crypt
workaround wasn't the way forward.  I didn't stage it because Christoph
disagreed with it:
https://lkml.org/lkml/2016/6/1/456
https://lkml.org/lkml/2016/6/1/477

Also, this would appear to be a more generic fix:
"block: make sure big bio is splitted into at most 256 bvecs
https://lkml.org/lkml/2016/8/12/154
(but Christoph disagrees there too, so the way forward isn't clear)

Mike

On Sat, Aug 13 2016 at  1:45pm -0400,
Mikulas Patocka <mpatocka@redhat.com> wrote:

> Yes, this should be backported. It was lost somehow.
> 
> Mike, please put it to your git.
> 
> Mikulas
> 
> 
> On Wed, 10 Aug 2016, Eric Wheeler wrote:
> 
> > Hello Mikulas and dm-devel list,
> > 
> > The simple patch below with is confirmed to fix James Johnston's issue and 
> > doesn't appear to be in v4.8-rc1:
> > 
> > This references the following patchwork entry:
> >   https://patchwork.kernel.org/patch/9138595/
> > 
> > Can we get this pushed upstream for v4.8?
> > 
> > --
> > Eric Wheeler
> > 
> > 
> > On Fri, 27 May 2016, Mikulas Patocka wrote:
> > > dm-crypt: Fix error with too large bios
> > > 
> > > When dm-crypt processes writes, it allocates a new bio in the function
> > > crypt_alloc_buffer. The bio is allocated from a bio set and it can have at
> > > most BIO_MAX_PAGES vector entries, however the incoming bio can be larger
> > > if it was allocated by other means. For example, bcache creates bios
> > > larger than BIO_MAX_PAGES. If the incoming bio is larger, bio_alloc_bioset
> > > fails and error is returned.
> > > 
> > > To avoid the error, we test for too large bio in the function crypt_map
> > > and dm_accept_partial_bio to split the bio. dm_accept_partial_bio trims
> > > the current bio to the desired size and requests that the device mapper
> > > core sends another bio with the rest of the data.
> > > 
> > > Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
> > > Cc: stable@vger.kernel.org	# v3.16+
> > 
> > Tested-by: James Johnston <johnstonj.public@codenest.com>
> > 
> > I tested this patch by:
> > 
> > 1.  Building v4.7-rc1 from Torvalds git repo.  Confirmed that original bug
> >     still occurs on Ubuntu 15.10.
> > 
> > 2.  Applying your patch to v4.7-rc1.  My kill sequence no longer works,
> >     and the writeback cache is now successfully flushed to disk, and the
> >     cache can be detached from the backing device.
> > 
> > 3.  To check data integrity, copied 250 MB of /dev/urandom to some file
> >     on main volume.  Then, dd copy this file to /dev/bcache0.  Then,
> >     detached the cache device from the backing device.  Then, rebooted.
> >     Then, dd copy /dev/bcache0 to another file on main volume.  Then,
> >     diff the files and confirm no changes.
> > 
> > So it looks like it works, based on this admittedly brief testing.  Thanks!
> > 
> > Best regards,
> > 
> > James Johnston
> > 
> > 
> > --
> > dm-devel mailing list
> > dm-devel@redhat.com
> > https://www.redhat.com/mailman/listinfo/dm-devel
> > 
> > Patch
> > 
> > Index: linux-4.6/drivers/md/dm-crypt.c
> > ===================================================================
> > --- linux-4.6.orig/drivers/md/dm-crypt.c
> > +++ linux-4.6/drivers/md/dm-crypt.c
> > @@ -2137,6 +2137,10 @@  static int crypt_map(struct dm_target *t
> >  	struct dm_crypt_io *io;
> >  	struct crypt_config *cc = ti->private;
> >  
> > +	if (unlikely(bio->bi_iter.bi_size > BIO_MAX_SIZE) &&
> > +	    (bio->bi_rw & (REQ_FLUSH | REQ_DISCARD | REQ_WRITE)) == REQ_WRITE)
> > +		dm_accept_partial_bio(bio, BIO_MAX_SIZE >> SECTOR_SHIFT);
> > +
> >  	/*
> >  	 * If bio is REQ_FLUSH or REQ_DISCARD, just bypass crypt queues.
> >  	 * - for REQ_FLUSH device-mapper core ensures that no IO is in-flight
> > 
> > 
> > 
> > 
