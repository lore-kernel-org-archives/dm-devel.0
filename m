From: Eric Wheeler <dm-devel@lists.ewheeler.net>
Subject: Re: [RFC] dm-thin: Heuristic early chunk copy before COW
Date: Fri, 10 Mar 2017 16:43:25 -0800 (PST)
Message-ID: <alpine.LRH.2.11.1703101631300.21446@mail.ewheeler.net>
References: <alpine.LRH.2.11.1703081005001.19383@mail.ewheeler.net>
	<20170309115142.GA17308@nim>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20170309115142.GA17308@nim>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Joe Thornber <thornber@redhat.com>
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

On Thu, 9 Mar 2017, Joe Thornber wrote:

> Hi Eric,
> 
> On Wed, Mar 08, 2017 at 10:17:51AM -0800, Eric Wheeler wrote:
> > Hello all,
> > 
> > For dm-thin volumes that are snapshotted often, there is a performance 
> > penalty for writes because of COW overhead since the modified chunk needs 
> > to be copied into a freshly allocated chunk.
> > 
> > What if we were to implement some sort of LRU for COW operations on 
> > chunks? We could then queue chunks that are commonly COWed within the 
> > inter-snapshot interval to be background copied immediately after the next 
> > snapshot. This would hide the latency and increase effective throughput 
> > when the thin device is written by its user since only the meta data would 
> > need an update because the chunk has already been copied.
> > 
> > I can imagine a simple algorithm where the COW increments the chunk LRU by 
> > 2, and decrements the LRU by 1 for all stored LRUs when the volume is 
> > snapshotted. After the snapshot, any LRU>0 would be queued for early copy.
> > 
> > The LRU would be in memory only, probably stored in a red/black tree. 
> > Pre-copied chunks would not update on-disk meta data unless a write occurs 
> > to that chunk. The allocator would need to be updated to ignore chunks 
> > that are in the LRU list which have been pre-copied (perhaps except in the 
> > case of pool free space exhaustion).
> > 
> > Does this sound viable?
> 
> Yes, I can see that it would benefit some people, and presumably we'd
> only turn it on for those people.  Random thoughts:
> 
> - I'm doing a lot of background work in the latest version of dm-cache
>   in idle periods and it certainly pays off.
> 
> - There can be a *lot* of chunks, so holding a counter for all chunks in
>   memory is not on.  (See the hassle I had squeezing stuff into memory
>   of dm-cache).
> 
> - Commonly cloned blocks can be gleaned from the metadata.  eg, by
>   walking the metadata for two snapshots and taking the common ones.
>   It might be possible to come up with a 'commonly used set' once, and
>   then keep using it for all future snaps.

That's a good idea. I have quite a few snapshot dump records, I'll run 
through them and see how common the COW blocks are between hourly 
snapshots.

 
> - Doing speculative work like this makes it harder to predict
>   performance.  At the moment any expense (ie. copy) is incurred
>   immediately as the triggering write comes in.

True. We would definitely want the early COW copies to run as idle IO.


> - Could this be done from userland?  Metadata snapshots let userland see
>   the mappings, alternatively dm-era let's userland track where io has
>   gone.  A simple read then write of a block would trigger the sharing
>   to be broken.

Userland could definitely break mappings in userspace with a pre-COWing 
process, however, you would want to somehow lock the block so as not to 
race the thin device user with the pre-COWing process. Is there already a 
mechamism to lock blocks from userspace and release them after the copy?

While this would work, it locks the block and prevents the opportunity 
from the thin device user from making its write to the COW if there was 
such a race; the optimal case when the pre-COWing process races the thin 
device user is to let the thin device user to win.

I acknowledge that the memory footprint and issues related to storing the 
pre-COW LRU in kernel memory might be notable. However, if there is a way 
to let the kernel do the work somehow, then we can pre-copy without 
breaking the COW in the meta data to preserve pool space; mappings would 
only be broken in the thin meta data if the thin device user actually 
writes to the specutively pre-COWed chunk. I suppose the meta data does 
not need to be in RAM; it could be an ephemeral on-disk b-tree under 
dm-bufio. For example, the thin pool could be passed an optional meta data 
volume for LRU purposes.

-Eric


> 
> - Joe
> 
> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://www.redhat.com/mailman/listinfo/dm-devel
> 
