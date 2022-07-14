Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 69ADFC433EF
	for <dm-devel@archiver.kernel.org>; Thu, 14 Jul 2022 20:13:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1657829635;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=y1EPh5APc40mypHZEXYueO/1hChxcuOwQA2vv8OPAK0=;
	b=aJ14YeaKT7wehJxxKrU5LqCh6sIc7gQN4mT0p0mBw2zIX42nQ1/QKwEsvn07vj45pakrYf
	y+DOy1I1drH52mKCrphTNskFIF2K/1+ipDzKkvaSCxrDk+naiung+qM0mvGY76vxH49BWL
	KVcGB72aBiFH1C3SxttbWy3QlDWr94c=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-440-krSAe688Nqqp6gsTnvakzw-1; Thu, 14 Jul 2022 16:13:46 -0400
X-MC-Unique: krSAe688Nqqp6gsTnvakzw-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 0DBDC101A58E;
	Thu, 14 Jul 2022 20:13:44 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 74BDA2166B26;
	Thu, 14 Jul 2022 20:13:42 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 517F9194706D;
	Thu, 14 Jul 2022 20:13:42 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com
 [10.11.54.3])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 97BE51947042
 for <dm-devel@listman.corp.redhat.com>; Thu, 14 Jul 2022 20:13:40 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 85D961121319; Thu, 14 Jul 2022 20:13:40 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast08.extmail.prod.ext.rdu2.redhat.com [10.11.55.24])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 815EA1121314
 for <dm-devel@redhat.com>; Thu, 14 Jul 2022 20:13:40 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [205.139.110.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 6555F38041D2
 for <dm-devel@redhat.com>; Thu, 14 Jul 2022 20:13:40 +0000 (UTC)
Received: from mail-qk1-f171.google.com (mail-qk1-f171.google.com
 [209.85.222.171]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-230-ZFWsuLJJP5aRVq_HoO295g-1; Thu, 14 Jul 2022 16:13:33 -0400
X-MC-Unique: ZFWsuLJJP5aRVq_HoO295g-1
Received: by mail-qk1-f171.google.com with SMTP id v28so531080qkg.13
 for <dm-devel@redhat.com>; Thu, 14 Jul 2022 13:13:26 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=QIFnewSJO5RPRbFfQGBESkxwcHJHTZrd3ulxj1Uol1U=;
 b=qkN30Y6ZxYobTXFPJSmpcw+VMgLC29WhDW4aJjUjKlnjyc1GSxBMsfWdxol5T+0h2I
 eweWeEdOuoCEdAHHlEMacJ2EISh68cVDO58BNLhS+lcm8YatrGZGcDxeOFYscisMK25M
 DzVy51fwx/Ub5z7Wd4OeVH+VwTULM6nJ72XN2Rce2H63sBTkOj4+WN+u0hbOBF7XHdph
 bT43AzTYtlS0+i7nCOFjhmOBnt+Pdj0RLccCwjNwect+roJaSWczQID3yEyvYFvdHSnk
 mNf8NsIwBpvUvm2EA77vAE1XHuuGTKFzXR0ocRqRjPTQi+nTUSgXSP5Wv9h0+kI2kh6Y
 GXBA==
X-Gm-Message-State: AJIora9hvBYtlvxUj1isDq2x9AhJG4SfbSqNvE2sihJXc0ApE1Hr7isO
 iXR/VNSB5RxhkBCSsZn0DXz3ZFI=
X-Google-Smtp-Source: AGRyM1szLUsAmGiDNl1c+GrlTpqZOEE+Fxs3qZG9HecTAWZ2su5al2HKJq3yE3EQOyzVrXdCf/lseQ==
X-Received: by 2002:a05:620a:2724:b0:6b5:cd4d:c6e8 with SMTP id
 b36-20020a05620a272400b006b5cd4dc6e8mr350262qkp.116.1657829606439; 
 Thu, 14 Jul 2022 13:13:26 -0700 (PDT)
Received: from localhost (pool-68-160-176-52.bstnma.fios.verizon.net.
 [68.160.176.52]) by smtp.gmail.com with ESMTPSA id
 u12-20020a05620a0c4c00b006a6ebde4799sm2186001qki.90.2022.07.14.13.13.25
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Thu, 14 Jul 2022 13:13:25 -0700 (PDT)
Date: Thu, 14 Jul 2022 16:13:24 -0400
From: Mike Snitzer <snitzer@kernel.org>
To: Daniil Lunev <dlunev@chromium.org>
Message-ID: <YtB45Lte5UhlEE6y@redhat.com>
References: <20220704000225.345536-1-dlunev@chromium.org>
 <20220704100221.1.I15b3f7a84ba5a97fde9276648e391b54957103ff@changeid>
MIME-Version: 1.0
In-Reply-To: <20220704100221.1.I15b3f7a84ba5a97fde9276648e391b54957103ff@changeid>
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.3
Subject: Re: [dm-devel] [PATCH 1/1] dm: add message command to disallow
 device open
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
Cc: dm-devel@redhat.com, Brian Geffon <bgeffon@google.com>,
 Alasdair Kergon <agk@redhat.com>, linux-kernel@vger.kernel.org
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.6
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Sun, Jul 03 2022 at  8:02P -0400,
Daniil Lunev <dlunev@chromium.org> wrote:

> A message can be passed to device mapper to prohibit open on a certain
> mapped device. This makes possible to disallow userspace access to
> raw swapped data if the system uses device mapper to encrypt it at rest.
> 
> Signed-off-by: Daniil Lunev <dlunev@chromium.org>

This commit header and patch make little sense to me.

If you're concerned about a normal (non-root) user having read access
to the swap device then disallow non-root user access permissions on
the swap device.

Why is an encrypted swap device any different than any other encrypted
device?

As is, this patch seems to be the wrong way to achieve your desired
result.  If you or someone else on the chromium team can better
defend/explain the need for this change please do so.

Thanks,
Mike


> ---
> 
>  drivers/md/dm-core.h          |  1 +
>  drivers/md/dm-ioctl.c         | 10 ++++++++++
>  drivers/md/dm.c               | 12 ++++++++++++
>  drivers/md/dm.h               | 10 ++++++++++
>  include/uapi/linux/dm-ioctl.h |  5 +++++
>  5 files changed, 38 insertions(+)
> 
> diff --git a/drivers/md/dm-core.h b/drivers/md/dm-core.h
> index 4277853c75351..37529b605b7c4 100644
> --- a/drivers/md/dm-core.h
> +++ b/drivers/md/dm-core.h
> @@ -140,6 +140,7 @@ struct mapped_device {
>  #define DMF_SUSPENDED_INTERNALLY 7
>  #define DMF_POST_SUSPENDING 8
>  #define DMF_EMULATE_ZONE_APPEND 9
> +#define DMF_DISALLOW_OPEN 10
>  
>  void disable_discard(struct mapped_device *md);
>  void disable_write_zeroes(struct mapped_device *md);
> diff --git a/drivers/md/dm-ioctl.c b/drivers/md/dm-ioctl.c
> index 87310fceb0d86..e35d560aa2ff3 100644
> --- a/drivers/md/dm-ioctl.c
> +++ b/drivers/md/dm-ioctl.c
> @@ -815,6 +815,9 @@ static void __dev_status(struct mapped_device *md, struct dm_ioctl *param)
>  	if (dm_test_deferred_remove_flag(md))
>  		param->flags |= DM_DEFERRED_REMOVE;
>  
> +	if (dm_test_disallow_open_flag(md))
> +		param->flags |= DM_DISALLOWED_OPEN;
> +
>  	param->dev = huge_encode_dev(disk_devt(disk));
>  
>  	/*
> @@ -1656,6 +1659,13 @@ static int message_for_md(struct mapped_device *md, unsigned argc, char **argv,
>  		}
>  		return dm_cancel_deferred_remove(md);
>  	}
> +	if (!strcasecmp(argv[0], "@disallow_open")) {
> +		if (argc != 1) {
> +			DMERR("Invalid arguments for @disallow_open");
> +			return -EINVAL;
> +		}
> +		return dm_disallow_open(md);
> +	}
>  
>  	r = dm_stats_message(md, argc, argv, result, maxlen);
>  	if (r < 2)
> diff --git a/drivers/md/dm.c b/drivers/md/dm.c
> index 82957bd460e89..3e53d1bd40f0c 100644
> --- a/drivers/md/dm.c
> +++ b/drivers/md/dm.c
> @@ -327,6 +327,7 @@ static int dm_blk_open(struct block_device *bdev, fmode_t mode)
>  		goto out;
>  
>  	if (test_bit(DMF_FREEING, &md->flags) ||
> +	    test_bit(DMF_DISALLOW_OPEN, &md->flags) ||
>  	    dm_deleting_md(md)) {
>  		md = NULL;
>  		goto out;
> @@ -403,6 +404,12 @@ int dm_cancel_deferred_remove(struct mapped_device *md)
>  	return r;
>  }
>  
> +int dm_disallow_open(struct mapped_device *md)
> +{
> +	set_bit(DMF_DISALLOW_OPEN, &md->flags);
> +	return 0;
> +}
> +
>  static void do_deferred_remove(struct work_struct *w)
>  {
>  	dm_deferred_remove();
> @@ -2883,6 +2890,11 @@ int dm_test_deferred_remove_flag(struct mapped_device *md)
>  	return test_bit(DMF_DEFERRED_REMOVE, &md->flags);
>  }
>  
> +int dm_test_disallow_open_flag(struct mapped_device *md)
> +{
> +	return test_bit(DMF_DISALLOW_OPEN, &md->flags);
> +}
> +
>  int dm_suspended(struct dm_target *ti)
>  {
>  	return dm_suspended_md(ti->table->md);
> diff --git a/drivers/md/dm.h b/drivers/md/dm.h
> index 9013dc1a7b002..da27f9dfe1413 100644
> --- a/drivers/md/dm.h
> +++ b/drivers/md/dm.h
> @@ -163,6 +163,16 @@ int dm_test_deferred_remove_flag(struct mapped_device *md);
>   */
>  void dm_deferred_remove(void);
>  
> +/*
> + * Test if the device is openable.
> + */
> +int dm_test_disallow_open_flag(struct mapped_device *md);
> +
> +/*
> + * Prevent new open request on the device.
> + */
> +int dm_disallow_open(struct mapped_device *md);
> +
>  /*
>   * The device-mapper can be driven through one of two interfaces;
>   * ioctl or filesystem, depending which patch you have applied.
> diff --git a/include/uapi/linux/dm-ioctl.h b/include/uapi/linux/dm-ioctl.h
> index 2e9550fef90fa..3b4d12d09c005 100644
> --- a/include/uapi/linux/dm-ioctl.h
> +++ b/include/uapi/linux/dm-ioctl.h
> @@ -382,4 +382,9 @@ enum {
>   */
>  #define DM_IMA_MEASUREMENT_FLAG	(1 << 19) /* In */
>  
> +/*
> + * If set, the device can not be opened.
> + */
> +#define DM_DISALLOWED_OPEN	(1 << 20) /* Out */
> +
>  #endif				/* _LINUX_DM_IOCTL_H */
> -- 
> 2.31.0
> 

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

