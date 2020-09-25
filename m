From: Benjamin Marzinski <bmarzins@redhat.com>
Subject: Re: [PATCH v2 19/21] libmpathpersist: call
	libmultipath_{init, exit}()
Date: Fri, 25 Sep 2020 18:55:12 -0500
Message-ID: <20200925235512.GG3384@octiron.msp.redhat.com>
References: <20200924133716.14120-1-mwilck@suse.com>
	<20200924133716.14120-20-mwilck@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20200924133716.14120-20-mwilck@suse.com>
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
To: mwilck@suse.com
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

On Thu, Sep 24, 2020 at 03:37:14PM +0200, mwilck@suse.com wrote:
> From: Martin Wilck <mwilck@suse.com>
> 
> Have libmpathpersist_{init,exit} do the udev initialization, too.
> 
Reviewed-by: Benjamin Marzinski <bmarzins@redhat.com>
> Signed-off-by: Martin Wilck <mwilck@suse.com>
> ---
>  libmpathpersist/mpath_persist.c | 11 ++++++++---
>  libmpathpersist/mpath_persist.h |  9 ++++++---
>  2 files changed, 14 insertions(+), 6 deletions(-)
> 
> diff --git a/libmpathpersist/mpath_persist.c b/libmpathpersist/mpath_persist.c
> index a529a38..873b419 100644
> --- a/libmpathpersist/mpath_persist.c
> +++ b/libmpathpersist/mpath_persist.c
> @@ -48,6 +48,10 @@ int libmpathpersist_init(void)
>  	struct config *conf;
>  	int rc = 0;
>  
> +	if (libmultipath_init()) {
> +		condlog(0, "Failed to initialize libmultipath.");
> +		return 1;
> +	}
>  	if (init_config(DEFAULT_CONFIGFILE)) {
>  		condlog(0, "Failed to initialize multipath config.");
>  		return 1;
> @@ -74,23 +78,24 @@ mpath_lib_init (void)
>  
>  static void libmpathpersist_cleanup(void)
>  {
> -	dm_lib_exit();
>  	cleanup_prio();
>  	cleanup_checkers();
> +	libmultipath_exit();
> +	dm_lib_exit();
>  }
>  
>  int
>  mpath_lib_exit (struct config *conf)
>  {
> -	libmpathpersist_cleanup();
>  	free_config(conf);
> +	libmpathpersist_cleanup();
>  	return 0;
>  }
>  
>  int libmpathpersist_exit(void)
>  {
> -	libmpathpersist_cleanup();
>  	uninit_config();
> +	libmpathpersist_cleanup();
>  	return 0;
>  }
>  
> diff --git a/libmpathpersist/mpath_persist.h b/libmpathpersist/mpath_persist.h
> index 91606ef..5435eae 100644
> --- a/libmpathpersist/mpath_persist.h
> +++ b/libmpathpersist/mpath_persist.h
> @@ -176,7 +176,8 @@ struct prout_param_descriptor {		/* PROUT parameter descriptor */
>   *	Initialize device mapper multipath configuration. This function must be invoked first
>   *	before performing reservation management functions.
>   *	Either this function or mpath_lib_init() may be used.
> - *	Use this function to work with libmultipath's internal "struct config".
> + *	Use this function to work with libmultipath's internal "struct config"
> + *	and "struct udev". The latter will be initialized automatically.
>   *	Call libmpathpersist_exit() for cleanup.
>   * RESTRICTIONS:
>   *
> @@ -189,7 +190,8 @@ extern int libmpathpersist_init (void);
>   *	Initialize device mapper multipath configuration. This function must be invoked first
>   *	before performing reservation management functions.
>   *	Either this function or libmpathpersist_init() may be used.
> - *	Use this function to work with an application-specific "struct config".
> + *	Use this function to work with an application-specific "struct config"
> + *	and "struct udev". The latter must be initialized by the application.
>   *	Call mpath_lib_exit() for cleanup.
>   * RESTRICTIONS:
>   *
> @@ -211,9 +213,10 @@ extern int mpath_lib_exit (struct config *conf);
>  
>  /*
>   * DESCRIPTION :
> - *	Release device mapper multipath configuration. This function must be invoked after
> + *	Release device mapper multipath configuration a. This function must be invoked after
>   *	performing reservation management functions.
>   *	Use this after initialization with libmpathpersist_init().
> + *	Calling libmpathpersist_init() after libmpathpersist_exit() will fail.
>   * RESTRICTIONS:
>   *
>   * RETURNS: 0->Success, 1->Failed.
> -- 
> 2.28.0
