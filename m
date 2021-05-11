Return-Path: <SRS0=/P3g=KH=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D46C9C433ED
	for <dm-devel@archiver.kernel.org>; Wed, 12 May 2021 05:58:02 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id B587361006
	for <dm-devel@archiver.kernel.org>; Wed, 12 May 2021 05:58:01 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org B587361006
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=vermwa.re
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-443-zVNF1QtZNGuLnLqeuPKHcg-1; Wed, 12 May 2021 01:57:57 -0400
X-MC-Unique: zVNF1QtZNGuLnLqeuPKHcg-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 16A94107ACE4;
	Wed, 12 May 2021 05:57:52 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 6B2445C232;
	Wed, 12 May 2021 05:57:50 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id E974F180B463;
	Wed, 12 May 2021 05:57:47 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
	[10.11.54.6])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 14BIXOUU024332 for <dm-devel@listman.util.phx.redhat.com>;
	Tue, 11 May 2021 14:33:24 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id 57C0B2135F17; Tue, 11 May 2021 18:33:24 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast02.extmail.prod.ext.rdu2.redhat.com [10.11.55.18])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 5393B202878E
	for <dm-devel@redhat.com>; Tue, 11 May 2021 18:33:21 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [205.139.110.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id A7899800B23
	for <dm-devel@redhat.com>; Tue, 11 May 2021 18:33:21 +0000 (UTC)
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed;
	d=dkim.mimecast.com; s=201903; t=1620758001;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	in-reply-to:in-reply-to:references:references;
	bh=E+tWBnx4csZoyAtDqMYIpwvT59brjWo/L0Cj6ei9ERg=;
	b=bmKAKSI/i80l7AQmOyjXnvm2Ff90eUyra/ULMqBQp0lxGBdJWZyLPazR05rAvVLUUJaaTm
	fBq2HPmFvetu3N1Sj+oasm+0sA6UfWRa0Rjo+NQvmwSJ1bKgY5LD6lLTiYX2HstTIUs1Wr
	Qh3+86Zvz9uOmm0fzi5aNGxarbq1MxaaK1B66i2wrVkdPytNTb2fxTBuXKSHLcL2LxWyER
	sqh8zoWN9l39XUykkrphc+Jbyar/HCNPEH1JM+yxovSdk4cMbGwiKQG7ZnN+ZNsaXh3Mqt
	88Ovyd6cbq3PLGcTh/uMu6/nbxWcnbGQqVocHLpO5vK/LemqdFiQITJLrStXHg==
ARC-Seal: i=1; s=201903; d=dkim.mimecast.com; t=1620758001; a=rsa-sha256;
	cv=none;
	b=W32CzpUxW13B9TGriymqirX6aIDzJGN3CqAi3sSQTYI0aIsDUlz/+yOBv9dSKvcnzJqyJB
	bScID15I4QDJTt6QJnHqQr9+m+05UPHM3SyKg9Woccf+2Puk74g1eoQ2n/35TqtrNJCeJT
	JoecAOUHYT6nHhvjneiHLhQaXjA1KuI9MIucG29zWr1bGynG64swm39wE38jT81LYuDl+Q
	BXUr90KM5/wdUr0lZ8VBZepFAlM+PrIEVbE/3WWIH/0IjqHeE83PhzyTbCuqnrHeAMdb5B
	678RFr5EmY+w1YF+S33Dw3EWYbDAdo4FeTm3+OZMo+9RvRX0guInV/uvfk7WHA==
ARC-Authentication-Results: i=1; relay.mimecast.com; dkim=none; dmarc=none;
	spf=pass (relay.mimecast.com: domain of vermeeren@vermwa.re designates
	5.255.86.113 as permitted sender)
	smtp.mailfrom=vermeeren@vermwa.re
Received: from victorique.vermwa.re (victorique.vermwa.re [5.255.86.113])
	(Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-434-IZPXPgqaMmayFQIHyvYkyQ-1; Tue, 11 May 2021 14:33:18 -0400
X-MC-Unique: IZPXPgqaMmayFQIHyvYkyQ-1
Received: from victorique.vermwa.re (localhost [127.0.0.1])
	by victorique.vermwa.re (Postfix) with ESMTP id 089C9A0E82;
	Tue, 11 May 2021 20:33:17 +0200 (CEST)
Received: from verm-r4e.localnet ([fd17:3171:f888:364d::1000])
	by victorique.vermwa.re with ESMTPSA id QqbuAO3NmmAhPgAAjH0QZw
	(envelope-from <vermeeren@vermwa.re>); Tue, 11 May 2021 20:33:17 +0200
From: Melvin Vermeeren <vermeeren@vermwa.re>
To: Milan Broz <mbroz@redhat.com>
Date: Tue, 11 May 2021 20:33:16 +0200
Message-ID: <19084315.bqbs8XHols@verm-r4e>
Organization: vermware
In-Reply-To: <26d4e0b9-329b-710e-3b93-82246d633ccb@redhat.com>
References: <alpine.LRH.2.02.2104281658430.9959@file01.intranet.prod.int.rdu2.redhat.com>
	<1647312.vWrHn5Hxal@verm-r4e>
	<26d4e0b9-329b-710e-3b93-82246d633ccb@redhat.com>
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
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.6
X-loop: dm-devel@redhat.com
X-Mailman-Approved-At: Wed, 12 May 2021 01:57:46 -0400
Cc: Mike Snitzer <msnitzer@redhat.com>, Mikulas Patocka <mpatocka@redhat.com>,
	dm-devel@redhat.com
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
Content-Type: multipart/mixed; boundary="===============3187249380460585036=="
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16

--===============3187249380460585036==
Content-Type: multipart/signed; boundary="nextPart1873769.rfdvJo9KMr";
	micalg="pgp-sha512"; protocol="application/pgp-signature"

--nextPart1873769.rfdvJo9KMr
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"; protected-headers="v1"
From: Melvin Vermeeren <vermeeren@vermwa.re>
To: Milan Broz <mbroz@redhat.com>
Cc: Mikulas Patocka <mpatocka@redhat.com>, Mike Snitzer <msnitzer@redhat.com>,
	dm-devel@redhat.com
Subject: Re: [PATCH v2] dm-integrity: if we have discard support,
	use it when recalculating
Date: Tue, 11 May 2021 20:33:16 +0200
Message-ID: <19084315.bqbs8XHols@verm-r4e>
Organization: vermware
In-Reply-To: <26d4e0b9-329b-710e-3b93-82246d633ccb@redhat.com>
References: <alpine.LRH.2.02.2104281658430.9959@file01.intranet.prod.int.rdu2.redhat.com>
	<1647312.vWrHn5Hxal@verm-r4e>
	<26d4e0b9-329b-710e-3b93-82246d633ccb@redhat.com>

Hi Milan,

On Tuesday, 11 May 2021 19:06:53 CEST Milan Broz wrote:
> Also, I added wiping to integritysetup because some tools (like mkfs)
> actually needef to read unitialized data before creating metadata - so
> without previous wipe it failed. (These are bugs in the tools, obviously: I
> plan to report these  unfortunately it never happened. Dunno if it is still
> the case.)

I can confirm a lot of tools still do this. Even `blkdiscard` probes for 
filesystems as a sanity check before discarding. So in order to efficiently 
initialise SSD without wiping, you need to dd zero to the start and end before 
running blkdiscard, or use --no-wipe with (pre-patch) recalculate.

Also, I did not realise the wiping is fully done from integritysetup 
userspace, this means the statement that this option would be useful as a new 
one is flawed, so then I agree the patch should be reverted.

It would be nice however if integritysetup from userspace has a native feature 
to wipe devices supporting discard with discards instead of writing (zeroes?), 
perhaps in the form of a --wipe-discard flag or similar, but that's for 
another day. :)

Cheers,

-- 
Melvin Vermeeren
Systems engineer
--nextPart1873769.rfdvJo9KMr
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part.
Content-Transfer-Encoding: 7Bit

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEEiu1YAh/qzdXye6Dmpy9idxbqnZYFAmCazewACgkQpy9idxbq
nZbSWg/8Djj03KiQreesleJXYiqkci5FA08BhNoylFETkX4q1R9U0EK78VPhfdNa
fiv7PbuLQP8ovlJIjgu5vukm0NL6/9bH1jinQMOhFSg55pxwyvvFnv6ROBVmVjXi
hKlVU3HMvuouaz42P4TZeFAMxHQhHk+JkfvSZhCmKwY8uusgoyi9VnTarVZry7zD
gsRGm5JIAay66Ghv5cXhupwYl7SNvDQ0XfpqNbjmcivpKNKiSId9kfvtwHZx1idD
gRrsMJe8D9bPDAAkNU0wkKQ4n6qAz4SdxVU9TsF+Wb5mILTMKwvhU8S44Yhi21ul
G2+o2qMNuYoaKqu1/JJFPUaQNohi08BWJ/wf6uS5Rhnob3ModBmWKwus3YC3QABg
d8wvEpIIh6ZNrSfejnTbcyS6hoFQz0Ev290Q0F3u65FrUsWCP+gdcoeOEdeaHLkc
39IINWlDyyqZD3dYHoOMV9xYGO6CBNQT59L+o7GKf2fgej8lz4xLsVMP5eiGusOF
9JVP3irs3m+w6NxxiRq3GePLfqYosVqFP6yGOx+YWDkF1Qh5LYLz/He5blzK5ixC
izF19LPEP19j6QpQehohVRXDdCcncvmVIuJfSLdYcfADqQcBLyyhoxAsJO3rY+Jr
LV9jtqgfRA19UNt4zPBigcCxs2d+YSzM23NbgrRhjBxx3ITrGtc=
=m5Rq
-----END PGP SIGNATURE-----

--nextPart1873769.rfdvJo9KMr--




--===============3187249380460585036==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel
--===============3187249380460585036==--



