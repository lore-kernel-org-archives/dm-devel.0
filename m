From: Mikulas Patocka <mpatocka@redhat.com>
Subject: Re: [PATCH] dm-bufio: implement discard
Date: Fri, 7 Feb 2020 13:04:15 -0500 (EST)
Message-ID: <alpine.LRH.2.02.2002071259240.7925@file01.intranet.prod.int.rdu2.redhat.com>
References: <alpine.LRH.2.02.2002071143390.32552@file01.intranet.prod.int.rdu2.redhat.com>
	<CAMeeMh-8MN=Jf4YhJ+Vx9-=Xa84EAPuDFyUk+jNU7ChB_EJ-6Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <CAMeeMh-8MN=Jf4YhJ+Vx9-=Xa84EAPuDFyUk+jNU7ChB_EJ-6Q@mail.gmail.com>
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

> > +/*
> > + * Free the specified range of buffers. If a buffer is held by other process, it
> > + * is not freed. If a buffer is dirty, it is discarded without writeback.
> > + * Finally, send the discard request to the device.
> Might be clearer to say "After freeing, send a discard request for the
> specified range to the device." to clarify that it's all cases, not
> just the dirty-buffer case mentioned in the previous sentence.
> 
> > + */
> > +int dm_bufio_discard_buffers(struct dm_bufio_client *c, sector_t block, sector_t count)
> > +{
> > +       sector_t i;
> > +
> > +       for (i = block; i < block + count; i++) {
> > +               struct dm_buffer *b;
> > +               dm_bufio_lock(c);
> > +               b = __find(c, i);
> > +               if (b && likely(!b->hold_count)) {
> > +                       wait_on_bit_io(&b->state, B_READING, TASK_UNINTERRUPTIBLE);
> > +                       wait_on_bit_io(&b->state, B_WRITING, TASK_UNINTERRUPTIBLE);
> > +                       __unlink_buffer(b);
> > +                       __free_buffer_wake(b);
> > +               }
> > +               dm_bufio_unlock(c);
> > +       }
> > +
> > +       return dm_bufio_issue_discard(c, block, count);
> > +}
> > +EXPORT_SYMBOL_GPL(dm_bufio_discard_buffers);
> 
> This seems dangerous -- if another process is holding the buffer, you
> could be issuing a discard while they are reading or writing, or vice
> versa.
> 
> Discards whose lifetime overlaps with the lifetime of a read or write
> to the same region have undefined behavior, as far as I know.

So the user should not do it. I don't see a problem with it. If the user 
sends two ovelapping writes, it is unspecified which of them stays on the 
device. If the user sends a read with overlapping write, it is unspecified 
if the read returns the old data or the new data.

It's the same with overlapping discards and other I/Os.

> Perhaps dm_bufio_issue_discard() should allow the caller to specify a
> callback, in which case dm_bufio_discard_buffers could unlock any
> buffers in the range upon completion; or dm_bufio_discard_buffers
> should not issue discards for blocks held by other processes.

Mikulas
