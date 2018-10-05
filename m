From: "Benjamin Marzinski" <bmarzins@redhat.com>
Subject: Re: [PATCH v3 01/19] libmultipath: fix tur checker
	timeout
Date: Fri, 5 Oct 2018 12:02:59 -0500
Message-ID: <20181005170259.GD3172@octiron.msp.redhat.com>
References: <1537571127-10143-1-git-send-email-bmarzins@redhat.com>
	<1537571127-10143-2-git-send-email-bmarzins@redhat.com>
	<deb772629c403acaf8c39a0e74f947a7f8b9d2bf.camel@suse.com>
	<20181004163118.GA3172@octiron.msp.redhat.com>
	<fd4fb2bec1f7b4dfa5703b2fb395a8f7bc8974bb.camel@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <fd4fb2bec1f7b4dfa5703b2fb395a8f7bc8974bb.camel@suse.com>
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
Cc: mwilck+gmail@suse.de, device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

On Fri, Oct 05, 2018 at 12:11:18PM +0200, Martin Wilck wrote:
> On Thu, 2018-10-04 at 11:31 -0500,  Benjamin Marzinski  wrote:
> > It's been a while, and I'm not exactly sure what I was thinking here.
> > But IIRC the idea was that if the state isn't set yet, then the old
> > thread could mess with the results of a future thread. Also, it was
> > to
> > avoid a corner case where the tur checker was called, started the
> > thread, got the result before the checker exitted, cancelled the
> > thread
> > and returned the result and then was called very shortly afterwards,
> > before the thread could clean itself up.  In that case, the right
> > thing
> > to do (I thought) would be to start a new thread, because the other
> > one
> > would be ending soon.  In truth, starting a new thread at all is
> > probably a bad idea, since the old thread will still mess with the
> > checker context on exit. =

> > =

> > A better idea might be to simply fail back to a syncronous call to
> > tur_check() when you notice a cancelled thread that hasn't exitted.
> > That can cause all the other checkers to get delayed, but at least in
> > that case you are still checking paths. The other option is to do as
> > before and just not check this path, which won't effect the other
> > checkers. It seems very unlikely that the thread could remain
> > uncancelled forever, especially if the path was usable.
> >
> > thoughts?
> =

> Generally speaking, we're deeply in the realm of highly unlikely
> situations I would say. But we should get it right eventually.
> =

> Maybe we can add logic to the tur thread to keep its hands off the
> context if it's a "zombie", like below (just a thought, untested)?

This still wouldn't stop a thread from racing with new thread creation
to change ct->holders or ct->running.

-Ben

> Martin
> =

> =

> diff --git a/libmultipath/checkers/tur.c b/libmultipath/checkers/tur.c
> index bf8486d3..e8493ca8 100644
> --- a/libmultipath/checkers/tur.c
> +++ b/libmultipath/checkers/tur.c
> @@ -219,11 +219,18 @@ static void cleanup_func(void *data)
>  	rcu_unregister_thread();
>  }
>  =

> +#define tur_thread_quit_unless_owner(__ct)	   \
> +	if (__ct->thread !=3D pthread_self()) {	   \
> +		pthread_mutex_unlock(&__ct->lock); \
> +		pthread_exit(NULL);		   \
> +	}
> +
>  static void copy_msg_to_tcc(void *ct_p, const char *msg)
>  {
>  	struct tur_checker_context *ct =3D ct_p;
>  =

>  	pthread_mutex_lock(&ct->lock);
> +	tur_thread_quit_unless_owner(ct);
>  	strlcpy(ct->message, msg, sizeof(ct->message));
>  	pthread_mutex_unlock(&ct->lock);
>  }
> @@ -243,6 +250,7 @@ static void *tur_thread(void *ctx)
>  =

>  	/* TUR checker start up */
>  	pthread_mutex_lock(&ct->lock);
> +	tur_thread_quit_unless_owner(ct);
>  	ct->state =3D PATH_PENDING;
>  	ct->message[0] =3D '\0';
>  	pthread_mutex_unlock(&ct->lock);
> @@ -252,6 +260,7 @@ static void *tur_thread(void *ctx)
>  =

>  	/* TUR checker done */
>  	pthread_mutex_lock(&ct->lock);
> +	tur_thread_quit_unless_owner(ct);
>  	ct->state =3D state;
>  	pthread_cond_signal(&ct->active);
>  	pthread_mutex_unlock(&ct->lock);
> =

> =

> =

> =

> -- =

> Dr. Martin Wilck <mwilck@suse.com>, Tel. +49 (0)911 74053 2107
> SUSELinux GmbH, GF: Felix Imend=F6rffer, Jane Smithard,  Graham Norton
> HRB 21284 (AG N=FCrnberg)
> =
