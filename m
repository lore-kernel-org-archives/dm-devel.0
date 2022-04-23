Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2DE95C433EF
	for <dm-devel@archiver.kernel.org>; Mon, 25 Apr 2022 05:54:55 +0000 (UTC)
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-287-1hvJgWP3MCa0wi5O-pd4tQ-1; Mon, 25 Apr 2022 01:54:50 -0400
X-MC-Unique: 1hvJgWP3MCa0wi5O-pd4tQ-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 7D38D1C05154;
	Mon, 25 Apr 2022 05:54:48 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id C7F16C27EA2;
	Mon, 25 Apr 2022 05:54:45 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 3ABDA1949762;
	Mon, 25 Apr 2022 05:54:45 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com
 [10.11.54.1])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id C6D6119466DF
 for <dm-devel@listman.corp.redhat.com>; Sat, 23 Apr 2022 08:14:13 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 98B6D40D017E; Sat, 23 Apr 2022 08:14:13 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast04.extmail.prod.ext.rdu2.redhat.com [10.11.55.20])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 940DD40D017A
 for <dm-devel@redhat.com>; Sat, 23 Apr 2022 08:14:13 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [205.139.110.61])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 7B6A2101AA42
 for <dm-devel@redhat.com>; Sat, 23 Apr 2022 08:14:13 +0000 (UTC)
