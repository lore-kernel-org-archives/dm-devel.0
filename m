Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B0D12EE0214
	for <dm-devel@archiver.kernel.org>; Wed, 13 Sep 2023 23:14:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1694646894;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=pCGoK2CTSSN30Z7ZIObP5fvkcBF1h6cjVJMPe0FJrgY=;
	b=hO+55GcMe7LQtyBJi6MCOS3wtpWvaSQuaRf12gvBc3MgFBfKUxrgLjx+8qp2YnsXcnxL1N
	+ORjH8zwbEFO+d83Wjmsz3/ImIkQXuVuIpwgzMgHGizIdkjv6VpJZvokY/VBOubH0xdwtt
	MNhFt5uHXT9n4xhyHzmLMgGv9RCZo2o=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-647--KVef0YSOjyUGA5WVOGY8g-1; Wed, 13 Sep 2023 19:14:51 -0400
X-MC-Unique: -KVef0YSOjyUGA5WVOGY8g-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 75B25100DDD5;
	Wed, 13 Sep 2023 23:14:49 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 0F4E440C200B;
	Wed, 13 Sep 2023 23:14:49 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id EAD1D19466E9;
	Wed, 13 Sep 2023 23:14:48 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
 [10.11.54.6])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 4932819465B1
 for <dm-devel@listman.corp.redhat.com>; Wed, 13 Sep 2023 23:14:06 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 323D7200BC7F; Wed, 13 Sep 2023 23:14:06 +0000 (UTC)
Received: from octiron.msp.redhat.com (octiron.msp.redhat.com [10.15.80.209])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id F00322156721;
 Wed, 13 Sep 2023 23:14:05 +0000 (UTC)
Received: from octiron.msp.redhat.com (localhost.localdomain [127.0.0.1])
 by octiron.msp.redhat.com (8.14.9/8.14.9) with ESMTP id 38DNDvrc004705;
 Wed, 13 Sep 2023 18:13:57 -0500
Received: (from bmarzins@localhost)
 by octiron.msp.redhat.com (8.14.9/8.14.9/Submit) id 38DNDvbk004704;
 Wed, 13 Sep 2023 18:13:57 -0500
Date: Wed, 13 Sep 2023 18:13:56 -0500
From: Benjamin Marzinski <bmarzins@redhat.com>
To: mwilck@suse.com
Message-ID: <20230913231356.GH7412@octiron.msp.redhat.com>
References: <20230911163846.27197-1-mwilck@suse.com>
 <20230911163846.27197-38-mwilck@suse.com>
MIME-Version: 1.0
In-Reply-To: <20230911163846.27197-38-mwilck@suse.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.6
Subject: Re: [dm-devel] [PATCH v2 37/37] libmultipath: deprecate
 bindings_file, wwids_file, prkeys_file
X-BeenThere: dm-devel@redhat.com
X-Mailman-Version: 2.1.29
Precedence: list
List-Id: device-mapper development <dm-devel.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/dm-devel>,
 <mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <http://listman.redhat.com/archives/dm-devel/>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/dm-devel>,
 <mailto:dm-devel-request@redhat.com?subject=subscribe>
