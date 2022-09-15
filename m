Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E7ACDC6FA90
	for <dm-devel@archiver.kernel.org>; Fri, 16 Sep 2022 08:45:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1663317904;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:in-reply-to:in-reply-to:
	 references:references:list-id:list-help:list-unsubscribe:
	 list-subscribe:list-post; bh=nzTYRZlupICDqUor1wNYDDwZD8QJv2IDfNBy+7FyVe8=;
	b=XmWKWTgJx2qN2jT37jXSRVSgymvRnUN9CGIZ8sagfc++nhtEIinfTs1BDB+oMQ28NFR/cJ
	jSlT9f1u5SKDfXNiJN5xGN1Wf3lErHTmTCt6RHVNItCfVQMXDaVD+zDRqQ5PwxwjqYahZ+
	uEi4kT4ZZn/bEWrSIk8cSAJL+XAQ9M8=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-278-CR8ZRhr4NzaNEFr-hwh9Nw-1; Fri, 16 Sep 2022 04:45:01 -0400
X-MC-Unique: CR8ZRhr4NzaNEFr-hwh9Nw-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id CB703857D1C;
	Fri, 16 Sep 2022 08:44:59 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id B317F1121319;
	Fri, 16 Sep 2022 08:44:59 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id E20F51947059;
	Fri, 16 Sep 2022 08:44:57 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
 [10.11.54.6])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 01DDF1946586
 for <dm-devel@listman.corp.redhat.com>; Thu, 15 Sep 2022 21:21:02 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id B2B202166B29; Thu, 15 Sep 2022 21:21:02 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast04.extmail.prod.ext.rdu2.redhat.com [10.11.55.20])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id ADFEB2166B26
 for <dm-devel@redhat.com>; Thu, 15 Sep 2022 21:21:02 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [205.139.110.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 8FE94101A528
 for <dm-devel@redhat.com>; Thu, 15 Sep 2022 21:21:02 +0000 (UTC)
Received: from mail-ed1-f54.google.com (mail-ed1-f54.google.com
 [209.85.208.54]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-622-hGnZCeKKPlW6glBg2BTL4Q-1; Thu, 15 Sep 2022 17:21:00 -0400
X-MC-Unique: hGnZCeKKPlW6glBg2BTL4Q-1
Received: by mail-ed1-f54.google.com with SMTP id w28so4889190edi.7
 for <dm-devel@redhat.com>; Thu, 15 Sep 2022 14:21:00 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=cc:to:subject:message-id:date:from:in-reply-to:references
 :mime-version:x-gm-message-state:from:to:cc:subject:date;
 bh=XyoVFsIWssm6o7scG92SBg/Uvz7MbceVn+ARLVqA3to=;
 b=xZBI5e5Rc2KBs7dD9Y5UwKeLulrcYSMnWHG0JnPs8FyrmTlPuUhjMI5vnR+uPtmpVH
 iEmQpM1DsJ+IDCXrYwfVntOdMGoJwB6JYilf5svJkxW29dknUJbRAh+mkrzwFAX7cCLE
 1FAC57F5UyLPkbycC2cRHn6XUYMeNqKxju8uNWeDT5Ijx9WVa6tnI3FIgOfWeD2ORLV2
 t8qbBV3puae0Sax+IIg7KGVc1BDcWdvpI38vzZIwQwRAy+ckysTuf4JnU46J6Jck2rht
 UdaTCqybfGjUs+V7BVZMCa2NZTH8ZiEADnSubEvTPMkktMgCRd9MyDtnN8crA1ItGupv
 NCEw==
X-Gm-Message-State: ACrzQf00LLy5F0fp0qhLEzMrt6Zgkl82YiOiRxp1fntCifaSjdnNxA/6
 O0l62tcKhRcaof7gAr5B7bWx8NjeZUJfGe8MkE07bw==
X-Google-Smtp-Source: AMsMyM7xo/dPfU0C3G7OVFyhy2fXUo0GWakDbyETcrB0G5DUlvES/xDrAk+hYkLYli9vdHiQd2umFtI60gVMhPBPz/U=
X-Received: by 2002:aa7:c415:0:b0:44d:f432:3e84 with SMTP id
 j21-20020aa7c415000000b0044df4323e84mr1520534edq.56.1663276859264; Thu, 15
 Sep 2022 14:20:59 -0700 (PDT)
MIME-Version: 1.0
References: <20220406154631.277107-1-fabio.aiuto@amarulasolutions.com>
 <7442e695-654a-59c2-e3dd-710946e6cddd@seco.com>
In-Reply-To: <7442e695-654a-59c2-e3dd-710946e6cddd@seco.com>
From: Michael Nazzareno Trimarchi <michael@amarulasolutions.com>
Date: Thu, 15 Sep 2022 23:20:47 +0200
Message-ID: <CAOf5uwmR59x=7vd=V9LQ-OS4HoR2WeKvSEiM_Or8Zgix9NtuMQ@mail.gmail.com>
To: Sean Anderson <sean.anderson@seco.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.6
X-Mailman-Approved-At: Fri, 16 Sep 2022 08:44:55 +0000
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
Cc: Fabio Aiuto <fabio.aiuto@amarulasolutions.com>, dm-devel@redhat.com,
 snitzer@kernel.org, linux-kernel@vger.kernel.org, agk@redhat.com
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.3
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: multipart/mixed; boundary="===============1683472414692865833=="

--===============1683472414692865833==
Content-Type: multipart/alternative; boundary="0000000000005c289d05e8bdd26b"

--0000000000005c289d05e8bdd26b
Content-Type: text/plain; charset="UTF-8"

Hi Sean

On Fri, Sep 9, 2022 at 10:12 PM Sean Anderson <sean.anderson@seco.com>
wrote:

> I ran into this issue today. This patch fixes things, so
>
> Tested-by: Sean Anderson <sean.anderson@seco.com>
>
> However, I think the implementation leaves a bit to be desired...
>
> On 4/6/22 11:46 AM, Fabio Aiuto wrote:
> > From: Michael Trimarchi <michael@amarulasolutions.com>
> >
> > The device driver can be deferrable and can be a race during
> > the dm-init early. We need to wait all the probe are really finished
> > in a loop as is done in do_mounts. This is was tested on kernel 5.4
> > but code seems was not changed since that time
> >
>

Ok, I know, I was waiting for some feedback. I will try to rework

Michael


> > 003: imx8mq-usb-phy 381f0040.usb-phy: 381f0040.usb-phy supply vbus not
> found, using dummy regulator
> > 003: imx8mq-usb-phy 382f0040.usb-phy: 382f0040.usb-phy supply vbus not
> found, using dummy regulator
> > 003: imx-cpufreq-dt imx-cpufreq-dt: cpu speed grade 5 mkt segment 0
> supported-hw 0x20 0x1
> > 003: caam-dma caam-dma: caam dma support with 2 job rings
> > 000: hctosys: unable to open rtc device (rtc0)
> > 000: device-mapper: init: waiting for all devices to be available before
> creating mapped devices
> > 002: device-mapper: table: 254:0: verity: Data device lookup failed
> > 002: device-mapper: ioctl: error adding target to table
> > 002: crng init done
> > 003: of_cfs_init
> > 003: of_cfs_init: OK
> > 003: Waiting for root device /dev/dm-0...
> > 001: mmc2: new HS400 Enhanced strobe MMC card at address 0001
> > 001: mmcblk2: mmc2:0001 IB2916 14.6 GiB
> > 001: mmcblk2boot0: mmc2:0001 IB2916 partition 1 4.00 MiB
> > 001: mmcblk2boot1: mmc2:0001 IB2916 partition 2 4.00 MiB
> > 001: mmcblk2rpmb: mmc2:0001 IB2916 partition 3 4.00 MiB, chardev (249:0)
> > 001:  mmcblk2: p1 p2 p3 p4 p5 p6 p7 p8 p9 p10 p11
> > 001: VSD_3V3: disabling
> >
> > with the patch
> >
> > 003: device-mapper: init: waiting for all devices to be available before
> creating mapped devices
> >
> > 000: device-mapper: table: 254:0: verity: Data device lookup failed
> > 000: device-mapper: ioctl: error adding target to table
> > 002: crng init done
> > 003: device-mapper: init: waiting for all devices to be available before
> creating mapped devices
> > 003: device-mapper: table: 254:0: verity: Data device lookup failed
> > 003: device-mapper: ioctl: error adding target to table
> > 003: device-mapper: init: waiting for all devices to be available before
> creating mapped devices
> > 000: device-mapper: table: 254:0: verity: Data device lookup failed
> > 000: device-mapper: ioctl: error adding target to table
> > 002: device-mapper: init: waiting for all devices to be available before
> creating mapped devices
> > 002: device-mapper: table: 254:0: verity: Data device lookup failed
> > 002: device-mapper: ioctl: error adding target to table
> > 000: device-mapper: init: waiting for all devices to be available before
> creating mapped devices
> > 000: device-mapper: table: 254:0: verity: Data device lookup failed
> > 000: device-mapper: ioctl: error adding target to table
>
> For example, we repeatedly print these errors, even though there is not
> really an error condition. Additionally, we still loop even if (e.g.)
> there is a syntax error in the dm-mod.create parameter. It also
> introduces similar problems to rootdelay, where you have to choose a
> suitable maximum value.
>
> I would much rather see something closer to rootwait (as implemented in
> prepare_namespace). To do that, I think it is better to modify
> dm_get_device or dm_get_dev_t, which are closer to the source of the
> error. One issue is that these functions are not just called from
> dm_early_create, but also at runtime. So we can't just blindly start
> waiting for devices to show up if they don't exist and dm-mod.wait (or
> whatever) is missing. We could solve this by introducing a variable
> which is cleared at the end of dm_early_create. I think that solution is
> OK. We could also modify dm_early_create to pass a parameter to
> dm_table_add_target which indicates that the target is being created
> "early." However, I think this would be fairly disruptive to existing
> code.
>
> --Sean
>
> > 003: mmc2: new HS400 Enhanced strobe MMC card at address 0001
> > 003: mmcblk2: mmc2:0001 DG4016 14.7 GiB
> > 003: mmcblk2boot0: mmc2:0001 DG4016 partition 1 4.00 MiB
> > 003: mmcblk2boot1: mmc2:0001 DG4016 partition 2 4.00 MiB
> > 003: mmcblk2rpmb: mmc2:0001 DG4016 partition 3 4.00 MiB, chardev (249:0)
> > 003:  mmcblk2: p1 p2 p3 p4 p5 p6 p7 p8 p9 p10 p11
> > 002: device-mapper: init: waiting for all devices to be available before
> creating mapped devices
> > 003: device-mapper: verity: sha256 using implementation "sha256-caam"
> > 000: device-mapper: ioctl: dm-0 (rootfs) is ready
> >
> > Wait loop is limited to 10 at the moment for our use case showed no
> > more than 4 loops before successfully find data device.
> >
> > Signed-off-by: Michael Trimarchi <michael@amarulasolutions.com>
> > Signed-off-by: Fabio Aiuto <fabio.aiuto@amarulasolutions.com>
> > ---
> > Changes from v1:
> >         - limit the loop to 10 iterations
> >         - change variable names
> >         - check only for -ENODEV failures
> >
> > Changes from v2:
> >       - use a limit in seconds (not in retry
> >         number)
> >       - add a parameter
> >       - update docs
> >
> >  .../admin-guide/device-mapper/dm-init.rst     | 13 +++++++++++
> >  drivers/md/dm-init.c                          | 23 +++++++++++++++++--
> >  2 files changed, 34 insertions(+), 2 deletions(-)
> >
> > diff --git a/Documentation/admin-guide/device-mapper/dm-init.rst
> b/Documentation/admin-guide/device-mapper/dm-init.rst
> > index e5242ff17e9b..5c2f2bf1db03 100644
> > --- a/Documentation/admin-guide/device-mapper/dm-init.rst
> > +++ b/Documentation/admin-guide/device-mapper/dm-init.rst
> > @@ -123,3 +123,16 @@ Other examples (per target):
> >      0 1638400 verity 1 8:1 8:2 4096 4096 204800 1 sha256
> >      fb1a5a0f00deb908d8b53cb270858975e76cf64105d412ce764225d53b8f3cfd
> >      51934789604d1b92399c52e7cb149d1b3a1b74bbbcb103b2a0aaacbed5c08584
> > +
> > +Delay for waiting deferred probes of block devices
> > +==================================================
> > +
> > +Sometimes the late initcall starting the early creation of mapped
> > +devices, starts too early. A loop waiting for probing of block
> > +devices has been added; the default maximum delay is 1 second but
> > +it can be set through the following kernel command::
> > +
> > +  dm-mod.delay=<seconds>
> > +
> > +This allows the procedure to retry the creation of a mapped device
> > +after a short wait (5 msecs).
> > diff --git a/drivers/md/dm-init.c b/drivers/md/dm-init.c
> > index b0c45c6ebe0b..f4c5b4a46001 100644
> > --- a/drivers/md/dm-init.c
> > +++ b/drivers/md/dm-init.c
> > @@ -7,7 +7,9 @@
> >   * This file is released under the GPLv2.
> >   */
> >
> > +#include <linux/async.h>
> >  #include <linux/ctype.h>
> > +#include <linux/delay.h>
> >  #include <linux/device.h>
> >  #include <linux/device-mapper.h>
> >  #include <linux/init.h>
> > @@ -18,8 +20,10 @@
> >  #define DM_MAX_DEVICES 256
> >  #define DM_MAX_TARGETS 256
> >  #define DM_MAX_STR_SIZE 4096
> > +#define DM_DEFAULT_MAX_PROBE_DELAY 1
> >
> >  static char *create;
> > +static int delay = DM_DEFAULT_MAX_PROBE_DELAY;
> >
> >  /*
> >   * Format:
> dm-mod.create=<name>,<uuid>,<minor>,<flags>,<table>[,<table>+][;<name>,<uuid>,<minor>,<flags>,<table>[,<table>+]+]
> > @@ -267,6 +271,8 @@ static int __init dm_init_init(void)
> >       LIST_HEAD(devices);
> >       char *str;
> >       int r;
> > +     int loopcnt = delay * 1000 / 5;
> > +     bool devnotfound = false;
> >
> >       if (!create)
> >               return 0;
> > @@ -275,6 +281,7 @@ static int __init dm_init_init(void)
> >               DMERR("Argument is too big. Limit is %d", DM_MAX_STR_SIZE);
> >               return -EINVAL;
> >       }
> > +retry:
> >       str = kstrndup(create, DM_MAX_STR_SIZE, GFP_KERNEL);
> >       if (!str)
> >               return -ENOMEM;
> > @@ -287,13 +294,23 @@ static int __init dm_init_init(void)
> >       wait_for_device_probe();
> >
> >       list_for_each_entry(dev, &devices, list) {
> > -             if (dm_early_create(&dev->dmi, dev->table,
> > -                                 dev->target_args_array))
> > +             r = dm_early_create(&dev->dmi, dev->table,
> dev->target_args_array);
> > +             if (r == -ENODEV) {
> > +                     devnotfound = true;
> >                       break;
> > +             }
> >       }
> > +
> >  out:
> >       kfree(str);
> >       dm_setup_cleanup(&devices);
> > +     if (devnotfound && loopcnt) {
> > +             msleep(5);
> > +             devnotfound = false;
> > +             loopcnt--;
> > +             goto retry;
> > +     }
> > +
> >       return r;
> >  }
> >
> > @@ -301,3 +318,5 @@ late_initcall(dm_init_init);
> >
> >  module_param(create, charp, 0);
> >  MODULE_PARM_DESC(create, "Create a mapped device in early boot");
> > +module_param(delay, int, 0);
> > +MODULE_PARM_DESC(delay, "Max delay to wait for data/hash device probe
> in seconds");
> >
>


-- 
Michael Nazzareno Trimarchi
Co-Founder & Chief Executive Officer
M. +39 347 913 2170
michael@amarulasolutions.com
__________________________________

Amarula Solutions BV
Joop Geesinkweg 125, 1114 AB, Amsterdam, NL
T. +31 (0)85 111 9172
info@amarulasolutions.com
www.amarulasolutions.com

--0000000000005c289d05e8bdd26b
Content-Type: text/html; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr"><div dir=3D"ltr">Hi Sean<br></div><br><div class=3D"gmail_=
quote"><div dir=3D"ltr" class=3D"gmail_attr">On Fri, Sep 9, 2022 at 10:12 P=
M Sean Anderson &lt;<a href=3D"mailto:sean.anderson@seco.com">sean.anderson=
@seco.com</a>&gt; wrote:<br></div><blockquote class=3D"gmail_quote" style=
=3D"margin:0px 0px 0px 0.8ex;border-left:1px solid rgb(204,204,204);padding=
-left:1ex">I ran into this issue today. This patch fixes things, so<br>
<br>
Tested-by: Sean Anderson &lt;<a href=3D"mailto:sean.anderson@seco.com" targ=
et=3D"_blank">sean.anderson@seco.com</a>&gt;<br>
<br>
However, I think the implementation leaves a bit to be desired...<br>
<br>
On 4/6/22 11:46 AM, Fabio Aiuto wrote:<br>
&gt; From: Michael Trimarchi &lt;<a href=3D"mailto:michael@amarulasolutions=
.com" target=3D"_blank">michael@amarulasolutions.com</a>&gt;<br>
&gt; <br>
&gt; The device driver can be deferrable and can be a race during<br>
&gt; the dm-init early. We need to wait all the probe are really finished<b=
r>
&gt; in a loop as is done in do_mounts. This is was tested on kernel 5.4<br=
>
&gt; but code seems was not changed since that time<br>
&gt; <br></blockquote><div><br></div><div>Ok, I know, I was waiting for som=
e feedback. I will try to rework</div><div><br></div><div>Michael</div><div=
>=C2=A0<br></div><blockquote class=3D"gmail_quote" style=3D"margin:0px 0px =
0px 0.8ex;border-left:1px solid rgb(204,204,204);padding-left:1ex">
&gt; 003: imx8mq-usb-phy 381f0040.usb-phy: 381f0040.usb-phy supply vbus not=
 found, using dummy regulator<br>
&gt; 003: imx8mq-usb-phy 382f0040.usb-phy: 382f0040.usb-phy supply vbus not=
 found, using dummy regulator<br>
&gt; 003: imx-cpufreq-dt imx-cpufreq-dt: cpu speed grade 5 mkt segment 0 su=
pported-hw 0x20 0x1<br>
&gt; 003: caam-dma caam-dma: caam dma support with 2 job rings<br>
&gt; 000: hctosys: unable to open rtc device (rtc0)<br>
&gt; 000: device-mapper: init: waiting for all devices to be available befo=
re creating mapped devices<br>
&gt; 002: device-mapper: table: 254:0: verity: Data device lookup failed<br=
>
&gt; 002: device-mapper: ioctl: error adding target to table<br>
&gt; 002: crng init done<br>
&gt; 003: of_cfs_init<br>
&gt; 003: of_cfs_init: OK<br>
&gt; 003: Waiting for root device /dev/dm-0...<br>
&gt; 001: mmc2: new HS400 Enhanced strobe MMC card at address 0001<br>
&gt; 001: mmcblk2: mmc2:0001 IB2916 14.6 GiB<br>
&gt; 001: mmcblk2boot0: mmc2:0001 IB2916 partition 1 4.00 MiB<br>
&gt; 001: mmcblk2boot1: mmc2:0001 IB2916 partition 2 4.00 MiB<br>
&gt; 001: mmcblk2rpmb: mmc2:0001 IB2916 partition 3 4.00 MiB, chardev (249:=
0)<br>
&gt; 001:=C2=A0 mmcblk2: p1 p2 p3 p4 p5 p6 p7 p8 p9 p10 p11<br>
&gt; 001: VSD_3V3: disabling<br>
&gt; <br>
&gt; with the patch<br>
&gt; <br>
&gt; 003: device-mapper: init: waiting for all devices to be available befo=
re creating mapped devices<br>
&gt; <br>
&gt; 000: device-mapper: table: 254:0: verity: Data device lookup failed<br=
>
&gt; 000: device-mapper: ioctl: error adding target to table<br>
&gt; 002: crng init done<br>
&gt; 003: device-mapper: init: waiting for all devices to be available befo=
re creating mapped devices<br>
&gt; 003: device-mapper: table: 254:0: verity: Data device lookup failed<br=
>
&gt; 003: device-mapper: ioctl: error adding target to table<br>
&gt; 003: device-mapper: init: waiting for all devices to be available befo=
re creating mapped devices<br>
&gt; 000: device-mapper: table: 254:0: verity: Data device lookup failed<br=
>
&gt; 000: device-mapper: ioctl: error adding target to table<br>
&gt; 002: device-mapper: init: waiting for all devices to be available befo=
re creating mapped devices<br>
&gt; 002: device-mapper: table: 254:0: verity: Data device lookup failed<br=
>
&gt; 002: device-mapper: ioctl: error adding target to table<br>
&gt; 000: device-mapper: init: waiting for all devices to be available befo=
re creating mapped devices<br>
&gt; 000: device-mapper: table: 254:0: verity: Data device lookup failed<br=
>
&gt; 000: device-mapper: ioctl: error adding target to table<br>
<br>
For example, we repeatedly print these errors, even though there is not<br>
really an error condition. Additionally, we still loop even if (e.g.)<br>
there is a syntax error in the dm-mod.create parameter. It also<br>
introduces similar problems to rootdelay, where you have to choose a<br>
suitable maximum value.<br>
<br>
I would much rather see something closer to rootwait (as implemented in<br>
prepare_namespace). To do that, I think it is better to modify<br>
dm_get_device or dm_get_dev_t, which are closer to the source of the<br>
error. One issue is that these functions are not just called from<br>
dm_early_create, but also at runtime. So we can&#39;t just blindly start<br=
>
waiting for devices to show up if they don&#39;t exist and dm-mod.wait (or<=
br>
whatever) is missing. We could solve this by introducing a variable<br>
which is cleared at the end of dm_early_create. I think that solution is<br=
>
OK. We could also modify dm_early_create to pass a parameter to<br>
dm_table_add_target which indicates that the target is being created<br>
&quot;early.&quot; However, I think this would be fairly disruptive to exis=
ting<br>
code.<br>
<br>
--Sean<br>
<br>
&gt; 003: mmc2: new HS400 Enhanced strobe MMC card at address 0001<br>
&gt; 003: mmcblk2: mmc2:0001 DG4016 14.7 GiB<br>
&gt; 003: mmcblk2boot0: mmc2:0001 DG4016 partition 1 4.00 MiB<br>
&gt; 003: mmcblk2boot1: mmc2:0001 DG4016 partition 2 4.00 MiB<br>
&gt; 003: mmcblk2rpmb: mmc2:0001 DG4016 partition 3 4.00 MiB, chardev (249:=
0)<br>
&gt; 003:=C2=A0 mmcblk2: p1 p2 p3 p4 p5 p6 p7 p8 p9 p10 p11<br>
&gt; 002: device-mapper: init: waiting for all devices to be available befo=
re creating mapped devices<br>
&gt; 003: device-mapper: verity: sha256 using implementation &quot;sha256-c=
aam&quot;<br>
&gt; 000: device-mapper: ioctl: dm-0 (rootfs) is ready<br>
&gt; <br>
&gt; Wait loop is limited to 10 at the moment for our use case showed no<br=
>
&gt; more than 4 loops before successfully find data device.<br>
&gt; <br>
&gt; Signed-off-by: Michael Trimarchi &lt;<a href=3D"mailto:michael@amarula=
solutions.com" target=3D"_blank">michael@amarulasolutions.com</a>&gt;<br>
&gt; Signed-off-by: Fabio Aiuto &lt;<a href=3D"mailto:fabio.aiuto@amarulaso=
lutions.com" target=3D"_blank">fabio.aiuto@amarulasolutions.com</a>&gt;<br>
&gt; ---<br>
&gt; Changes from v1:<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0- limit the loop to 10 iterations<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0- change variable names<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0- check only for -ENODEV failures<br>
&gt; <br>
&gt; Changes from v2:<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0- use a limit in seconds (not in retry<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0number)<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0- add a parameter<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0- update docs<br>
&gt; <br>
&gt;=C2=A0 .../admin-guide/device-mapper/dm-init.rst=C2=A0 =C2=A0 =C2=A0| 1=
3 +++++++++++<br>
&gt;=C2=A0 drivers/md/dm-init.c=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 | 23 +++++++++++++++++--<b=
r>
&gt;=C2=A0 2 files changed, 34 insertions(+), 2 deletions(-)<br>
&gt; <br>
&gt; diff --git a/Documentation/admin-guide/device-mapper/dm-init.rst b/Doc=
umentation/admin-guide/device-mapper/dm-init.rst<br>
&gt; index e5242ff17e9b..5c2f2bf1db03 100644<br>
&gt; --- a/Documentation/admin-guide/device-mapper/dm-init.rst<br>
&gt; +++ b/Documentation/admin-guide/device-mapper/dm-init.rst<br>
&gt; @@ -123,3 +123,16 @@ Other examples (per target):<br>
&gt;=C2=A0 =C2=A0 =C2=A0 0 1638400 verity 1 8:1 8:2 4096 4096 204800 1 sha2=
56<br>
&gt;=C2=A0 =C2=A0 =C2=A0 fb1a5a0f00deb908d8b53cb270858975e76cf64105d412ce76=
4225d53b8f3cfd<br>
&gt;=C2=A0 =C2=A0 =C2=A0 51934789604d1b92399c52e7cb149d1b3a1b74bbbcb103b2a0=
aaacbed5c08584<br>
&gt; +<br>
&gt; +Delay for waiting deferred probes of block devices<br>
&gt; +=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D<br>
&gt; +<br>
&gt; +Sometimes the late initcall starting the early creation of mapped<br>
&gt; +devices, starts too early. A loop waiting for probing of block<br>
&gt; +devices has been added; the default maximum delay is 1 second but<br>
&gt; +it can be set through the following kernel command::<br>
&gt; +<br>
&gt; +=C2=A0 dm-mod.delay=3D&lt;seconds&gt;<br>
&gt; +<br>
&gt; +This allows the procedure to retry the creation of a mapped device<br=
>
&gt; +after a short wait (5 msecs).<br>
&gt; diff --git a/drivers/md/dm-init.c b/drivers/md/dm-init.c<br>
&gt; index b0c45c6ebe0b..f4c5b4a46001 100644<br>
&gt; --- a/drivers/md/dm-init.c<br>
&gt; +++ b/drivers/md/dm-init.c<br>
&gt; @@ -7,7 +7,9 @@<br>
&gt;=C2=A0 =C2=A0* This file is released under the GPLv2.<br>
&gt;=C2=A0 =C2=A0*/<br>
&gt;=C2=A0 <br>
&gt; +#include &lt;linux/async.h&gt;<br>
&gt;=C2=A0 #include &lt;linux/ctype.h&gt;<br>
&gt; +#include &lt;linux/delay.h&gt;<br>
&gt;=C2=A0 #include &lt;linux/device.h&gt;<br>
&gt;=C2=A0 #include &lt;linux/device-mapper.h&gt;<br>
&gt;=C2=A0 #include &lt;linux/init.h&gt;<br>
&gt; @@ -18,8 +20,10 @@<br>
&gt;=C2=A0 #define DM_MAX_DEVICES 256<br>
&gt;=C2=A0 #define DM_MAX_TARGETS 256<br>
&gt;=C2=A0 #define DM_MAX_STR_SIZE 4096<br>
&gt; +#define DM_DEFAULT_MAX_PROBE_DELAY 1<br>
&gt;=C2=A0 <br>
&gt;=C2=A0 static char *create;<br>
&gt; +static int delay =3D DM_DEFAULT_MAX_PROBE_DELAY;<br>
&gt;=C2=A0 <br>
&gt;=C2=A0 /*<br>
&gt;=C2=A0 =C2=A0* Format: dm-mod.create=3D&lt;name&gt;,&lt;uuid&gt;,&lt;mi=
nor&gt;,&lt;flags&gt;,&lt;table&gt;[,&lt;table&gt;+][;&lt;name&gt;,&lt;uuid=
&gt;,&lt;minor&gt;,&lt;flags&gt;,&lt;table&gt;[,&lt;table&gt;+]+]<br>
&gt; @@ -267,6 +271,8 @@ static int __init dm_init_init(void)<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0LIST_HEAD(devices);<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0char *str;<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0int r;<br>
&gt; +=C2=A0 =C2=A0 =C2=A0int loopcnt =3D delay * 1000 / 5;<br>
&gt; +=C2=A0 =C2=A0 =C2=A0bool devnotfound =3D false;<br>
&gt;=C2=A0 <br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0if (!create)<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0return 0;<br>
&gt; @@ -275,6 +281,7 @@ static int __init dm_init_init(void)<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0DMERR(&quot;Argu=
ment is too big. Limit is %d&quot;, DM_MAX_STR_SIZE);<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0return -EINVAL;<=
br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0}<br>
&gt; +retry:<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0str =3D kstrndup(create, DM_MAX_STR_SIZE, GF=
P_KERNEL);<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0if (!str)<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0return -ENOMEM;<=
br>
&gt; @@ -287,13 +294,23 @@ static int __init dm_init_init(void)<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0wait_for_device_probe();<br>
&gt;=C2=A0 <br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0list_for_each_entry(dev, &amp;devices, list)=
 {<br>
&gt; -=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0if (dm_early_create(&=
amp;dev-&gt;dmi, dev-&gt;table,<br>
&gt; -=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0dev-&gt;target_args_array)=
)<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0r =3D dm_early_create=
(&amp;dev-&gt;dmi, dev-&gt;table, dev-&gt;target_args_array);<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0if (r =3D=3D -ENODEV)=
 {<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0devnotfound =3D true;<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0break;<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0}<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0}<br>
&gt; +<br>
&gt;=C2=A0 out:<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0kfree(str);<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0dm_setup_cleanup(&amp;devices);<br>
&gt; +=C2=A0 =C2=A0 =C2=A0if (devnotfound &amp;&amp; loopcnt) {<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0msleep(5);<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0devnotfound =3D false=
;<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0loopcnt--;<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0goto retry;<br>
&gt; +=C2=A0 =C2=A0 =C2=A0}<br>
&gt; +<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0return r;<br>
&gt;=C2=A0 }<br>
&gt;=C2=A0 <br>
&gt; @@ -301,3 +318,5 @@ late_initcall(dm_init_init);<br>
&gt;=C2=A0 <br>
&gt;=C2=A0 module_param(create, charp, 0);<br>
&gt;=C2=A0 MODULE_PARM_DESC(create, &quot;Create a mapped device in early b=
oot&quot;);<br>
&gt; +module_param(delay, int, 0);<br>
&gt; +MODULE_PARM_DESC(delay, &quot;Max delay to wait for data/hash device =
probe in seconds&quot;);<br>
&gt; <br>
</blockquote></div><br clear=3D"all"><br>-- <br><div dir=3D"ltr" class=3D"g=
mail_signature"><div dir=3D"ltr">Michael Nazzareno Trimarchi<br>Co-Founder =
&amp; Chief Executive Officer<br>M. +39 347 913 2170<br><a href=3D"mailto:m=
ichael@amarulasolutions.com" target=3D"_blank">michael@amarulasolutions.com=
</a><br>__________________________________<br><div><br></div><div>Amarula S=
olutions BV</div>Joop Geesinkweg 125, 1114 AB, Amsterdam, NL<br>T. +31 (0)8=
5 111 9172<br><a href=3D"mailto:info@amarulasolutions.com" target=3D"_blank=
">info@amarulasolutions.com</a><br><a href=3D"http://www.amarulasolutions.c=
om" target=3D"_blank">www.amarulasolutions.com</a><br></div></div></div>

--0000000000005c289d05e8bdd26b--

--===============1683472414692865833==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

--===============1683472414692865833==--

