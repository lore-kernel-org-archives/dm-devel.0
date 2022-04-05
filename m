Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 92AC7C433F5
	for <dm-devel@archiver.kernel.org>; Tue,  5 Apr 2022 15:50:53 +0000 (UTC)
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-92-u9u_AgHRNcKAloy7HnDpQQ-1; Tue, 05 Apr 2022 11:50:51 -0400
X-MC-Unique: u9u_AgHRNcKAloy7HnDpQQ-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 3B72D811E75;
	Tue,  5 Apr 2022 15:50:49 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id D1BE842B94A;
	Tue,  5 Apr 2022 15:50:45 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 899B21940369;
	Tue,  5 Apr 2022 15:50:45 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com
 [10.11.54.8])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id C2E161947BBD
 for <dm-devel@listman.corp.redhat.com>; Tue,  5 Apr 2022 15:50:43 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 8F943C54181; Tue,  5 Apr 2022 15:50:43 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast01.extmail.prod.ext.rdu2.redhat.com [10.11.55.17])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 8B4A5C54180
 for <dm-devel@redhat.com>; Tue,  5 Apr 2022 15:50:43 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [205.139.110.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 72D3F899EC1
 for <dm-devel@redhat.com>; Tue,  5 Apr 2022 15:50:43 +0000 (UTC)
Received: from mail-qt1-f175.google.com (mail-qt1-f175.google.com
 [209.85.160.175]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-290-qAJf9WrjMD-tIgUf0l6y8g-1; Tue, 05 Apr 2022 11:50:42 -0400
X-MC-Unique: qAJf9WrjMD-tIgUf0l6y8g-1
Received: by mail-qt1-f175.google.com with SMTP id j21so11798374qta.0
 for <dm-devel@redhat.com>; Tue, 05 Apr 2022 08:50:41 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=v+fdSoVNNjnUGmCkMRGF7bz1AtuvXBZQ7NRsX5hjdRI=;
 b=Iie1XNJxpqMOPHGnbjsMyq70PgoV3R2uMCUCeA1wwTTXPuzJtvbryHgu/NXvZ+Nw4e
 skM2cQgAvoHet0Ok9qHjOPjrqeeKFt6glM9FlTD5pL8ZkUUeKA0YPywjMxS+MnuVeUFB
 3ggsj3b8tEuEDpjmTICqP3PqNLSHUyamZ2UAQI9eD/NNbbNeRe6+mMYEXpKeAQ+X+RqX
 /iQsOxT0PxukQJP/5oDI1w22ZbOfZbQWilTAGMjSM3LZcPfrqTzK4IYwUKjQufuYxeVR
 YJ2W/Sy3zkRlnWip4T3j6kagiv8QoqwHaGq4WH0vcKbHpXwxpWVjl/pI0INcevgFoJMB
 CzOA==
X-Gm-Message-State: AOAM530VALQiU7y7xRE7kEEAQ+flk0W4r1oLTc0YXSQ7PAyumBR965Ft
 3KvQt7uP7GB61JuuiRqRsgBiC1Q=
X-Google-Smtp-Source: ABdhPJzKzm30OD+0rRZKNl7Nej0zc6frKnnX46QEawCBiKw/KCb8ayvLrIXfjw+ycf+lOxvjqpd0gA==
X-Received: by 2002:ac8:5b50:0:b0:2eb:8756:d7c1 with SMTP id
 n16-20020ac85b50000000b002eb8756d7c1mr3615358qtw.378.1649173841365; 
 Tue, 05 Apr 2022 08:50:41 -0700 (PDT)
Received: from localhost (pool-68-160-176-52.bstnma.fios.verizon.net.
 [68.160.176.52]) by smtp.gmail.com with ESMTPSA id
 de8-20020a05620a370800b0067ec34c9f27sm8282351qkb.129.2022.04.05.08.50.40
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Tue, 05 Apr 2022 08:50:40 -0700 (PDT)
Date: Tue, 5 Apr 2022 11:50:39 -0400
From: Mike Snitzer <snitzer@kernel.org>
To: Michael Trimarchi <michael@amarulasolutions.com>
Message-ID: <YkxlTyMFNNdBqFRd@redhat.com>
References: <20220401220705.82077-1-michael@amarulasolutions.com>
MIME-Version: 1.0
In-Reply-To: <20220401220705.82077-1-michael@amarulasolutions.com>
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.8
Subject: Re: [dm-devel] [RFC PATCH] md: dm-init: Wait devices if it's not
 find on first adpet
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
Cc: Fabio Aiuto <fabio.aiuto@amarulasolutions.com>, dm-devel@redhat.com,
 linux-kernel@vger.kernel.org, Alasdair Kergon <agk@redhat.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.9
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Fri, Apr 01 2022 at  6:07P -0400,
Michael Trimarchi <michael@amarulasolutions.com> wrote:

> The device driver can be deferrable and can be a race during
> the dm-init early. We need to wait all the probe are really finished
> in a loop as is done in do_mounts. This is was tested on kernel 5.4
> but code seems was not changed since that time
> 
> 003: imx8mq-usb-phy 381f0040.usb-phy: 381f0040.usb-phy supply vbus not found, using dummy regulator
> 003: imx8mq-usb-phy 382f0040.usb-phy: 382f0040.usb-phy supply vbus not found, using dummy regulator
> 003: imx-cpufreq-dt imx-cpufreq-dt: cpu speed grade 5 mkt segment 0 supported-hw 0x20 0x1
> 003: caam-dma caam-dma: caam dma support with 2 job rings
> 000: hctosys: unable to open rtc device (rtc0)
> 000: device-mapper: init: waiting for all devices to be available before creating mapped devices
> 002: device-mapper: table: 254:0: verity: Data device lookup failed
> 002: device-mapper: ioctl: error adding target to table
> 002: crng init done
> 003: of_cfs_init
> 003: of_cfs_init: OK
> 003: Waiting for root device /dev/dm-0...
> 001: mmc2: new HS400 Enhanced strobe MMC card at address 0001
> 001: mmcblk2: mmc2:0001 IB2916 14.6 GiB
> 001: mmcblk2boot0: mmc2:0001 IB2916 partition 1 4.00 MiB
> 001: mmcblk2boot1: mmc2:0001 IB2916 partition 2 4.00 MiB
> 001: mmcblk2rpmb: mmc2:0001 IB2916 partition 3 4.00 MiB, chardev (249:0)
> 001:  mmcblk2: p1 p2 p3 p4 p5 p6 p7 p8 p9 p10 p11
> 001: VSD_3V3: disabling
> 
> with the patch
> 
> 003: device-mapper: init: waiting for all devices to be available before creating mapped devices
> 
> 000: device-mapper: table: 254:0: verity: Data device lookup failed
> 000: device-mapper: ioctl: error adding target to table
> 002: crng init done
> 003: device-mapper: init: waiting for all devices to be available before creating mapped devices
> 003: device-mapper: table: 254:0: verity: Data device lookup failed
> 003: device-mapper: ioctl: error adding target to table
> 003: device-mapper: init: waiting for all devices to be available before creating mapped devices
> 000: device-mapper: table: 254:0: verity: Data device lookup failed
> 000: device-mapper: ioctl: error adding target to table
> 002: device-mapper: init: waiting for all devices to be available before creating mapped devices
> 002: device-mapper: table: 254:0: verity: Data device lookup failed
> 002: device-mapper: ioctl: error adding target to table
> 000: device-mapper: init: waiting for all devices to be available before creating mapped devices
> 000: device-mapper: table: 254:0: verity: Data device lookup failed
> 000: device-mapper: ioctl: error adding target to table
> 003: mmc2: new HS400 Enhanced strobe MMC card at address 0001
> 003: mmcblk2: mmc2:0001 DG4016 14.7 GiB
> 003: mmcblk2boot0: mmc2:0001 DG4016 partition 1 4.00 MiB
> 003: mmcblk2boot1: mmc2:0001 DG4016 partition 2 4.00 MiB
> 003: mmcblk2rpmb: mmc2:0001 DG4016 partition 3 4.00 MiB, chardev (249:0)
> 003:  mmcblk2: p1 p2 p3 p4 p5 p6 p7 p8 p9 p10 p11
> 002: device-mapper: init: waiting for all devices to be available before creating mapped devices
> 003: device-mapper: verity: sha256 using implementation "sha256-caam"
> 000: device-mapper: ioctl: dm-0 (rootfs) is ready
> 
> Signed-off-by: Michael Trimarchi <michael@amarulasolutions.com>
> ---
>  drivers/md/dm-init.c | 15 ++++++++++++++-
>  1 file changed, 14 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/md/dm-init.c b/drivers/md/dm-init.c
> index b0c45c6ebe0b..d3b754036484 100644
> --- a/drivers/md/dm-init.c
> +++ b/drivers/md/dm-init.c
> @@ -7,7 +7,9 @@
>   * This file is released under the GPLv2.
>   */
>  
> +#include <linux/async.h>
>  #include <linux/ctype.h>
> +#include <linux/delay.h>
>  #include <linux/device.h>
>  #include <linux/device-mapper.h>
>  #include <linux/init.h>
> @@ -267,6 +269,7 @@ static int __init dm_init_init(void)
>  	LIST_HEAD(devices);
>  	char *str;
>  	int r;
> +	bool fail = false;
>  
>  	if (!create)
>  		return 0;
> @@ -275,6 +278,7 @@ static int __init dm_init_init(void)
>  		DMERR("Argument is too big. Limit is %d", DM_MAX_STR_SIZE);
>  		return -EINVAL;
>  	}
> +retry:
>  	str = kstrndup(create, DM_MAX_STR_SIZE, GFP_KERNEL);
>  	if (!str)
>  		return -ENOMEM;
> @@ -288,12 +292,21 @@ static int __init dm_init_init(void)
>  
>  	list_for_each_entry(dev, &devices, list) {
>  		if (dm_early_create(&dev->dmi, dev->table,
> -				    dev->target_args_array))
> +				    dev->target_args_array)) {
> +			fail = true;
>  			break;
> +		}
>  	}
> +
>  out:
>  	kfree(str);
>  	dm_setup_cleanup(&devices);
> +	if (fail) {
> +		msleep(5);
> +		fail = false;
> +		goto retry;
> +	}
> +
>  	return r;
>  }
>  
> -- 
> 2.25.1
> 

I'm cannot take this as proposed.

If you're going to do something like this, the retries need to be
bounded. And retry should only be possible for select cases
(e.g. "verity: Data device lookup failed", which is emitted due to
dm_get_device failure with a return -ENODEV).

So please narrow this as much as possible (by only allowing retry if
-ENODEV) and bound the retries to a finite amount.. 5? 10? 20? *shrug*

And please take care to use variable names that are more appropriate
("fail" is not one of them when you're writing retry code)

Mike

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

