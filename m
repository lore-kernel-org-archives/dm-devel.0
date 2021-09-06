Return-Path: <SRS0=HcGL=N5=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.7 required=3.0 tests=BAYES_00,DKIM_ADSP_CUSTOM_MED,
	FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B3452C433EF
	for <dm-devel@archiver.kernel.org>; Tue,  7 Sep 2021 06:19:17 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 42829610FE
	for <dm-devel@archiver.kernel.org>; Tue,  7 Sep 2021 06:19:17 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 42829610FE
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-266-Htvu8Q2ZPO6mkFWSRFhqKQ-1; Tue, 07 Sep 2021 02:19:14 -0400
X-MC-Unique: Htvu8Q2ZPO6mkFWSRFhqKQ-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 3335E801B3D;
	Tue,  7 Sep 2021 06:19:08 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id CFB3D5D9DE;
	Tue,  7 Sep 2021 06:19:06 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 24CEB1809C81;
	Tue,  7 Sep 2021 06:19:02 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com
	[10.11.54.3])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 186GSRCW012195 for <dm-devel@listman.util.phx.redhat.com>;
	Mon, 6 Sep 2021 12:28:27 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id BAE6E1134CC9; Mon,  6 Sep 2021 16:28:27 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast06.extmail.prod.ext.rdu2.redhat.com [10.11.55.22])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id B6E5A1134CC7
	for <dm-devel@redhat.com>; Mon,  6 Sep 2021 16:28:24 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[205.139.110.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id DE1EA185A794
	for <dm-devel@redhat.com>; Mon,  6 Sep 2021 16:28:24 +0000 (UTC)
Received: from mail-ej1-f44.google.com (mail-ej1-f44.google.com
	[209.85.218.44]) (Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-14-wpIOAIhXMbeRHT78z5aHEw-1; Mon, 06 Sep 2021 12:28:21 -0400
X-MC-Unique: wpIOAIhXMbeRHT78z5aHEw-1
Received: by mail-ej1-f44.google.com with SMTP id i21so14489410ejd.2;
	Mon, 06 Sep 2021 09:28:20 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=1e100.net; s=20161025;
	h=x-gm-message-state:mime-version:references:in-reply-to:from:date
	:message-id:subject:to:cc;
	bh=6oKyG7zEb/nW+FeiP30bM48MUXtoqIWfTDkbvnG8BkY=;
	b=CNudj+AV8+xkleHje3ulqZM4viumMVkIqHR7+jRzUvUnAY1eg3WsN8lKXvL9gXO0D0
	FOaSsXk44G8XRz0JBaZKOS4o2j6gZP0TjJpNYv5lOwNg7EBT+81ifDXkQs+b98RF0q80
	rIqmMORnxaEv1YqEk2+1gVUioK8jSlH5b05zJimL2iW7IHt+ppZ3GEg5OI2guCpim/5f
	MNHPRK+Edm1cXtOpQ40niDmMWaf2l2xg0T9EmGDKHi9GIPx5C0Zl+upFEhq23yFKpTEI
	1/M5QpYief+tnfrc2xw3EDACC/2+khom9mMRmqXMaiP5UzCGRPIfZwg3ZKT1pXPavjV7
	SMCw==
X-Gm-Message-State: AOAM530AosqKubRh9i4v4/DW49mbnLPjFnOvA6jmwr8/UIrL605jpF29
	HbDecFqnCBc7dFTCXqc3WpaCZjdwrLBuQKPJvT6DDQy942TFaw==
X-Google-Smtp-Source: ABdhPJwyZI2iQmBxtUR38Zx7Nafy9EsJjNnIzDOyi9cAU4A8FwKXYxAZphlwRFe+JlmOEU0Qn2HcyvKeOV2DlHvWXs0=
X-Received: by 2002:a17:906:fb19:: with SMTP id
	lz25mr14543783ejb.162.1630945699450; 
	Mon, 06 Sep 2021 09:28:19 -0700 (PDT)
MIME-Version: 1.0
References: <CAOuPNLhqSpaTm3u4kFsnuZ0PLDKuX8wsxuF=vUJ1TEG0EP+L1g@mail.gmail.com>
	<alpine.LRH.2.02.2107200737510.19984@file01.intranet.prod.int.rdu2.redhat.com>
	<CAOuPNLhh_LkLQ8mSA4eoUDLCLzHo5zHXsiQZXUB_-T_F1_v6-g@mail.gmail.com>
	<alpine.LRH.2.02.2107211300520.10897@file01.intranet.prod.int.rdu2.redhat.com>
	<CAOuPNLi-xz_4P+v45CHLx00ztbSwU3_maf4tuuyso5RHyeOytg@mail.gmail.com>
	<CAOuPNLg0m-Q7Vhp4srbQrjXHsxVhOr-K2dvnNqzdR6Dr4kioqA@mail.gmail.com>
	<20210830185541.715f6a39@windsurf>
	<CAOuPNLhTidgLNWUbtUgdESYcKcE1C4SOdzKeQVhFGQvEoc0QEg@mail.gmail.com>
	<20210830211224.76391708@windsurf>
	<CAOuPNLgMd0AThhmSknbmKqp3_P8PFhBGr-jW0Mqjb6K6NchEMg@mail.gmail.com>
In-Reply-To: <CAOuPNLgMd0AThhmSknbmKqp3_P8PFhBGr-jW0Mqjb6K6NchEMg@mail.gmail.com>
From: Pintu Agarwal <pintu.ping@gmail.com>
Date: Mon, 6 Sep 2021 21:58:08 +0530
Message-ID: <CAOuPNLiW10-E6F_Ndte7U9NPBKa9Y_UuLhgdwAYTc0eYMk5Mqg@mail.gmail.com>
To: Thomas Petazzoni <thomas.petazzoni@bootlin.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Mimecast-Spam-Signature: yes
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.3
X-loop: dm-devel@redhat.com
X-Mailman-Approved-At: Tue, 07 Sep 2021 02:19:00 -0400
Cc: Sami Tolvanen <samitolvanen@google.com>, snitzer@redhat.com,
	Kernelnewbies <kernelnewbies@kernelnewbies.org>,
	open list <linux-kernel@vger.kernel.org>, dm-devel@redhat.com,
	Mikulas Patocka <mpatocka@redhat.com>,
	linux-mtd <linux-mtd@lists.infradead.org>,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>,
	Phillip Lougher <phillip@squashfs.org.uk>, agk@redhat.com
Subject: Re: [dm-devel] Kernel 4.14: Using dm-verity with squashfs rootfs -
	mounting issue
X-BeenThere: dm-devel@redhat.com
X-Mailman-Version: 2.1.12
Precedence: junk
List-Id: device-mapper development <dm-devel.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Dear Thomas, Mikulas,
Need your help in root causing my dm-verity issue with squashfs.
Please see my comments inline.

On Tue, 31 Aug 2021 at 18:49, Pintu Agarwal <pintu.ping@gmail.com> wrote:

> > No, but you can backport it easily. Back at
> > http://lists.infradead.org/pipermail/openwrt-devel/2019-November/025967.html
> > I provided backports of this feature to OpenWrt, for the 4.14 and 4.19
> > kernels.
> >
> Yes, I can backport it to our 4.14 Kernel.
> Can you share the list of patches to be backported to make it work on 4.14 ?
> If it's backported also I need to report to our internal kernel, but
> it might be slightly easier.
> Please share the details.
>

I am interested to backport dm-mod.create related patches to our 4.14 kernel.
Please let me know where can I find all the patches ?
Is it already part of mainline 4.14 ?
Please share the list of commits (from mainline) that we need to pull
and backport.

> > > Here is our kernel command line:
> > >
> > > [    0.000000] Kernel command line: ro rootwait
> > > console=ttyMSM0,115200,n8 ....  verity="95384 11923
> > > 16da5e4bbc706e5d90511d2a3dae373b5d878f9aebd522cd614a4faaace6baa3 12026
> > > " rootfstype=squashfs ubi.mtd=40,0,30 ubi.block=0,0 root=/dev/dm-0
> > > .... init=/sbin/init root=/dev/dm-0 dm="rootfs none ro,0 95384 verity
> > > 1 /dev/ubiblock0_0 /dev/mtdblock53 4096 4096 11923 8 sha256
> > > 16da5e4bbc706e5d90511d2a3dae373b5d878f9aebd522cd614a4faaace6baa3
> > > aee087a5be3b982978c923f566a94613496b417f2af592639bc80d141e34dfe7 10
> > > restart_on_corruption ignore_zero_blocks use_fec_from_device
> > > /dev/mtdblock53 fec_roots 2 fec_blocks 12026 fec_start 12026" ...
> >
> > I don't see how this can work without the dm-mod.create feature. Are
> > you sure the verity= and dm= kernel arguments exist?
>
I checked a little further and yes there is "dm=" command line in
kernel available.
This is already working with ext4 glue, but was never tried with squashfs.
I think it is mainline derived from Android.
https://patchwork.kernel.org/project/dm-devel/patch/2c01b2a43a46fab760208d7af3a7af37eec8c41a.1537936397.git.helen.koike@collabora.com/
https://github.com/projectceladon/device-androidia-kernel/blob/master/init/do_mounts_dm.c

Mostly, this is the main repo where our source might be derived:
https://github.com/android-linux-stable/msm-4.14

Can we backport the patches here ?
If I get the list I can try it.

>
> Also, you mentioned:
> >>> Here, it definitely worked to append the hash tree to the squashfs
> >>> image and store them in the same partition.
> Can you share some details about it ?
> How it can be done since squashfs is readonly.
Can you share your reference, how are you appending the hash tree ?
Let me try the same.

But it seems like the underlying concept is the same for both
"dm-mod.create" and "dm=".
However, I am not sure if there are any changes required for squashfs
as block device..

Errors:
Currently, we are getting this in boot logs:

[    4.962188] device-mapper: init: attempting early device configuration.
[    4.969699] device-mapper: init: created device '253:0'
[    4.975503] device-mapper: init: adding target '0 95384 verity 1
/dev/ubiblock0_0 /dev/mtdblock53 4096 4096 11923 8 sha256
8fc2e4bb751f4b3145a486a0f4f1b58149ba3eedc2a67312f31fbee131380dab
aee087a5be3b982978c923f566a94613496b417f2af592639bc80d141e34dfe7 10
restart_on_corruption ignore_zero_blocks use_fec_from_device
/dev/mtdblock53 fec_roots 2 fec_blocks 12026 fec_start 12026'
[    4.992323] device-mapper: verity: sha256 using implementation
"sha256-generic"
[    5.015568] device-mapper: init: dm-0 is ready
[   10.080065] prepare_namespace: dm_run_setup - done
[   10.080093] prepare_namespace: saved_root_name: /dev/dm-0
[   10.083903] prepare_namespace: Inside: name_to_dev_t
[   10.089605] prepare_namespace: Calling - mount_root() ...
[   10.094519] [PINTU]: mount_block_root: called with input name:
/dev/root, fs_names: squashfs
[   10.263510] [PINTU]: do_mount_root: sys_mount failed: err: -22
[   10.263544] [PINTU]: mount_block_root: do_mount_root: err: -22, p:
squashfs, flags: 32769, root_mount_data: (null)
[..]
[   10.745672] No filesystem could mount root, tried:
[   10.745676]  squashfs
[   10.748015]
[   10.755232] Kernel panic - not syncing: VFS: Unable to mount root
fs on unknown-block(253,0)

It seems the rootfs could not mount due to invalid arguments.
Not sure which arguments are invalid here...


Thanks,
Pintu

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

