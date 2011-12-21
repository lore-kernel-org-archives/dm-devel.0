From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH] multipath: fix scsi async tur checker
	corruption
Date: Wed, 21 Dec 2011 09:17:52 +0100
Message-ID: <4EF19630.4020709@suse.de>
References: <20111220230130.GB17034@ether.msp.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20111220230130.GB17034@ether.msp.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: dm-devel@redhat.com
List-Id: dm-devel.ids

On 12/21/2011 12:01 AM, Benjamin Marzinski wrote:
> Since the tur checker runs asynchronously in its own thread, there is not=
hing
> that keeps a path from being orphaned or deleted before the tur thread has
> finished. When this happenes the checker struct gets deleted.  However, t=
he tur
> thread might still we writing to that memory.  This can lead to memory
> corruption.  This patch adds all of the necessary data to the checker con=
text,
> and makes the tur thread only use that. This way, if the checker is delet=
ed
> while the thread is still using the context, the thread will clean up the
> context itself.
> =

> Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
> ---
>  libmultipath/checkers/tur.c |   85 +++++++++++++++++++++++++++++++++----=
-------
>  libmultipath/discovery.c    |    1 =

>  2 files changed, 65 insertions(+), 21 deletions(-)
> =

> Index: multipath-tools-111219/libmultipath/checkers/tur.c
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> --- multipath-tools-111219.orig/libmultipath/checkers/tur.c
> +++ multipath-tools-111219/libmultipath/checkers/tur.c
> @@ -35,10 +35,15 @@ struct tur_checker_context {
>  	dev_t devt;
>  	int state;
>  	int running;
> -	time_t timeout;
> +	int fd;
> +	unsigned int timeout;
> +	time_t time;
>  	pthread_t thread;
>  	pthread_mutex_t lock;
>  	pthread_cond_t active;
> +	pthread_spinlock_t hldr_lock;
> +	int holders;
> +	char message[CHECKER_MSG_LEN];
>  };
>  =

>  #define TUR_DEVT(c) major((c)->devt), minor((c)->devt)
> @@ -53,28 +58,49 @@ int libcheck_init (struct checker * c)
>  	memset(ct, 0, sizeof(struct tur_checker_context));
>  =

>  	ct->state =3D PATH_UNCHECKED;
> +	ct->fd =3D -1;
> +	ct->holders =3D 1;
>  	pthread_cond_init(&ct->active, NULL);
>  	pthread_mutex_init(&ct->lock, NULL);
> +	pthread_spin_init(&ct->hldr_lock, PTHREAD_PROCESS_PRIVATE);
>  	c->context =3D ct;
>  =

>  	return 0;
>  }
>  =

> +void cleanup_context(struct tur_checker_context *ct)
> +{
> +	pthread_mutex_destroy(&ct->lock);
> +	pthread_cond_destroy(&ct->active);
> +	pthread_spin_destroy(&ct->hldr_lock);
> +	free(ct);
> +}
> +
>  void libcheck_free (struct checker * c)
>  {
>  	if (c->context) {
>  		struct tur_checker_context *ct =3D c->context;
> +		int holders;
> +		pthread_t thread;
>  =

> -		pthread_mutex_destroy(&ct->lock);
> -		pthread_cond_destroy(&ct->active);
> -		free(c->context);
> +		pthread_spin_lock(&ct->hldr_lock);
> +		ct->holders--;
> +		holders =3D ct->holders;
> +		thread =3D ct->thread;
> +		pthread_spin_unlock(&ct->hldr_lock);
> +		if (holders)
> +			pthread_cancel(thread);
> +		else
> +			cleanup_context(ct);
>  		c->context =3D NULL;
>  	}
>  	return;
>  }
>  =

