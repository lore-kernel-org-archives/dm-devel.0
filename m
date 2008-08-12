From: Daniel Phillips <phillips@phunq.net>
Subject: Re: [PATCH RFC] dm snapshot: shared exception store
Date: Tue, 12 Aug 2008 05:30:46 -0700
Message-ID: <200808120530.47308.phillips@phunq.net>
References: <Pine.LNX.4.64.0808061453470.19728@devserv.devel.redhat.com>
	<20080812083440U.fujita.tomonori@lab.ntt.co.jp>
	<alpine.DEB.1.00.0808111644340.15543@abydos.NerdBox.Net>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <alpine.DEB.1.00.0808111644340.15543@abydos.NerdBox.Net>
Content-Disposition: inline
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: dm-devel@redhat.com
Cc: zumastor@googlegroups.com, agk@redhat.com
List-Id: dm-devel.ids

Hi Steve,

On Monday 11 August 2008 17:15, Steve VanDeBogart wrote:
> On Tue, 12 Aug 2008, FUJITA Tomonori wrote:
> > On Mon, 11 Aug 2008 18:12:08 -0400 (EDT) Mikulas Patocka <mpatocka@redhat.com> wrote:
> >> - drop that limitation on maximum 64 snapshots. If we are going to
> >> redesign it, we should design it without such a limit, so that we wouldn't
> >> have to redesign it again (why we need more than 64 --- for example to
> >> take periodic snapshots every few minutes to record system activity). The
> >> limit on number of snapshots can be dropped if we index b-tree nodes by a
> >> key that contains chunk number and range of snapshot numbers where this
> >> applies.
> >
> > Unfortunately it's the limitation of the current b-tree
> > format. As far as I know, there is no code that we can use, which
> > supports unlimited and writable snapshot.
> 
> I've recently worked on the limit of 64 snapshots and the storage cost of 
> 2x64bits per modified chunk.  A btree format that fixes these two issue 
> is described in this post: http://lwn.net/Articles/288896/  If you have 
> the time / energy, I believe that this format will work well and be 
> simple and elegant.  I can't speak for Daniel Phillips, but I suspect he 
> is concentrating on tux3 and not on getting this format into Zumastor.

It is very much the intention to get the versioned pointer code into
ddsnap.  There is also this code:

   http://tux3.org/tux3?f=81a1dd303e2a;file=user/test/dleaf.c

which implements a compressed leaf dictionary format that I believe you
last saw on a whiteboard a few weeks ago.  It now works pretty well, in
part thanks to Shapor.  The idea is to thoroughly shake out this code in
Tux3 then backport to ddsnap.  But nothing stands in the way of somebody
just putting that in now.

Incidentally, it did turn out to be possible to make the group entries
32 bits.  Demented code to be honest, but the leaf compression is really
good while the speed is roughly the same as the existing code, and it has
the benefit of supporting 48 bit block numbers while the existing code
only supports 32.  It also has the pleasant property of most of the
memmoves being zero bytes, because I got it right this time and put the
leaf dictionary upside down at the top of the block instead of having
the exceptions at the top.

You are right that I will not be merging this code in the immediate
future.  Anybody who wants to take that on is more than welcome.  It will
not be a hard project to integrate that code and the algorithms are quite
interesting.

Over time, a few other pieces of Tux3 will get merged back into ddsnap, 
for example, the forward logging atomic update method to eliminate most
of the remaining journal overhead.

> With both of these formats, in the context of the Zumastor codebase, the 
> number of snapshots is limited by a requirement that all metadata about
> a specific chunk fit within a single btree node.  This limits the 
> number of snapshots to approximately a quarter the chunk size. i.e. 4k
> chunks would support approximately 500 snapshots. 

One eighth the chunk size, you meant.  Chunk pointers being 8 bytes,
and the leaf directory overhead being insignificant by the time a
block has been split down to just a single logical address.

> Removing that restriction would increase the number of supported 
> snapshots by a factor of eight, at which point the next restriction
> is encountered.

I think the next restriction is the size of the version table in the
superblock, which is easily overcome.  Then the next one after that is
the number of bits available in the block pointer for the version,
which can resonably be 16 with 48 bit block pointers, giving 2^16 user
visible snapshots, which is getting pretty close to unlimited.

Regards,

Daniel
