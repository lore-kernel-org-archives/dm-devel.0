Return-Path: <SRS0=Sgdu=HZ=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.5 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0A43CC433E0
	for <dm-devel@archiver.kernel.org>; Tue, 23 Feb 2021 03:07:17 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 565BD64E02
	for <dm-devel@archiver.kernel.org>; Tue, 23 Feb 2021 03:07:16 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 565BD64E02
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=zougloub.eu
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-22-Oh9nrj8oNr6AwCfI2F4Ihg-1; Mon, 22 Feb 2021 22:07:11 -0500
X-MC-Unique: Oh9nrj8oNr6AwCfI2F4Ihg-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id ECB7F107ACE6;
	Tue, 23 Feb 2021 03:07:06 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 9DEE66E71A;
	Tue, 23 Feb 2021 03:07:03 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 41D724E58D;
	Tue, 23 Feb 2021 03:06:57 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
	[10.11.54.4])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 11N36s8d019908 for <dm-devel@listman.util.phx.redhat.com>;
	Mon, 22 Feb 2021 22:06:55 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 939E8202E956; Tue, 23 Feb 2021 03:06:54 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast04.extmail.prod.ext.rdu2.redhat.com [10.11.55.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 8D5AD202E946
	for <dm-devel@redhat.com>; Tue, 23 Feb 2021 03:06:51 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [205.139.110.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id CD33B1022F0A
	for <dm-devel@redhat.com>; Tue, 23 Feb 2021 03:06:51 +0000 (UTC)
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed;
	d=dkim.mimecast.com; s=201903; t=1614049611;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	in-reply-to:in-reply-to:dkim-signature;
	bh=fCMi6wNXfxDmHZyyyKoARX6GjpR39eHR0rJsUk74BM4=;
	b=b55V/lRUBLhdbwDUgsjDOB44iY96Ogg50+MEVjwHy08wrOzFR4+FzMtWN9hdLcMsm9NUim
	YatWoUvDO9CuUeO+d0S+rzGLsSSZXQtj0jy+zLGk5EAXKTfmVfE1abrorIwYL1anasYThr
	FIY3rEDzB5+TVR/2C7wwEANFzzjhkSOGJe6WeN7skjb7c0R8bhFIkRrZpcW+TJt3u9I8vT
	8Gm9HakAwHDo9yQ+iJyEoGS6LnJTb8T7tesYwM8ZRin68j/qqjaPb1HH4xfSG5NMOPLj8Y
	F3AWlRHZeaB+/uKiQNaGU9837eEEZK7z4HOcrviV65gE09F+slQCgtkSFihUOA==
ARC-Seal: i=1; s=201903; d=dkim.mimecast.com; t=1614049611; a=rsa-sha256;
	cv=none;
	b=iadj1nvD+22ugif4toCBs/3xSzwBUULgc0L/hniP1cnUH0eqtIh5g9hPDD3bvAjd58GH9M
	nrH//ylSeTclgg5WAxTi6u3thbIHStC2xQKUOwZ48oV7j4aEjHnhKKVscY/hz5T1HrWp8Z
	RgPDRdgQ64OsKq03T6rBiSwO446zhcn7VuxmyArJ5bqZg+F6KdZaAu2tUZH+1MytrX7qio
	4XsWOeQichrVrgwHvHWGoWCJUqyucV3dGb4AC+pngOtxDdymjyyDRxc3vY4VhoqjyDuyi1
	eKfW+mgAU7BV/3S+52FedRx31iKg0eOk+3mRZ9w9XNCZS5y1Bs8CqdwzMXvyjg==
ARC-Authentication-Results: i=1; relay.mimecast.com;
	dkim=pass header.d=zougloub.eu header.s=zougloub.eu header.b=cg2RtDZo; 
	dmarc=none;
	spf=pass (relay.mimecast.com: domain of cj-ko@zougloub.eu designates
	69.70.16.42 as permitted sender)
	smtp.mailfrom=cj-ko@zougloub.eu
Received: from zougloub.eu (zougloub.eu [69.70.16.42]) by relay.mimecast.com
	with ESMTP id us-mta-558-AagQ90Y1PmOKwkLdniLspA-1; Mon, 22 Feb 2021
	22:06:46 -0500
X-MC-Unique: AagQ90Y1PmOKwkLdniLspA-1
Received: from pouet.cJ (exmakhina.com [69.70.16.43])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	key-exchange ECDHE (P-256) server-signature RSA-PSS (2048 bits)
	server-digest SHA256) (No client certificate requested)
	by zougloub.eu (Postfix) with ESMTPSA id A45F814C6AEB;
	Mon, 22 Feb 2021 22:01:12 -0500 (EST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=zougloub.eu;
	s=zougloub.eu; t=1614049272;
	bh=fCMi6wNXfxDmHZyyyKoARX6GjpR39eHR0rJsUk74BM4=;
	h=Date:From:To:Cc:Subject:In-Reply-To;
	b=cg2RtDZo3tnseM3qvvC2x2at1TX21obojSHCP5WLErLA1pHTD+nyoDZLuKqlfaIzC
	bloTdTGbBN4ZQPyMupTqEDqWD4hB2dRrYAgCeu+OOYp4djkwyxn3ik6Wj9BBEHNJc6
	4753//MJlFxm8cDmzHIxw9zXWA6F7PoCRQDwPm0Q=
Date: Mon, 22 Feb 2021 22:00:43 -0500
From: =?UTF-8?B?SsOpcsO0bWU=?= Carretero <cJ-ko@zougloub.eu>
To: gmazyland@gmail.com
Message-ID: <20210222220110.22ee6d0e@pouet.cJ>
In-Reply-To: <20210222211528.848441-1-gmazyland@gmail.com>
MIME-Version: 1.0
Authentication-Results: relay.mimecast.com;
	dkim=pass header.d=zougloub.eu header.s=zougloub.eu header.b=cg2RtDZo; 
	dmarc=none;
	spf=pass (relay.mimecast.com: domain of cj-ko@zougloub.eu designates
	69.70.16.42 as permitted sender)
	smtp.mailfrom=cj-ko@zougloub.eu
X-Mimecast-Spam-Score: -5
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
Cc: dm-devel@redhat.com, mpatocka@redhat.com, samitolvanen@google.com
Subject: Re: [dm-devel] [PATCH] dm-verity: Fix FEC for RS roots non-aligned
 to block size
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
Content-Type: multipart/mixed; boundary="===============7330885356595869202=="
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11

--===============7330885356595869202==
Content-Type: multipart/signed; boundary="Sig_/eoGBHlJoA07ceIlOkTc_b8=";
	protocol="application/pgp-signature"; micalg=pgp-sha256

--Sig_/eoGBHlJoA07ceIlOkTc_b8=
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Tested-by: J=C3=A9r=C3=B4me Carretero <cJ-ko@zougloub.eu>


I smoke-tested by fuzzing contiguous ranges of user data (not hash
tree) and correction works up to the amount of added correction (since
erasures are identified by hashes).

Since the fix looks obvious, this should probably CC to stable?

--=20
J=C3=A9r=C3=B4me

--Sig_/eoGBHlJoA07ceIlOkTc_b8=
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEk5TkdsnFh9XvC+SieNwb2r75s3MFAmA0b/YACgkQeNwb2r75
s3NPZBAArz65nZc8QbaUR0gEeyLr8km6LAkpZFbKAxHFwyKjfVaJSN3J34qe3mja
7CdNYTItY/ihKLKKtDn6JtsBjwXkOUnCFRTlJq8OqaljfEjsJCQkE8q9W5sqT9jb
a9Fq9I1ibzcFPZHTV6SXABCsq9cd0aQGD9ImgOUifjHRV0hgLuzh6HZZPY8qWJ6K
hFQXW4JiKduvzyARfPhlInwPXSQLymhsmF0eZevcGQ6aH4fqpyAijr62W9uUOVDK
ZSKjUd0SAM/NihOi/XZ9WVPBEbCZnLjrztMWbmRnFvf9BNCFFLx7dLf03APo3Jps
C7GkuC7luGu+cU0WM1UzhLyvA4bFepgdvUUHIzBBvqtXhcr+4ri2bAZtAxzBXj7b
XRogcPTgTrwXjneySG4bWMe0GAhnMMKr6ARklfy14lBgrPjChMQMs7vUY0un5xyC
6pr1e644Q+RUR4qXSRWknvbxMKyh9Zo+kN8hs/adWuE78AN8XtZRMFDHeqXZiL4Q
j43yTP7FxrG2CrrAI7bqnrh6in4QG7dfWe0lOD86DZP/fsmIh88wXr9jJFCPaPFu
CNwISAbN2lSDNmkQUjAHnTNyATCZztK9WkaOy9LKbZIM7YydvKlYIynaXlM6tzdN
K440wXgoZzIIH8SBCKoaoGlX8uBRtuH2/VHbGjlVxtvhbRyrltQ=
=v7Vx
-----END PGP SIGNATURE-----

--Sig_/eoGBHlJoA07ceIlOkTc_b8=--


--===============7330885356595869202==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel
--===============7330885356595869202==--

