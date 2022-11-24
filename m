Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2596DC43219
	for <dm-devel@archiver.kernel.org>; Thu, 24 Nov 2022 10:52:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1669287135;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=FtHjmVb4ezxjgcm9elAFQuciTqRrCwLLBSEKjPztMO4=;
	b=NydkGvr9M5V5E3swnNEZFJPr0KJd8S3L7MtdjIW3iD56eOAh3sMhBOoYoLQAjC/OuKJSCW
	E2wn0FjB2LKPzZgqo77yBMbAmPNxxMNzvaGyewqb2I4OPCT4vbyb0HkstsYd/z4k7TvRPc
	LQ++gahIZP+40c7S1cRvN1OnE4Oe4qw=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-26-yHM86cRzP_mE73KMebsCag-1; Thu, 24 Nov 2022 05:52:11 -0500
X-MC-Unique: yHM86cRzP_mE73KMebsCag-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 5829C833AEF;
	Thu, 24 Nov 2022 10:52:10 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id E4FB3492B09;
	Thu, 24 Nov 2022 10:52:08 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 909411946589;
	Thu, 24 Nov 2022 10:52:03 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com
 [10.11.54.10])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 03BC61946A46
 for <dm-devel@listman.corp.redhat.com>; Thu, 24 Nov 2022 10:51:46 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id E7023492B1C; Thu, 24 Nov 2022 10:51:40 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast05.extmail.prod.ext.rdu2.redhat.com [10.11.55.21])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id DFEEA492B04
 for <dm-devel@redhat.com>; Thu, 24 Nov 2022 10:51:40 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [205.139.110.61])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id C510B833AEE
 for <dm-devel@redhat.com>; Thu, 24 Nov 2022 10:51:40 +0000 (UTC)
