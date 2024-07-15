Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A93A622626
	for <dm-devel@lists.linux.dev>; Mon, 15 Jul 2024 23:25:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721085906; cv=none; b=DnbmYJsDUd6B2mcPT9IbsqnvQmQSaWSUYYwZBa3OG1obDR1EUHvrWRToxt/FsqG4v4MOgPy0Jl0uktHyWtJNbMb8o7AhQbVwZpwCGFPNIP2y+nWaFTIa4oEzmekEdnoBVgs6m9eas/H0NHvRN5iSekXH34uScZES5WRL1gHJSeA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721085906; c=relaxed/simple;
	bh=rv9joB84zuf15TthSkYsE5IEx+9McYUk0eeFu2jMu28=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 In-Reply-To:Content-Type:Content-Disposition; b=Y4SIk1g7pMPKZlGWvRO2UKnu9SeTe/8u7Su5vjS182mGadf1Pg/FazBeiXx7tkg4zpHTAl6zPPseuzW/w82+WN3gw3joLH+kleBk83AlNaGMUMBVOz8wmtN39hWpR0EL/cf4SWSbJiWwlQVuwmu8SWVjwQo6EFN55jSuqXLkwVU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=gGw1TeUb; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="gGw1TeUb"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1721085902;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=3uyKFsZacYobpoUYEQsUn6psPFKW8S9Ip+jlKfKvC8U=;
	b=gGw1TeUbVr0xAh1KFcp3APBV7/IZHqpm7aVGUHLLbbgVHCYWTrfjspo14UvYT9UTG6WvcY
	9yL6xF0Rw/AYXu85YUiTwTNFMl1f1YZ8pMnCohJU6rdKRCMrlhHV64bueus4YtJ309ZSmr
	cHKmDHOJkol9wT1w3+YropvB12Aq3e0=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-121-Ue_Bvsl9MeKAqU-8lRkDdQ-1; Mon,
 15 Jul 2024 19:24:54 -0400
X-MC-Unique: Ue_Bvsl9MeKAqU-8lRkDdQ-1
Received: from mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.40])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 0018D19560BA;
	Mon, 15 Jul 2024 23:24:52 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (bmarzins-01.fast.eng.rdu2.dc.redhat.com [10.6.23.12])
	by mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 56A48195605A;
	Mon, 15 Jul 2024 23:24:52 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.2/8.17.1) with ESMTPS id 46FNOoxA2097838
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Mon, 15 Jul 2024 19:24:50 -0400
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.2/8.17.2/Submit) id 46FNOouS2097837;
	Mon, 15 Jul 2024 19:24:50 -0400
Date: Mon, 15 Jul 2024 19:24:50 -0400
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Martin Wilck <martin.wilck@suse.com>
Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>,
        dm-devel@lists.linux.dev, Martin Wilck <mwilck@suse.com>
Subject: Re: [PATCH v2 48/49] libmultipath: Move UUID check into
 libmp_pathinfo__()
