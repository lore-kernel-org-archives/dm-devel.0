From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: [PATCH -next] dm writecache: fix return value check in
 writecache_ctr()
Date: Thu, 31 May 2018 12:07:12 -0400
Message-ID: <20180531160711.GB11300@redhat.com>
References: <1527767595-76082-1-git-send-email-weiyongjun1@huawei.com>
 <20180531160202.GA11300@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180531160202.GA11300@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Wei Yongjun <weiyongjun1@huawei.com>
Cc: Alasdair Kergon <agk@redhat.com>, Mikulas Patocka <mpatocka@redhat.com>, dm-devel@redhat.com, linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
List-Id: dm-devel.ids

On Thu, May 31 2018 at 12:02pm -0400,
Mike Snitzer <snitzer@redhat.com> wrote:

> On Thu, May 31 2018 at  7:53am -0400,
> Wei Yongjun <weiyongjun1@huawei.com> wrote:
> 
> > Function dm_io_client_create() and dm_kcopyd_client_create() return
> > ERR_PTR() not NULL in case of error. The NULL test in the return value
> > check should be replaced with IS_ERR()
> > 
> > Fixes: 2105231db61b ("dm: add writecache target")
> > Signed-off-by: Wei Yongjun <weiyongjun1@huawei.com>
> > ---
> >  drivers/md/dm-writecache.c | 10 ++++++----
> >  1 file changed, 6 insertions(+), 4 deletions(-)
> > 
> > diff --git a/drivers/md/dm-writecache.c b/drivers/md/dm-writecache.c
> > index 844c4fb..0b2b436 100644
> > --- a/drivers/md/dm-writecache.c
> > +++ b/drivers/md/dm-writecache.c
> > @@ -1872,9 +1872,10 @@ static int writecache_ctr(struct dm_target *ti, unsigned argc, char **argv)
> >  	}
> >  
> >  	wc->dm_io = dm_io_client_create();
> > -	if (!wc->dm_io) {
> > -		r = -ENOMEM;
> > +	if (IS_ERR(wc->dm_io)) {
> > +		r = PTR_ERR(wc->dm_io);
> >  		ti->error = "Unable to allocate dm-io client";
> > +		wc->dm_io = NULL;
> >  		goto bad;
> >  	}
> >  
> > @@ -2096,9 +2097,10 @@ static int writecache_ctr(struct dm_target *ti, unsigned argc, char **argv)
> >  		}
> >  
> >  		wc->dm_kcopyd = dm_kcopyd_client_create(&dm_kcopyd_throttle);
> > -		if (!wc->dm_kcopyd) {
> > -			r = -ENOMEM;
> > +		if (IS_ERR(wc->dm_kcopyd)) {
> > +			r = PTR_ERR(wc->dm_kcopyd);
> >  			ti->error = "Unable to allocate dm-kcopyd client";
> > +			wc->dm_kcopyd = NULL;
> >  			goto bad;
> >  		}
> > 
> 
> 
> Yes, I forgot to pull this in.. it got lost in the shuffle.  Mikulas had
> provided this same change (folded into a larger patch) yesterday, see:
> https://patchwork.kernel.org/patch/10439345/
> 
> I'll get this folded in ASAP.

Turns out I already did fold it in.  My push to linux-next just missed
today's tree.

So already taken care of.

Thanks for sending the patch though.

Mike
