From: Benjamin Marzinski <bmarzins@redhat.com>
Subject: Re: [PATCH v2 13/21] libmultipath: provide defaults for
 {get, put}_multipath_config
Date: Thu, 24 Sep 2020 23:34:58 -0500
Message-ID: <20200925043458.GO11108@octiron.msp.redhat.com>
References: <20200924133716.14120-1-mwilck@suse.com>
	<20200924133716.14120-14-mwilck@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20200924133716.14120-14-mwilck@suse.com>
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

On Thu, Sep 24, 2020 at 03:37:08PM +0200, mwilck@suse.com wrote:
> From: Martin Wilck <mwilck@suse.com>
> 
> Add an implementation of get_multipath_config() and put_multipath_config()
> to libmultipath. The linker's symbol lookup rules will make sure that
> applications can override these functions if they need to. Defining
> these functions in libmultipath avoids the need to provide stubs
> for these functions in every appliation linking to libmultipath.
> 
> libmultipath's internal functions simply refer to a static "struct config".
> It must be initialized with init_config() rather than load_config(),
> which always allocates a new struct for backward compatibility, and must
> be teared down using uninit_config().
> 
> Signed-off-by: Martin Wilck <mwilck@suse.com>
> ---
>  libmultipath/config.c             | 75 ++++++++++++++++++++++++++-----
>  libmultipath/config.h             | 21 +++++++--
>  libmultipath/libmultipath.version | 10 +++++
>  3 files changed, 93 insertions(+), 13 deletions(-)
> 
> diff --git a/libmultipath/config.c b/libmultipath/config.c
> index 5c91a09..01b77df 100644
> --- a/libmultipath/config.c
> +++ b/libmultipath/config.c
> @@ -27,6 +27,26 @@
>  #include "mpath_cmd.h"
>  #include "propsel.h"
>  
> +static struct config __internal_config;
> +struct config *libmp_get_multipath_config(void)

This causes problems with the libmpathvalid library code I wrote.  The
issue is that right now, when you run _init_config() if
get_multipath_config() returns NULL, you will use the default loglevel.
I would like the library user to have control of the log level, even
during the calls to _init_config().

One possiblity would be to make init_config() take verbosity as an
argument.  There would also need to be some other config variable that
gets set at the start of init_config(), which is used by
libmp_get_multipath_config() to check if it is initialized.

-Ben

> +{
> +	if (!__internal_config.hwtable)
> +		/* not initialized */
> +		return NULL;
> +	return &__internal_config;
> +}
> +
> +struct config *get_multipath_config(void)
> +	__attribute__((weak, alias("libmp_get_multipath_config")));
> +
> +void libmp_put_multipath_config(void *conf __attribute__((unused)))
> +{
> +	/* empty */
> +}
> +
> +void put_multipath_config(void *conf)
> +	__attribute__((weak, alias("libmp_put_multipath_config")));
> +
>  static int
>  hwe_strmatch (const struct hwentry *hwe1, const struct hwentry *hwe2)
>  {
> @@ -574,17 +594,15 @@ restart:
>  	return;
>  }
>  
> -struct config *
> -alloc_config (void)
> +static struct config *alloc_config (void)
>  {
>  	return (struct config *)MALLOC(sizeof(struct config));
>  }
>  
> -void
> -free_config (struct config * conf)
> +static void _uninit_config(struct config *conf)
>  {
>  	if (!conf)
> -		return;
> +		conf = &__internal_config;
>  
>  	if (conf->multipath_dir)
>  		FREE(conf->multipath_dir);
> @@ -650,7 +668,27 @@ free_config (struct config * conf)
>  	free_hwtable(conf->hwtable);
>  	free_hwe(conf->overrides);
>  	free_keywords(conf->keywords);
> -	FREE(conf);
> +
> +	memset(conf, 0, sizeof(*conf));
> +}
> +
> +void uninit_config(void)

