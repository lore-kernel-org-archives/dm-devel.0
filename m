From: Vivek Goyal <vgoyal@redhat.com>
Subject: Re: [PATCH 4/7] dm: introduce dm_kvmalloc
Date: Mon, 6 Jul 2015 09:07:16 -0400
Message-ID: <20150706130716.GC4515@redhat.com>
References: <alpine.LRH.2.02.1507031658500.28837@file01.intranet.prod.int.rdu2.redhat.com>
	<20150706124212.GA4515@redhat.com>
	<alpine.LRH.2.02.1507060902220.27204@file01.intranet.prod.int.rdu2.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <alpine.LRH.2.02.1507060902220.27204@file01.intranet.prod.int.rdu2.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: Mike Snitzer <msnitzer@redhat.com>, Edward Thornber <thornber@redhat.com>, dm-devel@redhat.com, "Alasdair G. Kergon" <agk@redhat.com>
List-Id: dm-devel.ids

On Mon, Jul 06, 2015 at 09:04:34AM -0400, Mikulas Patocka wrote:
> 
> 
> On Mon, 6 Jul 2015, Vivek Goyal wrote:
> 
> > On Fri, Jul 03, 2015 at 04:59:54PM -0400, Mikulas Patocka wrote:
> > [..]
> > > Index: linux-4.1/drivers/md/dm-table.c
> > > ===================================================================
> > > --- linux-4.1.orig/drivers/md/dm-table.c	2015-07-02 19:21:16.000000000 +0200
> > > +++ linux-4.1/drivers/md/dm-table.c	2015-07-02 19:28:18.000000000 +0200
> > > @@ -131,6 +131,43 @@ static int setup_btree_index(unsigned in
> > >  	return 0;
> > >  }
> > >  
> > > +void *dm_kvmalloc_node(size_t size, gfp_t gfp, int node)
> > > +{
> > > +	void *p;
> > > +	unsigned uninitialized_var(noio_flag);
> > > +
> > > +	/* vmalloc doesn't support no-wait allocations */
> > > +	WARN_ON(!(gfp & __GFP_WAIT));
> > > +
> > 
> > Should this WARN_ON() be moved after kmalloc(). This should be triggered
> > only if we use vmalloc().
> > 
> > Thanks
> > Vivek
> 
> I think not - it would just hide the problematic usage. Warning always is 
> better than warning with some low probability when kmalloc fails.

Ok, so you don't want this function to be used if __GFP_WAIT is not
specified and caller needs to call kmalloc() directly in that case. If
that's the intent, it is fine.

Thanks
Vivek
