From: "Benjamin Marzinski" <bmarzins@redhat.com>
Subject: Re: [PATCH v3 02/19] libmultipath: fix tur checker
	double locking
Date: Thu, 4 Oct 2018 11:45:21 -0500
Message-ID: <20181004164521.GB3172@octiron.msp.redhat.com>
References: <1537571127-10143-1-git-send-email-bmarzins@redhat.com>
	<1537571127-10143-3-git-send-email-bmarzins@redhat.com>
	<3bad257069d68444b0b2743d4b38ba6b6d15501d.camel@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <3bad257069d68444b0b2743d4b38ba6b6d15501d.camel@suse.com>
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
Cc: Bart Van Assche <bart.vanassche@wdc.com>, device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

On Mon, Oct 01, 2018 at 10:09:41PM +0200, Martin Wilck wrote:
> On Fri, 2018-09-21 at 18:05 -0500, Benjamin Marzinski wrote:
> > tur_devt() locks ct->lock. However, it is ocassionally called while
> > ct->lock is already locked. In reality, there is no reason why we
> > need
> > to lock all the accesses to ct->devt. The tur checker only needs to
> > write to this variable one time, when it first gets the file
> > descripter
> > that it is checking.  It also never uses ct->devt directly. Instead,
> > it
> > always graps the major and minor, and turns them into a string. This
> > patch changes ct->devt into that string, and sets it in
> > libcheck_init()
> > when it is first initializing the checker context. After that, ct-
> > >devt
> > is only ever read.
> =

> I like the lock removal a lot, but not so much the conversion into a
> string. Why not keep the dev_t? =


Because we will simply convert it into a string every time we use it,
instead of doing the work one time. It's 24 more bytes in the
tur_checker_context, but the code is easier to read, and we're not doing
the same work again and again.

> =

> Or maybe even easier, the other way around: why don't we make it a
> char* and simply set checker->dev_t =3D &pp->dev_t?

The whole reason we have tur_checker_context->holders is that it's
possible for a path to be removed (or orphaned) while the thread is
still running. The tur_checker_context needs to keep all its own
storage, so that it never as to worry about pointing to freed memory.

-Ben

> Regards,
> Martin
> =

> > =

> > Cc: Bart Van Assche <bart.vanassche@wdc.com>4
> > Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
> > ---
> >  libmultipath/checkers/tur.c | 55 +++++++++++++--------------------
> > ------------
> >  1 file changed, 16 insertions(+), 39 deletions(-)
> > =

> > diff --git a/libmultipath/checkers/tur.c
> > b/libmultipath/checkers/tur.c
> > index 275541f..d173648 100644
> > --- a/libmultipath/checkers/tur.c
> > +++ b/libmultipath/checkers/tur.c
> > @@ -37,36 +37,24 @@
> >  #define MSG_TUR_FAILED	"tur checker failed to initialize"
> >  =

> >  struct tur_checker_context {
> > -	dev_t devt;
> > +	char devt[32];
> >  	int state;
> > -	int running;
> > +	int running; /* uatomic access only */
> >  	int fd;
> >  	unsigned int timeout;
> >  	time_t time;
> >  	pthread_t thread;
> >  	pthread_mutex_t lock;
> >  	pthread_cond_t active;
> > -	int holders;
> > +	int holders; /* uatomic access only */
> >  	char message[CHECKER_MSG_LEN];
> >  };
> >  =

