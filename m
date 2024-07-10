Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D9B8214A605
	for <dm-devel@lists.linux.dev>; Wed, 10 Jul 2024 22:53:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720652002; cv=none; b=kLk57idIgkZE9ejjwsSYGMORztb0k9WaCVnUOsnzXNmXPrwDsvgN4rA2EAYnjoM/RPtt5FTha88O9wX1RKa51xMpkTohaKcSArXX9f2VHe9I5lngLOlk6OAH/VKvXV2d8/vriXwUHg1mWOQUFPm4V20GveW468w83BBq3PE7DVE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720652002; c=relaxed/simple;
	bh=1zYPzjxtN2XwmkOl2teNxdiiuwBI12QC3SarDdB1QaY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 In-Reply-To:Content-Type:Content-Disposition; b=mf/p7VM15bFbFsYYBfnbBpLE6E0iDERyvgKtQR1vKndbOBpJ2ETz9GvKJl9O7xi1PT1SnEnwsyhJx/lpnw1DtOwsUdkJIPjJpmh/qrFm7YRLhDLnPcontTYl66qgJaDrtFQfPDZQaAJknaEj0OqC8zJWFWdMxAlOUv8bwQqolHA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=cFi8eDUF; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="cFi8eDUF"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1720651998;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=B/An6Y1pMs4rhwmfpjdVuiLmtDqqQcEkzBCdS1zhMvc=;
	b=cFi8eDUFBkC1px57WmJDuYVgy1WzeSVXEIaFu8trdUGoCE8KQJzFB9tkjDcLQ90GhQOdVx
	xv5+j7skjXJpL1itq5JTTrW7hCvy06uEs1/r5cjSjyMcaWTbU6vxdeXPkutNTWJV0Jp+6u
	Z5fNq6Jm7OG21lwes3YWyKRZ7BTR/So=
Received: from mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-578-p34CUcxONeurJOa89_QzJQ-1; Wed,
 10 Jul 2024 18:53:16 -0400
X-MC-Unique: p34CUcxONeurJOa89_QzJQ-1
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id DC2141956088;
	Wed, 10 Jul 2024 22:53:15 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (bmarzins-01.fast.eng.rdu2.dc.redhat.com [10.6.23.12])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 703D019560AE;
	Wed, 10 Jul 2024 22:53:15 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.2/8.17.1) with ESMTPS id 46AMrEhp1921337
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Wed, 10 Jul 2024 18:53:14 -0400
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.2/8.17.2/Submit) id 46AMrDhZ1921336;
	Wed, 10 Jul 2024 18:53:13 -0400
Date: Wed, 10 Jul 2024 18:53:13 -0400
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Martin Wilck <martin.wilck@suse.com>
Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>,
        dm-devel@lists.linux.dev
Subject: Re: [PATCH 17/44] libmultipath: add libmp_mapinfo()
Message-ID: <Zo8Q2UZLwzkaRePo@redhat.com>
References: <20240709213935.177028-1-mwilck@suse.com>
 <20240709213935.177028-18-mwilck@suse.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <20240709213935.177028-18-mwilck@suse.com>
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Jul 09, 2024 at 11:39:08PM +0200, Martin Wilck wrote:

This is a great idea! I just have a few minor issues.

> libmp_mapinfo() is intended as a generic abstraction for retrieving information from
> the kernel device-mapper driver. It retrieves the information that the caller
> needs, with a minimal set of DM ioctls, and never more then 2 ioctl calls.
> 
> libdm's DM_DEVICE_TABLE and DM_DEVICE_STATUS calls map to the kernel's
> DM_TABLE_STATUS ioctl, with or without the DM_STATUS_TABLE_FLAG set,
> respectively. DM_TABLE_STATUS always retrieves the basic map status (struct
> dm_info) and the map UUID and name, too.
> 
> Note: I'd prefer to use an unnamed struct instead of _u in
> union libmp_map_identifer. But doing using an unnamed struct and and
> initializing the union like this in a function argument:
> 
>   func((mapid_t) { .major = major, .minor = minor })

This is a nitpick, but instead of using _u, couldn't you just pass the
major and minor as a dev_t? If you're working with an actual major and
minor, you would need to do something like:

(mapid_t) { .dev = makedev(major, minor) }

but we are often already dealing with a dev_t, so instead of doing:

(mapid_t) { ._u = { major(dev), minor(dev) } }

we could just do:

(mapid_t) { .dev = dev }

To get the major and minor out in the libmp_mapinfo() you would need to
use major(id.dev) and minor(id.dev), instead of id._u.major and
id._u.minor, but I think first set is more readable anyway.

