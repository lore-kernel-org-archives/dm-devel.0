From: Mikulas Patocka <mpatocka@redhat.com>
Subject: Re: ANNOUNCE: consolidated patches for shared snapshots
Date: Mon, 8 Dec 2008 16:31:48 -0500 (EST)
Message-ID: <Pine.LNX.4.64.0812081621150.26709@hs20-bc2-1.build.redhat.com>
References: <Pine.LNX.4.64.0812072212380.19378@hs20-bc2-1.build.redhat.com>
	<20081208151957Z.fujita.tomonori@lab.ntt.co.jp>
	<Pine.LNX.4.64.0812080847130.16914@hs20-bc2-1.build.redhat.com>
	<1228751533.15732.6.camel@o>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1228751533.15732.6.camel@o>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: heinzm@redhat.com, device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids



On Mon, 8 Dec 2008, Heinz Mauelshagen wrote:

> Am Montag, den 08.12.2008, 09:02 -0500 schrieb Mikulas Patocka:
> > 
> > On Mon, 8 Dec 2008, FUJITA Tomonori wrote:
> > 
> > > I've not closely looked at your dm-multisnapshot but after a quick
> > > look, I'm not sure about the number of exception I/Os (except for
> > > metadata I/Os) with an origin write.
> > 
> > When writable snapshots will be implemented in my exception store, there 
> > will be a situation when the code will need to perform more copies. My 
> > implmentation stores snapshot ID ranges into the btree. For example, if I 
> > have snapshots 0-10. Someone wrote to snapshot 5. Now someone writes to 
> > the origin at this chunk. Two copies need to be performed, one for 
> > snapshots 0-4 and one for snapshots 6-10.
> 
> Don't you just need a copy of the origin for snapshot 5, because it's
> being changed and likewise another one for snapshots 0-4,6-10, because
> the origin changes, hence snapshot 0-4,6-10 refer to that copy ?
> 
> I.e if any snapshot changes, it gets a private copy to change, either
> from the origin unless already changed in which case it receives a copy
> from the already existing origin copy.
> 
> Heinz

I mean is: If you have snapshots 0-10 and a chunk that is allocated in 
none of the snapshots, then writing the chunk to the origin allocates one 
record with range (0-10) in the btree and there is just one copy.

But if you have a chunk that is allocated in none of the snapshots, then 
write this chunk to the snapshot 5, it will copy the chunk and create a 
record with range (5-5) in the btree. Now, if you write to the origin for 
that chunk, you need to create two records, one with range (0-4) and the 
other with range (6-10). That's where multiple copies come from.

Mikulas
