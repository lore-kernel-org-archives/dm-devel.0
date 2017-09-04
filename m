From: Mikulas Patocka <mpatocka@redhat.com>
Subject: Re: [PATCH/rfc] dm: revise 'rescue' strategy for md->bs
 allocations
Date: Mon, 4 Sep 2017 12:54:44 -0400 (EDT)
Message-ID: <alpine.LRH.2.02.1709041249100.9535@file01.intranet.prod.int.rdu2.redhat.com>
References: <878ti0fefq.fsf@notabene.neil.brown.name>
	<alpine.LRH.2.02.1708312233010.32309@file01.intranet.prod.int.rdu2.redhat.com>
	<87inh3dqp3.fsf@notabene.neil.brown.name>
	<alpine.LRH.2.02.1709011947200.22293@file01.intranet.prod.int.rdu2.redhat.com>
	<87a82be2zf.fsf@notabene.neil.brown.name>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <87a82be2zf.fsf@notabene.neil.brown.name>
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
Cc: dm-devel@redhat.com, Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@redhat.com>
List-Id: dm-devel.ids



On Mon, 4 Sep 2017, NeilBrown wrote:

> On Fri, Sep 01 2017, Mikulas Patocka wrote:
> 
> > On Fri, 1 Sep 2017, NeilBrown wrote:
> >
> >> On Thu, Aug 31 2017, Mikulas Patocka wrote:
> >> 
> >> >> 
> >> >> Note that only current->bio_list[0] is offloaded.  current->bio_list[1]
> >> >> contains bios that were scheduled *before* the current one started, so
> >> >
> >> > These bios need to be offloaded too, otherwise you re-introduce this 
> >> > deadlock: https://www.redhat.com/archives/dm-devel/2014-May/msg00089.html
> >> 
> >> Thanks for the link.
> >> In the example the bio that is stuck was created in step 4.  The call
> >> to generic_make_request() will have placed it on current->bio_list[0].
> >> The top-level generic_make_request call by Process A is still running,
> >> so nothing will have moved the bio to ->bio_list[1].  That only happens
> >> after the ->make_request_fn completes, which must be after step 7.
> >> So the problem bio is on ->bio_list[0] and the code in my patch will
> >> pass it to a workqueue for handling.
> >> 
> >> So I don't think the deadlock would be reintroduced.  Can you see
> >> something that I am missing?
> >> 
> >> Thanks,
> >> NeilBrown
> >
> > Offloading only current->bio_list[0] will work in a simple case described 
> > above, but not in the general case.
> >
> > For example, suppose that we have a dm device where the first part is 
> > linear and the second part is snapshot.
> >
> > * We receive bio A that crosses the linear/snapshot boundary
> > * DM core creates bio B, submits it to the linear target and adds it to 
> > current->bio_list[0]
> > * DM core creates bio C, submits it to the snapshot target, the snapshot 
> > target calls track_chunk for this bio and appends the bio to 
> > current->bio_list[0]
> > * Now, we return back to generic_make_request
> > * We pop bio B from current->bio_list[0]
> > * We execute bio_list_on_stack[1] = bio_list_on_stack[0], that moves bio C 
> > to bio_list_on_stack[1] - and now we lose any possibility to offload bio C 
> > to the rescue thread
> > * The kcopyd thread for the snapshot takes the snapshot lock and waits for 
> > bio C to finish
> 
> Thanks for the explanation.
> I cannot find this last step in the code.  "waits for BIO C to finish"
> is presumably the called to __check_for_conflicting_io().  This is
> called from kcopyd in merge_callback() -> snapshot_merge_next_chunks().
> What lock is held at that time?

The function pending_complete is called from the kcopyd callback. It takes 
"down_write(&s->lock)" and calls __check_for_conflicting_io which waits 
for I/Os to finish.

> > * We process bio B - and if processing bio B reaches something that takes 
> > the snapshot lock (for example an origin target for the snapshot), a 
> > deadlock will happen. The deadlock could be avoided by offloading bio C to 
> > the rescue thread, but bio C is already on bio_list_on_stack[1] and so it 
> > won't be offloaded
> 
> I think the core issue behind this deadlock is that the same volume
> can appear twice in the top-level device, in different regions.  An
> outstanding request to one region can then interfere with a new request
> to a different region.  That seems like a reasonable thing to do.
> I cannot immediately see a generic way to handle this case that I am
> happy with.  I'll keep hunting.

You can have a snapshot and an origin for the same device in the same 
tree - it is not common, but it is possible.

Offloafing bios queued on current->bio_list avoids the deadlock, but your 
patch breaks it by offloading only the first list and not the second.

> Thanks,
> NeilBrown

Mikulas
