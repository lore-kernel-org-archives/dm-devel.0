Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6EDEB21A433
	for <dm-devel@lists.linux.dev>; Mon, 21 Jul 2025 06:01:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753077682; cv=none; b=Ji4J30s4RJmTRKwYA0XkfAubl5SsAAkvu1DPqmlNL52so/3jSW1T+xUreVIMJKv+Xe1m3dgqLwVbyWHizhcsn/9BTYJB7yJkcVP59rGS5HIigTItT+pX5HVchoLW42kwwoIJ75Qhnmw2hJkYR0b8bE/LVGVXsTDKbaq2fuo1koQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753077682; c=relaxed/simple;
	bh=CWzU0xrYk1v44+Z7na9toRLUZpZoN+YAtBczIFL1d0E=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=dLeuJiRVO34i8EmdXVQNZtIW8wzcnzHOY5f+Z84G7EiX0vg4UAtWO2gSzSPHAnHgktgwrhzihI9aZrYgfEHh2TW7VTnuX2FgtBSeFjeelFjCvSeThgDH50QMSxFHBRI1i/GUbrtqyUqRN92VRqICBYyL6yQX22gIFpa53ueVN9c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=jNl73b+m; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=VRrqNaCR; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=jNl73b+m; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=VRrqNaCR; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="jNl73b+m";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="VRrqNaCR";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="jNl73b+m";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="VRrqNaCR"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 270E92123A;
	Mon, 21 Jul 2025 06:01:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1753077672; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=9yoMb371Tz4GwGn7mhwncLttXwPgpePW1Mqkvnyq6CU=;
	b=jNl73b+mjmQhbXPySmjNOfkMbLjM6RdH/bemsvRsiRhO+xtvrs75O25o/Nx/xMeq9SyAnA
	aQCC3cdqsFlsW0vbIWIVq0mWQzJ+dEqG/2oh/2+hpOf6fYFW12Kaiwe0RbdiZK3qKoXBOk
	e8PWAlhQ5Z0A2Zq6+UnsFI42HYf0oi4=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1753077672;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=9yoMb371Tz4GwGn7mhwncLttXwPgpePW1Mqkvnyq6CU=;
	b=VRrqNaCR9m5KdpGZXOzWWKITxfVWSwPkO4LBM6ZmQrGVNf+wiATJ8NiIptNwp98HeD1gqJ
	XttkS5JTfyPSJnBA==
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=jNl73b+m;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=VRrqNaCR
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1753077672; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=9yoMb371Tz4GwGn7mhwncLttXwPgpePW1Mqkvnyq6CU=;
	b=jNl73b+mjmQhbXPySmjNOfkMbLjM6RdH/bemsvRsiRhO+xtvrs75O25o/Nx/xMeq9SyAnA
	aQCC3cdqsFlsW0vbIWIVq0mWQzJ+dEqG/2oh/2+hpOf6fYFW12Kaiwe0RbdiZK3qKoXBOk
	e8PWAlhQ5Z0A2Zq6+UnsFI42HYf0oi4=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1753077672;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=9yoMb371Tz4GwGn7mhwncLttXwPgpePW1Mqkvnyq6CU=;
	b=VRrqNaCR9m5KdpGZXOzWWKITxfVWSwPkO4LBM6ZmQrGVNf+wiATJ8NiIptNwp98HeD1gqJ
	XttkS5JTfyPSJnBA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 836BE13A88;
	Mon, 21 Jul 2025 06:01:11 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id jh4LHqfXfWiBRQAAD6G6ig
	(envelope-from <hare@suse.de>); Mon, 21 Jul 2025 06:01:11 +0000
Message-ID: <ef4a53e0-760e-4ec8-9fdf-f4e8f36360c0@suse.de>
Date: Mon, 21 Jul 2025 08:01:11 +0200
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 06/11] md/md-bitmap: delay registration of bitmap_ops
 until creating bitmap
To: Yu Kuai <yukuai1@huaweicloud.com>, corbet@lwn.net, agk@redhat.com,
 snitzer@kernel.org, mpatocka@redhat.com, song@kernel.org, yukuai3@huawei.com
