From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: dm-writecache: fix compilation issue with !DAX
Date: Wed, 30 May 2018 09:13:27 -0400
Message-ID: <20180530131326.GA2106@redhat.com>
References: <20180529175216.24937-1-ross.zwisler@linux.intel.com>
 <alpine.LRH.2.02.1805300821510.24812@file01.intranet.prod.int.rdu2.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <alpine.LRH.2.02.1805300821510.24812@file01.intranet.prod.int.rdu2.redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: Ross Zwisler <ross.zwisler@linux.intel.com>, Arnd Bergmann <arnd@arndb.de>, Shaohua Li <shli@kernel.org>, Alasdair Kergon <agk@redhat.com>, dm-devel@redhat.com, Matthew Wilcox <mawilcox@microsoft.com>, linux-fsdevel@vger.kernel.org, Dan Williams <dan.j.williams@intel.com>, Heinz Mauelshagen <heinzm@redhat.com>, linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: dm-devel.ids

On Wed, May 30 2018 at  8:22am -0400,
Mikulas Patocka <mpatocka@redhat.com> wrote:

> 
> 
> On Tue, 29 May 2018, Ross Zwisler wrote:
> 
> > As reported by Arnd (https://lkml.org/lkml/2018/5/28/1697), dm-writecache
> > will fail with link errors in configs where DAX isn't present:
> > 
> > drivers/md/dm-writecache.o: In function `writecache_ctr':
> > dm-writecache.c:(.text+0x1fdc): undefined reference to `dax_read_lock'
> > dm-writecache.c:(.text+0x2004): undefined reference to `dax_direct_access'
> > dm-writecache.c:(.text+0x21cc): undefined reference to `dax_read_unlock'
> > 
> > Fix this by following the lead of the other DM modules and wrapping calls
> > to the generic DAX code in #if IS_ENABLED(CONFIG_DAX_DRIVER) blocks.
> > 
> > We also expand the failure case for the 'p' (persistent memory) flag so
> > that fails on both architectures that don't support persistent memory and
> > on kernels that don't have DAX support configured.  This prevents us from
> > ever hitting the BUG() in the persistent_memory_claim() stub.
> > 
> > Signed-off-by: Ross Zwisler <ross.zwisler@linux.intel.com>
> > Reported-by: Arnd Bergmann <arnd@arndb.de>
> > ---
> >  drivers/md/dm-writecache.c | 16 ++++++++++++----
> >  1 file changed, 12 insertions(+), 4 deletions(-)
> > 
> > diff --git a/drivers/md/dm-writecache.c b/drivers/md/dm-writecache.c
> > index 92af65fdf4af..1c2b53ae1a96 100644
> > --- a/drivers/md/dm-writecache.c
> > +++ b/drivers/md/dm-writecache.c
> > @@ -253,6 +253,7 @@ static void wc_unlock(struct dm_writecache *wc)
> >  	mutex_unlock(&wc->lock);
> >  }
> >  
> > +#if IS_ENABLED(CONFIG_DAX_DRIVER)
> 
> We already have #if(n)def DM_WRITECACHE_ONLY_SSD
> 
> There is no need to use another macro for the same purpose.

I removed DM_WRITECACHE_ONLY_SSD because it wasn't needed, this is the
split out commit that I have since folded in:
https://git.kernel.org/pub/scm/linux/kernel/git/snitzer/linux.git/commit/?h=dm-4.18-writecache-wip&id=e7fd3d1c05659f7e1295178290fbdaebf36becdc

Ross's patch effectively builds ontop of that.

Mike
