From: "Benjamin Marzinski" <bmarzins@redhat.com>
Subject: Re: [PATCH 1/7] multipath: fix tur checker locking
Date: Thu, 8 Feb 2018 11:52:05 -0600
Message-ID: <20180208175205.GQ14513@octiron.msp.redhat.com>
References: <1518043787-7066-1-git-send-email-bmarzins@redhat.com>
	<1518043787-7066-2-git-send-email-bmarzins@redhat.com>
	<1518079760.15245.39.camel@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <1518079760.15245.39.camel@suse.com>
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
Cc: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

On Thu, Feb 08, 2018 at 09:49:20AM +0100, Martin Wilck wrote:
> Hello Ben,
> =

> On Wed, 2018-02-07 at 16:49 -0600, Benjamin Marzinski wrote:
> > Commit 6e2423fd fixed a bug where the tur checker could cancel a
> > detached thread after it had exitted. However in fixing this, the new
> > code grabbed a mutex (to call condlog) while holding a spin_lock. To
> > deal with that, and to try to keep with the maixim "lock data, not
> > code", I've changed how the tur checker synchronizes with its thread.
> =

> Hmm, if it was only for the condlog issue, it'd certainly be possible
> to find a simpler solution (just move the log message out of the spin-
> locked code). And please explain some more why your patch implements
> "lock data not code" better than what we did before - it's not obvious
> to me.

The way I view spin_locks is that they hold up a processor, so they
should only be locking a defined set of shared resources, and making
sure that they move from a defined state to another defined state
correctly.  The existing code calls pthread_cancel(),
tur_check_async_timeout(), and condlog() in the spinlock, and only
condlog() can be removed from it. While I don't believe that
pthread_cancel() and tur_check_async_timeout() can block, they certainly
don't need to be run under a spin_lock.

My code just makes sure that holders, thread, and attached are updated
atomically.

> =

> > Now, the tur checker creates joinable threads, and detaches them when
> > the thread is finished or has timed out. To track the state of the
> > threads, I've added a new variable to the checker context, ct-
> > >attached.
> =

> Hmm, again. This adds more complexity to an already complex contruct,
> because now we don't know in the first place whether the checker thread
> is joinable or detached. IMO it makes a lot of sense for the checker to
> run in detached mode right from the start. If multipathd is terminated
> while checkers are blocked, it'll have to detach these threads in the
> process of terminating - I find that a bit weird.

I'm not sure I get what's weird here. Calling pthread_cancel() and then
pthread_detach() is commonly recommended online as an alternative to
calling pthread_cancel() and then pthread_join() if you don't want to
wait for the results.

> While I didn't spot obvious errors in your patch, changing the locking
> fundamentally is always risky to some extent, and I'm not yet convinced
> that the problem you're trying to solve justifies this risk.
> =

> > When a thread starts, attached is set to 1. When the thread finishes,
> > it
> > saves the value of attached, and then zeros it out, while locked. If
> > attached was set, it detaches itself.
> =

> Why aren't you simply using pthread_attr_getdetachstate()?

I'm not sure how you would avoid races if you did this. ct->attach gets
set to 0 inside the spinlock to notify the other side that they don't
have to do the detach.  If you just check if the thread is currently
detached, without being able to atomically noitify the other side that
you are going to do the detach, what's to stop both sides from checking
at the same time and both doing the detach? Am I missing something here?
 =

> > =

> > When the tur checker gives up on a thread, it also saves and
> > decrements
> > ct->attached, while locked. At the same time it saves the value of
> > ct->thread.  If attached was set, it cancels the thread, and then
> > detaches it.
> =

> Have you thought about using uatomic_add_return(), which we have
> available anyway through liburcu?
> https://github.com/urcu/userspace-rcu/blob/master/doc/uatomic-api.md
> =

> We might actually be able to get rid of the hldr_lock altogether, which
> would solve the initial spin_lock/mutex problem without any additional
> code.

No, I haven't. I can look into that.

> Some minor remarks below,
> Regards, Martin
> =

