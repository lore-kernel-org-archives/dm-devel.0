From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: dm raid: avoid mddev->suspended access
Date: Tue, 25 Jul 2017 14:29:17 -0400
Message-ID: <20170725182917.GB27077@redhat.com>
References: <20170713153424.24400-1-heinzm@redhat.com>
	<20170725181725.GA27077@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20170725181725.GA27077@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: heinzm@redhat.com
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

On Tue, Jul 25 2017 at  2:17pm -0400,
Mike Snitzer <snitzer@redhat.com> wrote:

> On Thu, Jul 13 2017 at 11:34am -0400,
> heinzm@redhat.com <heinzm@redhat.com> wrote:
> 
> > From: Heinz Mauelshagen <heinzm@redhat.com>
> > 
> > Use runtime flag to ensure that an mddev gets suspended/resumed just once.
> > 
> > Signed-off-by: Heinz Mauelshagen <heinzm@redhat.com>
> > ---
> >  drivers/md/dm-raid.c | 12 +++++++-----
> >  1 file changed, 7 insertions(+), 5 deletions(-)
> > 
> > diff --git a/drivers/md/dm-raid.c b/drivers/md/dm-raid.c
> > index b409015..60c524b 100644
> > --- a/drivers/md/dm-raid.c
> > +++ b/drivers/md/dm-raid.c
> > @@ -3760,7 +3762,7 @@ static int rs_start_reshape(struct raid_set *rs)
> >  		return r;
> >  
> >  	/* Need to be resumed to be able to start reshape, recovery is frozen until raid_resume() though */
> > -	if (mddev->suspended)
> > +	if (test_and_clear_bit(RT_FLAG_RS_SUSPENDED, &rs->runtime_flags))
> >  		mddev_resume(mddev);
> >  
> >  	/*
> > @@ -3787,8 +3789,8 @@ static int rs_start_reshape(struct raid_set *rs)
> >  	}
> >  
> >  	/* Suspend because a resume will happen in raid_resume() */
> > -	if (!mddev->suspended)
> > -		mddev_suspend(mddev);
> > +	set_bit(RT_FLAG_RS_SUSPENDED, &rs->runtime_flags);
> > +	mddev_suspend(mddev);
> >  
> >  	/*
> >  	 * Now reshape got set up, update superblocks to
> 
> Shouldn't this be the following?
> 
> if (!test_and_set_bit(RT_FLAG_RS_SUSPENDED, &rs->runtime_flags))
>    mddev_suspend(mddev);

Looking closer, the preceding test_and_clear_bit() should ensure that
the device is always resumed by the time it gets to the code I called
into question.
