Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0034E13CFAD
	for <dm-devel@lists.linux.dev>; Mon, 15 Jul 2024 22:15:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721081703; cv=none; b=s7OBdok92mPR1ilDn8F4mRkIPE7saE7mfr1fZ7O57ppZau5fjKEcsu3ME2gqPBrSSvbec2ALT04DkGyPePc21ufMBj/LIbTdEPZwrueeSTORRAxBznVj5nt/fxTaJIMG2j3hG+ZBwYlJpv7MykKGbUYSx3k+bfWb02H6rjTB/BM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721081703; c=relaxed/simple;
	bh=TnBrihTacSA45CmEYpI6p0WCfdC2Y45YBGEQ43pMIEw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 In-Reply-To:Content-Type:Content-Disposition; b=Gnhy9fwBay4S2OUW1rpsq/jzNZ51S3ZnhmpDLp4Pwnx7l3wc4zroldzy5VWd0soV6f3eB+21lcaduybNANRVvQ1CJt8CtvJq5QrXS3egNvYoIqvkqbZsh6VXwZkfJ3RhchBMvVXubRFZ2tqp+5hyk+GWQenREyKyqvY8tXGAGTI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=PYPeB885; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="PYPeB885"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1721081700;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=thj7Mg2eQPg273i+PcAyE8KiEZG/v828w7m+W0eWPfs=;
	b=PYPeB885bngzYWunng1hwi2UlEcY3pSc85F2xuuH+P1WapKUNDsGfnbZpVpzzWN47UnVM7
	82PUJFEe/NBJyoDdKQe4r++q0sFUYIKGkPMSDKkDA1gK9E5gWsLOo5GtrLKsAXf0CMxJOg
	dxaSMwTMrO+sIS+IUDE0+MUXRfN+Vps=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-538-Fh6F-3KgN1O-R3_1POdHJA-1; Mon,
 15 Jul 2024 18:14:57 -0400
X-MC-Unique: Fh6F-3KgN1O-R3_1POdHJA-1
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 3E59F1955F3B;
	Mon, 15 Jul 2024 22:14:56 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (bmarzins-01.fast.eng.rdu2.dc.redhat.com [10.6.23.12])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id C7C241955F40;
	Mon, 15 Jul 2024 22:14:55 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.2/8.17.1) with ESMTPS id 46FMEsM12095990
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Mon, 15 Jul 2024 18:14:54 -0400
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.2/8.17.2/Submit) id 46FMEsdr2095989;
	Mon, 15 Jul 2024 18:14:54 -0400
Date: Mon, 15 Jul 2024 18:14:54 -0400
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Martin Wilck <martin.wilck@suse.com>
Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>,
        dm-devel@lists.linux.dev, Martin Wilck <mwilck@suse.com>
Subject: Re: [PATCH v2 18/49] libmultipath: Use symbolic return values for
 dm_is_mpath()
