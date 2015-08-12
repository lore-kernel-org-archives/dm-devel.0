From: Mikulas Patocka <mpatocka@redhat.com>
Subject: Re: dm-snap deadlock in pending_complete()
Date: Wed, 12 Aug 2015 12:25:42 -0400 (EDT)
Message-ID: <alpine.LRH.2.02.1508121215430.12043@file01.intranet.prod.int.rdu2.redhat.com>
References: <20150810135551.64d7dbac@noble>
	<alpine.LRH.2.02.1508110509420.2623@file01.intranet.prod.int.rdu2.redhat.com>
	<20150812114631.15268065@noble>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20150812114631.15268065@noble>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: NeilBrown <neilb@suse.com>
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids



On Wed, 12 Aug 2015, NeilBrown wrote:

> On Tue, 11 Aug 2015 05:14:33 -0400 (EDT) Mikulas Patocka
> <mpatocka@redhat.com> wrote:
> 
> > Hi
> > 
> > On Mon, 10 Aug 2015, NeilBrown wrote:
> > 
> > > 
> > > Hi Mikulas,
> > >  I have a customer hitting the deadlock you described over a year ago
> > >  in:
> > > 
> > > Subject: [dm-devel] [PATCH] block: flush queued bios when the process
> > >          blocks
> > 
> > Ask block layer maintainers to accept that patch.
> 
> Unfortunately I don't really like the patch ... or the bioset rescue
> workqueues that it is based on.   Sorry.
> 
> So I might keep looking for a more localised approach....

The problem here is that other dm targets may deadlock in a similar way 
too - for example, dm-thin could deadlock on pmd->pool_lock.

The cause of the bug is bio queuing on current->bio_list. There is an 
assumption that if a dm target submits a bio to a lower-level target, the 
bio finishes in finite time. Queuing on current->bio_list breaks the 
assumption, bios can be held indefinitelly on current->bio_list.

The patch that flushes current->bio_list is the correct way to fix it - it 
makes sure that a bio can't be held indefinitely.

Another way to fix it would be to abandon current->bio_list --- but then, 
there would be problem with stack overflow on deeply nested targets.

Mikulas
