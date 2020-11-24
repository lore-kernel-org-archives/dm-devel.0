Return-Path: <SRS0=8HMs=E7=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A0B92C5519F
	for <dm-devel@archiver.kernel.org>; Wed, 25 Nov 2020 07:17:06 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [63.128.21.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id ED8D6208B8
	for <dm-devel@archiver.kernel.org>; Wed, 25 Nov 2020 07:17:05 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org ED8D6208B8
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=telegraphics.com.au
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-386-IpG9nC1ePZuKMfQv7kCMqw-1; Wed, 25 Nov 2020 02:17:02 -0500
X-MC-Unique: IpG9nC1ePZuKMfQv7kCMqw-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 7FE9B80B727;
	Wed, 25 Nov 2020 07:16:58 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 6097D60C8A;
	Wed, 25 Nov 2020 07:16:58 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 3021D1809CA5;
	Wed, 25 Nov 2020 07:16:58 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
	[10.11.54.4])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 0AOMOISD027560 for <dm-devel@listman.util.phx.redhat.com>;
	Tue, 24 Nov 2020 17:24:18 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 7D5812026D25; Tue, 24 Nov 2020 22:24:18 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast04.extmail.prod.ext.rdu2.redhat.com [10.11.55.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 7900C2026D46
	for <dm-devel@redhat.com>; Tue, 24 Nov 2020 22:24:16 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[205.139.110.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 509CA103B805
	for <dm-devel@redhat.com>; Tue, 24 Nov 2020 22:24:16 +0000 (UTC)
Received: from kvm5.telegraphics.com.au (kvm5.telegraphics.com.au
	[98.124.60.144]) by relay.mimecast.com with ESMTP id
	us-mta-534-IuYTrcytPLKTMNXSzNqBkQ-1; Tue, 24 Nov 2020 17:24:13 -0500
X-MC-Unique: IuYTrcytPLKTMNXSzNqBkQ-1
Received: from localhost (localhost.localdomain [127.0.0.1])
	by kvm5.telegraphics.com.au (Postfix) with ESMTP id 8A96E22AD6;
	Tue, 24 Nov 2020 17:24:09 -0500 (EST)
Date: Wed, 25 Nov 2020 09:24:08 +1100 (AEDT)
From: Finn Thain <fthain@telegraphics.com.au>
To: Kees Cook <keescook@chromium.org>
In-Reply-To: <202011241327.BB28F12F6@keescook>
Message-ID: <alpine.LNX.2.23.453.2011250859290.15@nippy.intranet>
References: <202011201129.B13FDB3C@keescook>
	<20201120115142.292999b2@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
	<202011220816.8B6591A@keescook>
	<9b57fd4914b46f38d54087d75e072d6e947cb56d.camel@HansenPartnership.com>
	<ca071decb87cc7e905411423c05a48f9fd2f58d7.camel@perches.com>
	<0147972a72bc13f3629de8a32dee6f1f308994b5.camel@HansenPartnership.com>
	<d8d1e9add08cdd4158405e77762d4946037208f8.camel@perches.com>
	<dbd2cb703ed9eefa7dde9281ea26ab0f7acc8afe.camel@HansenPartnership.com>
	<20201123130348.GA3119@embeddedor>
	<8f5611bb015e044fa1c0a48147293923c2d904e4.camel@HansenPartnership.com>
	<202011241327.BB28F12F6@keescook>
MIME-Version: 1.0
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.4
X-loop: dm-devel@redhat.com
X-Mailman-Approved-At: Wed, 25 Nov 2020 02:15:21 -0500
Cc: alsa-devel@alsa-project.org, bridge@lists.linux-foundation.org,
	target-devel@vger.kernel.org,
	Greg KH <gregkh@linuxfoundation.org>, linux-iio@vger.kernel.org,
	linux-wireless@vger.kernel.org, linux-mmc@vger.kernel.org,
	linux-fbdev@vger.kernel.org, dri-devel@lists.freedesktop.org,
	"Gustavo A. R. Silva" <gustavoars@kernel.org>,
	James Bottomley <James.Bottomley@HansenPartnership.com>,
	linux-ide@vger.kernel.org, dm-devel@redhat.com,
	keyrings@vger.kernel.org, linux-mtd@lists.infradead.org,
	GR-everest-linux-l2@marvell.com, wcn36xx@lists.infradead.org,
	linux-i3c@lists.infradead.org, linux1394-devel@lists.sourceforge.net,
	linux-afs@lists.infradead.org, devel@driverdev.osuosl.org,
	linux-cifs@vger.kernel.org, rds-devel@oss.oracle.com,
	linux-scsi@vger.kernel.org, linux-acpi@vger.kernel.org,
	linux-rdma@vger.kernel.org, oss-drivers@netronome.com,
	linux-atm-general@lists.sourceforge.net,
	ceph-devel@vger.kernel.org, amd-gfx@lists.freedesktop.org,
	linux-stm32@st-md-mailman.stormreply.com,
	cluster-devel@redhat.com, usb-storage@lists.one-eyed-alien.net,
	coreteam@netfilter.org, intel-wired-lan@lists.osuosl.org,
	linux-input@vger.kernel.org, Miguel Ojeda <ojeda@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>, linux-ext4@vger.kernel.org,
	virtualization@lists.linux-foundation.org, linux-mm@kvack.org,
	linux-media@vger.kernel.org, linux-watchdog@vger.kernel.org,
	selinux@vger.kernel.org, linux-arm-msm@vger.kernel.org,
	intel-gfx@lists.freedesktop.org, linux-sctp@vger.kernel.org,
	reiserfs-devel@vger.kernel.org, linux-geode@lists.infradead.org,
	linux-block@vger.kernel.org, linux-gpio@vger.kernel.org,
	op-tee@lists.trustedfirmware.org, linux-mediatek@lists.infradead.org,
	xen-devel@lists.xenproject.org, drbd-dev@tron.linbit.com,
	linux-hams@vger.kernel.org, Nathan Chancellor <natechancellor@gmail.com>,
	linux-can@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	linux-hwmon@vger.kernel.org, Nick Desaulniers <ndesaulniers@google.com>,
	linux-nfs@vger.kernel.org, GR-Linux-NIC-Dev@marvell.com,
	nouveau@lists.freedesktop.org, netdev@vger.kernel.org,
	linux-decnet-user@lists.sourceforge.net,
	samba-technical@lists.samba.org, linux-kernel@vger.kernel.org,
	linux-renesas-soc@vger.kernel.org,
	linux-security-module@vger.kernel.org, linux-usb@vger.kernel.org,
	tipc-discussion@lists.sourceforge.net, linux-crypto@vger.kernel.org,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	patches@opensource.cirrus.com, Joe Perches <joe@perches.com>,
	netfilter-devel@vger.kernel.org, linux-integrity@vger.kernel.org,
	x86@kernel.org, linux-hardening@vger.kernel.org
Subject: Re: [dm-devel] [Intel-wired-lan] [PATCH 000/141] Fix fall-through
 warnings for Clang
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Tue, 24 Nov 2020, Kees Cook wrote:

> On Mon, Nov 23, 2020 at 08:31:30AM -0800, James Bottomley wrote:
> > Really, no ... something which produces no improvement has no value at 
> > all ... we really shouldn't be wasting maintainer time with it because 
> > it has a cost to merge.  I'm not sure we understand where the balance 
> > lies in value vs cost to merge but I am confident in the zero value 
> > case.
> 
> What? We can't measure how many future bugs aren't introduced because 
> the kernel requires explicit case flow-control statements for all new 
> code.
> 

These statements are not "missing" unless you presume that code written 
before the latest de facto language spec was written should somehow be 
held to that spec.

If the 'fallthrough' statement is not part of the latest draft spec then 
we should ask why not before we embrace it. Being that the kernel still 
prefers -std=gnu89 you might want to consider what has prevented 
-std=gnu99 or -std=gnu2x etc.

> We already enable -Wimplicit-fallthrough globally, so that's not the 
> discussion. The issue is that Clang is (correctly) even more strict than 
> GCC for this, so these are the remaining ones to fix for full Clang 
> coverage too.
> 

Seems to me you should be patching the compiler.

When you have consensus among the language lawyers you'll have more 
credibility with those being subjected to enforcement.

--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel

