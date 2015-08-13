From: NeilBrown <neilb@suse.com>
Subject: Re: dm-snap deadlock in pending_complete()
Date: Thu, 13 Aug 2015 10:43:55 +1000
Message-ID: <20150813104355.485ed63d@noble>
References: <20150810135551.64d7dbac@noble>
	<alpine.LRH.2.02.1508110509420.2623@file01.intranet.prod.int.rdu2.redhat.com>
	<20150812114631.15268065@noble>
	<alpine.LRH.2.02.1508121215430.12043@file01.intranet.prod.int.rdu2.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <alpine.LRH.2.02.1508121215430.12043@file01.intranet.prod.int.rdu2.redhat.com>
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

On Wed, 12 Aug 2015 12:25:42 -0400 (EDT) Mikulas Patocka
<mpatocka@redhat.com> wrote:

> 
> 
> On Wed, 12 Aug 2015, NeilBrown wrote:
> 
> > On Tue, 11 Aug 2015 05:14:33 -0400 (EDT) Mikulas Patocka
> > <mpatocka@redhat.com> wrote:
> > 
> > > Hi
> > > 
> > > On Mon, 10 Aug 2015, NeilBrown wrote:
> > > 
> > > > 
> > > > Hi Mikulas,
> > > >  I have a customer hitting the deadlock you described over a year ago
> > > >  in:
> > > > 
> > > > Subject: [dm-devel] [PATCH] block: flush queued bios when the process
> > > >          blocks
> > > 
> > > Ask block layer maintainers to accept that patch.
> > 
> > Unfortunately I don't really like the patch ... or the bioset rescue
> > workqueues that it is based on.   Sorry.
> > 
> > So I might keep looking for a more localised approach....
> 
> The problem here is that other dm targets may deadlock in a similar way 
> too - for example, dm-thin could deadlock on pmd->pool_lock.
> 
> The cause of the bug is bio queuing on current->bio_list. There is an 
> assumption that if a dm target submits a bio to a lower-level target, the 
> bio finishes in finite time. Queuing on current->bio_list breaks the 
> assumption, bios can be held indefinitelly on current->bio_list.
> 
> The patch that flushes current->bio_list is the correct way to fix it - it 
> makes sure that a bio can't be held indefinitely.
> 
> Another way to fix it would be to abandon current->bio_list --- but then, 
> there would be problem with stack overflow on deeply nested targets.
> 

I think it is a bit simplistic to say that current->bio_list is the
"cause" of the problem.  It is certainly a part of the problem.  The
assumption you mention is another part - and the two conflict.

As you say, we could abandon current->bio_list, but then we risk stack
overflows again.
Or we could hand the bio_list to a work-queue whenever the make_request
function needs to schedule.... but then if handling one of those bios
needs to schedule...  not sure, it might work.

Or we could change the assumption and never block in a make_request
function after calling generic_make_request().  Maybe that is difficult.

Or we could change __split_and_process_bio to use bio_split() to split
the bio, then handle the first and call generic_make_request on the
second.  That would effectively put the second half on the end of
bio_list so it wouldn't be tried until all requests derived from the
first half have been handled.

None of these is completely straight forward, but I suspect all are
possible.

I'm leaning towards the last one:  when you want to split a bio, use
bio_split and handle the two halves separately.

Do you have thoughts on that?

Thanks,
NeilBrown