I didn't realize that this was o.k. I thought you had to specify static
in the function definition, even if it was specified in the protype.

> +{
> +	_uninit_config(&__internal_config);
> +}
> +
> +void free_config(struct config *conf)
> +{
> +	if (!conf)
> +		return;
> +	else if (conf == &__internal_config) {
> +		condlog(0, "ERROR: %s called for internal config. Use uninit_config() instead",
> +			__func__);
> +		return;
> +	}
> +
> +	_uninit_config(conf);
> +	free(conf);
>  }
>  
>  /* if multipath fails to process the config directory, it should continue,
> @@ -719,12 +757,29 @@ static void set_max_checkint_from_watchdog(struct config *conf)
>  }
>  #endif
>  
> +static int _init_config (const char *file, struct config *conf);
> +
> +int init_config(const char *file)
> +{
> +	return _init_config(file, &__internal_config);
> +}
> +
>  struct config *load_config(const char *file)
>  {
>  	struct config *conf = alloc_config();
>  
> +	if (conf && !_init_config(file, conf))
> +		return conf;
> +
> +	free(conf);
> +	return NULL;
> +}
> +
> +int _init_config (const char *file, struct config *conf)
> +{
> +
>  	if (!conf)
> -		return NULL;
> +		conf = &__internal_config;
>  
>  	/*
>  	 * internal defaults
> @@ -896,10 +951,10 @@ struct config *load_config(const char *file)
>  	    !conf->wwids_file || !conf->prkeys_file)
>  		goto out;
>  
> -	return conf;
> +	return 0;
>  out:
> -	free_config(conf);
> -	return NULL;
> +	_uninit_config(conf);
> +	return 1;
>  }
>  
>  char *get_uid_attribute_by_attrs(struct config *conf,
> diff --git a/libmultipath/config.h b/libmultipath/config.h
> index 116fe37..5997b71 100644
> --- a/libmultipath/config.h
> +++ b/libmultipath/config.h
> @@ -251,10 +251,25 @@ void free_mptable (vector mptable);
>  int store_hwe (vector hwtable, struct hwentry *);
>  
>  struct config *load_config (const char *file);
> -struct config * alloc_config (void);
>  void free_config (struct config * conf);
> -extern struct config *get_multipath_config(void);
> -extern void put_multipath_config(void *);
> +int init_config(const char *file);
> +void uninit_config(void);
> +
> +/*
> + * libmultipath provides default implementations of
> + * get_multipath_config() and put_multipath_config().
> + * Applications using these should use init_config(file, NULL)
> + * to load the configuration, rather than load_config(file).
> + * Likewise, uninit_config() should be used for teardown, but
> + * using free_config() for that is supported, too.
> + * Applications can define their own {get,put}_multipath_config()
> + * functions, which override the library-internal ones, but
> + * could still call libmp_{get,put}_multipath_config().
> + */
> +struct config *libmp_get_multipath_config(void);
> +struct config *get_multipath_config(void);
> +void libmp_put_multipath_config(void *);
> +void put_multipath_config(void *);
>  
>  int parse_uid_attrs(char *uid_attrs, struct config *conf);
>  char *get_uid_attribute_by_attrs(struct config *conf,
> diff --git a/libmultipath/libmultipath.version b/libmultipath/libmultipath.version
> index 0a96010..81bcc9d 100644
> --- a/libmultipath/libmultipath.version
> +++ b/libmultipath/libmultipath.version
> @@ -218,3 +218,13 @@ global:
>  	libmp_dm_task_run;
>  	cleanup_mutex;
>  } LIBMULTIPATH_0.8.4.1;
> +
> +LIBMULTIPATH_0.8.4.3 {
> +global:
> +	libmp_get_multipath_config;
> +	get_multipath_config;
> +	libmp_put_multipath_config;
> +	put_multipath_config;
> +	init_config;
> +	uninit_config;
> +} LIBMULTIPATH_0.8.4.2;
> -- 
> 2.28.0
