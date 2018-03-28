From: "Benjamin Marzinski" <bmarzins@redhat.com>
Subject: Re: [PATCH 2/2] libmultipath/propsel: (re)use static
 const vars for origin
Date: Wed, 28 Mar 2018 14:11:31 -0500
Message-ID: <20180328191131.GD3103@octiron.msp.redhat.com>
References: <20180327215053.3631-1-mwilck@suse.com>
	<20180327215053.3631-3-mwilck@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20180327215053.3631-3-mwilck@suse.com>
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

On Tue, Mar 27, 2018 at 11:50:53PM +0200, Martin Wilck wrote:
> Define a set of "origin" strings and reuse them throughout the code.
> That avoids duplication and makes it easier to verify that we use
> consistent messages.
> 
Reviewed-by: Benjamin Marzinski <bmarzins@redhat.com>
> Signed-off-by: Martin Wilck <mwilck@suse.com>
> ---
>  libmultipath/propsel.c | 170 ++++++++++++++++++++++++++++---------------------
>  1 file changed, 98 insertions(+), 72 deletions(-)
> 
> diff --git a/libmultipath/propsel.c b/libmultipath/propsel.c
> index dc24450eb775..2d3b7adfdfe2 100644
> --- a/libmultipath/propsel.c
> +++ b/libmultipath/propsel.c
> @@ -44,7 +44,19 @@ do {									\
>  	}								\
>  } while(0)
>  
> -static char default_origin[] = "(setting: multipath internal)";
> +static const char default_origin[] = "(setting: multipath internal)";
> +static const char hwe_origin[] =
> +	"(setting: storage device configuration)";
> +static const char multipaths_origin[] =
> +	"(setting: multipath.conf multipaths section)";
> +static const char conf_origin[] =
> +	"(setting: multipath.conf defaults/devices section)";
> +static const char overrides_origin[] =
> +	"(setting: multipath.conf overrides section)";
> +static const char cmdline_origin[] =
> +	"(setting: multipath command line [-p] flag)";
> +static const char autodetect_origin[] =
> +	"(setting: storage device autodetected)";
>  
>  #define do_default(dest, value)						\
>  do {									\
> @@ -53,24 +65,24 @@ do {									\
>  } while(0)
>  
>  #define mp_set_mpe(var)							\
> -do_set(var, mp->mpe, mp->var, "(setting: multipath.conf multipaths section)")
> +do_set(var, mp->mpe, mp->var, multipaths_origin)
>  #define mp_set_hwe(var)							\
> -do_set(var, mp->hwe, mp->var, "(setting: storage device configuration)")
> +do_set(var, mp->hwe, mp->var, hwe_origin)
>  #define mp_set_ovr(var)							\
> -do_set(var, conf->overrides, mp->var, "(setting: multipath.conf overrides section)")
> +do_set(var, conf->overrides, mp->var, overrides_origin)
>  #define mp_set_conf(var)						\
> -do_set(var, conf, mp->var, "(setting: multipath.conf defaults/devices section)")
> +do_set(var, conf, mp->var, conf_origin)
>  #define mp_set_default(var, value)					\
>  do_default(mp->var, value)
>  
>  #define pp_set_mpe(var)							\
> -do_set(var, mpe, pp->var, "(setting: multipath.conf multipaths section)")
> +do_set(var, mpe, pp->var, multipaths_origin)
>  #define pp_set_hwe(var)							\
> -do_set(var, pp->hwe, pp->var, "(setting: storage device configuration)")
> +do_set(var, pp->hwe, pp->var, hwe_origin)
>  #define pp_set_conf(var)						\
> -do_set(var, conf, pp->var, "(setting: multipath.conf defaults/devices section)")
> +do_set(var, conf, pp->var, conf_origin)
>  #define pp_set_ovr(var)							\
> -do_set(var, conf->overrides, pp->var, "(setting: multipath.conf overrides section)")
> +do_set(var, conf->overrides, pp->var, overrides_origin)
>  #define pp_set_default(var, value)					\
>  do_default(pp->var, value)
>  
> @@ -101,7 +113,7 @@ do {									\
>  
>  int select_mode(struct config *conf, struct multipath *mp)
>  {
> -	char *origin;
> +	const char *origin;
>  
>  	set_attr_mpe(mode, ATTR_MODE);
>  	set_attr_conf(mode, ATTR_MODE);
> @@ -114,7 +126,7 @@ out:
>  
>  int select_uid(struct config *conf, struct multipath *mp)
>  {
> -	char *origin;
> +	const char *origin;
>  
>  	set_attr_mpe(uid, ATTR_UID);
>  	set_attr_conf(uid, ATTR_UID);
> @@ -127,7 +139,7 @@ out:
>  
>  int select_gid(struct config *conf, struct multipath *mp)
>  {
> -	char *origin;
> +	const char *origin;
>  
>  	set_attr_mpe(gid, ATTR_GID);
>  	set_attr_conf(gid, ATTR_GID);
> @@ -145,7 +157,8 @@ out:
>   */
>  int select_rr_weight(struct config *conf, struct multipath * mp)
>  {
> -	char *origin, buff[13];
> +	const char *origin;
> +	char buff[13];
>  
>  	mp_set_mpe(rr_weight);
>  	mp_set_ovr(rr_weight);
> @@ -160,7 +173,8 @@ out:
>  
>  int select_pgfailback(struct config *conf, struct multipath * mp)
>  {
> -	char *origin, buff[13];
> +	const char *origin;
> +	char buff[13];
>  
>  	mp_set_mpe(pgfailback);
>  	mp_set_ovr(pgfailback);
> @@ -175,11 +189,12 @@ out:
>  
>  int select_pgpolicy(struct config *conf, struct multipath * mp)
>  {
> -	char *origin, buff[POLICY_NAME_SIZE];
> +	const char *origin;
> +	char buff[POLICY_NAME_SIZE];
>  
>  	if (conf->pgpolicy_flag > 0) {
>  		mp->pgpolicy = conf->pgpolicy_flag;
> -		origin = "(setting: multipath command line [-p] flag)";
> +		origin = cmdline_origin;
>  		goto out;
>  	}
>  	mp_set_mpe(pgpolicy);
> @@ -196,7 +211,7 @@ out:
>  
>  int select_selector(struct config *conf, struct multipath * mp)
>  {
> -	char *origin;
> +	const char *origin;
>  
>  	mp_set_mpe(selector);
>  	mp_set_ovr(selector);
> @@ -213,7 +228,7 @@ out:
>  static void
>  select_alias_prefix (struct config *conf, struct multipath * mp)
>  {
> -	char *origin;
> +	const char *origin;
>  
>  	mp_set_ovr(alias_prefix);
>  	mp_set_hwe(alias_prefix);
> @@ -228,17 +243,17 @@ static int
>  want_user_friendly_names(struct config *conf, struct multipath * mp)
>  {
>  
> -	char *origin;
> +	const char *origin;
>  	int user_friendly_names;
>  
>  	do_set(user_friendly_names, mp->mpe, user_friendly_names,
> -	       "(setting: multipath.conf multipaths section)");
> +	       multipaths_origin);
>  	do_set(user_friendly_names, conf->overrides, user_friendly_names,
> -	       "(setting: multipath.conf overrides section)");
> +	       overrides_origin);
>  	do_set(user_friendly_names, mp->hwe, user_friendly_names,
> -	       "(setting: storage device configuration)");
> +	       hwe_origin);
>  	do_set(user_friendly_names, conf, user_friendly_names,
> -	       "(setting: multipath.conf defaults/devices section)");
> +	       conf_origin);
>  	do_default(user_friendly_names, DEFAULT_USER_FRIENDLY_NAMES);
>  out:
>  	condlog(3, "%s: user_friendly_names = %s %s", mp->wwid,
> @@ -249,11 +264,11 @@ out:
>  
>  int select_alias(struct config *conf, struct multipath * mp)
>  {
> -	char *origin = NULL;
> +	const char *origin = NULL;
>  
>  	if (mp->mpe && mp->mpe->alias) {
>  		mp->alias = STRDUP(mp->mpe->alias);
> -		origin = "(setting: multipath.conf multipaths section)";
> +		origin = multipaths_origin;
>  		goto out;
>  	}
>  
> @@ -342,7 +357,7 @@ void reconcile_features_with_options(const char *id, char **features, int* no_pa
>  
>  int select_features(struct config *conf, struct multipath *mp)
>  {
> -	char *origin;
> +	const char *origin;
>  
>  	mp_set_mpe(features);
>  	mp_set_ovr(features);
> @@ -441,11 +456,12 @@ check_rdac(struct path * pp)
>  
>  int select_checker(struct config *conf, struct path *pp)
>  {
> -	char *origin, *checker_name;
> +	const char *origin;
> +	char *checker_name;
>  	struct checker * c = &pp->checker;
>  
>  	if (pp->detect_checker == DETECT_CHECKER_ON) {
> -		origin = "(setting: storage device autodetected)";
> +		origin = autodetect_origin;
>  		if (check_rdac(pp)) {
>  			checker_name = RDAC;
>  			goto out;
> @@ -454,32 +470,32 @@ int select_checker(struct config *conf, struct path *pp)
>  			goto out;
>  		}
>   	}
> -	do_set(checker_name, conf->overrides, checker_name, "(setting: multipath.conf overrides section)");
> -	do_set(checker_name, pp->hwe, checker_name, "(setting: storage device configuration)");
> -	do_set(checker_name, conf, checker_name, "(setting: multipath.conf defaults/devices section)");
> +	do_set(checker_name, conf->overrides, checker_name, overrides_origin);
> +	do_set(checker_name, pp->hwe, checker_name, hwe_origin);
> +	do_set(checker_name, conf, checker_name, conf_origin);
>  	do_default(checker_name, DEFAULT_CHECKER);
>  out:
>  	checker_get(conf->multipath_dir, c, checker_name);
>  	condlog(3, "%s: path_checker = %s %s", pp->dev, c->name, origin);
>  	if (conf->checker_timeout) {
>  		c->timeout = conf->checker_timeout;
> -		condlog(3, "%s: checker timeout = %u s (setting: multipath.conf defaults/devices section)",
> -				pp->dev, c->timeout);
> +		condlog(3, "%s: checker timeout = %u s %s",
> +			pp->dev, c->timeout, conf_origin);
>  	}
>  	else if (sysfs_get_timeout(pp, &c->timeout) > 0)
>  		condlog(3, "%s: checker timeout = %u s (setting: kernel sysfs)",
> -				pp->dev, c->timeout);
> +			pp->dev, c->timeout);
>  	else {
>  		c->timeout = DEF_TIMEOUT;
> -		condlog(3, "%s: checker timeout = %u s (setting: multipath internal)",
> -				pp->dev, c->timeout);
> +		condlog(3, "%s: checker timeout = %u s %s",
> +			pp->dev, c->timeout, default_origin);
>  	}
>  	return 0;
>  }
>  
>  int select_getuid(struct config *conf, struct path *pp)
>  {
> -	char *origin;
> +	const char *origin;
>  
>  	pp->uid_attribute = parse_uid_attribute_by_attrs(conf->uid_attrs, pp->dev);
>  	if (pp->uid_attribute) {
> @@ -531,24 +547,24 @@ do {									\
>  
>  int select_prio(struct config *conf, struct path *pp)
>  {
> -	char *origin;
> +	const char *origin;
>  	struct mpentry * mpe;
>  	struct prio * p = &pp->prio;
>  
>  	if (pp->detect_prio == DETECT_PRIO_ON) {
>  		detect_prio(conf, pp);
>  		if (prio_selected(p)) {
> -			origin = "(setting: storage device autodetected)";
> +			origin = autodetect_origin;
>  			goto out;
>  		}
>  	}
>  	mpe = find_mpe(conf->mptable, pp->wwid);
> -	set_prio(conf->multipath_dir, mpe, "(setting: multipath.conf multipaths section)");
> -	set_prio(conf->multipath_dir, conf->overrides, "(setting: multipath.conf overrides section)");
> -	set_prio(conf->multipath_dir, pp->hwe, "(setting: storage device configuration)");
> -	set_prio(conf->multipath_dir, conf, "(setting: multipath.conf defaults/devices section)");
> +	set_prio(conf->multipath_dir, mpe, multipaths_origin);
> +	set_prio(conf->multipath_dir, conf->overrides, overrides_origin);
> +	set_prio(conf->multipath_dir, pp->hwe, hwe_origin);
> +	set_prio(conf->multipath_dir, conf, conf_origin);
>  	prio_get(conf->multipath_dir, p, DEFAULT_PRIO, DEFAULT_PRIO_ARGS);
> -	origin = "(setting: multipath internal)";
> +	origin = default_origin;
>  out:
>  	/*
>  	 * fetch tpgs mode for alua, if its not already obtained
> @@ -568,7 +584,7 @@ out:
>  
>  int select_no_path_retry(struct config *conf, struct multipath *mp)
>  {
> -	char *origin = NULL;
> +	const char *origin = NULL;
>  	char buff[12];
>  
>  	if (mp->disable_queueing) {
> @@ -586,20 +602,20 @@ out:
>  		condlog(3, "%s: no_path_retry = %s %s", mp->alias, buff,
>  			origin);
>  	else
> -		condlog(3, "%s: no_path_retry = undef (setting: multipath internal)",
> -			mp->alias);
> +		condlog(3, "%s: no_path_retry = undef %s",
> +			mp->alias, default_origin);
>  	return 0;
>  }
>  
>  int
>  select_minio_rq (struct config *conf, struct multipath * mp)
>  {
> -	char *origin;
> +	const char *origin;
>  
> -	do_set(minio_rq, mp->mpe, mp->minio, "(setting: multipath.conf multipaths section)");
> -	do_set(minio_rq, conf->overrides, mp->minio, "(setting: multipath.conf overrides section)");
> -	do_set(minio_rq, mp->hwe, mp->minio, "(setting: storage device configuration)");
> -	do_set(minio_rq, conf, mp->minio, "(setting: multipath.conf defaults/devices section)");
> +	do_set(minio_rq, mp->mpe, mp->minio, multipaths_origin);
> +	do_set(minio_rq, conf->overrides, mp->minio, overrides_origin);
> +	do_set(minio_rq, mp->hwe, mp->minio, hwe_origin);
> +	do_set(minio_rq, conf, mp->minio, conf_origin);
>  	do_default(mp->minio, DEFAULT_MINIO_RQ);
>  out:
>  	condlog(3, "%s: minio = %i %s", mp->alias, mp->minio, origin);
> @@ -609,7 +625,7 @@ out:
>  int
>  select_minio_bio (struct config *conf, struct multipath * mp)
>  {
> -	char *origin;
> +	const char *origin;
>  
>  	mp_set_mpe(minio);
>  	mp_set_ovr(minio);
> @@ -633,7 +649,8 @@ int select_minio(struct config *conf, struct multipath *mp)
>  
>  int select_fast_io_fail(struct config *conf, struct multipath *mp)
>  {
> -	char *origin, buff[12];
> +	const char *origin;
> +	char buff[12];
>  
>  	mp_set_ovr(fast_io_fail);
>  	mp_set_hwe(fast_io_fail);
> @@ -647,7 +664,8 @@ out:
>  
>  int select_dev_loss(struct config *conf, struct multipath *mp)
>  {
> -	char *origin, buff[12];
> +	const char *origin;
> +	char buff[12];
>  
>  	mp_set_ovr(dev_loss);
>  	mp_set_hwe(dev_loss);
> @@ -662,7 +680,7 @@ out:
>  
>  int select_flush_on_last_del(struct config *conf, struct multipath *mp)
>  {
> -	char *origin;
> +	const char *origin;
>  
>  	mp_set_mpe(flush_on_last_del);
>  	mp_set_ovr(flush_on_last_del);
> @@ -677,12 +695,13 @@ out:
>  
>  int select_reservation_key(struct config *conf, struct multipath *mp)
>  {
> -	char *origin, buff[PRKEY_SIZE];
> +	const char *origin;
> +	char buff[PRKEY_SIZE];
>  	char *from_file = "";
>  	uint64_t prkey = 0;
>  
> -	do_prkey_set(mp->mpe, "(setting: multipath.conf multipaths section)");
> -	do_prkey_set(conf, "(setting: multipath.conf defaults/devices section)");
> +	do_prkey_set(mp->mpe, multipaths_origin);
> +	do_prkey_set(conf, conf_origin);
>  	put_be64(mp->reservation_key, 0);
>  	mp->prkey_source = PRKEY_SOURCE_NONE;
>  	return 0;
> @@ -703,7 +722,7 @@ out:
>  
>  int select_retain_hwhandler(struct config *conf, struct multipath *mp)
>  {
> -	char *origin;
> +	const char *origin;
>  	unsigned int minv_dm_retain[3] = {1, 5, 0};
>  
>  	if (!VERSION_GE(conf->version, minv_dm_retain)) {
> @@ -729,7 +748,7 @@ out:
>  
>  int select_detect_prio(struct config *conf, struct path *pp)
>  {
> -	char *origin;
> +	const char *origin;
>  
>  	pp_set_ovr(detect_prio);
>  	pp_set_hwe(detect_prio);
> @@ -743,7 +762,7 @@ out:
>  
>  int select_detect_checker(struct config *conf, struct path *pp)
>  {
> -	char *origin;
> +	const char *origin;
>  
>  	pp_set_ovr(detect_checker);
>  	pp_set_hwe(detect_checker);
> @@ -758,7 +777,7 @@ out:
>  
>  int select_deferred_remove(struct config *conf, struct multipath *mp)
>  {
> -	char *origin;
> +	const char *origin;
>  
>  #ifndef LIBDM_API_DEFERRED
>  	mp->deferred_remove = DEFERRED_REMOVE_OFF;
> @@ -783,7 +802,8 @@ out:
>  
>  int select_delay_watch_checks(struct config *conf, struct multipath *mp)
>  {
> -	char *origin, buff[12];
> +	const char *origin;
> +	char buff[12];
>  
>  	mp_set_mpe(delay_watch_checks);
>  	mp_set_ovr(delay_watch_checks);
> @@ -798,7 +818,8 @@ out:
>  
>  int select_delay_wait_checks(struct config *conf, struct multipath *mp)
>  {
> -	char *origin, buff[12];
> +	const char *origin;
> +	char buff[12];
>  
>  	mp_set_mpe(delay_wait_checks);
>  	mp_set_ovr(delay_wait_checks);
> @@ -814,7 +835,8 @@ out:
>  
>  int select_marginal_path_err_sample_time(struct config *conf, struct multipath *mp)
>  {
> -	char *origin, buff[12];
> +	const char *origin;
> +	char buff[12];
>  
>  	mp_set_mpe(marginal_path_err_sample_time);
>  	mp_set_ovr(marginal_path_err_sample_time);
> @@ -830,7 +852,8 @@ out:
>  
>  int select_marginal_path_err_rate_threshold(struct config *conf, struct multipath *mp)
>  {
> -	char *origin, buff[12];
> +	const char *origin;
> +	char buff[12];
>  
>  	mp_set_mpe(marginal_path_err_rate_threshold);
>  	mp_set_ovr(marginal_path_err_rate_threshold);
> @@ -846,7 +869,8 @@ out:
>  
>  int select_marginal_path_err_recheck_gap_time(struct config *conf, struct multipath *mp)
>  {
> -	char *origin, buff[12];
> +	const char *origin;
> +	char buff[12];
>  
>  	mp_set_mpe(marginal_path_err_recheck_gap_time);
>  	mp_set_ovr(marginal_path_err_recheck_gap_time);
> @@ -862,7 +886,8 @@ out:
>  
>  int select_marginal_path_double_failed_time(struct config *conf, struct multipath *mp)
>  {
> -	char *origin, buff[12];
> +	const char *origin;
> +	char buff[12];
>  
>  	mp_set_mpe(marginal_path_double_failed_time);
>  	mp_set_ovr(marginal_path_double_failed_time);
> @@ -878,7 +903,7 @@ out:
>  
>  int select_skip_kpartx (struct config *conf, struct multipath * mp)
>  {
> -	char *origin;
> +	const char *origin;
>  
>  	mp_set_mpe(skip_kpartx);
>  	mp_set_ovr(skip_kpartx);
> @@ -894,7 +919,7 @@ out:
>  
>  int select_max_sectors_kb(struct config *conf, struct multipath * mp)
>  {
> -	char *origin;
> +	const char *origin;
>  
>  	mp_set_mpe(max_sectors_kb);
>  	mp_set_ovr(max_sectors_kb);
> @@ -915,7 +940,8 @@ out:
>  
>  int select_ghost_delay (struct config *conf, struct multipath * mp)
>  {
> -	char *origin, buff[12];
> +	const char *origin;
> +	char buff[12];
>  
>  	mp_set_mpe(ghost_delay);
>  	mp_set_ovr(ghost_delay);
> -- 
> 2.16.1
