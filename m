From: Mikulas Patocka <mpatocka@redhat.com>
Subject: Re: [PATCH RFC] dm snapshot: shared exception store
Date: Mon, 11 Aug 2008 18:12:08 -0400 (EDT)
Message-ID: <Pine.LNX.4.64.0808111740520.14722@hs20-bc2-1.build.redhat.com>
References: <20080804171242V.fujita.tomonori@lab.ntt.co.jp>
	<Pine.LNX.4.64.0808061453470.19728@devserv.devel.redhat.com>
	<20080809140205V.fujita.tomonori@lab.ntt.co.jp>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20080809140205V.fujita.tomonori@lab.ntt.co.jp>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: dm-devel@redhat.com, agk@redhat.com
List-Id: dm-devel.ids

> > - drop that limitation on maximum 64 snapshots. If we are going to 
> > redesign it, we should design it without such a limit, so that we wouldn't 
> > have to redesign it again (why we need more than 64 --- for example to 
> > take periodic snapshots every few minutes to record system activity). The 
> > limit on number of snapshots can be dropped if we index b-tree nodes by a 
> > key that contains chunk number and range of snapshot numbers where this 
> > applies.
> 
> Unfortunately it's the limitation of the current b-tree
> format. As far as I know, there is no code that we can use, which
> supports unlimited and writable snapshot.

So use different format --- we in RedHat plan redesigning it too. One of 
the needed features is "rolling snapshots" --- i.e. you take snapshot 
every 5 minutes or so and you keep them around. The result is that you 
have complete history of the system activity.

And this 64-snapshot limitation would not allow this. The problem if we 
use this format is that we will spend a lot of time developing and 
finalizing it --- and then a requirement for rolling snapshots comes --- 
and we'll have to throw it away and start from scratch. So I'd rather do 
b-tree without limitation on number of snapshots from the beginning.

Another good thing would be the ability to compress several consecutive 
chunks into one b-tree entry. But I think with multiple snapshots, there 
is no clean way how to do it. Maybe design it without this possibility, 
and then use some dirty hack to compress consecutive chunks in most common 
cases (such as for example when no one writes to the snapshots).

> > - do some cache for metadata, don't read the b-tree from the root node 
> > from disk all the time.
> 
> The current code already does.

I see. That GFP_NOFS allocation shouldn't be there, because
- it is not reliable
- it can recurse back into block writing via swapper (use GFP_NOIO to 
avoid that)

The correct solution would be to preallocate one or more buffers in the 
target constructor. When running, get additional buffers with GFP_NOIO, 
but if that fails, use the preallocated buffer. --- this way it can handle 
temporary memory shortage without data corruption.

I'll write some generic code for that caching, I think it could be useful 
even for other targets, so it'd be best to write it into main dm module.

> > Ideally the cache should be integrated with page 
> > cache so that it's size would tune automatically (I'm not sure if it's 
> > possible to cleanly code it, though).
> 
> Agreed. The current code invents the own cache code. I don't like it
> but there is no other option.

Yes. Theoretically you can create your own address_space_operations and 
try to integrate it into memory management. Practically, it's hard to say 
if it will work (and if it will be maintainable as memory management 
changes).

> > - the b-tree is good structure, I'd create log-structured filesystem to 
> > hold the b-tree. The advantage is that it will require less 
> > synchronization overhead in clustering. Also, log-structured filesystem 
> > will bring you crash recovery (with minimum coding overhead) and it has 
> > very good write performance.
> 
> A log-structured filesystem is pretty complex. Even though we don't
> need a complete log-structured filesystem, it's still too complex,
> IMO.

I think it's not really harder than journaling. Maybe it's even easier, 
because in journaling you have replay code that is very hard to test and 
debug (ext3 had some replay bug even recently). In log-structured 
filesystem there is no replay code, it is always consistent.

(I obviously don't mean to develop the whole filesystem for that --- just 
use the main idea that you write always forward into unallocated space)

+ good for performance, majority of operations are writes
+ doesn't need cache-synchronization for cluster
+ can be simultaneously read by more cluster nodes and written by one 
cluster node (all other formats require read:write exclusion)

> A copy-on-Write manner to update the b-tree on disk (as some of the
> latest file systems do) is a possible option.

That is what I mean. When we modify a node, one possibility is to write 
b-tree blocks back to the root to unallocated space. The other possibility 
is to write just one block to new space and mark it in superblock as 
"redirected" from the old location. When the array of redirected blocks 
fills up, write all b-tree blocks up to the root and erase the array of 
redirected blocks (this will improve performance because you don't have to 
write the full path up to root on every block update).

Another question is, where the superblock should be located. Just one 
superblock at the beginning would be bad for disk seeks, maybe have 
superblock at each disk track (approximatelly ... we don't know where the 
tracks area), use some sequence counter to tell which one is the newest, 
and write to the one that is near to the data.

> Another option is using journaling as I wrote.
> 
> 
> > - deleting the snapshot --- this needs to walk the whole b-tree --- it is 
> > slow. Keeping another b-tree of chunks belonging to the given snapshot 
> > would be overkill. I think the best solution would be to split the device 
> > into large areas and use per-snapshot bitmap that says if the snapshot has 
> > some exceptions allocated in the pertaining area (similar to the 
> > dirty-bitmap of raid1). For short lived snapshots this will save walking 
> > the b-tree. For long-lived snapshots there is no help to speed it up... 
> > But delete performance is not that critical anyway because deleting can be 
> > done asynchronously without user waiting for it.
> 
> Yeah, it would be nice to delete a snapshot really quickly but it's
> not a must.

Mikulas