> +#define TUR_MSG(msg, fmt, args...) snprintf(msg, CHECKER_MSG_LEN, fmt, #=
#args);
> +
>  int
> -tur_check (struct checker * c)
> +tur_check(int fd, unsigned int timeout, char *msg)
>  {
>  	struct sg_io_hdr io_hdr;
>  	unsigned char turCmdBlk[TUR_CMD_LEN] =3D { 0x00, 0, 0, 0, 0, 0 };
> @@ -90,10 +116,10 @@ tur_check (struct checker * c)
>  	io_hdr.dxfer_direction =3D SG_DXFER_NONE;
>  	io_hdr.cmdp =3D turCmdBlk;
>  	io_hdr.sbp =3D sense_buffer;
> -	io_hdr.timeout =3D c->timeout;
> +	io_hdr.timeout =3D timeout;
>  	io_hdr.pack_id =3D 0;
> -	if (ioctl(c->fd, SG_IO, &io_hdr) < 0) {
> -		MSG(c, MSG_TUR_DOWN);
> +	if (ioctl(fd, SG_IO, &io_hdr) < 0) {
> +		TUR_MSG(msg, MSG_TUR_DOWN);
>  		return PATH_DOWN;
>  	}
>  	if ((io_hdr.status & 0x7e) =3D=3D 0x18) {
> @@ -101,7 +127,7 @@ tur_check (struct checker * c)
>  		 * SCSI-3 arrays might return
>  		 * reservation conflict on TUR
>  		 */
> -		MSG(c, MSG_TUR_UP);
> +		TUR_MSG(msg, MSG_TUR_UP);
>  		return PATH_UP;
>  	}
>  	if (io_hdr.info & SG_INFO_OK_MASK) {
> @@ -146,14 +172,14 @@ tur_check (struct checker * c)
>  				 * LOGICAL UNIT NOT ACCESSIBLE,
>  				 * TARGET PORT IN STANDBY STATE
>  				 */
> -				MSG(c, MSG_TUR_GHOST);
> +				TUR_MSG(msg, MSG_TUR_GHOST);
>  				return PATH_GHOST;
>  			}
>  		}
> -		MSG(c, MSG_TUR_DOWN);
> +		TUR_MSG(msg, MSG_TUR_DOWN);
>  		return PATH_DOWN;
>  	}
> -	MSG(c, MSG_TUR_UP);
> +	TUR_MSG(msg, MSG_TUR_UP);
>  	return PATH_UP;
>  }
>  =

> @@ -162,18 +188,25 @@ tur_check (struct checker * c)
>  =

>  void cleanup_func(void *data)
>  {
> +	int holders;
>  	struct tur_checker_context *ct =3D data;
> +	pthread_spin_lock(&ct->hldr_lock);
> +	ct->holders--;
> +	holders =3D ct->holders;
>  	ct->thread =3D 0;
> +	pthread_spin_unlock(&ct->hldr_lock);
> +	if (!holders)
> +		cleanup_context(ct);
>  }
>  =

