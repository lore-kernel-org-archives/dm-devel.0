Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9AA1033E3
	for <dm-devel@lists.linux.dev>; Wed, 25 Oct 2023 23:58:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="huPaplkW"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1698278309;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=663EeRew+0LTZfB+4SAmO4g8inceViRGln5/ydSE0DU=;
	b=huPaplkWxBrwkU4OnwABSmT2lo+79fd3ZFV15QIBHYgRxbwV/BC5gtqRSTsE1PIh8cMYpK
	xbx6vnFKcvAQA1a3H/3l4f4VGKXgLBgIjaPjaUhBCPXiu71GR6Ka7KWKrFO/hFoY+tO62Z
	oI4o+jeC9mWeVFrsXHzq/8dbhDwqQ68=
Received: from mimecast-mx02.redhat.com (mx-ext.redhat.com [66.187.233.73])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-580-557pW1SJNeqJPDSdEmav2w-1; Wed,
 25 Oct 2023 19:58:26 -0400
X-MC-Unique: 557pW1SJNeqJPDSdEmav2w-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 878092806056;
	Wed, 25 Oct 2023 23:58:25 +0000 (UTC)
Received: from bmarzins-01.fast.rdu2.eng.redhat.com (bmarzins-01.fast.rdu2.eng.redhat.com [10.6.23.12])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 6A7B7C1596D;
	Wed, 25 Oct 2023 23:58:25 +0000 (UTC)
Received: from bmarzins-01.fast.rdu2.eng.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.rdu2.eng.redhat.com (8.17.1/8.17.1) with ESMTPS id 39PNwPxu032420
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Wed, 25 Oct 2023 19:58:25 -0400
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.rdu2.eng.redhat.com (8.17.1/8.17.1/Submit) id 39PNwORu032419;
	Wed, 25 Oct 2023 19:58:24 -0400
Date: Wed, 25 Oct 2023 19:58:24 -0400
From: Benjamin Marzinski <bmarzins@redhat.com>
To: mwilck@suse.com
Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>,
        dm-devel@lists.linux.dev, Miao Guanqin <miaoguanqin@huawei.com>,
        Li Xiao Keng <lixiaokeng@huawei.com>
