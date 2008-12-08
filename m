From: Heinz Mauelshagen <heinzm@redhat.com>
Subject: Re: ANNOUNCE: consolidated patches for shared snapshots
Date: Mon, 08 Dec 2008 16:52:13 +0100
Message-ID: <1228751533.15732.6.camel@o>
References: <Pine.LNX.4.64.0812072212380.19378@hs20-bc2-1.build.redhat.com>
	<20081208151957Z.fujita.tomonori@lab.ntt.co.jp>
	<Pine.LNX.4.64.0812080847130.16914@hs20-bc2-1.build.redhat.com>
Reply-To: heinzm@redhat.com, device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <Pine.LNX.4.64.0812080847130.16914@hs20-bc2-1.build.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

Am Montag, den 08.12.2008, 09:02 -0500 schrieb Mikulas Patocka:
> 
> On Mon, 8 Dec 2008, FUJITA Tomonori wrote:
> 
> > On Sun, 7 Dec 2008 22:41:19 -0500 (EST)
> > Mikulas Patocka <mpatocka@redhat.com> wrote:
> > 
> > > I released new patches for shared snapshots. The functionality is the same 
> > > as in previous releases, but the two snapshot exception stores, one 
> > > created by Fujita Tomonori and one by me, are consolidated and common code 
> > > is shared.
> > > 
> > > The patches are at:
> > > http://people.redhat.com/mpatocka/patches/kernel/new-snapshots/
> > 
> > Thanks,
> > 
> > As I said before, I have no preference about how to integrate new
> > snapshot implementations into the existing code. I'm happy to follow
> > the maintainer, Alasdair?
> > 
> > 
> > > The patches don't alter existing snapshot implementation, they contain 
> > > just new files (they alter only Kconfig and Makefile to make the new files 
> > > compilable).
> > > 
> > > The new architecture is as follows:
> > > 
> > > The module dm-multisnapshot.ko contains common code for both exception 
> > > stores. It has basically processing and queuing IOs and attaching 
> > > snapshots and interfacing with device mapper.
> > 
> > I've not closely looked at your dm-multisnapshot but after a quick
> > look, I'm not sure about the number of exception I/Os (except for
> > metadata I/Os) with an origin write.
> 
> When writable snapshots will be implemented in my exception store, there 
> will be a situation when the code will need to perform more copies. My 
> implmentation stores snapshot ID ranges into the btree. For example, if I 
> have snapshots 0-10. Someone wrote to snapshot 5. Now someone writes to 
> the origin at this chunk. Two copies need to be performed, one for 
> snapshots 0-4 and one for snapshots 6-10.

Don't you just need a copy of the origin for snapshot 5, because it's
being changed and likewise another one for snapshots 0-4,6-10, because
the origin changes, hence snapshot 0-4,6-10 refer to that copy ?

I.e if any snapshot changes, it gets a private copy to change, either
from the origin unless already changed in which case it receives a copy
from the already existing origin copy.

Heinz

> 
> Kcopyd can perform at most 8 copies efficiently (one read + many 
> concurrent writes).
> 
> That's why there is this reset_query/query_next_remap/add_next_remap loop.
> 
> reset_query resets the search state in the snapshot store, 
> query_next_remap asks for next remapping to be done and add_next_remap 
> inserts the remapping into the b-tree. It continues to loop until it fills 
> all 8 kcopyd slots or until query_next_remap reports that there is nothing 
> more to do.
> 
> For your implementation, the loop executes just once, because you use 
> bitmap of snapshot IDs and you process all the snapshots in one call.
>  
> > For example, I create five snapshots and remove the 1 and 3 snapshots
> > (*1). Now I have 0, 2, 4 snapshots. Then when I update the origin, how
> > many exception I/Os dm-multisnapshot needs to perform?
> 
> For your implementation, just one. For my implementation, also just one, 
> because I don't resuse snapshot IDs --- so when I implement it, I can just 
> insert one entry with range 0-4. More entries need to be inserted when 
> someone wrote to the snapshots in the middle of the range.
> 
> > (*1) I know dm-multisnapshot doesn't support deleting a snapshot for
> > now, but I expect that it will support it in the future.
> > 
> > --
> > dm-devel mailing list
> > dm-devel@redhat.com
> > https://www.redhat.com/mailman/listinfo/dm-devel
> 
> Mikulas
> 
> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://www.redhat.com/mailman/listinfo/dm-devel
