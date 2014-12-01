From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: dm-bufio: fix memleak when using a dm_buffer's inline bio
Date: Mon, 1 Dec 2014 11:27:53 -0500
Message-ID: <20141201162753.GA8227@redhat.com>
References: <20141126014515.GE10050@birch.djwong.org>
 <alpine.LRH.2.02.1412011117180.27118@file01.intranet.prod.int.rdu2.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <alpine.LRH.2.02.1412011117180.27118@file01.intranet.prod.int.rdu2.redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: device-mapper development <dm-devel@redhat.com>, Alasdair Kergon <agk@redhat.com>, linux-kernel@vger.kernel.org, darrick.wong@oracle.com
List-Id: dm-devel.ids

On Mon, Dec 01 2014 at 11:23am -0500,
Mikulas Patocka <mpatocka@redhat.com> wrote:

> 
> 
> On Tue, 25 Nov 2014, Darrick J. Wong wrote:
> 
> > When dm-bufio sets out to use the bio built into a struct dm_buffer to
> > issue an IO, it needs to call bio_reset after it's done with the bio
> > so that we can free things attached to the bio such as the integrity
> > payload.  Therefore, inject our own endio callback to take care of
> > the bio_reset after calling submit_io's end_io callback.
> > 
> > Test case:
> > 1. modprobe scsi_debug delay=0 dif=1 dix=199 ato=1 dev_size_mb=300
> > 2. Set up a dm-bufio client, e.g. dm-verity, on the scsi_debug device
> > 3. Repeatedly read metadata and watch kmalloc-192 leak!
> > 
> > Fix is against 3.18-rc6.
> > 
> > +/* Reset the bio to free attached bio integrity profiles when we're done */
> > +static void inline_endio(struct bio *bio, int error)
> > +{
> > +	bio_end_io_t *end_fn;
> > +
> > +	end_fn = bio->bi_private;
> > +	end_fn(bio, error);
> > +	bio_reset(bio);
> > +}
> 
> This is wrong - when end_fn clears the B_READING or B_WRITING flag, the 
> buffer may be freed by the background cleanup - so bio_reset may be 
> modifying freed memory here. We need to call bio_reset before end_fn.

OK, I'll fold your fix in.
