From: Pavel Machek <pavel@ucw.cz>
Subject: Re: 4.4-final: 28 bioset threads on small notebook
Date: Tue, 23 Feb 2016 21:45:32 +0100
Message-ID: <20160223204532.GD16961@amd>
References: <20160220174035.GA16459@amd>
 <20160220184258.GA3753@amd>
 <20160220195136.GA27149@redhat.com>
 <20160220200432.GB22120@amd>
 <20160220203856.GB27149@redhat.com>
 <20160220205519.GA14108@amd>
 <20160221041540.GA24735@kmo-pixel>
 <3A47B4705F6BE24CBB43C61AA73286211B3AA6A9@SSIEXCH-MB3.ssi.samsung.com>
 <CACVXFVPav3D2MzNFR-b4YadFMM6_KcyEYQ7dx4t1r9fMOLDaFw@mail.gmail.com>
 <20160222225818.GA2675@kmo-pixel>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20160222225818.GA2675@kmo-pixel>
Sender: linux-kernel-owner@vger.kernel.org
To: Kent Overstreet <kent.overstreet@gmail.com>
Cc: Ming Lei <ming.lei@canonical.com>, Ming Lin-SSI <ming.l@ssi.samsung.com>, Mike Snitzer <snitzer@redhat.com>, kernel list <linux-kernel@vger.kernel.org>, "axboe@fb.com" <axboe@fb.com>, "hch@lst.de" <hch@lst.de>, "neilb@suse.de" <neilb@suse.de>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>, "dpark@posteo.net" <dpark@posteo.net>, "dm-devel@redhat.com" <dm-devel@redhat.com>, "agk@redhat.com" <agk@redhat.com>, "jkosina@suse.cz" <jkosina@suse.cz>, "geoff@infradead.org" <geoff@infradead.org>, "jim@jtan.com" <jim@jtan.com>, "pjk1939@linux.vnet.ibm.com" <pjk1939@linux.vnet.ibm.com>, "minchan@kernel.org" <minchan@kernel.org>, "ngupta@vflare.org" <ngupta@vflare.org>, "oleg.drokin@intel.com" <oleg.drokin@intel.com>, "andreas.dilger@intel.com" <andreas.dilger@intel.com>
List-Id: dm-devel.ids

On Mon 2016-02-22 13:58:18, Kent Overstreet wrote:
> On Sun, Feb 21, 2016 at 05:40:59PM +0800, Ming Lei wrote:
> > On Sun, Feb 21, 2016 at 2:43 PM, Ming Lin-SSI <ming.l@ssi.samsung.com> wrote:
> > >>-----Original Message-----
> > >
> > > So it's almost already "per request_queue"
> > 
> > Yes, that is because of the following line:
> > 
> > q->bio_split = bioset_create(BIO_POOL_SIZE, 0);
> > 
> > in blk_alloc_queue_node().
> > 
> > Looks like this bio_set doesn't need to be per-request_queue, and
> > now it is only used for fast-cloning bio for splitting, and one global
> > split bio_set should be enough.
> 
> It does have to be per request queue for stacking block devices (which includes
> loopback).

Could we only allocate request queues for devices that are not even
opened? I have these in my system:

loop0  loop2  loop4  loop6  md0   nbd1	 nbd11	nbd13  nbd15  nbd3 nbd5  nbd7    nbd9  sda1  sda3
loop1  loop3  loop5  loop7  nbd0  nbd10  nbd12	nbd14  nbd2   nbd4 nbd6  nbd8    sda   sda2  sda4

...but nbd is never used, loop1+ is never used, and loop0 is only used
once in a blue moon. Each process takes 8K+...

								Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