Message-ID: <ZpWfXvsVP70TQlf1@redhat.com>
References: <20240712171458.77611-1-mwilck@suse.com>
 <20240712171458.77611-19-mwilck@suse.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <20240712171458.77611-19-mwilck@suse.com>
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Jul 12, 2024 at 07:14:26PM +0200, Martin Wilck wrote:
> Signed-off-by: Martin Wilck <mwilck@suse.com>
Reviewed-by: Benjamin Marzinski <bmarzins@redhat.com>
> ---
>  libmpathpersist/mpath_persist_int.c |  2 +-
>  libmultipath/devmapper.c            | 22 ++++++++--------------
>  libmultipath/devmapper.h            |  6 ++++++
>  multipath/main.c                    |  4 ++--
>  multipathd/dmevents.c               | 19 +++++++++++++------
>  multipathd/main.c                   |  2 +-
>  6 files changed, 31 insertions(+), 24 deletions(-)
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
> index a63154f..3abdc26 100644
> --- a/libmultipath/devmapper.c
> +++ b/libmultipath/devmapper.c
> @@ -846,15 +846,9 @@ static int dm_type_match(const char *name, char *type)
>  		return DM_TYPE_NOMATCH;
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
> +	int r = DM_IS_MPATH_ERR;
>  	struct dm_task __attribute__((cleanup(cleanup_dm_task))) *dmt = NULL;
>  	struct dm_info info;
>  	uint64_t start, length;
> @@ -876,7 +870,7 @@ int dm_is_mpath(const char *name)
>  	if (!dm_task_get_info(dmt, &info))
>  		goto out;
>  
> -	r = 0;
> +	r = DM_IS_MPATH_NO;
>  
>  	if (!info.exists)
>  		goto out;
> @@ -895,10 +889,10 @@ int dm_is_mpath(const char *name)
>  	if (!target_type || strcmp(target_type, TGT_MPATH) != 0)
>  		goto out;
>  
> -	r = 1;
> +	r = DM_IS_MPATH_YES;
>  out:
> -	if (r < 0)
> -		condlog(3, "%s: dm command failed in %s: %s", name, __FUNCTION__, strerror(errno));
> +	if (r == DM_IS_MPATH_ERR)
> +		condlog(3, "%s: dm command failed in %s: %s", name, __func__, strerror(errno));
>  	return r;
>  }
>  
> @@ -1039,7 +1033,7 @@ int _dm_flush_map (const char *mapname, int flags, int retries)
>  	unsigned long long mapsize;
>  	char *params = NULL;
>  
> -	if (dm_is_mpath(mapname) != 1)
> +	if (dm_is_mpath(mapname) != DM_IS_MPATH_YES)
>  		return DM_FLUSH_OK; /* nothing to do */
>  
>  	/* if the device currently has no partitions, do not
> @@ -1086,7 +1080,7 @@ int _dm_flush_map (const char *mapname, int flags, int retries)
>  			}
>  			condlog(4, "multipath map %s removed", mapname);
>  			return DM_FLUSH_OK;
> -		} else if (dm_is_mpath(mapname) != 1) {
> +		} else if (dm_is_mpath(mapname) != DM_IS_MPATH_YES) {
>  			condlog(4, "multipath map %s removed externally",
>  				mapname);
>  			return DM_FLUSH_OK; /* raced. someone else removed it */
> @@ -1316,7 +1310,7 @@ int dm_get_maps(vector mp)
>  	}
>  
>  	do {
> -		if (dm_is_mpath(names->name) != 1)
> +		if (dm_is_mpath(names->name) != DM_IS_MPATH_YES)
>  			goto next;
>  
>  		mpp = dm_get_multipath(names->name);
> diff --git a/libmultipath/devmapper.h b/libmultipath/devmapper.h
> index ff28575..9438c2d 100644
> --- a/libmultipath/devmapper.h
> +++ b/libmultipath/devmapper.h
> @@ -46,6 +46,12 @@ int dm_map_present (const char *name);
>  int dm_map_present_by_uuid(const char *uuid);
>  int dm_get_map(const char *name, unsigned long long *size, char **outparams);
>  int dm_get_status(const char *name, char **outstatus);
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
> index 3fbdc55..af1e12e 100644
> --- a/multipathd/dmevents.c
> +++ b/multipathd/dmevents.c
> @@ -168,9 +168,13 @@ static int dm_get_events(void)
>  	while (names->dev) {
>  		uint32_t event_nr;
>  
> -		/* Don't delete device if dm_is_mpath() fails without
> -		 * checking the device type */
> -		if (dm_is_mpath(names->name) == 0)
> +		/*
> +		 * Don't delete device if dm_is_mpath() fails without
> +		 * checking the device type.
> +		 * IOW, only delete devices from the event list for which
> +		 *  we positively know that they aren't multipath devices.
> +		 */
> +		if (dm_is_mpath(names->name) == DM_IS_MPATH_NO)
>  			goto next;
>  
>  		event_nr = dm_event_nr(names);
> @@ -206,9 +210,12 @@ int watch_dmevents(char *name)
>  	struct dev_event *dev_evt, *old_dev_evt;
>  	int i;
>  
> -	/* We know that this is a multipath device, so only fail if
> -	 * device-mapper tells us that we're wrong */
> -	if (dm_is_mpath(name) == 0) {
> +	/*
> +	 * We know that this is a multipath device, so only fail if
> +	 * device-mapper tells us that we're wrong
> +	 * IOW, don't fail for DM generic errors.
> +	 */
> +	if (dm_is_mpath(name) == DM_IS_MPATH_NO) {
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

