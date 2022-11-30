Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E933AC4321E
	for <dm-devel@archiver.kernel.org>; Wed, 30 Nov 2022 23:35:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1669851344;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=URWxqaP+oS7b6l5FfjQE2U4j3AM64f7C/gN1N41UC8g=;
	b=aCLbOuIdz3rORrWnAMEHJTMDZCQxfMFNlom44sEXvjJQw4T/o1aq8LkVQ5v16jPBrJBdkw
	zaC10nKZgB3Vs1SCz1OenKecZ/JgVK8g0WLtbfk64COjezW8kW+b9d34hA8gaEx9RqJ982
	NFYwMacDYcLDSFOPHLYdiQb05T56ojA=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-108-mdtAgPjfNXOMjPW3TaT--w-1; Wed, 30 Nov 2022 18:35:41 -0500
X-MC-Unique: mdtAgPjfNXOMjPW3TaT--w-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 236041C05AE5;
	Wed, 30 Nov 2022 23:35:40 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id C3867C15E76;
	Wed, 30 Nov 2022 23:35:37 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id BB90C19465A0;
	Wed, 30 Nov 2022 23:35:24 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com
 [10.11.54.3])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id CBB791946586
 for <dm-devel@listman.corp.redhat.com>; Wed, 30 Nov 2022 23:07:50 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 9FE83111F3B6; Wed, 30 Nov 2022 23:07:50 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast03.extmail.prod.ext.rdu2.redhat.com [10.11.55.19])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 981861120AC2
 for <dm-devel@redhat.com>; Wed, 30 Nov 2022 23:07:50 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [207.211.31.81])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 77B09811E67
 for <dm-devel@redhat.com>; Wed, 30 Nov 2022 23:07:50 +0000 (UTC)
