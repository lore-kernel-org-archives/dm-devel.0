From: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Subject: Re: [dm-devel] [PATCH] dm-writecache
Date: Mon, 12 Mar 2018 00:50:29 -0700
Message-ID: <20180312075029.GC30695@infradead.org>
References: <alpine.LRH.2.02.1803080824210.2819@file01.intranet.prod.int.rdu2.redhat.com>
 <20180308145153.GB23262@infradead.org>
 <alpine.LRH.2.02.1803082213080.2200@file01.intranet.prod.int.rdu2.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <alpine.LRH.2.02.1803082213080.2200-Hpncn10jQN4oNljnaZt3ZvA+iT7yCHsGwRM8/txMwJMAicBL8TP8PQ@public.gmane.org>
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
List-Help: <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=subscribe>
Errors-To: linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
To: Mikulas Patocka <mpatocka-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Mike Snitzer <msnitzer-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, dm-devel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, "Alasdair G. Kergon" <agk-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org
List-Id: dm-devel.ids

On Thu, Mar 08, 2018 at 10:26:17PM -0500, Mikulas Patocka wrote:
> > no business having this around.
> 
> It's the default setting of the flag wc->writeback_fua (it can be changed 
> with target parameters). The flag selects whether the target uses FUA 
> requests when doing writeback or whether it uses non-FUA requests and 
> FLUSH afterwards. For some block devices, FUA is faster, for some 
> nonFUA+FLUSH is faster.

So just use true as the default flag, adding a name for it in addition
to the field it is assigned to makes no sense at all.

> > > +#ifndef bio_set_dev
> > > +#define	bio_set_dev(bio, dev)	((bio)->bi_bdev = (dev))
> > > +#endif
> > > +#ifndef timer_setup
> > > +#define timer_setup(t, c, f)	setup_timer(t, c, (unsigned long)(t))
> > > +#endif
> > 
> > no business in mainline.
> 
> People removed dax support for ramdisk in 4.15.
> 
> If I need to test it on non-x86 architecture, I need ramdisk as a fake dax 
> device - and that only works up to 4.14. These defines are for 4.14 
> compatibility.

So add them when you backport, or use the existing automated backport
frameworks.  But do not add dead code to an upstream submission.

> > > +#if defined(CONFIG_X86_64)
> > > +#define NT_STORE(dest, src)				\
> > > +do {							\
> > > +	typeof(src) val = (src);			\
> > > +	memcpy_flushcache(&(dest), &val, sizeof(src));	\
> > > +} while (0)
> > > +#define COMMIT_FLUSHED()	wmb()
> > > +#else
> > > +#define NT_STORE(dest, src)	WRITE_ONCE(dest, src)
> > > +#define FLUSH_RANGE		dax_flush
> > > +#define COMMIT_FLUSHED()	do { } while (0)
> > > +#endif
> > 
> > Please use proper APIs for this, this has no business in a driver.
> > 
> > And that's it for now.  This is clearly not submission ready, and I
> > should got back to my backlog of other things.
> 
> Why is memcpy_flushcache and dax_flush "improper"? What should I use 
> instead of them?

They are proper and should be used directly instead of through your
hacky macros.
