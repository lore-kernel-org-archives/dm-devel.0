Return-Path: <SRS0=JGfJ=E5=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D9E15C2D0E4
	for <dm-devel@archiver.kernel.org>; Mon, 23 Nov 2020 08:41:10 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 0FC2920729
	for <dm-devel@archiver.kernel.org>; Mon, 23 Nov 2020 08:41:09 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 0FC2920729
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=ravnborg.org
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-587-Fay7QzY3OTK3Bm0Tjfefxg-1; Mon, 23 Nov 2020 03:40:47 -0500
X-MC-Unique: Fay7QzY3OTK3Bm0Tjfefxg-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 0413E1083EAE;
	Mon, 23 Nov 2020 08:40:41 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id DA3841349A;
	Mon, 23 Nov 2020 08:40:40 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id B1F5850033;
	Mon, 23 Nov 2020 08:40:40 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com
	[10.11.54.3])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 0AMMHS8n018946 for <dm-devel@listman.util.phx.redhat.com>;
	Sun, 22 Nov 2020 17:17:28 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 190AC1000DBB; Sun, 22 Nov 2020 22:17:28 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast06.extmail.prod.ext.rdu2.redhat.com [10.11.55.22])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 15062100335C
	for <dm-devel@redhat.com>; Sun, 22 Nov 2020 22:17:25 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[205.139.110.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id CC84E185A794
	for <dm-devel@redhat.com>; Sun, 22 Nov 2020 22:17:25 +0000 (UTC)
Received: from asavdk4.altibox.net (asavdk4.altibox.net [109.247.116.15])
	(Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-188-XfkMBqc8M7OaoJ-d7DxPiQ-1; Sun, 22 Nov 2020 17:17:21 -0500
X-MC-Unique: XfkMBqc8M7OaoJ-d7DxPiQ-1
Received: from ravnborg.org (unknown [188.228.123.71])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by asavdk4.altibox.net (Postfix) with ESMTPS id 2C52280567;
	Sun, 22 Nov 2020 23:10:42 +0100 (CET)
Date: Sun, 22 Nov 2020 23:10:40 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: James Bottomley <James.Bottomley@hansenpartnership.com>
Message-ID: <20201122221040.GD566387@ravnborg.org>
References: <cover.1605896059.git.gustavoars@kernel.org>
	<20201120105344.4345c14e@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
	<202011201129.B13FDB3C@keescook>
	<20201120115142.292999b2@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
	<202011220816.8B6591A@keescook>
	<9b57fd4914b46f38d54087d75e072d6e947cb56d.camel@HansenPartnership.com>
MIME-Version: 1.0
In-Reply-To: <9b57fd4914b46f38d54087d75e072d6e947cb56d.camel@HansenPartnership.com>
X-CMAE-Score: 0
X-CMAE-Analysis: v=2.3 cv=VafZwmh9 c=1 sm=1 tr=0
	a=S6zTFyMACwkrwXSdXUNehg==:117 a=S6zTFyMACwkrwXSdXUNehg==:17
	a=kj9zAlcOel0A:10 a=VwQbUJbxAAAA:8 a=pGLkceISAAAA:8
	a=7T594MSkF3521FIrX4wA:9 a=CjuIK1q_8ugA:10 a=AjGcO6oz07-iQ99wixmX:22
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.3
X-loop: dm-devel@redhat.com
X-Mailman-Approved-At: Mon, 23 Nov 2020 03:39:39 -0500
Cc: alsa-devel@alsa-project.org, bridge@lists.linux-foundation.org,
	linux-iio@vger.kernel.org, linux-wireless@vger.kernel.org,
	linux-mmc@vger.kernel.org, linux-fbdev@vger.kernel.org,
	dri-devel@lists.freedesktop.org,
	virtualization@lists.linux-foundation.org, linux-mm@kvack.org,
	linux-ide@vger.kernel.org, dm-devel@redhat.com,
	keyrings@vger.kernel.org, linux-mtd@lists.infradead.org,
	GR-everest-linux-l2@marvell.com, wcn36xx@lists.infradead.org,
	linux-i3c@lists.infradead.org, linux1394-devel@lists.sourceforge.net,
	linux-afs@lists.infradead.org, linux-watchdog@vger.kernel.org,
	devel@driverdev.osuosl.org, linux-cifs@vger.kernel.org,
	rds-devel@oss.oracle.com, linux-scsi@vger.kernel.org,
	linux-acpi@vger.kernel.org, linux-rdma@vger.kernel.org,
	oss-drivers@netronome.com, linux-atm-general@lists.sourceforge.net,
	ceph-devel@vger.kernel.org, amd-gfx@lists.freedesktop.org,
	linux-stm32@st-md-mailman.stormreply.com,
	cluster-devel@redhat.com, usb-storage@lists.one-eyed-alien.net,
	coreteam@netfilter.org, intel-wired-lan@lists.osuosl.org,
	"Gustavo A. R. Silva" <gustavoars@kernel.org>,
	linux-input@vger.kernel.org, Miguel Ojeda <ojeda@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>, linux-ext4@vger.kernel.org,
	netfilter-devel@vger.kernel.org, linux-media@vger.kernel.org,
	Kees Cook <keescook@chromium.org>, selinux@vger.kernel.org,
	linux-arm-msm@vger.kernel.org, intel-gfx@lists.freedesktop.org,
	linux-sctp@vger.kernel.org, reiserfs-devel@vger.kernel.org,
	linux-geode@lists.infradead.org, linux-block@vger.kernel.org,
	linux-gpio@vger.kernel.org, op-tee@lists.trustedfirmware.org,
	linux-mediatek@lists.infradead.org,
	xen-devel@lists.xenproject.org, drbd-dev@tron.linbit.com,
	linux-hams@vger.kernel.org, Nathan Chancellor <natechancellor@gmail.com>,
	linux-can@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	linux-hwmon@vger.kernel.org, Nick Desaulniers <ndesaulniers@google.com>,
	linux-nfs@vger.kernel.org, GR-Linux-NIC-Dev@marvell.com,
	nouveau@lists.freedesktop.org, netdev@vger.kernel.org,
	linux-decnet-user@lists.sourceforge.net,
	samba-technical@lists.samba.org, linux-kernel@vger.kernel.org,
	linux-renesas-soc@vger.kernel.org, linux-security-module@vger.kernel.org,
	target-devel@vger.kernel.org, tipc-discussion@lists.sourceforge.net,
	linux-crypto@vger.kernel.org, patches@opensource.cirrus.com,
	Joe Perches <joe@perches.com>, linux-integrity@vger.kernel.org,
	linux-usb@vger.kernel.org, x86@kernel.org, linux-hardening@vger.kernel.org
Subject: Re: [dm-devel] [PATCH 000/141] Fix fall-through warnings for Clang
X-BeenThere: dm-devel@redhat.com
X-Mailman-Version: 2.1.12
Precedence: junk
List-Id: device-mapper development <dm-devel.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Hi James.

> > > If none of the 140 patches here fix a real bug, and there is no
> > > change to machine code then it sounds to me like a W=2 kind of a
> > > warning.
> > 
> > FWIW, this series has found at least one bug so far:
> > https://lore.kernel.org/lkml/CAFCwf11izHF=g1mGry1fE5kvFFFrxzhPSM6qKAO8gxSp=Kr_CQ@mail.gmail.com/
> 
> 
> Well, it's a problem in an error leg, sure, but it's not a really
> compelling reason for a 141 patch series, is it?  All that fixing this
> error will do is get the driver to print "oh dear there's a problem"
> under four more conditions than it previously did.

You are asking the wrong question here.

Yuo should ask  how many hours could have been saved by all the bugs
people have been fighting with and then fixed *before* the code
hit the kernel at all.

My personal experience is that I, more than once, have had errors
related to a missing break in my code. So this warnings is IMO a win.

And if we are only ~100 patches to have it globally enabled then it is a
no-brainer in my book.

	Sam

--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel

