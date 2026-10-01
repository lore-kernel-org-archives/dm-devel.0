Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 008BB1A9FBD
	for <dm-devel@lists.linux.dev>; Thu,  1 Oct 2026 00:05:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790813104; cv=none; b=FZZIygC4SIVBokM8q8xe4aGfKSlAYJXT7LwxgKaEN0usx5sR5X7eiO2X7OsU1IGfOzAKGNhcLp5Usg8ueK2Vtkfb9nkIwzB1JfmSXogKoCQLniAP4/9jOyi37dnTKIfaF9VMvBFnLZjAN02EkejdM595wLEMDZQyhi62Bdpd7n0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790813104; c=relaxed/simple;
	bh=Ruz+8e/o3ChS2SUhSh30jhYUrQ6+nX4nLi4ICB2wIow=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 In-Reply-To:Content-Type:Content-Disposition; b=E6FusmF3vuYOCpGZUEvkOR7UJRBF38+2EDDIdfqBK8kcZB61PlQauaQ8vaqQYA9ItKtp8zcBaxpcY5AXKNaM8VUf0OVm6lFEkusi5qpFnyvjBpBFg5rgs/qxDjPJm3DjW3H7d+cgPstFYZsPfDKSMerf3SrG0m1YLS7gO/YIIBE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=MIBTzGXG; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="MIBTzGXG"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1790813100;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=9k0TOWWAB99p49pdwTcAT7U/S7/5viqbFOx2GiyypgY=;
	b=MIBTzGXGF+ZyelAF1U6BMLxor/X8K7chygMSOpavoypuoeP7mmWtJyi2XVFHEaXdlJyXUG
	fMfCTUKY4QjXYFpHsYmLU4+PbYZWXnisb/suxIQM2eXZbpQLz35E/bTudYRKnP3t8SF7p4
	LXp56M4Xz8DQw5nYH8UVUjEE3Nn2rqY=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-659-UzPLBNe2OVmOyNv5ylXqaQ-1; Wed,
 30 Sep 2026 20:04:56 -0400
X-MC-Unique: UzPLBNe2OVmOyNv5ylXqaQ-1
X-Mimecast-MFC-AGG-ID: UzPLBNe2OVmOyNv5ylXqaQ_1790813095
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 6157919540E5;
	Thu,  1 Oct 2026 00:04:55 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (bmarzins-01.fast.eng.rdu2.dc.redhat.com [10.6.23.12])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 2C0791956042;
	Thu,  1 Oct 2026 00:04:55 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.17.1) with ESMTPS id 69104rGs872376
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Wed, 30 Sep 2026 20:04:53 -0400
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.18.1/Submit) id 69104rol872375;
	Wed, 30 Sep 2026 20:04:53 -0400
Date: Wed, 30 Sep 2026 20:04:53 -0400
From: Benjamin Marzinski <bmarzins@redhat.com>
To: mwilck@suse.de
Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>,
        dm-devel@lists.linux.dev, Martin Wilck <mwilck@suse.com>
