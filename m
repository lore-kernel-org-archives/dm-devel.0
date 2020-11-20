Return-Path: <SRS0=JGfJ=E5=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9994BC56202
	for <dm-devel@archiver.kernel.org>; Mon, 23 Nov 2020 08:40:38 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [63.128.21.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id E33BA2072C
	for <dm-devel@archiver.kernel.org>; Mon, 23 Nov 2020 08:40:37 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org E33BA2072C
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=chromium.org
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-160-mm-kRm2CPSiLxjuUUPCrDw-1; Mon, 23 Nov 2020 03:40:34 -0500
X-MC-Unique: mm-kRm2CPSiLxjuUUPCrDw-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 0CAC8803F60;
	Mon, 23 Nov 2020 08:40:27 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id DDD9D1A3D8;
	Mon, 23 Nov 2020 08:40:26 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id B1DFF1809CA6;
	Mon, 23 Nov 2020 08:40:26 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
	[10.11.54.4])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 0AKJUn7a022462 for <dm-devel@listman.util.phx.redhat.com>;
	Fri, 20 Nov 2020 14:30:49 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id E43542026D47; Fri, 20 Nov 2020 19:30:48 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast05.extmail.prod.ext.rdu2.redhat.com [10.11.55.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id DF6882026D49
	for <dm-devel@redhat.com>; Fri, 20 Nov 2020 19:30:46 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [205.139.110.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 7E676800157
	for <dm-devel@redhat.com>; Fri, 20 Nov 2020 19:30:46 +0000 (UTC)
Received: from mail-pf1-f194.google.com (mail-pf1-f194.google.com
	[209.85.210.194]) (Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-416-eIzhDGTzNNma_STA2jthqg-1; Fri, 20 Nov 2020 14:30:44 -0500
X-MC-Unique: eIzhDGTzNNma_STA2jthqg-1
Received: by mail-pf1-f194.google.com with SMTP id a18so8832049pfl.3
	for <dm-devel@redhat.com>; Fri, 20 Nov 2020 11:30:44 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=1e100.net; s=20161025;
	h=x-gm-message-state:date:from:to:cc:subject:message-id:references
	:mime-version:content-disposition:in-reply-to;
	bh=3bv50j9tOMZCSWAChUvUk5K6TgooTRt3SRcQZBJ9fcA=;
	b=ax8LK5gl7muKJq4bNgoxmvdHS6/oTEjmJbQLdzsK5pFksLwoH2fdA3wIHu42fllYT3
	0xNQSPk4sV7KmmpWWfcZeB6O2SMvMPplxEhG2BklDB99kZNqqZKClmvVUSwde/EpNsP4
	tRtPFhg4HO5nvKeUvhb5gIXPYILCVQHhHLqYyuxqW4eXhmGDJeXhNKMlue2otQ5RDwN2
	6RRgqUX2p/t/S+Iccw0HsgIhQWGP1Vf+sN/4Fka/ICxXfetMKKEx43tLhD/tC+nFetnC
	HlcK1R64IBPEtMN+lV1Em50w5WIlnKoKv1MZGCcoKkv2PaJTycrYMaVN5e47ryzKmO7m
	XqPA==
X-Gm-Message-State: AOAM5327lHfKPq1qws6jODPglP7akEpcJDpWLyPSy2f7c2Y0HDGOVMGa
	O7XxgJKN9t3FuKbJ1S6xhtdVDA==
X-Google-Smtp-Source: ABdhPJwl3VgOHP/MWhG5DtpaEL0Yyt6dBbRzpe/94BRgWnGkgcq6AJ5JXkZmDK0TJqDkyAhq9Y3Q+Q==
X-Received: by 2002:a63:5043:: with SMTP id q3mr17907345pgl.137.1605900643099; 
	Fri, 20 Nov 2020 11:30:43 -0800 (PST)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
	by smtp.gmail.com with ESMTPSA id
	d10sm4785681pjj.38.2020.11.20.11.30.41
	(version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
	Fri, 20 Nov 2020 11:30:41 -0800 (PST)
Date: Fri, 20 Nov 2020 11:30:40 -0800
From: Kees Cook <keescook@chromium.org>
To: Jakub Kicinski <kuba@kernel.org>
Message-ID: <202011201129.B13FDB3C@keescook>
References: <cover.1605896059.git.gustavoars@kernel.org>
	<20201120105344.4345c14e@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
MIME-Version: 1.0
In-Reply-To: <20201120105344.4345c14e@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
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
X-Mailman-Approved-At: Mon, 23 Nov 2020 03:39:39 -0500
Cc: alsa-devel@alsa-project.org, linux-atm-general@lists.sourceforge.net,
	reiserfs-devel@vger.kernel.org, nouveau@lists.freedesktop.org,
	linux-iio@vger.kernel.org, linux-wireless@vger.kernel.org,
	linux-fbdev@vger.kernel.org, dri-devel@lists.freedesktop.org,
	linux-kernel@vger.kernel.org, Nathan Chancellor <natechancellor@gmail.com>,
	linux-ide@vger.kernel.org, dm-devel@redhat.com,
	keyrings@vger.kernel.org, linux-mtd@lists.infradead.org,
	GR-everest-linux-l2@marvell.com, wcn36xx@lists.infradead.org,
	samba-technical@lists.samba.org, linux-i3c@lists.infradead.org,
	linux1394-devel@lists.sourceforge.net, linux-afs@lists.infradead.org,
	usb-storage@lists.one-eyed-alien.net,
	target-devel@vger.kernel.org, devel@driverdev.osuosl.org,
	linux-cifs@vger.kernel.org, rds-devel@oss.oracle.com,
	Nick Desaulniers <ndesaulniers@google.com>,
	linux-scsi@vger.kernel.org, linux-rdma@vger.kernel.org,
	oss-drivers@netronome.com, bridge@lists.linux-foundation.org,
	linux-security-module@vger.kernel.org, amd-gfx@lists.freedesktop.org,
	linux-stm32@st-md-mailman.stormreply.com,
	cluster-devel@redhat.com, linux-acpi@vger.kernel.org,
	coreteam@netfilter.org, intel-wired-lan@lists.osuosl.org,
	linux-input@vger.kernel.org, Miguel Ojeda <ojeda@kernel.org>,
	tipc-discussion@lists.sourceforge.net,
	linux-ext4@vger.kernel.org, linux-media@vger.kernel.org,
	linux-watchdog@vger.kernel.org, selinux@vger.kernel.org,
	linux-arm-msm@vger.kernel.org, intel-gfx@lists.freedesktop.org,
	linux-geode@lists.infradead.org, linux-can@vger.kernel.org,
	linux-block@vger.kernel.org, linux-gpio@vger.kernel.org,
	op-tee@lists.trustedfirmware.org, linux-mediatek@lists.infradead.org,
	xen-devel@lists.xenproject.org, drbd-dev@tron.linbit.com,
	linux-hams@vger.kernel.org, ceph-devel@vger.kernel.org,
	virtualization@lists.linux-foundation.org,
	linux-arm-kernel@lists.infradead.org,
	linux-hwmon@vger.kernel.org, x86@kernel.org,
	linux-nfs@vger.kernel.org, GR-Linux-NIC-Dev@marvell.com,
	linux-mm@kvack.org, netdev@vger.kernel.org,
	linux-decnet-user@lists.sourceforge.net, linux-mmc@vger.kernel.org,
	"Gustavo A. R. Silva" <gustavoars@kernel.org>,
	linux-renesas-soc@vger.kernel.org, linux-sctp@vger.kernel.org,
	linux-usb@vger.kernel.org, netfilter-devel@vger.kernel.org,
	linux-crypto@vger.kernel.org, patches@opensource.cirrus.com,
	Joe Perches <joe@perches.com>, linux-integrity@vger.kernel.org,
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
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Fri, Nov 20, 2020 at 10:53:44AM -0800, Jakub Kicinski wrote:
> On Fri, 20 Nov 2020 12:21:39 -0600 Gustavo A. R. Silva wrote:
> > This series aims to fix almost all remaining fall-through warnings in
> > order to enable -Wimplicit-fallthrough for Clang.
> > 
> > In preparation to enable -Wimplicit-fallthrough for Clang, explicitly
> > add multiple break/goto/return/fallthrough statements instead of just
> > letting the code fall through to the next case.
> > 
> > Notice that in order to enable -Wimplicit-fallthrough for Clang, this
> > change[1] is meant to be reverted at some point. So, this patch helps
> > to move in that direction.
> > 
> > Something important to mention is that there is currently a discrepancy
> > between GCC and Clang when dealing with switch fall-through to empty case
> > statements or to cases that only contain a break/continue/return
> > statement[2][3][4].
> 
> Are we sure we want to make this change? Was it discussed before?
> 
> Are there any bugs Clangs puritanical definition of fallthrough helped
> find?
> 
> IMVHO compiler warnings are supposed to warn about issues that could
> be bugs. Falling through to default: break; can hardly be a bug?!

It's certainly a place where the intent is not always clear. I think
this makes all the cases unambiguous, and doesn't impact the machine
code, since the compiler will happily optimize away any behavioral
redundancy.


-- 
Kees Cook

--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel

