Return-Path: <SRS0=NZHG=FV=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7A66FC4361B
	for <dm-devel@archiver.kernel.org>; Thu, 17 Dec 2020 03:44:10 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [63.128.21.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id C342320866
	for <dm-devel@archiver.kernel.org>; Thu, 17 Dec 2020 03:44:09 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org C342320866
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1608176648;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=9xpVBAbuSNwB/DV+EUQInQvROsQKH6QVMX36lio62pY=;
	b=Tqn6vIsscJs8bw95UaSvtrE+FcSJrV1f5j5fDcLdiDk1WvTnl2FcRs0boD2phN/tWR3Saw
	FCwNYnOwVwDxlkWCdl8ZJiOUAfj+gPJL5BTb+MutOXCdklI9CosNAzX2YzqVLBpHOlGDUp
	d9In8j1RH+nWaH8Rm9CBTRT6e/cKd2A=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-516-v0s2KODpOBiItL8KG-r7MA-1; Wed, 16 Dec 2020 22:44:06 -0500
X-MC-Unique: v0s2KODpOBiItL8KG-r7MA-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 3121F80EF82;
	Thu, 17 Dec 2020 03:44:02 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id CDB685D9C0;
	Thu, 17 Dec 2020 03:44:01 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 38914180954D;
	Thu, 17 Dec 2020 03:44:01 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com
	[10.5.11.12])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 0BH3dt9u012739 for <dm-devel@listman.util.phx.redhat.com>;
	Wed, 16 Dec 2020 22:39:55 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 1111260C4D; Thu, 17 Dec 2020 03:39:55 +0000 (UTC)
Received: from octiron.msp.redhat.com (octiron.msp.redhat.com [10.15.80.209])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 051CF60C15;
	Thu, 17 Dec 2020 03:39:51 +0000 (UTC)
Received: from octiron.msp.redhat.com (localhost.localdomain [127.0.0.1])
	by octiron.msp.redhat.com (8.14.9/8.14.9) with ESMTP id 0BH3doLn028195; 
	Wed, 16 Dec 2020 21:39:50 -0600
Received: (from bmarzins@localhost)
	by octiron.msp.redhat.com (8.14.9/8.14.9/Submit) id 0BH3doEs028194;
	Wed, 16 Dec 2020 21:39:50 -0600
Date: Wed, 16 Dec 2020 21:39:50 -0600
From: Benjamin Marzinski <bmarzins@redhat.com>
To: mwilck@suse.com
Message-ID: <20201217033950.GW3103@octiron.msp.redhat.com>
References: <20201216181708.22224-1-mwilck@suse.com>
	<20201216181708.22224-25-mwilck@suse.com>
MIME-Version: 1.0
In-Reply-To: <20201216181708.22224-25-mwilck@suse.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
X-loop: dm-devel@redhat.com
Cc: lixiaokeng@huawei.com, dm-devel@redhat.com
Subject: Re: [dm-devel] [PATCH v3 24/29] libmultipath: use libmp_verbosity
 to track verbosity
