Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DDFCFC7EE2A
	for <dm-devel@archiver.kernel.org>; Mon,  5 Jun 2023 06:04:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1685945055;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:in-reply-to:in-reply-to:
	 references:references:list-id:list-help:list-unsubscribe:
	 list-subscribe:list-post; bh=H+XNtv0SwLvP6mM9fqQHffm0p+tJ9lr1z/oHX9xpfUI=;
	b=dfyWRh0VvpGBH/IKuOJklwb+PUJsNcZELbyo0SYkNP6D+/gXD20vATiURn7UC3jcV8vIyA
	eYjXmQle0s5vqZnx65zMznPoYlgkxvj1aM03bzgQQXmZFLcfoHKPB6PvsgROHMB+2f170F
	bAyWD0xQ5IMDZIcxehhi/0us8kg78to=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-435-oxkGu-uOPvutRZJAS82Pvg-1; Mon, 05 Jun 2023 02:04:10 -0400
X-MC-Unique: oxkGu-uOPvutRZJAS82Pvg-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 54E898039CE;
	Mon,  5 Jun 2023 06:04:08 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 430E7140EBB8;
	Mon,  5 Jun 2023 06:04:08 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id E4D171946F20;
	Mon,  5 Jun 2023 06:04:05 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com
 [10.11.54.7])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 58D751946595
 for <dm-devel@listman.corp.redhat.com>; Mon,  5 Jun 2023 03:08:06 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id E91D31410F25; Mon,  5 Jun 2023 03:08:05 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast08.extmail.prod.ext.rdu2.redhat.com [10.11.55.24])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id DFDC31400AFC
 for <dm-devel@redhat.com>; Mon,  5 Jun 2023 03:08:05 +0000 (UTC)
Received: from us-smtp-inbound-1.mimecast.com (us-smtp-1.mimecast.com
 [207.211.31.81])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id C8368380671E
 for <dm-devel@redhat.com>; Mon,  5 Jun 2023 03:08:05 +0000 (UTC)
