From: Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [PATCH] bcache: Remove use of down/up_read_non_owner()
Date: Wed, 21 Aug 2013 04:38:21 -0400
Message-ID: <20130821043821.6e1224b4@gandalf.local.home>
References: <20130820111602.3cea203c@gandalf.local.home>
	<20130821021900.GB4051@kmo-pixel>
	<20130820224153.5667495b@gandalf.local.home>
	<20130821033658.GE4051@kmo-pixel>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20130821033658.GE4051@kmo-pixel>
Sender: linux-kernel-owner@vger.kernel.org
To: Kent Overstreet <kmo@daterainc.com>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-bcache@vger.kernel.org, dm-devel@redhat.com, Christoph Hellwig <hch@infradead.org>, David Howells <dhowells@redhat.com>, Thomas Gleixner <tglx@linutronix.de>, Sebastian Andrzej Siewior <bigeasy@linutronix.de>, akpm@linux-foundation.org
List-Id: dm-devel.ids

On Tue, 20 Aug 2013 20:36:58 -0700
Kent Overstreet <kmo@daterainc.com> wrote:


> I think we're mostly quibbling over semantics here, and it's not that
> big a deal - that said, I don't really get your distinction between a
> semaphore and a mutex; I'd distinguish them by saying a semaphore can
> count an arbitrary number of resources (the number it's initialized to),
> and a mutex is always initialized to one - the fact that in the kernel
> mutexes must be released by the same process that took them (while
> important for PI and debugging) is not fundamental.

Understood. As, I usually am focused on PI and debugging, it may be
more fundamental to me than others.

> 
> "rw semaphore" never made any sense to me; they're not counting
> anything, like regular semaphores. They're just sleepable rw locks.

Me either.

> 
> So it _sounds_ like you're saying bcache is using it as a semaphore,
> beacuse it's using it as a lock we don't release in the original
> context? in analogy to linux mutexes and semaphores? Not quite sure what
> you mean.

Actually, I'm thinking you are using it more as a completion than a
semaphore.


> > I have a hack that actually implements a work around for non_owner, but
> > it adds overhead to all locks to do so.
> 
> Ok - I'd just be curious why the PI bit can't be factored out into a
> wrapper like how the debug stuff is handled with the _non_owner bits,
> but I can certainly believe that.

The problem is that all sleeping locks go through rt_mutex. The locks
are replaced with locks that incorporate PI.


> To simplify the algorithm just a bit (only leaving out some
> optimizations), bcache is using it to protect a rb tree, which containts
> "things that are undergoing background writeback".

I think this is what makes bcache unique in the kernel, and I don't
think there's open coded locks elsewhere.

> 
> For foreground writes, we've got to check if the write overlaps with
> anything in this rb tree. If so, we force _this_ write to writeback;
> background writeback will write stale data to the backing device, but
> that's fine because the data in the cache will still be marked as dirty.
> 
> To add stuff to this rb tree - i.e. for background writeback to start
> flushing some dirty data - it's got to make sure it's not going to
> overwrite some in progress foreground writethrough write.
> 
> Tracking every outstanding foreground write would be expensive, so
> foreground writes take a read lock on the rb tree (both to check it for
> anything they overlap with, and for their duration), and background
> writeback takes a write lock when it goes to scan for dirty data to add
> to the rb tree.
> 
> Even if you complain it's not _just_ protecting the rb tree, we're still
> using it for mutual exclusion, plain and simple, and that's all a lock
> is.

Well, rwlocks and rwsems are not mutually exclusive ;-) The read side
has multiple accessors. A mutual exclusion also would be a single task
needing exclusive access to a resource. But as things are done in the
background, that is not the case. But we are arguing semantics here and
not helping with a solution.

> 
> 
> > > Also, nack this patch because increasing the number of atomic ops to
> > > shared cachelines in our fast path. If it does end up being open coded,
> > > I'll make a more efficient version.
> > 
> > Perhaps I can whip up a "struct rwsem_non_owner" and have a very
> > limited API for that, and then you can use that.
> 
> That would be perfect :)

OK, I'll see what I can do.

-- Steve
