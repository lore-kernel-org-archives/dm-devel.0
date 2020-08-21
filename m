From: Benjamin Marzinski <bmarzins@redhat.com>
Subject: Re: [RFC PATCH 4/6] multipathd: cancel threads early
	during shutdown
Date: Fri, 21 Aug 2020 17:22:19 -0500
Message-ID: <20200821222219.GZ19233@octiron.msp.redhat.com>
References: <20190104175914.22784-1-mwilck@suse.com>
	<20190104175914.22784-5-mwilck@suse.com>
	<20190116234056.GT11315@octiron.msp.redhat.com>
	<ac0f4fc202cf40b1c12dd7484468a162d757b4e0.camel@suse.com>
	<9b5a6c4fd5790f4662cf70d23578f86e90bbe37f.camel@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <9b5a6c4fd5790f4662cf70d23578f86e90bbe37f.camel@suse.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
Content-Disposition: inline
To: Martin Wilck <mwilck@suse.com>
Cc: Chongyun Wu <wu.chongyun@h3c.com>, dm-devel@redhat.com
List-Id: dm-devel.ids

On Thu, Aug 20, 2020 at 10:39:19PM +0200, Martin Wilck wrote:
> Hi Ben,
> 
> I need to get back to this old discussion. I didn't resend this patch
> last year, because I tried to figure out how to solve the memory leaks
> you mentioned.
> 
> On Thu, 2019-01-17 at 10:59 +0100, Martin Wilck wrote:
> > On Wed, 2019-01-16 at 17:40 -0600, Benjamin Marzinski wrote:
> > > On Fri, Jan 04, 2019 at 06:59:12PM +0100, Martin Wilck wrote:
> > > > Cancel the other threads before taking vecs->lock. This avoids
> > > > delays during shutdown caused e.g. by the checker thread holding
> > > > the vecs lock.
> > > 
> > > Before this change, multipathd was guaranteed that once a thread
> > > had
> > > locked the vecs lock, and checked if it had been cancelled, it
> > > could
> > > not
> > > be cancelled after that until it unlocked the vecs lock.  Undoing
> > > this
> > > guarantee will likely make it possible for multipathd to leak
> > > memory
> > > where it wasn't possible before. 
> > 
> > Thanks for pointing that out.
> > 
> > I wasn't aware of this guarantee. In my latest valgrind tests,
> > valgrind
> > reported no leaks, but multipathd was also not "clean" in the sense
> > that every chunk of memory malloc()d had been explicitly free()d at
> > exit. IIRC that hadn't been caused by any patches added recently.
> > I haven't had time to look at that further, I was satisfied with no
> > real leaks being reported.
> > 
> > We do free the global data structures in "vecs" when we exit. So any
> > possible leaks caused by this patch must be cases where temporary
> > memory is allocated without proper pthread_cleanup_push(), or where a
> > thread was cancelled between allocation of memory and setting a
> > reference to it in the global data structures - e.g. between
> > allocation
> > of a path and adding it to vecs->pathvec.
> > 
> > I haven't audited either class of leaks. I believe the first class
> > should have been eliminated by earlier phthread_cancel audits. Fixing
> > the second class would require designing some really clever helpers,
> > I
> > guess. But as argued above, I really don't think it matters much if
> > it
> > concerns only leaks-at-shutdown.
> > 
> > I'll put this on my todo list, but not at the highest prio.
> > For this RFC, we need to decide whether it's more important to be
> > leak-
> > free on shutdown, or to react quickly on shutdown requests.
> 
> Last year, I had started looking into this, and produced a first patch,
> bca3729 ("libmultipath: alias.c: prepare for cancel-safe allocation").
> I've just revisited this. I think what I did back then was broken.
> 
>  out:
> +       pthread_cleanup_push(free, alias);
>         fclose(f);
> +       pthread_cleanup_pop(0);
> 
> 
> is confusing and hard to read. When I just saw it, several months after
> having written it myself, I thought it was a bug. Actually, it *is*
> broken, as you pointed out already in 
> https://www.redhat.com/archives/dm-devel/2019-October/msg00211.html,
> because we need to avoid leaking the fd, too.
> 
> How would code look like that would protect both from the memory and fd
> leak due to cancellation? Maybe like this:
> 
> char *get_user_friendly_alias(...)
> {
>         char *alias = NULL;
>         ...
> 
>         /* simplified, we need a wrapper for fclose */
> 	pthread_cleanup_push(fclose, f);
> 
> 	id = lookup_binding(f, wwid, &alias, prefix);
> 	if (id < 0)
>                 goto out_fclose;
> 
> 	pthread_cleanup_push(free, alias);
> 	if (fflush(f) != 0) {
> 		condlog(0, "cannot fflush bindings file stream : %s",
> 			strerror(errno));
> 		free(alias);
> 		alias = NULL;
>                 goto out_free;
> 	} else if (can_write && !bindings_read_only && !alias)
> 		alias = allocate_binding(fd, wwid, id, prefix);
> 
> out_free:
>         /* This is necessary to preserve nesting */
> 	pthread_cleanup_pop(0); /* free */
> out_fclose:
> 	pthread_cleanup_pop(0); /* fclose */
>         /* This is necessary because fclose() is a cancellation point */
> 	pthread_cleanup_push(free, alias);
> 	fclose(f);
> 	pthread_cleanup_pop(0); /* free */
> 
>         return alias;
> }
> 
> I hope you concur that this is awfully ugly. Everyone is invited to
> find a solution that doesn't require 3x pthread_cleanup_push()/pop(),
> without completely rewriting the code.

