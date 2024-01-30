Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5CD5E12839C
	for <dm-devel@lists.linux.dev>; Tue, 30 Jan 2024 16:41:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706632898; cv=none; b=bK6o6U2okUCN5po6umNCY96jkmm9Nq0x4lq92LBFV7v8rGuRPoRVk5YV0+7L0BXrjYlTpOcXPTH8BUB6kjFdEUU79YtQ0tnvZlGF/TvLSsvtDdNm6KtM9EsvHSbLsbrHMd1CunABy+7ZjLXqhkFXeddTHcUVcN9JRewzYzprEoY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706632898; c=relaxed/simple;
	bh=7CZjc6hkNTgFwGXPLivZD/LBidpM6mTQ3V0qdK0QE08=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 In-Reply-To:Content-Type:Content-Disposition; b=TabcS37HwHwAejM9zi3/KkViHCNXx5pWF/ig1Zd9Cqpqabe0qyqOBkbGwLzPnHn+gLmXcru4+ewoWwGGqbEO2Vb88YC16F4a+Yb5Todw+UoF+BZPT1tk9JSRRTlxGffem5wyG3uyTMm9uppxH7UTri9zlXLjD6+V0YV38L/Qpgw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=W6WwPQI7; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="W6WwPQI7"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1706632895;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=7s2jLm7QNzl3hDBZ6ammon7hYtGmGwz58G2L9H3aFmA=;
	b=W6WwPQI7DKNzAx+y06ROFSsNR2OFgGq5ohLYYgBK9Ae1uErhPSxuU6rRNno92LaYStPMsC
	F3N8ZeoL7e9pQm73EGhtrQRa+9U58PYKN3sSrVXezTIHkWFHAueeyylJBFhaAwFbUiRTSc
	G9svkoGnsPFu/kabwA8tSE/UIvahmwo=
Received: from mimecast-mx02.redhat.com (mx-ext.redhat.com [66.187.233.73])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-488-JA-30aC-OTyNaf8wYMPjAg-1; Tue,
 30 Jan 2024 11:41:31 -0500
X-MC-Unique: JA-30aC-OTyNaf8wYMPjAg-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 6760F2815E26;
	Tue, 30 Jan 2024 16:41:31 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (bmarzins-01.fast.eng.rdu2.dc.redhat.com [10.6.23.12])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 4F578C154AB;
	Tue, 30 Jan 2024 16:41:31 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.1/8.17.1) with ESMTPS id 40UGfVHC251942
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Tue, 30 Jan 2024 11:41:31 -0500
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.1/8.17.1/Submit) id 40UGfUue251941;
	Tue, 30 Jan 2024 11:41:30 -0500
Date: Tue, 30 Jan 2024 11:41:30 -0500
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Brian Bunker <brian@purestorage.com>
Cc: dm-devel@lists.linux.dev, mwilck@suse.com,
        Seamus Connor <sconnor@purestorage.com>
Subject: Re: [PATCH] multipathd: the sysfs prioritizer can return stale data
Message-ID: <ZbkmuqWetsaOPMkC@bmarzins-01.fast.eng.rdu2.dc.redhat.com>
References: <20240124020007.25259-1-brian@purestorage.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <20240124020007.25259-1-brian@purestorage.com>
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.8
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Jan 23, 2024 at 06:00:07PM -0800, Brian Bunker wrote:
> When a path is lost and then reinstated later, the ALUA
> device handler will not pick up this change and continue
> to possibly provide incorrect (stale) information about
> its ALUA state to the 'sysfs' prioritizer if the path's
> priorities were changed prior to the loss of those paths.
> 
> On the loss of an I_T nexus, the path state should not
> continue to use its last known state. Many things and a lot
> of time could have passed between the path loss and its
> eventual reinstatemnt.
> 
> The ALUA device handler didn't have this issue since it
> always got the ALUA state from the target by sending an RTPG
> request on the path and updated the priority. However with
> the detect priority set to true by default, the 'sysfs'
> prioritzier will be used on targets that support ALUA rather
> than the 'alua' prioritizer.
> 
> Without re-evaluating the ALUA state when a path returns
> multipath is left with path states which do not reflect
> the actual ALUA states the target is providing.
> 
> 3624a9370f0f545fc7c3e46a100011010 dm-2 PURE,FlashArray
> size=3.0T features='0' hwhandler='1 alua' wp=rw
> |-+- policy='service-time 0' prio=50 status=active
> | |- 13:0:0:1 sdg 8:96  active ready running
> | |- 12:0:0:1 sdf 8:80  active ready running
> | |- 9:0:0:1  sdc 8:32  active ready running
> | `- 1:0:0:1  sdb 8:16  active ready running
> `-+- policy='service-time 0' prio=10 status=enabled
>   |- 14:0:0:1 sdh 8:112 active ready running
>   |- 15:0:0:1 sdi 8:128 active ready running
>   |- 10:0:0:1 sdd 8:48  active ready running
>   `- 11:0:0:1 sde 8:64  active ready running
> 
>  # sg_rtpg /dev/sdh (Active/Optimized)
> target port group asymmetric access state : 0x00
> 
> Signed-off-by: Brian Bunker <brian@purestorage.com>
> Signed-off-by: Seamus Connor <sconnor@purestorage.com>
> ---
>  multipathd/main.c | 5 +++++
>  1 file changed, 5 insertions(+)
> 
> diff --git a/multipathd/main.c b/multipathd/main.c
> index 230c9d10..dd48be74 100644
> --- a/multipathd/main.c
> +++ b/multipathd/main.c
> @@ -1937,6 +1937,11 @@ reinstate_path (struct path * pp)
>  	else {
>  		condlog(2, "%s: reinstated", pp->dev_t);
>  		update_queue_mode_add_path(pp->mpp);
> +		if (strcmp(pp->prio.name, PRIO_SYSFS) == 0) {
> +			condlog(2, "%s: rescan target to update priorities",
> +				pp->dev_t);
> +			rescan_path(pp->udev);

I can see why this is necessary with the sysfs target, but AFAICT
rescanning the scsi device will end up calling scsi_execute_cmd to
update the vpd pages, and this can block.  Obviously, we are doing this
after the checker has verified that the path is up, but even still,
we're trying to cut down on the amount of code that can block multipathd
on an inaccessible device, instead of increase it.

Perhaps it would be better to make the prioritizer itself smarter, so
that it could know when it needs to run the rescan(), and it could do
that in a separate thread.

Thoughts?

-Ben

> +		}
>  	}
>  }
>  
> -- 
> 2.43.0