Cc: linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
 dm-devel@lists.linux.dev, linux-raid@vger.kernel.org, yi.zhang@huawei.com,
 yangerkun@huawei.com, johnny.chenyi@huawei.com
References: <20250718092336.3346644-1-yukuai1@huaweicloud.com>
 <20250718092336.3346644-7-yukuai1@huaweicloud.com>
Content-Language: en-US
From: Hannes Reinecke <hare@suse.de>
In-Reply-To: <20250718092336.3346644-7-yukuai1@huaweicloud.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spamd-Result: default: False [-4.51 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_DKIM_ALLOW(-0.20)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	FROM_HAS_DN(0.00)[];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	ARC_NA(0.00)[];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	RCPT_COUNT_TWELVE(0.00)[14];
	MIME_TRACE(0.00)[0:+];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	DKIM_TRACE(0.00)[suse.de:+];
	RCVD_COUNT_TWO(0.00)[2];
	FROM_EQ_ENVFROM(0.00)[];
	TO_DN_SOME(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	DWL_DNSWL_BLOCKED(0.00)[suse.de:dkim];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[huawei.com:email,imap1.dmz-prg2.suse.org:helo,imap1.dmz-prg2.suse.org:rdns]
X-Spam-Flag: NO
X-Spam-Level: 
X-Rspamd-Queue-Id: 270E92123A
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org
X-Rspamd-Action: no action
X-Spam-Score: -4.51

On 7/18/25 11:23, Yu Kuai wrote:
> From: Yu Kuai <yukuai3@huawei.com>
> 
> Currently bitmap_ops is registered while allocating mddev, this is fine
> when there is only one bitmap_ops.
> 
> Delay setting bitmap_ops until creating bitmap, so that user can choose
> which bitmap to use before running the array.
> 
> Signed-off-by: Yu Kuai <yukuai3@huawei.com>
> ---
>   Documentation/admin-guide/md.rst |  3 ++
>   drivers/md/md.c                  | 82 +++++++++++++++++++++-----------
>   2 files changed, 56 insertions(+), 29 deletions(-)
> 
> diff --git a/Documentation/admin-guide/md.rst b/Documentation/admin-guide/md.rst
> index 356d2a344f08..03a9f5025f99 100644
> --- a/Documentation/admin-guide/md.rst
> +++ b/Documentation/admin-guide/md.rst
> @@ -388,6 +388,9 @@ All md devices contain:
>        bitmap
>            The default internal bitmap
>   
> +If bitmap_type is not none, then additional bitmap attributes will be
> +created after md device KOBJ_CHANGE event.
> +
>   If bitmap_type is bitmap, then the md device will also contain:
>   
>     bitmap/location

Please state _which_ attributes are created with the KOBJ_CHANGE
event.

> diff --git a/drivers/md/md.c b/drivers/md/md.c
> index d8b0dfdb4bfc..639b0143cbb1 100644
> --- a/drivers/md/md.c
> +++ b/drivers/md/md.c
> @@ -674,9 +674,11 @@ static void no_op(struct percpu_ref *r) {}
>   
>   static bool mddev_set_bitmap_ops(struct mddev *mddev)
>   {
> +	struct bitmap_operations *old = mddev->bitmap_ops;
>   	struct md_submodule_head *head;
>   
> -	if (mddev->bitmap_id == ID_BITMAP_NONE)
> +	if (mddev->bitmap_id == ID_BITMAP_NONE ||
> +	    (old && old->head.id == mddev->bitmap_id))
>   		return true;
>   
>   	xa_lock(&md_submodule);
> @@ -694,6 +696,18 @@ static bool mddev_set_bitmap_ops(struct mddev *mddev)
>   
>   	mddev->bitmap_ops = (void *)head;
>   	xa_unlock(&md_submodule);
> +
> +	if (mddev->bitmap_ops->group) {
> +		if (sysfs_create_group(&mddev->kobj, mddev->bitmap_ops->group))
> +			pr_warn("md: cannot register extra bitmap attributes for %s\n",
> +				mdname(mddev));
> +		else
> +			/*
> +			 * Inform user with KOBJ_CHANGE about new bitmap
> +			 * attributes.
> +			 */
> +			kobject_uevent(&mddev->kobj, KOBJ_CHANGE);
> +	}
>   	return true;
>   
>   err:
> @@ -703,28 +717,25 @@ static bool mddev_set_bitmap_ops(struct mddev *mddev)
>   
>   static void mddev_clear_bitmap_ops(struct mddev *mddev)
>   {
> +	if (mddev->bitmap_ops && mddev->bitmap_ops->group)
> +		sysfs_remove_group(&mddev->kobj, mddev->bitmap_ops->group);
> +
>   	mddev->bitmap_ops = NULL;
>   }
>   
>   int mddev_init(struct mddev *mddev)
>   {
> -	if (!IS_ENABLED(CONFIG_MD_BITMAP)) {
> +	if (!IS_ENABLED(CONFIG_MD_BITMAP))
>   		mddev->bitmap_id = ID_BITMAP_NONE;
> -	} else {
> +	else
>   		mddev->bitmap_id = ID_BITMAP;
> -		if (!mddev_set_bitmap_ops(mddev))
> -			return -EINVAL;
> -	}
>   
>   	if (percpu_ref_init(&mddev->active_io, active_io_release,
> -			    PERCPU_REF_ALLOW_REINIT, GFP_KERNEL)) {
> -		mddev_clear_bitmap_ops(mddev);
> +			    PERCPU_REF_ALLOW_REINIT, GFP_KERNEL))
>   		return -ENOMEM;
> -	}
>   
>   	if (percpu_ref_init(&mddev->writes_pending, no_op,
>   			    PERCPU_REF_ALLOW_REINIT, GFP_KERNEL)) {
> -		mddev_clear_bitmap_ops(mddev);
>   		percpu_ref_exit(&mddev->active_io);
>   		return -ENOMEM;
>   	}
> @@ -752,6 +763,7 @@ int mddev_init(struct mddev *mddev)
>   	mddev->resync_min = 0;
>   	mddev->resync_max = MaxSector;
>   	mddev->level = LEVEL_NONE;
> +	mddev->bitmap_id = ID_BITMAP;
>   
>   	INIT_WORK(&mddev->sync_work, md_start_sync);
>   	INIT_WORK(&mddev->del_work, mddev_delayed_delete);
> @@ -762,7 +774,6 @@ EXPORT_SYMBOL_GPL(mddev_init);
>   
>   void mddev_destroy(struct mddev *mddev)
>   {
> -	mddev_clear_bitmap_ops(mddev);
>   	percpu_ref_exit(&mddev->active_io);
>   	percpu_ref_exit(&mddev->writes_pending);
>   }
> @@ -6125,11 +6136,6 @@ struct mddev *md_alloc(dev_t dev, char *name)
>   		return ERR_PTR(error);
>   	}
>   
> -	if (md_bitmap_registered(mddev) && mddev->bitmap_ops->group)
> -		if (sysfs_create_group(&mddev->kobj, mddev->bitmap_ops->group))
> -			pr_warn("md: cannot register extra bitmap attributes for %s\n",
> -				mdname(mddev));
> -
>   	kobject_uevent(&mddev->kobj, KOBJ_ADD);
>   	mddev->sysfs_state = sysfs_get_dirent_safe(mddev->kobj.sd, "array_state");
>   	mddev->sysfs_level = sysfs_get_dirent_safe(mddev->kobj.sd, "level");
> @@ -6205,6 +6211,26 @@ static void md_safemode_timeout(struct timer_list *t)
>   
>   static int start_dirty_degraded;
>   
> +static int md_bitmap_create(struct mddev *mddev)
> +{
> +	if (mddev->bitmap_id == ID_BITMAP_NONE)
> +		return -EINVAL;
> +
> +	if (!mddev_set_bitmap_ops(mddev))
> +		return -ENOENT;
> +
> +	return mddev->bitmap_ops->create(mddev);
> +}
> +
> +static void md_bitmap_destroy(struct mddev *mddev)
> +{
> +	if (!md_bitmap_registered(mddev))
> +		return;
> +
> +	mddev->bitmap_ops->destroy(mddev);
> +	mddev_clear_bitmap_ops(mddev);
> +}
> +
>   int md_run(struct mddev *mddev)
>   {
>   	int err;
> @@ -6369,9 +6395,9 @@ int md_run(struct mddev *mddev)
>   			(unsigned long long)pers->size(mddev, 0, 0) / 2);
>   		err = -EINVAL;
>   	}
> -	if (err == 0 && pers->sync_request && md_bitmap_registered(mddev) &&
> +	if (err == 0 && pers->sync_request &&
>   	    (mddev->bitmap_info.file || mddev->bitmap_info.offset)) {
> -		err = mddev->bitmap_ops->create(mddev);
> +		err = md_bitmap_create(mddev);
>   		if (err)
>   			pr_warn("%s: failed to create bitmap (%d)\n",
>   				mdname(mddev), err);
> @@ -6444,8 +6470,7 @@ int md_run(struct mddev *mddev)
>   		pers->free(mddev, mddev->private);
>   	mddev->private = NULL;
>   	put_pers(pers);
> -	if (md_bitmap_registered(mddev))
> -		mddev->bitmap_ops->destroy(mddev);
> +	md_bitmap_destroy(mddev);
>   abort:
>   	bioset_exit(&mddev->io_clone_set);
>   exit_sync_set:
> @@ -6468,7 +6493,7 @@ int do_md_run(struct mddev *mddev)
>   	if (md_bitmap_registered(mddev)) {
>   		err = mddev->bitmap_ops->load(mddev);
>   		if (err) {
> -			mddev->bitmap_ops->destroy(mddev);
> +			md_bitmap_destroy(mddev);
>   			goto out;
>   		}
>   	}
> @@ -6659,8 +6684,7 @@ static void __md_stop(struct mddev *mddev)
>   {
>   	struct md_personality *pers = mddev->pers;
>   
> -	if (md_bitmap_registered(mddev))
> -		mddev->bitmap_ops->destroy(mddev);
> +	md_bitmap_destroy(mddev);
>   	mddev_detach(mddev);
>   	spin_lock(&mddev->lock);
>   	mddev->pers = NULL;
> @@ -7440,16 +7464,16 @@ static int set_bitmap_file(struct mddev *mddev, int fd)
>   	err = 0;
>   	if (mddev->pers) {
>   		if (fd >= 0) {
> -			err = mddev->bitmap_ops->create(mddev);
> +			err = md_bitmap_create(mddev);
>   			if (!err)
>   				err = mddev->bitmap_ops->load(mddev);
>   
>   			if (err) {
> -				mddev->bitmap_ops->destroy(mddev);
> +				md_bitmap_destroy(mddev);
>   				fd = -1;
>   			}
>   		} else if (fd < 0) {
> -			mddev->bitmap_ops->destroy(mddev);
> +			md_bitmap_destroy(mddev);
>   		}
>   	}
>   
> @@ -7764,12 +7788,12 @@ static int update_array_info(struct mddev *mddev, mdu_array_info_t *info)
>   				mddev->bitmap_info.default_offset;
>   			mddev->bitmap_info.space =
>   				mddev->bitmap_info.default_space;
> -			rv = mddev->bitmap_ops->create(mddev);
> +			rv = md_bitmap_create(mddev);
>   			if (!rv)
>   				rv = mddev->bitmap_ops->load(mddev);
>   
>   			if (rv)
> -				mddev->bitmap_ops->destroy(mddev);
> +				md_bitmap_destroy(mddev);
>   		} else {
>   			struct md_bitmap_stats stats;
>   
> @@ -7795,7 +7819,7 @@ static int update_array_info(struct mddev *mddev, mdu_array_info_t *info)
>   				put_cluster_ops(mddev);
>   				mddev->safemode_delay = DEFAULT_SAFEMODE_DELAY;
>   			}
> -			mddev->bitmap_ops->destroy(mddev);
> +			md_bitmap_destroy(mddev);
>   			mddev->bitmap_info.offset = 0;
>   		}
>   	}

Otherwise:
Reviewed-by: Hannes Reinecke <hare@suse.de>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                  Kernel Storage Architect
hare@suse.de                                +49 911 74053 688
SUSE Software Solutions GmbH, Frankenstr. 146, 90461 Nürnberg
HRB 36809 (AG Nürnberg), GF: I. Totev, A. McDonald, W. Knoblich
