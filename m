Return-Path: <SRS0=LgXV=KB=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E0EEDC43460
	for <dm-devel@archiver.kernel.org>; Thu,  6 May 2021 07:57:33 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 09814613C0
	for <dm-devel@archiver.kernel.org>; Thu,  6 May 2021 07:57:32 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 09814613C0
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=vermwa.re
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-599-bzF4_ZXWPK6QE4AgHD8yWw-1; Thu, 06 May 2021 03:57:29 -0400
X-MC-Unique: bzF4_ZXWPK6QE4AgHD8yWw-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 0090B1927800;
	Thu,  6 May 2021 07:57:24 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 117BF5D9DD;
	Thu,  6 May 2021 07:57:23 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id CDD561800BB8;
	Thu,  6 May 2021 07:57:18 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
	[10.11.54.5])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 145KGoOW024050 for <dm-devel@listman.util.phx.redhat.com>;
	Wed, 5 May 2021 16:16:50 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id 990F711E6A8; Wed,  5 May 2021 20:16:50 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast06.extmail.prod.ext.rdu2.redhat.com [10.11.55.22])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 9483D106A21
	for <dm-devel@redhat.com>; Wed,  5 May 2021 20:16:48 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[205.139.110.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 129EC1857F25
	for <dm-devel@redhat.com>; Wed,  5 May 2021 20:16:48 +0000 (UTC)
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed;
	d=dkim.mimecast.com; s=201903; t=1620245807;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	in-reply-to:in-reply-to:references:references;
	bh=6CHTO01PIeAZgZtv2Y6nnQgcxzQvFbOnirAbCEC/cXY=;
	b=jk2G8IRmLUi4UCMOr6ky8aw5wk2sO1iOmm931x7VBpzkb8v6o08ZCSjWrnTMVBqipgyEcg
	1slTKQKjVErllDE4CZrQncR4fwu2zD1LgLRxIUh+enO9BqIRqId4OaThcmU14ZWrf4vkxB
	RTvim91F6qttZL+S3k0MsFuki4Y2oIRC57fiY/5DOlrUjuDQsKyOk7GQn+/VE9DXT+Sba0
	Mb4IERjIjzeV7iZLoPSZHLrTuSpA9cfElT9fb2n+Gc2Bc+YvAv/UV1koJ+G6rh+Ds8SbLG
	5W10pz4w3W6rY+g7lw4VMeuAwdBcbghtNOiIpwR1H7EBfu2Xzi6VGqjPrJTsRg==
ARC-Seal: i=1; s=201903; d=dkim.mimecast.com; t=1620245807; a=rsa-sha256;
	cv=none;
	b=VZqCO3FqK84aMIOEqWUjhjgjQSQ5b7hGHq00N5+0PtRk2II5TkLTzQZZLkWILFKWLQOdUD
	lcjuChTLDJvh65xmcCGi016kwChigW48IyfNAei44Iir6pns++z7KaObVsA6gb2hBTGMi/
	0rC2EzXtB0w1Hm/twg6SNlaC1D8JDXdcQcBQ6tVTIkhmkWvbZJy3OrKZget5oK6/3+C+RV
	9a/bMbDv5T6997mmbzdKZXqRBH8QvIUNeyrbT+6d4cVwOoYLqyM4H7AmmYaKc+YuHbjCul
	wPMwBNS0tnIh9/pBNVM2xzk6BNJhchs0OQ8h3DDDea6OPjHSx/bvtSjiCRqn+w==
ARC-Authentication-Results: i=1; relay.mimecast.com; dkim=none; dmarc=none;
	spf=pass (relay.mimecast.com: domain of vermeeren@vermwa.re designates
	5.255.86.113 as permitted sender)
	smtp.mailfrom=vermeeren@vermwa.re
Received: from victorique.vermwa.re (victorique.vermwa.re [5.255.86.113])
	(Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-492-YpRg8mThMOSJqXASBsxJYw-1; Wed, 05 May 2021 16:16:45 -0400
X-MC-Unique: YpRg8mThMOSJqXASBsxJYw-1
Received: from victorique.vermwa.re (localhost [127.0.0.1])
	by victorique.vermwa.re (Postfix) with ESMTP id 66330A02D7;
	Wed,  5 May 2021 22:16:43 +0200 (CEST)
Received: from verm-r4e.localnet ([fd17:3171:f888:364d::1000])
	by victorique.vermwa.re with ESMTPSA id IKLiFyv9kmBBSgAAjH0QZw
	(envelope-from <vermeeren@vermwa.re>); Wed, 05 May 2021 22:16:43 +0200
From: Melvin Vermeeren <vermeeren@vermwa.re>
To: Mikulas Patocka <mpatocka@redhat.com>
Date: Wed, 05 May 2021 22:16:38 +0200
Message-ID: <10258776.4TuPVb8Keo@verm-r4e>
Organization: vermware
In-Reply-To: <alpine.LRH.2.02.2105051604580.32187@file01.intranet.prod.int.rdu2.redhat.com>
References: <alpine.LRH.2.02.2104281658430.9959@file01.intranet.prod.int.rdu2.redhat.com>
	<2912930.OmXdaqUpTP@verm-r4e>
	<alpine.LRH.2.02.2105051604580.32187@file01.intranet.prod.int.rdu2.redhat.com>
MIME-Version: 1.0
Authentication-Results: relay.mimecast.com; dkim=none; dmarc=none;
	spf=pass (relay.mimecast.com: domain of vermeeren@vermwa.re designates
	5.255.86.113 as permitted sender)
	smtp.mailfrom=vermeeren@vermwa.re
X-Mimecast-Spam-Score: -5
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
X-Mailman-Approved-At: Thu, 06 May 2021 03:57:16 -0400
Cc: Mike Snitzer <msnitzer@redhat.com>, dm-devel@redhat.com,
	Milan Broz <mbroz@redhat.com>
Subject: Re: [dm-devel] [PATCH v2] dm-integrity: if we have discard support,
	use it when recalculating
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
Content-Type: multipart/mixed; boundary="===============6689231451468412941=="
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14

--===============6689231451468412941==
Content-Type: multipart/signed; boundary="nextPart2019287.s6M6IzKXav";
	micalg="pgp-sha512"; protocol="application/pgp-signature"

--nextPart2019287.s6M6IzKXav
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"; protected-headers="v1"
From: Melvin Vermeeren <vermeeren@vermwa.re>
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: Mike Snitzer <msnitzer@redhat.com>, Milan Broz <mbroz@redhat.com>,
	dm-devel@redhat.com
Subject: Re: [PATCH v2] dm-integrity: if we have discard support,
	use it when recalculating
Date: Wed, 05 May 2021 22:16:38 +0200
Message-ID: <10258776.4TuPVb8Keo@verm-r4e>
Organization: vermware
In-Reply-To: <alpine.LRH.2.02.2105051604580.32187@file01.intranet.prod.int.rdu2.redhat.com>
References: <alpine.LRH.2.02.2104281658430.9959@file01.intranet.prod.int.rdu2.redhat.com>
	<2912930.OmXdaqUpTP@verm-r4e>
	<alpine.LRH.2.02.2105051604580.32187@file01.intranet.prod.int.rdu2.redhat.com>

On Wednesday, 5 May 2021 22:05:35 CEST Mikulas Patocka wrote:
> Yes.

I fail to understand why that would be desired behaviour, as I see it it is 
conflicting with current documentation in integritysetup(8):

> --integrity-recalculate
> Automatically recalculate integrity tags in kernel on activation. The device
> can be used during automatic integrity recalculation but becomes fully
> integrity protected only after the background operation is finished. This
> option is available since the Linux kernel version 4.19.

The device in SSD with discard case never receives integrity protection 
because the metadata is filled with discard filler. Could you explain the 
reasoning behind the patch?

Thanks,

-- 
Melvin Vermeeren
Systems engineer
--nextPart2019287.s6M6IzKXav
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part.
Content-Transfer-Encoding: 7Bit

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEEiu1YAh/qzdXye6Dmpy9idxbqnZYFAmCS/SYACgkQpy9idxbq
nZaWgA//VxErT2jyc3Phx1HqPt9ppcAqhDJsOn+++CmLUZxccqfqvFfULi1OdnKh
nD1BPdFuk2J+PkgidE4QX9I9aBlknzW0jwdJIVDRQw9rTkkKY2xoyWddgUxucKBS
h1nUoR8tMFu9fnLzJ9shteG6ry/hjBIshM89oYuSXENdl3mNH2ua3AXWy8Jv539U
vo00dRKluM3P92kGiHoSlPTeXaPrKOVsM6PLxMAAwUMxAZQcZXB+qQuidbdhpd1t
Uta38RQdah3N+RjzpQp4CFrrptb4xcp1z69D/H0/I5HsdMONQxxXdNTzd7nu0luH
nU5+NnF3ioKrF+VD8QzryBnTOoHSzl4Up0Ah9dHXRdy0CcC5f9y91IJ9AYkqHhrY
UEkbaaV7K3GfYmRaWVOZA1Tl5tc+UP6epkyB+zqOTTkvKy67Zn8ixB1U7hhl+XRR
SMO/07grkCpHhDuGNm1k336xzAN8A+w54Xp0YeJxktf2BnOAoLRfcW4x0qQlQTUt
Q9A1XzTr9LQpIJbQSWHzT2JQ5wdr5d6UqMgv/nBOyRplB0tI9RhNo+kYpHKweidB
rwtWwuJjL0EPsNzt1DKMClQ6vj/fjwbWBjYUriJsoX4TQxbzfKhwbn2P44Ih2BKA
Z0gGitLs/PbI/WNBgNPGq2X3MvRIG0kKam37Ty99FR0fhpaQ3bo=
=I5vU
-----END PGP SIGNATURE-----

--nextPart2019287.s6M6IzKXav--




--===============6689231451468412941==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel
--===============6689231451468412941==--



