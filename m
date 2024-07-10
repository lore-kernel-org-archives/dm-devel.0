Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF5FF4F1E2
	for <dm-devel@lists.linux.dev>; Wed, 10 Jul 2024 20:12:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720642329; cv=none; b=IaRy9eFObqbbqwitrlkVtbUwfysz0r5x8as0a3DyvvPx47Y17mKOH4GPDusnY0SSodS9byODXU4ODio9hZvPJ/jOl8AGGS7S2V+4M10FgOATWKkJynDQJmEHeqrH22w951H7nNP0rumpkQOXzhv8EBOEPMs3jU2GjQfPbV8Zzlo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720642329; c=relaxed/simple;
	bh=FXHTuSfl57aFXifGoGJuzy9bqKf9GLoTnjCHdDtqFHw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 In-Reply-To:Content-Type:Content-Disposition; b=axYw1f10dzBefjV068nsIIDIoRDBnIGZhq/t+I/kpCj+l1kjM2oUhtDeJXbGQ+brsarQZfgXSM2LvVlYzbz6fx5Hyt9YY7i+v2/VAiMD22zPV89nvcjR+odnYYw2StJ3tu8zn0USCs0C6KFC70EK3TZEDgzgPgO1pXqZFZiHFZc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=ZPbbG8Uy; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ZPbbG8Uy"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1720642325;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=rD/09eQh5SQ+83KkJ0pHXTUEbXQPla/h/EGlV8F1G10=;
	b=ZPbbG8Uy75l34urHPcKa1/784rE7qfWcgmloyeghaWHDkE7x7i8opinVFw21qeENBsFoCZ
	UJVNmRCwlSdk+gDSlpUIpeMvE5TO/EpM+YyV/cO9/gr+1NP1T3uJGielcrVKbiVciUxMMf
	FwSdzUW/zAzTYtzY+HfxZxUjDpLEPNo=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-589-4lMkfQYEPbO85HMiWOsxlQ-1; Wed,
 10 Jul 2024 16:12:04 -0400
X-MC-Unique: 4lMkfQYEPbO85HMiWOsxlQ-1
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 3749719560AE;
	Wed, 10 Jul 2024 20:12:03 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (bmarzins-01.fast.eng.rdu2.dc.redhat.com [10.6.23.12])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id C2C7519560AE;
	Wed, 10 Jul 2024 20:12:02 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.2/8.17.1) with ESMTPS id 46AKC1Lc1917295
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Wed, 10 Jul 2024 16:12:01 -0400
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.2/8.17.2/Submit) id 46AKC11q1917294;
	Wed, 10 Jul 2024 16:12:01 -0400
Date: Wed, 10 Jul 2024 16:12:01 -0400
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Martin Wilck <martin.wilck@suse.com>
Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>,
        dm-devel@lists.linux.dev
Subject: Re: [PATCH 16/44] libmultipath: add cleanup_dm_task(), and use it in
 devmapper.c
