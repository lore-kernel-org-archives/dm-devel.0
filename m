From: Shaohua Li <shli@kernel.org>
Subject: Re: [PATCH v2 2/2] blk-throttle: fix wrong initialization in case of
 dm device
Date: Mon, 20 Nov 2017 13:23:19 -0800
Message-ID: <20171120212319.3rxkbcdpxglfa565@kernel.org>
References: <241a6fbe-f2d2-3d11-ba45-afc5b02de9c2@gmail.com>
 <CAMM=eLes8Z05HseDYjt+S3HC7jvfyREZrRqGBbTzxEfy8KHEEA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-block-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAMM=eLes8Z05HseDYjt+S3HC7jvfyREZrRqGBbTzxEfy8KHEEA@mail.gmail.com>
Sender: linux-block-owner@vger.kernel.org
To: Mike Snitzer <snitzer@redhat.com>
Cc: Joseph Qi <jiangqi903@gmail.com>, Jens Axboe <axboe@kernel.dk>, Shaohua Li <shli@fb.com>, linux-block <linux-block@vger.kernel.org>, qijiang.qj@alibaba-inc.com, device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

On Mon, Nov 20, 2017 at 04:02:03PM -0500, Mike Snitzer wrote:
> On Sun, Nov 19, 2017 at 9:00 PM, Joseph Qi <jiangqi903@gmail.com> wrote:
> > From: Joseph Qi <qijiang.qj@alibaba-inc.com>
> >
> > dm device set QUEUE_FLAG_NONROT in resume, which is after register
> > queue. That is to mean, the previous initialization in
> > blk_throtl_register_queue is wrong in this case.
> > Fix it by checking and then updating the info during root tg
> > initialization as we don't have a better choice.
> 
> Given DM motivated this change, curious why you didn't send this to dm-devel?
> 
> In any case, not sure why you need to reference "resume".  Very few
> people will appreciate that detail.
> 
> Better to just say: DM device sets QUEUE_FLAG_NONROT after the queue
> is registered.
> 
> > Signed-off-by: Joseph Qi <qijiang.qj@alibaba-inc.com>
> > ---
> >  block/blk-throttle.c | 17 +++++++++++++++++
> >  1 file changed, 17 insertions(+)
> >
> > diff --git a/block/blk-throttle.c b/block/blk-throttle.c
> > index bf52035..6d6b220 100644
> > --- a/block/blk-throttle.c
> > +++ b/block/blk-throttle.c
> > @@ -541,6 +541,23 @@ static void throtl_pd_init(struct blkg_policy_data *pd)
> >         if (cgroup_subsys_on_dfl(io_cgrp_subsys) && blkg->parent)
> >                 sq->parent_sq = &blkg_to_tg(blkg->parent)->service_queue;
> >         tg->td = td;
> > +
> > +       /*
> > +        * dm device set QUEUE_FLAG_NONROT in resume, which is after resister
> > +        * queue, so the previous initialization is wrong in this case. Check
> > +        * and update it here.
> > +        */
> 
> typo: s/resister/register/
> But again, best to say:
> DM device sets QUEUE_FLAG_NONROT after the queue is registered, ...
> 
> Also, an alternative to your patch would be to have DM's
> dm_table_set_restrictions() call a blk-throttle function to setup
> blk-throttle after it is done setting queue flags?
> Saves all other drivers from having to run this 2 stage initialization
> code.. just a thought.

Though the patch is a workaround, I'd prefer limiting the code into
blk-throttle itself. Populating it to drivers is a layer violation to me. The
initialization only runs once, so I think it's ok.

Thanks,
Shaohua
