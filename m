Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 922A7143742
	for <dm-devel@lists.linux.dev>; Wed, 10 Jul 2024 23:35:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720654508; cv=none; b=BvxfIoy8y+/7unzkPPX7zCy4reVFNmM16ahKkT3Mqs0+mtHH0V3Lh4RZS/iBntlKooKp7e0LW7uOie2ZiRJxEvHFDSqIbUV3C8en+s/glX2lvztt4LLHeNlt0a3F8ePIS4b9w3qlkaor0BhiPiJEGdLI0afF+HYBrzHtDf8KiLY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720654508; c=relaxed/simple;
	bh=c3EKEWKpvkj3ZYAXL1n39j6FSy+Zn0JeB93Oo9Q/bWc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 In-Reply-To:Content-Type:Content-Disposition; b=l2o9o/62d5/pkHKeO+fiULxqln25PBSli5aQUVKQAs3tI5IcNHcg5RrafqXh8q9/IlBTV7m/DcrmghqawU9mjObk3d7ELoT2V+f+dpi5gruDFp/J5rzzMc/OqYtGwVz3OtCLgv3KCHA25q3nj1+B0UAvS3kWAzL4jA6Pio3jqOE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=gDQEIoga; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="gDQEIoga"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1720654505;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=TBzzUMyvo2C+wir4ZG/xT7Rdosy9lsv4Hnc/zEViZRA=;
	b=gDQEIogauAjT5eTMhYYiTNOBVzgeqD9SyJAA/Rlf5DYqwqAPpYquURrvXQNnh3jnRSOGGQ
	IK6Q3iiGCGz6n//0eXzvXPqkVA2J2IKPlJRsjTrzxhEWtOSCXj7YMg7QzHqOR32r3tinBv
	6jv5epmGSpnUPq8fh2DY8BzcS/OheSs=
Received: from mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-42-8jYpVhl7MZifYYrjjkZyiQ-1; Wed,
 10 Jul 2024 19:35:00 -0400
X-MC-Unique: 8jYpVhl7MZifYYrjjkZyiQ-1
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 0B8C01955F3C;
	Wed, 10 Jul 2024 23:34:59 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (bmarzins-01.fast.eng.rdu2.dc.redhat.com [10.6.23.12])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id A5FD23000182;
	Wed, 10 Jul 2024 23:34:58 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.2/8.17.1) with ESMTPS id 46ANYvAu1922420
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Wed, 10 Jul 2024 19:34:57 -0400
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.2/8.17.2/Submit) id 46ANYvOd1922419;
	Wed, 10 Jul 2024 19:34:57 -0400
Date: Wed, 10 Jul 2024 19:34:56 -0400
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Martin Wilck <martin.wilck@suse.com>
Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>,
        dm-devel@lists.linux.dev
Subject: Re: [PATCH 23/44] libmultipath: improve dm_get_wwid() return value
 logic