I assume you would do it something like:

static void free_ptr(void *arg)
{
	void *ptr;

	if (!arg)
		return

	ptr = *((void **) arg);
	if (ptr)
		free(ptr);
}

char *get_user_friendly_alias(...)
{
        char *alias = NULL;

	pthread_cleanup_push(free_ptr, &alias);
	...

	/* simplified, we need a wrapper for fclose */
	pthread_cleanup_push(fclose, f);
	...

out:
	pthread_cleanup_pop(1); /* fclose */
	pthread_cleanup_pop(0); /* free_ptr */
	return alias;
}
 
> IMO avoiding the fd leak is more important than avoiding the memory 
> leak of "alias". I'm going to submit a patch that does exactly that.
> 
> In general: I think completely avoiding memory leaks in multithreaded
> code that allows almost arbitrary cancellation is not a worthwhile
> goal. After all, except for the waiter and checker threads,
> all other threads are only cancelled when multipathd exits. Yes, this
> makes it harder to assess potential memory leaks with valgrind, because
> we can't easily distinguish real memory leaks from leaks caused by
> cancellation. But that's about it, and I think the distinction is
> actually not that hard, because the leaks caused by cancellation would
> be sporadic, and wouldn't pile up during longer runs.
> 
> So, I propose not to go further in this direction. IOW, we shouldn't
> write code like bca3729 any more. We don't have to avoid it at all cost
> (for example, it's always good to link allocated memory to some global
> data structure as soon as it makes sense to do so). But I think that
> "pthread_cleanup_push(free, xyz)" is often not worth the code
> uglification it causes. If it conflicts with other cleanup actions, and
> can't be cleanly nested like above, we should definitely not do it.

Sure. For threads that are only cancelled for shutdown, I'm fine with
reasonable effort, balanced against other code considerations.
 
> Moreover, I believe that reacting quickly on cancellation / exit
> requests is more important than avoiding cancellation-caused memory
> leaks. Therefore I plan to resend the "cancel threads early" patch,
> unless you come up with more strong reasons not to do so.

go ahead.

> Another possibility to "fix" cancellation issues and get rid of ugly
> pthread_cleanup_push() calls would be changing our cancellation policy
> to PTHREAD_CANCEL_DISABLE, and check for cancellation only at certain
> points during runtime (basically, before and after blocking / waiting
> on something). But I don't think that's going to work well, for the
> same reason - we'd run high risk to get those multipathd shutdown
> issues back which we've overcome only recently.

I'm not a fan either. I'd rather deal with occasionally seeing fake
memory leaks.

-Ben

> Thoughts?
> 
> Martin
> 
> 
> 