Received: from mslow1.mail.gandi.net (mslow1.mail.gandi.net
 [217.70.178.240]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-596-4ffm8M2uOFOV377axeU4Lw-1; Thu, 24 Nov 2022 05:51:39 -0500
X-MC-Unique: 4ffm8M2uOFOV377axeU4Lw-1
Received: from relay8-d.mail.gandi.net (unknown [IPv6:2001:4b98:dc4:8::228])
 by mslow1.mail.gandi.net (Postfix) with ESMTP id 41184C1A4B
 for <dm-devel@redhat.com>; Thu, 24 Nov 2022 10:35:24 +0000 (UTC)
Received: (Authenticated sender: peter@korsgaard.com)
 by mail.gandi.net (Postfix) with ESMTPSA id D4AA81BF211;
 Thu, 24 Nov 2022 10:35:18 +0000 (UTC)
Received: from peko by dell.be.48ers.dk with local (Exim 4.94.2)
 (envelope-from <peter@korsgaard.com>)
 id 1oy9Zd-000G5g-Me; Thu, 24 Nov 2022 11:35:17 +0100
From: Peter Korsgaard <peter@korsgaard.com>
To: Mike Snitzer <snitzer@kernel.org>
References: <20221116061656.2345538-1-peter@korsgaard.com>
Date: Thu, 24 Nov 2022 11:35:17 +0100
In-Reply-To: <20221116061656.2345538-1-peter@korsgaard.com> (Peter Korsgaard's
 message of "Wed, 16 Nov 2022 07:16:56 +0100")
Message-ID: <877czkhc7u.fsf@dell.be.48ers.dk>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/27.1 (gnu/linux)
MIME-Version: 1.0
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Mimecast-Spam-Signature: yes
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.10
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
Cc: fabio.aiuto@amarulasolutions.com, Helen Koike <helen.koike@collabora.com>,
 michael@amarulasolutions.com, dm-devel@redhat.com,
 Jonathan Corbet <corbet@lwn.net>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.10
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

>>>>> "Peter" == Peter Korsgaard <peter@korsgaard.com> writes:

 > Just calling wait_for_device_probe() is not enough to ensure that
 > asynchronously probed block devices are available (E.G.  mmc, usb, ..), so
 > add a "dm-mod.waitfor=<device1>[,..,<deviceN>]" parameter to get dm-init to
 > explicitly wait for specific block devices before initializing the tables
 > with logic similar to the rootwait logic in init/do_mounts.c.

 > E.G. with dm-verity on mmc with
 > dm-mod.waitfor="PARTLABEL=hash-a,PARTLABEL=root-a"

 > [    0.671671] device-mapper: init: waiting for all devices to be available before creating mapped devices
 > [    0.671679] device-mapper: init: waiting for PARTLABEL=hash-a
 > [    0.710695] mmc0: new HS200 MMC card at address 0001
 > [    0.711158] mmcblk0: mmc0:0001 004GA0 3.69 GiB
 > [    0.715954] mmcblk0boot0: mmc0:0001 004GA0 partition 1 2.00 MiB
 > [    0.722085] mmcblk0boot1: mmc0:0001 004GA0 partition 2 2.00 MiB
 > [    0.728093] mmcblk0rpmb: mmc0:0001 004GA0 partition 3 512 KiB, chardev (249:0)
 > [    0.738274]  mmcblk0: p1 p2 p3 p4 p5 p6 p7
 > [    0.751282] device-mapper: init: waiting for PARTLABEL=root-a
 > [    0.751306] device-mapper: init: all devices available
 > [    0.751683] device-mapper: verity: sha256 using implementation "sha256-generic"
 > [    0.759344] device-mapper: ioctl: dm-0 (vroot) is ready
 > [    0.766540] VFS: Mounted root (squashfs filesystem) readonly on device 254:0.

 > Signed-off-by: Peter Korsgaard <peter@korsgaard.com>
 > ---
 > Changes since v1:
 > - Fix s/dm-init/dm-mod/ typo in documentation, drop trailing newline

Ping?

FYI: I was recently made aware that other patches fixing this issue
(but less nice, E.G. with a fixed delay) have been posted in the past,
so there seems to be a general need for something like this.

E.G:
https://lore.kernel.org/all/20220406154631.277107-1-fabio.aiuto@amarulasolutions.com/



 >  .../admin-guide/device-mapper/dm-init.rst     |  8 +++++++
 >  drivers/md/dm-init.c                          | 23 ++++++++++++++++++-
 >  2 files changed, 30 insertions(+), 1 deletion(-)

 > diff --git a/Documentation/admin-guide/device-mapper/dm-init.rst b/Documentation/admin-guide/device-mapper/dm-init.rst
 > index e5242ff17e9b..981d6a907699 100644
 > --- a/Documentation/admin-guide/device-mapper/dm-init.rst
 > +++ b/Documentation/admin-guide/device-mapper/dm-init.rst
 > @@ -123,3 +123,11 @@ Other examples (per target):
 >      0 1638400 verity 1 8:1 8:2 4096 4096 204800 1 sha256
 >      fb1a5a0f00deb908d8b53cb270858975e76cf64105d412ce764225d53b8f3cfd
 >      51934789604d1b92399c52e7cb149d1b3a1b74bbbcb103b2a0aaacbed5c08584
 > +
 > +For setups using device-mapper on top of asynchronously probed block
 > +devices (MMC, USB, ..), it may be necessary to tell dm-init to
 > +explicitly wait for them to become available before setting up the
 > +device-mapper tables. This can be done with the "dm-mod.waitfor="
 > +module parameter, which takes a list of devices to wait for::
 > +
 > +  dm-mod.waitfor=<device1>[,..,<deviceN>]
 > diff --git a/drivers/md/dm-init.c b/drivers/md/dm-init.c
 > index b0c45c6ebe0b..fc70b568e072 100644
 > --- a/drivers/md/dm-init.c
 > +++ b/drivers/md/dm-init.c
 > @@ -8,6 +8,7 @@
 >   */
 
 >  #include <linux/ctype.h>
 > +#include <linux/delay.h>
 >  #include <linux/device.h>
 >  #include <linux/device-mapper.h>
 >  #include <linux/init.h>
 > @@ -18,12 +19,17 @@
 >  #define DM_MAX_DEVICES 256
 >  #define DM_MAX_TARGETS 256
 >  #define DM_MAX_STR_SIZE 4096
 > +#define DM_MAX_WAITFOR 256
 
 >  static char *create;
 
 > +static char *waitfor[DM_MAX_WAITFOR];
 > +
 >  /*
 >   * Format: dm-mod.create=<name>,<uuid>,<minor>,<flags>,<table>[,<table>+][;<name>,<uuid>,<minor>,<flags>,<table>[,<table>+]+]
 >   * Table format: <start_sector> <num_sectors> <target_type> <target_args>
 > + * Block devices to wait for to become available before setting up tables:
 > + * dm-mod.waitfor=<device1>[,..,<deviceN>]
 >   *
 >   * See Documentation/admin-guide/device-mapper/dm-init.rst for dm-mod.create="..." format
 >   * details.
 > @@ -266,7 +272,7 @@ static int __init dm_init_init(void)
 >  	struct dm_device *dev;
 >  	LIST_HEAD(devices);
 >  	char *str;
 > -	int r;
 > +	int i, r;
 
 >  	if (!create)
 >  		return 0;
 > @@ -286,6 +292,18 @@ static int __init dm_init_init(void)
 >  	DMINFO("waiting for all devices to be available before creating mapped devices");
 >  	wait_for_device_probe();
 
 > +	for (i = 0; i < ARRAY_SIZE(waitfor); i++) {
 > +		if (waitfor[i]) {
 > +			DMINFO("waiting for %s", waitfor[i]);
 > +
 > +			while (!dm_get_dev_t(waitfor[i]))
 > +				msleep(20);
 > +		}
 > +	}
 > +
 > +	if (waitfor[0])
 > +		DMINFO("all devices available");
 > +
 >  	list_for_each_entry(dev, &devices, list) {
 >  		if (dm_early_create(&dev->dmi, dev->table,
 dev-> target_args_array))
 > @@ -301,3 +319,6 @@ late_initcall(dm_init_init);
 
 >  module_param(create, charp, 0);
 >  MODULE_PARM_DESC(create, "Create a mapped device in early boot");
 > +
 > +module_param_array(waitfor, charp, NULL, 0);
 > +MODULE_PARM_DESC(waitfor, "Devices to wait for before setting up tables");
 > -- 

 > 2.30.2


-- 
Bye, Peter Korsgaard

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

