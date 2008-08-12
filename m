From: Steve VanDeBogart <vandebo-dm@NerdBox.Net>
Subject: Re: [PATCH RFC] dm snapshot: shared exception store
Date: Mon, 11 Aug 2008 17:15:51 -0700 (PDT)
Message-ID: <alpine.DEB.1.00.0808111644340.15543@abydos.NerdBox.Net>
References: <Pine.LNX.4.64.0808061453470.19728@devserv.devel.redhat.com>
	<20080809140205V.fujita.tomonori@lab.ntt.co.jp>
	<Pine.LNX.4.64.0808111740520.14722@hs20-bc2-1.build.redhat.com>
	<20080812083440U.fujita.tomonori@lab.ntt.co.jp>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; format=flowed; charset=US-ASCII
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20080812083440U.fujita.tomonori@lab.ntt.co.jp>
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
Cc: agk@redhat.com
List-Id: dm-devel.ids

On Tue, 12 Aug 2008, FUJITA Tomonori wrote:
> On Mon, 11 Aug 2008 18:12:08 -0400 (EDT) Mikulas Patocka <mpatocka@redhat.com> wrote:
>> - drop that limitation on maximum 64 snapshots. If we are going to
>> redesign it, we should design it without such a limit, so that we wouldn't
>> have to redesign it again (why we need more than 64 --- for example to
>> take periodic snapshots every few minutes to record system activity). The
>> limit on number of snapshots can be dropped if we index b-tree nodes by a
>> key that contains chunk number and range of snapshot numbers where this
>> applies.
>
> Unfortunately it's the limitation of the current b-tree
> format. As far as I know, there is no code that we can use, which
> supports unlimited and writable snapshot.

I've recently worked on the limit of 64 snapshots and the storage cost of 
2x64bits per modified chunk.  A btree format that fixes these two issue 
is described in this post: http://lwn.net/Articles/288896/  If you have 
the time / energy, I believe that this format will work well and be 
simple and elegant.  I can't speak for Daniel Phillips, but I suspect he 
is concentrating on tux3 and not on getting this format into Zumastor.

If you don't want to implement "versioned pointers," an earlier format
change is implemented as a patch against Zumastor here:
http://groups.google.com/group/zumastor/browse_thread/thread/523ee7925add3dfc/a5d26a4b48fd8906?lnk=gst&q=#a5d26a4b48fd8906
It removes the 64 snapshot limit and reduces the meta-data storage 
requirements, but does not support snapshots of snapshots.  This patch 
has undergone reasonable testing and can be considered beta level code.

With both of these formats, in the context of the Zumastor codebase, the 
number of snapshots is limited by a requirement that all metadata about
a specific chunk fit within a single btree node.  This limits the 
number of snapshots to approximately a quarter the chunk size. i.e. 4k
chunks would support approximately 500 snapshots. 
Removing that restriction would increase the number of supported 
snapshots by a factor of eight, at which point the next restriction
is encountered.

>> - deleting the snapshot --- this needs to walk the whole b-tree --- it is
>> slow. Keeping another b-tree of chunks belonging to the given snapshot
>> would be overkill. I think the best solution would be to split the device
>> into large areas and use per-snapshot bitmap that says if the snapshot has
>> some exceptions allocated in the pertaining area (similar to the
>> dirty-bitmap of raid1). For short lived snapshots this will save walking
>> the b-tree. For long-lived snapshots there is no help to speed it up...
>> But delete performance is not that critical anyway because deleting can be
>> done asynchronously without user waiting for it.

I don't know if it would be useful for your port, but there are some
patches floating around the Zumastor mailing list that implement
background delete.  They're not production ready but are a good start on
the implementation.

--
Steve