Cc: dm-devel@redhat.com
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.1
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Mon, Sep 11, 2023 at 06:38:46PM +0200, mwilck@suse.com wrote:
> From: Martin Wilck <mwilck@suse.com>
> 
> The options bindings_file, wwids_file, and prkeys_file have been
> deprecated since cb4d6db ("libmultipath: deprecate file and directory config
> options") (multipath-tools 0.8.8). Deprecate and ignore them now.
> 
Reviewed-by: Benjamin Marzinski <bmarzins@redhat.com>
> Signed-off-by: Martin Wilck <mwilck@suse.com>
> ---
>  libmultipath/alias.c              | 43 +++++++++----------
>  libmultipath/alias.h              |  3 +-
>  libmultipath/config.c             | 18 --------
>  libmultipath/config.h             |  3 --
>  libmultipath/dict.c               | 39 +++---------------
>  libmultipath/libmultipath.version |  8 +---
>  libmultipath/prkey.c              |  7 ++--
>  libmultipath/prkey.h              |  7 ++--
>  libmultipath/propsel.c            |  5 +--
>  libmultipath/wwids.c              | 18 ++------
>  multipath/main.c                  |  2 +-
>  multipath/multipath.conf.5.in     | 23 +++++------
>  multipathd/uxlsnr.c               | 17 +++-----
>  tests/alias.c                     | 68 +++++++++++++++----------------
>  14 files changed, 90 insertions(+), 171 deletions(-)
> 
> diff --git a/libmultipath/alias.c b/libmultipath/alias.c
> index 76ed62d..11130e6 100644
> --- a/libmultipath/alias.c
> +++ b/libmultipath/alias.c
> @@ -55,6 +55,8 @@
>  /* uatomic access only */
>  static int bindings_file_changed = 1;
>  
> +static const char bindings_file_path[] = DEFAULT_BINDINGS_FILE;
> +
>  static pthread_mutex_t timestamp_mutex = PTHREAD_MUTEX_INITIALIZER;
>  static struct timespec bindings_last_updated;
>  
> @@ -273,7 +275,6 @@ static int write_bindings_file(const Bindings *bindings, int fd,
>  
>  void handle_bindings_file_inotify(const struct inotify_event *event)
>  {
> -	struct config *conf;
>  	const char *base;
>  	bool changed = false;
>  	struct stat st;
> @@ -283,12 +284,9 @@ void handle_bindings_file_inotify(const struct inotify_event *event)
>  	if (!(event->mask & IN_MOVED_TO))
>  		return;
>  
> -	conf = get_multipath_config();
> -	base = strrchr(conf->bindings_file, '/');
> -	changed = base && base > conf->bindings_file &&
> -		!strcmp(base + 1, event->name);
> -	ret = stat(conf->bindings_file, &st);
> -	put_multipath_config(conf);
> +	base = strrchr(bindings_file_path, '/');
> +	changed = base && !strcmp(base + 1, event->name);
> +	ret = stat(bindings_file_path, &st);
>  
>  	if (!changed)
>  		return;
> @@ -309,8 +307,7 @@ void handle_bindings_file_inotify(const struct inotify_event *event)
>  			__func__, (long)ts.tv_sec, (long)ts.tv_nsec / 1000);
>  }
>  
> -static int update_bindings_file(const Bindings *bindings,
> -				const char *bindings_file)
> +static int update_bindings_file(const Bindings *bindings)
>  {
>  	int rc;
>  	int fd = -1;
> @@ -318,7 +315,7 @@ static int update_bindings_file(const Bindings *bindings,
>  	mode_t old_umask;
>  	struct timespec ts;
>  
> -	if (safe_sprintf(tempname, "%s.XXXXXX", bindings_file))
> +	if (safe_sprintf(tempname, "%s.XXXXXX", bindings_file_path))
>  		return -1;
>  	/* coverity: SECURE_TEMP */
>  	old_umask = umask(0077);
> @@ -335,10 +332,10 @@ static int update_bindings_file(const Bindings *bindings,
>  		unlink(tempname);
>  		return rc;
>  	}
> -	if ((rc = rename(tempname, bindings_file)) == -1)
> +	if ((rc = rename(tempname, bindings_file_path)) == -1)
>  		condlog(0, "%s: rename: %m", __func__);
>  	else {
> -		condlog(1, "updated bindings file %s", bindings_file);
> +		condlog(1, "updated bindings file %s", bindings_file_path);
>  		pthread_mutex_lock(&timestamp_mutex);
>  		bindings_last_updated = ts;
>  		pthread_mutex_unlock(&timestamp_mutex);
> @@ -473,7 +470,7 @@ int get_free_id(const Bindings *bindings, const char *prefix, const char *map_ww
>  
>  /* Called with binding_mutex held */
>  static char *
> -allocate_binding(const char *filename, const char *wwid, int id, const char *prefix)
> +allocate_binding(const char *wwid, int id, const char *prefix)
>  {
>  	STRBUF_ON_STACK(buf);
>  	char *alias;
> @@ -497,7 +494,7 @@ allocate_binding(const char *filename, const char *wwid, int id, const char *pre
>  		return NULL;
>  	}
>  
> -	if (update_bindings_file(&global_bindings, filename) == -1) {
> +	if (update_bindings_file(&global_bindings) == -1) {
>  		condlog(1, "%s: deleting binding %s for %s", __func__, alias, wwid);
>  		delete_binding(&global_bindings, wwid);
>  		free(alias);
> @@ -564,7 +561,7 @@ static void read_bindings_file(void)
>   *    that the mpvec corrcectly represents kernel state.
>   */
>  
> -char *get_user_friendly_alias(const char *wwid, const char *file, const char *alias_old,
> +char *get_user_friendly_alias(const char *wwid, const char *alias_old,
>  			      const char *prefix, bool bindings_read_only)
>  {
>  	char *alias = NULL;
> @@ -621,7 +618,7 @@ new_alias:
>  	}
>  
>  	if (!bindings_read_only && id > 0)
> -		alias = allocate_binding(file, wwid, id, prefix);
> +		alias = allocate_binding(wwid, id, prefix);
>  
>  	if (alias && !new_binding)
>  		condlog(2, "Allocated existing binding [%s] for WWID [%s]",
> @@ -713,12 +710,12 @@ static int _check_bindings_file(const struct config *conf, FILE *file,
>  	if (fread(header, sizeof(BINDINGS_FILE_HEADER) - 1, 1, file)
>  	    < sizeof(BINDINGS_FILE_HEADER)  - 1) {
>  		condlog(2, "%s: failed to read header from %s", __func__,
> -			conf->bindings_file);
> +			bindings_file_path);
>  		fseek(file, 0, SEEK_SET);
>  		rc = -1;
>  	} else if (strcmp(header, BINDINGS_FILE_HEADER)) {
>  		condlog(2, "%s: invalid header in %s", __func__,
> -			conf->bindings_file);
> +			bindings_file_path);
>  		fseek(file, 0, SEEK_SET);
>  		rc = -1;
>  	}
> @@ -785,13 +782,13 @@ static int _read_bindings_file(const struct config *conf, Bindings *bindings,
>  		}
>  	}
>  
> -	fd = open_file(conf->bindings_file, &can_write, BINDINGS_FILE_HEADER);
> +	fd = open_file(bindings_file_path, &can_write, BINDINGS_FILE_HEADER);
>  	if (fd == -1)
>  		return BINDINGS_FILE_ERROR;
>  
>  	file = fdopen(fd, "r");
>  	if (file != NULL) {
> -		condlog(3, "%s: reading %s", __func__, conf->bindings_file);
> +		condlog(3, "%s: reading %s", __func__, bindings_file_path);
>  
>  		pthread_cleanup_push(cleanup_fclose, file);
>  		ret = _check_bindings_file(conf, file, bindings);
> @@ -810,20 +807,20 @@ static int _read_bindings_file(const struct config *conf, Bindings *bindings,
>  			bindings_last_updated = ts;
>  			pthread_mutex_unlock(&timestamp_mutex);
>  		} else if (ret == -1 && can_write && !conf->bindings_read_only) {
> -			ret = update_bindings_file(bindings, conf->bindings_file);
> +			ret = update_bindings_file(bindings);
>  			if (ret == 0)
>  				rc = BINDINGS_FILE_READ;
>  			else
>  				rc = BINDINGS_FILE_BAD;
>  		} else if (ret == -1) {
>  			condlog(0, "ERROR: bad settings in read-only bindings file %s",
> -				conf->bindings_file);
> +				bindings_file_path);
>  			rc = BINDINGS_FILE_BAD;
>  		}
>  		pthread_cleanup_pop(1);
>  	} else {
>  		condlog(1, "failed to fdopen %s: %m",
> -			conf->bindings_file);
> +			bindings_file_path);
>  		close(fd);
>  		rc = BINDINGS_FILE_ERROR;
>  	}
> diff --git a/libmultipath/alias.h b/libmultipath/alias.h
> index ca8911f..629e8d5 100644
> --- a/libmultipath/alias.h
> +++ b/libmultipath/alias.h
> @@ -3,8 +3,7 @@
>  
>  int valid_alias(const char *alias);
>  int get_user_friendly_wwid(const char *alias, char *buff);
> -char *get_user_friendly_alias(const char *wwid, const char *file,
> -			      const char *alias_old,
> +char *get_user_friendly_alias(const char *wwid, const char *alias_old,
>  			      const char *prefix, bool bindings_read_only);
>  
>  struct config;
> diff --git a/libmultipath/config.c b/libmultipath/config.c
> index 7b20759..b7dbc6f 100644
> --- a/libmultipath/config.c
> +++ b/libmultipath/config.c
> @@ -752,15 +752,6 @@ static void _uninit_config(struct config *conf)
>  	if (conf->hwhandler)
>  		free(conf->hwhandler);
>  
> -	if (conf->bindings_file)
> -		free(conf->bindings_file);
> -
> -	if (conf->wwids_file)
> -		free(conf->wwids_file);
> -
> -	if (conf->prkeys_file)
> -		free(conf->prkeys_file);
> -
>  	if (conf->prio_name)
>  		free(conf->prio_name);
>  
> @@ -922,9 +913,6 @@ int _init_config (const char *file, struct config *conf)
>  	 * internal defaults
>  	 */
>  	get_sys_max_fds(&conf->max_fds);
> -	conf->bindings_file = set_default(DEFAULT_BINDINGS_FILE);
> -	conf->wwids_file = set_default(DEFAULT_WWIDS_FILE);
> -	conf->prkeys_file = set_default(DEFAULT_PRKEYS_FILE);
>  	conf->attribute_flags = 0;
>  	conf->reassign_maps = DEFAULT_REASSIGN_MAPS;
>  	conf->checkint = CHECKINT_UNDEF;
> @@ -1078,12 +1066,6 @@ int _init_config (const char *file, struct config *conf)
>  	merge_blacklist(conf->elist_wwid);
>  	merge_blacklist_device(conf->elist_device);
>  
> -	if (conf->bindings_file == NULL)
> -		conf->bindings_file = set_default(DEFAULT_BINDINGS_FILE);
> -
> -	if (!conf->bindings_file || !conf->wwids_file || !conf->prkeys_file)
> -		goto out;
> -
>  	libmp_verbosity = conf->verbosity;
>  	return 0;
>  out:
> diff --git a/libmultipath/config.h b/libmultipath/config.h
> index 0a2c297..8c22ce7 100644
> --- a/libmultipath/config.h
> +++ b/libmultipath/config.h
> @@ -207,9 +207,6 @@ struct config {
>  	char * uid_attribute;
>  	char * features;
>  	char * hwhandler;
> -	char * bindings_file;
> -	char * wwids_file;
> -	char * prkeys_file;
>  	char * prio_name;
>  	char * prio_args;
>  	char * checker_name;
> diff --git a/libmultipath/dict.c b/libmultipath/dict.c
> index dace343..044067a 100644
> --- a/libmultipath/dict.c
> +++ b/libmultipath/dict.c
> @@ -168,27 +168,6 @@ fail:
>  	return 0;
>  }
>  
> -static int
> -set_path(vector strvec, void *ptr, const char *file, int line_nr)
> -{
> -	char **str_ptr = (char **)ptr;
> -	char *old_str = *str_ptr;
> -
> -	*str_ptr = set_value(strvec);
> -	if (!*str_ptr) {
> -		free(old_str);
> -		return 1;
> -	}
> -	if ((*str_ptr)[0] != '/'){
> -		condlog(1, "%s line %d, %s is not an absolute path. Ignoring",
> -			file, line_nr, *str_ptr);
> -		free(*str_ptr);
> -		*str_ptr = old_str;
> -	} else
> -		free(old_str);
> -	return 0;
> -}
> -
>  static int
>  set_str_noslash(vector strvec, void *ptr, const char *file, int line_nr)
>  {
> @@ -831,15 +810,6 @@ declare_hw_snprint(user_friendly_names, print_yes_no_undef)
>  declare_mp_handler(user_friendly_names, set_yes_no_undef)
>  declare_mp_snprint(user_friendly_names, print_yes_no_undef)
>  
> -declare_def_warn_handler(bindings_file, set_path)
> -declare_def_snprint(bindings_file, print_str)
> -
> -declare_def_warn_handler(wwids_file, set_path)
> -declare_def_snprint(wwids_file, print_str)
> -
> -declare_def_warn_handler(prkeys_file, set_path)
> -declare_def_snprint(prkeys_file, print_str)
> -
>  declare_def_handler(retain_hwhandler, set_yes_no_undef)
>  declare_def_snprint_defint(retain_hwhandler, print_yes_no_undef,
>  			   DEFAULT_RETAIN_HWHANDLER)
> @@ -2064,6 +2034,9 @@ declare_deprecated_handler(disable_changed_wwids, "yes")
>  declare_deprecated_handler(getuid_callout, "(not set)")
>  declare_deprecated_handler(multipath_dir, MULTIPATH_DIR)
>  declare_deprecated_handler(pg_timeout, "(not set)")
> +declare_deprecated_handler(bindings_file, DEFAULT_BINDINGS_FILE)
> +declare_deprecated_handler(wwids_file, DEFAULT_WWIDS_FILE)
> +declare_deprecated_handler(prkeys_file, DEFAULT_PRKEYS_FILE)
>  
>  /*
>   * If you add or remove a keyword also update multipath/multipath.conf.5
> @@ -2106,9 +2079,9 @@ init_keywords(vector keywords)
>  	install_keyword("fast_io_fail_tmo", &def_fast_io_fail_handler, &snprint_def_fast_io_fail);
>  	install_keyword("dev_loss_tmo", &def_dev_loss_handler, &snprint_def_dev_loss);
>  	install_keyword("eh_deadline", &def_eh_deadline_handler, &snprint_def_eh_deadline);
> -	install_keyword("bindings_file", &def_bindings_file_handler, &snprint_def_bindings_file);
> -	install_keyword("wwids_file", &def_wwids_file_handler, &snprint_def_wwids_file);
> -	install_keyword("prkeys_file", &def_prkeys_file_handler, &snprint_def_prkeys_file);
> +	install_keyword("bindings_file", &deprecated_bindings_file_handler, &snprint_deprecated);
> +	install_keyword("wwids_file", &deprecated_wwids_file_handler, &snprint_deprecated);
> +	install_keyword("prkeys_file", &deprecated_prkeys_file_handler, &snprint_deprecated);
>  	install_keyword("log_checker_err", &def_log_checker_err_handler, &snprint_def_log_checker_err);
>  	install_keyword("reservation_key", &def_reservation_key_handler, &snprint_def_reservation_key);
>  	install_keyword("all_tg_pt", &def_all_tg_pt_handler, &snprint_def_all_tg_pt);
> diff --git a/libmultipath/libmultipath.version b/libmultipath/libmultipath.version
> index 57e50c1..8368ef7 100644
> --- a/libmultipath/libmultipath.version
> +++ b/libmultipath/libmultipath.version
> @@ -43,7 +43,7 @@ LIBMPATHCOMMON_1.0.0 {
>  	put_multipath_config;
>  };
>  
> -LIBMULTIPATH_20.0.0 {
> +LIBMULTIPATH_21.0.0 {
>  global:
>  	/* symbols referenced by multipath and multipathd */
>  	add_foreign;
> @@ -121,6 +121,7 @@ global:
>  	get_used_hwes;
>  	get_vpd_sgio;
>  	group_by_prio;
> +	handle_bindings_file_inotify;
>  	has_dm_info;
>  	init_checkers;
>  	init_config;
> @@ -238,8 +239,3 @@ global:
>  local:
>  	*;
>  };
> -
> -LIBMULTIPATH_20.1.0 {
> -global:
> -	handle_bindings_file_inotify;
> -};
> diff --git a/libmultipath/prkey.c b/libmultipath/prkey.c
> index a215499..c66d293 100644
> --- a/libmultipath/prkey.c
> +++ b/libmultipath/prkey.c
> @@ -157,8 +157,7 @@ static int do_prkey(int fd, char *wwid, char *keystr, int cmd)
>  	return 0;
>  }
>  
> -int get_prkey(struct config *conf, struct multipath *mpp, uint64_t *prkey,
> -	      uint8_t *sa_flags)
> +int get_prkey(struct multipath *mpp, uint64_t *prkey, uint8_t *sa_flags)
>  {
>  	int fd;
>  	int unused;
> @@ -168,7 +167,7 @@ int get_prkey(struct config *conf, struct multipath *mpp, uint64_t *prkey,
>  	if (!strlen(mpp->wwid))
>  		goto out;
>  
> -	fd = open_file(conf->prkeys_file, &unused, PRKEYS_FILE_HEADER);
> +	fd = open_file(DEFAULT_PRKEYS_FILE, &unused, PRKEYS_FILE_HEADER);
>  	if (fd < 0)
>  		goto out;
>  	ret = do_prkey(fd, mpp->wwid, keystr, PRKEY_READ);
> @@ -201,7 +200,7 @@ int set_prkey(struct config *conf, struct multipath *mpp, uint64_t prkey,
>  		sa_flags &= MPATH_F_APTPL_MASK;
>  	}
>  
> -	fd = open_file(conf->prkeys_file, &can_write, PRKEYS_FILE_HEADER);
> +	fd = open_file(DEFAULT_PRKEYS_FILE, &can_write, PRKEYS_FILE_HEADER);
>  	if (fd < 0)
>  		goto out;
>  	if (!can_write) {
> diff --git a/libmultipath/prkey.h b/libmultipath/prkey.h
> index a16de10..43afd5e 100644
> --- a/libmultipath/prkey.h
> +++ b/libmultipath/prkey.h
> @@ -16,9 +16,8 @@
>  int print_reservation_key(struct strbuf *buff,
>  			  struct be64 key, uint8_t flags, int source);
>  int parse_prkey_flags(const char *ptr, uint64_t *prkey, uint8_t *flags);
> -int set_prkey(struct config *conf, struct multipath *mpp, uint64_t prkey,
> -	      uint8_t sa_flags);
> -int get_prkey(struct config *conf, struct multipath *mpp, uint64_t *prkey,
> -	      uint8_t *sa_flags);
> +int set_prkey(struct config *conf, struct multipath *mpp,
> +	      uint64_t prkey, uint8_t sa_flags);
> +int get_prkey(struct multipath *mpp, uint64_t *prkey, uint8_t *sa_flags);
>  
>  #endif /* _PRKEY_H */
> diff --git a/libmultipath/propsel.c b/libmultipath/propsel.c
> index 354e883..44241e2 100644
> --- a/libmultipath/propsel.c
> +++ b/libmultipath/propsel.c
> @@ -401,8 +401,7 @@ int select_alias(struct config *conf, struct multipath * mp)
>  
>  	select_alias_prefix(conf, mp);
>  
> -	mp->alias = get_user_friendly_alias(mp->wwid, conf->bindings_file,
> -					    mp->alias_old, mp->alias_prefix,
> +	mp->alias = get_user_friendly_alias(mp->wwid, mp->alias_old, mp->alias_prefix,
>  					    conf->bindings_read_only);
>  
>  	if (mp->alias && !strncmp(mp->alias, mp->alias_old, WWID_SIZE))
> @@ -992,7 +991,7 @@ int select_reservation_key(struct config *conf, struct multipath *mp)
>  out:
>  	if (mp->prkey_source == PRKEY_SOURCE_FILE) {
>  		from_file = " (from prkeys file)";
> -		if (get_prkey(conf, mp, &prkey, &mp->sa_flags) != 0)
> +		if (get_prkey(mp, &prkey, &mp->sa_flags) != 0)
>  			put_be64(mp->reservation_key, 0);
>  		else
>  			put_be64(mp->reservation_key, prkey);
> diff --git a/libmultipath/wwids.c b/libmultipath/wwids.c
> index 89bb60c..591cd09 100644
> --- a/libmultipath/wwids.c
> +++ b/libmultipath/wwids.c
> @@ -94,12 +94,8 @@ replace_wwids(vector mp)
>  	struct multipath * mpp;
>  	size_t len;
>  	int ret = -1;
> -	struct config *conf;
>  
> -	conf = get_multipath_config();
> -	pthread_cleanup_push(put_multipath_config, conf);
> -	fd = open_file(conf->wwids_file, &can_write, WWIDS_FILE_HEADER);
> -	pthread_cleanup_pop(1);
> +	fd = open_file(DEFAULT_WWIDS_FILE, &can_write, WWIDS_FILE_HEADER);
>  	if (fd < 0)
>  		goto out;
>  
> @@ -200,7 +196,6 @@ remove_wwid(char *wwid) {
>  	int len, can_write;
>  	char *str;
>  	int ret = -1;
> -	struct config *conf;
>  
>  	len = strlen(wwid) + 4; /* two slashes the newline and a zero byte */
>  	str = malloc(len);
> @@ -216,10 +211,7 @@ remove_wwid(char *wwid) {
>  		goto out;
>  	}
>  	condlog(3, "removing line '%s' from wwids file", str);
> -	conf = get_multipath_config();
> -	pthread_cleanup_push(put_multipath_config, conf);
> -	fd = open_file(conf->wwids_file, &can_write, WWIDS_FILE_HEADER);
> -	pthread_cleanup_pop(1);
> +	fd = open_file(DEFAULT_WWIDS_FILE, &can_write, WWIDS_FILE_HEADER);
>  
>  	if (fd < 0) {
>  		ret = -1;
> @@ -244,12 +236,8 @@ check_wwids_file(char *wwid, int write_wwid)
>  {
>  	int fd, can_write, found, ret;
>  	FILE *f;
> -	struct config *conf;
>  
> -	conf = get_multipath_config();
> -	pthread_cleanup_push(put_multipath_config, conf);
> -	fd = open_file(conf->wwids_file, &can_write, WWIDS_FILE_HEADER);
> -	pthread_cleanup_pop(1);
> +	fd = open_file(DEFAULT_WWIDS_FILE, &can_write, WWIDS_FILE_HEADER);
>  	if (fd < 0)
>  		return -1;
>  
> diff --git a/multipath/main.c b/multipath/main.c
> index b91289e..9e1c505 100644
> --- a/multipath/main.c
> +++ b/multipath/main.c
> @@ -856,7 +856,7 @@ main (int argc, char *argv[])
>  			libmp_verbosity = atoi(optarg);
>  			break;
>  		case 'b':
> -			conf->bindings_file = strdup(optarg);
> +			condlog(1, "option -b ignored");
>  			break;
>  		case 'B':
>  			conf->bindings_read_only = 1;
> diff --git a/multipath/multipath.conf.5.in b/multipath/multipath.conf.5.in
> index 20df223..d320a88 100644
> --- a/multipath/multipath.conf.5.in
> +++ b/multipath/multipath.conf.5.in
> @@ -794,35 +794,28 @@ The default is: \fB<unset>\fR
>  .
>  .TP
>  .B bindings_file
> -(Deprecated) This option is deprecated, and will be removed in a future release.
> -The full pathname of the binding file to be used when the user_friendly_names
> -option is set.
> +(Deprecated) This option is not supported any more, and will be ignored.
>  .RS
>  .TP
> -The default is: \fB@STATE_DIR@/bindings\fR
> +The compiled-in value is: \fB@STATE_DIR@/bindings\fR
>  .RE
>  .
>  .
>  .TP
>  .B wwids_file
> -(Deprecated) This option is deprecated, and will be removed in a future release.
> -The full pathname of the WWIDs file, which is used by multipath to keep track
> -of the WWIDs for LUNs it has created multipath devices on in the past.
> +(Deprecated) This option is not supported any more, and will be ignored.
>  .RS
>  .TP
> -The default is: \fB@STATE_DIR@/wwids\fR
> +The compiled-in value is: \fB@STATE_DIR@/wwids\fR
>  .RE
>  .
>  .
>  .TP
>  .B prkeys_file
> -(Deprecated) This option is deprecated, and will be removed in a future release.
> -The full pathname of the prkeys file, which is used by multipathd to keep
> -track of the persistent reservation key used for a specific WWID, when
> -\fIreservation_key\fR is set to \fBfile\fR.
> +(Deprecated) This option is not supported any more, and will be ignored.
>  .RS
>  .TP
> -The default is: \fB@STATE_DIR@/prkeys\fR
> +The compiled-in value is: \fB@STATE_DIR@/prkeys\fR
>  .RE
>  .
>  .
> @@ -989,6 +982,10 @@ The default is: \fB<unset>\fR
>  .TP
>  .B config_dir
>  (Deprecated) This option is not supported any more, and the value is ignored.
> +.RS
> +.TP
> +The compiled-in value is: \fB@CONFIGDIR@\fR
> +.RE
>  .
>  .
>  .TP
> diff --git a/multipathd/uxlsnr.c b/multipathd/uxlsnr.c
> index d1f8f23..4d6f258 100644
> --- a/multipathd/uxlsnr.c
> +++ b/multipathd/uxlsnr.c
> @@ -203,7 +203,6 @@ static void reset_watch(int notify_fd, struct watch_descriptors *wds,
>  	int dir_reset = 0;
>  	int conf_reset = 0;
>  	int mp_reset = 0;
> -	char *bindings_file __attribute__((cleanup(cleanup_charp))) = NULL;
>  
>  	if (notify_fd == -1)
>  		return;
> @@ -221,7 +220,6 @@ static void reset_watch(int notify_fd, struct watch_descriptors *wds,
>  		if (wds->mp_wd == -1)
>  			mp_reset = 1;
>  	}
> -	bindings_file = strdup(conf->bindings_file);
>  	put_multipath_config(conf);
>  
>  	if (dir_reset) {
> @@ -242,17 +240,12 @@ static void reset_watch(int notify_fd, struct watch_descriptors *wds,
>  		if (wds->conf_wd == -1)
>  			condlog(3, "didn't set up notifications on /etc/multipath.conf: %m");
>  	}
> -	if (mp_reset && bindings_file) {
> -		char *slash = strrchr(bindings_file, '/');
> -
> -		if (slash && slash > bindings_file) {
> -			*slash = '\0';
> -			wds->mp_wd = inotify_add_watch(notify_fd, bindings_file,
> -						       IN_MOVED_TO|IN_ONLYDIR);
> -			if (wds->mp_wd == -1)
> +	if (mp_reset) {
> +		wds->mp_wd = inotify_add_watch(notify_fd, STATE_DIR,
> +					       IN_MOVED_TO|IN_ONLYDIR);
> +		if (wds->mp_wd == -1)
>  				condlog(3, "didn't set up notifications on %s: %m",
> -					bindings_file);
> -		}
> +					STATE_DIR);
>  	}
>  }
>  
> diff --git a/tests/alias.c b/tests/alias.c
> index 962c158..feca325 100644
> --- a/tests/alias.c
> +++ b/tests/alias.c
> @@ -1264,10 +1264,10 @@ static void al_a(void **state)
>  	will_return(__wrap_write, ln);
>  	will_return(__wrap_write, strlen(BINDINGS_FILE_HEADER) + strlen(ln));
>  	will_return(__wrap_rename, 0);
> -	expect_condlog(1, "updated bindings file foo");
> +	expect_condlog(1, "updated bindings file " DEFAULT_BINDINGS_FILE);
>  	expect_condlog(3, NEW_STR("MPATHa", "WWIDa"));
>  
> -	alias = allocate_binding("foo", "WWIDa", 1, "MPATH");
> +	alias = allocate_binding("WWIDa", 1, "MPATH");
>  	assert_ptr_not_equal(alias, NULL);
>  	assert_string_equal(alias, "MPATHa");
>  	check_bindings_size(1);
> @@ -1283,10 +1283,10 @@ static void al_zz(void **state)
>  	will_return(__wrap_write, ln);
>  	will_return(__wrap_write, strlen(BINDINGS_FILE_HEADER) + strlen(ln));
>  	will_return(__wrap_rename, 0);
> -	expect_condlog(1, "updated bindings file foo");
> +	expect_condlog(1, "updated bindings file " DEFAULT_BINDINGS_FILE);
>  	expect_condlog(3, NEW_STR("MPATHzz", "WWIDzz"));
>  
> -	alias = allocate_binding("foo", "WWIDzz", 26*26 + 26, "MPATH");
> +	alias = allocate_binding("WWIDzz", 26*26 + 26, "MPATH");
>  	assert_ptr_not_equal(alias, NULL);
>  	assert_string_equal(alias, "MPATHzz");
>  	check_bindings_size(1);
> @@ -1298,7 +1298,7 @@ static void al_0(void **state)
>  	char *alias;
>  
>  	expect_condlog(0, "allocate_binding: cannot allocate new binding for id 0\n");
> -	alias = allocate_binding(0, "WWIDa", 0, "MPATH");
> +	alias = allocate_binding("WWIDa", 0, "MPATH");
>  	assert_ptr_equal(alias, NULL);
>  	check_bindings_size(0);
>  }
> @@ -1308,7 +1308,7 @@ static void al_m2(void **state)
>  	char *alias;
>  
>  	expect_condlog(0, "allocate_binding: cannot allocate new binding for id -2\n");
> -	alias = allocate_binding(0, "WWIDa", -2, "MPATH");
> +	alias = allocate_binding("WWIDa", -2, "MPATH");
>  	assert_ptr_equal(alias, NULL);
>  	check_bindings_size(0);
>  }
> @@ -1325,10 +1325,10 @@ static void al_write_partial(void **state)
>  	will_return(__wrap_write, ln + sizeof(ln) - 2);
>  	will_return(__wrap_write, 1);
>  	will_return(__wrap_rename, 0);
> -	expect_condlog(1, "updated bindings file foo");
> +	expect_condlog(1, "updated bindings file " DEFAULT_BINDINGS_FILE);
>  	expect_condlog(3, "Created new binding [MPATHa] for WWID [WWIDa]\n");
>  
> -	alias = allocate_binding("foo", "WWIDa", 1, "MPATH");
> +	alias = allocate_binding("WWIDa", 1, "MPATH");
>  	assert_ptr_not_equal(alias, NULL);
>  	assert_string_equal(alias, "MPATHa");
>  	check_bindings_size(1);
> @@ -1350,7 +1350,7 @@ static void al_write_short(void **state)
>  	expect_condlog(1, "failed to write new bindings file");
>  	expect_condlog(1, "allocate_binding: deleting binding MPATHa for WWIDa");
>  
> -	alias = allocate_binding("foo", "WWIDa", 1, "MPATH");
> +	alias = allocate_binding("WWIDa", 1, "MPATH");
>  	assert_ptr_equal(alias, NULL);
>  	check_bindings_size(0);
>  }
> @@ -1366,7 +1366,7 @@ static void al_write_err(void **state)
>  	expect_condlog(1, "failed to write new bindings file");
>  	expect_condlog(1, "allocate_binding: deleting binding MPATHa for WWIDa");
>  
> -	alias = allocate_binding("foo", "WWIDa", 1, "MPATH");
> +	alias = allocate_binding("WWIDa", 1, "MPATH");
>  	assert_ptr_equal(alias, NULL);
>  	check_bindings_size(0);
>  }
> @@ -1383,7 +1383,7 @@ static void al_rename_err(void **state)
>  
>  	expect_condlog(0, "update_bindings_file: rename: Read-only file system");
>  	expect_condlog(1, "allocate_binding: deleting binding MPATHa for WWIDa");
> -	alias = allocate_binding("foo", "WWIDa", 1, "MPATH");
> +	alias = allocate_binding("WWIDa", 1, "MPATH");
>  	assert_ptr_equal(alias, NULL);
>  	check_bindings_size(0);
>  }
> @@ -1415,7 +1415,7 @@ static int test_allocate_binding(void)
>  			    strlen(BINDINGS_FILE_HEADER) + (len) + strlen(ln)); \
>  		will_return(__wrap_rename, err);			\
>  		if (err == 0) {						\
> -			expect_condlog(1, "updated bindings file x\n");	\
> +			expect_condlog(1, "updated bindings file " DEFAULT_BINDINGS_FILE);	\
>  			expect_condlog(3, NEW_STR(alias, wwid));	\
>  		} else {						\
>  			expect_condlog(0, "update_bindings_file: rename: " msg "\n"); \
> @@ -1441,7 +1441,7 @@ static void gufa_empty_new_rw(void **state) {
>  	expect_condlog(3, NOMATCH_WWID_STR("WWID0"));
>  
>  	mock_allocate_binding("MPATHa", "WWID0");
> -	alias = get_user_friendly_alias("WWID0", "x", "", "MPATH", false);
> +	alias = get_user_friendly_alias("WWID0", "", "MPATH", false);
>  	assert_string_equal(alias, "MPATHa");
>  	free(alias);
>  }
> @@ -1454,7 +1454,7 @@ static void gufa_empty_new_ro_1(void **state) {
>  	expect_condlog(3, NOMATCH_WWID_STR("WWID0"));
>  	mock_allocate_binding_err("MPATHa", "WWID0", -EROFS, "Read-only file system");
>  
> -	alias = get_user_friendly_alias("WWID0", "x", "", "MPATH", false);
> +	alias = get_user_friendly_alias("WWID0", "", "MPATH", false);
>  	assert_ptr_equal(alias, NULL);
>  }
>  
> @@ -1465,7 +1465,7 @@ static void gufa_empty_new_ro_2(void **state) {
>  	expect_condlog(3, NOMATCH_WWID_STR("WWID0"));
>  	mock_unused_alias("MPATHa");
>  
> -	alias = get_user_friendly_alias("WWID0", "x", "", "MPATH", true);
> +	alias = get_user_friendly_alias("WWID0", "", "MPATH", true);
>  	assert_ptr_equal(alias, NULL);
>  }
>  
> @@ -1477,7 +1477,7 @@ static void gufa_match_a_unused(void **state) {
>  	mock_unused_alias("MPATHa");
>  	expect_condlog(3, EXISTING_STR("MPATHa", "WWID0"));
>  
> -	alias = get_user_friendly_alias("WWID0", "x", "", "MPATH", true);
> +	alias = get_user_friendly_alias("WWID0", "", "MPATH", true);
>  	assert_string_equal(alias, "MPATHa");
>  	free(alias);
>  }
> @@ -1490,7 +1490,7 @@ static void gufa_match_a_self(void **state) {
>  	mock_self_alias("MPATHa", "WWID0");
>  	expect_condlog(3, EXISTING_STR("MPATHa", "WWID0"));
>  
> -	alias = get_user_friendly_alias("WWID0", "x", "", "MPATH", true);
> +	alias = get_user_friendly_alias("WWID0", "", "MPATH", true);
>  	assert_string_equal(alias, "MPATHa");
>  	free(alias);
>  }
> @@ -1503,7 +1503,7 @@ static void gufa_match_a_used(void **state) {
>  	expect_condlog(3, FOUND_STR("MPATHa", "WWID0"));
>  	mock_used_alias("MPATHa", "WWID0");
>  
> -	alias = get_user_friendly_alias("WWID0", "x", "", "MPATH", true);
> +	alias = get_user_friendly_alias("WWID0", "", "MPATH", true);
>  	assert_ptr_equal(alias, NULL);
>  }
>  
> @@ -1518,7 +1518,7 @@ static void gufa_nomatch_a_c(void **state) {
>  
>  	mock_allocate_binding_len("MPATHb", "WWID1", strlen(bindings));
>  
> -	alias = get_user_friendly_alias("WWID1", "x", "", "MPATH", false);
> +	alias = get_user_friendly_alias("WWID1", "", "MPATH", false);
>  	assert_string_equal(alias, "MPATHb");
>  	free(alias);
>  }
> @@ -1534,7 +1534,7 @@ static void gufa_nomatch_c_a(void **state) {
>  
>  	mock_allocate_binding_len("MPATHb", "WWID1", sizeof(bindings) - 1);
>  
> -	alias = get_user_friendly_alias("WWID1", "x", "", "MPATH", false);
> +	alias = get_user_friendly_alias("WWID1", "", "MPATH", false);
>  	assert_string_equal(alias, "MPATHb");
>  	free(alias);
>  }
> @@ -1550,7 +1550,7 @@ static void gufa_nomatch_c_b(void **state) {
>  
>  	mock_allocate_binding_len("MPATHa", "WWID0", sizeof(bindings) - 1);
>  
> -	alias = get_user_friendly_alias("WWID0", "x", "", "MPATH", false);
> +	alias = get_user_friendly_alias("WWID0", "", "MPATH", false);
>  	assert_string_equal(alias, "MPATHa");
>  	free(alias);
>  }
> @@ -1567,7 +1567,7 @@ static void gufa_nomatch_c_b_used(void **state) {
>  
>  	mock_allocate_binding_len("MPATHd", "WWID4", sizeof(bindings) - 1);
>  
> -	alias = get_user_friendly_alias("WWID4", "x", "", "MPATH", false);
> +	alias = get_user_friendly_alias("WWID4", "", "MPATH", false);
>  	assert_string_equal(alias, "MPATHd");
>  	free(alias);
>  }
> @@ -1584,7 +1584,7 @@ static void gufa_nomatch_b_f_a(void **state) {
>  
>  	mock_allocate_binding_len("MPATHc", "WWID7", sizeof(bindings) - 1);
>  
> -	alias = get_user_friendly_alias("WWID7", "x", "", "MPATH", false);
> +	alias = get_user_friendly_alias("WWID7", "", "MPATH", false);
>  	assert_string_equal(alias, "MPATHc");
>  	free(alias);
>  }
> @@ -1599,7 +1599,7 @@ static void gufa_nomatch_b_aa_a(void **state) {
>  	mock_unused_alias("MPATHab");
>  	mock_allocate_binding_len("MPATHab", "WWID28", get_strbuf_len(&buf));
>  
> -	alias = get_user_friendly_alias("WWID28", "x", "", "MPATH", false);
> +	alias = get_user_friendly_alias("WWID28", "", "MPATH", false);
>  	assert_string_equal(alias, "MPATHab");
>  	free(alias);
>  }
> @@ -1616,7 +1616,7 @@ static void gufa_nomatch_b_f_a_sorted(void **state) {
>  
>  	mock_allocate_binding_len("MPATHc", "WWID7", sizeof(bindings) - 1);
>  
> -	alias = get_user_friendly_alias("WWID7", "x", "", "MPATH", false);
> +	alias = get_user_friendly_alias("WWID7", "", "MPATH", false);
>  	assert_string_equal(alias, "MPATHc");
>  	free(alias);
>  }
> @@ -1632,7 +1632,7 @@ static void gufa_old_empty(void **state) {
>  	mock_allocate_binding("MPATHz", "WWID0");
>  	expect_condlog(2, ALLOC_STR("MPATHz", "WWID0"));
>  
> -	alias = get_user_friendly_alias("WWID0", "x", "MPATHz", "MPATH", false);
> +	alias = get_user_friendly_alias("WWID0", "MPATHz", "MPATH", false);
>  	assert_string_equal(alias, "MPATHz");
>  	free(alias);
>  }
> @@ -1644,7 +1644,7 @@ static void gufa_old_match(void **state) {
>  			   "MPATHz WWID0");
>  	expect_condlog(3, FOUND_ALIAS_STR("MPATHz", "WWID0"));
>  
> -	alias = get_user_friendly_alias("WWID0", "x", "MPATHz", "MPATH", false);
> +	alias = get_user_friendly_alias("WWID0", "MPATHz", "MPATH", false);
>  	assert_string_equal(alias, "MPATHz");
>  	free(alias);
>  }
> @@ -1661,7 +1661,7 @@ static void gufa_old_match_other(void **state) {
>  
>  	mock_allocate_binding_len("MPATHa", "WWID0", sizeof(bindings) - 1);
>  
> -	alias = get_user_friendly_alias("WWID0", "x", "MPATHz", "MPATH", false);
> +	alias = get_user_friendly_alias("WWID0", "MPATHz", "MPATH", false);
>  	assert_string_equal(alias, "MPATHa");
>  	free(alias);
>  }
> @@ -1678,7 +1678,7 @@ static void gufa_old_match_other_used(void **state) {
>  	mock_unused_alias("MPATHb");
>  
>  	mock_allocate_binding_len("MPATHb", "WWID0", sizeof(bindings) - 1);
> -	alias = get_user_friendly_alias("WWID0", "x", "MPATHz", "MPATH", false);
> +	alias = get_user_friendly_alias("WWID0", "MPATHz", "MPATH", false);
>  	assert_string_equal(alias, "MPATHb");
>  	free(alias);
>  }
> @@ -1695,7 +1695,7 @@ static void gufa_old_match_other_wwidmatch(void **state) {
>  	mock_unused_alias("MPATHc");
>  	expect_condlog(3, EXISTING_STR("MPATHc", "WWID2"));
>  
> -	alias = get_user_friendly_alias("WWID2", "x", "MPATHz", "MPATH", false);
> +	alias = get_user_friendly_alias("WWID2", "MPATHz", "MPATH", false);
>  	assert_string_equal(alias, "MPATHc");
>  	free(alias);
>  }
> @@ -1711,7 +1711,7 @@ static void gufa_old_match_other_wwidmatch_used(void **state) {
>  	expect_condlog(3, FOUND_STR("MPATHc", "WWID2"));
>  	mock_used_alias("MPATHc", "WWID2");
>  
> -	alias = get_user_friendly_alias("WWID2", "x", "MPATHz", "MPATH", false);
> +	alias = get_user_friendly_alias("WWID2", "MPATHz", "MPATH", false);
>  	assert_ptr_equal(alias, NULL);
>  }
>  
> @@ -1725,7 +1725,7 @@ static void gufa_old_nomatch_wwidmatch(void **state) {
>  	mock_unused_alias("MPATHa");
>  	expect_condlog(3, EXISTING_STR("MPATHa", "WWID0"));
>  
> -	alias = get_user_friendly_alias("WWID0", "x", "MPATHz", "MPATH", false);
> +	alias = get_user_friendly_alias("WWID0", "MPATHz", "MPATH", false);
>  	assert_string_equal(alias, "MPATHa");
>  	free(alias);
>  }
> @@ -1739,7 +1739,7 @@ static void gufa_old_nomatch_wwidmatch_used(void **state) {
>  	expect_condlog(3, FOUND_STR("MPATHa", "WWID0"));
>  	mock_used_alias("MPATHa", "WWID0");
>  
> -	alias = get_user_friendly_alias("WWID0", "x", "MPATHz", "MPATH", false);
> +	alias = get_user_friendly_alias("WWID0", "MPATHz", "MPATH", false);
>  	assert_ptr_equal(alias, NULL);
>  }
>  
> @@ -1754,7 +1754,7 @@ static void gufa_old_nomatch_nowwidmatch(void **state) {
>  	mock_allocate_binding_len("MPATHz", "WWID0", sizeof(bindings) - 1);
>  	expect_condlog(2, ALLOC_STR("MPATHz", "WWID0"));
>  
> -	alias = get_user_friendly_alias("WWID0", "x", "MPATHz", "MPATH", false);
> +	alias = get_user_friendly_alias("WWID0", "MPATHz", "MPATH", false);
>  	assert_string_equal(alias, "MPATHz");
>  	free(alias);
>  }
> -- 
> 2.42.0
--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