> > -static const char *tur_devt(char *devt_buf, int size,
> > -			    struct tur_checker_context *ct)
> > -{
> > -	dev_t devt;
> > -
> > -	pthread_mutex_lock(&ct->lock);
> > -	devt =3D ct->devt;
> > -	pthread_mutex_unlock(&ct->lock);
> > -
> > -	snprintf(devt_buf, size, "%d:%d", major(devt), minor(devt));
> > -	return devt_buf;
> > -}
> > -
> >  int libcheck_init (struct checker * c)
> >  {
> >  	struct tur_checker_context *ct;
> >  	pthread_mutexattr_t attr;
> > +	struct stat sb;
> >  =

> >  	ct =3D malloc(sizeof(struct tur_checker_context));
> >  	if (!ct)
> > @@ -81,6 +69,9 @@ int libcheck_init (struct checker * c)
> >  	pthread_mutexattr_settype(&attr, PTHREAD_MUTEX_RECURSIVE);
> >  	pthread_mutex_init(&ct->lock, &attr);
> >  	pthread_mutexattr_destroy(&attr);
> > +	if (fstat(c->fd, &sb) =3D=3D 0)
> > +		snprintf(ct->devt, sizeof(ct->devt), "%d:%d",
> > major(sb.st_rdev),
> > +			 minor(sb.st_rdev));
> >  	c->context =3D ct;
> >  =

> >  	return 0;
> > @@ -232,14 +223,12 @@ static void *tur_thread(void *ctx)
> >  {
> >  	struct tur_checker_context *ct =3D ctx;
> >  	int state, running;
> > -	char devt[32];
> >  =

> >  	/* This thread can be canceled, so setup clean up */
> >  	tur_thread_cleanup_push(ct);
> >  	rcu_register_thread();
> >  =

> > -	condlog(3, "%s: tur checker starting up",
> > -		tur_devt(devt, sizeof(devt), ct));
> > +	condlog(3, "%s: tur checker starting up", ct->devt);
> >  =

> >  	/* TUR checker start up */
> >  	pthread_mutex_lock(&ct->lock);
> > @@ -256,8 +245,8 @@ static void *tur_thread(void *ctx)
> >  	pthread_cond_signal(&ct->active);
> >  	pthread_mutex_unlock(&ct->lock);
> >  =

> > -	condlog(3, "%s: tur checker finished, state %s",
> > -		tur_devt(devt, sizeof(devt), ct),
> > checker_state_name(state));
> > +	condlog(3, "%s: tur checker finished, state %s", ct->devt,
> > +		checker_state_name(state));
> >  =

> >  	running =3D uatomic_xchg(&ct->running, 0);
> >  	if (!running)
> > @@ -305,20 +294,12 @@ int libcheck_check(struct checker * c)
> >  {
> >  	struct tur_checker_context *ct =3D c->context;
> >  	struct timespec tsp;
> > -	struct stat sb;
> >  	pthread_attr_t attr;
> >  	int tur_status, r;
> > -	char devt[32];
> >  =

> >  	if (!ct)
> >  		return PATH_UNCHECKED;
> >  =

> > -	if (fstat(c->fd, &sb) =3D=3D 0) {
> > -		pthread_mutex_lock(&ct->lock);
> > -		ct->devt =3D sb.st_rdev;
> > -		pthread_mutex_unlock(&ct->lock);
> > -	}
> > -
> >  	if (c->sync)
> >  		return tur_check(c->fd, c->timeout,
> > copy_msg_to_checker, c);
> >  =

> > @@ -327,8 +308,7 @@ int libcheck_check(struct checker * c)
> >  	 */
> >  	r =3D pthread_mutex_lock(&ct->lock);
> >  	if (r !=3D 0) {
> > -		condlog(2, "%s: tur mutex lock failed with %d",
> > -			tur_devt(devt, sizeof(devt), ct), r);
> > +		condlog(2, "%s: tur mutex lock failed with %d", ct-
> > >devt, r);
> >  		MSG(c, MSG_TUR_FAILED);
> >  		return PATH_WILD;
> >  	}
> > @@ -338,14 +318,12 @@ int libcheck_check(struct checker * c)
> >  			int running =3D uatomic_xchg(&ct->running, 0);
> >  			if (running)
> >  				pthread_cancel(ct->thread);
> > -			condlog(3, "%s: tur checker timeout",
> > -				tur_devt(devt, sizeof(devt), ct));
> > +			condlog(3, "%s: tur checker timeout", ct-
> > >devt);
> >  			ct->thread =3D 0;
> >  			MSG(c, MSG_TUR_TIMEOUT);
> >  			tur_status =3D PATH_TIMEOUT;
> >  		} else if (uatomic_read(&ct->running) !=3D 0) {
> > -			condlog(3, "%s: tur checker not finished",
> > -					tur_devt(devt, sizeof(devt),
> > ct));
> > +			condlog(3, "%s: tur checker not finished", ct-
> > >devt);
> >  			tur_status =3D PATH_PENDING;
> >  		} else {
> >  			/* TUR checker done */
> > @@ -361,7 +339,7 @@ int libcheck_check(struct checker * c)
> >  			if (ct->state =3D=3D PATH_PENDING) {
> >  				pthread_mutex_unlock(&ct->lock);
> >  				condlog(3, "%s: tur thread not
> > responding",
> > -					tur_devt(devt, sizeof(devt),
> > ct));
> > +					ct->devt);
> >  				return PATH_TIMEOUT;
> >  			}
> >  		}
> > @@ -381,7 +359,7 @@ int libcheck_check(struct checker * c)
> >  			ct->thread =3D 0;
> >  			pthread_mutex_unlock(&ct->lock);
> >  			condlog(3, "%s: failed to start tur thread,
> > using"
> > -				" sync mode", tur_devt(devt,
> > sizeof(devt), ct));
> > +				" sync mode", ct->devt);
> >  			return tur_check(c->fd, c->timeout,
> >  					 copy_msg_to_checker, c);
> >  		}
> > @@ -392,8 +370,7 @@ int libcheck_check(struct checker * c)
> >  		pthread_mutex_unlock(&ct->lock);
> >  		if (uatomic_read(&ct->running) !=3D 0 &&
> >  		    (tur_status =3D=3D PATH_PENDING || tur_status =3D=3D
> > PATH_UNCHECKED)) {
> > -			condlog(3, "%s: tur checker still running",
> > -				tur_devt(devt, sizeof(devt), ct));
> > +			condlog(3, "%s: tur checker still running", ct-
> > >devt);
> >  			tur_status =3D PATH_PENDING;
> >  		} else {
> >  			int running =3D uatomic_xchg(&ct->running, 0);
> =

> -- =

> Dr. Martin Wilck <mwilck@suse.com>, Tel. +49 (0)911 74053 2107
> SUSE Linux GmbH, GF: Felix Imend=F6rffer, Jane Smithard, Graham Norton
> HRB 21284 (AG N=FCrnberg)
> =
