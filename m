From: "Benjamin Marzinski" <bmarzins@redhat.com>
Subject: Re: [PATCH 1/7] libmultipath: load_config: skip setting
 unnecessary defaults
Date: Thu, 15 Jun 2017 14:49:14 -0500
Message-ID: <20170615194914.GD2940@octiron.msp.redhat.com>
References: <20170613225554.11181-1-mwilck@suse.com>
	<20170613225554.11181-2-mwilck@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20170613225554.11181-2-mwilck@suse.com>
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
Cc: dm-devel@redhat.com, Xose Vazquez Perez <xose.vazquez@gmail.com>
List-Id: dm-devel.ids

On Wed, Jun 14, 2017 at 12:55:48AM +0200, Martin Wilck wrote:
> We have the logic for setting defaults for paths and maps
> in propsel.c. By pre-setting conf values with defaults in
> load_config(), we generate irritating log messages like
> 'features = "0" (setting: multipath.conf defaults/devices section)'
> even if multipath.conf doesn't contain a 'features' setting at all.
> With this patch, these defaults are correctly logged as "multipath internal".
> 
> Signed-off-by: Martin Wilck <mwilck@suse.com>
> ---
>  libmultipath/config.c  | 16 ----------------
>  libmultipath/propsel.c |  2 +-
>  2 files changed, 1 insertion(+), 17 deletions(-)
> 
> diff --git a/libmultipath/config.c b/libmultipath/config.c
> index bb6619b3..61bbba91 100644
> --- a/libmultipath/config.c
> +++ b/libmultipath/config.c
> @@ -599,40 +599,24 @@ load_config (char * file)
>  	if (!conf->verbosity)
>  		conf->verbosity = DEFAULT_VERBOSITY;
>  
> -	conf->minio = DEFAULT_MINIO;
> -	conf->minio_rq = DEFAULT_MINIO_RQ;
>  	get_sys_max_fds(&conf->max_fds);
>  	conf->bindings_file = set_default(DEFAULT_BINDINGS_FILE);
>  	conf->wwids_file = set_default(DEFAULT_WWIDS_FILE);
>  	conf->multipath_dir = set_default(DEFAULT_MULTIPATHDIR);
> -	conf->features = set_default(DEFAULT_FEATURES);
> -	conf->flush_on_last_del = DEFAULT_FLUSH;
>  	conf->attribute_flags = 0;
>  	conf->reassign_maps = DEFAULT_REASSIGN_MAPS;
>  	conf->checkint = DEFAULT_CHECKINT;
>  	conf->max_checkint = 0;
> -	conf->pgfailback = DEFAULT_FAILBACK;
> -	conf->fast_io_fail = DEFAULT_FAST_IO_FAIL;
> -	conf->retain_hwhandler = DEFAULT_RETAIN_HWHANDLER;
> -	conf->detect_prio = DEFAULT_DETECT_PRIO;
> -	conf->detect_checker = DEFAULT_DETECT_CHECKER;
>  	conf->force_sync = DEFAULT_FORCE_SYNC;
>  	conf->partition_delim = DEFAULT_PARTITION_DELIM;
>  	conf->processed_main_config = 0;
>  	conf->find_multipaths = DEFAULT_FIND_MULTIPATHS;
>  	conf->uxsock_timeout = DEFAULT_REPLY_TIMEOUT;
> -	conf->uid_attribute = set_default(DEFAULT_UID_ATTRIBUTE);
>  	conf->retrigger_tries = DEFAULT_RETRIGGER_TRIES;
>  	conf->retrigger_delay = DEFAULT_RETRIGGER_DELAY;
>  	conf->uev_wait_timeout = DEFAULT_UEV_WAIT_TIMEOUT;
> -	conf->deferred_remove = DEFAULT_DEFERRED_REMOVE;
> -	conf->skip_kpartx = DEFAULT_SKIP_KPARTX;
>  	conf->disable_changed_wwids = DEFAULT_DISABLE_CHANGED_WWIDS;
>  	conf->remove_retries = 0;
> -	conf->max_sectors_kb = DEFAULT_MAX_SECTORS_KB;
> -	conf->san_path_err_threshold = DEFAULT_ERR_CHECKS;
> -	conf->san_path_err_forget_rate = DEFAULT_ERR_CHECKS;
> -	conf->san_path_err_recovery_time = DEFAULT_ERR_CHECKS;
>  
>  	/*
>  	 * preload default hwtable

If you look at the output of "multipathd show config", with this change
multipath is not longer printing the built-in defaults for some options
that do have defined defaults. Fixing this probably just requires using
declare_def_snprint_defint() instead of declare_def_snprint() for these
options it dict.c.

> diff --git a/libmultipath/propsel.c b/libmultipath/propsel.c
> index 385063aa..99d17e65 100644
> --- a/libmultipath/propsel.c
> +++ b/libmultipath/propsel.c
> @@ -752,7 +752,7 @@ int select_max_sectors_kb(struct config *conf, struct multipath * mp)
>  	mp_set_ovr(max_sectors_kb);
>  	mp_set_hwe(max_sectors_kb);
>  	mp_set_conf(max_sectors_kb);
> -	return 0;
> +	mp_set_default(max_sectors_kb, DEFAULT_MAX_SECTORS_KB);
>  out:
>  	condlog(3, "%s: max_sectors_kb = %i %s", mp->alias, mp->max_sectors_kb,
>  		origin);

I think this will be confusing.  The default for max_sectors_kb is
undefined (i.e. if users don't set it, multipath doesn't doesn't change
the existing sysfs value for max_sectors_kb for the path devices).
Instead of just printing nothing, we will now print that max_sectors_kb
has been set to 0, which isn't actually true. I don't disagree that we
should explicitly set the value for the multipath device. I just think
that we should either print nothing, or define a print function that
prints "undefined" or something for 0 and the number otherwise, and use
that to generate the string to print, much like how
select_san_path_err_recovery_time() and others use print_off_int_undef()

-Ben

> -- 
> 2.13.0
