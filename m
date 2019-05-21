From: Benjamin Marzinski <bmarzins@redhat.com>
Subject: Re: [PATCH 1/4] libmultipath: handle clock_gettime
 failures in tur checker
Date: Mon, 20 May 2019 20:02:38 -0500
Message-ID: <20190521010238.GI3090@octiron.msp.redhat.com>
References: <1558109650-21179-1-git-send-email-bmarzins@redhat.com>
	<1558109650-21179-2-git-send-email-bmarzins@redhat.com>
	<a7b173c7139bd43fa950a85e39104b68f04ee101.camel@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <a7b173c7139bd43fa950a85e39104b68f04ee101.camel@suse.de>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Martin Wilck <mwilck@suse.de>
Cc: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

On Fri, May 17, 2019 at 11:55:48PM +0200, Martin Wilck wrote:
> On Fri, 2019-05-17 at 11:14 -0500, Benjamin Marzinski wrote:
> > If clock_gettime() fails, and multipathd can't figure out when it
> > should
> > time out, it should just default to assuming that it has already
> > timed
> > out. Found by coverity.
> > 
> > Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
> > ---
> >  libmultipath/checkers/tur.c | 19 +++++++++++++++----
> >  1 file changed, 15 insertions(+), 4 deletions(-)
> 
> I know coverity picks on this, but I don't like the result. It's
> superfluous IMO, and uglifies the code. 
> 
> Other than passing an invalid address (unlikely because basically every
> caller uses memory from the stack), the only possible reason for
> failure in clock_gettime is "EINVAL - The clk_id specified is not
> supported on this system".
> 
> We have this code in pthread_cond_init_mono():
> 
> 	res = pthread_condattr_setclock(&attr, CLOCK_MONOTONIC);
> 	assert(res == 0);
> 
> this is called when initializing config_cond. So multipathd at least
> won't even start if CLOCK_MONOTONIC is unsupported.
> 
> If that's not enough, I don't mind putting such a check in
> mpath_lib_init() and refuse to start on systems without
> CLOCK_MONOTONIC, then stop bothering with the return value of
> clock_gettime() in the rest of the code.
> 
> Regards,
> Martin

I'm fine with dropping this one. We just have so many other checks for
the return on this call that I thought that there was possibly some
important error condition that the man page didn't mention.

I'll repost the set without it.

-Ben

> 
> 
> > diff --git a/libmultipath/checkers/tur.c
> > b/libmultipath/checkers/tur.c
> > index 6b08dbbb..717353ef 100644
> > --- a/libmultipath/checkers/tur.c
> > +++ b/libmultipath/checkers/tur.c
> > @@ -290,7 +290,12 @@ static void *tur_thread(void *ctx)
> >  
> >  static void tur_timeout(struct timespec *tsp)
> >  {
> > -	clock_gettime(CLOCK_MONOTONIC, tsp);
> > +	if (clock_gettime(CLOCK_MONOTONIC, tsp) != 0) {
> > +		/* can't get time. clear tsp to not wait */
> > +		tsp->tv_sec = 0;
> > +		tsp->tv_nsec = 0;
> > +		return;
> > +	}
> >  	tsp->tv_nsec += 1000 * 1000; /* 1 millisecond */
> >  	normalize_timespec(tsp);
> >  }
> > @@ -300,8 +305,12 @@ static void tur_set_async_timeout(struct checker
> > *c)
> >  	struct tur_checker_context *ct = c->context;
> >  	struct timespec now;
> >  
> > -	clock_gettime(CLOCK_MONOTONIC, &now);
> > -	ct->time = now.tv_sec + c->timeout;
> > +	if (clock_gettime(CLOCK_MONOTONIC, &now) != 0)
> > +		/* can't get time. clear time to always timeout on
> > +		 * next path check */
> > +		ct->time = 0;
> > +	else
> > +		ct->time = now.tv_sec + c->timeout;
> >  }
> >  
> >  static int tur_check_async_timeout(struct checker *c)
> > @@ -309,7 +318,9 @@ static int tur_check_async_timeout(struct checker
> > *c)
> >  	struct tur_checker_context *ct = c->context;
> >  	struct timespec now;
> >  
> > -	clock_gettime(CLOCK_MONOTONIC, &now);
> > +	if (clock_gettime(CLOCK_MONOTONIC, &now) != 0)
> > +		/* can't get time. assume we've timed out */
> > +		return 1;
> >  	return (now.tv_sec > ct->time);
> >  }
> >  
> 
