From: Julia Lawall <julia.lawall@lip6.fr>
Subject: Re: [PATCH 12/39] dm: drop null test before destroy functions
Date: Mon, 14 Sep 2015 20:50:03 +0200 (CEST)
Message-ID: <alpine.DEB.2.02.1509142049590.2048@localhost6.localdomain6>
References: <1442146532-9100-1-git-send-email-Julia.Lawall@lip6.fr> <1442146532-9100-13-git-send-email-Julia.Lawall@lip6.fr> <alpine.LRH.2.02.1509140932400.7970@file01.intranet.prod.int.rdu2.redhat.com> <20150914140040.GA11815@redhat.com>
 <alpine.LRH.2.02.1509141004430.7970@file01.intranet.prod.int.rdu2.redhat.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <alpine.LRH.2.02.1509141004430.7970@file01.intranet.prod.int.rdu2.redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: Mike Snitzer <snitzer@redhat.com>, device-mapper development <dm-devel@redhat.com>, Alasdair Kergon <agk@redhat.com>, kernel-janitors@vger.kernel.org, Neil Brown <neilb@suse.com>, linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org, sergey.senozhatsky@gmail.com
List-Id: dm-devel.ids



On Mon, 14 Sep 2015, Mikulas Patocka wrote:

> 
> 
> On Mon, 14 Sep 2015, Mike Snitzer wrote:
> 
> > On Mon, Sep 14 2015 at  9:46am -0400,
> > Mikulas Patocka <mpatocka@redhat.com> wrote:
> > 
> > > 
> > > 
> > > On Sun, 13 Sep 2015, Julia Lawall wrote:
> > > 
> > > > Remove unneeded NULL test.
> > > > 
> > > > The semantic patch that makes this change is as follows:
> > > > (http://coccinelle.lip6.fr/)
> > > > 
> > > > // <smpl>
> > > > @@ expression x; @@
> > > > -if (x != NULL)
> > > >   \(kmem_cache_destroy\|mempool_destroy\|dma_pool_destroy\)(x);
> > > > // </smpl>
> > > > 
> > > > Signed-off-by: Julia Lawall <Julia.Lawall@lip6.fr>
> > > > 
> > > > ---
> > > >  drivers/md/dm-bufio.c              |    3 +--
> > > >  drivers/md/dm-cache-target.c       |    3 +--
> > > >  drivers/md/dm-crypt.c              |    6 ++----
> > > >  drivers/md/dm-io.c                 |    3 +--
> > > >  drivers/md/dm-log-userspace-base.c |    3 +--
> > > >  drivers/md/dm-region-hash.c        |    4 +---
> > > >  drivers/md/dm.c                    |   13 ++++---------
> > > >  7 files changed, 11 insertions(+), 24 deletions(-)
> > > > 
> > > > diff --git a/drivers/md/dm-bufio.c b/drivers/md/dm-bufio.c
> > > > index 83cc52e..8ad39b6 100644
> > > > --- a/drivers/md/dm-bufio.c
> > > > +++ b/drivers/md/dm-bufio.c
> > > > @@ -1864,8 +1864,7 @@ static void __exit dm_bufio_exit(void)
> > > >  	for (i = 0; i < ARRAY_SIZE(dm_bufio_caches); i++) {
> > > >  		struct kmem_cache *kc = dm_bufio_caches[i];
> > > >  
> > > > -		if (kc)
> > > > -			kmem_cache_destroy(kc);
> > > > +		kmem_cache_destroy(kc);
> > > >  	}
> > > 
> > > The variable here can be NULL. I don't know how did you conclude that it 
> > > cannot. It seems that you didn't test the patch, if you did, you'd hit 
> > > NULL pointer dereference here.
> > 
> > kmem_cache_destroy(), mempool_destroy(), etc all check for NULL and just
> > return.  So there is no need for the callers to check for NULL too.
> > 
> > Mike
> 
> I see. It was recent change that I missed.

The relevant commits were in the cover letter:

kmem_cache_destroy (commit 3942d29918522)
mempool_destroy (commit 4e3ca3e033d1)
dma_pool_destroy (commit 44d7175da6ea)

julia
