Return-Path: <SRS0=ugf6=NW=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3B026C432BE
	for <dm-devel@archiver.kernel.org>; Tue, 31 Aug 2021 07:26:18 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 7B5DD60F91
	for <dm-devel@archiver.kernel.org>; Tue, 31 Aug 2021 07:26:17 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 7B5DD60F91
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=bootlin.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-153-8c5uxFgbNlaVjVROiffW9g-1; Tue, 31 Aug 2021 03:26:15 -0400
X-MC-Unique: 8c5uxFgbNlaVjVROiffW9g-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 722958799EC;
	Tue, 31 Aug 2021 07:26:05 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 56C2B60C05;
	Tue, 31 Aug 2021 07:26:05 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id F38754A7C8;
	Tue, 31 Aug 2021 07:26:04 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
	[10.11.54.5])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 17UJCkPv029015 for <dm-devel@listman.util.phx.redhat.com>;
	Mon, 30 Aug 2021 15:12:46 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id E74EF6D9DF; Mon, 30 Aug 2021 19:12:45 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast06.extmail.prod.ext.rdu2.redhat.com [10.11.55.22])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id E09A96D9F2
	for <dm-devel@redhat.com>; Mon, 30 Aug 2021 19:12:43 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[207.211.31.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 0F1C919705A7
	for <dm-devel@redhat.com>; Mon, 30 Aug 2021 19:12:43 +0000 (UTC)
Received: from relay1-d.mail.gandi.net (relay1-d.mail.gandi.net
	[217.70.183.193]) (Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-371-eL0PbPb4NAiFv_A-k5WlTQ-1; Mon, 30 Aug 2021 15:12:31 -0400
X-MC-Unique: eL0PbPb4NAiFv_A-k5WlTQ-1
Received: (Authenticated sender: thomas.petazzoni@bootlin.com)
	by relay1-d.mail.gandi.net (Postfix) with ESMTPSA id DA682240003;
	Mon, 30 Aug 2021 19:12:25 +0000 (UTC)
Date: Mon, 30 Aug 2021 21:12:24 +0200
From: Thomas Petazzoni <thomas.petazzoni@bootlin.com>
To: Pintu Agarwal <pintu.ping@gmail.com>
Message-ID: <20210830211224.76391708@windsurf>
In-Reply-To: <CAOuPNLhTidgLNWUbtUgdESYcKcE1C4SOdzKeQVhFGQvEoc0QEg@mail.gmail.com>
References: <CAOuPNLhqSpaTm3u4kFsnuZ0PLDKuX8wsxuF=vUJ1TEG0EP+L1g@mail.gmail.com>
	<alpine.LRH.2.02.2107200737510.19984@file01.intranet.prod.int.rdu2.redhat.com>
	<CAOuPNLhh_LkLQ8mSA4eoUDLCLzHo5zHXsiQZXUB_-T_F1_v6-g@mail.gmail.com>
	<alpine.LRH.2.02.2107211300520.10897@file01.intranet.prod.int.rdu2.redhat.com>
	<CAOuPNLi-xz_4P+v45CHLx00ztbSwU3_maf4tuuyso5RHyeOytg@mail.gmail.com>
	<CAOuPNLg0m-Q7Vhp4srbQrjXHsxVhOr-K2dvnNqzdR6Dr4kioqA@mail.gmail.com>
	<20210830185541.715f6a39@windsurf>
	<CAOuPNLhTidgLNWUbtUgdESYcKcE1C4SOdzKeQVhFGQvEoc0QEg@mail.gmail.com>
Organization: Bootlin
MIME-Version: 1.0
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.79 on 10.11.54.5
X-loop: dm-devel@redhat.com
X-Mailman-Approved-At: Tue, 31 Aug 2021 03:25:15 -0400
Cc: Sami, Tolvanen <samitolvanen@google.com>, snitzer@redhat.com,
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Hello,

On Mon, 30 Aug 2021 23:48:40 +0530
Pintu Agarwal <pintu.ping@gmail.com> wrote:

> ohh that means we already have a working reference.
> If possible can you share the details, even 4.19 or higher will be
> also a good reference.
> 
> > > Or, another option is to use the new concept from 5.1 kernel that is:
> > > dm-mod.create = ?  
> > How are you doing it today without dm-mod.create ?  
> I think in 4.14 we don't have dm-mod.create right ?

No, but you can backport it easily. Back at
http://lists.infradead.org/pipermail/openwrt-devel/2019-November/025967.html
I provided backports of this feature to OpenWrt, for the 4.14 and 4.19
kernels.

> Here is our kernel command line:
> 
> [    0.000000] Kernel command line: ro rootwait
> console=ttyMSM0,115200,n8 ....  verity="95384 11923
> 16da5e4bbc706e5d90511d2a3dae373b5d878f9aebd522cd614a4faaace6baa3 12026
> " rootfstype=squashfs ubi.mtd=40,0,30 ubi.block=0,0 root=/dev/dm-0
> .... init=/sbin/init root=/dev/dm-0 dm="rootfs none ro,0 95384 verity
> 1 /dev/ubiblock0_0 /dev/mtdblock53 4096 4096 11923 8 sha256
> 16da5e4bbc706e5d90511d2a3dae373b5d878f9aebd522cd614a4faaace6baa3
> aee087a5be3b982978c923f566a94613496b417f2af592639bc80d141e34dfe7 10
> restart_on_corruption ignore_zero_blocks use_fec_from_device
> /dev/mtdblock53 fec_roots 2 fec_blocks 12026 fec_start 12026" ...

I don't see how this can work without the dm-mod.create feature. Are
you sure the verity= and dm= kernel arguments exist?

Best regards,

Thomas
-- 
Thomas Petazzoni, co-owner and CEO, Bootlin
Embedded Linux and Kernel engineering
https://bootlin.com

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

