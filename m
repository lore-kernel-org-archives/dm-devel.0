From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: Re: [PATCH RFC] dm snapshot: shared exception store
Date: Wed, 13 Aug 2008 08:29:28 +0900
Message-ID: <20080813082953F.fujita.tomonori@lab.ntt.co.jp>
References: <20080812221448N.fujita.tomonori@lab.ntt.co.jp>
	<200808121200.36628.phillips@phunq.net>
	<20080813082508U.fujita.tomonori@lab.ntt.co.jp>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20080813082508U.fujita.tomonori@lab.ntt.co.jp>
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
Cc: agk@redhat.com
List-Id: dm-devel.ids

On Wed, 13 Aug 2008 08:24:41 +0900
FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp> wrote:

> On Tue, 12 Aug 2008 12:00:36 -0700
> Daniel Phillips <phillips@phunq.net> wrote:
> 
> > On Tuesday 12 August 2008 06:14, FUJITA Tomonori wrote:
> > > >  You just want to use getblk for alloc_chunk_buffer,
> > > > not vmalloc.
> > > 
> > > I think that it means that we cache all the chunks, both btree chunks
> > > and the data chunks (which are passed to the upper layer such as file
> > > systems). I think that we don't want cache the latter in dm.
> > 
> > That is true.  However your code should not be reading data chunks into
> > memory at all.  The only time the snapshot code has to read a data
> > chunk is when performing the copy from origin to snapshot store in
> > make_unique.  Your code does not directly perform this task as far as I
> > can see.  That would be done in a part of the dm snapshot code your
> > patch does not touch, which I seem to recall uses the kcopyd mechanism.
> 
> Yes, dm-snapshot doesn't access to data chunks. However, dm does for
> dm-snapshot (by using submit_bio friends). So if dm-snapshot uses
> __getblk, we use both __getblk and submit_bio with a single device at
> the same time. I think that it's the right thing.

Oops, I meant, I don't think that it's the right thing.
