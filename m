Return-Path: <SRS0=8HMs=E7=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 40A52C5519F
	for <dm-devel@archiver.kernel.org>; Wed, 25 Nov 2020 07:16:13 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 93ADB208B8
	for <dm-devel@archiver.kernel.org>; Wed, 25 Nov 2020 07:16:12 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 93ADB208B8
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=chromium.org
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-417-2hqTXCG8Nz26nw4vu40xZw-1; Wed, 25 Nov 2020 02:16:08 -0500
X-MC-Unique: 2hqTXCG8Nz26nw4vu40xZw-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id ACBF11009462;
	Wed, 25 Nov 2020 07:16:03 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 84A5810021B3;
	Wed, 25 Nov 2020 07:16:03 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 2B8471809CA0;
	Wed, 25 Nov 2020 07:16:03 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com
	[10.11.54.3])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 0AOLWr1b022358 for <dm-devel@listman.util.phx.redhat.com>;
	Tue, 24 Nov 2020 16:32:53 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id A0185110F0BA; Tue, 24 Nov 2020 21:32:53 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast05.extmail.prod.ext.rdu2.redhat.com [10.11.55.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 9C4B3110F0A2
	for <dm-devel@redhat.com>; Tue, 24 Nov 2020 21:32:51 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [207.211.31.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 4882A803DD6
	for <dm-devel@redhat.com>; Tue, 24 Nov 2020 21:32:51 +0000 (UTC)
Received: from mail-pg1-f193.google.com (mail-pg1-f193.google.com
	[209.85.215.193]) (Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-453-6mQR6DIqNquJeCn5Hkub5g-1; Tue, 24 Nov 2020 16:32:47 -0500
X-MC-Unique: 6mQR6DIqNquJeCn5Hkub5g-1
Received: by mail-pg1-f193.google.com with SMTP id m9so376680pgb.4
	for <dm-devel@redhat.com>; Tue, 24 Nov 2020 13:32:47 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=1e100.net; s=20161025;
	h=x-gm-message-state:date:from:to:cc:subject:message-id:references
	:mime-version:content-disposition:in-reply-to;
	bh=nUebvx46WK355IC8BSYKhA86maU/C5TyOra9y/oS07E=;
	b=JLd20bteD/nyUXiixgzapqFDv+qnya8bVZwBrDKC/p+1AGytpwNuAWJ2N2QA8kBNBq
	l9euFHUUjafL9+DMmw/Lu7Hmithw7cRQ+qBXl2Nf2/ObgciEuc7E/rBDnGmIeu2gkpPl
	M8iXyaKwisITCj10K3aeG9LfxaD23wuQ16O9CTAMjjZKz0IFCTZznM494JWt+DefOvPx
	Ft83NqEvVT1r3dlurVkUj4J9MOi6moX/CB6nidWMoDO+HMTcqQStk0QYM09bqaKlmfDb
	n6Lb9w2j5GjxobCzBi1eefOZwhx2vN+qiqQpX5pdHxfHQ8cOBNfNVzxgDr0OX8aP+Xsh
	gE6g==
X-Gm-Message-State: AOAM532TyHSHEeFNX23m41aPSFT0wVeE4fGWf6Hcqbs5oBR51tud8l7x
	tnYij6aVCfgAcUFLZ9AcNc5MvA==
X-Google-Smtp-Source: ABdhPJxq53hoH5g966jwbYjUDwfs6lHQ9KOfN5qCJ8fiAFBBjxy/+X2rEoTmF5zSw2rlwmYa8QmuBA==
X-Received: by 2002:aa7:9af2:0:b029:198:273c:6be8 with SMTP id
	y18-20020aa79af20000b0290198273c6be8mr329847pfp.4.1606253566848;
	Tue, 24 Nov 2020 13:32:46 -0800 (PST)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
	by smtp.gmail.com with ESMTPSA id j74sm15845pfd.43.2020.11.24.13.32.45
	(version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
	Tue, 24 Nov 2020 13:32:45 -0800 (PST)
Date: Tue, 24 Nov 2020 13:32:44 -0800
From: Kees Cook <keescook@chromium.org>
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Message-ID: <202011241327.BB28F12F6@keescook>
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
MIME-Version: 1.0
In-Reply-To: <8f5611bb015e044fa1c0a48147293923c2d904e4.camel@HansenPartnership.com>
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
X-Mailman-Approved-At: Wed, 25 Nov 2020 02:15:21 -0500
Cc: alsa-devel@alsa-project.org, bridge@lists.linux-foundation.org,
	target-devel@vger.kernel.org,
	Greg KH <gregkh@linuxfoundation.org>, linux-iio@vger.kernel.org,
	samba-technical@lists.samba.org, linux-mmc@vger.kernel.org,
	linux-fbdev@vger.kernel.org, dri-devel@lists.freedesktop.org,
	"Gustavo A. R. Silva" <gustavoars@kernel.org>,
	linux-mm@kvack.org, linux-ide@vger.kernel.org,
	dm-devel@redhat.com, keyrings@vger.kernel.org,
	linux-mtd@lists.infradead.org, GR-everest-linux-l2@marvell.com,
	wcn36xx@lists.infradead.org, linux-i3c@lists.infradead.org,
	linux1394-devel@lists.sourceforge.net,
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
	virtualization@lists.linux-foundation.org,
	netfilter-devel@vger.kernel.org, linux-media@vger.kernel.org,
	linux-watchdog@vger.kernel.org, selinux@vger.kernel.org,
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
	linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-renesas-soc@vger.kernel.org,
	linux-security-module@vger.kernel.org, linux-usb@vger.kernel.org,
	tipc-discussion@lists.sourceforge.net, linux-crypto@vger.kernel.org,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	patches@opensource.cirrus.com, Joe Perches <joe@perches.com>,
	linux-integrity@vger.kernel.org, x86@kernel.org,
	linux-hardening@vger.kernel.org
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
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Mon, Nov 23, 2020 at 08:31:30AM -0800, James Bottomley wrote:
> Really, no ... something which produces no improvement has no value at
> all ... we really shouldn't be wasting maintainer time with it because
> it has a cost to merge.  I'm not sure we understand where the balance
> lies in value vs cost to merge but I am confident in the zero value
> case.

What? We can't measure how many future bugs aren't introduced because the
kernel requires explicit case flow-control statements for all new code.

We already enable -Wimplicit-fallthrough globally, so that's not the
discussion. The issue is that Clang is (correctly) even more strict
than GCC for this, so these are the remaining ones to fix for full Clang
coverage too.

People have spent more time debating this already than it would have
taken to apply the patches. :)

This is about robustness and language wrangling. It's a big code-base,
and this is the price of our managing technical debt for permanent
robustness improvements. (The numbers I ran from Gustavo's earlier
patches were that about 10% of the places adjusted were identified as
legitimate bugs being fixed. This final series may be lower, but there
are still bugs being found from it -- we need to finish this and shut
the door on it for good.)

-- 
Kees Cook

--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel

