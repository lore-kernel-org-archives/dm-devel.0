From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: shared snapshots release 17
Date: Fri, 26 Mar 2010 12:13:14 -0400
Message-ID: <20100326161314.GA15016@redhat.com>
References: <Pine.LNX.4.64.1003221513150.15382@hs20-bc2-1.build.redhat.com>
	<20100322205433.GB13346@redhat.com>
	<Pine.LNX.4.64.1003261019110.21803@hs20-bc2-1.build.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.1003261019110.21803@hs20-bc2-1.build.redhat.com>
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
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

On Fri, Mar 26 2010 at 10:35am -0400,
Mikulas Patocka <mpatocka@redhat.com> wrote:

> Hi
> 
> > Mikulas Patocka <mpatocka@redhat.com> wrote:
> > 
> > > Hi
> > > 
> > > New shared snapshots are here. It incorporates Mike's changes and it has 
> > > reworked memory limit:
> > > - a minimum of 8 buffers is guaranteed to prevent thrasing with too big 
> > > chunk sizes
> > > - the cache for multisnapshots is limited to 2% of memory or 25% of 
> > > vmalloc memory (whichever is lower) [ I'm thinking about making this 
> > > configurable in /proc ]
> > > - big chunk sizes (8MB or more) allocate memory always from vmalloc, there 
> > > is no point in allocating from general allocator
> > 
> > For the benefit of others, here are your r17 changes relative to r16.  I
> > have some early questions/comments:
> > 
> > - What is going on with EXPORT_SYMBOL at the top of drivers/md/dm-bufio.c?  
> >   Do you intend to have a standalone dm-bufio module?
> 
> Maybe sometimes, but not now. That's why I mark exported symbols with 
> EXPORT_SYMBOL, but disable it.
> 
> >   I think it makes
> >   sense to go one way or another.  As is you're in limbo; the name of
> >   the _init and _exit functions don't _really_ make sense given that it
> >   isn't a standalone module (e.g. dm_bufio_module_init).
> 
> dm-bufio may become part of dm module --- then, dm_bufio_module_init and 
> dm_bufio_module_exit will be called from dm.c:_inits and _exits. Or 
> dm-bufio becomes a standalone module and then these functions will be 
> called from module_init and module_exit. Or it stays attached to 
> dm-store-mikulas, as it is now, and then it will be called from there.
> 
> I really don't know what will be the future of dm-bufio file --- will 
> fujita-daniel store use it? Will something else use it? (for example 
> replicator, SSD caching or whatever else). So I must be prepared for all 
> the alternatives.
> 
> >   Makes the
> >   calling code in dm-multisnap-mikulas.c somewhat awkward (calling
> >   another _{module_init,exit}).  Especially when you consider
> >   dm_bufio_module_exit() doesn't do anything;
> 
> It may do something in the future --- for example, unregister /sys or 
> /proc config files. (so far, it seems that it will be unnecessary if 
> sysfs is used...)
> 
> >   yet you've reworked
> >   dm_multisnapshot_mikulas_module_init() to call it.
> > 
> > - Please don't introduce long lines as you make new changes.  Below, the
> >   following functions have unnecessarily long lines:
> >   get_memory_limit, dm_bufio_alloc_buffer_data, dm_bufio_module_init
> 
> Grr, people are still obsessed about it :-/

Wouldn't say obsessed.  But long lines need to be justified (e.g. allows
grep'ing for error message); otherwise they are just ugly (my opinion).
The first 2 clearly aren't needed.  The last (dm_bufio_module_init)
could be justified just because that initialization is ugly no matter
what.

This is all subjective; but my desire is to avoid longer lines that
don't really help.  Those that stand out when looking at the code around
it.

Mike
