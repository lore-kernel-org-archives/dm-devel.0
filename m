From: NeilBrown <neilb@suse.de>
Subject: Re: [dm-devel] [PATCH] Fix over-zealous flush_disk when changing
 device size.
Date: Thu, 17 Mar 2011 12:28:33 +1100
Message-ID: <20110317122833.30077397@notabene.brown>
References: <20110217165057.5c50e566@notabene.brown>
	<20110303143120.GA8134@infradead.org>
	<20110304111624.4be27aaf@notabene.brown>
	<1299259506.2118.24.camel@grinch>
	<20110306174755.49404c8e@notabene.brown>
	<1299471771.2228.11.camel@grinch>
	<1299516418.15258.4.camel@mulgrave.site>
	<20110308094412.1c45b277@notabene.brown>
	<1299538572.15955.90.camel@mulgrave.site>
	<20110308110453.0047307d@notabene.brown>
	<x49pqpq95b5.fsf@segfault.boston.devel.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <x49pqpq95b5.fsf@segfault.boston.devel.redhat.com>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Jeff Moyer <jmoyer@redhat.com>
Cc: James Bottomley <James.Bottomley@suse.de>, device-mapper development <dm-devel@redhat.com>, Jens Axboe <axboe@kernel.dk>, linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org, Christoph Hellwig <hch@infradead.org>, linux-fsdevel@vger.kernel.org
List-Id: dm-devel.ids

On Wed, 16 Mar 2011 16:30:22 -0400 Jeff Moyer <jmoyer@redhat.com> wrote:

> NeilBrown <neilb@suse.de> writes:
> 
> >> Synchronous notification of errors.  If we don't try to write everything
> >> back immediately after the size change, we don't see dirty pages in
> >> zapped regions until the writeout/page cache management takes it into
> >> its head to try to clean the pages.
> >> 
> >
> > So if you just want synchronous errors, I think you want:
> >     fsync_bdev()
> >
> > which calls sync_filesystem() if it can find a filesystem, else
> > sync_blockdev();  (sync_filesystem itself calls sync_blockdev too).
> 
> ... which deadlocks md.  ;-)  writeback_inodes_sb_nr is waiting for the
> flusher thread to write back the dirty data.  The flusher thread is
> stuck in md_write_start, here:
> 
>         wait_event(mddev->sb_wait,
>                    !test_bit(MD_CHANGE_PENDING, &mddev->flags));
> 
> This is after reverting your change, and replacing the flush_disk call
> in check_disk_size_change with a call to fsync_bdev.  I'm not familiar
> enough with md to really suggest a way forward.  Neil?

That would be quite easy to avoid.
Just call
   md_write_start()
before revalidate_disk, and
   md_write_end()
afterwards.
You wouldn't have a 'bio' to pass in - but it is rather ugly requiring
one anyway - I should fix that.
For testing, just pass in NULL, and change
	if (bio_data_dir(bi) != WRITE)
		return;
to
	if (bi && bio_data_dir(bi) != WRITE)
		return;

NeilBrown

