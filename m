Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 93D15C43217
	for <dm-devel@archiver.kernel.org>; Mon,  9 May 2022 07:53:35 +0000 (UTC)
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-426-5V900OW1POa4mLELqCCN-w-1; Mon, 09 May 2022 03:53:30 -0400
X-MC-Unique: 5V900OW1POa4mLELqCCN-w-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id A253E100BAA0;
	Mon,  9 May 2022 07:53:28 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 84EC414609AD;
	Mon,  9 May 2022 07:53:28 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 6D4F3194706E;
	Mon,  9 May 2022 07:53:26 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
 [10.11.54.6])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 8B206194704E
 for <dm-devel@listman.corp.redhat.com>; Sun,  8 May 2022 04:40:52 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 553C42166B48; Sun,  8 May 2022 04:40:52 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast10.extmail.prod.ext.rdu2.redhat.com [10.11.55.26])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 5035D2166B2F
 for <dm-devel@redhat.com>; Sun,  8 May 2022 04:40:49 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [205.139.110.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id E064F1C05B05
 for <dm-devel@redhat.com>; Sun,  8 May 2022 04:40:48 +0000 (UTC)
Received: from out1-smtp.messagingengine.com (out1-smtp.messagingengine.com
 [66.111.4.25]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-340-zbncWVLFOou1knNjIoPSZQ-1; Sun, 08 May 2022 00:40:46 -0400
X-MC-Unique: zbncWVLFOou1knNjIoPSZQ-1
Received: from compute2.internal (compute2.nyi.internal [10.202.2.46])
 by mailout.nyi.internal (Postfix) with ESMTP id 686EF5C005F;
 Sun,  8 May 2022 00:40:46 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
 by compute2.internal (MEProxy); Sun, 08 May 2022 00:40:46 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
 messagingengine.com; h=cc:cc:content-type:date:date:from:from
 :in-reply-to:in-reply-to:message-id:mime-version:reply-to:sender
 :subject:subject:to:to:x-me-proxy:x-me-proxy:x-me-sender
 :x-me-sender:x-sasl-enc; s=fm1; t=1651984846; x=1652071246; bh=N
 ew1kHAYn2RAULfL2ULXIJxNYWlQQiUEdCVT1uKZn6k=; b=r42uasgFii/DdMNXv
 Scw/IFsoZnWMWairAZPWq7pyAPtq2X+y4XfMMo4VM3/GyyLsqqedCFUTJT6UA1xc
 0evtOG4ZyhgHjhOgvfXATD9wFEumms2xfP4xW9unnqrPcl4gwikQGjQXB/gpb9Y4
 xvWw3PIsqytkV69MAfLOrhO6kaLhvSZ9olQ/+LUu87V1hX/Ky33gfKcaJ+MOxVjh
 LhFViyXIqn/hvhu/P1noc4T6XU4eOARuYbHJ8vxKxXzEZRd3Sc8g2a9STeF92kR1
 +npv9oU2Oxevn/aIbAoeM5Kq9fUlP0LvHwXNUYxvJFAPMosdjwIBW8PNwaBYeP05
 0fOcQ==
X-ME-Sender: <xms:zkl3Yk1_srdPr0GUuI3ixxsCouG3f8hNJr4x-HVEY7aJFpeiYmDCJQ>
 <xme:zkl3YvF9Uf7O8NOg9sHrBnZ6fYI7kf5RrvL03xrCWJxRe96Ot6vmb9ZVAfLNY7JPF
 xCF-SkIVnb_czY>
X-ME-Received: <xmr:zkl3Ys59ZY9ive8kExBtGs7f-fSNfSq_wytrOSNfWUB7ck57G0zJStIQbM_0>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvfedrfeeigdekhecutefuodetggdotefrodftvf
 curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
 uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
 fjughrpeffhffvvefukfggtggujgesghdtreertddtvdenucfhrhhomhepffgvmhhiucfo
 rghrihgvucfqsggvnhhouhhruceouggvmhhisehinhhvihhsihgslhgvthhhihhnghhslh
 grsgdrtghomheqnecuggftrfgrthhtvghrnhepieelkeetleegieeufedvffeifeefveeg
 gfeutdehteevteefueehhfduhfetfeehnecuvehluhhsthgvrhfuihiivgeptdenucfrrg
 hrrghmpehmrghilhhfrhhomhepuggvmhhisehinhhvihhsihgslhgvthhhihhnghhslhgr
 sgdrtghomh
X-ME-Proxy: <xmx:zkl3Yt0QCSCuNfEQx7_3yh1ZIGavCuVJMHCjtMfImWZnMV6TiAUYig>
 <xmx:zkl3YnGAAjfoK2h3mu23wK6QuMnaF0AN-wunbKm52nlIlVglRQE5sw>
 <xmx:zkl3Ym_SiJLD3A3mkfRxxbn82Mc6nRPWa07TMQl0nNEB-lweYRmIdg>
 <xmx:zkl3YsTKOCE2xyhJiP97esEF_hJn90blYVDYvnVawDHLh_h0fI8FKA>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Sun,
 8 May 2022 00:40:45 -0400 (EDT)
Date: Sun, 8 May 2022 00:40:25 -0400
From: Demi Marie Obenour <demi@invisiblethingslab.com>
To: Mikulas Patocka <mpatocka@redhat.com>, Mike Snitzer <msnitzer@redhat.com>
Message-ID: <YndJzCY5sZG3k5q5@itl-email>
MIME-Version: 1.0
In-Reply-To: <alpine.LRH.2.02.2204250851320.1699@file01.intranet.prod.int.rdu2.redhat.com>
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.6
X-Mailman-Approved-At: Mon, 09 May 2022 07:53:25 +0000
Subject: Re: [dm-devel] [PATCH v2] dm-crypt: make printing of the key
 constant-time
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
Cc: dm-devel@redhat.com, Milan Broz <gmazyland@gmail.com>,
 stable@vger.kernel.org
Content-Type: multipart/mixed; boundary="===============5219736901724564518=="
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.7


--===============5219736901724564518==
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="cOu/gkykmDr07wxN"
Content-Disposition: inline


--cOu/gkykmDr07wxN
Content-Type: text/plain; protected-headers=v1; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
Date: Sun, 8 May 2022 00:40:25 -0400
From: Demi Marie Obenour <demi@invisiblethingslab.com>
To: Mikulas Patocka <mpatocka@redhat.com>,
	Mike Snitzer <msnitzer@redhat.com>
Cc: dm-devel@redhat.com, Milan Broz <gmazyland@gmail.com>,
	stable@vger.kernel.org
Subject: Re: [dm-devel] [PATCH v2] dm-crypt: make printing of the key
 constant-time

Nit: did you mean CC: stable@vger.kernel.org (colon instead of
semicolon)?  Also, would it be better to avoid using the formatting
built-in to DMEMIT()?  Finally, are there any architectures for which
gcc or clang make this non-constant-time?
--=20
Sincerely,
Demi Marie Obenour (she/her/hers)
Invisible Things Lab

--cOu/gkykmDr07wxN
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEdodNnxM2uiJZBxxxsoi1X/+cIsEFAmJ3ScsACgkQsoi1X/+c
IsGt3RAA2hU0+iLv18E6gyonqnEFcAw1qMWO8eVBJ/J/zUiYSBile1ubZOESzt2T
9ic5zo6o1U34u+8g0O5kKAvtXPWZIsXEILA5Bs8rKPtWYRDy/0yfJdqDJ7tEtCjR
YIEH04j3EHVdYU4VznizQ3G2OYuhFXv1TaD9TGONlwHLtwx8fBSmpixFRxcvscol
GOQrpWT1CgYzr2zju5MpAEAOeTTAkKqDBYIgPwhOglfQ2KHKPn+Ao4nDiGVUPIvb
lLuKodoaMvxcx3vNqIGkL/lL0ivJwoqwNhDBq+UT5fA8id9Rtskh4kwYv/B+3PRm
9pAMsldNCtLMWbf7Vtcf2dfTOfqifZ/FMf14Cw2LvgA0rn3lINdM39N/Pd6LngMm
qvXxy8Ot2G8NWb9BK7ZkbzB7yHA7xnTdREfk8eFF7FYyJFWi4SDqryUqjm11FSa0
3fvUXUSUooFk1tgIIqXVDFUB8kzQjZ5TP3c47vTabKQubwHxmdYuAwM4U3dxN27B
J0nURU67xlup/r5A/7siPVteNjQ7KfkT4MVHL2WW6bOSQrsyutqqIiEFvbYkp5Ug
e/e6/vWB3GTfnAPRX+b1NNLcuFOMRi0Q5qv9IPa4SMJf9vP8YtAcRikjNrhyITf+
s5Y0gCb2vup7fHeOC6a7ac4wj7NbN0O1vvEnsBKENq3ufjLBtsg=
=pKVN
-----END PGP SIGNATURE-----

--cOu/gkykmDr07wxN--


--===============5219736901724564518==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

--===============5219736901724564518==--