Message-ID: <ZpWvwq0cnQfR6qh2@redhat.com>
References: <20240712171458.77611-1-mwilck@suse.com>
 <20240712171458.77611-49-mwilck@suse.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <20240712171458.77611-49-mwilck@suse.com>
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.40
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Jul 12, 2024 at 07:14:56PM +0200, Martin Wilck wrote:
> We have a couple of callers that check whether the map UUID conforms
> to the multipath convention ("mpath-xyz"). Move this check into
> libmp_mapinfo__(). Add another flag MAPINFO_CHECK_UUID for this
> purpose. This allows to simplify some callers, which only fetched
> the UUID in order to check it.
> 
> Note that the UUID check is orthogonal to MAPINFO_MPATH_ONLY, which
> tests the target type. We shold make sure that both tests are in
> agreement, but this is postponed to a later patch set.
> 
> is_mpath_uuid() can now be converted to a static function.
> 
> Also add some unit tests for the WWID check.
> 
Reviewed-by: Benjamin Marzinski <bmarzins@redhat.com>
> Signed-off-by: Martin Wilck <mwilck@suse.com>
> ---
>  libmpathpersist/mpath_persist_int.c |  11 +-
>  libmultipath/devmapper.c            |  52 +++----
>  libmultipath/devmapper.h            |   3 +-
>  libmultipath/libmultipath.version   |   1 -
>  multipath/main.c                    |   5 +-
>  multipathd/main.c                   |   7 +-
>  tests/mapinfo.c                     | 226 ++++++++++++++++++++++++++++
>  7 files changed, 256 insertions(+), 49 deletions(-)
> 
> diff --git a/libmpathpersist/mpath_persist_int.c b/libmpathpersist/mpath_persist_int.c
> index 807415f..f4d9e7c 100644
> --- a/libmpathpersist/mpath_persist_int.c
> +++ b/libmpathpersist/mpath_persist_int.c
> @@ -158,7 +158,7 @@ static int mpath_get_map(vector curmp, vector pathvec, int fd, struct multipath
>  {
>  	int rc;
>  	struct stat info;
> -	char alias[WWID_SIZE], uuid[DM_UUID_LEN];
> +	char alias[WWID_SIZE];
>  	struct multipath *mpp;
>  
>  	if (fstat(fd, &info) != 0){
> @@ -171,14 +171,11 @@ static int mpath_get_map(vector curmp, vector pathvec, int fd, struct multipath
>  	}
>  
>  	/* get alias from major:minor*/
> -	rc = libmp_mapinfo(DM_MAP_BY_DEVT | MAPINFO_MPATH_ONLY,
> +	rc = libmp_mapinfo(DM_MAP_BY_DEVT | MAPINFO_MPATH_ONLY | MAPINFO_CHECK_UUID,
>  			   (mapid_t) { .devt = info.st_rdev },
> -			   (mapinfo_t) {
> -				   .name = alias,
> -				   .uuid = uuid,
> -			   });
> +			   (mapinfo_t) { .name = alias });
>  
> -	if (rc == DMP_NO_MATCH || !is_mpath_uuid(uuid)) {
> +	if (rc == DMP_NO_MATCH) {
>  		condlog(3, "%s: not a multipath device.", alias);
>  		return MPATH_PR_DMMP_ERROR;
>  	} else if (rc != DMP_OK) {
> diff --git a/libmultipath/devmapper.c b/libmultipath/devmapper.c
> index d9d96be..bbbadee 100644
> --- a/libmultipath/devmapper.c
> +++ b/libmultipath/devmapper.c
> @@ -611,6 +611,11 @@ int dm_addmap_reload(struct multipath *mpp, char *params, int flush)
>  	return 0;
>  }
>  
> +static bool is_mpath_uuid(const char uuid[DM_UUID_LEN])
> +{
> +	return !strncmp(uuid, UUID_PREFIX, UUID_PREFIX_LEN);
> +}
> +
>  bool
>  has_dm_info(const struct multipath *mpp)
>  {
> @@ -734,11 +739,17 @@ static int libmp_mapinfo__(int flags, mapid_t id, mapinfo_t info, const char *ma
>  	 * If error is returned, don't touch any output parameters.
>  	 */
>  	if ((info.name && !(name = dm_task_get_name(dmt)))
> -	    || (info.uuid && !(uuid = dm_task_get_uuid(dmt)))
> +	    || ((info.uuid || flags & MAPINFO_CHECK_UUID)
> +		&& !(uuid = dm_task_get_uuid(dmt)))
>  	    || (info.status && !(tmp_status = strdup(params)))
>  	    || (info.target && !tmp_target && !(tmp_target = strdup(params))))
>  		return DMP_ERR;
>  
> +	if (flags & MAPINFO_CHECK_UUID && !is_mpath_uuid(uuid)) {
> +		condlog(3, "%s: UUID mismatch: %s", __func__, uuid);
> +		return DMP_NO_MATCH;
> +	}
> +
>  	if (info.name) {
>  		strlcpy(info.name, name, WWID_SIZE);
>  		condlog(4, "%s: %s: name: \"%s\"", __func__, map_id, info.name);
> @@ -808,18 +819,6 @@ int libmp_mapinfo(int flags, mapid_t id, mapinfo_t info)
>  			       libmp_map_identifier(flags, id, idbuf));
>  }
>  
> -static int dm_get_dm_uuid(const char *mapname, char uuid[DM_UUID_LEN])
> -{
> -	return libmp_mapinfo(DM_MAP_BY_NAME,
> -			     (mapid_t) { .str = mapname },
> -			     (mapinfo_t) { .uuid = uuid });
> -}
> -
> -bool is_mpath_uuid(const char uuid[DM_UUID_LEN])
> -{
> -	return !strncmp(uuid, UUID_PREFIX, UUID_PREFIX_LEN);
> -}
> -
>  /**
>   * dm_get_wwid(): return WWID for a multipath map
>   * @returns:
> @@ -832,16 +831,14 @@ bool is_mpath_uuid(const char uuid[DM_UUID_LEN])
>  int dm_get_wwid(const char *name, char *uuid, int uuid_len)
>  {
>  	char tmp[DM_UUID_LEN];
> -	int rc = dm_get_dm_uuid(name, tmp);
> +	int rc = libmp_mapinfo(DM_MAP_BY_NAME | MAPINFO_CHECK_UUID,
> +			       (mapid_t) { .str = name },
> +			       (mapinfo_t) { .uuid = tmp });
>  
>  	if (rc != DMP_OK)
>  		return rc;
>  
> -	if (is_mpath_uuid(tmp))
> -		strlcpy(uuid, tmp + UUID_PREFIX_LEN, uuid_len);
> -	else
> -		return DMP_NO_MATCH;
> -
> +	strlcpy(uuid, tmp + UUID_PREFIX_LEN, uuid_len);
>  	return DMP_OK;
>  }
>  
> @@ -859,16 +856,13 @@ static bool is_mpath_part_uuid(const char part_uuid[DM_UUID_LEN],
>  
>  int dm_is_mpath(const char *name)
>  {
> -	char uuid[DM_UUID_LEN];
> -	int rc = libmp_mapinfo(DM_MAP_BY_NAME | MAPINFO_MPATH_ONLY,
> +	int rc = libmp_mapinfo(DM_MAP_BY_NAME | MAPINFO_MPATH_ONLY | MAPINFO_CHECK_UUID,
>  			       (mapid_t) { .str = name },
> -			       (mapinfo_t) { .uuid = uuid });
> +			       (mapinfo_t) { .uuid = NULL });
>  
>  	switch (rc) {
>  	case DMP_OK:
> -		if (is_mpath_uuid(uuid))
> -			return DM_IS_MPATH_YES;
> -		/* fallthrough */
> +		return DM_IS_MPATH_YES;
>  	case DMP_NOT_FOUND:
>  	case DMP_NO_MATCH:
>  		return DM_IS_MPATH_NO;
> @@ -974,14 +968,10 @@ int _dm_flush_map (const char *mapname, int flags, int retries)
>  	int queue_if_no_path = 0;
>  	int udev_flags = 0;
>  	char *params __attribute__((cleanup(cleanup_charp))) = NULL;
> -	char uuid[DM_UUID_LEN];
>  
> -	if (libmp_mapinfo(DM_MAP_BY_NAME | MAPINFO_MPATH_ONLY,
> +	if (libmp_mapinfo(DM_MAP_BY_NAME | MAPINFO_MPATH_ONLY | MAPINFO_CHECK_UUID,
>  			  (mapid_t) { .str = mapname },
> -			  (mapinfo_t) {
> -				  .uuid = uuid,
> -				  .target = &params }) != DMP_OK
> -	    || !is_mpath_uuid(uuid))
> +			  (mapinfo_t) { .target = &params }) != DMP_OK)
>  		return DM_FLUSH_OK; /* nothing to do */
>  
>  	/* if the device currently has no partitions, do not
> diff --git a/libmultipath/devmapper.h b/libmultipath/devmapper.h
> index 6eb5ab9..c28991f 100644
> --- a/libmultipath/devmapper.h
> +++ b/libmultipath/devmapper.h
> @@ -57,6 +57,8 @@ enum __mapinfo_flags {
>  	/* Fail if target type is not "partition" (linear) */
>  	MAPINFO_PART_ONLY   = (1 << 4),
>  	__MAPINFO_TGT_TYPE  = (MAPINFO_MPATH_ONLY | MAPINFO_PART_ONLY),
> +	/* Fail if the UUID doesn't match the multipath UUID format */
> +	MAPINFO_CHECK_UUID  = (1 << 8),
>  };
>  
>  typedef union libmp_map_identifier {
> @@ -138,7 +140,6 @@ enum {
>  	DM_IS_MPATH_ERR,
>  };
>  
> -bool is_mpath_uuid(const char uuid[DM_UUID_LEN]);
>  int dm_is_mpath(const char *name);
>  
>  enum {
> diff --git a/libmultipath/libmultipath.version b/libmultipath/libmultipath.version
> index 649c1cb..959f675 100644
> --- a/libmultipath/libmultipath.version
> +++ b/libmultipath/libmultipath.version
> @@ -127,7 +127,6 @@ global:
>  	init_foreign;
>  	init_prio;
>  	io_err_stat_handle_pathfail;
> -	is_mpath_uuid;
>  	is_path_valid;
>  	libmp_dm_task_create;
>  	libmp_get_version;
> diff --git a/multipath/main.c b/multipath/main.c
> index 0d989dc..4b19d2e 100644
> --- a/multipath/main.c
> +++ b/multipath/main.c
> @@ -254,7 +254,7 @@ static int check_usable_paths(struct config *conf,
>  	if (pathvec == NULL)
>  		return r;
>  
> -	if (libmp_mapinfo(DM_MAP_BY_DEVT | MAPINFO_MPATH_ONLY,
> +	if (libmp_mapinfo(DM_MAP_BY_DEVT | MAPINFO_MPATH_ONLY | MAPINFO_CHECK_UUID,
>  			  (mapid_t) { .devt = devt },
>  			  (mapinfo_t) {
>  			      .name = mpp->alias,
> @@ -266,9 +266,6 @@ static int check_usable_paths(struct config *conf,
>  		      }) != DMP_OK)
>  		return r;
>  
> -	if (!is_mpath_uuid(uuid))
> -		return r;
> -
>  	strlcpy(mpp->wwid, uuid + UUID_PREFIX_LEN, sizeof(mpp->wwid));
>  
>  	if (update_multipath_table__(mpp, pathvec, 0, params, status) != DMP_OK)
> diff --git a/multipathd/main.c b/multipathd/main.c
> index 13af94e..386cd07 100644
> --- a/multipathd/main.c
> +++ b/multipathd/main.c
> @@ -720,7 +720,7 @@ static int add_map_without_path (struct vectors *vecs, const char *alias)
>  	if (!mpp || !(mpp->alias = strdup(alias)))
>  		return DMP_ERR;
>  
> -	if ((rc = libmp_mapinfo(DM_MAP_BY_NAME | MAPINFO_MPATH_ONLY,
> +	if ((rc = libmp_mapinfo(DM_MAP_BY_NAME | MAPINFO_MPATH_ONLY | MAPINFO_CHECK_UUID,
>  				(mapid_t) { .str = mpp->alias },
>  				(mapinfo_t) {
>  					.uuid = uuid,
> @@ -731,10 +731,7 @@ static int add_map_without_path (struct vectors *vecs, const char *alias)
>  				})) != DMP_OK)
>  		return rc;
>  
> -	if (!is_mpath_uuid(uuid))
> -		return DMP_NO_MATCH;
> -	else
> -		strlcpy(mpp->wwid, uuid + UUID_PREFIX_LEN, sizeof(mpp->wwid));
> +	strlcpy(mpp->wwid, uuid + UUID_PREFIX_LEN, sizeof(mpp->wwid));
>  
>  	if (!strlen(mpp->wwid))
>  		condlog(1, "%s: adding map with empty WWID", mpp->alias);
> diff --git a/tests/mapinfo.c b/tests/mapinfo.c
> index f3a8440..f7ad868 100644
> --- a/tests/mapinfo.c
> +++ b/tests/mapinfo.c
> @@ -54,6 +54,16 @@ static const char MPATH_STATUS_01[] =
>  	"A 0 3 2 65:32 A 0 0 1 67:64 A 0 0 1 69:96 A 0 0 1 "
>  	"E 0 3 2 8:16 A 0 0 1 66:48 A 0 0 1 68:80 A 0 0 1 ";
>  
> +static const char BAD_UUID_01[] = "";
> +static const char BAD_UUID_02[] = "mpath3600a098038302d414b2b4d4453474f62";
> +static const char BAD_UUID_03[] = " mpath-3600a098038302d414b2b4d4453474f62";
> +static const char BAD_UUID_04[] = "-mpath-3600a098038302d414b2b4d4453474f62";
> +static const char BAD_UUID_05[] = "mpth-3600a098038302d414b2b4d4453474f62";
> +static const char BAD_UUID_06[] = "part1-mpath-3600a098038302d414b2b4d4453474f62";
> +static const char BAD_UUID_07[] = "mpath 3600a098038302d414b2b4d4453474f62";
> +static const char BAD_UUID_08[] = "mpath";
> +static const char BAD_UUID_09[] = "mpath-";
> +
>  char *__real_strdup(const char *str);
>  char *__wrap_strdup(const char *str)
>  {
> @@ -413,6 +423,208 @@ static void test_mapinfo_good_exists(void **state)
>  	assert_int_equal(rc, DMP_OK);
>  }
>  
> +static void test_mapinfo_bad_check_uuid_00(void **state)
> +{
> +	int rc;
> +
> +	mock_mapinfo_name_1(DM_DEVICE_INFO, 1, "foo", 1, 1, 0);
> +	WRAP_DM_TASK_GET_INFO(1);
> +	WRAP_DM_TASK_GET_INFO(&MPATH_DMI_01);
> +	will_return(__wrap_dm_task_get_uuid, NULL);
> +	rc = libmp_mapinfo(DM_MAP_BY_NAME | MAPINFO_CHECK_UUID,
> +			   (mapid_t) { .str = "foo", },
> +			   (mapinfo_t) { .name = NULL });
> +	assert_int_equal(rc, DMP_ERR);
> +}
> +
> +static void test_mapinfo_bad_check_uuid_01(void **state)
> +{
> +	int rc;
> +
> +	mock_mapinfo_name_1(DM_DEVICE_INFO, 1, "foo", 1, 1, 0);
> +	WRAP_DM_TASK_GET_INFO(1);
> +	WRAP_DM_TASK_GET_INFO(&MPATH_DMI_01);
> +	will_return(__wrap_dm_task_get_uuid, BAD_UUID_01);
> +	rc = libmp_mapinfo(DM_MAP_BY_NAME | MAPINFO_CHECK_UUID,
> +			   (mapid_t) { .str = "foo", },
> +			   (mapinfo_t) { .name = NULL });
> +	assert_int_equal(rc, DMP_NO_MATCH);
> +}
> +
> +static void test_mapinfo_bad_check_uuid_02(void **state)
> +{
> +	int rc;
> +
> +	mock_mapinfo_name_1(DM_DEVICE_INFO, 1, "foo", 1, 1, 0);
> +	WRAP_DM_TASK_GET_INFO(1);
> +	WRAP_DM_TASK_GET_INFO(&MPATH_DMI_01);
> +	will_return(__wrap_dm_task_get_uuid, BAD_UUID_02);
> +	rc = libmp_mapinfo(DM_MAP_BY_NAME | MAPINFO_CHECK_UUID,
> +			   (mapid_t) { .str = "foo", },
> +			   (mapinfo_t) { .name = NULL });
> +	assert_int_equal(rc, DMP_NO_MATCH);
> +}
> +
> +static void test_mapinfo_bad_check_uuid_03(void **state)
> +{
> +	int rc;
> +
> +	mock_mapinfo_name_1(DM_DEVICE_INFO, 1, "foo", 1, 1, 0);
> +	WRAP_DM_TASK_GET_INFO(1);
> +	WRAP_DM_TASK_GET_INFO(&MPATH_DMI_01);
> +	will_return(__wrap_dm_task_get_uuid, BAD_UUID_03);
> +	rc = libmp_mapinfo(DM_MAP_BY_NAME | MAPINFO_CHECK_UUID,
> +			   (mapid_t) { .str = "foo", },
> +			   (mapinfo_t) { .name = NULL });
> +	assert_int_equal(rc, DMP_NO_MATCH);
> +}
> +
> +static void test_mapinfo_bad_check_uuid_04(void **state)
> +{
> +	int rc;
> +
> +	mock_mapinfo_name_1(DM_DEVICE_INFO, 1, "foo", 1, 1, 0);
> +	WRAP_DM_TASK_GET_INFO(1);
> +	WRAP_DM_TASK_GET_INFO(&MPATH_DMI_01);
> +	will_return(__wrap_dm_task_get_uuid, BAD_UUID_04);
> +	rc = libmp_mapinfo(DM_MAP_BY_NAME | MAPINFO_CHECK_UUID,
> +			   (mapid_t) { .str = "foo", },
> +			   (mapinfo_t) { .name = NULL });
> +	assert_int_equal(rc, DMP_NO_MATCH);
> +}
> +
> +static void test_mapinfo_bad_check_uuid_05(void **state)
> +{
> +	int rc;
> +
> +	mock_mapinfo_name_1(DM_DEVICE_INFO, 1, "foo", 1, 1, 0);
> +	WRAP_DM_TASK_GET_INFO(1);
> +	WRAP_DM_TASK_GET_INFO(&MPATH_DMI_01);
> +	will_return(__wrap_dm_task_get_uuid, BAD_UUID_05);
> +	rc = libmp_mapinfo(DM_MAP_BY_NAME | MAPINFO_CHECK_UUID,
> +			   (mapid_t) { .str = "foo", },
> +			   (mapinfo_t) { .name = NULL });
> +	assert_int_equal(rc, DMP_NO_MATCH);
> +}
> +
> +static void test_mapinfo_bad_check_uuid_06(void **state)
> +{
> +	int rc;
> +
> +	mock_mapinfo_name_1(DM_DEVICE_INFO, 1, "foo", 1, 1, 0);
> +	WRAP_DM_TASK_GET_INFO(1);
> +	WRAP_DM_TASK_GET_INFO(&MPATH_DMI_01);
> +	will_return(__wrap_dm_task_get_uuid, BAD_UUID_06);
> +	rc = libmp_mapinfo(DM_MAP_BY_NAME | MAPINFO_CHECK_UUID,
> +			   (mapid_t) { .str = "foo", },
> +			   (mapinfo_t) { .name = NULL });
> +	assert_int_equal(rc, DMP_NO_MATCH);
> +}
> +
> +static void test_mapinfo_bad_check_uuid_07(void **state)
> +{
> +	int rc;
> +
> +	mock_mapinfo_name_1(DM_DEVICE_INFO, 1, "foo", 1, 1, 0);
> +	WRAP_DM_TASK_GET_INFO(1);
> +	WRAP_DM_TASK_GET_INFO(&MPATH_DMI_01);
> +	will_return(__wrap_dm_task_get_uuid, BAD_UUID_07);
> +	rc = libmp_mapinfo(DM_MAP_BY_NAME | MAPINFO_CHECK_UUID,
> +			   (mapid_t) { .str = "foo", },
> +			   (mapinfo_t) { .name = NULL });
> +	assert_int_equal(rc, DMP_NO_MATCH);
> +}
> +
> +static void test_mapinfo_bad_check_uuid_08(void **state)
> +{
> +	int rc;
> +
> +	mock_mapinfo_name_1(DM_DEVICE_INFO, 1, "foo", 1, 1, 0);
> +	WRAP_DM_TASK_GET_INFO(1);
> +	WRAP_DM_TASK_GET_INFO(&MPATH_DMI_01);
> +	will_return(__wrap_dm_task_get_uuid, BAD_UUID_08);
> +	rc = libmp_mapinfo(DM_MAP_BY_NAME | MAPINFO_CHECK_UUID,
> +			   (mapid_t) { .str = "foo", },
> +			   (mapinfo_t) { .name = NULL });
> +	assert_int_equal(rc, DMP_NO_MATCH);
> +}
> +
> +static void test_mapinfo_bad_check_uuid_09(void **state)
> +{
> +	int rc;
> +
> +	mock_mapinfo_name_1(DM_DEVICE_INFO, 1, "foo", 1, 1, 0);
> +	WRAP_DM_TASK_GET_INFO(1);
> +	WRAP_DM_TASK_GET_INFO(&MPATH_DMI_01);
> +	will_return(__wrap_dm_task_get_uuid, BAD_UUID_09);
> +	rc = libmp_mapinfo(DM_MAP_BY_NAME | MAPINFO_CHECK_UUID,
> +			   (mapid_t) { .str = "foo", },
> +			   (mapinfo_t) { .name = NULL });
> +	assert_int_equal(rc, DMP_OK);
> +}
> +
> +static void test_mapinfo_good_check_uuid_01(void **state)
> +{
> +	int rc;
> +
> +	mock_mapinfo_name_1(DM_DEVICE_INFO, 1, "foo", 1, 1, 0);
> +	WRAP_DM_TASK_GET_INFO(1);
> +	WRAP_DM_TASK_GET_INFO(&MPATH_DMI_01);
> +	will_return(__wrap_dm_task_get_uuid, MPATH_UUID_01);
> +	rc = libmp_mapinfo(DM_MAP_BY_NAME | MAPINFO_CHECK_UUID,
> +			   (mapid_t) { .str = "foo", },
> +			   (mapinfo_t) { .name = NULL });
> +	assert_int_equal(rc, DMP_OK);
> +}
> +
> +static void test_mapinfo_good_check_uuid_02(void **state)
> +{
> +	int rc;
> +	char uuid[DM_UUID_LEN];
> +
> +	mock_mapinfo_name_1(DM_DEVICE_INFO, 1, "foo", 1, 1, 0);
> +	WRAP_DM_TASK_GET_INFO(1);
> +	WRAP_DM_TASK_GET_INFO(&MPATH_DMI_01);
> +	will_return(__wrap_dm_task_get_uuid, MPATH_UUID_01);
> +	rc = libmp_mapinfo(DM_MAP_BY_NAME | MAPINFO_CHECK_UUID,
> +			   (mapid_t) { .str = "foo", },
> +			   (mapinfo_t) { .uuid = uuid });
> +	assert_int_equal(rc, DMP_OK);
> +}
> +
> +static void test_mapinfo_good_check_uuid_03(void **state)
> +{
> +	int rc;
> +
> +	mock_mapinfo_name_1(DM_DEVICE_STATUS, 1, "foo", 1, 1, 0);
> +	WRAP_DM_TASK_GET_INFO(1);
> +	WRAP_DM_TASK_GET_INFO(&MPATH_DMI_01);
> +	mock_dm_get_next_target(12345, TGT_MPATH, MPATH_STATUS_01, NULL);
> +	will_return(__wrap_dm_task_get_uuid, MPATH_UUID_01);
> +	rc = libmp_mapinfo(DM_MAP_BY_NAME | MAPINFO_MPATH_ONLY | MAPINFO_CHECK_UUID,
> +			   (mapid_t) { .str = "foo", },
> +			   (mapinfo_t) { .name = NULL });
> +	assert_int_equal(rc, DMP_OK);
> +}
> +
> +static void test_mapinfo_good_check_uuid_04(void **state)
> +{
> +	char __attribute__((cleanup(cleanup_charp))) *target = NULL;
> +	int rc;
> +
> +	mock_mapinfo_name_1(DM_DEVICE_TABLE, 1, "foo", 1, 1, 0);
> +	WRAP_DM_TASK_GET_INFO(1);
> +	WRAP_DM_TASK_GET_INFO(&MPATH_DMI_01);
> +	mock_dm_get_next_target(12345, TGT_MPATH, MPATH_STATUS_01, NULL);
> +	will_return(__wrap_dm_task_get_uuid, MPATH_UUID_01);
> +	will_return(__wrap_strdup, 1);
> +
> +	rc = libmp_mapinfo(DM_MAP_BY_NAME | MAPINFO_MPATH_ONLY | MAPINFO_CHECK_UUID,
> +			   (mapid_t) { .str = "foo", },
> +			   (mapinfo_t) { .target = &target });
> +	assert_int_equal(rc, DMP_OK);
> +}
> +
>  static void test_mapinfo_bad_set_uuid(void **state)
>  {
>  	int rc;
> @@ -1126,6 +1338,20 @@ static int test_mapinfo(void)
>  		cmocka_unit_test(test_mapinfo_bad_get_info_03),
>  		cmocka_unit_test(test_mapinfo_bad_get_info_04),
>  		cmocka_unit_test(test_mapinfo_good_exists),
> +		cmocka_unit_test(test_mapinfo_bad_check_uuid_00),
> +		cmocka_unit_test(test_mapinfo_bad_check_uuid_01),
> +		cmocka_unit_test(test_mapinfo_bad_check_uuid_02),
> +		cmocka_unit_test(test_mapinfo_bad_check_uuid_03),
> +		cmocka_unit_test(test_mapinfo_bad_check_uuid_04),
> +		cmocka_unit_test(test_mapinfo_bad_check_uuid_05),
> +		cmocka_unit_test(test_mapinfo_bad_check_uuid_06),
> +		cmocka_unit_test(test_mapinfo_bad_check_uuid_07),
> +		cmocka_unit_test(test_mapinfo_bad_check_uuid_08),
> +		cmocka_unit_test(test_mapinfo_bad_check_uuid_09),
> +		cmocka_unit_test(test_mapinfo_good_check_uuid_01),
> +		cmocka_unit_test(test_mapinfo_good_check_uuid_02),
> +		cmocka_unit_test(test_mapinfo_good_check_uuid_03),
> +		cmocka_unit_test(test_mapinfo_good_check_uuid_04),
>  		cmocka_unit_test(test_mapinfo_bad_set_uuid),
>  		cmocka_unit_test(test_mapinfo_bad_set_dev_01),
>  		cmocka_unit_test(test_mapinfo_bad_set_dev_02),
> -- 
> 2.45.2

