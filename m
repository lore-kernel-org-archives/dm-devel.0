From: "Benjamin Marzinski" <bmarzins@redhat.com>
Subject: Re: [PATCH 1/3] multipathd: fix waiter thread cancelling
Date: Mon, 19 Mar 2018 11:25:55 -0500
Message-ID: <20180319162555.GK14513@octiron.msp.redhat.com>
References: <1521235867-29476-1-git-send-email-bmarzins@redhat.com>
	<1521235867-29476-2-git-send-email-bmarzins@redhat.com>
	<1521464364.3798.48.camel@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <1521464364.3798.48.camel@suse.com>
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

On Mon, Mar 19, 2018 at 01:59:24PM +0100, Martin Wilck wrote:
> On Fri, 2018-03-16 at 16:31 -0500, Benjamin Marzinski wrote:
> > diff --git a/multipathd/waiter.c b/multipathd/waiter.c
> > index cb9708b..e894294 100644
> > --- a/multipathd/waiter.c
> > +++ b/multipathd/waiter.c
> > @@ -23,6 +23,7 @@
> >  #include "waiter.h"
> >  =

> >  pthread_attr_t waiter_attr;
> > +struct mutex_lock waiter_lock =3D { .mutex =3D PTHREAD_MUTEX_INITIALIZ=
ER
> > };
> >  =

> >  static struct event_thread *alloc_waiter (void)
> >  {
> > @@ -59,8 +60,12 @@ void stop_waiter_thread (struct multipath *mpp,
> > struct vectors *vecs)
> >  		mpp->waiter);
> >  	thread =3D mpp->waiter;
> >  	mpp->waiter =3D (pthread_t)0;
> > -	pthread_cancel(thread);
> > +	pthread_cleanup_push(cleanup_lock, &waiter_lock);
> > +	lock(&waiter_lock);
> > +	pthread_testcancel();
> =

> What's the purpose of this pthread_testcancel() call?
> =


It's not necessary. I feel like in general, after you get done waiting
on a lock, it's good form to see if you've been cancelled while you were
waiting. However, it's really unlikely that a thread will be waiting
here long, and this pthread_cancel isn't protecting it form accessing
any freed data. If you think it's likely to confuse people, I have no
problem with removing it.

> >  	pthread_kill(thread, SIGUSR2);
> > +	pthread_cancel(thread);
> > +	lock_cleanup_pop(&waiter_lock);
> >  }
> >  =

> >  /*
> > @@ -114,8 +119,13 @@ static int waiteventloop (struct event_thread
> > *waiter)
> >  	dm_task_destroy(waiter->dmt);
> >  	waiter->dmt =3D NULL;
> >  =

> > -	if (!r)	/* wait interrupted by signal */
> > -		return -1;
> > +	if (!r)	{ /* wait interrupted by signal. check for
> > cancellation */
> > +		pthread_cleanup_push(cleanup_lock, &waiter_lock);
> > +		lock(&waiter_lock);
> > +		pthread_testcancel();
> > +		lock_cleanup_pop(&waiter_lock);
> =

> Nitpick: I'd prefer pthread_cleanup_pop(1) here.

I have no problem with changing that.

-Ben

> Regards,
> Martin
> =

> =

> > +		return 1; /* If we weren't cancelled, just
> > reschedule */
> > +	}
> >  =

> >  	waiter->event_nr++;
> >  =

> =

> -- =

> Dr. Martin Wilck <mwilck@suse.com>, Tel. +49 (0)911 74053 2107
> SUSE Linux GmbH, GF: Felix Imend=F6rffer, Jane Smithard, Graham Norton
> HRB 21284 (AG N=FCrnberg)
