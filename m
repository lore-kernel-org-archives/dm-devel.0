Return-Path: <SRS0=D9Ri=FI=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 632BBC433FE
	for <dm-devel@archiver.kernel.org>; Fri,  4 Dec 2020 17:57:22 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id CB41C22B43
	for <dm-devel@archiver.kernel.org>; Fri,  4 Dec 2020 17:57:21 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org CB41C22B43
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=hansenpartnership.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-243-PGHnLTFSM6m9NoWtZb4XNA-1; Fri, 04 Dec 2020 12:57:18 -0500
X-MC-Unique: PGHnLTFSM6m9NoWtZb4XNA-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 8256C107ACFB;
	Fri,  4 Dec 2020 17:57:13 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 21D9C27C5B;
	Fri,  4 Dec 2020 17:57:13 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 78AAC4BB7B;
	Fri,  4 Dec 2020 17:57:12 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
	[10.11.54.5])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 0B4Hv8kE017703 for <dm-devel@listman.util.phx.redhat.com>;
	Fri, 4 Dec 2020 12:57:08 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 83275108473; Fri,  4 Dec 2020 17:57:08 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast02.extmail.prod.ext.rdu2.redhat.com [10.11.55.18])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 7DDAA108479
	for <dm-devel@redhat.com>; Fri,  4 Dec 2020 17:57:06 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [207.211.31.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 3D82F800B3B
	for <dm-devel@redhat.com>; Fri,  4 Dec 2020 17:57:06 +0000 (UTC)
Received: from bedivere.hansenpartnership.com
	(bedivere.hansenpartnership.com [96.44.175.130]) (Using TLS) by
	relay.mimecast.com with ESMTP id us-mta-515-k8b9gcf4Ni-7j96giNAYQw-1;
	Fri, 04 Dec 2020 12:57:02 -0500
X-MC-Unique: k8b9gcf4Ni-7j96giNAYQw-1
Received: from localhost (localhost [127.0.0.1])
	by bedivere.hansenpartnership.com (Postfix) with ESMTP id EFE5C12806D3; 
	Fri,  4 Dec 2020 09:57:00 -0800 (PST)
Received: from bedivere.hansenpartnership.com ([127.0.0.1])
	by localhost (bedivere.hansenpartnership.com [127.0.0.1]) (amavisd-new,
	port 10024)
	with ESMTP id INp-1Jb0T2J6; Fri,  4 Dec 2020 09:57:00 -0800 (PST)
Received: from jarvis.int.hansenpartnership.com (unknown
	[IPv6:2601:600:8280:66d1::527])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by bedivere.hansenpartnership.com (Postfix) with ESMTPSA id
	92AB012806D2; Fri,  4 Dec 2020 09:56:59 -0800 (PST)
Message-ID: <d706cdbcc4eba3fb3fe17453017a6623f1ec80dc.camel@HansenPartnership.com>
From: James Bottomley <James.Bottomley@hansenpartnership.com>
To: laniel_francis@privacyrequired.com, Russell King <linux@armlinux.org.uk>,
	Hauke Mehrtens <hauke@hauke-m.de>,
	=?UTF-8?Q?Rafa=C5=82_Mi=C5=82ecki?= <zajec5@gmail.com>, Thomas Bogendoerfer
	<tsbogend@alpha.franken.de>, Florian Fainelli <f.fainelli@gmail.com>,
	bcm-kernel-feedback-list@broadcom.com, Herbert Xu
	<herbert@gondor.apana.org.au>, "David S. Miller" <davem@davemloft.net>,
	Ard Biesheuvel <ardb@kernel.org>, Tomi Valkeinen <tomi.valkeinen@ti.com>,
	David Airlie <airlied@linux.ie>, Daniel Vetter <daniel@ffwll.ch>, Laurent
	Pinchart <laurent.pinchart@ideasonboard.com>, Kieran Bingham
	<kieran.bingham+renesas@ideasonboard.com>, Alasdair Kergon
	<agk@redhat.com>, Mike Snitzer <snitzer@redhat.com>,
	dm-devel@redhat.com, Bin Liu <b-liu@ti.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Jessica Yu <jeyu@kernel.org>
Date: Fri, 04 Dec 2020 09:56:58 -0800
In-Reply-To: <20201204170319.20383-1-laniel_francis@privacyrequired.com>
References: <20201204170319.20383-1-laniel_francis@privacyrequired.com>
User-Agent: Evolution 3.34.4
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
Cc: linux-efi@vger.kernel.org, linux-usb@vger.kernel.org,
	linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
	linux-mips@vger.kernel.org, linux-renesas-soc@vger.kernel.org,
	linux-ide@vger.kernel.org, linux-crypto@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org
Subject: Re: [dm-devel] [RFC PATCH v1 00/12] Replace strstarts() by
	str_has_prefix()
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
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Fri, 2020-12-04 at 18:03 +0100, laniel_francis@privacyrequired.com
wrote:
> In this patch set, I replaced all calls to strstarts() by calls to
> str_has_prefix(). Indeed, the kernel has two functions to test if a
> string begins with an other:
> 1. strstarts() which returns a bool, so 1 if the string begins with
> the prefix,0 otherwise.
> 2. str_has_prefix() which returns the length of the prefix or 0.
> 
> str_has_prefix() was introduced later than strstarts(), in commit
> 495d714ad140 which also stated that str_has_prefix() should replace
> strstarts(). This is what this patch set does.

What's the reason why?  If you look at the use cases for the
replacement of strstart()  they're all cases where we need to know the
length we're skipping and this is hard coded, leading to potential
errors later.  This is a classic example:  3d739c1f6156 ("tracing: Use
the return of str_has_prefix() to remove open coded numbers").  However
you're not doing this transformation in the conversion, so the
conversion is pretty useless.  I also see no case for replacing
strstart() where we're using it simply as a boolean without needing to
know the length of the prefix.

James


--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel

