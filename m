From: "Benjamin Marzinski" <bmarzins@redhat.com>
Subject: Re: [PATCH v2 1/7] libmultipath: fix tur checker locking
Date: Fri, 9 Feb 2018 18:17:06 -0600
Message-ID: <20180210001706.GX14513@octiron.msp.redhat.com>
References: <1518134167-15938-1-git-send-email-bmarzins@redhat.com>
	<1518134167-15938-2-git-send-email-bmarzins@redhat.com>
	<1518208256.2937.16.camel@suse.com>
	<20180209230449.GW14513@octiron.msp.redhat.com>
	<1518218931.2937.20.camel@suse.com>
	<1518219365.2937.22.camel@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <1518219365.2937.22.camel@suse.com>
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
Cc: Bart Van Assche <Bart.VanAssche@wdc.com>, device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

On Sat, Feb 10, 2018 at 12:36:05AM +0100, Martin Wilck wrote:
> On Sat, 2018-02-10 at 00:28 +0100, Martin Wilck wrote:
> > Maybe it's easier than we thought. Attached is a patch on top of
> > yours that I think might work, please have a look. =

> > =

> =

> That one didn't even compile. This one is better.
> =

> Martin

So if we have this ordering

- checker calls uatomic_xchg() which returns 1 and then gets scheduled
- thread calls uatomic_set() and then runs till it terminates
- checker calls pthread_cancel()

You will get Bart's original bug.  I realize that having the condlog()
after the uatomic_set() in the thread makes this unlikely, but I don't
races like this. I would be happier with simply taking the original code
and moving the condlog(), if neither of my other two options are
acceptable.

-Ben

> =

> -- =

> Dr. Martin Wilck <mwilck@suse.com>, Tel. +49 (0)911 74053 2107
> SUSE Linux GmbH, GF: Felix Imend=F6rffer, Jane Smithard, Graham Norton
> HRB 21284 (AG N=FCrnberg)

> From afb9c7de3658d49c4f28f6b9ee618a87b806ecdd Mon Sep 17 00:00:00 2001
> From: Martin Wilck <mwilck@suse.com>
> Date: Sat, 10 Feb 2018 00:22:17 +0100
> Subject: [PATCH] tur checker: make sure pthread_cancel isn't called for e=
xited
>  thread
> =

> If we enter the cleanup function as the result of a pthread_cancel by ano=
ther
> thread, we don't need to wait for a cancellation any more. If we exit
> regularly, just tell the other thread not to try to cancel us.
> ---
>  libmultipath/checkers/tur.c | 9 +++++----
>  1 file changed, 5 insertions(+), 4 deletions(-)
> =

> diff --git a/libmultipath/checkers/tur.c b/libmultipath/checkers/tur.c
> index 894ad41c89c3..5d2b36bfa883 100644
> --- a/libmultipath/checkers/tur.c
> +++ b/libmultipath/checkers/tur.c
> @@ -214,15 +214,13 @@ retry:
>  =

>  static void cleanup_func(void *data)
>  {
> -	int running, holders;
> +	int holders;
>  	struct tur_checker_context *ct =3D data;
>  =

> -	running =3D uatomic_xchg(&ct->running, 0);
> +	uatomic_set(&ct->running, 0);
>  	holders =3D uatomic_sub_return(&ct->holders, 1);
>  	if (!holders)
>  		cleanup_context(ct);
> -	if (!running)
> -		pause();
>  }
>  =

>  static int tur_running(struct tur_checker_context *ct)
> @@ -266,6 +264,9 @@ static void *tur_thread(void *ctx)
>  	pthread_cond_signal(&ct->active);
>  	pthread_mutex_unlock(&ct->lock);
>  =

> +	/* Tell main checker thread not to cancel us, as we exit anyway */
> +	uatomic_set(&ct->running, 0);
> +
>  	condlog(3, "%s: tur checker finished, state %s",
>  		tur_devt(devt, sizeof(devt), ct), checker_state_name(state));
>  	tur_thread_cleanup_pop(ct);
> -- =

> 2.16.1
> =
