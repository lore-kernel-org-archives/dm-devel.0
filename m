Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C0F233BBC2
	for <dm-devel@lists.linux.dev>; Mon, 15 Jul 2024 22:51:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721083870; cv=none; b=d+4jIZBAdyoJIEil/j3HBxMZ7affNwrdzlg59KKWnXj4yS8srLCdSG6zB6u79yC8uQaRjkbXs4hNxkW7u8x0g5Vu0yW+gymlHgqBkc5rg4nmCsvAbHLlw2SVhbmtLGdMY88utKeiMqHlThzR5/qNdnqacVdaRvEl/B+qjWYqIqo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721083870; c=relaxed/simple;
	bh=5kyeWqrh5D9ZbJA5K0CQ3cQh4IsiaxegI0H/X25+DcM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 In-Reply-To:Content-Type:Content-Disposition; b=LMyHAr9vZSxtDJIcLC/wsG/Si/ESoW3mJMCgNYsiH21Af3UDO35BHA0LhIrv9qNztTqn9Zwnc8KC90qv1LHsn40fRplbJtoVgFw6nMfNAneQBw/YbV23FJBnNqHVbD95v5kkJ8SO7/8uotA/kfa6olrddF6ufSnHIDBA/MWZCWE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=XQPc1Zba; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="XQPc1Zba"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1721083867;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Ma2VgT3K2UBXEZu0VLneHZaOFn8fmqRuR+idyO/Lh0U=;
	b=XQPc1Zbat6s72rz5D6wGmY/nxqD/LlTl1ROXbkWRPSAkmZPaNcl3+LnEIRVFanknRgfG97
	0hW+JdD/y56KDHQXSf0IPZdijVlwk5Lsqnn45SJKjucTzhzKGWxUfAywrnlrIRs9jTeHPk
	zK8Sa0vL3QxasUiKbef33hrZfpnHtSE=
Received: from mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-126-FXtv14-RMbeOMZMkAqyNUA-1; Mon,
 15 Jul 2024 18:51:05 -0400
X-MC-Unique: FXtv14-RMbeOMZMkAqyNUA-1
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 7328C1955D42;
	Mon, 15 Jul 2024 22:51:04 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (bmarzins-01.fast.eng.rdu2.dc.redhat.com [10.6.23.12])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id DE946300018D;
	Mon, 15 Jul 2024 22:51:03 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.2/8.17.1) with ESMTPS id 46FMp2iA2096981
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Mon, 15 Jul 2024 18:51:02 -0400
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.2/8.17.2/Submit) id 46FMp2KK2096980;
	Mon, 15 Jul 2024 18:51:02 -0400
Date: Mon, 15 Jul 2024 18:51:02 -0400
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Martin Wilck <martin.wilck@suse.com>
Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>,
        dm-devel@lists.linux.dev, Martin Wilck <mwilck@suse.com>
Subject: Re: [PATCH v2 47/49] libmultipath: don't call do_foreach_partmaps()
 recursively