X-BeenThere: dm-devel@redhat.com
X-Mailman-Version: 2.1.12
Precedence: junk
List-Id: device-mapper development <dm-devel.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Wed, Dec 16, 2020 at 07:17:03PM +0100, mwilck@suse.com wrote:
> From: Martin Wilck <mwilck@suse.com>
> 
> Introduce a new global variable to set the verbosity of libmultipath.
> This avoids accessing the configuration in every dlog() call.
> When libmultipath reads its configuration in init_config() or
> load_config(), it will use the current value of libmp_verbosity
> for logging. Immediately before returning, libmp_verbosity will be
> overwritten with the verbosity value from the configuration file,
> if it was set there. An application is free to set libmp_verbosity
> back to the previous value or not after that, depending on whether
> command line options or configuration file settings should take
> precedence.
> 
> Replace internal access to conf->verbosity with the new variable.
> 
Reviewed-by: Benjamin Marzinski <bmarzins@redhat.com>
> Signed-off-by: Martin Wilck <mwilck@suse.com>
> ---
>  libmpathpersist/mpath_persist.c   |  5 +---
>  libmultipath/config.c             |  9 +++++--
>  libmultipath/configure.c          | 16 +++----------
>  libmultipath/debug.c              | 10 ++------
>  libmultipath/debug.h              |  1 +
>  libmultipath/devmapper.c          |  7 +-----
>  libmultipath/libmultipath.version |  5 ++++
>  multipath/main.c                  | 21 ++++++----------
>  multipathd/main.c                 | 40 ++++++++++++++++++-------------
>  tests/alias.c                     |  1 +
>  tests/blacklist.c                 |  2 ++
>  11 files changed, 53 insertions(+), 64 deletions(-)
> 
> diff --git a/libmpathpersist/mpath_persist.c b/libmpathpersist/mpath_persist.c
> index 9ebf91d..79322e8 100644
> --- a/libmpathpersist/mpath_persist.c
> +++ b/libmpathpersist/mpath_persist.c
> @@ -170,10 +170,7 @@ void mpath_persistent_reserve_free_vecs(void)
>  
>  int mpath_persistent_reserve_init_vecs(int verbose)
>  {
> -	struct config *conf = get_multipath_config();
> -
> -	conf->verbosity = verbose;
> -	put_multipath_config(conf);
> +	libmp_verbosity = verbose;
>  
>  	if (curmp)
>  		return MPATH_PR_SUCCESS;
> diff --git a/libmultipath/config.c b/libmultipath/config.c
> index 52b1447..49e7fb8 100644
> --- a/libmultipath/config.c
> +++ b/libmultipath/config.c
> @@ -828,10 +828,14 @@ int _init_config (const char *file, struct config *conf)
>  		conf = &__internal_config;
>  
>  	/*
> -	 * internal defaults
> +	 * Processing the config file will overwrite conf->verbosity if set
> +	 * When we return, we'll copy the config value back
>  	 */
> -	conf->verbosity = DEFAULT_VERBOSITY;
> +	conf->verbosity = libmp_verbosity;
>  
> +	/*
> +	 * internal defaults
> +	 */
>  	get_sys_max_fds(&conf->max_fds);
>  	conf->bindings_file = set_default(DEFAULT_BINDINGS_FILE);
>  	conf->wwids_file = set_default(DEFAULT_WWIDS_FILE);
> @@ -997,6 +1001,7 @@ int _init_config (const char *file, struct config *conf)
>  	    !conf->wwids_file || !conf->prkeys_file)
>  		goto out;
>  
> +	libmp_verbosity = conf->verbosity;
>  	return 0;
>  out:
>  	_uninit_config(conf);
> diff --git a/libmultipath/configure.c b/libmultipath/configure.c
> index 1c8aac0..3dbc1f1 100644
> --- a/libmultipath/configure.c
> +++ b/libmultipath/configure.c
> @@ -934,16 +934,12 @@ int domap(struct multipath *mpp, char *params, int is_daemon)
>  {
>  	int r = DOMAP_FAIL;
>  	struct config *conf;
> -	int verbosity;
>  
>  	/*
>  	 * last chance to quit before touching the devmaps
>  	 */
>  	if (mpp->action == ACT_DRY_RUN) {
> -		conf = get_multipath_config();
> -		verbosity = conf->verbosity;
> -		put_multipath_config(conf);
> -		print_multipath_topology(mpp, verbosity);
> +		print_multipath_topology(mpp, libmp_verbosity);
>  		return DOMAP_DRY;
>  	}
>  
> @@ -1311,14 +1307,8 @@ int coalesce_paths (struct vectors * vecs, vector newmp, char * refwwid,
>  					       "queue_if_no_path");
>  		}
>  
> -		if (!is_daemon && mpp->action != ACT_NOTHING) {
> -			int verbosity;
> -
> -			conf = get_multipath_config();
> -			verbosity = conf->verbosity;
> -			put_multipath_config(conf);
> -			print_multipath_topology(mpp, verbosity);
> -		}
> +		if (!is_daemon && mpp->action != ACT_NOTHING)
> +			print_multipath_topology(mpp, libmp_verbosity);
>  
>  		if (newmp) {
>  			if (mpp->action != ACT_REJECT) {
> diff --git a/libmultipath/debug.c b/libmultipath/debug.c
> index b3a1de9..a1713b9 100644
> --- a/libmultipath/debug.c
> +++ b/libmultipath/debug.c
> @@ -16,21 +16,15 @@
>  #include "debug.h"
>  
>  int logsink;
> +int libmp_verbosity = DEFAULT_VERBOSITY;
>  
>  void dlog (int sink, int prio, const char * fmt, ...)
>  {
>  	va_list ap;
> -	int thres;
> -	struct config *conf;
>  
>  	va_start(ap, fmt);
> -	conf = get_multipath_config();
> -	ANNOTATE_IGNORE_READS_BEGIN();
> -	thres = (conf) ? conf->verbosity : DEFAULT_VERBOSITY;
> -	ANNOTATE_IGNORE_READS_END();
> -	put_multipath_config(conf);
>  
> -	if (prio <= thres) {
> +	if (prio <= libmp_verbosity) {
>  		if (sink < 1) {
>  			if (sink == 0) {
>  				time_t t = time(NULL);
> diff --git a/libmultipath/debug.h b/libmultipath/debug.h
> index c6120c1..1f3bc8b 100644
> --- a/libmultipath/debug.h
> +++ b/libmultipath/debug.h
> @@ -8,6 +8,7 @@ void dlog (int sink, int prio, const char * fmt, ...)
>  #include "log_pthread.h"
>  
>  extern int logsink;
> +extern int libmp_verbosity;
>  
>  #define condlog(prio, fmt, args...) \
>  	dlog(logsink, prio, fmt "\n", ##args)
> diff --git a/libmultipath/devmapper.c b/libmultipath/devmapper.c
> index e60ab49..dfe95d2 100644
> --- a/libmultipath/devmapper.c
> +++ b/libmultipath/devmapper.c
> @@ -351,16 +351,11 @@ void libmp_dm_exit(void)
>  
>  static void libmp_dm_init(void)
>  {
> -	struct config *conf;
> -	int verbosity;
>  	unsigned int version[3];
>  
>  	if (dm_prereq(version))
>  		exit(1);
> -	conf = get_multipath_config();
> -	verbosity = conf->verbosity;
> -	put_multipath_config(conf);
> -	dm_init(verbosity);
> +	dm_init(libmp_verbosity);
>  #ifdef LIBDM_API_HOLD_CONTROL
>  	dm_hold_control_dev(1);
>  #endif
> diff --git a/libmultipath/libmultipath.version b/libmultipath/libmultipath.version
> index 800cff2..67a7379 100644
> --- a/libmultipath/libmultipath.version
> +++ b/libmultipath/libmultipath.version
> @@ -259,3 +259,8 @@ global:
>  local:
>  	*;
>  };
> +
> +LIBMULTIPATH_4.1.0 {
> +global:
> +	libmp_verbosity;
> +} LIBMULTIPATH_4.0.0;
> diff --git a/multipath/main.c b/multipath/main.c
> index 056e29a..371be2a 100644
> --- a/multipath/main.c
> +++ b/multipath/main.c
> @@ -208,22 +208,15 @@ get_dm_mpvec (enum mpath_cmds cmd, vector curmp, vector pathvec, char * refwwid)
>  			mpp->bestpg = select_path_group(mpp);
>  
>  		if (cmd == CMD_LIST_SHORT ||
> -		    cmd == CMD_LIST_LONG) {
> -			struct config *conf = get_multipath_config();
> -			print_multipath_topology(mpp, conf->verbosity);
> -			put_multipath_config(conf);
> -		}
> +		    cmd == CMD_LIST_LONG)
> +			print_multipath_topology(mpp, libmp_verbosity);
>  
>  		if (cmd == CMD_CREATE)
>  			reinstate_paths(mpp);
>  	}
>  
> -	if (cmd == CMD_LIST_SHORT || cmd == CMD_LIST_LONG) {
> -		struct config *conf = get_multipath_config();
> -
> -		print_foreign_topology(conf->verbosity);
> -		put_multipath_config(conf);
> -	}
> +	if (cmd == CMD_LIST_SHORT || cmd == CMD_LIST_LONG)
> +		print_foreign_topology(libmp_verbosity);
>  
>  	return 0;
>  }
> @@ -552,7 +545,7 @@ configure (struct config *conf, enum mpath_cmds cmd,
>  	if (path_discovery(pathvec, di_flag) < 0)
>  		goto out;
>  
> -	if (conf->verbosity > 2)
> +	if (libmp_verbosity > 2)
>  		print_all_paths(pathvec, 1);
>  
>  	get_path_layout(pathvec, 0);
> @@ -842,7 +835,7 @@ main (int argc, char *argv[])
>  				exit(RTVL_FAIL);
>  			}
>  
> -			conf->verbosity = atoi(optarg);
> +			libmp_verbosity = atoi(optarg);
>  			break;
>  		case 'b':
>  			conf->bindings_file = strdup(optarg);
> @@ -973,7 +966,7 @@ main (int argc, char *argv[])
>  	}
>  	if (dev_type == DEV_UEVENT) {
>  		openlog("multipath", 0, LOG_DAEMON);
> -		setlogmask(LOG_UPTO(conf->verbosity + 3));
> +		setlogmask(LOG_UPTO(libmp_verbosity + 3));
>  		logsink = 1;
>  	}
>  
> diff --git a/multipathd/main.c b/multipathd/main.c
> index 4de0978..ba25751 100644
> --- a/multipathd/main.c
> +++ b/multipathd/main.c
> @@ -88,10 +88,10 @@
>  #define CMDSIZE 160
>  #define MSG_SIZE 32
>  
> -#define LOG_MSG(lvl, verb, pp)					\
> +#define LOG_MSG(lvl, pp)					\
>  do {								\
>  	if (pp->mpp && checker_selected(&pp->checker) &&	\
> -	    lvl <= verb) {					\
> +	    lvl <= libmp_verbosity) {					\
>  		if (pp->offline)				\
>  			condlog(lvl, "%s: %s - path offline",	\
>  				pp->mpp->alias, pp->dev);	\
> @@ -2070,7 +2070,7 @@ check_path (struct vectors * vecs, struct path * pp, unsigned int ticks)
>  	int chkr_new_path_up = 0;
>  	int disable_reinstate = 0;
>  	int oldchkrstate = pp->chkrstate;
> -	int retrigger_tries, verbosity;
> +	int retrigger_tries;
>  	unsigned int checkint, max_checkint;
>  	struct config *conf;
>  	int marginal_pathgroups, marginal_changed = 0;
> @@ -2090,7 +2090,6 @@ check_path (struct vectors * vecs, struct path * pp, unsigned int ticks)
>  	retrigger_tries = conf->retrigger_tries;
>  	checkint = conf->checkint;
>  	max_checkint = conf->max_checkint;
> -	verbosity = conf->verbosity;
>  	marginal_pathgroups = conf->marginal_pathgroups;
>  	put_multipath_config(conf);
>  
> @@ -2152,7 +2151,7 @@ check_path (struct vectors * vecs, struct path * pp, unsigned int ticks)
>  	if (newstate == PATH_WILD || newstate == PATH_UNCHECKED) {
>  		condlog(2, "%s: unusable path (%s) - checker failed",
>  			pp->dev, checker_state_name(newstate));
> -		LOG_MSG(2, verbosity, pp);
> +		LOG_MSG(2, pp);
>  		conf = get_multipath_config();
>  		pthread_cleanup_push(put_multipath_config, conf);
>  		pathinfo(pp, conf, 0);
> @@ -2257,7 +2256,7 @@ check_path (struct vectors * vecs, struct path * pp, unsigned int ticks)
>  		int oldstate = pp->state;
>  		pp->state = newstate;
>  
> -		LOG_MSG(1, verbosity, pp);
> +		LOG_MSG(1, pp);
>  
>  		/*
>  		 * upon state change, reset the checkint
> @@ -2321,7 +2320,7 @@ check_path (struct vectors * vecs, struct path * pp, unsigned int ticks)
>  			/* Clear IO errors */
>  			reinstate_path(pp);
>  		else {
> -			LOG_MSG(4, verbosity, pp);
> +			LOG_MSG(4, pp);
>  			if (pp->checkint != max_checkint) {
>  				/*
>  				 * double the next check delay.
> @@ -2349,9 +2348,9 @@ check_path (struct vectors * vecs, struct path * pp, unsigned int ticks)
>  			log_checker_err = conf->log_checker_err;
>  			put_multipath_config(conf);
>  			if (log_checker_err == LOG_CHKR_ERR_ONCE)
> -				LOG_MSG(3, verbosity, pp);
> +				LOG_MSG(3, pp);
>  			else
> -				LOG_MSG(2, verbosity, pp);
> +				LOG_MSG(2, pp);
>  		}
>  	}
>  
> @@ -2696,6 +2695,10 @@ reconfigure (struct vectors * vecs)
>  	if (!conf)
>  		return 1;
>  
> +	if (verbosity)
> +		libmp_verbosity = verbosity;
> +	setlogmask(LOG_UPTO(libmp_verbosity + 3));
> +
>  	/*
>  	 * free old map and path vectors ... they use old conf state
>  	 */
> @@ -2710,8 +2713,6 @@ reconfigure (struct vectors * vecs)
>  	/* Re-read any timezone changes */
>  	tzset();
>  
> -	if (verbosity)
> -		conf->verbosity = verbosity;
>  	if (bindings_read_only)
>  		conf->bindings_read_only = bindings_read_only;
>  	check_alias_settings(conf);
> @@ -3091,14 +3092,18 @@ child (__attribute__((unused)) void *param)
>  	condlog(2, "--------start up--------");
>  	condlog(2, "read " DEFAULT_CONFIGFILE);
>  
> +	if (verbosity)
> +		libmp_verbosity = verbosity;
>  	conf = load_config(DEFAULT_CONFIGFILE);
> +	if (verbosity)
> +		libmp_verbosity = verbosity;
> +	setlogmask(LOG_UPTO(libmp_verbosity + 3));
> +
>  	if (!conf) {
>  		condlog(0, "failed to load configuration");
>  		goto failed;
>  	}
>  
> -	if (verbosity)
> -		conf->verbosity = verbosity;
>  	if (bindings_read_only)
>  		conf->bindings_read_only = bindings_read_only;
>  	uxsock_timeout = conf->uxsock_timeout;
> @@ -3117,7 +3122,6 @@ child (__attribute__((unused)) void *param)
>  
>  	if (poll_dmevents)
>  		poll_dmevents = dmevent_poll_supported();
> -	setlogmask(LOG_UPTO(conf->verbosity + 3));
>  
>  	envp = getenv("LimitNOFILE");
>  
> @@ -3339,7 +3343,7 @@ main (int argc, char *argv[])
>  			    !isdigit(optarg[0]))
>  				exit(1);
>  
> -			verbosity = atoi(optarg);
> +			libmp_verbosity = verbosity = atoi(optarg);
>  			break;
>  		case 's':
>  			logsink = -1;
> @@ -3350,7 +3354,7 @@ main (int argc, char *argv[])
>  			if (!conf)
>  				exit(1);
>  			if (verbosity)
> -				conf->verbosity = verbosity;
> +				libmp_verbosity = verbosity;
>  			uxsock_timeout = conf->uxsock_timeout;
>  			err = uxclnt(optarg, uxsock_timeout + 100);
>  			free_config(conf);
> @@ -3376,11 +3380,13 @@ main (int argc, char *argv[])
>  		char * c = s;
>  
>  		logsink = 0;
> +		if (verbosity)
> +			libmp_verbosity = verbosity;
>  		conf = load_config(DEFAULT_CONFIGFILE);
>  		if (!conf)
>  			exit(1);
>  		if (verbosity)
> -			conf->verbosity = verbosity;
> +			libmp_verbosity = verbosity;
>  		uxsock_timeout = conf->uxsock_timeout;
>  		memset(cmd, 0x0, CMDSIZE);
>  		while (optind < argc) {
> diff --git a/tests/alias.c b/tests/alias.c
> index 7fda679..0311faa 100644
> --- a/tests/alias.c
> +++ b/tests/alias.c
> @@ -735,6 +735,7 @@ static int test_allocate_binding(void)
>  int main(void)
>  {
>  	int ret = 0;
> +	libmp_verbosity = conf.verbosity;
>  
>  	ret += test_format_devname();
>  	ret += test_scan_devname();
> diff --git a/tests/blacklist.c b/tests/blacklist.c
> index 84a3ba2..0b42e25 100644
> --- a/tests/blacklist.c
> +++ b/tests/blacklist.c
> @@ -22,6 +22,7 @@
>  #include "globals.c"
>  #include "blacklist.h"
>  #include "test-log.h"
> +#include "debug.h"
>  
>  struct udev_device {
>  	const char *sysname;
> @@ -152,6 +153,7 @@ static int setup(void **state)
>  	    store_ble(blist_property_wwn_inv, "!ID_WWN", ORIGIN_CONFIG))
>  		return -1;
>  
> +	libmp_verbosity = conf.verbosity = 4;
>  	return 0;
>  }
>  
> -- 
> 2.29.0

--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel

