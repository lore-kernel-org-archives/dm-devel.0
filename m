From: Mikulas Patocka <mpatocka@redhat.com>
Subject: Re: [PATCH] dm-bufio: implement discard
Date: Fri, 7 Feb 2020 15:07:05 -0500 (EST)
Message-ID: <alpine.LRH.2.02.2002071456370.16613@file01.intranet.prod.int.rdu2.redhat.com>
References: <alpine.LRH.2.02.2002071143390.32552@file01.intranet.prod.int.rdu2.redhat.com>
	<CAMeeMh-8MN=Jf4YhJ+Vx9-=Xa84EAPuDFyUk+jNU7ChB_EJ-6Q@mail.gmail.com>
	<alpine.LRH.2.02.2002071259240.7925@file01.intranet.prod.int.rdu2.redhat.com>
	<CAMeeMh-r9Hxj+FCxg510wrfYb=Hhnz2wVbxLHfjVTz3i23XHHA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <CAMeeMh-r9Hxj+FCxg510wrfYb=Hhnz2wVbxLHfjVTz3i23XHHA@mail.gmail.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: John Dorminy <jdorminy@redhat.com>
Cc: Heinz Mauelshagen <heinzm@redhat.com>, Mike Snitzer <msnitzer@redhat.com>, device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids



On Fri, 7 Feb 2020, John Dorminy wrote:

> There's no obvious way for the other process to wait for the discard
> to be complete at the present time, though -- suppose there were two
> holders of a given buffer, and one decided to discard -- how will the
> second one to wait for the discard to complete, or even tell that it's
> currently being discarded from another thread? I would naively guess
> that __write_dirty_buffer() waits via wait_on_bit_io(&b->state,
> B_WRITING, ...) to make sure nobody else is doing IO on the buffer
> location at the moment, but a discard doesn't currently set that bit,
> as far as I can see.
> 
> (If there is a way to wait, perhaps it should be documented at
> dm_bufio_discard_buffers() -- "If there is another process holding the
> buffer, the other process should be sure to [do stuff] before issuing
> a write, lest the write potentially be dropped or corrupted."

If two processes write to the same buffer, it is undefined behavior. If 
both of them do this:
	1) dm_bufio_get
	2) ... write to the buffer
	3) dm_bufio_mark_buffer_dirty
	4) dm_bufio_release
it is undefined what data the buffer would hold. It can even hold mixture 
of data written by those two processes. You must design your code in such 
a way that this doesn't happen.

The same is with discards - if you want to use them, you must design your 
code so that it doesn't overlay discards with other I/O. If you can't 
design it this way, then don't use discard.

Mikulas
