Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE9D81CA80
	for <dm-devel@lists.linux.dev>; Mon, 15 Jul 2024 22:42:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721083358; cv=none; b=YOnmWkgp850lXxz30ybzrvEi8EgGWP+xZIU0T7mvdgQvT2DVuB7cvrYssVWkqgF6yheSrq4TKbHvlamyOo/dLUpbwJgphorpE4nJ2jdoQtkwhGh0za7pjGyKxaiaRPddzS/pXemFjJpIEXA02mFh0X71Wjgp9I0vflilt3KHueQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721083358; c=relaxed/simple;
	bh=HeceTMM/jSCwEzfjDTuC5FUXiM2M+EZjxZxUcDukXQw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 In-Reply-To:Content-Type:Content-Disposition; b=tmQtsMOnDmqcD1GckOVDISQG9KXC7YPrVL4ZrtcDir+cAD2sg13q5jLCSMaapliGoHUIfr2DohigmuiyQ/ZIk2kH6uQ1+wltpVJK84610nH1iaOhcV0Sw6CdwqTQpgnJSufnYnAxuhpQ2EgMYkyuTeKgbes/2gJu02okjAuywJc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=LDr3dN/P; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="LDr3dN/P"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1721083355;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=jB0VqKXQvRJd2CHnNgIIy9g4WBGHANTs+y9myNeQIpo=;
	b=LDr3dN/PT5jJhAZ33L+3cUf6gO2EMTo/W0wV3MRvQjCSY+qYee7qYK+jXK9IJAwPkNuWX0
	g/RWnrDGSa6ekdjD+nLVwLrnHlgMV1NyPKX56ph1FFe6lFFvciQHiUtDVCiaUrz+dH7vCd
	O2+8thSwDhUPedJ9qCzqwIiaip05AVg=
Received: from mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-610-P0aFL9EtP_ue4w2J-c3VJA-1; Mon,
 15 Jul 2024 18:42:33 -0400
X-MC-Unique: P0aFL9EtP_ue4w2J-c3VJA-1
Received: from mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.40])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id AF5581955D55;
	Mon, 15 Jul 2024 22:42:32 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (bmarzins-01.fast.eng.rdu2.dc.redhat.com [10.6.23.12])
	by mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 5CDBC1955D42;
	Mon, 15 Jul 2024 22:42:32 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.2/8.17.1) with ESMTPS id 46FMgUTe2096714
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Mon, 15 Jul 2024 18:42:31 -0400
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.2/8.17.2/Submit) id 46FMgUfh2096713;
	Mon, 15 Jul 2024 18:42:30 -0400
Date: Mon, 15 Jul 2024 18:42:30 -0400
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Martin Wilck <martin.wilck@suse.com>
Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>,
        dm-devel@lists.linux.dev, Martin Wilck <mwilck@suse.com>
Subject: Re: [PATCH v2 25/49] libmultipath: improve dm_get_wwid() return
 value logic
