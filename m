Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C3C36C433EF
	for <dm-devel@archiver.kernel.org>; Wed, 23 Mar 2022 23:21:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1648077704;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=BNPczhkFDQUY552+aRYlz2ofdTdHtm5/4Xa3OKi9YAc=;
	b=Pw4j99NY2nob71nrwJsbNJrvR+G/0tLIvT8lzLynouVLf1WtNGKlaanb0MiyvGNrDqEAfw
	oVbvmnfxHslnzYAZiICPIh9x4ev8NkuI9RuXogTgCVzXb7FMMBdTSxIcCxr08aGxVqfoaB
	d9StJiicpxe+QWaFaWEVyravdMuZOV0=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-468-bCzAF1mUPOaYHF_ThSK9IQ-1; Wed, 23 Mar 2022 19:21:43 -0400
X-MC-Unique: bCzAF1mUPOaYHF_ThSK9IQ-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 5AC551C01508;
	Wed, 23 Mar 2022 23:21:41 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 0887540D1B9A;
	Wed, 23 Mar 2022 23:21:41 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 9B1F21940347;
	Wed, 23 Mar 2022 23:21:40 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com
 [10.11.54.9])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id A907D1949763
 for <dm-devel@listman.corp.redhat.com>; Wed, 23 Mar 2022 23:10:25 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 763C25805BF; Wed, 23 Mar 2022 23:10:25 +0000 (UTC)
Received: from octiron.msp.redhat.com (octiron.msp.redhat.com [10.15.80.209])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 5C00C5805BC;
 Wed, 23 Mar 2022 23:10:25 +0000 (UTC)
Received: from octiron.msp.redhat.com (localhost.localdomain [127.0.0.1])
 by octiron.msp.redhat.com (8.14.9/8.14.9) with ESMTP id 22NNAOwI020640;
 Wed, 23 Mar 2022 18:10:24 -0500
Received: (from bmarzins@localhost)
 by octiron.msp.redhat.com (8.14.9/8.14.9/Submit) id 22NNANbE020639;
 Wed, 23 Mar 2022 18:10:23 -0500
Date: Wed, 23 Mar 2022 18:10:23 -0500
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Uday Shankar <ushankar@purestorage.com>
Message-ID: <20220323231023.GL24684@octiron.msp.redhat.com>
References: <20220309200325.2490463-1-ushankar@purestorage.com>
MIME-Version: 1.0
In-Reply-To: <20220309200325.2490463-1-ushankar@purestorage.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.9
Subject: Re: [dm-devel] [PATCH] multipath-tools: update mpp->force_readonly
 in ev_add_path
X-BeenThere: dm-devel@redhat.com
X-Mailman-Version: 2.1.29
Precedence: list
List-Id: device-mapper development <dm-devel.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/dm-devel>,
 <mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <http://listman.redhat.com/archives/dm-devel/>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/dm-devel>,
 <mailto:dm-devel-request@redhat.com?subject=subscribe>