> > So the values that are protected by the spin lock are now ct-
> > >holders,
> > ct->thread, and ct->attached. There are cases where the tur checker
> > just
> > wants to know if the thread is running. If so, its safe to simply
> > read
> > ct->thread without locking.  Also, if it knows that the thread isn't
> > running, it can freely access all of these variables. I've left the
> > locking in-place in these cases to make the static analyzers happy.
> > However I have added comments stating when the locking isn't actually
> > necessary.
> > =

> > Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
> > ---
> >  libmultipath/checkers/tur.c | 66 ++++++++++++++++++++++++++++++++---
> > ----------
> >  1 file changed, 48 insertions(+), 18 deletions(-)
> > =

> > diff --git a/libmultipath/checkers/tur.c
> > b/libmultipath/checkers/tur.c
> > index b4a5cb2..6ae9700 100644
> > --- a/libmultipath/checkers/tur.c
> > +++ b/libmultipath/checkers/tur.c
> > @@ -46,6 +46,7 @@ struct tur_checker_context {
> >  	pthread_cond_t active;
> >  	pthread_spinlock_t hldr_lock;
> >  	int holders;
> > +	int attached;
> >  	char message[CHECKER_MSG_LEN];
> >  };
> >  =

> > @@ -98,17 +99,21 @@ void libcheck_free (struct checker * c)
> >  {
> >  	if (c->context) {
> >  		struct tur_checker_context *ct =3D c->context;
> > -		int holders;
> > +		int attached, holders;
> >  		pthread_t thread;
> >  =

> >  		pthread_spin_lock(&ct->hldr_lock);
> >  		ct->holders--;
> >  		holders =3D ct->holders;
> > +		attached =3D ct->attached;
> > +		ct->attached =3D 0;
> >  		thread =3D ct->thread;
> >  		pthread_spin_unlock(&ct->hldr_lock);
> > -		if (holders)
> > +		if (attached) {
> >  			pthread_cancel(thread);
> > -		else
> > +			pthread_detach(thread);
> > +		}
> > +		if (!holders)
> >  			cleanup_context(ct);
> >  		c->context =3D NULL;
> >  	}
> > @@ -218,15 +223,21 @@ retry:
> >  =

> >  static void cleanup_func(void *data)
> >  {
> > -	int holders;
> > +	int attached, holders;
> > +	pthread_t thread;
> >  	struct tur_checker_context *ct =3D data;
> >  	pthread_spin_lock(&ct->hldr_lock);
> >  	ct->holders--;
> >  	holders =3D ct->holders;
> > +	attached =3D ct->attached;
> > +	ct->attached =3D 0;
> > +	thread =3D ct->thread;
> >  	ct->thread =3D 0;
> >  	pthread_spin_unlock(&ct->hldr_lock);
> >  	if (!holders)
> >  		cleanup_context(ct);
> > +	if (attached)
> > +		pthread_detach(thread);
> >  }
> >  =

> >  static int tur_running(struct tur_checker_context *ct)
> > @@ -324,7 +335,8 @@ int libcheck_check(struct checker * c)
> >  	pthread_attr_t attr;
> >  	int tur_status, r;
> >  	char devt[32];
> > -
> > +	pthread_t thread;
> > +	int timed_out, attached;
> >  =

> >  	if (!ct)
> >  		return PATH_UNCHECKED;
> > @@ -350,18 +362,27 @@ int libcheck_check(struct checker * c)
> >  	}
> >  =

