From: Kent Overstreet <koverstreet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v3 07/26] block: Use bio_sectors() more consistently
Date: Mon, 24 Sep 2012 16:09:45 -0700
Message-ID: <20120924230945.GB27689@google.com>
References: <1348526106-17074-1-git-send-email-koverstreet@google.com>
 <1348526106-17074-8-git-send-email-koverstreet@google.com>
 <20120924230449.GA2040@psychosis.jim.sh>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20120924230449.GA2040-SRSuHwkuBJlaX0KmTac7FA@public.gmane.org>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jim Paris <jim-XrPbb/hENzg@public.gmane.org>
Cc: linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, dm-devel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org, neilb-l3A5Bk7waGM@public.gmane.org, vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, "Ed L. Cashin" <ecashin-kFqnmIA2sJXQT0dZR+AlfA@public.gmane.org>, Nick Piggin <npiggin-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>, Jiri Kosina <jkosina-AlSwsSmVLrQ@public.gmane.org>, Geoff Levand <geoff-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Alasdair Kergon <agk-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Steven Rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>
List-Id: dm-devel.ids

On Mon, Sep 24, 2012 at 07:04:50PM -0400, Jim Paris wrote:
> Kent Overstreet wrote:
> > Bunch of places in the code weren't using it where they could be -
> > this'll reduce the size of the patch that puts bi_sector/bi_size/bi_idx
> > into a struct bvec_iter.
> > 
> > Signed-off-by: Kent Overstreet <koverstreet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
> > CC: Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>
> > CC: "Ed L. Cashin" <ecashin-kFqnmIA2sJXQT0dZR+AlfA@public.gmane.org>
> > CC: Nick Piggin <npiggin-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>
> > CC: Jiri Kosina <jkosina-AlSwsSmVLrQ@public.gmane.org>
> > CC: Jim Paris <jim-XrPbb/hENzg@public.gmane.org>
> > CC: Geoff Levand <geoff-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
> > CC: Alasdair Kergon <agk-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> > CC: dm-devel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
> > CC: Neil Brown <neilb-l3A5Bk7waGM@public.gmane.org>
> > CC: Steven Rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>
> > ---
> >  drivers/block/aoe/aoecmd.c   |  2 +-
> >  drivers/block/brd.c          |  3 +--
> >  drivers/block/pktcdvd.c      |  2 +-
> >  drivers/block/ps3vram.c      |  2 +-
> >  drivers/md/dm-raid1.c        |  2 +-
> >  drivers/md/raid0.c           |  6 +++---
> >  drivers/md/raid1.c           | 17 ++++++++---------
> >  drivers/md/raid10.c          | 24 +++++++++++-------------
> >  drivers/md/raid5.c           |  8 ++++----
> >  include/trace/events/block.h | 10 +++++-----
> >  10 files changed, 36 insertions(+), 40 deletions(-)
> ...
> > diff --git a/drivers/block/ps3vram.c b/drivers/block/ps3vram.c
> > index f58cdcf..1ff38e8 100644
> > --- a/drivers/block/ps3vram.c
> > +++ b/drivers/block/ps3vram.c
> > @@ -553,7 +553,7 @@ static struct bio *ps3vram_do_bio(struct ps3_system_bus_device *dev,
> >  	struct ps3vram_priv *priv = ps3_system_bus_get_drvdata(dev);
> >  	int write = bio_data_dir(bio) == WRITE;
> >  	const char *op = write ? "write" : "read";
> > -	loff_t offset = bio->bi_sector << 9;
> > +	loff_t offset = bio_sectors(bio);
> 
> This doesn't look right to me: bio_sectors(bio) is (bio->bi_size>>9),
> not (bio->bi_sector<<9~)?

Whoops, you're right - that's completely wrong. Thanks.
