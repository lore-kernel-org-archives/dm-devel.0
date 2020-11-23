Return-Path: <SRS0=MhoS=E6=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.0 required=3.0 tests=BAYES_00,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3A5CFC56201
	for <dm-devel@archiver.kernel.org>; Tue, 24 Nov 2020 08:54:41 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 806152073C
	for <dm-devel@archiver.kernel.org>; Tue, 24 Nov 2020 08:54:40 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 806152073C
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-27-HUNUVQj2MGmOuHF-dm4vPw-1; Tue, 24 Nov 2020 03:54:37 -0500
X-MC-Unique: HUNUVQj2MGmOuHF-dm4vPw-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 1F8D9100C602;
	Tue, 24 Nov 2020 08:54:32 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id F2A715D705;
	Tue, 24 Nov 2020 08:54:31 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id C5FB21809CA4;
	Tue, 24 Nov 2020 08:54:31 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com
	[10.11.54.3])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 0ANGPBLZ019103 for <dm-devel@listman.util.phx.redhat.com>;
	Mon, 23 Nov 2020 11:25:11 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id E95ED112C261; Mon, 23 Nov 2020 16:25:10 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast06.extmail.prod.ext.rdu2.redhat.com [10.11.55.22])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id E5414112C243
	for <dm-devel@redhat.com>; Mon, 23 Nov 2020 16:25:08 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [205.139.110.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 9065C186E122
	for <dm-devel@redhat.com>; Mon, 23 Nov 2020 16:25:08 +0000 (UTC)
Received: from mail-ot1-f66.google.com (mail-ot1-f66.google.com
	[209.85.210.66]) (Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-410-rYguESr9Pf6GosfW0txP8w-1; Mon, 23 Nov 2020 11:25:03 -0500
X-MC-Unique: rYguESr9Pf6GosfW0txP8w-1
Received: by mail-ot1-f66.google.com with SMTP id h19so3802617otr.1;
	Mon, 23 Nov 2020 08:25:03 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=1e100.net; s=20161025;
	h=x-gm-message-state:mime-version:references:in-reply-to:from:date
	:message-id:subject:to:cc;
	bh=SWzdE85KMSmQ5K6aYMgWVQjn8/tst2VI3dLUnv/55SM=;
	b=hwe5DwryUAKXqogXOaM1Cm0R0d66x72VzToc/Cg4uWOBBVkM+7q6t58M4kCHR5nECq
	/hMEdt0lXCSNcinn9enL31a52iuEXc1XDhVXjWFbBGT4cO/+wndnwWBXBvtZ+KbnED/0
	Uq2J0jhwuZjYM8w9x3d5a0VZVMguWc5JPd/3fUz70ORzvrGOPcHZeHXdflqKgLnhKyWk
	FOca3TUqKy6zWGs8SJPKx2y7TCuTjdVRnlsUEZtR4wU64/zFWoc+CCkemImR0OzBK4j6
	OrJ+2+EC3GHYYf4kA38RP64YlfVpQN0GADURTQ8YMn5wTDSRuDxnL/pD69PCyaoc6ydm
	vT4Q==
X-Gm-Message-State: AOAM533Ygts28/R4F6WalpW3kkTQ2CAm6HXOr/c/KVsOBB7Ojs1JDwaG
	pdmopY9A6gfAKY/GPhasZlc7z90geEeqiL7cDcQ=
X-Google-Smtp-Source: ABdhPJxW9u67TbnPp8ObIChv5a6F+ncd8SoV+BFvs894Bl4MJzyAX0TVAjkpawJr+z1OvIzzPyEcIsCefAg0WelXSFg=
X-Received: by 2002:a9d:16f:: with SMTP id 102mr68959otu.206.1606148702991;
	Mon, 23 Nov 2020 08:25:02 -0800 (PST)
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
In-Reply-To: <fc45750b6d0277c401015b7aa11e16cd15f32ab2.camel@HansenPartnership.com>
From: "Rafael J. Wysocki" <rafael@kernel.org>
Date: Mon, 23 Nov 2020 17:24:51 +0100
Message-ID: <CAJZ5v0jJ6GFm4LFCR2V3qvD9rZrVw=pXyXSjSWPYtQudg-F3xg@mail.gmail.com>
To: James Bottomley <James.Bottomley@hansenpartnership.com>
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
X-Mailman-Approved-At: Tue, 24 Nov 2020 03:53:49 -0500
Cc: "moderated list:SOUND - SOC LAYER / DYNAMIC AUDIO POWER MANAGEM..."
	<alsa-devel@alsa-project.org>, linux-atm-general@lists.sourceforge.net,
	reiserfs-devel@vger.kernel.org, nouveau <nouveau@lists.freedesktop.org>,
	linux-iio@vger.kernel.org, linux-wireless <linux-wireless@vger.kernel.org>,
	"open list:FRAMEBUFFER LAYER" <linux-fbdev@vger.kernel.org>,
	dri-devel <dri-devel@lists.freedesktop.org>,
	linux-kernel <linux-kernel@vger.kernel.org>,
	Nathan Chancellor <natechancellor@gmail.com>,
	"open list:LIBATA SUBSYSTEM \(Serial and Parallel ATA drivers\)"
	<linux-ide@vger.kernel.org>, dm-devel@redhat.com,
	keyrings@vger.kernel.org, linux-mtd@lists.infradead.org,
	GR-everest-linux-l2@marvell.com, wcn36xx@lists.infradead.org,
	samba-technical@lists.samba.org, linux-i3c@lists.infradead.org,
	linux1394-devel@lists.sourceforge.net, linux-afs@lists.infradead.org,
	usb-storage@lists.one-eyed-alien.net,
	linux-watchdog@vger.kernel.org, devel@driverdev.osuosl.org,
	linux-cifs@vger.kernel.org, rds-devel@oss.oracle.com,
	Nick Desaulniers <ndesaulniers@google.com>,
	"open list:TARGET SUBSYSTEM" <linux-scsi@vger.kernel.org>,
	linux-rdma@vger.kernel.org, oss-drivers@netronome.com,
	bridge@lists.linux-foundation.org, linux-security-module@vger.kernel.org,
	amd-gfx list <amd-gfx@lists.freedesktop.org>,
	linux-stm32@st-md-mailman.stormreply.com, cluster-devel@redhat.com,
	ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
	coreteam@netfilter.org, intel-wired-lan@lists.osuosl.org,
	linux-input <linux-input@vger.kernel.org>, Miguel Ojeda <ojeda@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Ext4 Developers List <linux-ext4@vger.kernel.org>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Kees Cook <keescook@chromium.org>, selinux@vger.kernel.org,
	linux-arm-msm <linux-arm-msm@vger.kernel.org>,
	intel-gfx <intel-gfx@lists.freedesktop.org>,
	linux-geode@lists.infradead.org, linux-can@vger.kernel.org,
	linux-block@vger.kernel.org, linux-gpio@vger.kernel.org,
	op-tee@lists.trustedfirmware.org, "moderated list:ARM/Mediatek SoC..."
	<linux-mediatek@lists.infradead.org>,
	xen-devel@lists.xenproject.org, drbd-dev@tron.linbit.com,
	linux-hams@vger.kernel.org, ceph-devel@vger.kernel.org,
	virtualization@lists.linux-foundation.org, target-devel@vger.kernel.org,
	Linux ARM <linux-arm-kernel@lists.infradead.org>,
	linux-hwmon@vger.kernel.org,
	"maintainer:X86 ARCHITECTURE \(32-BIT AND 64-BIT\)" <x86@kernel.org>,
	linux-nfs@vger.kernel.org, GR-Linux-NIC-Dev@marvell.com,
	tipc-discussion@lists.sourceforge.net, Linux-MM <linux-mm@kvack.org>,
	Network Development <netdev@vger.kernel.org>,
	linux-decnet-user@lists.sourceforge.net,
	linux-mmc <linux-mmc@vger.kernel.org>,
	"Gustavo A. R. Silva" <gustavoars@kernel.org>,
	Linux-Renesas <linux-renesas-soc@vger.kernel.org>,
	Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>, linux-sctp@vger.kernel.org,
	"open list:ULTRA-WIDEBAND \(UWB\) SUBSYSTEM:"
	<linux-usb@vger.kernel.org>, netfilter-devel@vger.kernel.org,
	Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
	patches@opensource.cirrus.com, Joe Perches <joe@perches.com>,
	linux-integrity@vger.kernel.org, linux-hardening@vger.kernel.org
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Mon, Nov 23, 2020 at 4:58 PM James Bottomley
<James.Bottomley@hansenpartnership.com> wrote:
>
> On Mon, 2020-11-23 at 15:19 +0100, Miguel Ojeda wrote:
> > On Sun, Nov 22, 2020 at 11:36 PM James Bottomley
> > <James.Bottomley@hansenpartnership.com> wrote:

[cut]

> >
> > Maintainers routinely review 1-line trivial patches, not to mention
> > internal API changes, etc.
>
> We're also complaining about the inability to recruit maintainers:
>
> https://www.theregister.com/2020/06/30/hard_to_find_linux_maintainers_says_torvalds/
>
> And burn out:
>
> http://antirez.com/news/129

Right.

> The whole crux of your argument seems to be maintainers' time isn't
> important so we should accept all trivial patches ... I'm pushing back
> on that assumption in two places, firstly the valulessness of the time
> and secondly that all trivial patches are valuable.
>
> > If some company does not want to pay for that, that's fine, but they
> > don't get to be maintainers and claim `Supported`.
>
> What I'm actually trying to articulate is a way of measuring value of
> the patch vs cost ... it has nothing really to do with who foots the
> actual bill.
>
> One thesis I'm actually starting to formulate is that this continual
> devaluing of maintainers is why we have so much difficulty keeping and
> recruiting them.

Absolutely.

This is just one of the factors involved, but a significant one IMV.

--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel

