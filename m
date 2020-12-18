Return-Path: <SRS0=A8Ao=FW=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0095EC4361B
	for <dm-devel@archiver.kernel.org>; Fri, 18 Dec 2020 18:03:08 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 7C86123B76
	for <dm-devel@archiver.kernel.org>; Fri, 18 Dec 2020 18:03:07 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 7C86123B76
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1608314586;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=mkd60DJeJf6KxG7gH1IDyYrfjgxEneEgj05TO3WR/ro=;
	b=VcYRWzNjV+KkPTLYbhihlnpYqvu1y/VcLGlyv4dMsS7avxog5Wq5JurWObDuwvf8toCsML
	DSTOf4ee3liLRBWwgYWoac3v8Pv89PeECUpDXkNEbk7WYgT3dtEpD+effkTEgPNSR6PLxY
	9noaf5zJLnOLMuQbo7unrRqTiumOKd0=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-485-uy50L-kSMi-USHON0UiGIA-1; Fri, 18 Dec 2020 13:03:03 -0500
X-MC-Unique: uy50L-kSMi-USHON0UiGIA-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 203E919611A6;
	Fri, 18 Dec 2020 18:02:58 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id ACBC55D9D7;
	Fri, 18 Dec 2020 18:02:56 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 641E94EA6C;
	Fri, 18 Dec 2020 18:02:54 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com
	[10.5.11.11])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 0BIHvoj0030526 for <dm-devel@listman.util.phx.redhat.com>;
	Fri, 18 Dec 2020 12:57:50 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 9AA3C2C01B; Fri, 18 Dec 2020 17:57:50 +0000 (UTC)
Received: from octiron.msp.redhat.com (octiron.msp.redhat.com [10.15.80.209])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 6B6A518AAB;
	Fri, 18 Dec 2020 17:57:47 +0000 (UTC)
Received: from octiron.msp.redhat.com (localhost.localdomain [127.0.0.1])
	by octiron.msp.redhat.com (8.14.9/8.14.9) with ESMTP id 0BIHvkev008256; 
	Fri, 18 Dec 2020 11:57:46 -0600
Received: (from bmarzins@localhost)
	by octiron.msp.redhat.com (8.14.9/8.14.9/Submit) id 0BIHvjRF008255;
	Fri, 18 Dec 2020 11:57:45 -0600
Date: Fri, 18 Dec 2020 11:57:45 -0600
From: Benjamin Marzinski <bmarzins@redhat.com>
To: mwilck@suse.com
Message-ID: <20201218175745.GK3103@octiron.msp.redhat.com>
References: <20201217110018.3347-1-mwilck@suse.com>
	<20201217110018.3347-5-mwilck@suse.com>
MIME-Version: 1.0
In-Reply-To: <20201217110018.3347-5-mwilck@suse.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
X-loop: dm-devel@redhat.com
Cc: dm-devel@redhat.com
Subject: Re: [dm-devel] [PATCH 4/7] libmultipath: force map reload if udev
	incomplete