> >  	if (ct->running) {
> > -		/*
> > -		 * Check if TUR checker is still running. Hold
> > hldr_lock
> > -		 * around the pthread_cancel() call to avoid that
> > -		 * pthread_cancel() gets called after the (detached)
> > TUR
> > -		 * thread has exited.
> > -		 */
> > -		pthread_spin_lock(&ct->hldr_lock);
> > -		if (ct->thread) {
> > -			if (tur_check_async_timeout(c)) {
> > +		timed_out =3D tur_check_async_timeout(c);
> > +		if (timed_out) {
> > +			pthread_spin_lock(&ct->hldr_lock);
> > +			attached =3D ct->attached;
> > +			ct->attached =3D 0;
> > +			thread =3D ct->thread;
> > +			pthread_spin_unlock(&ct->hldr_lock);
> > +			if (attached) {
> > +				pthread_cancel(thread);
> > +				pthread_detach(thread);
> > +			}
> > +		} else {
> > +			/* locking here solely to make static
> > analyzers happy */
> =

> Out of curiosity: which analyzers have you been using?

You would have to ask Bart, who I forgot to CC on this patch. He added
the code to always read ct->thread in a spin_lock, and said it was to
make an analyzer happy.
 =

> > +			pthread_spin_lock(&ct->hldr_lock);
> > +			thread =3D ct->thread;
> > +			pthread_spin_unlock(&ct->hldr_lock);
> > +		}
> > +		if (thread) {
> > +			if (timed_out) {
> >  				condlog(3, "%s: tur checker
> > timeout",
> >  					tur_devt(devt, sizeof(devt),
> > ct));
> > -				pthread_cancel(ct->thread);
> >  				ct->running =3D 0;
> >  				MSG(c, MSG_TUR_TIMEOUT);
> >  				tur_status =3D PATH_TIMEOUT;
> > @@ -377,9 +398,13 @@ int libcheck_check(struct checker * c)
> >  			tur_status =3D ct->state;
> >  			strlcpy(c->message, ct->message, sizeof(c-
> > >message));
> >  		}
> > -		pthread_spin_unlock(&ct->hldr_lock);
> >  		pthread_mutex_unlock(&ct->lock);
> >  	} else {
> > +		/*
> > +		 * locking is necessary here, so that we know that
> > the
> > +		 * thread finished all access to the context before
> > we
> > +		 * delare it not running
> > +		 */
> >  		if (tur_running(ct)) {
> >  			/* pthread cancel failed. continue in sync
> > mode */
> >  			pthread_mutex_unlock(&ct->lock);
> > @@ -391,19 +416,23 @@ int libcheck_check(struct checker * c)
> >  		ct->state =3D PATH_UNCHECKED;
> >  		ct->fd =3D c->fd;
> >  		ct->timeout =3D c->timeout;
> > +		/* locking here solely to make static analyzers
> > happy */
> >  		pthread_spin_lock(&ct->hldr_lock);
> >  		ct->holders++;
> > +		ct->attached =3D 1;
> >  		pthread_spin_unlock(&ct->hldr_lock);
> >  		tur_set_async_timeout(c);
> > -		setup_thread_attr(&attr, 32 * 1024, 1);
> > +		setup_thread_attr(&attr, 32 * 1024, 0);
> >  		r =3D pthread_create(&ct->thread, &attr, tur_thread,
> > ct);
> >  		pthread_attr_destroy(&attr);
> >  		if (r) {
> > +			/* locking here solely to make static
> > analyzers happy */
> >  			pthread_spin_lock(&ct->hldr_lock);
> >  			ct->holders--;
> > +			ct->attached =3D 0;
> > +			ct->thread =3D 0;
> >  			pthread_spin_unlock(&ct->hldr_lock);
> >  			pthread_mutex_unlock(&ct->lock);
> > -			ct->thread =3D 0;
> >  			condlog(3, "%s: failed to start tur thread, =

> =

> This part (moving ct->thread =3D0 into the cricital section) is a bug
> fix.

Well, we've already determined that another thread wasn't running, and
then we failed to start a new thread, so really all the locking here is
unnecessary, but I agree that we should either lock all the variables or
none of them.

> =

> > using"
> >  				" sync mode", tur_devt(devt,
> > sizeof(devt), ct));
> >  			return tur_check(c->fd, c->timeout,
> > @@ -414,6 +443,7 @@ int libcheck_check(struct checker * c)
> >  		tur_status =3D ct->state;
> >  		strlcpy(c->message, ct->message, sizeof(c-
> > >message));
> >  		pthread_mutex_unlock(&ct->lock);
> > +		/* locking here solely to make static analyzers
> > happy */
> >  		if (tur_running(ct) &&
> >  		    (tur_status =3D=3D PATH_PENDING || tur_status =3D=3D
> > PATH_UNCHECKED)) {
> >  			condlog(3, "%s: tur checker still running",
> =

> -- =

> Dr. Martin Wilck <mwilck@suse.com>, Tel. +49 (0)911 74053 2107
> SUSE Linux GmbH, GF: Felix Imend=F6rffer, Jane Smithard, Graham Norton
> HRB 21284 (AG N=FCrnberg)