Message-ID: <Zo7rERddnnfSvSsW@redhat.com>
References: <20240709213935.177028-1-mwilck@suse.com>
 <20240709213935.177028-17-mwilck@suse.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <20240709213935.177028-17-mwilck@suse.com>
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Jul 09, 2024 at 11:39:07PM +0200, Martin Wilck wrote:
> This allows us to get rid of a lot of goto statements, and generally
> obtain cleaner code.
> 
> Additional small changes:
> 
>  - simplify the logic of dm_tgt_version(); the only caller isn't interested
>    in the nature of the error if the version couldn't be obtained.
>  - libmultipath: rename dm_type() to the more fitting dm_type_match()
>  - use symbolic return values in dm_is_mpath()
> 
> Signed-off-by: Martin Wilck <mwilck@suse.com>
> ---
>  libmpathpersist/mpath_persist_int.c |   2 +-
>  libmultipath/devmapper.c            | 315 ++++++++++++----------------
>  libmultipath/devmapper.h            |   7 +-
>  multipath/main.c                    |   4 +-
>  multipathd/dmevents.c               |   4 +-
>  multipathd/main.c                   |   2 +-
>  6 files changed, 145 insertions(+), 189 deletions(-)
> 
> diff --git a/libmpathpersist/mpath_persist_int.c b/libmpathpersist/mpath_persist_int.c
> index 178c2f5..6da0401 100644
> --- a/libmpathpersist/mpath_persist_int.c
> +++ b/libmpathpersist/mpath_persist_int.c
> @@ -185,7 +185,7 @@ static int mpath_get_map(vector curmp, vector pathvec, int fd, char **palias,
>  
>  	condlog(3, "alias = %s", alias);
>  
> -	if (dm_map_present(alias) && dm_is_mpath(alias) != 1){
> +	if (dm_map_present(alias) && dm_is_mpath(alias) != DM_IS_MPATH_YES) {
>  		condlog(3, "%s: not a multipath device.", alias);
>  		goto out;
>  	}
> diff --git a/libmultipath/devmapper.c b/libmultipath/devmapper.c
> index 8996c1d..3685ef7 100644
> --- a/libmultipath/devmapper.c
> +++ b/libmultipath/devmapper.c
> @@ -91,6 +91,12 @@ int libmp_dm_task_run(struct dm_task *dmt)
>  	return r;
>  }
>  
> +static void cleanup_dm_task(struct dm_task **pdmt)
> +{
> +	if (*pdmt)
> +		dm_task_destroy(*pdmt);
> +}
> +
>  __attribute__((format(printf, 4, 5))) static void
>  dm_write_log (int level, const char *file, int line, const char *f, ...)
>  {
> @@ -203,8 +209,8 @@ static void init_dm_drv_version(void)
>  
>  static int dm_tgt_version (unsigned int *version, char *str)
>  {
> -	int r = 2;
> -	struct dm_task *dmt;
> +	bool found = false;
> +	struct dm_task __attribute__((cleanup(cleanup_dm_task))) *dmt = NULL;
>  	struct dm_versions *target;
>  	struct dm_versions *last_target;
>  	unsigned int *v;
> @@ -220,31 +226,28 @@ static int dm_tgt_version (unsigned int *version, char *str)
>  	if (!libmp_dm_task_run(dmt)) {
>  		dm_log_error(2, DM_DEVICE_LIST_VERSIONS, dmt);
>  		condlog(0, "Cannot communicate with kernel DM");
> -		goto out;
> +		return 1;
>  	}
>  	target = dm_task_get_versions(dmt);
>  
>  	do {
>  		last_target = target;
>  		if (!strncmp(str, target->name, strlen(str))) {
> -			r = 1;
> +			found = true;
>  			break;
>  		}
>  		target = (void *) target + target->next;
>  	} while (last_target != target);
>  
> -	if (r == 2) {
> +	if (!found) {
>  		condlog(0, "DM %s kernel driver not loaded", str);
> -		goto out;
> +		return 1;
>  	}
>  	v = target->version;
>  	version[0] = v[0];
>  	version[1] = v[1];
>  	version[2] = v[2];
> -	r = 0;
> -out:
> -	dm_task_destroy(dmt);
> -	return r;
> +	return 0;
>  }
>  
>  static void init_dm_mpath_version(void)
> @@ -383,18 +386,18 @@ libmp_dm_task_create(int task)
>  
>  static int
>  dm_simplecmd (int task, const char *name, int flags, uint16_t udev_flags) {
> -	int r = 0;
> +	int r;
>  	int udev_wait_flag = (((flags & DMFL_NEED_SYNC) || udev_flags) &&
>  			      (task == DM_DEVICE_RESUME ||
>  			       task == DM_DEVICE_REMOVE));
>  	uint32_t cookie = 0;
> -	struct dm_task *dmt;
> +	struct dm_task __attribute__((cleanup(cleanup_dm_task))) *dmt = NULL;
>  
>  	if (!(dmt = libmp_dm_task_create (task)))
>  		return 0;
>  
>  	if (!dm_task_set_name (dmt, name))
> -		goto out;
> +		return 0;
>  
>  	dm_task_skip_lockfs(dmt);	/* for DM_DEVICE_RESUME */
>  #ifdef LIBDM_API_FLUSH
> @@ -408,7 +411,7 @@ dm_simplecmd (int task, const char *name, int flags, uint16_t udev_flags) {
>  	if (udev_wait_flag &&
>  	    !dm_task_set_cookie(dmt, &cookie,
>  				DM_UDEV_DISABLE_LIBRARY_FALLBACK | udev_flags))
> -		goto out;
> +		return 0;
>  
>  	r = libmp_dm_task_run (dmt);
>  	if (!r)
> @@ -416,8 +419,6 @@ dm_simplecmd (int task, const char *name, int flags, uint16_t udev_flags) {
>  
>  	if (udev_wait_flag)
>  			libmp_udev_wait(cookie);
> -out:
> -	dm_task_destroy (dmt);
>  	return r;
>  }
>  
> @@ -440,8 +441,9 @@ static int
>  dm_addmap (int task, const char *target, struct multipath *mpp,
>  	   char * params, int ro, uint16_t udev_flags) {
>  	int r = 0;
> -	struct dm_task *dmt;
> -	char *prefixed_uuid = NULL;
> +	struct dm_task __attribute__((cleanup(cleanup_dm_task))) *dmt = NULL;
> +	char __attribute__((cleanup(cleanup_charp))) *prefixed_uuid = NULL;
> +
>  	uint32_t cookie = 0;
>  
>  	if (task == DM_DEVICE_CREATE && strlen(mpp->wwid) == 0) {
> @@ -457,10 +459,10 @@ dm_addmap (int task, const char *target, struct multipath *mpp,
>  		return 0;
>  
>  	if (!dm_task_set_name (dmt, mpp->alias))
> -		goto addout;
> +		return 0;
>  
>  	if (!dm_task_add_target (dmt, 0, mpp->size, target, params))
> -		goto addout;
> +		return 0;
>  
>  	if (ro)
>  		dm_task_set_ro(dmt);
> @@ -469,10 +471,10 @@ dm_addmap (int task, const char *target, struct multipath *mpp,
>  		if (asprintf(&prefixed_uuid, UUID_PREFIX "%s", mpp->wwid) < 0) {
>  			condlog(0, "cannot create prefixed uuid : %s",
>  				strerror(errno));
> -			goto addout;
> +			return 0;
>  		}
>  		if (!dm_task_set_uuid(dmt, prefixed_uuid))
> -			goto freeout;
> +			return 0;
>  		dm_task_skip_lockfs(dmt);
>  #ifdef LIBDM_API_FLUSH
>  		dm_task_no_flush(dmt);
> @@ -481,33 +483,28 @@ dm_addmap (int task, const char *target, struct multipath *mpp,
>  
>  	if (mpp->attribute_flags & (1 << ATTR_MODE) &&
>  	    !dm_task_set_mode(dmt, mpp->mode))
> -		goto freeout;
> +		return 0;
>  	if (mpp->attribute_flags & (1 << ATTR_UID) &&
>  	    !dm_task_set_uid(dmt, mpp->uid))
> -		goto freeout;
> +		return 0;
>  	if (mpp->attribute_flags & (1 << ATTR_GID) &&
>  	    !dm_task_set_gid(dmt, mpp->gid))
> -		goto freeout;
> +		return 0;
> +
>  	condlog(2, "%s: %s [0 %llu %s %s]", mpp->alias,
>  		task == DM_DEVICE_RELOAD ? "reload" : "addmap", mpp->size,
>  		target, params);
>  
>  	if (task == DM_DEVICE_CREATE &&
>  	    !dm_task_set_cookie(dmt, &cookie, udev_flags))
> -		goto freeout;
> +		return 0;
>  
>  	r = libmp_dm_task_run (dmt);
>  	if (!r)
>  		dm_log_error(2, task, dmt);
>  
>  	if (task == DM_DEVICE_CREATE)
> -			libmp_udev_wait(cookie);
> -freeout:
> -	if (prefixed_uuid)
> -		free(prefixed_uuid);
> -
> -addout:
> -	dm_task_destroy (dmt);
> +		libmp_udev_wait(cookie);
>  
>  	if (r)
>  		mpp->need_reload = false;
> @@ -648,46 +645,41 @@ int dm_map_present(const char * str)
>  
>  int dm_get_map(const char *name, unsigned long long *size, char **outparams)
>  {
> -	int r = DMP_ERR;
> -	struct dm_task *dmt;
> +	struct dm_task __attribute__((cleanup(cleanup_dm_task))) *dmt = NULL;
>  	uint64_t start, length;
>  	char *target_type = NULL;
>  	char *params = NULL;
>  
>  	if (!(dmt = libmp_dm_task_create(DM_DEVICE_TABLE)))
> -		return r;
> +		return DMP_ERR;
>  
>  	if (!dm_task_set_name(dmt, name))
> -		goto out;
> +		return DMP_ERR;
>  
>  	errno = 0;
>  	if (!libmp_dm_task_run(dmt)) {
>  		dm_log_error(3, DM_DEVICE_TABLE, dmt);
>  		if (dm_task_get_errno(dmt) == ENXIO)
> -			r = DMP_NOT_FOUND;
> -		goto out;
> +			return DMP_NOT_FOUND;
> +		else
> +			return DMP_ERR;
>  	}
>  
> -	r = DMP_NOT_FOUND;
>  	/* Fetch 1st target */
>  	if (dm_get_next_target(dmt, NULL, &start, &length,
>  			       &target_type, &params) != NULL || !params)
>  		/* more than one target or not found target */
> -		goto out;
> +		return DMP_NOT_FOUND;
>  
>  	if (size)
>  		*size = length;
>  
>  	if (!outparams)
> -		r = DMP_OK;
> +		return DMP_OK;
>  	else {
>  		*outparams = strdup(params);
> -		r = *outparams ? DMP_OK : DMP_ERR;
> +		return *outparams ? DMP_OK : DMP_ERR;
>  	}
> -
> -out:
> -	dm_task_destroy(dmt);
> -	return r;
>  }
>  
>  static int
> @@ -767,7 +759,7 @@ is_mpath_part(const char *part_name, const char *map_name)
>  int dm_get_status(const char *name, char **outstatus)
>  {
>  	int r = DMP_ERR;
> -	struct dm_task *dmt;
> +	struct dm_task __attribute__((cleanup(cleanup_dm_task))) *dmt = NULL;
>  	uint64_t start, length;
>  	char *target_type = NULL;
>  	char *status = NULL;
> @@ -796,7 +788,7 @@ int dm_get_status(const char *name, char **outstatus)
>  		goto out;
>  
>  	if (!status) {
> -		condlog(2, "get null status.");
> +		condlog(2, "got null status.");
>  		goto out;
>  	}
>  
> @@ -808,62 +800,56 @@ int dm_get_status(const char *name, char **outstatus)
>  	}
>  out:
>  	if (r != DMP_OK)
> -		condlog(0, "%s: error getting map status string", name);
> +		condlog(0, "%s: %s: error getting map status string: %d",
> +			__func__, name, r);
>  
> -	dm_task_destroy(dmt);
>  	return r;
>  }
>  
> -/*
> - * returns:
> - *    1 : match
> - *    0 : no match
> - *   -1 : empty map, or more than 1 target
> - */
> -int dm_type(const char *name, char *type)
> +enum {
> +	DM_TYPE_NOMATCH = 0,
> +	DM_TYPE_MATCH,
> +	/* more than 1 target */
> +	DM_TYPE_MULTI,
> +	/* empty map */
> +	DM_TYPE_EMPTY,
> +	DM_TYPE_ERR,
> +};
> +static int dm_type_match(const char *name, char *type)
>  {
> -	int r = 0;
> -	struct dm_task *dmt;
> +	struct dm_task __attribute__((cleanup(cleanup_dm_task))) *dmt = NULL;
>  	uint64_t start, length;
>  	char *target_type = NULL;
>  	char *params;
>  
>  	if (!(dmt = libmp_dm_task_create(DM_DEVICE_TABLE)))
> -		return 0;
> +		return DM_TYPE_ERR;
>  
>  	if (!dm_task_set_name(dmt, name))
> -		goto out;
> +		return DM_TYPE_ERR;
>  
>  	if (!libmp_dm_task_run(dmt)) {
>  		dm_log_error(3, DM_DEVICE_TABLE, dmt);
> -		goto out;
> +		return DM_TYPE_ERR;
>  	}
>  
>  	/* Fetch 1st target */
>  	if (dm_get_next_target(dmt, NULL, &start, &length,
>  			       &target_type, &params) != NULL)
>  		/* multiple targets */
> -		r = -1;
> +		return DM_TYPE_MULTI;
>  	else if (!target_type)
> -		r = -1;
> +		return DM_TYPE_EMPTY;
>  	else if (!strcmp(target_type, type))
> -		r = 1;
> -
> -out:
> -	dm_task_destroy(dmt);
> -	return r;
> +		return DM_TYPE_MATCH;
> +	else
> +		return DM_TYPE_NOMATCH;
>  }
>  
> -/*
> - * returns:
> - * 1  : is multipath device
> - * 0  : is not multipath device
> - * -1 : error
> - */
>  int dm_is_mpath(const char *name)
>  {
> -	int r = -1;
> -	struct dm_task *dmt;
> +	int r = DM_IS_MPATH_ERR;
> +	struct dm_task __attribute__((cleanup(cleanup_dm_task))) *dmt = NULL;
>  	struct dm_info info;
>  	uint64_t start, length;
>  	char *target_type = NULL;
> @@ -874,41 +860,39 @@ int dm_is_mpath(const char *name)
>  		goto out;
>  
>  	if (!dm_task_set_name(dmt, name))
> -		goto out_task;
> +		goto out;
>  
>  	if (!libmp_dm_task_run(dmt)) {
>  		dm_log_error(3, DM_DEVICE_TABLE, dmt);
> -		goto out_task;
> +		goto out;
>  	}
>  
>  	if (!dm_task_get_info(dmt, &info))
> -		goto out_task;
> +		goto out;
>  
> -	r = 0;
> +	r = DM_IS_MPATH_NO;
>  
>  	if (!info.exists)
> -		goto out_task;
> +		goto out;
>  
>  	uuid = dm_task_get_uuid(dmt);
>  
>  	if (!uuid || strncmp(uuid, UUID_PREFIX, UUID_PREFIX_LEN) != 0)
> -		goto out_task;
> +		goto out;
>  
>  	/* Fetch 1st target */
>  	if (dm_get_next_target(dmt, NULL, &start, &length, &target_type,
>  			       &params) != NULL)
>  		/* multiple targets */
> -		goto out_task;
> +		goto out;
>  
>  	if (!target_type || strcmp(target_type, TGT_MPATH) != 0)
> -		goto out_task;
> +		goto out;
>  
> -	r = 1;
> -out_task:
> -	dm_task_destroy(dmt);
> +	r = DM_IS_MPATH_YES;
>  out:
>  	if (r < 0)
> -		condlog(3, "%s: dm command failed in %s: %s", name, __FUNCTION__, strerror(errno));
> +		condlog(3, "%s: dm command failed in %s: %s", name, __func__, strerror(errno));
>  	return r;
>  }
>  
> @@ -1049,7 +1033,7 @@ int _dm_flush_map (const char *mapname, int flags, int retries)
>  	unsigned long long mapsize;
>  	char *params = NULL;
>  
> -	if (dm_is_mpath(mapname) != 1)
> +	if (dm_is_mpath(mapname) != DM_IS_MPATH_YES)
>  		return DM_FLUSH_OK; /* nothing to do */
>  
>  	/* if the device currently has no partitions, do not
> @@ -1096,7 +1080,7 @@ int _dm_flush_map (const char *mapname, int flags, int retries)
>  			}
>  			condlog(4, "multipath map %s removed", mapname);
>  			return DM_FLUSH_OK;
> -		} else if (dm_is_mpath(mapname) != 1) {
> +		} else if (dm_is_mpath(mapname) != DM_IS_MPATH_YES) {
>  			condlog(4, "multipath map %s removed externally",
>  				mapname);
>  			return DM_FLUSH_OK; /* raced. someone else removed it */
> @@ -1131,10 +1115,10 @@ dm_flush_map_nopaths(const char *mapname, int deferred_remove __DR_UNUSED__)
>  	return _dm_flush_map(mapname, flags, 0);
>  }
>  
> -int dm_flush_maps (int retries)
> +int dm_flush_maps(int retries)
>  {
>  	int r = DM_FLUSH_FAIL;
> -	struct dm_task *dmt;
> +	struct dm_task __attribute__((cleanup(cleanup_dm_task))) *dmt = NULL;
>  	struct dm_names *names;
>  	unsigned next = 0;
>  
> @@ -1143,15 +1127,15 @@ int dm_flush_maps (int retries)
>  
>  	if (!libmp_dm_task_run (dmt)) {
>  		dm_log_error(3, DM_DEVICE_LIST, dmt);
> -		goto out;
> +		return r;
>  	}
>  
>  	if (!(names = dm_task_get_names (dmt)))
> -		goto out;
> +		return r;
>  
>  	r = DM_FLUSH_OK;
>  	if (!names->dev)
> -		goto out;
> +		return r;
>  
>  	do {
>  		int ret;
> @@ -1163,16 +1147,13 @@ int dm_flush_maps (int retries)
>  		names = (void *) names + next;
>  	} while (next);
>  
> -out:
> -	dm_task_destroy (dmt);
>  	return r;
>  }
>  
>  int
>  dm_message(const char * mapname, char * message)
>  {
> -	int r = 1;
> -	struct dm_task *dmt;
> +	struct dm_task __attribute__((cleanup(cleanup_dm_task))) *dmt = NULL;
>  
>  	if (!(dmt = libmp_dm_task_create(DM_DEVICE_TARGET_MSG)))
>  		return 1;
> @@ -1191,13 +1172,10 @@ dm_message(const char * mapname, char * message)
>  		goto out;
>  	}
>  
> -	r = 0;
> +	return 0;
>  out:
> -	if (r)
> -		condlog(0, "DM message failed [%s]", message);
> -
> -	dm_task_destroy(dmt);
> -	return r;
> +	condlog(0, "DM message failed [%s]", message);
> +	return 1;
>  }
>  
>  int
> @@ -1305,12 +1283,10 @@ out:
>  	return NULL;
>  }
>  
> -int
> -dm_get_maps (vector mp)
> +int dm_get_maps(vector mp)
>  {
>  	struct multipath * mpp;
> -	int r = 1;
> -	struct dm_task *dmt;
> +	struct dm_task __attribute__((cleanup(cleanup_dm_task))) *dmt = NULL;
>  	struct dm_names *names;
>  	unsigned next = 0;
>  
> @@ -1322,28 +1298,28 @@ dm_get_maps (vector mp)
>  
>  	if (!libmp_dm_task_run(dmt)) {
>  		dm_log_error(3, DM_DEVICE_LIST, dmt);
> -		goto out;
> +		return 1;
>  	}
>  
>  	if (!(names = dm_task_get_names(dmt)))
> -		goto out;
> +		return 1;
>  
>  	if (!names->dev) {
> -		r = 0; /* this is perfectly valid */
> -		goto out;
> +		/* this is perfectly valid */
> +		return 0;
>  	}
>  
>  	do {
> -		if (dm_is_mpath(names->name) != 1)
> +		if (dm_is_mpath(names->name) != DM_IS_MPATH_YES)
>  			goto next;
>  
>  		mpp = dm_get_multipath(names->name);
>  		if (!mpp)
> -			goto out;
> +			return 1;
>  
>  		if (!vector_alloc_slot(mp)) {
>  			free_multipath(mpp, KEEP_PATHS);
> -			goto out;
> +			return 1;
>  		}
>  
>  		vector_set_slot(mp, mpp);
> @@ -1352,11 +1328,7 @@ next:
>  		names = (void *) names + next;
>  	} while (next);
>  
> -	r = 0;
> -	goto out;
> -out:
> -	dm_task_destroy (dmt);
> -	return r;
> +	return 0;
>  }
>  
>  int
> @@ -1419,10 +1391,10 @@ do_foreach_partmaps (const char * mapname,
>  		     int (*partmap_func)(const char *, void *),
>  		     void *data)
>  {
> -	struct dm_task *dmt;
> +	struct dm_task __attribute__((cleanup(cleanup_dm_task))) *dmt = NULL;
> +	char __attribute__((cleanup(cleanup_charp))) *params = NULL;
>  	struct dm_names *names;
>  	unsigned next = 0;
> -	char *params = NULL;
>  	unsigned long long size;
>  	char dev_t[32];
>  	int r = 1;
> @@ -1431,28 +1403,25 @@ do_foreach_partmaps (const char * mapname,
>  	if (!(dmt = libmp_dm_task_create(DM_DEVICE_LIST)))
>  		return 1;
>  
> -	if (!libmp_dm_task_run(dmt)) {
> -		dm_log_error(3, DM_DEVICE_LIST, dmt);
> -		goto out;
> -	}
> +	if (!libmp_dm_task_run(dmt))
> +		return 1;
>  
>  	if (!(names = dm_task_get_names(dmt)))
> -		goto out;
> +		return 1;
>  
> -	if (!names->dev) {
> -		r = 0; /* this is perfectly valid */
> -		goto out;
> -	}
> +	if (!names->dev)
> +		/* this is perfectly valid */
> +		return 0;
>  
>  	if (dm_dev_t(mapname, &dev_t[0], 32))
> -		goto out;
> +		return 1;
>  
>  	do {
>  		if (
>  		    /*
>  		     * if there is only a single "linear" target
>  		     */
> -		    (dm_type(names->name, TGT_PART) == 1) &&
> +		    (dm_type_match(names->name, TGT_PART) == DM_TYPE_MATCH) &&
>  
>  		    /*
>  		     * and the uuid of the target is a partition of the
> @@ -1472,7 +1441,7 @@ do_foreach_partmaps (const char * mapname,
>  		    !isdigit(*(p + strlen(dev_t)))
>  		   ) {
>  			if ((r = partmap_func(names->name, data)) != 0)
> -				goto out;
> +				return 1;
>  		}
>  
>  		free(params);
> @@ -1481,11 +1450,7 @@ do_foreach_partmaps (const char * mapname,
>  		names = (void *) names + next;
>  	} while (next);
>  
> -	r = 0;
> -out:
> -	free(params);
> -	dm_task_destroy (dmt);
> -	return r;
> +	return 0;
>  }
>  
>  struct remove_data {
> @@ -1623,7 +1588,7 @@ int
>  dm_rename (const char * old, char * new, char *delim, int skip_kpartx)
>  {
>  	int r = 0;
> -	struct dm_task *dmt;
> +	struct dm_task __attribute__((cleanup(cleanup_dm_task))) *dmt = NULL;
>  	uint32_t cookie = 0;
>  	uint16_t udev_flags = DM_UDEV_DISABLE_LIBRARY_FALLBACK | ((skip_kpartx == SKIP_KPARTX_ON)? MPATH_UDEV_NO_KPARTX_FLAG : 0);
>  
> @@ -1634,22 +1599,19 @@ dm_rename (const char * old, char * new, char *delim, int skip_kpartx)
>  		return r;
>  
>  	if (!dm_task_set_name(dmt, old))
> -		goto out;
> +		return r;
>  
>  	if (!dm_task_set_newname(dmt, new))
> -		goto out;
> +		return r;
>  
>  	if (!dm_task_set_cookie(dmt, &cookie, udev_flags))
> -		goto out;
> +		return r;
> +
>  	r = libmp_dm_task_run(dmt);
>  	if (!r)
>  		dm_log_error(2, DM_DEVICE_RENAME, dmt);
>  
>  	libmp_udev_wait(cookie);
> -
> -out:
> -	dm_task_destroy(dmt);
> -
>  	return r;
>  }
>  
> @@ -1672,9 +1634,10 @@ void dm_reassign_deps(char *table, const char *dep, const char *newdep)
>  
>  int dm_reassign_table(const char *name, char *old, char *new)
>  {
> -	int r = 0, modified = 0;
> +	int modified = 0;
>  	uint64_t start, length;
> -	struct dm_task *dmt, *reload_dmt;
> +	struct dm_task __attribute__((cleanup(cleanup_dm_task))) *dmt = NULL;
> +	struct dm_task __attribute__((cleanup(cleanup_dm_task))) *reload_dmt = NULL;
>  	char *target, *params = NULL;
>  	char *buff;
>  	void *next = NULL;
> @@ -1683,16 +1646,16 @@ int dm_reassign_table(const char *name, char *old, char *new)
>  		return 0;
>  
>  	if (!dm_task_set_name(dmt, name))
> -		goto out;
> +		return 0;
>  
>  	if (!libmp_dm_task_run(dmt)) {
>  		dm_log_error(3, DM_DEVICE_TABLE, dmt);
> -		goto out;
> +		return 0;
>  	}
>  	if (!(reload_dmt = libmp_dm_task_create(DM_DEVICE_RELOAD)))
> -		goto out;
> +		return 0;
>  	if (!dm_task_set_name(reload_dmt, name))
> -		goto out_reload;
> +		return 0;
>  
>  	do {
>  		next = dm_get_next_target(dmt, next, &start, &length,
> @@ -1705,13 +1668,13 @@ int dm_reassign_table(const char *name, char *old, char *new)
>  			 */
>  			condlog(1, "%s: invalid target found in map %s",
>  				__func__, name);
> -			goto out_reload;
> +			return 0;
>  		}
>  		buff = strdup(params);
>  		if (!buff) {
>  			condlog(3, "%s: failed to replace target %s, "
>  				"out of memory", name, target);
> -			goto out_reload;
> +			return 0;
>  		}
>  		if (strcmp(target, TGT_MPATH) && strstr(params, old)) {
>  			condlog(3, "%s: replace target %s %s",
> @@ -1729,18 +1692,12 @@ int dm_reassign_table(const char *name, char *old, char *new)
>  		if (!libmp_dm_task_run(reload_dmt)) {
>  			dm_log_error(3, DM_DEVICE_RELOAD, reload_dmt);
>  			condlog(3, "%s: failed to reassign targets", name);
> -			goto out_reload;
> +			return 0;
>  		}
>  		dm_simplecmd_noflush(DM_DEVICE_RESUME, name,
>  				     MPATH_UDEV_RELOAD_FLAG);
>  	}
> -	r = 1;
> -
> -out_reload:
> -	dm_task_destroy(reload_dmt);
> -out:
> -	dm_task_destroy(dmt);
> -	return r;
> +	return 1;
>  }
>  
>  
> @@ -1752,10 +1709,9 @@ out:
>  int dm_reassign(const char *mapname)
>  {
>  	struct dm_deps *deps;
> -	struct dm_task *dmt;
> +	struct dm_task __attribute__((cleanup(cleanup_dm_task))) *dmt = NULL;
>  	struct dm_info info;
>  	char dev_t[32], dm_dep[32];
> -	int r = 0;
>  	unsigned int i;
>  
>  	if (dm_dev_t(mapname, &dev_t[0], 32)) {
> @@ -1769,21 +1725,21 @@ int dm_reassign(const char *mapname)
>  	}
>  
>  	if (!dm_task_set_name(dmt, mapname))
> -		goto out;
> +		return 0;
>  
>  	if (!libmp_dm_task_run(dmt)) {
>  		dm_log_error(3, DM_DEVICE_DEPS, dmt);
> -		goto out;
> +		return 0;
>  	}
>  
>  	if (!dm_task_get_info(dmt, &info))
> -		goto out;
> +		return 0;
>  
>  	if (!(deps = dm_task_get_deps(dmt)))
> -		goto out;
> +		return 0;
>  
>  	if (!info.exists)
> -		goto out;
> +		return 0;
>  
>  	for (i = 0; i < deps->count; i++) {
>  		sprintf(dm_dep, "%d:%d",
> @@ -1792,15 +1748,12 @@ int dm_reassign(const char *mapname)
>  		sysfs_check_holders(dm_dep, dev_t);
>  	}
>  
> -	r = 1;
> -out:
> -	dm_task_destroy (dmt);
> -	return r;
> +	return 1;
>  }
>  
>  int dm_setgeometry(struct multipath *mpp)
>  {
> -	struct dm_task *dmt;
> +	struct dm_task __attribute__((cleanup(cleanup_dm_task))) *dmt = NULL;
>  	struct path *pp;
>  	char heads[4], sectors[4];
>  	char cylinders[10], start[32];
> @@ -1825,7 +1778,7 @@ int dm_setgeometry(struct multipath *mpp)
>  		return 0;
>  
>  	if (!dm_task_set_name(dmt, mpp->alias))
> -		goto out;
> +		return 0;
>  
>  	/* What a sick interface ... */
>  	snprintf(heads, 4, "%u", pp->geom.heads);
> @@ -1834,14 +1787,12 @@ int dm_setgeometry(struct multipath *mpp)
>  	snprintf(start, 32, "%lu", pp->geom.start);
>  	if (!dm_task_set_geometry(dmt, cylinders, heads, sectors, start)) {
>  		condlog(3, "%s: Failed to set geometry", mpp->alias);
> -		goto out;
> +		return 0;
>  	}
>  
>  	r = libmp_dm_task_run(dmt);
>  	if (!r)
>  		dm_log_error(3, DM_DEVICE_SET_GEOMETRY, dmt);
> -out:
> -	dm_task_destroy(dmt);
>  
>  	return r;
>  }
> diff --git a/libmultipath/devmapper.h b/libmultipath/devmapper.h
> index 19b79c5..9438c2d 100644
> --- a/libmultipath/devmapper.h
> +++ b/libmultipath/devmapper.h
> @@ -46,7 +46,12 @@ int dm_map_present (const char *name);
>  int dm_map_present_by_uuid(const char *uuid);
>  int dm_get_map(const char *name, unsigned long long *size, char **outparams);
>  int dm_get_status(const char *name, char **outstatus);
> -int dm_type(const char *name, char *type);
> +
> +enum {
> +	DM_IS_MPATH_NO,
> +	DM_IS_MPATH_YES,
> +	DM_IS_MPATH_ERR,
> +};
>  int dm_is_mpath(const char *name);
>  
>  enum {
> diff --git a/multipath/main.c b/multipath/main.c
> index ce702e7..c82bc86 100644
> --- a/multipath/main.c
> +++ b/multipath/main.c
> @@ -247,7 +247,7 @@ static int check_usable_paths(struct config *conf,
>  		goto out;
>  	}
>  
> -	if (dm_is_mpath(mapname) != 1) {
> +	if (dm_is_mpath(mapname) != DM_IS_MPATH_YES) {
>  		condlog(1, "%s is not a multipath map", devpath);
>  		goto free;
>  	}
> @@ -1080,7 +1080,7 @@ main (int argc, char *argv[])
>  		goto out;
>  	}
>  	if (cmd == CMD_FLUSH_ONE) {
> -		if (dm_is_mpath(dev) != 1) {
> +		if (dm_is_mpath(dev) != DM_IS_MPATH_YES) {
>  			condlog(0, "%s is not a multipath device", dev);
>  			r = RTVL_FAIL;
>  			goto out;
> diff --git a/multipathd/dmevents.c b/multipathd/dmevents.c
> index 3fbdc55..605219e 100644
> --- a/multipathd/dmevents.c
> +++ b/multipathd/dmevents.c
> @@ -170,7 +170,7 @@ static int dm_get_events(void)
>  
>  		/* Don't delete device if dm_is_mpath() fails without
>  		 * checking the device type */

Like the comments says, this check is only supposed to remove a multipath
device from the list of devices if dm_is_mpath() returns DM_IS_MPATH_NO.

See 9050cd5a1 ("libmultipath: fix false removes in dmevents polling
code")

> -		if (dm_is_mpath(names->name) == 0)
> +		if (dm_is_mpath(names->name) != DM_IS_MPATH_YES)
>  			goto next;
>  
>  		event_nr = dm_event_nr(names);
> @@ -208,7 +208,7 @@ int watch_dmevents(char *name)
>  
>  	/* We know that this is a multipath device, so only fail if
>  	 * device-mapper tells us that we're wrong */

Same here.

-Ben

> -	if (dm_is_mpath(name) == 0) {
> +	if (dm_is_mpath(name) != DM_IS_MPATH_YES) {
>  		condlog(0, "%s: not a multipath device. can't watch events",
>  			name);
>  		return -1;
> diff --git a/multipathd/main.c b/multipathd/main.c
> index 58afe14..132bb2e 100644
> --- a/multipathd/main.c
> +++ b/multipathd/main.c
> @@ -865,7 +865,7 @@ ev_add_map (char * dev, const char * alias, struct vectors * vecs)
>  	int reassign_maps;
>  	struct config *conf;
>  
> -	if (dm_is_mpath(alias) != 1) {
> +	if (dm_is_mpath(alias) != DM_IS_MPATH_YES) {
>  		condlog(4, "%s: not a multipath map", alias);
>  		return 0;
>  	}
> -- 
> 2.45.2