Received: from mail-oa1-f47.google.com (mail-oa1-f47.google.com
 [209.85.160.47]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-665-GTOr-CorNfqe5e9RPMkjcg-1; Sun, 04 Jun 2023 23:08:02 -0400
X-MC-Unique: GTOr-CorNfqe5e9RPMkjcg-1
Received: by mail-oa1-f47.google.com with SMTP id
 586e51a60fabf-19f3550bcceso4028919fac.0; 
 Sun, 04 Jun 2023 20:08:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=gmail.com; s=20221208; t=1685934481; x=1688526481;
 h=in-reply-to:content-disposition:mime-version:references:message-id
 :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
 bh=HmucptkZoDu3+K08LKOsMYAoXOw3eVCfWImOiCZOdF8=;
 b=X+TDiHxfgevZOeX20EHHhoXH2LvvAtjtpoG85idHqVCYPVuM/OgwXjMZ4NHjNJY86Z
 GaQ11IlULLuCY3w1Gmw6vpbm1Z1HEmOf0SYMrWBhWSueRiw0vJkVMbUwfsftq6QSCRC6
 Tx3S4muvvYff4VTGE67lUnpDgScieCAYX8wOGACR0IQxD+bl8RFcwl5u6S9BfU/q0/ym
 pxYuvOuK97Gi2zavSuNFVgJl18kEIujAVrxr3oHASiYn481x6FfxDWJEqH5OHww4BN9Q
 lP9evoAT37Mb64bWXI/e1uGMxM/2mzPZu2FBN5sgap9Bi8uKDmUlae/GHdIfcm4HbL27
 FZ0g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20221208; t=1685934481; x=1688526481;
 h=in-reply-to:content-disposition:mime-version:references:message-id
 :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
 :message-id:reply-to;
 bh=HmucptkZoDu3+K08LKOsMYAoXOw3eVCfWImOiCZOdF8=;
 b=kl1eBYOhJxjTcd1+Tq/Q9KD8gfjZJqqdrg3NbXSL/OOwmFcntZ2gMKyHKSQ056aZmn
 /VMdo0DC5H8KdgAHtssVhKjHX6GTUHepASeh5O85mBKLJ42IO4R0sJ5cUdTLnGKJHJv3
 DKVYRUUK6O5nyiJwOB3YLYMPDcfJ2bCzEe9V+Kz57pknbad6CpkleRdSj3ROkJ5OtXva
 Z6WCHSuXCDuLgf9Lq6+T4TVWGhg63Bsbn5h8Vo4Pz1OXCVKgaYvoMCT3UUs1mskfpOh5
 tgUKVriHN9XTqAdw06o08ZyQ2BvdB4qLL7qOFHoIip+nJ+o0VySXQ5GZz1Ug1cblkyCg
 eQWw==
X-Gm-Message-State: AC+VfDxOD5QsFBpwtm8n0i+ZfEWQARnoYSgHDCmgT1RTNUKuBw4zlmTg
 OSDesG9bfl0wvWIKpWSfPRkP1N/TdL6gcQ==
X-Google-Smtp-Source: ACHHUZ7m72Kp1UdoPnUIdV5YMJ3ZbM2ARYoaAbyUayvanFIB8zvJRCRnKJZXF5okiIpHRPeTIC+3Kw==
X-Received: by 2002:a05:6870:98a6:b0:1a1:2939:3f13 with SMTP id
 eg38-20020a05687098a600b001a129393f13mr8256009oab.24.1685934481111; 
 Sun, 04 Jun 2023 20:08:01 -0700 (PDT)
Received: from debian.me (subs03-180-214-233-4.three.co.id. [180.214.233.4])
 by smtp.gmail.com with ESMTPSA id
 c3-20020a656183000000b0053b92b26412sm4246493pgv.14.2023.06.04.20.08.00
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Sun, 04 Jun 2023 20:08:00 -0700 (PDT)
Received: by debian.me (Postfix, from userid 1000)
 id 0E7941061BF; Mon,  5 Jun 2023 10:07:57 +0700 (WIB)
Date: Mon, 5 Jun 2023 10:07:57 +0700
From: Bagas Sanjaya <bagasdotme@gmail.com>
To: Russell Harmon <eatnumber1@gmail.com>
Message-ID: <ZH1RjWUfq3Af4fiB@debian.me>
References: <CA+zrezTegR8jHQA3MNM6WnfFU_RP4=fiCuk6WgwJZsjZ2PYUSw@mail.gmail.com>
 <20230604190604.4800-1-eatnumber1@gmail.com>
 <20230604190604.4800-3-eatnumber1@gmail.com>
MIME-Version: 1.0
In-Reply-To: <20230604190604.4800-3-eatnumber1@gmail.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.7
X-Mailman-Approved-At: Mon, 05 Jun 2023 06:04:03 +0000
Subject: Re: [dm-devel] [PATCH v3 2/4] Documents the meaning of "buffer" in
 dm-integrity.
X-BeenThere: dm-devel@redhat.com
X-Mailman-Version: 2.1.29
Precedence: list
List-Id: device-mapper development <dm-devel.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/dm-devel>,
 <mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <http://listman.redhat.com/archives/dm-devel/>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/dm-devel>,
 <mailto:dm-devel-request@redhat.com?subject=subscribe>
Cc: dm-devel@redhat.com, mpatocka@redhat.com, snitzer@redhat.com,
 linux-doc@vger.kernel.org
Content-Type: multipart/mixed; boundary="===============0103977891891471631=="
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.7


--===============0103977891891471631==
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="HSFYUBcIsEVvpXlP"
Content-Disposition: inline


--HSFYUBcIsEVvpXlP
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sun, Jun 04, 2023 at 12:06:02PM -0700, Russell Harmon wrote:
> "Buffers" are buffers of the metadata/checksum area of dm-integrity.
> They are always at most as large as a single metadata area on-disk, but
> may be smaller.

Hey, I forgot to mention below.

Where is the subject prefix? The patch title should have been "Documentatio=
n: dm-integrity: Document
buffers".

Thanks.

--=20
An old man doll... just what I always wanted! - Clara

--HSFYUBcIsEVvpXlP
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQSSYQ6Cy7oyFNCHrUH2uYlJVVFOowUCZH1RjQAKCRD2uYlJVVFO
o4s9AQDcc+iJrSPFyOxiVtNsDj14f0Sd9tDmnXoUZ7wDxKqPRAEAquh4m8KjN8Cx
crwOHqbq0WwzkHlXZuPC2dSSz1XGmgs=
=lfu6
-----END PGP SIGNATURE-----

--HSFYUBcIsEVvpXlP--


--===============0103977891891471631==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

--===============0103977891891471631==--