Message-ID: <ZpWn1iA-sQ5jy3o5@redhat.com>
References: <20240712171458.77611-1-mwilck@suse.com>
 <20240712171458.77611-48-mwilck@suse.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <20240712171458.77611-48-mwilck@suse.com>
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Jul 12, 2024 at 07:14:55PM +0200, Martin Wilck wrote:
> We've removed partition mappings recursively since 83fb936 ("Correctly remove
> logical partition maps"). This was wrong, because kpartx doesn't create
> logical partitions as mappings onto the extended partition. Rather, logical
> partitions are created by kpartx as mappings to the multipath device, and
> afaics, this has always been the case. Therefore, the loop in
> do_foreach_partmaps() will detect all partition mappings (primary, extended,
> and logical) without recursion. At least since 4059e42 ("libmultipath: fix
> partition detection"), the recursion has actually been pointless, because
> is_mpath_part() would never have returned "true" for a pair of two partition
> mappings (one representing an extended partition and one a logical partition).
> 
> Avoiding the recursion has the additional benefit that the complexity of
> removing maps scales with N, where N is the number of dm devices, rather than
> with N^2. Also, it simplifies the code.
> 
> Split partmap_in_use() into two separate functions, mpath_in_use() (to be called
> for multipath maps) and count_partitions(), which is called from
> do_foreach_partmaps().
> 
> Because do_foreach_partmaps() is now only legitimately called for multipath
> maps, quit early if called for another map type.
> 
> Signed-off-by: Martin Wilck <mwilck@suse.com>
> ---
>  libmultipath/devmapper.c          | 48 +++++++++++++++++++------------
>  libmultipath/devmapper.h          |  2 +-
>  libmultipath/libmultipath.version |  2 +-
>  multipathd/main.c                 |  2 +-
>  4 files changed, 33 insertions(+), 21 deletions(-)
> 
> diff --git a/libmultipath/devmapper.c b/libmultipath/devmapper.c
> index 5749d63..d9d96be 100644
> --- a/libmultipath/devmapper.c
> +++ b/libmultipath/devmapper.c
> @@ -933,22 +933,37 @@ has_partmap(const char *name __attribute__((unused)),
>  	return 1;
>  }
>  
> -int
> -partmap_in_use(const char *name, void *data)
> +/*
> + * This will be called from mpath_in_use, for each partition.
> + * If the partition itself in use, returns 1 immediately, causing
> + * do_foreach_partmaps() to stop iterating and return 1.
> + * Otherwise, increases the partition count.
> + */
> +static int count_partitions(const char *name, void *data)
> +{
> +	int *ret_count = (int *)data;
> +	int open_count = dm_get_opencount(name);
> +
> +	if (open_count)
> +		return 1;
> +	(*ret_count)++;
> +	return 0;
> +}
> +
> +int mpath_in_use(const char *name)
>  {
> -	int part_count, *ret_count = (int *)data;
>  	int open_count = dm_get_opencount(name);
>  
> -	if (ret_count)
> -		(*ret_count)++;
> -	part_count = 0;
>  	if (open_count) {
> -		if (do_foreach_partmaps(name, partmap_in_use, &part_count))
> -			return 1;
> -		if (open_count != part_count) {
> -			condlog(2, "%s: map in use", name);
> +		int part_count = 0;
> +
> +		if (do_foreach_partmaps(name, count_partitions, &part_count)) {
> +			condlog(4, "%s: %s has open partitions", __func__, name);
>  			return 1;
>  		}
> +		condlog(4, "%s: %s: %d openers, %d partitions", __func__, name,
> +			open_count, part_count);
> +		return open_count > part_count;
>  	}
>  	return 0;
>  }
> @@ -976,7 +991,7 @@ int _dm_flush_map (const char *mapname, int flags, int retries)
>  
>  	/* If you aren't doing a deferred remove, make sure that no
>  	 * devices are in use */
> -	if (!(flags & DMFL_DEFERRED) && partmap_in_use(mapname, NULL))
> +	if (!(flags & DMFL_DEFERRED) && mpath_in_use(mapname))
>  			return DM_FLUSH_BUSY;
>  
>  	if ((flags & DMFL_SUSPEND) &&
> @@ -1314,7 +1329,7 @@ do_foreach_partmaps (const char *mapname,
>  	char map_uuid[DM_UUID_LEN];
>  	struct dm_info info;
>  
> -	if (libmp_mapinfo(DM_MAP_BY_NAME,
> +	if (libmp_mapinfo(DM_MAP_BY_NAME | MAPINFO_CHECK_UUID,

This patch is out of order. You add MAPINFO_CHECK_UUID in the next one.
Otherwise
Reviewed-by: Benjamin Marzinski <bmarzins@redhat.com>

-Ben

>  			  (mapid_t) { .str = mapname },
>  			  (mapinfo_t) { .uuid = map_uuid, .dmi = &info }) != DMP_OK)
>  		return 1;
> @@ -1381,12 +1396,9 @@ remove_partmap(const char *name, void *data)
>  {
>  	struct remove_data *rd = (struct remove_data *)data;
>  
> -	if (dm_get_opencount(name)) {
> -		dm_remove_partmaps(name, rd->flags);
> -		if (!(rd->flags & DMFL_DEFERRED) && dm_get_opencount(name)) {
> -			condlog(2, "%s: map in use", name);
> -			return DM_FLUSH_BUSY;
> -		}
> +	if (!(rd->flags & DMFL_DEFERRED) && dm_get_opencount(name)) {
> +		condlog(2, "%s: map in use", name);
> +		return DM_FLUSH_BUSY;
>  	}
>  	condlog(4, "partition map %s removed", name);
>  	dm_device_remove(name, rd->flags);
> diff --git a/libmultipath/devmapper.h b/libmultipath/devmapper.h
> index d01f9f2..6eb5ab9 100644
> --- a/libmultipath/devmapper.h
> +++ b/libmultipath/devmapper.h
> @@ -149,7 +149,7 @@ enum {
>  	DM_FLUSH_BUSY,
>  };
>  
> -int partmap_in_use(const char *name, void *data);
> +int mpath_in_use(const char *name);
>  
>  enum {
>  	DMFL_NONE      = 0,
> diff --git a/libmultipath/libmultipath.version b/libmultipath/libmultipath.version
> index 54b5a23..649c1cb 100644
> --- a/libmultipath/libmultipath.version
> +++ b/libmultipath/libmultipath.version
> @@ -139,10 +139,10 @@ global:
>  	libmultipath_exit;
>  	libmultipath_init;
>  	load_config;
> +	mpath_in_use;
>  	need_io_err_check;
>  	orphan_path;
>  	parse_prkey_flags;
> -	partmap_in_use;
>  	pathcount;
>  	path_discovery;
>  	path_get_tpgs;
> diff --git a/multipathd/main.c b/multipathd/main.c
> index 536974c..13af94e 100644
> --- a/multipathd/main.c
> +++ b/multipathd/main.c
> @@ -597,7 +597,7 @@ flush_map_nopaths(struct multipath *mpp, struct vectors *vecs) {
>  		return false;
>  	}
>  	if (mpp->flush_on_last_del == FLUSH_UNUSED &&
> -            partmap_in_use(mpp->alias, NULL) && is_queueing) {
> +	    mpath_in_use(mpp->alias) && is_queueing) {
>  		condlog(2, "%s: map in use and queueing, can't remove",
>  			mpp->alias);
>  		return false;
> -- 
> 2.45.2