Subject: Re: [PATCH 6/6] libmpathutil: remove systemd_service_enabled()
Message-ID: <ZTmroA3eU3vLgOLl@bmarzins-01.fast.rdu2.eng.redhat.com>
References: <20231024164937.14684-1-mwilck@suse.com>
 <20231024164937.14684-7-mwilck@suse.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <20231024164937.14684-7-mwilck@suse.com>
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.8
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Oct 24, 2023 at 06:49:37PM +0200, mwilck@suse.com wrote:
> From: Martin Wilck <mwilck@suse.com>
> 
> Since  c203929 ("multipathd.service: add dependency on
> systemd-udevd-kernel.socket"), multipathd will start early during boot.
> Moreover, we recommend using socket activation for multipathd,
> and if multipathd.socket is enabled, the __mpath_connect()
> check will succeed anyway.
> 
> The systemd_service_enabled() test was just "good enough" for
> standard situations but never robust; it checked for multipathd.wants in
> "some" directory, which might or might not be the current target,
> and it would return true even of multipathd.service was masked.
> 
> Remove this test.
> 
> Signed-off-by: Martin Wilck <mwilck@suse.com>

I'd be lying if I said I had no worries at all about this. Removing this
check means that if someone isn't using socket activation, and
multipathd is temporarily down, and a new device appears, it will always
be marked as not claimed by multipath. This could cause the device to be
grabbed by LVM, and not multipathed. This is probably just may paranoia
talking, since the chance of this happening in the real world seems
pretty low. So,

Reviewed-by: Benjamin Marzinski <bmarzins@redhat.com>

> ---
>  libmpathutil/libmpathutil.version | 17 +++------
>  libmpathutil/util.c               | 58 -------------------------------
>  libmpathutil/util.h               |  1 -
>  libmultipath/valid.c              | 16 ++-------
>  tests/valid.c                     | 24 ++-----------
>  5 files changed, 9 insertions(+), 107 deletions(-)
> 
> diff --git a/libmpathutil/libmpathutil.version b/libmpathutil/libmpathutil.version
> index 6ebb718..15ff467 100644
> --- a/libmpathutil/libmpathutil.version
> +++ b/libmpathutil/libmpathutil.version
> @@ -93,12 +93,15 @@ local:
>  };
>  
>  /* symbols referenced internally by libmultipath */
> -LIBMPATHUTIL_1.0 {
> +LIBMPATHUTIL_2.0 {
>  	alloc_bitfield;
>  	__append_strbuf_str;
>  	append_strbuf_quoted;
>  	basenamecpy;
> +	cleanup_fd_ptr;
>  	cleanup_free_ptr;
> +	cleanup_vector_free;
> +	cleanup_fclose;
>  	filepresent;
>  	find_keyword;
>  	free_keywords;
> @@ -120,21 +123,9 @@ LIBMPATHUTIL_1.0 {
>  	snprint_keyword;
>  	steal_strbuf_str;
>  	strlcat;
> -	systemd_service_enabled;
>  	validate_config_strvec;
>  	vector_find_or_add_slot;
>  	vector_insert_slot;
>  	vector_move_up;
>  	vector_sort;
>  };
> -
> -LIBMPATHUTIL_1.1 {
> -global:
> -	cleanup_fd_ptr;
> -} LIBMPATHUTIL_1.0;
> -
> -LIBMPATHUTIL_1.2 {
> -global:
> -	cleanup_vector_free;
> -	cleanup_fclose;
> -} LIBMPATHUTIL_1.0;
> diff --git a/libmpathutil/util.c b/libmpathutil/util.c
> index 92f25a5..9d147fc 100644
> --- a/libmpathutil/util.c
> +++ b/libmpathutil/util.c
> @@ -213,64 +213,6 @@ setup_thread_attr(pthread_attr_t *attr, size_t stacksize, int detached)
>  	}
>  }
>  
> -int systemd_service_enabled_in(const char *dev, const char *prefix)
> -{
> -	static const char service[] = "multipathd.service";
> -	char path[PATH_MAX], file[PATH_MAX];
> -	DIR *dirfd;
> -	struct dirent *d;
> -	int found = 0;
> -
> -	if (safe_sprintf(path, "%s/systemd/system", prefix))
> -		return 0;
> -
> -	condlog(3, "%s: checking for %s in %s", dev, service, path);
> -
> -	dirfd = opendir(path);
> -	if (dirfd == NULL)
> -		return 0;
> -
> -	while ((d = readdir(dirfd)) != NULL) {
> -		char *p;
> -		struct stat stbuf;
> -
> -		if ((strcmp(d->d_name,".") == 0) ||
> -		    (strcmp(d->d_name,"..") == 0))
> -			continue;
> -
> -		if (strlen(d->d_name) < 6)
> -			continue;
> -
> -		p = d->d_name + strlen(d->d_name) - 6;
> -		if (strcmp(p, ".wants"))
> -			continue;
> -		if (!safe_sprintf(file, "%s/%s/%s",
> -				  path, d->d_name, service)
> -		    && stat(file, &stbuf) == 0) {
> -			condlog(3, "%s: found %s", dev, file);
> -			found++;
> -			break;
> -		}
> -	}
> -	closedir(dirfd);
> -
> -	return found;
> -}
> -
> -int systemd_service_enabled(const char *dev)
> -{
> -	int found = 0;
> -
> -	found = systemd_service_enabled_in(dev, "/etc");
> -	if (!found)
> -		found = systemd_service_enabled_in(dev, "/usr/lib");
> -	if (!found)
> -		found = systemd_service_enabled_in(dev, "/lib");
> -	if (!found)
> -		found = systemd_service_enabled_in(dev, "/run");
> -	return found;
> -}
> -
>  static int _linux_version_code;
>  static pthread_once_t _lvc_initialized = PTHREAD_ONCE_INIT;
>  
> diff --git a/libmpathutil/util.h b/libmpathutil/util.h
> index 99a471d..de9fcfd 100644
> --- a/libmpathutil/util.h
> +++ b/libmpathutil/util.h
> @@ -21,7 +21,6 @@ size_t strlcat(char * restrict dst, const char * restrict src, size_t size);
>  dev_t parse_devt(const char *dev_t);
>  char *convert_dev(char *dev, int is_path_device);
>  void setup_thread_attr(pthread_attr_t *attr, size_t stacksize, int detached);
> -int systemd_service_enabled(const char *dev);
>  int get_linux_version_code(void);
>  int safe_write(int fd, const void *buf, size_t count);
>  void set_max_fds(rlim_t max_fds);
> diff --git a/libmultipath/valid.c b/libmultipath/valid.c
> index d4dae3e..f223778 100644
> --- a/libmultipath/valid.c
> +++ b/libmultipath/valid.c
> @@ -314,23 +314,11 @@ is_path_valid(const char *name, struct config *conf, struct path *pp,
>  		return PATH_IS_VALID_NO_CHECK;
>  	}
>  
> -	/*
> -	 * "multipath -u" may be run before the daemon is started. In this
> -	 * case, systemd might own the socket but might delay multipathd
> -	 * startup until some other unit (udev settle!)  has finished
> -	 * starting. With many LUNs, the listen backlog may be exceeded, which
> -	 * would cause connect() to block. This causes udev workers calling
> -	 * "multipath -u" to hang, and thus creates a deadlock, until "udev
> -	 * settle" times out.  To avoid this, call connect() in non-blocking
> -	 * mode here, and take EAGAIN as indication for a filled-up systemd
> -	 * backlog.
> -	 */
> -
>  	if (check_multipathd) {
>  		fd = __mpath_connect(1);
>  		if (fd < 0) {
> -			if (errno != EAGAIN && !systemd_service_enabled(name)) {
> -				condlog(3, "multipathd not running or enabled");
> +			if (errno != EAGAIN) {
> +				condlog(3, "multipathd not running");
>  				return PATH_IS_NOT_VALID;
>  			}
>  		} else
> diff --git a/tests/valid.c b/tests/valid.c
> index 7032932..18a5a7b 100644
> --- a/tests/valid.c
> +++ b/tests/valid.c
> @@ -62,11 +62,6 @@ int __wrap___mpath_connect(int nonblocking)
>  	return -1;
>  }
>  
> -int __wrap_systemd_service_enabled(const char *dev)
> -{
> -	return (int)mock_type(bool);
> -}
> -
>  /* There's no point in checking the return value here */
>  int __wrap_mpath_disconnect(int fd)
>  {
> @@ -216,7 +211,6 @@ enum {
>  enum {
>  	CHECK_MPATHD_RUNNING,
>  	CHECK_MPATHD_EAGAIN,
> -	CHECK_MPATHD_ENABLED,
>  	CHECK_MPATHD_SKIP,
>  };
>  
> @@ -232,11 +226,8 @@ static void setup_passing(char *name, char *wwid, unsigned int check_multipathd,
>  	else if (check_multipathd == CHECK_MPATHD_EAGAIN) {
>  		will_return(__wrap___mpath_connect, false);
>  		will_return(__wrap___mpath_connect, EAGAIN);
> -	} else if (check_multipathd == CHECK_MPATHD_ENABLED) {
> -		will_return(__wrap___mpath_connect, false);
> -		will_return(__wrap___mpath_connect, ECONNREFUSED);
> -		will_return(__wrap_systemd_service_enabled, true);
>  	}
> +
>  	/* nothing for CHECK_MPATHD_SKIP */
>  	if (stage == STAGE_CHECK_MULTIPATHD)
>  		return;
> @@ -342,19 +333,10 @@ static void test_check_multipathd(void **state)
>  	will_return(__wrap_sysfs_is_multipathed, false);
>  	will_return(__wrap___mpath_connect, false);
>  	will_return(__wrap___mpath_connect, ECONNREFUSED);
> -	will_return(__wrap_systemd_service_enabled, false);
> +
>  	assert_int_equal(is_path_valid(name, &conf, &pp, true),
>  			 PATH_IS_NOT_VALID);
>  	assert_string_equal(pp.dev, name);
> -	/* test pass because service is enabled. fail getting udev */
> -	memset(&pp, 0, sizeof(pp));
> -	setup_passing(name, NULL, CHECK_MPATHD_ENABLED, STAGE_CHECK_MULTIPATHD);
> -	will_return(__wrap_udev_device_new_from_subsystem_sysname, false);
> -	will_return(__wrap_udev_device_new_from_subsystem_sysname,
> -		    name);
> -	assert_int_equal(is_path_valid(name, &conf, &pp, true),
> -			 PATH_IS_ERROR);
> -	assert_string_equal(pp.dev, name);
>  	/* test pass because connect returned EAGAIN. fail getting udev */
>  	setup_passing(name, NULL, CHECK_MPATHD_EAGAIN, STAGE_CHECK_MULTIPATHD);
>  	will_return(__wrap_udev_device_new_from_subsystem_sysname, false);
> @@ -533,7 +515,7 @@ static void test_check_uuid_present(void **state)
>  
>  	memset(&pp, 0, sizeof(pp));
>  	conf.find_multipaths = FIND_MULTIPATHS_STRICT;
> -	setup_passing(name, wwid, CHECK_MPATHD_ENABLED, STAGE_CHECK_WWIDS);
> +	setup_passing(name, wwid, CHECK_MPATHD_RUNNING, STAGE_CHECK_WWIDS);
>  	will_return(__wrap_dm_map_present_by_uuid, 1);
>  	will_return(__wrap_dm_map_present_by_uuid, wwid);
>  	assert_int_equal(is_path_valid(name, &conf, &pp, true),
> -- 
> 2.42.0

