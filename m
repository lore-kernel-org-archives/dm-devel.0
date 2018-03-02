From: "Benjamin Marzinski" <bmarzins@redhat.com>
Subject: Re: [RFC PATCH 17/20] libmultipath/foreign: nvme foreign
	library
Date: Fri, 2 Mar 2018 12:30:47 -0600
Message-ID: <20180302183047.GF14513@octiron.msp.redhat.com>
References: <20180220132658.22295-1-mwilck@suse.com>
	<20180220132658.22295-18-mwilck@suse.com>
	<20180301031420.GM14513@octiron.msp.redhat.com>
	<1520006668.4169.69.camel@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <1520006668.4169.69.camel@suse.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Martin Wilck <mwilck@suse.com>
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

On Fri, Mar 02, 2018 at 05:04:28PM +0100, Martin Wilck wrote:
> On Wed, 2018-02-28 at 21:14 -0600, Benjamin Marzinski wrote:
> > On Tue, Feb 20, 2018 at 02:26:55PM +0100, Martin Wilck wrote:
> > > +void cleanup(struct context *ctx)
> > > +{
> > > +	if (ctx == NULL)
> > > +		return;
> > > +
> > > +	(void)delete_all(ctx);
> > > +
> > > +	lock(ctx);
> > > +	pthread_cleanup_push(unlock, ctx);
> > > +	vector_free(ctx->mpvec);
> > > +	pthread_cleanup_pop(1);
> > > +	pthread_mutex_destroy(&ctx->mutex);
> > > +
> > > +	free(ctx);
> > > +}
> > 
> > Would you mind either removing the locking, or adding a comment
> > explaining that it's not necessary here.  If you really did need to
> > lock
> > ctx in order guard against someone accessing ctx->mpvec in cleanup(),
> > then not setting it to NULL after its freed, and immediately freeing
> > ctx
> > afterwards would clearly be broken, so seeing the locking makes it
> > look
> > like this function is wrong.
> 
> I don't understand, sorry. I need to lock because some other entity may
> still be using ctx->mpvec when cleanup() is called, and I should wait
> until that other entity has released the lock before I free it.

Who else could be using ctx->mpvec?  You only call cleanup on code paths
through init_foreign and cleanup_foreign.  There are no seperate threads
running in parallel in multipath, and in multipathd, you call
init_foreign before any other threads except the log writer thread is
created, and call cleanup_foreign after all the main threads except for
the log writer thread have been waited for? I admit, there could be a
rogue checker or prio thread that has been cancelled, but still not
returned, but those don't touch the foreign ctx code. If I'm missing
something, or you want to make sure that this code is future-proofed,
against possible future threads, you need some ref counting. Otherwise,
you could get into a situation where the thread doing the cleanup locks
the ctx->mutex and then another thread blocks on it. When the cleanup
thread drops the mutex and frees ctx, the other thread will grab a lock
to freed memory.

> I'm
> also pretty sure that checkers such as coverity would complain if I
> free a structure here without locking which I access only under the
> lock in other places.

Yeah. That's why I said you could just add a comment.
 
> I agree, though, that I should nullify the data and add checks in the
> other functions. I'll also add some locking in the foreign.c file,
> didn't occur to me before.

-Ben