Message-ID: <Zo8aoNebaxrgKlzo@redhat.com>
References: <20240709213935.177028-1-mwilck@suse.com>
 <20240709213935.177028-24-mwilck@suse.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <20240709213935.177028-24-mwilck@suse.com>
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Jul 09, 2024 at 11:39:14PM +0200, Martin Wilck wrote:
> Make dm_get_wwid() return different status codes for non-existing maps,
> maps that exists but are not multipath maps, and generic error case,
> and handle these return codes appropriately in callers.
> 
> Signed-off-by: Martin Wilck <mwilck@suse.com>
> ---
>  libmultipath/alias.c     |  5 +++--
>  libmultipath/configure.c | 23 +++++++++++------------
>  libmultipath/devmapper.c | 21 ++++++++++++++++-----
>  libmultipath/wwids.c     |  2 +-
>  tests/alias.c            | 10 +++++-----
>  5 files changed, 36 insertions(+), 25 deletions(-)
> 
> diff --git a/libmultipath/alias.c b/libmultipath/alias.c
> index 10e58a7..2ab9499 100644
> --- a/libmultipath/alias.c
> +++ b/libmultipath/alias.c
> @@ -408,13 +408,14 @@ static bool alias_already_taken(const char *alias, const char *map_wwid)
>  {
>  
>  	char wwid[WWID_SIZE];
> +	int rc = dm_get_wwid(alias, wwid, sizeof(wwid));
>  
>  	/* If the map doesn't exist, it's fine */
> -	if (dm_get_wwid(alias, wwid, sizeof(wwid)) != 0)

We used to assume the alias was not taken if dm_get_wwid() failed with
an error. Now we assume that the alias is taken. I think we should
continue to assume we can use the alias if we get DM_ERR.

> +	if (rc == DMP_NOT_FOUND)
>  		return false;
>  
>  	/* If both the name and the wwid match, it's fine.*/
> -	if (strncmp(map_wwid, wwid, sizeof(wwid)) == 0)
> +	if (rc == DMP_OK && strncmp(map_wwid, wwid, sizeof(wwid)) == 0)
>  		return false;
>  
>  	condlog(3, "%s: alias '%s' already taken, reselecting alias",
> diff --git a/libmultipath/configure.c b/libmultipath/configure.c
> index 666d4e8..565ea5c 100644
> --- a/libmultipath/configure.c
> +++ b/libmultipath/configure.c
> @@ -845,18 +845,17 @@ int domap(struct multipath *mpp, char *params, int is_daemon)
>  
>  	if (mpp->action == ACT_CREATE && dm_map_present(mpp->alias)) {
>  		char wwid[WWID_SIZE];
> +		int rc = dm_get_wwid(mpp->alias, wwid, sizeof(wwid));
>  
> -		if (dm_get_wwid(mpp->alias, wwid, sizeof(wwid)) == 0) {
> -			if (!strncmp(mpp->wwid, wwid, sizeof(wwid))) {
> -				condlog(3, "%s: map already present",
> -					mpp->alias);
> -				mpp->action = ACT_RELOAD;
> -			} else {
> -				condlog(0, "%s: map \"%s\" already present with WWID %s, skipping",
> -					mpp->wwid, mpp->alias, wwid);
> -				condlog(0, "please check alias settings in config and bindings file");
> -				mpp->action = ACT_REJECT;
> -			}
> +		if (rc == DMP_OK && !strncmp(mpp->wwid, wwid, sizeof(wwid))) {
> +			condlog(3, "%s: map already present",
> +				mpp->alias);
> +			mpp->action = ACT_RELOAD;

If we return DMP_NO_MATCH, we'll tell the user that the device is already
present will a WWID of "". This is the same as before, but perhaps it
would be better to tell the user that the alias is in use by a
non-multipath device.

> +		} else if (rc == DMP_OK || rc == DMP_NO_MATCH) {
> +			condlog(1, "%s: map \"%s\" already present with WWID \"%s\", skipping\n"
> +				   "please check alias settings in config and bindings file",
> +				mpp->wwid, mpp->alias, wwid);
> +			mpp->action = ACT_REJECT;
>  		}
>  	}
>  
> @@ -1320,7 +1319,7 @@ static int _get_refwwid(enum mpath_cmds cmd, const char *dev,
>  		break;
>  
>  	case DEV_DEVMAP:
> -		if (((dm_get_wwid(dev, tmpwwid, WWID_SIZE)) == 0)
> +		if (((dm_get_wwid(dev, tmpwwid, WWID_SIZE)) == DMP_OK)
>  		    && (strlen(tmpwwid)))
>  			refwwid = tmpwwid;
>  
> diff --git a/libmultipath/devmapper.c b/libmultipath/devmapper.c
> index 94ef369..1eebcb5 100644
> --- a/libmultipath/devmapper.c
> +++ b/libmultipath/devmapper.c
> @@ -829,19 +829,30 @@ int dm_get_map(const char *name, unsigned long long *size, char **outparams)
>  	}
>  }
>  
> +/**
> + * dm_get_wwid(): return WWID for a multipath map
> + * @returns:
> + *    DMP_OK if successful
> + *    DMP_NOT_FOUND if the map doesn't exist
> + *    DMP_NO_MATCH if the map exists but is not a multipath map
> + *    DMP_ERR for other errors
> + */
>  int dm_get_wwid(const char *name, char *uuid, int uuid_len)
>  {
>  	char tmp[DM_UUID_LEN];
> +	int rc = dm_get_dm_uuid(name, tmp);
>  
> -	if (dm_get_dm_uuid(name, tmp) != DMP_OK)
> -		return 1;
> +	if (rc != DMP_OK)
> +		return rc;
>  
>  	if (!strncmp(tmp, UUID_PREFIX, UUID_PREFIX_LEN))
>  		strlcpy(uuid, tmp + UUID_PREFIX_LEN, uuid_len);
> -	else
> +	else {

This seems a little inconsistent with the change in our returns.
Before, if we found a device but it wasn't multipath device,
dm_get_wwid() would exit with 0 but set uuid to an empty string. Now we
return DMP_NO_MATCH in this case but we still clear uuid. It seems like
perhaps we should either set uuid to an empty string for all cases
except DM_OK or we should not touch it for all cases except DM_OK.
Alternatively, perhaps I'm over-thinking this.

-Ben 

>  		uuid[0] = '\0';
> +		return DMP_NO_MATCH;
> +	}
>  
> -	return 0;
> +	return DMP_OK;
>  }
>  
>  static int is_mpath_part(const char *part_name, const char *map_name)
> @@ -1377,7 +1388,7 @@ struct multipath *dm_get_multipath(const char *name)
>  	if (dm_get_map(name, &mpp->size, NULL) != DMP_OK)
>  		goto out;
>  
> -	if (dm_get_wwid(name, mpp->wwid, WWID_SIZE) != 0)
> +	if (dm_get_wwid(name, mpp->wwid, WWID_SIZE) != DMP_OK)
>  		condlog(2, "%s: failed to get uuid for %s", __func__, name);
>  	if (dm_get_info(name, &mpp->dmi) != 0)
>  		condlog(2, "%s: failed to get info for %s", __func__, name);
> diff --git a/libmultipath/wwids.c b/libmultipath/wwids.c
> index 7a4cb74..aac18c0 100644
> --- a/libmultipath/wwids.c
> +++ b/libmultipath/wwids.c
> @@ -295,7 +295,7 @@ should_multipath(struct path *pp1, vector pathvec, vector mpvec)
>  		struct multipath *mp = find_mp_by_wwid(mpvec, pp1->wwid);
>  
>  		if (mp != NULL &&
> -		    dm_get_wwid(mp->alias, tmp_wwid, WWID_SIZE) == 0 &&
> +		    dm_get_wwid(mp->alias, tmp_wwid, WWID_SIZE) == DMP_OK &&
>  		    !strncmp(tmp_wwid, pp1->wwid, WWID_SIZE)) {
>  			condlog(3, "wwid %s is already multipathed, keeping it",
>  				pp1->wwid);
> diff --git a/tests/alias.c b/tests/alias.c
> index 1f78656..a95b308 100644
> --- a/tests/alias.c
> +++ b/tests/alias.c
> @@ -84,7 +84,7 @@ int __wrap_dm_get_wwid(const char *name, char *uuid, int uuid_len)
>  	check_expected(uuid_len);
>  	assert_non_null(uuid);
>  	ret = mock_type(int);
> -	if (ret == 0)
> +	if (ret == DMP_OK)
>  		strcpy(uuid, mock_ptr_type(char *));
>  	return ret;
>  }
> @@ -438,14 +438,14 @@ static void mock_unused_alias(const char *alias)
>  {
>  	expect_string(__wrap_dm_get_wwid, name, alias);
>  	expect_value(__wrap_dm_get_wwid, uuid_len, WWID_SIZE);
> -	will_return(__wrap_dm_get_wwid, 1);
> +	will_return(__wrap_dm_get_wwid, DMP_NOT_FOUND);
>  }
>  
>  static void mock_self_alias(const char *alias, const char *wwid)
>  {
>  	expect_string(__wrap_dm_get_wwid, name, alias);
>  	expect_value(__wrap_dm_get_wwid, uuid_len, WWID_SIZE);
> -	will_return(__wrap_dm_get_wwid, 0);
> +	will_return(__wrap_dm_get_wwid, DMP_OK);
>  	will_return(__wrap_dm_get_wwid, wwid);
>  }
>  
> @@ -471,14 +471,14 @@ static void mock_self_alias(const char *alias, const char *wwid)
>  	do {								\
>  		expect_string(__wrap_dm_get_wwid, name, alias);		\
>  		expect_value(__wrap_dm_get_wwid, uuid_len, WWID_SIZE);	\
> -		will_return(__wrap_dm_get_wwid, 1);			\
> +		will_return(__wrap_dm_get_wwid, DMP_NOT_FOUND);		\
>  	} while (0)
>  
>  #define mock_used_alias(alias, wwid)					\
>  	do {								\
>  		expect_string(__wrap_dm_get_wwid, name, alias);		\
>  		expect_value(__wrap_dm_get_wwid, uuid_len, WWID_SIZE);	\
> -		will_return(__wrap_dm_get_wwid, 0);			\
> +		will_return(__wrap_dm_get_wwid, DMP_OK);		\
>  		will_return(__wrap_dm_get_wwid, "WWID_USED");		\
>  		expect_condlog(3, USED_STR(alias, wwid));		\
>  	} while(0)
> -- 
> 2.45.2

