From: Kent Overstreet <kmo-PEzghdH756F8UrSeD/g0lQ@public.gmane.org>
Subject: Re: [PATCH] bcache: Remove use of down/up_read_non_owner()
Date: Tue, 20 Aug 2013 19:19:00 -0700
Message-ID: <20130821021900.GB4051@kmo-pixel>
References: <20130820111602.3cea203c@gandalf.local.home>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20130820111602.3cea203c-f9ZlEuEWxVcJvu8Pb33WZ0EMvNT87kid@public.gmane.org>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Steven Rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>
Cc: LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, dm-devel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Sebastian Andrzej Siewior <bigeasy-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org
List-Id: dm-devel.ids

On Tue, Aug 20, 2013 at 11:16:02AM -0400, Steven Rostedt wrote:
> 
> The down/up_read_non_owner() is a nasty hack in the API of the rwsem
> operations. It was once removed, but then resurrected for use with
> bcache. Not only is the API an abomination to the rwsem API, it also
> prevents bcache from ever being compiled with PREEMPT_RT, as the RT
> kernel requires all rwsems to have an owner.
> 
> Instead of keeping the down/up_read_non_owner() around, it is better to
> modify the one user of it and have it do something a bit differently.
> 
> From reading the bcache code, the reason for the non_owner usage is
> that a request is made, and writers must wait for that request to
> finish before they can continue. But because the request is completed
> by another task, the rwsem can not be held for read and then released
> on completion.
> 
> Instead of abusing the rwsem code for this, I added a refcount
> "nr_requests" to the cached_dev structure as well as a "write_waiters"
> wait queue. When a request is to be made, the rwsem is still taken for
> read, but this time with an owner. The refcount is incremented and
> before exiting the function, the rwsem is released.
> 
> The writer will then take the rwsem for write, check the refcount, if
> it is not zero, it will release the rwsem, add itself to a wait_event()
> waiting for refcount to become zero, and then try again.

I _really_ disagree with this approach.

I get that there's a problem, but the bcache code REALLY IS USING THE
RWSEM AS A LOCK; the answer isn't to open code the lock!

Apologies to Christoph for getting distracted and not responding when
you started to explain what the issues were for RT. I'm not really
convinced they're that insurmountable (one of the issues was debugging,
which the _non_owner() stuff always handled just fine), but I'll take it
on faith that this usage is incompatible with rwsems + the RT
functionality since I haven't actually had time to dig into it.

So assuming that's the case, IMO the sanest thing to do is make a new
type of lock - "rwsem_non_process" or somesuch - and use _that_ in
bcache. Not open coding the lock.

It can even live in the bcache code if we want since there currently
wouldn't be any other users, I don't really care. But open coding it?
Come on... makes me wonder what other code in the kernel is open coding
locks because it couldn't release it in the same process context that
took the lock for whatever reason.

Also, nack this patch because increasing the number of atomic ops to
shared cachelines in our fast path. If it does end up being open coded,
I'll make a more efficient version.