Received: from mail-qk1-f200.google.com (mail-qk1-f200.google.com
 [209.85.222.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-531-DEGcQb_jOiaLEFobWNCMaw-1; Wed, 30 Nov 2022 18:07:49 -0500
X-MC-Unique: DEGcQb_jOiaLEFobWNCMaw-1
Received: by mail-qk1-f200.google.com with SMTP id
 f13-20020a05620a408d00b006fc740f837eso31788264qko.20
 for <dm-devel@redhat.com>; Wed, 30 Nov 2022 15:07:49 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=in-reply-to:content-disposition:mime-version:references:message-id
 :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
 :message-id:reply-to;
 bh=pwSDViD7kRlHlSAJwoUShvXDQ4sk/sbujs+3EAqNGJY=;
 b=D+Vsetv6vj36zC24NAnT0ycnh7CKSo3fOkkjU5XEtbDn6qSbFV6otXekOVALjhIcgs
 fen0Ajs6BVF9l3pA7SX5StAT7i4y/LqS3HQrKj6Z5j214J/SH5rI6NUEGr9MwZZsikBZ
 2uoxHmKR44RNtV8DaXraVGkHqD1OVoifaW17/nekL7O3rVeqpmd6i0xDx+1J2JL5xcd8
 zTV12x6TkqIuOucdT7TEVyuEE+d3/qS5qiIDyW4tZ0B7O6Xt0byY+UR4ZbTH4esbejxb
 1JHELQIi9dML8UhYUGXKQGX5AM97sTJEg/uDrPUo3R6rZp7HUaxM/l4bFpAdMNO+iLBL
 zugA==
X-Gm-Message-State: ANoB5plCN8ZX0+aTzfLURmL3jKQ+FrieJBom1O/T7vpmorx/AALGEnrI
 Hw8zcmYOiBrdbl5c9omBGm1iWSSB3BvujHmkFrOG/q9JI4QseQf3giJGV71A9c9ymy7oMFBwdTI
 Z+S3qlFkqKs+nVQ==
X-Received: by 2002:ac8:444a:0:b0:3a6:8d96:8373 with SMTP id
 m10-20020ac8444a000000b003a68d968373mr3989916qtn.568.1669849668065; 
 Wed, 30 Nov 2022 15:07:48 -0800 (PST)
X-Google-Smtp-Source: AA0mqf4ok7EHoYfN2Hiybv764QWUaxGtHI2l7Mlgd6FTkTQg0llRmLLuPJyRFGTiAJzh8WPsH7h4/Q==
X-Received: by 2002:ac8:444a:0:b0:3a6:8d96:8373 with SMTP id
 m10-20020ac8444a000000b003a68d968373mr3989891qtn.568.1669849667676; 
 Wed, 30 Nov 2022 15:07:47 -0800 (PST)
Received: from localhost (pool-68-160-173-162.bstnma.fios.verizon.net.
 [68.160.173.162]) by smtp.gmail.com with ESMTPSA id
 q2-20020a05620a2a4200b006fa4cefccd6sm2236666qkp.13.2022.11.30.15.07.46
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Wed, 30 Nov 2022 15:07:47 -0800 (PST)
Date: Wed, 30 Nov 2022 18:07:46 -0500
From: Mike Snitzer <snitzer@redhat.com>
To: Peter Korsgaard <peter@korsgaard.com>
Message-ID: <Y4fiQvg9OOATD5Cv@redhat.com>
References: <20221116061656.2345538-1-peter@korsgaard.com>
 <877czkhc7u.fsf@dell.be.48ers.dk>
MIME-Version: 1.0
In-Reply-To: <877czkhc7u.fsf@dell.be.48ers.dk>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.3
Subject: Re: [dm-devel] [PATCH v2] dm init: add dm-mod.waitfor to wait for
 asynchronously probed block devices
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
Cc: Jonathan Corbet <corbet@lwn.net>, Mike Snitzer <snitzer@kernel.org>,
 dm-devel@redhat.com, fabio.aiuto@amarulasolutions.com,
 Helen Koike <helen.koike@collabora.com>, michael@amarulasolutions.com
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.8
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Thu, Nov 24 2022 at  5:35P -0500,
Peter Korsgaard <peter@korsgaard.com> wrote:

> >>>>> "Peter" == Peter Korsgaard <peter@korsgaard.com> writes:
> 
>  > Just calling wait_for_device_probe() is not enough to ensure that
>  > asynchronously probed block devices are available (E.G.  mmc, usb, ..), so
>  > add a "dm-mod.waitfor=<device1>[,..,<deviceN>]" parameter to get dm-init to
>  > explicitly wait for specific block devices before initializing the tables
>  > with logic similar to the rootwait logic in init/do_mounts.c.
> 
>  > E.G. with dm-verity on mmc with
>  > dm-mod.waitfor="PARTLABEL=hash-a,PARTLABEL=root-a"
> 
>  > [    0.671671] device-mapper: init: waiting for all devices to be available before creating mapped devices
>  > [    0.671679] device-mapper: init: waiting for PARTLABEL=hash-a
>  > [    0.710695] mmc0: new HS200 MMC card at address 0001
>  > [    0.711158] mmcblk0: mmc0:0001 004GA0 3.69 GiB
>  > [    0.715954] mmcblk0boot0: mmc0:0001 004GA0 partition 1 2.00 MiB
>  > [    0.722085] mmcblk0boot1: mmc0:0001 004GA0 partition 2 2.00 MiB
>  > [    0.728093] mmcblk0rpmb: mmc0:0001 004GA0 partition 3 512 KiB, chardev (249:0)
>  > [    0.738274]  mmcblk0: p1 p2 p3 p4 p5 p6 p7
>  > [    0.751282] device-mapper: init: waiting for PARTLABEL=root-a
>  > [    0.751306] device-mapper: init: all devices available
>  > [    0.751683] device-mapper: verity: sha256 using implementation "sha256-generic"
>  > [    0.759344] device-mapper: ioctl: dm-0 (vroot) is ready
>  > [    0.766540] VFS: Mounted root (squashfs filesystem) readonly on device 254:0.
> 
>  > Signed-off-by: Peter Korsgaard <peter@korsgaard.com>
>  > ---
>  > Changes since v1:
>  > - Fix s/dm-init/dm-mod/ typo in documentation, drop trailing newline
> 
> Ping?
> 
> FYI: I was recently made aware that other patches fixing this issue
> (but less nice, E.G. with a fixed delay) have been posted in the past,
> so there seems to be a general need for something like this.
> 
> E.G:
> https://lore.kernel.org/all/20220406154631.277107-1-fabio.aiuto@amarulasolutions.com/
> 
> 
> 
>  >  .../admin-guide/device-mapper/dm-init.rst     |  8 +++++++
>  >  drivers/md/dm-init.c                          | 23 ++++++++++++++++++-
>  >  2 files changed, 30 insertions(+), 1 deletion(-)
> 
>  > diff --git a/Documentation/admin-guide/device-mapper/dm-init.rst b/Documentation/admin-guide/device-mapper/dm-init.rst
>  > index e5242ff17e9b..981d6a907699 100644
>  > --- a/Documentation/admin-guide/device-mapper/dm-init.rst
>  > +++ b/Documentation/admin-guide/device-mapper/dm-init.rst
>  > @@ -123,3 +123,11 @@ Other examples (per target):
>  >      0 1638400 verity 1 8:1 8:2 4096 4096 204800 1 sha256
>  >      fb1a5a0f00deb908d8b53cb270858975e76cf64105d412ce764225d53b8f3cfd
>  >      51934789604d1b92399c52e7cb149d1b3a1b74bbbcb103b2a0aaacbed5c08584
>  > +
>  > +For setups using device-mapper on top of asynchronously probed block
>  > +devices (MMC, USB, ..), it may be necessary to tell dm-init to
>  > +explicitly wait for them to become available before setting up the
>  > +device-mapper tables. This can be done with the "dm-mod.waitfor="
>  > +module parameter, which takes a list of devices to wait for::
>  > +
>  > +  dm-mod.waitfor=<device1>[,..,<deviceN>]
>  > diff --git a/drivers/md/dm-init.c b/drivers/md/dm-init.c
>  > index b0c45c6ebe0b..fc70b568e072 100644
>  > --- a/drivers/md/dm-init.c
>  > +++ b/drivers/md/dm-init.c
>  > @@ -8,6 +8,7 @@
>  >   */
>  
>  >  #include <linux/ctype.h>
>  > +#include <linux/delay.h>
>  >  #include <linux/device.h>
>  >  #include <linux/device-mapper.h>
>  >  #include <linux/init.h>
>  > @@ -18,12 +19,17 @@
>  >  #define DM_MAX_DEVICES 256
>  >  #define DM_MAX_TARGETS 256
>  >  #define DM_MAX_STR_SIZE 4096
>  > +#define DM_MAX_WAITFOR 256
>  
>  >  static char *create;
>  
>  > +static char *waitfor[DM_MAX_WAITFOR];
>  > +
>  >  /*
>  >   * Format: dm-mod.create=<name>,<uuid>,<minor>,<flags>,<table>[,<table>+][;<name>,<uuid>,<minor>,<flags>,<table>[,<table>+]+]
>  >   * Table format: <start_sector> <num_sectors> <target_type> <target_args>
>  > + * Block devices to wait for to become available before setting up tables:
>  > + * dm-mod.waitfor=<device1>[,..,<deviceN>]
>  >   *
>  >   * See Documentation/admin-guide/device-mapper/dm-init.rst for dm-mod.create="..." format
>  >   * details.
>  > @@ -266,7 +272,7 @@ static int __init dm_init_init(void)
>  >  	struct dm_device *dev;
>  >  	LIST_HEAD(devices);
>  >  	char *str;
>  > -	int r;
>  > +	int i, r;
>  
>  >  	if (!create)
>  >  		return 0;
>  > @@ -286,6 +292,18 @@ static int __init dm_init_init(void)
>  >  	DMINFO("waiting for all devices to be available before creating mapped devices");
>  >  	wait_for_device_probe();
>  
>  > +	for (i = 0; i < ARRAY_SIZE(waitfor); i++) {
>  > +		if (waitfor[i]) {
>  > +			DMINFO("waiting for %s", waitfor[i]);
>  > +
>  > +			while (!dm_get_dev_t(waitfor[i]))
>  > +				msleep(20);
>  > +		}
>  > +	}
>  > +
>  > +	if (waitfor[0])
>  > +		DMINFO("all devices available");
>  > +

Why 20?  Also, why is waiting indefinitely OK?  Would really like to
hear from other consumers of dm-init that this module param is useful
and needed.

Mike


>  >  	list_for_each_entry(dev, &devices, list) {
>  >  		if (dm_early_create(&dev->dmi, dev->table,
>  dev-> target_args_array))
>  > @@ -301,3 +319,6 @@ late_initcall(dm_init_init);
>  
>  >  module_param(create, charp, 0);
>  >  MODULE_PARM_DESC(create, "Create a mapped device in early boot");
>  > +
>  > +module_param_array(waitfor, charp, NULL, 0);
>  > +MODULE_PARM_DESC(waitfor, "Devices to wait for before setting up tables");
>  > -- 
> 
>  > 2.30.2
> 
> 
> -- 
> Bye, Peter Korsgaard
> 


--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

