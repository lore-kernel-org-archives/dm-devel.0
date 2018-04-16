From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: slab: introduce the flag SLAB_MINIMIZE_WASTE
Date: Mon, 16 Apr 2018 10:46:39 -0400
Message-ID: <20180416144638.GA22484@redhat.com>
References: <alpine.LRH.2.02.1803201740280.21066@file01.intranet.prod.int.rdu2.redhat.com>
	<alpine.DEB.2.20.1803211024220.2175@nuc-kabylake>
	<alpine.LRH.2.02.1803211153320.16017@file01.intranet.prod.int.rdu2.redhat.com>
	<alpine.DEB.2.20.1803211226350.3174@nuc-kabylake>
	<alpine.LRH.2.02.1803211425330.26409@file01.intranet.prod.int.rdu2.redhat.com>
	<20c58a03-90a8-7e75-5fc7-856facfb6c8a@suse.cz>
	<20180413151019.GA5660@redhat.com>
	<ee8807ff-d650-0064-70bf-e1d77fa61f5c@suse.cz>
	<20180416142703.GA22422@redhat.com>
	<alpine.LRH.2.02.1804161031300.24222@file01.intranet.prod.int.rdu2.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <alpine.LRH.2.02.1804161031300.24222@file01.intranet.prod.int.rdu2.redhat.com>
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
Cc: Andrew Morton <akpm@linux-foundation.org>, Matthew Wilcox <willy@infradead.org>, Pekka Enberg <penberg@kernel.org>, linux-mm@kvack.org, dm-devel@redhat.com, David Rientjes <rientjes@google.com>, Christopher Lameter <cl@linux.com>, Joonsoo Kim <iamjoonsoo.kim@lge.com>, Vlastimil Babka <vbabka@suse.cz>
List-Id: dm-devel.ids

On Mon, Apr 16 2018 at 10:37am -0400,
Mikulas Patocka <mpatocka@redhat.com> wrote:

> 
> 
> On Mon, 16 Apr 2018, Mike Snitzer wrote:
> 
> > On Mon, Apr 16 2018 at  8:38am -0400,
> > Vlastimil Babka <vbabka@suse.cz> wrote:
> > 
> > > On 04/13/2018 05:10 PM, Mike Snitzer wrote:
> > > > On Fri, Apr 13 2018 at  5:22am -0400,
> > > > Vlastimil Babka <vbabka@suse.cz> wrote:
> > > >>
> > > >> Would this perhaps be a good LSF/MM discussion topic? Mikulas, are you
> > > >> attending, or anyone else that can vouch for your usecase?
> > > > 
> > > > Any further discussion on SLAB_MINIMIZE_WASTE should continue on list.
> > > > 
> > > > Mikulas won't be at LSF/MM.  But I included Mikulas' dm-bufio changes
> > > > that no longer depend on this proposed SLAB_MINIMIZE_WASTE (as part of
> > > > the 4.17 merge window).
> > > 
> > > Can you or Mikulas briefly summarize how the dependency is avoided, and
> > > whether if (something like) SLAB_MINIMIZE_WASTE were implemented, the
> > > dm-bufio code would happily switch to it, or not?
> > 
> > git log eeb67a0ba04df^..45354f1eb67224669a1 -- drivers/md/dm-bufio.c
> > 
> > But the most signficant commit relative to SLAB_MINIMIZE_WASTE is: 
> > 359dbf19ab524652a2208a2a2cddccec2eede2ad ("dm bufio: use slab cache for 
> > dm_buffer structure allocations")
> > 
> > So no, I don't see why dm-bufio would need to switch to
> > SLAB_MINIMIZE_WASTE if it were introduced in the future.
> 
> Currently, the slab cache rounds up the size of the slab to the next power 
> of two (if the size is large). And that wastes memory if that memory were 
> to be used for deduplication tables.

You mean on an overall size of the cache level?  Or on a per-object
level?  I can only imagine you mean the former.
 
> Generally, the performance of the deduplication solution depends on how 
> much data can you put to memory. If you round 640KB buffer to 1MB (this is 
> what the slab and slub subsystem currently do), you waste a lot of memory. 
> Deduplication indices with 640KB blocks are already used in the wild, so 
> it can't be easily changed.

OK, seems you're suggesting a single object is rounded up.. so then this
header is very wrong?:

commit 359dbf19ab524652a2208a2a2cddccec2eede2ad
Author: Mikulas Patocka <mpatocka@redhat.com>
Date:   Mon Mar 26 20:29:45 2018 +0200

    dm bufio: use slab cache for dm_buffer structure allocations

    kmalloc padded to the next power of two, using a slab cache avoids this.

    Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
    Signed-off-by: Mike Snitzer <snitzer@redhat.com>

Please clarify further, thanks!
Mike
