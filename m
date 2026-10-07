Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E9417385503
	for <dm-devel@lists.linux.dev>; Wed,  7 Oct 2026 16:42:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791391331; cv=none; b=A7BEkLnB4bt+suiRqqOj7gx45oWeWy0xhKy3VgNx/7GS2bZh4zDup+NGPrrzqNU3+G602IJaB/GGghNvR2coISyHsOJJ2dcuRHVIH5aT8CjNo+oS3eDjUwjHzHK3M5vEKU4v8IsuHIccytaJnpwAAOARp5zWI9TZ4MphenL58YI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791391331; c=relaxed/simple;
	bh=v1carSDHma1WXTXbSk7Sn0CXvnrkQNVRbl5UII07Le8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 In-Reply-To:Content-Type:Content-Disposition; b=RqG/A1Z8XSJeyHaRVvrdvgRVxja6AEqv5ArAKdQzRE4JfNuuTh9Tnynbx+8AfrlVtQIX7ArzlOkVS4zBjuoiRbrkmlXZUQK0yFD2S6ceCVsSfpzt2YUBsVvz3bn/jWKEGWN6oU3I/+83jCIQjqJsOtP+86SIn+wwqKuNLDZ8YCU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=P/SiE6qi; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="P/SiE6qi"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1791391328;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=KvjFeiBujPlfRlZhM5i2pbtfmls5tSscptUXRY+JJLY=;
	b=P/SiE6qim/hkOzVtYvAQyP21dYXu50zjvY7ctxCBCXgUeYNzmtuO///9oolbG8MNDJYZ5y
	tSrZLXyooi6jqm9dEBaOs6r3lgvxUKxWDA+b/8+dp3rvhzKiklo0t1RY6ZJMghpz2r4mNv
	2v4apweVaE/ByBgwwRxVUIC0WqOVzzM=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-94-6F4YBtAwMAixP1ZOcT1z5g-1; Wed,
 7 Oct 2026 16:42:04 +0000
X-MC-Unique: 6F4YBtAwMAixP1ZOcT1z5g-1
X-Mimecast-MFC-AGG-ID: 6F4YBtAwMAixP1ZOcT1z5g_1791391323
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id A03471800594;
	Wed,  7 Oct 2026 16:42:03 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (bmarzins-01.fast.eng.rdu2.dc.redhat.com [10.6.23.12])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 42AB518004D4;
	Wed,  7 Oct 2026 16:42:03 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.17.1) with ESMTPS id 697Gg1aQ2585476
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Wed, 7 Oct 2026 12:42:02 -0400
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.18.1/Submit) id 697Gg1pN2585395;
	Wed, 7 Oct 2026 12:42:01 -0400
Date: Wed, 7 Oct 2026 12:42:01 -0400
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Suresh Thelkar <suresh.thelkar@yahoo.com>
Cc: dm-devel@lists.linux.dev, Martin Wilck <mwilck@suse.com>
Subject: Re: [PATCH v2 2/2] libmultipath: dm_flush_map__: log if the resume
 fails after a failed remove
Message-ID: <asZ2WTKM-SeIbsE6@redhat.com>
References: <20261005045726.71858-1-suresh.thelkar@yahoo.com>
 <20261007092236.165908-1-suresh.thelkar@yahoo.com>
 <20261007092236.165908-3-suresh.thelkar@yahoo.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <20261007092236.165908-3-suresh.thelkar@yahoo.com>
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.93
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: b8Vj35qipdqwJZGbkd0Mezn5Eveu2Y0myA5joHkXyZU_1791391323
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Oct 07, 2026 at 09:22:36AM +0000, Suresh Thelkar wrote:
> After a failed DM_DEVICE_REMOVE the map was suspended earlier in
> dm_flush_map__(), and the recovery path issued a single fire-and-forget
> DM_DEVICE_RESUME whose result was ignored. If that resume ioctl failed,
> the map could be left suspended with no trace in the logs, which wedges
> any later task in uninterruptible D state and, because sync() walks
> every block device, hangs I/O node-wide until reboot.
> 
> Check the DM_DEVICE_RESUME return value and log at condlog(1) when it
> fails, so a leaked suspend is at least visible in the logs. The map is
> known to have been suspended at the start of the loop, so the ioctl
> return value is authoritative.
> 
> Signed-off-by: Suresh Thelkar <suresh.thelkar@yahoo.com>

I want to discuss this change from v1 a bit. The issue that the second
resume is solving is the same one that lead us to add a second resume to
dm_addmap_reload(). If the device has an invalid inactive table, and you
do a resume, dm will attempt to swap the table, fail, and leave the
device suspended with the invalid table removed. Immediately issuing a
second resume will cause dm to actually resume with the old table. If we
don't manage to resume the device, it seems much less likely that
waiting a second and re-attempting the remove will succeed (I believe
the most common case is us racing with something that temporarily opens
the device, like udev. It may need the device to be unsuspended to
do a quick read and close it again). 

Now, I admit that this is WAY more likely to happen when we are actually
reloading the table, since we just added an inactive table, and dm might
not be able to swap it correctly for any number of reasons. To hit this
issue when removing the device there would need to be an inactive table
(which is unlikely) and dm would have to fail when trying to swap tables
(which is also unlikely). Also, we resume the table in other places in
the code, without caring about this corner case. For consistency's sake,
we should probably either always do it, or only do it when we've loaded
a new table.

Thoughts? Also, I'm fine with this change going in as-is and dealing
with the resume question as a separate issue.

-Ben 

> ---
>  libmultipath/devmapper.c | 10 ++++++----
>  1 file changed, 6 insertions(+), 4 deletions(-)
> 
> diff --git a/libmultipath/devmapper.c b/libmultipath/devmapper.c
> index a5570a85..85c552cf 100644
> --- a/libmultipath/devmapper.c
> +++ b/libmultipath/devmapper.c
> @@ -1062,10 +1062,12 @@ int dm_flush_map__ (const char *mapname, int flags, int retries)
>  			else
>  				condlog(2, "failed to remove multipath map %s",
>  					mapname);
> -			if ((flags & DMFL_SUSPEND) && queue_if_no_path != -1) {
> -				dm_simplecmd_noflush(DM_DEVICE_RESUME,
> -						     mapname, udev_flags);
> -			}
> +			/* Resume the map suspended above; log if the resume
> +			 * ioctl fails, so a leaked suspend is visible. */
> +			if ((flags & DMFL_SUSPEND) && queue_if_no_path != -1 &&
> +			    !dm_simplecmd_noflush(DM_DEVICE_RESUME, mapname, udev_flags))
> +				condlog(1, "%s: failed to resume map after failed remove",
> +					mapname);
>  		}
>  		if (retries)
>  			sleep(1);
> -- 
> 2.43.0

