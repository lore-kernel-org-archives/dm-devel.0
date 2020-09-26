From: Benjamin Marzinski <bmarzins@redhat.com>
Subject: Re: [PATCH v2 21/21] multipathd: remove logsink and udev
Date: Fri, 25 Sep 2020 19:19:23 -0500
Message-ID: <20200926001923.GI3384@octiron.msp.redhat.com>
References: <20200924133716.14120-1-mwilck@suse.com>
	<20200924133716.14120-22-mwilck@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20200924133716.14120-22-mwilck@suse.com>
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

On Thu, Sep 24, 2020 at 03:37:16PM +0200, mwilck@suse.com wrote:
> From: Martin Wilck <mwilck@suse.com>
> 
> We can use the symbols from libmultipath now.
> 
Reviewed-by: Benjamin Marzinski <bmarzins@redhat.com>
> Signed-off-by: Martin Wilck <mwilck@suse.com>
> ---
>  multipathd/main.c | 9 +++------
>  1 file changed, 3 insertions(+), 6 deletions(-)
> 
> diff --git a/multipathd/main.c b/multipathd/main.c
> index 00b66ba..c5c374b 100644
> --- a/multipathd/main.c
> +++ b/multipathd/main.c
> @@ -115,7 +115,6 @@ struct mpath_event_param
>  	struct multipath *mpp;
>  };
>  
> -int logsink;
>  int uxsock_timeout;
>  int verbosity;
>  int bindings_read_only;
> @@ -151,8 +150,6 @@ int should_exit(void)
>   */
>  struct vectors * gvecs;
>  
> -struct udev * udev;
> -
>  struct config *multipath_conf;
>  
>  /* Local variables */
> @@ -3123,8 +3120,6 @@ child (__attribute__((unused)) void *param)
>  	conf = rcu_dereference(multipath_conf);
>  	rcu_assign_pointer(multipath_conf, NULL);
>  	call_rcu(&conf->rcu, rcu_free_config);
> -	udev_unref(udev);
> -	udev = NULL;
>  	pthread_attr_destroy(&waiter_attr);
>  	pthread_attr_destroy(&io_err_stat_attr);
>  #ifdef _DEBUG_
> @@ -3228,7 +3223,9 @@ main (int argc, char *argv[])
>  
>  	pthread_cond_init_mono(&config_cond);
>  
> -	udev = udev_new();
> +	libmultipath_init();
> +	if (atexit(libmultipath_exit))
> +		condlog(3, "failed to register exit handler for libmultipath");
>  	libmp_udev_set_sync_support(0);
>  
>  	while ((arg = getopt(argc, argv, ":dsv:k::Bniw")) != EOF ) {
> -- 
> 2.28.0
