Return-Path: <SRS0=wQ+j=IQ=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.0 required=3.0 tests=BAYES_00,DKIM_ADSP_CUSTOM_MED,
	DKIM_INVALID,DKIM_SIGNED,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6A434C43332
	for <dm-devel@archiver.kernel.org>; Thu, 18 Mar 2021 09:15:15 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 0607A64F30
	for <dm-devel@archiver.kernel.org>; Thu, 18 Mar 2021 09:15:14 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 0607A64F30
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-573-D3jfXQljNxWiIsTFs4B-HQ-1; Thu, 18 Mar 2021 05:15:11 -0400
X-MC-Unique: D3jfXQljNxWiIsTFs4B-HQ-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 076658162F;
	Thu, 18 Mar 2021 09:15:06 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id CF979610F1;
	Thu, 18 Mar 2021 09:15:05 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 895B44A7CD;
	Thu, 18 Mar 2021 09:15:05 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
	[10.11.54.6])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 12HHcprm004190 for <dm-devel@listman.util.phx.redhat.com>;
	Wed, 17 Mar 2021 13:38:52 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id D98BE2166BA2; Wed, 17 Mar 2021 17:38:51 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast04.extmail.prod.ext.rdu2.redhat.com [10.11.55.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id D2D2B2166B44
	for <dm-devel@redhat.com>; Wed, 17 Mar 2021 17:38:49 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [207.211.31.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 6C1B6101A531
	for <dm-devel@redhat.com>; Wed, 17 Mar 2021 17:38:49 +0000 (UTC)
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed;
	d=dkim.mimecast.com; s=201903; t=1616002729;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	to:to:cc:mime-version:mime-version:content-type:content-type:
	dkim-signature; bh=KWnPjhHvY07vrcCSeD6jWJNd/u8GP81+i4vsSnST2f0=;
	b=VoBNxr5afHnAs5ZCIfOuBDuk6aVveYpKjiRucyNR0GUtj3X9BdFz5LzkvngOAtfEZi3v3H
	+Re8VPYGTLS8NZJrPLYnK2EzkFu2b0UL2j9w/o7O2Xgl2MBSmEDwxrvXRIXEVGIP7JVH+d
	eqL3ryNcRhur/va3KvMzlXT2hkpS3qW1jCLrK+T7B1GMdKim1VRLkXRvuh/+os7jSr3ZzJ
	n0+0Y02P+u1vv8omSoQQJazOeAG4YVxEUsxk+z/ySk8JqZYPUBJkzz5zAIdfaC9Y3e+zJN
	a/Dvnp70D1lf7id0cifERIRyc4/9PSj2gj7zQV/fH+7ndqqZNd2cDliY1AKRlw==
ARC-Seal: i=1; s=201903; d=dkim.mimecast.com; t=1616002729; a=rsa-sha256;
	cv=none;
	b=VeBvYv+c/lksdK6UJqO26bNeblXgc9HBKpc5Ym3JV7k8prExMBwfpgsvFnWFjoGjbrbBvc
	smjEbBdf/BDcpLUbtWdt6RyglIfny/iEM3ddb5wlvJapOJV6jU3+9zgeyI+Dxn5DVEzaEG
	DQGe3OmRkEIQZwP4xPLaQg1UquD/6nNTIKKfI9F5KE+bOUfpkq0RXakggZhg6yUL+vyRLw
	pMamiHw+hVE+1sVwxVzTSy62SZGWXdwhgCD/I73SSqfg/hdOEa3htkGHSpE6wXXaPzNYlT
	UeHD6Jr/nReu1AywgiUaQrme62ubdYLIeZFul5BNppgf07opX342UrqH4WMP6g==
ARC-Authentication-Results: i=1; relay.mimecast.com;
	dkim=pass header.d=gmail.com header.s=20161025 header.b=ta797dXg;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (relay.mimecast.com: domain of demiobenour@gmail.com
	designates 209.85.222.169 as permitted sender)
	smtp.mailfrom=demiobenour@gmail.com
Received: from mail-qk1-f169.google.com (mail-qk1-f169.google.com
	[209.85.222.169]) (Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-577-Fq04TI_bMr-DeEh8Rku3EA-1; Wed, 17 Mar 2021 13:38:46 -0400
X-MC-Unique: Fq04TI_bMr-DeEh8Rku3EA-1
Received: by mail-qk1-f169.google.com with SMTP id n24so9548208qkh.9
	for <dm-devel@redhat.com>; Wed, 17 Mar 2021 10:38:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmail.com; s=20161025;
	h=to:from:subject:message-id:date:user-agent:mime-version;
	bh=58I/TNBEh569jn1KJ1kuTErOVxeW4FV/VxmiZuAJnvU=;
	b=ta797dXg6pRIqw6iePwJyMqAuAPPID7+G4z38UXPBELnWYukvZfyXM96RmMu9ie4NS
	1Y4/chKOoqzjp6u3W2IMmx50URtTG1oKXLxXYZY/ymeSK7SE2OQmBAEGIP0r5qIh0IhA
	iB6stMY5GoDq0OJ2/uFyLiUaMgu+c3oouuWx8M6idnCBtx8z4CX3Qy+5JmjudTnsvhCU
	iQnjpIFPKkRNPidGH8NTG+lmhHBwIVuOePTHyTWhsRtfmQ5C0nQ5vZmybSD/XNzwji0a
	izMJB0wVFd7pbaAe/FjTYyiPg4TqebVZZiW88e8yDbF76BDWbB9sWjfqwDwAsN5IfVbM
	cwfQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=1e100.net; s=20161025;
	h=x-gm-message-state:to:from:subject:message-id:date:user-agent
	:mime-version;
	bh=58I/TNBEh569jn1KJ1kuTErOVxeW4FV/VxmiZuAJnvU=;
	b=KkexolDx+eZZK6iesdnZgE88cQFtGu9lB0F5HjSAj2t8fM/HUYfP4PHvDe8bkkhpSw
	dKH7SPKIKReINd273LvDSBJG6NdXkxBG0OpU3jqhtLicO75KtIyONz+Rb8FZCyCCqo9/
	ujhO8tXy5a+Xev/TlFdbupSQjxZsqaDSobttlruUmA8gkZb9nflh9vkLNhH6uVHMVJ4b
	MrVfbABLFrdYuRhghNXZca/Zy6eG/0s0dXhPoz2VKVqrEQQCgHJHoEtLwVC+lweMYssO
	0iFacE1OKsdXEBOHbAtEjOT+OwoEnyV0fpbgX3bPuz+kvRu4V4clnVKC1Y4EtVGKFT+I
	tqFg==
X-Gm-Message-State: AOAM531HwSk5I4YeNNe4Jn+NPXfWkG33bnbOYoulB+IYqH3vXde6gVch
	bu2OkuJeS5ZU+wgaKtCCG+zUpbHCZsQKYA==
X-Google-Smtp-Source: ABdhPJytMtWYg1j7OhQHBg72TZWCpH0KdMaI/2SywG6CeDD3KtKjRBkyEZP0JRxuaX60i0vTl8nNCA==
X-Received: by 2002:a05:620a:44d1:: with SMTP id
	y17mr282366qkp.247.1616002726041; 
	Wed, 17 Mar 2021 10:38:46 -0700 (PDT)
Received: from [10.139.255.254] ([66.115.173.166])
	by smtp.gmail.com with ESMTPSA id
	o23sm15709838qtm.31.2021.03.17.10.38.44 for <dm-devel@redhat.com>
	(version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
	Wed, 17 Mar 2021 10:38:45 -0700 (PDT)
To: dm-devel@redhat.com
From: "Demi M. Obenour" <demiobenour@gmail.com>
Message-ID: <bdd1f985-0ed9-5bfb-20a5-035442d7d506@gmail.com>
Date: Wed, 17 Mar 2021 13:38:25 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
	Thunderbird/78.8.0
MIME-Version: 1.0
Authentication-Results: relay.mimecast.com;
	dkim=pass header.d=gmail.com header.s=20161025 header.b=ta797dXg;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (relay.mimecast.com: domain of demiobenour@gmail.com
	designates 209.85.222.169 as permitted sender)
	smtp.mailfrom=demiobenour@gmail.com
X-Mimecast-Spam-Score: 5
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Mimecast-Spam-Signature: yes
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.6
X-loop: dm-devel@redhat.com
X-Mailman-Approved-At: Thu, 18 Mar 2021 05:14:45 -0400
Subject: [dm-devel] Thread-safety of libdevmapper
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
Content-Type: multipart/mixed; boundary="===============1071479633411625444=="
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--===============1071479633411625444==
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature";
	boundary="9MIEjA2oWPMWJvYoyGDFioGFvb9WEXpAN"

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--9MIEjA2oWPMWJvYoyGDFioGFvb9WEXpAN
Content-Type: multipart/mixed; boundary="3fnbj3nIx3NwLFc44jj4wQUGixo3m8Bpp";
	protected-headers="v1"
From: "Demi M. Obenour" <demiobenour@gmail.com>
To: dm-devel@redhat.com
Message-ID: <bdd1f985-0ed9-5bfb-20a5-035442d7d506@gmail.com>
Subject: Thread-safety of libdevmapper

--3fnbj3nIx3NwLFc44jj4wQUGixo3m8Bpp
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

>From discussions with the Stratis developers, it appears that libdevmapper
is not thread-safe.  This is very annoying, since it means that every other
library that uses it needs to coordinate synchronization.

Is there some fundamental reason that libdevmapper is not thread-safe, such=
 as
the use of thread-unsafe kernel interfaces?

Sincerely,

Demi M. Obenour
she/her/hers


--3fnbj3nIx3NwLFc44jj4wQUGixo3m8Bpp--

--9MIEjA2oWPMWJvYoyGDFioGFvb9WEXpAN
Content-Type: application/pgp-signature; name="OpenPGP_signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="OpenPGP_signature"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEdodNnxM2uiJZBxxxsoi1X/+cIsEFAmBSPqMACgkQsoi1X/+c
IsG9FxAA3f56wNnERTi5A9dq/BdmQE8wUv8wbsOOJMyzjb7PGPvOBPAEFV+euWun
UQQbrBQUYzyLTk9ca5viWFfbE3+6c7L5fSSy2Q9rbSgi6UHttXMi0lEy4wJfQE1J
5NhPxgTV10yj7FrkEonpkFsG/du/y2UlKe2IaefLhIn6QnBP6qm1GQoMqWvg0CUN
pIR6OHON9wJY1ZvolFncVw/bhIBpznHh9iOp9pDVF1BIt6Bs/NArbyn11iAjnTCX
3P7EA7UI+Xn2KOSfDKms5I9PWOkd7Xo0KPO/2F7or2iwft9+X9QubdLs2y3yISga
kgBc+zkUcPUo0uyc9bEuEv9Ai31pm2scDoHdUFfO31BpJqAtls/CKGvJNDR+51rF
VHK3yEfkeva+UkVOZ/EsDjOLiP6BrXBL5I5jIXCPyZg1K9lc7QsyWzum3Vyax5nq
xZ5hyIVkY1IAd61Drrlz+v2F1e0fUwMuu/YYI7Nuv36EUlSprjz7NhjnOXwjo7oZ
hWJn2x/Y0byN04GXBTtt82L8CvquihGlm/y1zWfyylcj2Vu2KZroA/CGeqBMXhji
igLnWw6ABeaLNVbNsE711OjBPA1WiUAzFkmT3ir2wUj4F2q81G2curXjGyGBn5KU
wsot6KjG7/8af2qZyVI4/INdzZ3ca0b9B8A9oh1vFAQADwDnh7E=
=Eqmo
-----END PGP SIGNATURE-----

--9MIEjA2oWPMWJvYoyGDFioGFvb9WEXpAN--


--===============1071479633411625444==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel
--===============1071479633411625444==--