Message-ID: <ZpWl1qrpqZ-TQulk@redhat.com>
References: <20240712171458.77611-1-mwilck@suse.com>
 <20240712171458.77611-26-mwilck@suse.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <20240712171458.77611-26-mwilck@suse.com>
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.40
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Jul 12, 2024 at 07:14:33PM +0200, Martin Wilck wrote:
> Make dm_get_wwid() return different status codes for non-existing maps,
> maps that exists but are not multipath maps, and generic error case,
> and handle these return codes appropriately in callers.
> 
> The error handling is als changed; dm_get_wwid() doesn't take
> care of making the ouput 0-terminated if anything fails. The
> caller is responsible for that. Change callers accordingly.
> 
Reviewed-by: Benjamin Marzinski <bmarzins@redhat.com>
> Signed-off-by: Martin Wilck <mwilck@suse.com>
> ---
>  libmultipath/alias.c     | 11 ++++++++---
>  libmultipath/configure.c | 27 +++++++++++++++------------
>  libmultipath/devmapper.c | 22 +++++++++++++++++-----
>  libmultipath/wwids.c     |  2 +-
>  multipathd/main.c        |  7 +++++--
>  tests/alias.c            | 10 +++++-----
>  6 files changed, 51 insertions(+), 28 deletions(-)
> 
> diff --git a/libmultipath/alias.c b/libmultipath/alias.c
> index 10e58a7..c4eb5d8 100644
> --- a/libmultipath/alias.c
> +++ b/libmultipath/alias.c
> @@ -408,13 +408,18 @@ static bool alias_already_taken(const char *alias, const char *map_wwid)
>  {
>  
>  	char wwid[WWID_SIZE];
> +	int rc = dm_get_wwid(alias, wwid, sizeof(wwid));
>  
> -	/* If the map doesn't exist, it's fine */
> -	if (dm_get_wwid(alias, wwid, sizeof(wwid)) != 0)
> +	/*
> +	 * If the map doesn't exist, it's fine.
> +	 * In the generic error case, assume that the device is not
> +	 * taken, and try to proceed.
> +	 */
> +	if (rc == DMP_NOT_FOUND || rc == DMP_ERR)
>  		return false;
>  
>  	/* If both the name and the wwid match, it's fine.*/
> -	if (strncmp(map_wwid, wwid, sizeof(wwid)) == 0)
> +	if (rc == DMP_OK && strncmp(map_wwid, wwid, sizeof(wwid)) == 0)
>  		return false;
>  
>  	condlog(3, "%s: alias '%s' already taken, reselecting alias",
> diff --git a/libmultipath/configure.c b/libmultipath/configure.c
> index 666d4e8..2fdaca8 100644
> --- a/libmultipath/configure.c
> +++ b/libmultipath/configure.c
> @@ -845,18 +845,21 @@ int domap(struct multipath *mpp, char *params, int is_daemon)
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
> +		} else if (rc == DMP_OK) {
> +			condlog(1, "%s: map \"%s\" already present with WWID \"%s\", skipping\n"
> +				   "please check alias settings in config and bindings file",
> +				mpp->wwid, mpp->alias, wwid);
> +			mpp->action = ACT_REJECT;
> +		} else if (rc == DMP_NO_MATCH) {
> +			condlog(1, "%s: alias \"%s\" already taken by a non-multipath map",
> +				mpp->wwid, mpp->alias);
> +			mpp->action = ACT_REJECT;
>  		}
>  	}
>  
> @@ -1320,7 +1323,7 @@ static int _get_refwwid(enum mpath_cmds cmd, const char *dev,
>  		break;
>  
>  	case DEV_DEVMAP:
> -		if (((dm_get_wwid(dev, tmpwwid, WWID_SIZE)) == 0)
> +		if (((dm_get_wwid(dev, tmpwwid, WWID_SIZE)) == DMP_OK)
>  		    && (strlen(tmpwwid)))
>  			refwwid = tmpwwid;
>  
> diff --git a/libmultipath/devmapper.c b/libmultipath/devmapper.c
> index 3fca08c..003d834 100644
> --- a/libmultipath/devmapper.c
> +++ b/libmultipath/devmapper.c
> @@ -840,19 +840,29 @@ int dm_get_map(const char *name, unsigned long long *size, char **outparams)
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
> + * Caller may access uuid if and only if DMP_OK is returned.
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
>  	else
> -		uuid[0] = '\0';
> +		return DMP_NO_MATCH;
>  
> -	return 0;
> +	return DMP_OK;
>  }
>  
>  static int is_mpath_part(const char *part_name, const char *map_name)
> @@ -1388,8 +1398,10 @@ struct multipath *dm_get_multipath(const char *name)
>  	if (dm_get_map(name, &mpp->size, NULL) != DMP_OK)
>  		goto out;
>  
> -	if (dm_get_wwid(name, mpp->wwid, WWID_SIZE) != 0)
> +	if (dm_get_wwid(name, mpp->wwid, WWID_SIZE) != DMP_OK) {
>  		condlog(2, "%s: failed to get uuid for %s", __func__, name);
> +		mpp->wwid[0] = '\0';
> +	}
>  	if (dm_get_info(name, &mpp->dmi) != 0)
>  		condlog(2, "%s: failed to get info for %s", __func__, name);
>  
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
> diff --git a/multipathd/main.c b/multipathd/main.c
> index 442a154..1e7a6ac 100644
> --- a/multipathd/main.c
> +++ b/multipathd/main.c
> @@ -726,8 +726,11 @@ add_map_without_path (struct vectors *vecs, const char *alias)
>  		condlog(3, "%s: cannot access table", mpp->alias);
>  		goto out;
>  	}
> -	if (!strlen(mpp->wwid))
> -		dm_get_wwid(mpp->alias, mpp->wwid, WWID_SIZE);
> +	if (!strlen(mpp->wwid) &&
> +	    dm_get_wwid(mpp->alias, mpp->wwid, WWID_SIZE) != DMP_OK) {
> +		condlog(3, "%s: cannot obtain WWID", mpp->alias);
> +		goto out;
> +	}
>  	if (!strlen(mpp->wwid))
>  		condlog(1, "%s: adding map with empty WWID", mpp->alias);
>  	conf = get_multipath_config();
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

