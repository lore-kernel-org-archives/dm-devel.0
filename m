Return-Path: <SRS0=s6zu=FE=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 12F89C63777
	for <dm-devel@archiver.kernel.org>; Mon, 30 Nov 2020 07:02:52 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 0D6A9206CB
	for <dm-devel@archiver.kernel.org>; Mon, 30 Nov 2020 07:02:50 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 0D6A9206CB
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=linux-m68k.org
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-65-acX0DUkPO6yeCjSVciSebA-1; Mon, 30 Nov 2020 02:02:47 -0500
X-MC-Unique: acX0DUkPO6yeCjSVciSebA-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id B0F48106B359;
	Mon, 30 Nov 2020 07:02:42 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 7D79D60843;
	Mon, 30 Nov 2020 07:02:42 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 41C79180954D;
	Mon, 30 Nov 2020 07:02:40 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
	[10.11.54.5])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 0AQFSUDn017525 for <dm-devel@listman.util.phx.redhat.com>;
	Thu, 26 Nov 2020 10:28:30 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 6D5DBC77D9; Thu, 26 Nov 2020 15:28:30 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast05.extmail.prod.ext.rdu2.redhat.com [10.11.55.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 6801DC77CB
	for <dm-devel@redhat.com>; Thu, 26 Nov 2020 15:28:27 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[205.139.110.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 5C2DE800889
	for <dm-devel@redhat.com>; Thu, 26 Nov 2020 15:28:27 +0000 (UTC)
Received: from mail-ot1-f68.google.com (mail-ot1-f68.google.com
	[209.85.210.68]) (Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-354-IOnJUUUXMPqm_ond6Ag3Lw-1; Thu, 26 Nov 2020 10:28:24 -0500
X-MC-Unique: IOnJUUUXMPqm_ond6Ag3Lw-1
Received: by mail-ot1-f68.google.com with SMTP id o3so2160474ota.8;
	Thu, 26 Nov 2020 07:28:24 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=1e100.net; s=20161025;
	h=x-gm-message-state:mime-version:references:in-reply-to:from:date
	:message-id:subject:to:cc;
	bh=kP9MspVOPl/NnVl8oGn1EIC/+F8CcK5+OXo+jY56Nno=;
	b=V0t4YwuCvRmHxMAlG4LvThLMvBLTqGR9Kok2MP+oB1xi/r5PUj9BIO0o3rV3FzFHwD
	qcGwj4DsJ7CyKlKbOHQvFW+3/SgPrWhgbhXXgw4KZAqZ1VQpi9scEJSQ5/jqB8FGn6lr
	qPTWV6dfC8aWEmTDWf3/KmvkTxNq8PZc7TlKzCZOPbPys9FzNWI1vLw01DoiJ8uKUXk9
	0p6JLkL6kwBhBHkMWvkosG0npy+W80jdJYmzJ8ASpYkCDHq1Le52AuMe0H4yeiIGFXeF
	dx+Tx6Pg0Tfef4omOlwmVz+DdcimDfEgEs2uSZcUGhyee7fjCP0vxk9qONydF0w3qJtx
	klGA==
X-Gm-Message-State: AOAM532ie6P4NRAnQfqb437LenfiKPEdPOMCFgsDtKEP7IlfheoNwNoy
	ScMUHqMtIQZJlzfS23H59y3KW31DwZAflNgZ9LY=
X-Google-Smtp-Source: ABdhPJyYtol6dSfaI6WhgTcuunq7fhBuSULViECyA4Z+K27bCejCuaia55DZ/aziu9dD69JTQZlYwW/4z6Mu7Di+rU4=
X-Received: by 2002:a05:6830:210a:: with SMTP id
	i10mr2551843otc.145.1606404504116; 
	Thu, 26 Nov 2020 07:28:24 -0800 (PST)
MIME-Version: 1.0
References: <cover.1605896059.git.gustavoars@kernel.org>
	<20201120105344.4345c14e@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
	<202011201129.B13FDB3C@keescook>
	<20201120115142.292999b2@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
	<202011220816.8B6591A@keescook>
	<9b57fd4914b46f38d54087d75e072d6e947cb56d.camel@HansenPartnership.com>
	<CANiq72nZrHWTA4_Msg6MP9snTyenC6-eGfD27CyfNSu7QoVZbw@mail.gmail.com>
	<1c7d7fde126bc0acf825766de64bf2f9b888f216.camel@HansenPartnership.com>
	<CANiq72m22Jb5_+62NnwX8xds2iUdWDMAqD8PZw9cuxdHd95W0A@mail.gmail.com>
	<fc45750b6d0277c401015b7aa11e16cd15f32ab2.camel@HansenPartnership.com>
	<CANiq72k5tpDoDPmJ0ZWc1DGqm+81Gi-uEENAtvEs9v3SZcx6_Q@mail.gmail.com>
	<4993259d01a0064f8bb22770503490f9252f3659.camel@HansenPartnership.com>
	<CANiq72kqO=bYMJnFS2uYRpgWATJ=uXxZuNUsTXT+3aLtrpnzvQ@mail.gmail.com>
	<44005bde-f6d4-5eaa-39b8-1a5efeedb2d3@gmail.com>
	<CANiq72nobq=ptWK-qWxU91JHqkKhMcRtJNnw2XJd5-vSJWZd8Q@mail.gmail.com>
In-Reply-To: <CANiq72nobq=ptWK-qWxU91JHqkKhMcRtJNnw2XJd5-vSJWZd8Q@mail.gmail.com>
From: Geert Uytterhoeven <geert@linux-m68k.org>
Date: Thu, 26 Nov 2020 16:28:12 +0100
Message-ID: <CAMuHMdV5kOakvZJMWLxbpigFPS+Xuw6DVYsWCWZy7wGsv3idcw@mail.gmail.com>
To: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
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
X-Mailman-Approved-At: Mon, 30 Nov 2020 02:02:38 -0500
Cc: ALSA Development Mailing List <alsa-devel@alsa-project.org>,
	bridge@lists.linux-foundation.org,
	target-devel <target-devel@vger.kernel.org>, linux-iio@vger.kernel.org,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Linux MMC List <linux-mmc@vger.kernel.org>,
	Linux Fbdev development list <linux-fbdev@vger.kernel.org>,
	dri-devel <dri-devel@lists.freedesktop.org>,
	virtualization@lists.linux-foundation.org,
	James Bottomley <James.Bottomley@hansenpartnership.com>,
	linux-ide@vger.kernel.org, dm-devel@redhat.com, keyrings@vger.kernel.org,
	MTD Maling List <linux-mtd@lists.infradead.org>,
	GR-everest-linux-l2@marvell.com, wcn36xx@lists.infradead.org,
	linux-i3c@lists.infradead.org, linux1394-devel@lists.sourceforge.net,
	linux-afs@lists.infradead.org,
	Linux Watchdog Mailing List <linux-watchdog@vger.kernel.org>,
	driverdevel <devel@driverdev.osuosl.org>,
	linux-cifs@vger.kernel.org, rds-devel@oss.oracle.com,
	scsi <linux-scsi@vger.kernel.org>,
	ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
	linux-rdma <linux-rdma@vger.kernel.org>, oss-drivers@netronome.com,
	linux-atm-general@lists.sourceforge.net,
	ceph-devel <ceph-devel@vger.kernel.org>,
	amd-gfx list <amd-gfx@lists.freedesktop.org>,
	linux-stm32@st-md-mailman.stormreply.com,
	cluster-devel@redhat.com, usb-storage@lists.one-eyed-alien.net,
	coreteam@netfilter.org, intel-wired-lan@lists.osuosl.org,
	linux-input <linux-input@vger.kernel.org>, Miguel Ojeda <ojeda@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Ext4 Developers List <linux-ext4@vger.kernel.org>,
	Linux-MM <linux-mm@kvack.org>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Kees Cook <keescook@chromium.org>, selinux@vger.kernel.org,
	linux-arm-msm <linux-arm-msm@vger.kernel.org>,
	Intel Graphics Development <intel-gfx@lists.freedesktop.org>,
	linux-sctp@vger.kernel.org, reiserfs-devel@vger.kernel.org,
	linux-geode@lists.infradead.org, linux-block@vger.kernel.org,
	"open list:GPIO SUBSYSTEM" <linux-gpio@vger.kernel.org>,
	op-tee@lists.trustedfirmware.org, linux-mediatek@lists.infradead.org,
	xen-devel@lists.xenproject.org, Lars Ellenberg <drbd-dev@tron.linbit.com>,
	linux-hams@vger.kernel.org, Nathan Chancellor <natechancellor@gmail.com>,
	linux-can@vger.kernel.org,
	Linux ARM <linux-arm-kernel@lists.infradead.org>,
	linux-hwmon@vger.kernel.org,
	Nick Desaulniers <ndesaulniers@google.com>, "open list:NFS,
	SUNRPC, AND..." <linux-nfs@vger.kernel.org>, GR-Linux-NIC-Dev@marvell.com,
	Nouveau Dev <nouveau@lists.freedesktop.org>,
	Network Development <netdev@vger.kernel.org>,
	linux-decnet-user@lists.sourceforge.net, samba-technical@lists.samba.org,
	"Gustavo A. R. Silva" <gustavoars@kernel.org>,
	linux-kernel <linux-kernel@vger.kernel.org>,
	Linux-Renesas <linux-renesas-soc@vger.kernel.org>,
	Edward Cree <ecree.xilinx@gmail.com>,
	linux-security-module <linux-security-module@vger.kernel.org>,
	USB list <linux-usb@vger.kernel.org>,
	tipc-discussion@lists.sourceforge.net,
	Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
	patches@opensource.cirrus.com, Joe Perches <joe@perches.com>,
	NetFilter <netfilter-devel@vger.kernel.org>,
	linux-integrity <linux-integrity@vger.kernel.org>,
	"maintainer:X86 ARCHITECTURE \(32-BIT AND 64-BIT\)" <x86@kernel.org>,
	linux-hardening@vger.kernel.org
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Hi Miguel,

On Thu, Nov 26, 2020 at 3:54 PM Miguel Ojeda
<miguel.ojeda.sandonis@gmail.com> wrote:
> On Wed, Nov 25, 2020 at 11:44 PM Edward Cree <ecree.xilinx@gmail.com> wrote:
> > To make the intent clear, you have to first be certain that you
> >  understand the intent; otherwise by adding either a break or a
> >  fallthrough to suppress the warning you are just destroying the
> >  information that "the intent of this code is unknown".
>
> If you don't know what the intent of your own code is, then you
> *already* have a problem in your hands.

The maintainer is not necessarily the owner/author of the code, and
thus may not know the intent of the code.

> > or does it flag up code
> >  that can be mindlessly "fixed" (in which case the warning is
> >  worthless)?  Proponents in this thread seem to be trying to
> >  have it both ways.
>
> A warning is not worthless just because you can mindlessly fix it.
> There are many counterexamples, e.g. many
> checkpatch/lint/lang-format/indentation warnings, functional ones like
> the `if (a = b)` warning...

BTW, you cannot mindlessly fix the latter, as you cannot know if
"(a == b)" or "((a = b))" was intended, without understanding the code
(and the (possibly unavailable) data sheet, and the hardware, ...).

P.S. So far I've stayed out of this thread, as I like it if the compiler
     flags possible mistakes.  After all I was the one fixing new
     "may be used uninitialized" warnings thrown up by gcc-4.1, until
     (a bit later than) support for that compiler was removed...

Gr{oetje,eeting}s,

                        Geert

-- 
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds

--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel

