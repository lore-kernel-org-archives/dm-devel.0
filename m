Return-Path: <SRS0=MhoS=E6=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 45FA8C56201
	for <dm-devel@archiver.kernel.org>; Tue, 24 Nov 2020 08:54:24 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [63.128.21.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 7B5302073C
	for <dm-devel@archiver.kernel.org>; Tue, 24 Nov 2020 08:54:23 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 7B5302073C
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=perches.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-496-l0l9WHl7P3yLovwwD7SVIg-1; Tue, 24 Nov 2020 03:54:18 -0500
X-MC-Unique: l0l9WHl7P3yLovwwD7SVIg-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id A75E718C43DE;
	Tue, 24 Nov 2020 08:54:13 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 8A0995D71D;
	Tue, 24 Nov 2020 08:54:13 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 5FB8E4E590;
	Tue, 24 Nov 2020 08:54:13 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com
	[10.11.54.3])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 0ANGX2pF020245 for <dm-devel@listman.util.phx.redhat.com>;
	Mon, 23 Nov 2020 11:33:02 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 05EB1112C261; Mon, 23 Nov 2020 16:33:02 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast03.extmail.prod.ext.rdu2.redhat.com [10.11.55.19])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 028511031F5F
	for <dm-devel@redhat.com>; Mon, 23 Nov 2020 16:32:59 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [205.139.110.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id C50EB811E9F
	for <dm-devel@redhat.com>; Mon, 23 Nov 2020 16:32:59 +0000 (UTC)
Received: from smtprelay.hostedemail.com (smtprelay0092.hostedemail.com
	[216.40.44.92]) (Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-208-9u3T3Sk8OYaUkTBlnyt1VA-1; Mon, 23 Nov 2020 11:32:55 -0500
X-MC-Unique: 9u3T3Sk8OYaUkTBlnyt1VA-1
Received: from filter.hostedemail.com (clb03-v110.bra.tucows.net
	[216.40.38.60])
	by smtprelay07.hostedemail.com (Postfix) with ESMTP id A722B181D3025;
	Mon, 23 Nov 2020 16:32:53 +0000 (UTC)
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-HE-Tag: can43_5c1502d27366
X-Filterd-Recvd-Size: 5503
Received: from XPS-9350.home (unknown [47.151.128.180])
	(Authenticated sender: joe@perches.com)
	by omf03.hostedemail.com (Postfix) with ESMTPA;
	Mon, 23 Nov 2020 16:32:42 +0000 (UTC)
Message-ID: <32dc7423124b51da4e144e931bf099a368ab50a8.camel@perches.com>
From: Joe Perches <joe@perches.com>
To: James Bottomley <James.Bottomley@HansenPartnership.com>, Miguel Ojeda
	<miguel.ojeda.sandonis@gmail.com>
Date: Mon, 23 Nov 2020 08:32:41 -0800
In-Reply-To: <fc45750b6d0277c401015b7aa11e16cd15f32ab2.camel@HansenPartnership.com>
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
User-Agent: Evolution 3.38.1-1
MIME-Version: 1.0
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
Cc: alsa-devel@alsa-project.org, linux-atm-general@lists.sourceforge.net,
	reiserfs-devel@vger.kernel.org, nouveau@lists.freedesktop.org,
	linux-iio@vger.kernel.org, linux-wireless <linux-wireless@vger.kernel.org>,
	linux-fbdev@vger.kernel.org, dri-devel@lists.freedesktop.org,
	"Gustavo A. R. Silva" <gustavoars@kernel.org>,
	Nathan Chancellor <natechancellor@gmail.com>,
	linux-ide@vger.kernel.org, dm-devel@redhat.com,
	keyrings@vger.kernel.org, linux-mtd@lists.infradead.org,
	GR-everest-linux-l2@marvell.com, Linux,
	samba-technical@lists.samba.org, linux-i3c@lists.infradead.org,
	linux1394-devel@lists.sourceforge.net, linux-afs@lists.infradead.org,
	usb-storage@lists.one-eyed-alien.net,
	linux-watchdog@vger.kernel.org, devel@driverdev.osuosl.org,
	linux-cifs@vger.kernel.org, rds-devel@oss.oracle.com,
	Desaulniers <ndesaulniers@google.com>,
	linux-scsi@vger.kernel.org, Nick, linux-rdma@vger.kernel.org,
	oss-drivers@netronome.com, bridge@lists.linux-foundation.org,
	linux-security-module@vger.kernel.org, amd-gfx@lists.freedesktop.org,
	linux-stm32@st-md-mailman.stormreply.com,
	cluster-devel@redhat.com, linux-acpi@vger.kernel.org,
	coreteam@netfilter.org, intel-wired-lan@lists.osuosl.org,
	linux-input <linux-input@vger.kernel.org>, Miguel Ojeda <ojeda@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Ext4 Developers List <linux-ext4@vger.kernel.org>,
	Media Mailing List <linux-media@vger.kernel.org>,
	Kees Cook <keescook@chromium.org>, selinux@vger.kernel.org,
	linux-arm-msm@vger.kernel.org, intel-gfx@lists.freedesktop.org,
	linux-geode@lists.infradead.org, linux-can@vger.kernel.org,
	linux-block@vger.kernel.org, linux-gpio@vger.kernel.org,
	op-tee@lists.trustedfirmware.org, linux-mediatek@lists.infradead.org,
	xen-devel@lists.xenproject.org, drbd-dev@tron.linbit.com,
	linux-hams@vger.kernel.org, ceph-devel@vger.kernel.org,
	virtualization@lists.linux-foundation.org, target-devel@vger.kernel.org,
	Linux ARM <linux-arm-kernel@lists.infradead.org>,
	linux-hwmon@vger.kernel.org,
	"maintainer:X86 ARCHITECTURE \(32-BIT AND 64-BIT\)" <x86@kernel.org>,
	linux-nfs@vger.kernel.org, GR-Linux-NIC-Dev@marvell.com,
	tipc-discussion@lists.sourceforge.net, Linux-MM <linux-mm@kvack.org>,
	Network Development <netdev@vger.kernel.org>,
	linux-decnet-user@lists.sourceforge.net, linux-mmc@vger.kernel.org,
	linux-kernel <linux-kernel@vger.kernel.org>,
	linux-renesas-soc@vger.kernel.org, linux-sctp@vger.kernel.org,
	linux-usb@vger.kernel.org, netfilter-devel@vger.kernel.org,
	List <linux-crypto@vger.kernel.org>,
	patches@opensource.cirrus.com, linux-integrity@vger.kernel.org,
	wcn36xx@lists.infradead.org, linux-hardening@vger.kernel.org
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

On Mon, 2020-11-23 at 07:58 -0800, James Bottomley wrote:
> We're also complaining about the inability to recruit maintainers:
> 
> https://www.theregister.com/2020/06/30/hard_to_find_linux_maintainers_says_torvalds/
> 
> And burn out:
> 
> http://antirez.com/news/129

https://www.wired.com/story/open-source-coders-few-tired/

> What I'm actually trying to articulate is a way of measuring value of
> the patch vs cost ... it has nothing really to do with who foots the
> actual bill.

It's unclear how to measure value in consistency.

But one way that costs can be reduced is by automation and _not_
involving maintainers when the patch itself is provably correct.

> One thesis I'm actually starting to formulate is that this continual
> devaluing of maintainers is why we have so much difficulty keeping and
> recruiting them.

The linux kernel has something like 1500 different maintainers listed
in the MAINTAINERS file.  That's not a trivial number.

$ git grep '^M:' MAINTAINERS | sort | uniq -c | wc -l
1543
$ git grep '^M:' MAINTAINERS| cut -f1 -d'<' | sort | uniq -c | wc -l
1446

I think the question you are asking is about trust and how it
effects development.

And back to that wired story, the actual number of what you might
be considering to be maintainers is likely less than 10% of the
listed numbers above.


--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel

