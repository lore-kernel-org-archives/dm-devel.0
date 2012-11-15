From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: [PATCH 1/3] md:Add a func 'dm_md_stop' for dm-raid to clear up
 md resources.
Date: Thu, 15 Nov 2012 08:52:41 -0500
Message-ID: <20121115135241.GB15279@redhat.com>
References: <201211151646546882035@gmail.com>
 <20121115114529.GA12798@agk-dp.fab.redhat.com>
 <201211151951429245011@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <201211151951429245011@gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: majianpeng <majianpeng@gmail.com>
Cc: agk <agk@redhat.com>, linux-raid <linux-raid@vger.kernel.org>, dm-devel <dm-devel@redhat.com>
List-Id: dm-devel.ids

On Thu, Nov 15 2012 at  6:51am -0500,
majianpeng <majianpeng@gmail.com> wrote:

> >On Thu, Nov 15, 2012 at 04:46:59PM +0800, majianpeng wrote:
> >> So add a func dm_md_stop to clear up resource.
> > 
> >> +++ b/drivers/md/md.c
> >
> >> +void dm_md_stop(struct mddev *mddev)
> >> +{
> >> +	md_stop(mddev);
> >> +	bitmap_destroy(mddev);
> >> +	if (mddev->bio_set)
> >> +		bioset_free(mddev->bio_set);
> >> +}
> >> +EXPORT_SYMBOL_GPL(dm_md_stop);
> >
> >Let's not put a function with a dm_ prefix in an md file?
> >
> >Alasdair
> >
> Can you give me a hint? My thought is this func only by dm to call and there was a md_stop already?
> I firstly want to add those statements in dm driver like md_stop rather than a func include those.
> But i think dm don't know to much.

Nmae it mddev_stop_and_cleanup?
