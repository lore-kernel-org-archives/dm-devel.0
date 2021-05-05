Return-Path: <SRS0=LgXV=KB=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6AE66C433ED
	for <dm-devel@archiver.kernel.org>; Thu,  6 May 2021 07:57:50 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id D9529613BA
	for <dm-devel@archiver.kernel.org>; Thu,  6 May 2021 07:57:49 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org D9529613BA
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=vermwa.re
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-424-VUUk8pTzPZSEZsPp8QV6PQ-1; Thu, 06 May 2021 03:57:46 -0400
X-MC-Unique: VUUk8pTzPZSEZsPp8QV6PQ-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 069C41927803;
	Thu,  6 May 2021 07:57:43 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id D83F4505AD;
	Thu,  6 May 2021 07:57:42 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id ABAD45534E;
	Thu,  6 May 2021 07:57:42 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
	[10.11.54.5])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 145Lltax000617 for <dm-devel@listman.util.phx.redhat.com>;
	Wed, 5 May 2021 17:47:56 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id D54877AD8; Wed,  5 May 2021 21:47:55 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast06.extmail.prod.ext.rdu2.redhat.com [10.11.55.22])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id D0D6E11EB1F
	for <dm-devel@redhat.com>; Wed,  5 May 2021 21:47:52 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[205.139.110.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id A88C8185A79C
	for <dm-devel@redhat.com>; Wed,  5 May 2021 21:47:52 +0000 (UTC)
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed;
	d=dkim.mimecast.com; s=201903; t=1620251272;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	in-reply-to:in-reply-to:references:references;
	bh=MVAJ1qIEXMsunGcxS+sg0lAtHmADQGI8dKjzSuJJosU=;
	b=ZAaD1j6mIvIpKKLmuvnkola5lZtWEdloBwtRkdnVaKHe/rbWyRWubzLEuc/MRrKEP5d9AX
	ZhxF2EgqWyVc/Ff9jaF0+K6MYtVM1bfvgpGcu3R1MRjK686BFW1ni/EPhxOAm6z715Qgfz
	1ULf6DqNBKam5FqiX1xqf2TSDkaUp4VKe491vUQzIwCeFrX067A3BKJMlfk0XnR447/GNh
	0/6dd+t6zyDHsryxQNnm/V+iimgUhf+qHIPoAkKvcADKln4Cv0AUcb18IFi94bsCeZ10Q6
	BRePLjGvKhWj9dVwfbA/IlF6qBJES5o/X5UUFJAtBFMhcz7+M6Rcfo4lBznR3w==
ARC-Seal: i=1; s=201903; d=dkim.mimecast.com; t=1620251272; a=rsa-sha256;
	cv=none;
	b=gFGQldGCU8N8OtRGnZoOUMCTpIKCXxI6f0FtQ4RmpW6lD0ec6dzuxNJ0QbD64sbOW9eQi9
	b1C3RXfcmUzUkZ80Uz6rLxHhGS/siYWLWqBzXfc5Y+buQc8zg5Wnbb/PqoxAh7GNXOBlBK
	pnX1SyUmnLyav8P1+axYPnlU8KEo9GnAG/2P3EjMA3Dyb2QaxjHK/3Q6AbtO+OFxqRp/HA
	zCwWKrEA3BuslhaN4kvozJUmvtmvoxe4CHsHFnnnVGDI997tcnvQmUM3KSjD+wJgRxwfOn
	i2cwKCwRUrZueZTUavyETJX56V3v1g1wD8N1r0wb9QFzj9YvNUKNbFaPnC/G9w==
ARC-Authentication-Results: i=1; relay.mimecast.com; dkim=none; dmarc=none;
	spf=pass (relay.mimecast.com: domain of vermeeren@vermwa.re designates
	5.255.86.113 as permitted sender)
	smtp.mailfrom=vermeeren@vermwa.re
Received: from victorique.vermwa.re (victorique.vermwa.re [5.255.86.113])
	(Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-50-QvSQeWhcOy6oDP6CwUQPsQ-1; Wed, 05 May 2021 17:47:47 -0400
X-MC-Unique: QvSQeWhcOy6oDP6CwUQPsQ-1
Received: from victorique.vermwa.re (localhost [127.0.0.1])
	by victorique.vermwa.re (Postfix) with ESMTP id 9490EA02D7;
	Wed,  5 May 2021 23:47:45 +0200 (CEST)
Received: from verm-r4e.localnet ([fd17:3171:f888:364d::1000])
	by victorique.vermwa.re with ESMTPSA id 8M//IoESk2BCUAAAjH0QZw
	(envelope-from <vermeeren@vermwa.re>); Wed, 05 May 2021 23:47:45 +0200
From: Melvin Vermeeren <vermeeren@vermwa.re>
To: Mikulas Patocka <mpatocka@redhat.com>
Date: Wed, 05 May 2021 23:47:41 +0200
Message-ID: <1647312.vWrHn5Hxal@verm-r4e>
Organization: vermware
In-Reply-To: <alpine.LRH.2.02.2105051642300.32187@file01.intranet.prod.int.rdu2.redhat.com>
References: <alpine.LRH.2.02.2104281658430.9959@file01.intranet.prod.int.rdu2.redhat.com>
	<10258776.4TuPVb8Keo@verm-r4e>
	<alpine.LRH.2.02.2105051642300.32187@file01.intranet.prod.int.rdu2.redhat.com>
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
Content-Type: multipart/mixed; boundary="===============5024415718977642024=="
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12

--===============5024415718977642024==
Content-Type: multipart/signed; boundary="nextPart27008243.bQPKdacuC8";
	micalg="pgp-sha512"; protocol="application/pgp-signature"

--nextPart27008243.bQPKdacuC8
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"; protected-headers="v1"
From: Melvin Vermeeren <vermeeren@vermwa.re>
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: Mike Snitzer <msnitzer@redhat.com>, Milan Broz <mbroz@redhat.com>,
	dm-devel@redhat.com
Subject: Re: [PATCH v2] dm-integrity: if we have discard support,
	use it when recalculating
Date: Wed, 05 May 2021 23:47:41 +0200
Message-ID: <1647312.vWrHn5Hxal@verm-r4e>
Organization: vermware
In-Reply-To: <alpine.LRH.2.02.2105051642300.32187@file01.intranet.prod.int.rdu2.redhat.com>
References: <alpine.LRH.2.02.2104281658430.9959@file01.intranet.prod.int.rdu2.redhat.com>
	<10258776.4TuPVb8Keo@verm-r4e>
	<alpine.LRH.2.02.2105051642300.32187@file01.intranet.prod.int.rdu2.redhat.com>

Hi,

On Wednesday, 5 May 2021 22:45:09 CEST Mikulas Patocka wrote:
> So, we can ask Milan to update the manpage.

Yes, that would be fine. However, "integrity recalculate" sounds like 
recalculating integrity. The newly implemented logic is more of a "integrity 
wipe" or "integrity reset".

What is problematic is that actual functionality from end user point of view 
is now completely different depending on if you use --allow-discards or not. 
Without discard you recalculate meta, with discard you reset/wipe meta.

> It will receive integrity protection for the newly written data.
> 
> If you create an integrity device and make a filesystem on it, the newly
> written data matters. The old data that were on the filesystem before
> formatting it don't care and don't need to be protected.

One of the current possible use cases with --no-wipe --data-device is that you 
can use existing device holding data that has no integrity and add integrity 
to it with detached metadata device in combination with recalculate.

Then recalculation can be used in a fashion similar to trust-on-first-use for 
this specific disk without rewriting the data meaning also no temporary copy 
is needed. This feature is something I have used a few times as adding 
integrity in-place can be useful in certain situations especially when dealing 
with large amounts of data.


I am not against the new reset/wipe operation, it is certainly a useful thing 
to have. This style of initialising metadata would be especially useful with 
formatting devices supporting discard, as it could be used to avoid 
unnecessary writes on main data by initialising metadata only (and perhaps 
also issue discards to underlying device).

But I do think this should be a separate, new function in addition to existing 
recalculation feature, to me they both seem useful in different use cases.

Thoughts on this?

Thanks,

-- 
Melvin Vermeeren
Systems engineer
--nextPart27008243.bQPKdacuC8
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part.
Content-Transfer-Encoding: 7Bit

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEEiu1YAh/qzdXye6Dmpy9idxbqnZYFAmCTEn0ACgkQpy9idxbq
nZZqSxAAiIdvmRmi7b3S1oVwff43L8XNuHNIuFDOJYS/mpYXoATShsPKpBYF/HRc
NdcBlsGxodnuhpxmQf3G8vZGIhg0wGx7FQDUnB0qH+KGK8/RGtW6ldLVD7BggtDa
10C/YY4gXQBQHJJgWYAoq2piAtFjFOTWrXyWkMANclWz5fBKvpKN5rjtWHvF6m5f
4XT1qm8dK3OOKkM+t+CUTi3oAjJQOHS1+uU6QZYFONUS9JAwJuB2AZF92w40kztW
6lLtabxckc4OSKWmmPynUMD1w1J41nFyltRVZKV9fe65h7sCeEGUcVgNWBSuViws
PYadTFnnJtVCychkH5TMUok+aJLOnlxI5OfHIvgDDqnwywL3NLT1oFFV6NfE9PG1
7ArBICvTauSbm3YA+9z+EOrzjYM74MS9Ifv+5Sf6GPIuCJg153UC4U1txHYjkI6V
p6V/p9fRgfGl8OiAwdVDXYfr2UY5P1UaTyCYwmwRe6PK9WJVSrQI915SQ4gSLcB5
FPL8zgg73jA/JQDklXBz1WNkUb13L3U/KqcuVFkTqWQla06bpMgRYjwk65h8yAXP
3+URwae+TG/TgR72Gf5o5oGzGpDVF1mg5rfVXoR4Z8bsLfzaBdRPOIX/J05ZkbPK
K+FKVxpHz34AI5UVInNU6grO1eHTog41/doKCnN83dd/AYRyLzM=
=kxnn
-----END PGP SIGNATURE-----

--nextPart27008243.bQPKdacuC8--




--===============5024415718977642024==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel
--===============5024415718977642024==--



