From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: dm: Return correct value in retry loop
Date: Mon, 12 Sep 2016 11:01:42 -0400
Message-ID: <20160912150142.GB16681@redhat.com>
References: <1473148829-3317-1-git-send-email-mnghuan@gmail.com>
 <20160912013906.GA24268@MinfeideMacBook-Pro.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20160912013906.GA24268@MinfeideMacBook-Pro.local>
Sender: linux-kernel-owner@vger.kernel.org
To: Minfei Huang <mnghuan@gmail.com>
Cc: agk@redhat.com, shli@kernel.org, linux-raid@vger.kernel.org, dm-devel@redhat.com, linux-kernel@vger.kernel.org
List-Id: dm-devel.ids

Thanks for the patch, I've picked it up as a stable@ fix for either
4.8-rc7 or when the 4.9 merge windw opens (I'm leaning toward the latter
since this issue has been around since 3.19 was released and there
aren't any known problems/reports related to this oversight).

Please see:
https://git.kernel.org/cgit/linux/kernel/git/device-mapper/linux-dm.git/commit/?h=dm-4.8&id=7735f936a13d79bbaead1723e4532e65d4c4cf01

On Sun, Sep 11 2016 at  9:39pm -0400,
Minfei Huang <mnghuan@gmail.com> wrote:

> Ping.
> 
> Any comment is appreciate.
> 
> Thanks
> Minfei
> 
> On 09/06/16 at 04:00P, Minfei Huang wrote:
> > dm_resume will return sliently in retry loop's failure. Assign a correct
> > return value in the failed loop.
> > 
> > Remove a useless assignment as well.
> > 
> > Signed-off-by: Minfei Huang <mnghuan@gmail.com>
> > ---
> >  drivers/md/dm.c | 5 ++---
> >  1 file changed, 2 insertions(+), 3 deletions(-)
> > 
> > diff --git a/drivers/md/dm.c b/drivers/md/dm.c
> > index fa9b1cb..c935cc8 100644
> > --- a/drivers/md/dm.c
> > +++ b/drivers/md/dm.c
> > @@ -2249,10 +2249,11 @@ static int __dm_resume(struct mapped_device *md, struct dm_table *map)
> >  
> >  int dm_resume(struct mapped_device *md)
> >  {
> > -	int r = -EINVAL;
> > +	int r;
> >  	struct dm_table *map = NULL;
> >  
> >  retry:
> > +	r = -EINVAL;
> >  	mutex_lock_nested(&md->suspend_lock, SINGLE_DEPTH_NESTING);
> >  
> >  	if (!dm_suspended_md(md))
> > @@ -2277,10 +2278,8 @@ retry:
> >  
> >  	clear_bit(DMF_SUSPENDED, &md->flags);
> >  
> > -	r = 0;
> >  out:
> >  	mutex_unlock(&md->suspend_lock);
> > -
> >  	return r;
> >  }
> >  
> > -- 
> > 2.7.4 (Apple Git-66)
> > 
> 
> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://www.redhat.com/mailman/listinfo/dm-devel