Received: from mail-pl1-f172.google.com (mail-pl1-f172.google.com
 [209.85.214.172]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-302-FLMFBelOOXuSTTk_Q1GpMw-1; Sat, 23 Apr 2022 04:14:11 -0400
X-MC-Unique: FLMFBelOOXuSTTk_Q1GpMw-1
Received: by mail-pl1-f172.google.com with SMTP id k4so4236554plk.7
 for <dm-devel@redhat.com>; Sat, 23 Apr 2022 01:14:11 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc;
 bh=9tEABhHPLdbb/U7q9ZbhGXPyRjuxdRV60qM4AkqCbUw=;
 b=vcpQ+ph9+jJjDqpxAMcWHyW/5ITHsg4UYKdBrFFDWp0PiuNulq4/OtJt2PiwI03fh/
 J0cYWVApcXqfHxXP+LbMgDTcifTCHguXbqiwkiUdYiTKHg5MUNlg4aglnTLXUB6A7So2
 p91NgyzmLev+GsJq7/j87OKqDoM7g40ddAjHAQsIXHp2Oy/PbPNiBvQlu2MsFFqN47Ka
 UlQ4xjb6vkBwcrKS2PnJkco7c8zKxx4G6Ywe4qdR3NqSvyFp2rQaIOkp4Jcy6BCpc7h9
 zzvQMATIkZFmbRNrxkm2RCHECwqq7SwnaAzJwd9cKyBISRbU4X6jOd9Si43QvU7Xp2yV
 0NKA==
X-Gm-Message-State: AOAM533nBF6SYGlMNEhR1/nCVW93HBmRHX3ZJNgELbR5SlPaoRb1A6xu
 PSVzRP9dcZbZNnaKd9v+NHiTkm2Xhi7R/vcTrAceBw==
X-Google-Smtp-Source: ABdhPJxoch5J7AIZlt4Vw0WAxgGdzG3GmikwsJhG7Cf+opEU4XlyXdl2FNxO9SkpveyvaZkLeZyhGfisnK5byjcAnAQ=
X-Received: by 2002:a17:90a:94c2:b0:1d9:3fbd:bbe1 with SMTP id
 j2-20020a17090a94c200b001d93fbdbbe1mr561231pjw.59.1650701650360; Sat, 23 Apr
 2022 01:14:10 -0700 (PDT)
MIME-Version: 1.0
References: <20220406154631.277107-1-fabio.aiuto@amarulasolutions.com>
In-Reply-To: <20220406154631.277107-1-fabio.aiuto@amarulasolutions.com>
From: Michael Nazzareno Trimarchi <michael@amarulasolutions.com>
Date: Sat, 23 Apr 2022 10:13:59 +0200
Message-ID: <CAOf5uwnHq1kMa+qDsieLUt_QRVr7-q5B7jvC2owYJjgU1wZL9Q@mail.gmail.com>
To: Fabio Aiuto <fabio.aiuto@amarulasolutions.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.1
X-Mailman-Approved-At: Mon, 25 Apr 2022 05:54:44 +0000
Subject: Re: [dm-devel] [PATCH v3] md: dm-init: Wait devices if it's not
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
Cc: dm-devel@redhat.com, snitzer@kernel.org, linux-kernel@vger.kernel.org,
 agk@redhat.com
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.8
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Hi all

On Wed, Apr 6, 2022 at 5:46 PM Fabio Aiuto
<fabio.aiuto@amarulasolutions.com> wrote:
>
> From: Michael Trimarchi <michael@amarulasolutions.com>
>
> The device driver can be deferrable and can be a race during
> the dm-init early. We need to wait all the probe are really finished
> in a loop as is done in do_mounts. This is was tested on kernel 5.4
> but code seems was not changed since that time
>

Any follow up?

Michael

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
> Wait loop is limited to 10 at the moment for our use case showed no
> more than 4 loops before successfully find data device.
>
> Signed-off-by: Michael Trimarchi <michael@amarulasolutions.com>
> Signed-off-by: Fabio Aiuto <fabio.aiuto@amarulasolutions.com>
> ---
> Changes from v1:
>         - limit the loop to 10 iterations
>         - change variable names
>         - check only for -ENODEV failures
>
> Changes from v2:
>         - use a limit in seconds (not in retry
>           number)
>         - add a parameter
>         - update docs
>
>  .../admin-guide/device-mapper/dm-init.rst     | 13 +++++++++++
>  drivers/md/dm-init.c                          | 23 +++++++++++++++++--
>  2 files changed, 34 insertions(+), 2 deletions(-)
>
> diff --git a/Documentation/admin-guide/device-mapper/dm-init.rst b/Documentation/admin-guide/device-mapper/dm-init.rst
> index e5242ff17e9b..5c2f2bf1db03 100644
> --- a/Documentation/admin-guide/device-mapper/dm-init.rst
> +++ b/Documentation/admin-guide/device-mapper/dm-init.rst
> @@ -123,3 +123,16 @@ Other examples (per target):
>      0 1638400 verity 1 8:1 8:2 4096 4096 204800 1 sha256
>      fb1a5a0f00deb908d8b53cb270858975e76cf64105d412ce764225d53b8f3cfd
>      51934789604d1b92399c52e7cb149d1b3a1b74bbbcb103b2a0aaacbed5c08584
> +
> +Delay for waiting deferred probes of block devices
> +==================================================
> +
> +Sometimes the late initcall starting the early creation of mapped
> +devices, starts too early. A loop waiting for probing of block
> +devices has been added; the default maximum delay is 1 second but
> +it can be set through the following kernel command::
> +
> +  dm-mod.delay=<seconds>
> +
> +This allows the procedure to retry the creation of a mapped device
> +after a short wait (5 msecs).
> diff --git a/drivers/md/dm-init.c b/drivers/md/dm-init.c
> index b0c45c6ebe0b..f4c5b4a46001 100644
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
> @@ -18,8 +20,10 @@
>  #define DM_MAX_DEVICES 256
>  #define DM_MAX_TARGETS 256
>  #define DM_MAX_STR_SIZE 4096
> +#define DM_DEFAULT_MAX_PROBE_DELAY 1
>
>  static char *create;
> +static int delay = DM_DEFAULT_MAX_PROBE_DELAY;
>
>  /*
>   * Format: dm-mod.create=<name>,<uuid>,<minor>,<flags>,<table>[,<table>+][;<name>,<uuid>,<minor>,<flags>,<table>[,<table>+]+]
> @@ -267,6 +271,8 @@ static int __init dm_init_init(void)
>         LIST_HEAD(devices);
>         char *str;
>         int r;
> +       int loopcnt = delay * 1000 / 5;
> +       bool devnotfound = false;
>
>         if (!create)
>                 return 0;
> @@ -275,6 +281,7 @@ static int __init dm_init_init(void)
>                 DMERR("Argument is too big. Limit is %d", DM_MAX_STR_SIZE);
>                 return -EINVAL;
>         }
> +retry:
>         str = kstrndup(create, DM_MAX_STR_SIZE, GFP_KERNEL);
>         if (!str)
>                 return -ENOMEM;
> @@ -287,13 +294,23 @@ static int __init dm_init_init(void)
>         wait_for_device_probe();
>
>         list_for_each_entry(dev, &devices, list) {
> -               if (dm_early_create(&dev->dmi, dev->table,
> -                                   dev->target_args_array))
> +               r = dm_early_create(&dev->dmi, dev->table, dev->target_args_array);
> +               if (r == -ENODEV) {
> +                       devnotfound = true;
>                         break;
> +               }
>         }
> +
>  out:
>         kfree(str);
>         dm_setup_cleanup(&devices);
> +       if (devnotfound && loopcnt) {
> +               msleep(5);
> +               devnotfound = false;
> +               loopcnt--;
> +               goto retry;
> +       }
> +
>         return r;
>  }
>
> @@ -301,3 +318,5 @@ late_initcall(dm_init_init);
>
>  module_param(create, charp, 0);
>  MODULE_PARM_DESC(create, "Create a mapped device in early boot");
> +module_param(delay, int, 0);
> +MODULE_PARM_DESC(delay, "Max delay to wait for data/hash device probe in seconds");
> --
> 2.30.2
>

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