Cc: dm-devel@redhat.com, Martin Wilck <mwilck@suse.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.2
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Wed, Mar 09, 2022 at 01:03:26PM -0700, Uday Shankar wrote:
> When NVMe disks are added to the system, no uevent containing the
> DISK_RO property is generated. As a result, dm-* nodes backed by
> readonly NVMe disks will not have their RO state set properly. The
> result looks like this:
> 
> $ multipath -l
> eui.00c92c091fd6564424a9376600011bd1 dm-3 NVME,Pure Storage FlashArray
> size=1.0T features='0' hwhandler='0' wp=rw
> |-+- policy='service-time 0' prio=0 status=active
> | `- 0:2:2:72657 nvme0n2 259:4 active undef running
> `-+- policy='service-time 0' prio=0 status=enabled
>   `- 1:0:2:72657 nvme1n2 259:1 active undef running
> $ cat /sys/block/dm-3/ro
> 0
> $ cat /sys/block/nvme*n2/ro
> 1
> 1
> 
> This is not a problem for SCSI disks, since the kernel will emit change
> uevents containing the DISK_RO property when the disk is added to the
> system. See the following thread for my initial attempt to fix this
> issue at the kernel level:
> https://lore.kernel.org/linux-block/Yib8GqCA5e3SQYty@infradead.org/T/#t
> 
> Fix the issue by picking up the path ro state from sysfs in ev_add_path,
> setting the mpp->force_readonly accordingly, and changing
> dm_addmap_create to be aware of mpp->force_readonly.
> 
> Signed-off-by: Uday Shankar <ushankar@purestorage.com>

Reviewed-by: Benjamin Marzinski <bmarzins@redhat.com>

> ---
>  libmultipath/devmapper.c |  2 +-
>  multipathd/main.c        | 50 ++++++++++++++++++++++------------------
>  2 files changed, 29 insertions(+), 23 deletions(-)
> 
> diff --git a/libmultipath/devmapper.c b/libmultipath/devmapper.c
> index 2507f77f..9819e29b 100644
> --- a/libmultipath/devmapper.c
> +++ b/libmultipath/devmapper.c
> @@ -540,7 +540,7 @@ int dm_addmap_create (struct multipath *mpp, char * params)
>  	int ro;
>  	uint16_t udev_flags = build_udev_flags(mpp, 0);
>  
> -	for (ro = 0; ro <= 1; ro++) {
> +	for (ro = mpp->force_readonly ? 1 : 0; ro <= 1; ro++) {
>  		int err;
>  
>  		if (dm_addmap(DM_DEVICE_CREATE, TGT_MPATH, mpp, params, ro,
> diff --git a/multipathd/main.c b/multipathd/main.c
> index f2c0b280..a67865df 100644
> --- a/multipathd/main.c
> +++ b/multipathd/main.c
> @@ -1130,6 +1130,28 @@ out:
>  	return ret;
>  }
>  
> +static int
> +sysfs_get_ro (struct path *pp)
> +{
> +	int ro;
> +	char buff[3]; /* Either "0\n\0" or "1\n\0" */
> +
> +	if (!pp->udev)
> +		return -1;
> +
> +	if (sysfs_attr_get_value(pp->udev, "ro", buff, sizeof(buff)) <= 0) {
> +		condlog(3, "%s: Cannot read ro attribute in sysfs", pp->dev);
> +		return -1;
> +	}
> +
> +	if (sscanf(buff, "%d\n", &ro) != 1 || ro < 0 || ro > 1) {
> +		condlog(3, "%s: Cannot parse ro attribute", pp->dev);
> +		return -1;
> +	}
> +
> +	return ro;
> +}
> +
>  /*
>   * returns:
>   * 0: added
> @@ -1143,6 +1165,7 @@ ev_add_path (struct path * pp, struct vectors * vecs, int need_do_map)
>  	int retries = 3;
>  	int start_waiter = 0;
>  	int ret;
> +	int ro;
>  
>  	/*
>  	 * need path UID to go any further
> @@ -1207,6 +1230,11 @@ rescan:
>  	/* persistent reservation check*/
>  	mpath_pr_event_handle(pp);
>  
> +	/* ro check - if new path is ro, force map to be ro as well */
> +	ro = sysfs_get_ro(pp);
> +	if (ro == 1)
> +		mpp->force_readonly = 1;
> +
>  	if (!need_do_map)
>  		return 0;
>  
> @@ -1446,28 +1474,6 @@ finish_path_init(struct path *pp, struct vectors * vecs)
>  	return -1;
>  }
>  
> -static int
> -sysfs_get_ro (struct path *pp)
> -{
> -	int ro;
> -	char buff[3]; /* Either "0\n\0" or "1\n\0" */
> -
> -	if (!pp->udev)
> -		return -1;
> -
> -	if (sysfs_attr_get_value(pp->udev, "ro", buff, sizeof(buff)) <= 0) {
> -		condlog(3, "%s: Cannot read ro attribute in sysfs", pp->dev);
> -		return -1;
> -	}
> -
> -	if (sscanf(buff, "%d\n", &ro) != 1 || ro < 0 || ro > 1) {
> -		condlog(3, "%s: Cannot parse ro attribute", pp->dev);
> -		return -1;
> -	}
> -
> -	return ro;
> -}
> -
>  static bool
>  needs_ro_update(struct multipath *mpp, int ro)
>  {
> -- 
> 2.25.1
> 
> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://listman.redhat.com/mailman/listinfo/dm-devel
--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