X-BeenThere: dm-devel@redhat.com
X-Mailman-Version: 2.1.12
Precedence: junk
List-Id: device-mapper development <dm-devel.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Thu, Dec 17, 2020 at 12:00:15PM +0100, mwilck@suse.com wrote:
> From: Martin Wilck <mwilck@suse.com>
> 
> We've recently observed various cases of incompletely processed uevents
> during initrd processing. Typically, this would leave a dm device in
> the state it had after the initial "add" uevent, which is basically unusable,
> because udevd had been killed by systemd before processing the subsequent
> "change" event. After switching root, the coldplug event would re-read
> the db file, which would be in unusable state, and would not do anything.
> In such cases, a RELOAD action with force_udev_reload=1 is in order to
> make udev re-process the device completely (DM_UDEV_PRIMARY_SOURCE_FLAG=1 and
> DM_SUBSYSTEM_UDEV_FLAG0=0).
> 
> The previous commits
> 
> 2b25a9e libmultipath: select_action(): force udev reload for uninitialized maps
> cb10d38 multipathd: uev_trigger(): handle incomplete ADD events
> 
> addressed the same issue, but incompletely. They would miss cases where the
> map was configured correctly but none of the RELOAD criteria were met.
> This patch partially reverts 2b25a9e by converting select_reload_action() into
> a trivial helper. Instead, we now check for incompletely initialized udev now
> before checking any of the other reload criteria.
> 
Reviewed-by: Benjamin Marzinski <bmarzins@redhat.com>
> Signed-off-by: Martin Wilck <mwilck@suse.com>
> ---
>  libmultipath/configure.c | 45 ++++++++++++++++++++++++++--------------
>  1 file changed, 29 insertions(+), 16 deletions(-)
> 
> diff --git a/libmultipath/configure.c b/libmultipath/configure.c
> index 3dbc1f1..d64fe88 100644
> --- a/libmultipath/configure.c
> +++ b/libmultipath/configure.c
> @@ -695,12 +695,11 @@ sysfs_set_max_sectors_kb(struct multipath *mpp, int is_reload)
>  	return err;
>  }
>  
> -static void
> -select_reload_action(struct multipath *mpp, const struct multipath *cmpp,
> -		     const char *reason)
> +static bool is_udev_ready(struct multipath *cmpp)
>  {
>  	struct udev_device *mpp_ud;
>  	const char *env;
> +	bool rc;
>  
>  	/*
>  	 * MPATH_DEVICE_READY != 1 can mean two things:
> @@ -712,14 +711,20 @@ select_reload_action(struct multipath *mpp, const struct multipath *cmpp,
>  	 */
>  
>  	mpp_ud = get_udev_for_mpp(cmpp);
> +	if (!mpp_ud)
> +		return true;
>  	env = udev_device_get_property_value(mpp_ud, "MPATH_DEVICE_READY");
> -	if ((!env || strcmp(env, "1")) && count_active_paths(mpp) > 0)
> -		mpp->force_udev_reload = 1;
> +	rc = (env != NULL && !strcmp(env, "1"));
>  	udev_device_unref(mpp_ud);
> +	condlog(4, "%s: %s: \"%s\" -> %d\n", __func__, cmpp->alias, env, rc);
> +	return rc;
> +}
> +
> +static void
> +select_reload_action(struct multipath *mpp, const char *reason)
> +{
>  	mpp->action = ACT_RELOAD;
> -	condlog(3, "%s: set ACT_RELOAD (%s%s)", mpp->alias,
> -		mpp->force_udev_reload ? "forced, " : "",
> -		reason);
> +	condlog(3, "%s: set ACT_RELOAD (%s)", mpp->alias, reason);
>  }
>  
>  void select_action (struct multipath *mpp, const struct _vector *curmp,
> @@ -788,10 +793,18 @@ void select_action (struct multipath *mpp, const struct _vector *curmp,
>  		return;
>  	}
>  
> +	if (!is_udev_ready(cmpp) && count_active_paths(mpp) > 0) {
> +		mpp->force_udev_reload = 1;
> +		mpp->action = ACT_RELOAD;
> +		condlog(3, "%s: set ACT_RELOAD (udev incomplete)",
> +			mpp->alias);
> +		return;
> +	}
> +
>  	if (mpp->no_path_retry != NO_PATH_RETRY_UNDEF &&
>  	    !!strstr(mpp->features, "queue_if_no_path") !=
>  	    !!strstr(cmpp->features, "queue_if_no_path")) {
> -		select_reload_action(mpp, cmpp, "no_path_retry change");
> +		select_reload_action(mpp, "no_path_retry change");
>  		return;
>  	}
>  	if ((mpp->retain_hwhandler != RETAIN_HWHANDLER_ON ||
> @@ -799,7 +812,7 @@ void select_action (struct multipath *mpp, const struct _vector *curmp,
>  	    (strlen(cmpp->hwhandler) != strlen(mpp->hwhandler) ||
>  	     strncmp(cmpp->hwhandler, mpp->hwhandler,
>  		    strlen(mpp->hwhandler)))) {
> -		select_reload_action(mpp, cmpp, "hwhandler change");
> +		select_reload_action(mpp, "hwhandler change");
>  		return;
>  	}
>  
> @@ -807,7 +820,7 @@ void select_action (struct multipath *mpp, const struct _vector *curmp,
>  	    !!strstr(mpp->features, "retain_attached_hw_handler") !=
>  	    !!strstr(cmpp->features, "retain_attached_hw_handler") &&
>  	    get_linux_version_code() < KERNEL_VERSION(4, 3, 0)) {
> -		select_reload_action(mpp, cmpp, "retain_hwhandler change");
> +		select_reload_action(mpp, "retain_hwhandler change");
>  		return;
>  	}
>  
> @@ -819,7 +832,7 @@ void select_action (struct multipath *mpp, const struct _vector *curmp,
>  		remove_feature(&cmpp_feat, "queue_if_no_path");
>  		remove_feature(&cmpp_feat, "retain_attached_hw_handler");
>  		if (strncmp(mpp_feat, cmpp_feat, PARAMS_SIZE)) {
> -			select_reload_action(mpp, cmpp, "features change");
> +			select_reload_action(mpp, "features change");
>  			FREE(cmpp_feat);
>  			FREE(mpp_feat);
>  			return;
> @@ -830,19 +843,19 @@ void select_action (struct multipath *mpp, const struct _vector *curmp,
>  
>  	if (!cmpp->selector || strncmp(cmpp->selector, mpp->selector,
>  		    strlen(mpp->selector))) {
> -		select_reload_action(mpp, cmpp, "selector change");
> +		select_reload_action(mpp, "selector change");
>  		return;
>  	}
>  	if (cmpp->minio != mpp->minio) {
> -		select_reload_action(mpp, cmpp, "minio change");
> +		select_reload_action(mpp, "minio change");
>  		return;
>  	}
>  	if (!cmpp->pg || VECTOR_SIZE(cmpp->pg) != VECTOR_SIZE(mpp->pg)) {
> -		select_reload_action(mpp, cmpp, "path group number change");
> +		select_reload_action(mpp, "path group number change");
>  		return;
>  	}
>  	if (pgcmp(mpp, cmpp)) {
> -		select_reload_action(mpp, cmpp, "path group topology change");
> +		select_reload_action(mpp, "path group topology change");
>  		return;
>  	}
>  	if (cmpp->nextpg != mpp->bestpg) {
> -- 
> 2.29.0

--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel

