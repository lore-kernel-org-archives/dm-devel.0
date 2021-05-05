Return-Path: <SRS0=LgXV=KB=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DDF56C433B4
	for <dm-devel@archiver.kernel.org>; Thu,  6 May 2021 07:57:33 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 9067F613BE
	for <dm-devel@archiver.kernel.org>; Thu,  6 May 2021 07:57:32 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 9067F613BE
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=vermwa.re
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-504-SqMO-mObMtKqJ0d9Bprfww-1; Thu, 06 May 2021 03:57:28 -0400
X-MC-Unique: SqMO-mObMtKqJ0d9Bprfww-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id AE8611006C80;
	Thu,  6 May 2021 07:57:24 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 125FA60C5C;
	Thu,  6 May 2021 07:57:23 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id D193755346;
	Thu,  6 May 2021 07:57:18 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com
	[10.11.54.3])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 145JRrTZ020858 for <dm-devel@listman.util.phx.redhat.com>;
	Wed, 5 May 2021 15:27:53 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id 937A01055189; Wed,  5 May 2021 19:27:53 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast01.extmail.prod.ext.rdu2.redhat.com [10.11.55.17])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 8E8E61055246
	for <dm-devel@redhat.com>; Wed,  5 May 2021 19:27:51 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[207.211.31.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 5EDD3858290
	for <dm-devel@redhat.com>; Wed,  5 May 2021 19:27:51 +0000 (UTC)
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed;
	d=dkim.mimecast.com; s=201903; t=1620242871;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	in-reply-to:in-reply-to:references:references;
	bh=D08ZNjDn7cOUUSA85d/D8zO7XylPUMI1ShFK6d8ShW4=;
	b=cxH0bnlSLHZ/dvoawp+x9D+Jh3aT8HNwnBD9FE+oMCq+TR+sYwqcNIaOt2ORBag+DORXLD
	fWIHNV2SOYEQ4VrRHuhQFPo3tC659EzQkfyrTGg5kzlAp4sqasC8Spsw9pzTqn2mpOrj/8
	zIW6ONd5vRB2GGBij6IYpkbeH81akVRnryicnf0XGJyZawjZkSzbKsV5xaUfrNMap0/3x4
	zwUXP9urDFDGXcsb5qnl5ZhrdN9S67eZdRUuJkWSbVmLIOybf+JjB9L6gEbFMUeu1zChLW
	aaLEBW++iQyBDsQsfJKblX+HWx9f/+q4dS2LFAytpFrCwPgMkbJsLDd45e85TA==
ARC-Seal: i=1; s=201903; d=dkim.mimecast.com; t=1620242871; a=rsa-sha256;
	cv=none;
	b=mW5sNXEb8qeKl4/eD8n0X8Sxp23bkCu3su+y581znfwK6PyWPRJvTHqCL8jZPB7yPXAeLW
	0li8dwIgE/x+X8fGpyQ90+ElUNNlEzAZC9yrRjvFmNtmw6mokAAqY3mr0PaCTscGDvSE8X
	W0NUCpANUUGXG79ea/vdLWf0B7mWzP/BzlMZSNy/A/RpzxjJxOYSb550Olcn9IAN4OdFWk
	BoWRfoxedw5FL5SJ0FNB7qV7Tz/W8NSg3uUAgtBi0678Nh+twLlKYWa4E+dizWaWZMET0A
	b58u/deYhQMH+AijTLDVOzupSoxEAVzoOWglXlSUqEYGoXXvxkIqCCoKtmtAVA==
ARC-Authentication-Results: i=1; relay.mimecast.com; dkim=none; dmarc=none;
	spf=pass (relay.mimecast.com: domain of vermeeren@vermwa.re designates
	5.255.86.113 as permitted sender)
	smtp.mailfrom=vermeeren@vermwa.re
Received: from victorique.vermwa.re (victorique.vermwa.re [5.255.86.113])
	(Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-571-udG338qIMMCZtukgvT0R0A-1; Wed, 05 May 2021 15:25:08 -0400
X-MC-Unique: udG338qIMMCZtukgvT0R0A-1
Received: from victorique.vermwa.re (localhost [127.0.0.1])
	by victorique.vermwa.re (Postfix) with ESMTP id 0096DA02D7;
	Wed,  5 May 2021 21:27:45 +0200 (CEST)
Received: from verm-r4e.localnet ([fd17:3171:f888:364d::1000])
	by victorique.vermwa.re with ESMTPSA id LcxIOrHxkmCPQgAAjH0QZw
	(envelope-from <vermeeren@vermwa.re>); Wed, 05 May 2021 21:27:45 +0200
From: Melvin Vermeeren <vermeeren@vermwa.re>
To: Mikulas Patocka <mpatocka@redhat.com>
Date: Wed, 05 May 2021 21:27:41 +0200
Message-ID: <2912930.OmXdaqUpTP@verm-r4e>
Organization: vermware
In-Reply-To: <alpine.LRH.2.02.2105051444010.31064@file01.intranet.prod.int.rdu2.redhat.com>
References: <alpine.LRH.2.02.2104281658430.9959@file01.intranet.prod.int.rdu2.redhat.com>
	<6810395.sd9NxXGo4T@verm-r4e>
	<alpine.LRH.2.02.2105051444010.31064@file01.intranet.prod.int.rdu2.redhat.com>
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
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.3
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
Content-Type: multipart/mixed; boundary="===============1090109555911653130=="
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13

--===============1090109555911653130==
Content-Type: multipart/signed; boundary="nextPart1637365.EO7CkVvcX8";
	micalg="pgp-sha512"; protocol="application/pgp-signature"

--nextPart1637365.EO7CkVvcX8
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"; protected-headers="v1"
From: Melvin Vermeeren <vermeeren@vermwa.re>
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: Mike Snitzer <msnitzer@redhat.com>, Milan Broz <mbroz@redhat.com>,
	dm-devel@redhat.com
Subject: Re: [PATCH v2] dm-integrity: if we have discard support,
	use it when recalculating
Date: Wed, 05 May 2021 21:27:41 +0200
Message-ID: <2912930.OmXdaqUpTP@verm-r4e>
Organization: vermware
In-Reply-To: <alpine.LRH.2.02.2105051444010.31064@file01.intranet.prod.int.rdu2.redhat.com>
References: <alpine.LRH.2.02.2104281658430.9959@file01.intranet.prod.int.rdu2.redhat.com>
	<6810395.sd9NxXGo4T@verm-r4e>
	<alpine.LRH.2.02.2105051444010.31064@file01.intranet.prod.int.rdu2.redhat.com>

Hi,

On Wednesday, 5 May 2021 20:48:47 CEST Mikulas Patocka wrote:
> It doesn't matter if the device is discarded or not. If the metadata
> constains the discard filler, dm-integrity won't check the checksum - so
> the data can contain anything.
> 
> ...
>
> The device after discard may contain random pattern (some SSDs really do)
> - so when the metadata contains the discard filler, the data may contain
> anything.

So if an existing SSD is formatted with --no-wipe --data-device option and 
then opened with --integrity-recalculate all metadata will contain the discard 
filler with this patch.

So then, all the current data in the drive is not checked for integrity 
because it contains discard filler. This means that integrity recalculation 
itself never takes place for existing data. Meaning that only newly written 
data to SSD device will actually have integrity protection.

Is this correct?

Cheers,

-- 
Melvin Vermeeren
Systems engineer
--nextPart1637365.EO7CkVvcX8
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part.
Content-Transfer-Encoding: 7Bit

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEEiu1YAh/qzdXye6Dmpy9idxbqnZYFAmCS8a0ACgkQpy9idxbq
nZYrCA/8DS+OGyjK2bSR1D3DpJQrHksMLPu0577o+d5HeEUeu7t21lMCvplHktBF
eCyb7FVeLGi5zWPv7BwlKKfFOPFnMBZegUPgwXKeT8DZenJ2SKb4II/cw71ULlZD
ECzP2pM+CjiYqDaKUHp3Jy142H5WH6pGXvEOf2ZEnPVlyWQv6auFs63tC6u92d70
Psk7BL4Jr7Hvxwjugvwpn5BQ7WtMWw0UokPv9ZkNpURhzNuVn8XsGypwZ3jAlyZj
EhQhH3TKTqAmvt16UAd43Yj1ZYpcJrIBrV7yOKYr5e/e4wAvITELTTkwTyXy4916
2lKHwFgWWxZFk8PCLj3Jf0XV405EVIB7GS3nRXFFSg/dUIbOOQ5Vi/7/FZWOoZkY
P0Mzci/DDCl+G2bYNzPFBfPqFzcSEt/wQF1/bjOAULQeROrcBJM2ALf+A2efwW/m
A+iczf9w+Mw+v146GPw74B4tSirhVlA+gLAodYgGm6y5fr6BqXiKEweO+sccgDpm
Pze7E/MY/45dPfn0GxjuSzRWxxHtLF3pcuXy9ug25Jc+Bj6l87LYqz4dFhoRuTVU
s8qbUU4A0GC83ikOOvs34Hw1Ghqrkp6wU6at+oQNOxjYgQ+1nP3Y4tvuNYggW1uz
7CSfOH7/S+rMnZOF46nLhAd8byKmwGTbZmb2ZAoN1fhtSQatRng=
=ciX+
-----END PGP SIGNATURE-----

--nextPart1637365.EO7CkVvcX8--




--===============1090109555911653130==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel
--===============1090109555911653130==--