>  void *tur_thread(void *ctx)
>  {
> -	struct checker *c =3D ctx;
> -	struct tur_checker_context *ct =3D c->context;
> +	struct tur_checker_context *ct =3D ctx;
>  	int state;
>  =

>  	condlog(3, "%d:%d: tur checker starting up", TUR_DEVT(ct));
>  =

> +	ct->message[0] =3D '\0';
>  	/* This thread can be canceled, so setup clean up */
>  	tur_thread_cleanup_push(ct)
>  =

> @@ -182,7 +215,7 @@ void *tur_thread(void *ctx)
>  	ct->state =3D PATH_PENDING;
>  	pthread_mutex_unlock(&ct->lock);
>  =

> -	state =3D tur_check(c);
> +	state =3D tur_check(ct->fd, ct->timeout, ct->message);
>  =

>  	/* TUR checker done */
>  	pthread_mutex_lock(&ct->lock);
> @@ -213,7 +246,7 @@ void tur_set_async_timeout(struct checke
>  	struct timeval now;
>  =

>  	gettimeofday(&now, NULL);
> -	ct->timeout =3D now.tv_sec + c->timeout;
> +	ct->time =3D now.tv_sec + c->timeout;
>  }
>  =

>  int tur_check_async_timeout(struct checker *c)
> @@ -222,7 +255,7 @@ int tur_check_async_timeout(struct check
>  	struct timeval now;
>  =

>  	gettimeofday(&now, NULL);
> -	return (now.tv_sec > ct->timeout);
> +	return (now.tv_sec > ct->time);
>  }
>  =

>  extern int
> @@ -242,7 +275,7 @@ libcheck_check (struct checker * c)
>  		ct->devt =3D sb.st_rdev;
>  =

>  	if (c->sync)
> -		return tur_check(c);
> +		return tur_check(c->fd, c->timeout, c->message);
>  =

>  	/*
>  	 * Async mode
> @@ -276,6 +309,8 @@ libcheck_check (struct checker * c)
>  			/* TUR checker done */
>  			ct->running =3D 0;
>  			tur_status =3D ct->state;
> +			strncpy(c->message, ct->message, CHECKER_MSG_LEN);
> +			c->message[CHECKER_MSG_LEN - 1] =3D '\0';
>  		}
>  		pthread_mutex_unlock(&ct->lock);
>  	} else {
> @@ -284,24 +319,32 @@ libcheck_check (struct checker * c)
>  			pthread_mutex_unlock(&ct->lock);
>  			condlog(3, "%d:%d: tur thread not responding, "
>  				"using sync mode", TUR_DEVT(ct));
> -			return tur_check(c);
> +			return tur_check(c->fd, c->timeout, c->message);
>  		}
>  		/* Start new TUR checker */
>  		ct->state =3D PATH_UNCHECKED;
> +		ct->fd =3D c->fd;
> +		ct->timeout =3D c->timeout;
> +		pthread_spin_lock(&ct->hldr_lock);
> +		ct->holders++;
> +		pthread_spin_unlock(&ct->hldr_lock);
>  		tur_set_async_timeout(c);
>  		setup_thread_attr(&attr, 32 * 1024, 1);
> -		r =3D pthread_create(&ct->thread, &attr, tur_thread, c);
> +		r =3D pthread_create(&ct->thread, &attr, tur_thread, ct);
>  		if (r) {
>  			pthread_mutex_unlock(&ct->lock);
>  			ct->thread =3D 0;
> +			ct->holders--;
>  			condlog(3, "%d:%d: failed to start tur thread, using"
>  				" sync mode", TUR_DEVT(ct));
> -			return tur_check(c);
> +			return tur_check(c->fd, c->timeout, c->message);
>  		}
>  		pthread_attr_destroy(&attr);
>  		tur_timeout(&tsp);
>  		r =3D pthread_cond_timedwait(&ct->active, &ct->lock, &tsp);
>  		tur_status =3D ct->state;
> +		strncpy(c->message, ct->message,CHECKER_MSG_LEN);
> +		c->message[CHECKER_MSG_LEN -1] =3D '\0';
>  		pthread_mutex_unlock(&ct->lock);
>  		if (ct->thread &&
>  		    (tur_status =3D=3D PATH_PENDING || tur_status =3D=3D PATH_UNCHECKE=
D)) {
> Index: multipath-tools-111219/libmultipath/discovery.c
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> --- multipath-tools-111219.orig/libmultipath/discovery.c
> +++ multipath-tools-111219/libmultipath/discovery.c
> @@ -826,6 +826,7 @@ get_state (struct path * pp, int daemon)
>  		}
>  		checker_set_fd(c, pp->fd);
>  		if (checker_init(c, pp->mpp?&pp->mpp->mpcontext:NULL)) {
> +			memset(c, 0x0, sizeof(struct checker));
>  			condlog(3, "%s: checker init failed", pp->dev);
>  			return PATH_UNCHECKED;
>  		}
> =

Hmm. Why do we need ->holders here?
In theory we can have only two states; async thread running or no
thread running. I really cannot imagine a scenario where ->holders
would be > 1.
Or, to stress the point a bit more, any scenario where holders > 1
would most definitely be a bug, as this would indicate that an async
tur thread is running, but we somehow failed to notice this, and
started a new one. Which means we end with two threads doing exactly
the same thing. And which was _exactly_ what we want to avoid with
at startup.
So I guess we can do away with ->holders.
And once ->holders is gone, I doubt it'll make any sense to retain
the spinlock, as we then just have ->thread to worry about.
And this doesn't need to be spinlock protected, as we take care to
synchronize during startup. And during shutdown we simply don't
care, as pthread_cancel() will return an error if the thread is
already done for.

Cheers,

Hannes
-- =

Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: J. Hawn, J. Guild, F. Imend=F6rffer, HRB 16746 (AG N=FCrnberg)