> 
> is not part of C99, and not supported in gcc 4.8, which we still support.
> 
> Likewise, the following syntax for initializing an empty struct:
> 
>   (mapinfo_t) { 0 }
> 
> is not supported on all architectures we support (notably clang 3.5 under
> Debian Jessie).
> 
> Signed-off-by: Martin Wilck <mwilck@suse.com>
> ---
>  libmultipath/devmapper.c          | 181 +++++++++++++++++++++++++++++-
>  libmultipath/devmapper.h          |  66 +++++++++++
>  libmultipath/libmultipath.version |   3 +-
>  3 files changed, 248 insertions(+), 2 deletions(-)
> 
> diff --git a/libmultipath/devmapper.c b/libmultipath/devmapper.c
> index 3685ef7..5c9f9d8 100644
> --- a/libmultipath/devmapper.c
> +++ b/libmultipath/devmapper.c
> @@ -14,7 +14,6 @@
>  #include <errno.h>
>  #include <syslog.h>
>  #include <sys/sysmacros.h>
> -#include <linux/dm-ioctl.h>
>  
>  #include "util.h"
>  #include "vector.h"
> @@ -604,6 +603,186 @@ has_dm_info(const struct multipath *mpp)
>  	return (mpp && mpp->dmi.exists != 0);
>  }
>  
> +static int libmp_set_map_identifier(int flags, mapid_t id, struct dm_task *dmt)
> +{
> +	switch (flags & __DM_MAP_BY_MASK) {
> +	case DM_MAP_BY_UUID:
> +		if (!id.str || !(*id.str))
> +			return 0;
> +		return dm_task_set_uuid(dmt, id.str);
> +	case DM_MAP_BY_NAME:
> +		if (!id.str || !(*id.str))
> +			return 0;
> +		return dm_task_set_name(dmt, id.str);
> +	case DM_MAP_BY_DEV:
> +		if (!dm_task_set_major(dmt, id._u.major))
> +			return 0;
> +		return  dm_task_set_minor(dmt, id._u.minor);
> +	default:
> +		condlog(0, "%s: invalid by_id", __func__);
> +		return 0;
> +	}
> +}
> +
> +static int libmp_mapinfo__(int flags, mapid_t id, mapinfo_t info, const char *map_id)
> +{
> +	struct dm_task __attribute__((cleanup(cleanup_dm_task))) *dmt = NULL;
> +	struct dm_info dmi;
> +	int rc, ioctl_nr;
> +	uint64_t start, length = 0;
> +	char *target_type = NULL, *params = NULL;
> +	const char *name = NULL, *uuid = NULL;
> +	char __attribute__((cleanup(cleanup_charp))) *tmp_target = NULL;
> +	char __attribute__((cleanup(cleanup_charp))) *tmp_status = NULL;
> +	bool tgt_set = false;
> +
> +	/*
> +	 * If both info.target and info.status are set, we need two
> +	 * ioctls. Call this function recursively.
> +	 * If successful, tmp_target will be non-NULL.
> +	 */
> +	if (info.target && info.status) {
> +		rc = libmp_mapinfo__(flags, id,
> +				     (mapinfo_t) {
> +					     .target = &tmp_target,
> +					     .tgt_type = info.tgt_type,
> +				     },
> +				     map_id);
> +		if (rc != DMP_OK)
> +			return rc;
> +		tgt_set = true;
> +	}
> +
> +	/*
> +	 * The DM_DEVICE_TABLE and DM_DEVICE_STATUS ioctls both fetch the basic
> +	 * information from DM_DEVICE_INFO, too.
> +	 * Choose the most lightweight ioctl to fetch all requested info.
> +	 */
> +	if (info.target && !info.status)
> +		ioctl_nr = DM_DEVICE_TABLE;
> +	else if (info.status || info.size || info.tgt_type)
> +		ioctl_nr = DM_DEVICE_STATUS;
> +	else
> +		ioctl_nr = DM_DEVICE_INFO;
> +
> +	if (!(dmt = libmp_dm_task_create(ioctl_nr)))
> +		return DMP_ERR;
> +
> +	if (!libmp_set_map_identifier(flags, id, dmt)) {
> +		condlog(2, "%s: failed to set map identifier to %s", __func__, map_id);
> +		return DMP_ERR;
> +	}
> +
> +	if (!libmp_dm_task_run(dmt)) {
> +		dm_log_error(3, ioctl_nr, dmt);
> +		if (dm_task_get_errno(dmt) == ENXIO) {
> +			condlog(2, "%s: map %s not found", __func__, map_id);
> +			return DMP_NOT_FOUND;
> +		} else
> +			return DMP_ERR;
> +	}
> +
> +	condlog(4, "%s: DM ioctl %d succeeded for %s",
> +		__func__, ioctl_nr, map_id);
> +
> +	if (!dm_task_get_info(dmt, &dmi) || !dmi.exists) {
> +		condlog(2, "%s: map %s doesn't exist", __func__, map_id);
> +		return DMP_NOT_FOUND;
> +	}
> +
> +	if (info.target || info.status || info.size || info.tgt_type) {
> +		if (dm_get_next_target(dmt, NULL, &start, &length,
> +				       &target_type, &params) != NULL) {
> +			condlog(2, "%s: map %s has multiple targets", __func__, map_id);
> +			return DMP_NOT_FOUND;
> +		}
> +		if (!params) {
> +			condlog(2, "%s: map %s has no targets", __func__, map_id);
> +			return DMP_NOT_FOUND;
> +		}
> +		if (info.tgt_type && strcmp(info.tgt_type, target_type)) {
> +			condlog(3, "%s: target type mismatch: \"%s\" != \"%s\"",
> +				__func__, info.tgt_type, target_type);
> +			return DMP_NO_MATCH;
> +		}
> +	}
> +
> +	/*
> +	 * Check possible error conditions.
> +	 * If error is returned, don't touch any output parameters.
> +	 */
> +	if ((info.name && !(name = dm_task_get_name(dmt)))
> +	    || (info.uuid && !(uuid = dm_task_get_uuid(dmt)))
> +	    || (info.status && !(tmp_status = strdup(params)))
> +	    || (info.target && !tmp_target && !(tmp_target = strdup(params))))
> +		return DMP_ERR;
> +
> +	if (info.name) {
> +		strlcpy(info.name, name, WWID_SIZE);
> +		condlog(4, "%s: %s: name: \"%s\"", __func__, map_id, info.name);
> +	}
> +	if (info.uuid) {
> +		strlcpy(info.uuid, uuid, DM_UUID_LEN);
> +		condlog(4, "%s: %s: uuid: \"%s\"", __func__, map_id, info.uuid);
> +	}
> +
> +	if (info.size) {
> +		*info.size = length;
> +		condlog(4, "%s: %s: size: %lld", __func__, map_id, *info.size);
> +	}
> +
> +	if (info.dmi) {
> +		memcpy(info.dmi, &dmi, sizeof(*info.dmi));
> +		condlog(4, "%s: %s %d:%d, %d targets, %s table, %s, %s, %d opened, %u events",
> +			__func__, map_id,
> +			info.dmi->major, info.dmi->minor,
> +			info.dmi->target_count,
> +			info.dmi->live_table ? "live" :
> +				info.dmi->inactive_table ? "inactive" : "no",
> +			info.dmi->suspended ? "suspended" : "active",
> +			info.dmi->read_only ? "ro" : "rw",
> +			info.dmi->open_count,
> +			info.dmi->event_nr);
> +	}
> +
> +	if (info.target) {
> +		*info.target = steal_ptr(tmp_target);
> +		if (!tgt_set)
> +			condlog(4, "%s: %s: target: \"%s\"", __func__, map_id, *info.target);
> +	}
> +
> +	if (info.status) {
> +		*info.status = steal_ptr(tmp_status);
> +		condlog(4, "%s: %s: status: \"%s\"", __func__, map_id, *info.status);
> +	}
> +
> +	return DMP_OK;
> +}
> +
> +/* Helper: format a string describing the map for log messages */
> +static const char* libmp_map_identifier(int flags, mapid_t id, char buf[BLK_DEV_SIZE])
> +{
> +	switch (flags & __DM_MAP_BY_MASK) {
> +	case DM_MAP_BY_NAME:
> +	case DM_MAP_BY_UUID:
> +		return id.str;
> +	case DM_MAP_BY_DEV:
> +		safe_snprintf(buf, BLK_DEV_SIZE, "%d:%d", id._u.major, id._u.minor);
> +		return buf;
> +	default:
> +		safe_snprintf(buf, BLK_DEV_SIZE, "*invalid*");
> +		return buf;
> +	}
> +}
> +
> +int libmp_mapinfo(int flags, mapid_t id, mapinfo_t info)
> +{
> +	char idbuf[BLK_DEV_SIZE];
> +
> +	return libmp_mapinfo__(flags, id, info,
> +			       libmp_map_identifier(flags, id, idbuf));
> +}
> +
>  int
>  dm_get_info(const char *name, struct dm_info *info)
>  {
> diff --git a/libmultipath/devmapper.h b/libmultipath/devmapper.h
> index 9438c2d..269389b 100644
> --- a/libmultipath/devmapper.h
> +++ b/libmultipath/devmapper.h
> @@ -1,5 +1,6 @@
>  #ifndef _DEVMAPPER_H
>  #define _DEVMAPPER_H
> +#include <linux/dm-ioctl.h>
>  #include "autoconfig.h"
>  #include "structs.h"
>  
> @@ -31,8 +32,73 @@ enum {
>  	DMP_ERR,
>  	DMP_OK,
>  	DMP_NOT_FOUND,
> +	DMP_NO_MATCH,
>  };
>  
> +/**
> + * enum mapinfo_flags: input flags for libmp_mapinfo()
> + */
> +enum __mapinfo_flags {
> +	/** DM_MAP_BY_NAME: identify map by device-mapper name from @name */
> +	DM_MAP_BY_NAME      = 0,
> +	/** DM_MAP_BY_UUID: identify map by device-mapper UUID from @uuid */
> +	DM_MAP_BY_UUID,
> +	/** DM_MAP_BY_DEV: identify map by major/minor number from @dmi */
> +	DM_MAP_BY_DEV,
> +	__DM_MAP_BY_MASK    = (1 << 3) - 1,

I assume you orignally indented these to be flags, but they aren't
really, so __DM_MAP_BY_MASK would just be 3, since the values are 0, 1,
and 2.

> +};
> +
> +typedef union libmp_map_identifier {
> +	const char *str;

Like I said before, I would just use

        dev_t dev;

instead of the struct. But I don't have stong feelings about this if you
prefer keeping major and minor separate.

> +	struct {
> +		int major;
> +		int minor;
> +	} _u;
> +} mapid_t;
> +
> +typedef struct libmp_map_info {
> +	/** @name: name of the map.
> +	 * If non-NULL, it must point to an array of WWID_SIZE bytes
> +	 */
> +	char *name;
> +	/** @uuid: UUID of the map.
> +	 * If non-NULL it must point to an array of DM_UUID_LEN bytes
> +	 */
> +	char *uuid;
> +	/** @dmi: Basic info, must point to a valid dm_info buffer if non-NULL */
> +	struct dm_info *dmi;
> +	/** @target: target params, *@target will be allocated if @target is non-NULL*/
> +	char **target;
> +	/** @size: target size. Will be ignored if @target is NULL */
> +	unsigned long long *size;
> +	/** @status: target status, *@status will be allocated if @status is non-NULL */
> +	char **status;
> +	/** @tgt_type: (input) set to a target type, e.g. "multipath" to limit
> +	 * successful return to just this target type in libmp_mapinfo().
> +	 */
> +	const char *tgt_type;
> +} mapinfo_t;
> +
> +/**
> + * libmp_mapinfo(): obtain information about a map from the kernel
> + * @param flags: see __mapinfo_flags above.
> + *     Exactly one of DM_MAP_BY_NAME, DM_MAP_BY_UUID, and DM_MAP_BY_DEV must be set.

Again, you can't really set multiple values, so this comment doesn't
make sense.

-Ben

> + * @param id: string or major/minor to identify the map to query
> + * @param info: output parameters, see above. Non-NULL elements will be filled in.
> + * @returns:
> + *     DMP_OK if successful.
> + *     DMP_NOT_FOUND if the map wasn't found, or has no or multiple targets.
> + *     DMP_NO_MATCH if the map didn't match @tgt_type (see above).
> + *     DMP_ERR if some other error occurred.
> + *
> + * This function obtains the requested information for the device-mapper map
> + * identified by the input parameters.
> + * Output parameters are only filled in if the return value is DMP_OK.
> + * For target / status / size information, the  map's table should contain
> + * only one target (usually multipath or linear).
> + */
> +int libmp_mapinfo(int flags, mapid_t id, mapinfo_t info);
> +
>  int dm_prereq(unsigned int *v);
>  void skip_libmp_dm_init(void);
>  void libmp_dm_exit(void);
> diff --git a/libmultipath/libmultipath.version b/libmultipath/libmultipath.version
> index f58cb1d..48c2b67 100644
> --- a/libmultipath/libmultipath.version
> +++ b/libmultipath/libmultipath.version
> @@ -43,7 +43,7 @@ LIBMPATHCOMMON_1.0.0 {
>  	put_multipath_config;
>  };
>  
> -LIBMULTIPATH_24.0.0 {
> +LIBMULTIPATH_25.0.0 {
>  global:
>  	/* symbols referenced by multipath and multipathd */
>  	add_foreign;
> @@ -134,6 +134,7 @@ global:
>  	libmp_get_version;
>  	libmp_get_multipath_config;
>  	libmp_dm_task_run;
> +	libmp_mapinfo;
>  	libmp_put_multipath_config;
>  	libmp_udev_set_sync_support;
>  	libmultipath_exit;
> -- 
> 2.45.2

