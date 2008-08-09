From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: Re: [PATCH RFC] dm snapshot: shared exception store
Date: Sat, 9 Aug 2008 14:01:51 +0900
Message-ID: <20080809140205V.fujita.tomonori@lab.ntt.co.jp>
References: <20080804171242V.fujita.tomonori@lab.ntt.co.jp>
	<Pine.LNX.4.64.0808061453470.19728@devserv.devel.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <Pine.LNX.4.64.0808061453470.19728@devserv.devel.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: mpatocka@redhat.com
Cc: dm-devel@redhat.com, agk@redhat.com
List-Id: dm-devel.ids

On Wed, 6 Aug 2008 15:14:50 -0400 (EDT)
Mikulas Patocka <mpatocka@redhat.com> wrote:

> Hi
> 
> I looked at it.

Thanks! I didn't expect someone read the patch. I'll submit patches in
more proper manner next time.


> Alasdair had some concerns about the interface on the phone call. From my 
> point of view, the Fujita's interface is OK (using messages to manipulate 
> the snapshot storage and using targets to access the snapshots). Alasdair, 
> could you be pls. more specific about it?

Yeah, we can't use dmsetup create/destroy to create/delete
snapshots. We need something different.

I have no strong opinion about it. Whatever interface is fine by me as
long as it works.


> What I would propose to change in the upcoming redesign:
> 
> - develop it as a separate target, not patch against dm-snapshot. The code 
> reuse from dm-snapshot is minimal, and keeping the old code around will 
> likely consume more coding time then the potential code reuse will save.

It's fine by me if the maintainer prefers it. Alasdair?


> - drop that limitation on maximum 64 snapshots. If we are going to 
> redesign it, we should design it without such a limit, so that we wouldn't 
> have to redesign it again (why we need more than 64 --- for example to 
> take periodic snapshots every few minutes to record system activity). The 
> limit on number of snapshots can be dropped if we index b-tree nodes by a 
> key that contains chunk number and range of snapshot numbers where this 
> applies.

Unfortunately it's the limitation of the current b-tree
format. As far as I know, there is no code that we can use, which
supports unlimited and writable snapshot.


> - do some cache for metadata, don't read the b-tree from the root node 
> from disk all the time.

The current code already does.


> Ideally the cache should be integrated with page 
> cache so that it's size would tune automatically (I'm not sure if it's 
> possible to cleanly code it, though).

Agreed. The current code invents the own cache code. I don't like it
but there is no other option.


> - the b-tree is good structure, I'd create log-structured filesystem to 
> hold the b-tree. The advantage is that it will require less 
> synchronization overhead in clustering. Also, log-structured filesystem 
> will bring you crash recovery (with minimum coding overhead) and it has 
> very good write performance.

A log-structured filesystem is pretty complex. Even though we don't
need a complete log-structured filesystem, it's still too complex,
IMO.

A copy-on-Write manner to update the b-tree on disk (as some of the
latest file systems do) is a possible option. Another option is using
journaling as I wrote.


> - deleting the snapshot --- this needs to walk the whole b-tree --- it is 
> slow. Keeping another b-tree of chunks belonging to the given snapshot 
> would be overkill. I think the best solution would be to split the device 
> into large areas and use per-snapshot bitmap that says if the snapshot has 
> some exceptions allocated in the pertaining area (similar to the 
> dirty-bitmap of raid1). For short lived snapshots this will save walking 
> the b-tree. For long-lived snapshots there is no help to speed it up... 
> But delete performance is not that critical anyway because deleting can be 
> done asynchronously without user waiting for it.

Yeah, it would be nice to delete a snapshot really quickly but it's
not a must.
