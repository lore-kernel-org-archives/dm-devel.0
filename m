From: Benjamin Marzinski <bmarzins@redhat.com>
Subject: Re: [PATCH 1/4] multipathd: avoid null pointer
 dereference in LOG_MSG\
Date: Fri, 8 Feb 2019 11:28:54 -0600
Message-ID: <20190208172854.GN11315@octiron.msp.redhat.com>
References: <20190207235302.21635-1-bmarzins@redhat.com>
	<20190207235302.21635-2-bmarzins@redhat.com>
	<e59bbe5e705b02b80d799bb4f4582af34be1dfbb.camel@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <e59bbe5e705b02b80d799bb4f4582af34be1dfbb.camel@suse.de>
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

On Fri, Feb 08, 2019 at 10:05:51AM +0100, Martin Wilck wrote:
> On Thu, 2019-02-07 at 17:52 -0600, Benjamin Marzinski wrote:
> > LOG_MSG() will dereference pp->mpp. Commit cb5ec664 added a call to
> > LOG_MSG() before the check for (!pp->mpp) in check_path.  This can
> > cause
> > multipathd to crash.  LOG_MSG() should only be called if pp->mpp is
> > set
> > and a checker is selected.
> > 
> > Also, checker_message() should fail to a generic message if c->cls
> > isn't
> > set (which means that a checker hasn't been selected).
> > 
> > Fixes: cb5ec664 (multipathd: check_path: improve logging for
> > "unusable
> >                  path" case)
> > Cc: Martin Wilck <mwilck@suse.com>
> > Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
> 
> Thanks a lot, but could we do the below instead? IMO it's better to
> avoid similar errors in the future.
> 
> Martin

Sure. I can resend the series with this patch instead.

-Ben

> 
> 
> >From e5bef42f8f9d2aef9406873f515a45914c1aa251 Mon Sep 17 00:00:00 2001
> From: Benjamin Marzinski <bmarzins@redhat.com>
> Date: Thu, 7 Feb 2019 17:52:59 -0600
> Subject: [PATCH] multipathd: avoid null pointer dereference in LOG_MSG
> 
> LOG_MSG() will dereference pp->mpp. Commit cb5ec664 added a call to
> LOG_MSG() before the check for (!pp->mpp) in check_path.  This can cause
> multipathd to crash.  LOG_MSG() should check the fields before dereferencing
> them. Make checker_selected() an inline function to allow the compiler
> to optimize away the usually redundant test "if (&checker->pp != NULL)".
> 
> Also, checker_message() should fail to a generic message if c->cls isn't
> set (which means that a checker hasn't been selected).
> 
> Fixes: cb5ec664 (multipathd: check_path: improve logging for "unusable
>                  path" case)
> Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
> Signed-off-by: Martin Wilck <mwilck@suse.com>
> ---
>  libmultipath/checkers.c | 9 +--------
>  libmultipath/checkers.h | 6 +++++-
>  multipathd/main.c       | 6 ++++--
>  3 files changed, 10 insertions(+), 11 deletions(-)
> 
> diff --git a/libmultipath/checkers.c b/libmultipath/checkers.c
> index 848c4c34..f4fdcae9 100644
> --- a/libmultipath/checkers.c
> +++ b/libmultipath/checkers.c
> @@ -261,13 +261,6 @@ int checker_check (struct checker * c, int path_state)
>  	return r;
>  }
>  
> -int checker_selected(const struct checker *c)
> -{
> -	if (!c)
> -		return 0;
> -	return c->cls != NULL;
> -}
> -
>  const char *checker_name(const struct checker *c)
>  {
>  	if (!c || !c->cls)
> @@ -295,7 +288,7 @@ const char *checker_message(const struct checker *c)
>  {
>  	int id;
>  
> -	if (!c || c->msgid < 0 ||
> +	if (!c || !c->cls || c->msgid < 0 ||
>  	    (c->msgid >= CHECKER_GENERIC_MSGTABLE_SIZE &&
>  	     c->msgid < CHECKER_FIRST_MSGID))
>  		goto bad_id;
> diff --git a/libmultipath/checkers.h b/libmultipath/checkers.h
> index b2e8f9aa..dab197f9 100644
> --- a/libmultipath/checkers.h
> +++ b/libmultipath/checkers.h
> @@ -129,6 +129,11 @@ struct checker {
>  						you want to stuff data in. */
>  };
>  
> +static inline int checker_selected(const struct checker *c)
> +{
> +	return c != NULL && c->cls != NULL;
> +}
> +
>  const char *checker_state_name(int);
>  int init_checkers(const char *);
>  void cleanup_checkers (void);
> @@ -142,7 +147,6 @@ void checker_set_fd (struct checker *, int);
>  void checker_enable (struct checker *);
>  void checker_disable (struct checker *);
>  int checker_check (struct checker *, int);
> -int checker_selected(const struct checker *);
>  int checker_is_sync(const struct checker *);
>  const char *checker_name (const struct checker *);
>  /*
> diff --git a/multipathd/main.c b/multipathd/main.c
> index d1a4f629..d1dd286c 100644
> --- a/multipathd/main.c
> +++ b/multipathd/main.c
> @@ -92,7 +92,8 @@ static int use_watchdog;
>  
>  #define LOG_MSG(lvl, verb, pp)					\
>  do {								\
> -	if (lvl <= verb) {					\
> +	if (pp->mpp && checker_selected(&pp->checker) &&	\
> +	    lvl <= verb) {					\
>  		if (pp->offline)				\
>  			condlog(lvl, "%s: %s - path offline",	\
>  				pp->mpp->alias, pp->dev);	\
> @@ -2017,7 +2018,8 @@ check_path (struct vectors * vecs, struct path * pp, int ticks)
>  	}
>  
>  	if (newstate == PATH_WILD || newstate == PATH_UNCHECKED) {
> -		condlog(2, "%s: unusable path - checker failed", pp->dev);
> +		condlog(2, "%s: unusable path (%s) - checker failed",
> +			pp->dev, checker_state_name(newstate));
>  		LOG_MSG(2, verbosity, pp);
>  		conf = get_multipath_config();
>  		pthread_cleanup_push(put_multipath_config, conf);
> -- 
> 2.20.1
> 