Subject: Re: [PATCH 2/4] libmultipath: unmangle WWIDs if necessary
Message-ID: <ar2jpWLGvnezXeW5@redhat.com>
References: <20260925214014.2464499-1-mwilck@suse.de>
 <20260925214014.2464499-3-mwilck@suse.de>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <20260925214014.2464499-3-mwilck@suse.de>
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: ignaD0MlFA1BRaeSDGAdm0jxknHCelzr8vy-0VEUE3g_1790813095
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Sep 25, 2026 at 11:40:07PM +0200, mwilck@suse.de wrote:
> From: Martin Wilck <mwilck@suse.com>
> diff --git a/libmultipath/discovery.c b/libmultipath/discovery.c
> index 344da19..66af333 100644
> --- a/libmultipath/discovery.c
> +++ b/libmultipath/discovery.c
> @@ -37,6 +37,7 @@
>  #include "print.h"
>  #include "strbuf.h"
>  #include "pgpolicies.h"
> +#include "wwids.h"
>  
>  #define VPD_BUFLEN 4096
>  
> @@ -45,6 +46,97 @@ struct vpd_vendor_page vpd_vendor_pages[VPD_VP_ARRAY_SIZE] = {
>  	[VPD_VP_HP3PAR]	= { 0xc0, "hp3par" },
>  };
>  
> +/* from libdm/libdm-common.c; license: LGPL-2.1-only */
> +static bool _is_whitelisted_char(char c)
> +{
> +	/*
> +	 * Actually, DM supports any character in a device name.
> +	 * This whitelist is just for proper integration with udev.
> +	 */
> +	if ((c >= '0' && c <= '9') || (c >= 'A' && c <= 'Z') ||
> +	    (c >= 'a' && c <= 'z') || strchr("#+-.:=@_", c) != NULL)
> +		return true;
> +
> +	return false;
> +}
> +
> +size_t maybe_unmangle_wwid(char new_wwid[WWID_SIZE], const char *wwid)
> +{
> +	char buf[WWID_SIZE], *dst;
> +	const char *src;
> +	bool mangled = false, invalid = false;
> +	size_t rc, len;
> +
> +	if (!wwid) {
> +		*new_wwid = '\0';
> +		return 0;
> +	}
> +
> +	/* this might be > WWID_SIZE - 1 */
> +	len = strlen(wwid);
> +	/*
> +	 * A correctly mangled string doesn't contain invalid characters.
> +	 * In particular, if the original string contained `\xXY`, it will
> +	 * itself be mangled to '\x5cxXY`.
> +	 */
> +	/* clang-format off */
> +	for (src = wwid, dst = buf;
> +	     dst - buf < WWID_SIZE - 1 && *src;
> +	     src++, dst++) {
> +		/*clang-format on */
> +		if (_is_whitelisted_char(*src)) {
> +			*dst = *src;
> +			continue;
> +		}
> +		if (*src == '\\') {
> +			char hex[3], c;
> +
> +			/*
> +			 * udev mangling always outputs 2-digit hex numbers
> +			 * 1-digit would be unprintable, anyway
> +			 */
> +			if (src + 4 > wwid + len || *(src + 1) != 'x' ||
> +			    sscanf(src + 2, "%2[A-Fa-f0-9]", hex) == 0 ||
> +			    strlen(hex) != 2) {
> +				condlog(3, "%s: wwid \"%s\" contains invalid mangle sequence \"%s\"",
> +					__func__, wwid, src);
> +				invalid = true;
> +				break;
> +			}
> +			mangled = true;
> +			src += 1 + strlen(hex);
> +			c = strtol(hex, NULL, 16);
> +			/* Allow non-ascii unicode, but avoid non-printable characters */
> +			*dst = (c & 0x80) || isprint(c) ? c : '_';
> +		} else {
> +			condlog(3, "%s: wwid \"%s\" contains illegal character '%02x'",
> +				__func__, wwid, (unsigned char)*src);
> +			invalid = true;
> +			break;
> +		}
> +	}
> +
> +	/*
> +	 * 1. If we found an invalid character, it can't be mangled by udev,
> +	 *    use original WWID.
> +	 * 2. If we didn't found a `\xHH`, it isn't mangled, use original.
> +	 * 3. If the unmangled WWID is known, use it.
> +	 * 4. If the original WWID is known, use it.
> +	 * 5. If in doubt, use the unmangled WWID.
> +	 */
> +	if (!invalid && mangled &&

This check should use "buf" not "new_wwid".

> +	    (!check_wwids_file(new_wwid, 0) || check_wwids_file(wwid, 0))) {
> +		*dst = '\0';
> +		rc = strlcpy(new_wwid, buf, WWID_SIZE);
> +		condlog(3, "%s: unmangled WWID \"%s\" -> \"%s\"", __func__,
> +			wwid, new_wwid);
> +	} else {
> +		rc = strlcpy(new_wwid, wwid, WWID_SIZE);
> +		condlog(4, "%s: kept WWID \"%s\"", __func__, new_wwid);
> +	}

Nitpick: I think these conditionals would be easier to check against
rules as:

	if (invalid || !mangled || check_wwids_file(wwid, 0) == 0) {
		/* Keep original wwid */
	} else {
		/* Use unmangled wwid */
	}
> +	return rc;
> +}
> +
>  int
>  alloc_path_with_pathinfo (struct config *conf, struct udev_device *udevice,
>  			  const char *wwid, int flag, struct path **pp_ptr)
> @@ -65,8 +157,7 @@ alloc_path_with_pathinfo (struct config *conf, struct udev_device *udevice,
>  	if (!pp)
>  		return PATHINFO_FAILED;
>  
> -	if (wwid)
> -		strlcpy(pp->wwid, wwid, sizeof(pp->wwid));
> +	maybe_unmangle_wwid(pp->wwid, wwid);
>  
>  	if (safe_sprintf(pp->dev, "%s", devname)) {
>  		condlog(0, "pp->dev too small");
> @@ -2163,8 +2254,8 @@ get_udev_uid(struct path * pp, const char *uid_attribute, struct udev_device *ud
>  	value = udev_device_get_property_value(udev, uid_attribute);
>  	if ((!value || strlen(value) == 0) && pp->can_use_env_uid)
>  		value = getenv(uid_attribute);
> -	if (value && strlen(value)) {
> -		len = strlcpy(pp->wwid, value, WWID_SIZE);
> +	if (value && *value) {
> +		len = maybe_unmangle_wwid(pp->wwid, value);
>  		if (len >= WWID_SIZE) {
>  			len = fix_broken_nvme_wwid(pp, value, WWID_SIZE);
>  			if (len > 0)
> @@ -2224,7 +2315,7 @@ static ssize_t dasd_get_uid(struct path *pp)
>  	if (p)
>  		*p = '\0';
>  
> -	return strlcpy(pp->wwid, value, WWID_SIZE);
> +	return maybe_unmangle_wwid(pp->wwid, value);

We're reading this from sysfs, so I don't think this one needs to be
unmangled.

>  }
>  
>  static ssize_t uid_fallback(struct path *pp, int path_state,
> @@ -2254,6 +2345,8 @@ static ssize_t uid_fallback(struct path *pp, int path_state,
>  					   sizeof(value));
>  		if (!sysfs_attr_value_ok(len, sizeof(value)))
>  			return -1;
> +
> +		/* WWID read from sysfs, unmangling is not necessary */

I'm pretty sure that unmangling is unnecessary in all of the methods in
uid_fallback, so this comment is confusing.

-Ben

