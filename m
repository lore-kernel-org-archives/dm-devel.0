Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5CBA3C4332F
	for <dm-devel@archiver.kernel.org>; Mon, 11 Apr 2022 06:19:35 +0000 (UTC)
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-617-ndByixvaOnmkeYAs5MgufQ-1; Mon, 11 Apr 2022 02:19:30 -0400
X-MC-Unique: ndByixvaOnmkeYAs5MgufQ-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id BF1E53803906;
	Mon, 11 Apr 2022 06:19:27 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id AE39EC35994;
	Mon, 11 Apr 2022 06:19:27 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 0E3BA194E109;
	Mon, 11 Apr 2022 06:19:25 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
 [10.11.54.5])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 73EDA19466DF
 for <dm-devel@listman.corp.redhat.com>; Sun, 10 Apr 2022 22:11:15 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 652327C55; Sun, 10 Apr 2022 22:11:15 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast10.extmail.prod.ext.rdu2.redhat.com [10.11.55.26])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 60B987C4E
 for <dm-devel@redhat.com>; Sun, 10 Apr 2022 22:11:08 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [205.139.110.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 212D51C05AAF
 for <dm-devel@redhat.com>; Sun, 10 Apr 2022 22:11:08 +0000 (UTC)
Received: from wout5-smtp.messagingengine.com
 (wout5-smtp.messagingengine.com [64.147.123.21]) by relay.mimecast.com with
 ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-60-IiRXuEAuPzOuYu8nUopfqQ-1; Sun, 10 Apr 2022 18:11:06 -0400
X-MC-Unique: IiRXuEAuPzOuYu8nUopfqQ-1
Received: from compute5.internal (compute5.nyi.internal [10.202.2.45])
 by mailout.west.internal (Postfix) with ESMTP id 8C6EF3200FA9;
 Sun, 10 Apr 2022 18:04:56 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
 by compute5.internal (MEProxy); Sun, 10 Apr 2022 18:04:56 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
 messagingengine.com; h=cc:cc:content-type:date:date:from:from
 :in-reply-to:message-id:mime-version:reply-to:sender:subject
 :subject:to:to:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender
 :x-sasl-enc; s=fm3; bh=1NFkjAQyamI41mY2q+y6ewEGpFGU8QkAic+IrSg3q
 Oo=; b=nMRstEptLC2pmexha3KYB57DlFvUMvo+eT9n/qUHdKpY2h/05hYwGnKWF
 7fAT9OEvVtmCnyQSJXketIKijR1geQUYuXRJrZIuaWF8O2B1CEJ1v9O8ipiV9Az4
 bRiv4FeIFZhLXirKM1c2UYTqK85RW6GtCkPN084me5HTKm5PK8WL67zCgjB6H7Gn
 gletuurmBNgzYR/gd/K6AXSRqozMpMLzPug/t6JO9XYGAmKss5VPR9EhDfnWOxFB
 pCnftf0z+uOzBnymu3M9xtDXV/Ob+U5h3/JnGoJ3IlTH4zwxi0usmePF7xx41nyj
 H0OWnpUFvxIMXJVg/LtB8ZweSdw1g==
X-ME-Sender: <xms:iFRTYvCH90C4xDYIne2GdgdXi9JuJhJz3wH0gKL2ec2oylhcqghbuQ>
 <xme:iFRTYlidvMbzdWL6bJlv9X_2fFqinrUang9xQmw-qy52RrmEVATH7r5rDKHsg_YrE
 uP16Xv1051fbq8>
X-ME-Received: <xmr:iFRTYqlmLGhU8M93IgxCpBmAwG0D-GKL1dxGCwQ1v-dW3WppzRdHo0-EOYb0>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvvddrudekhecutefuodetggdotefrodftvfcurf
 hrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecuuegr
 ihhlohhuthemuceftddtnecunecujfgurhepfffhvffukfggtggusehgtderredttdejne
 cuhfhrohhmpeffvghmihcuofgrrhhivgcuqfgsvghnohhurhcuoeguvghmihesihhnvhhi
 shhisghlvghthhhinhhgshhlrggsrdgtohhmqeenucggtffrrghtthgvrhhnpeeljedtge
 ejffelveefueelheejgfdvfefhhefgjeegleetgedtteejleeuueevfeenucevlhhushht
 vghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpeguvghmihesihhnvhhish
 hisghlvghthhhinhhgshhlrggsrdgtohhm
X-ME-Proxy: <xmx:iFRTYhz40rUkEdxQSiutBiUHeA83zfChcFpYiwBHf8j-kJsk8XBtBQ>
 <xmx:iFRTYkSQ0DN3fNP-M9xOzeOVgnEcayXanmOcjfjTx_jzyoYMaO51kw>
 <xmx:iFRTYkYhAelgQV_nL9dGfpMMqGJ3Z0nSO1fcW1ZUvW7-gyOHR8lsGQ>
 <xmx:iFRTYjMjhpnELBontmiG4ef75cz3xYN6jHo3gZgHWsaxIG4WoqlNSQ>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Sun,
 10 Apr 2022 18:04:55 -0400 (EDT)
Date: Sun, 10 Apr 2022 18:03:56 -0400
From: Demi Marie Obenour <demi@invisiblethingslab.com>
To: Joe Thornber <ejt@redhat.com>
Message-ID: <YlNUhtXltj8vgvcZ@itl-email>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.11.54.5
X-Mailman-Approved-At: Mon, 11 Apr 2022 06:19:21 +0000
Subject: [dm-devel] Potential enhancements to dm-thin v2
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
Cc: dm-devel@redhat.com
Content-Type: multipart/mixed; boundary="===============1387832672996918267=="
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.8


--===============1387832672996918267==
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="BSM3hf3au0I54JDH"
Content-Disposition: inline


--BSM3hf3au0I54JDH
Content-Type: text/plain; protected-headers=v1; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
Date: Sun, 10 Apr 2022 18:03:56 -0400
From: Demi Marie Obenour <demi@invisiblethingslab.com>
To: Joe Thornber <ejt@redhat.com>
Cc: dm-devel@redhat.com
Subject: Potential enhancements to dm-thin v2

For quite a while, I have wanted to write a tool to manage thin volumes
that is not based on LVM.  The main thing holding me back is that the
current dm-thin interface is extremely error-prone.  The only per-thin
metadata stored by the kernel is a 24-bit thin ID, and userspace must
take great care to keep that ID in sync with its own metadata.  Failure
to do so results in data loss, data corruption, or even security
vulnerabilities.  Furthermore, having to suspend a thin volume before
one can take a snapshot of it creates a critical section during which
userspace must be very careful, as I/O or a crash can lead to deadlock.
I believe both of these problems can be solved without overly
complicating the kernel implementation.

The metadata problem can be solved by allowing userspace to (1)
associate a 256-byte binary blob with each thin volume and (2) easily
enumerate the thin volumes in a pool.  Even with 16777216 thins, this
would only use 4GiB of space, and dm-thin v2 will support far larger
metadata volumes.  While being able to look up thins by the blob would
be awesome, I would be okay with just enumerating thins at startup and
caching the ID =E2=87=94 blob mapping in userspace, at least if thin IDs be=
come
64-bit so I do not have to worry about reuse.  Being able to enumerate
the thin volumes would allow me to rely solely on the metadata in the
thin pool, without having to manage any metadata in userspace.  Looking
at the existing implementation, this seems to be fairly simple: the
current B-tree code supports arbitrary value sizes already, so the blob
could be appended to 'struct disk_device_details'.  (Requiring the size
of the blob to be set at pool creation, or when the pool is empty, is
fine.)

The suspend problem can be solved by having the kernel automatically
suspend a thin volume before taking a snapshot of it, and resuming
afterwards.  This removes a footgun from the userspace API, and should
improve reliability too, as it reduces the number of error conditions
that can hang the system.  Per discussion with Zdenek, having the kernel
do this automatically is infeasible for arbitrary device stacks, but
this is a common special case.
--=20
Sincerely,
Demi Marie Obenour (she/her/hers)
Invisible Things Lab

--BSM3hf3au0I54JDH
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEdodNnxM2uiJZBxxxsoi1X/+cIsEFAmJTVIYACgkQsoi1X/+c
IsE3DRAAqPMnYTPeaOzaig51bEzNQF85nJP+gy2TdYSvxOiTw4IXBryDbVV1wiRF
gsHun2okgURAjlCaWDxX+hCzG0w7iSz4nh08WpnDPjIsEx5F8BB8JrD7Bc6fT0rz
Jy4WWho/GV0KcQAu4vssUO1F297Kj66tTQoy/OCpP+yrJ6L4RckXX6Mtk0SDRU+v
taA18ZWTZPNY7p1J/v2RwFWoQ8p47k07QgjxDSE9u4YrcD/FlS3FX9aJ1RC8wuUQ
ItmCm8YnSgEQIEVH7pXT0/8pW0rST8dU8sf2N1IQbDawBVu0trURlzjRjLBxGPta
pJG5ZQzkhtWa8fHHfvLvqgC/icNYVqWQgKZvZ+JhISL/TMoyAM4ePuFlFV/psEet
jxWVx0DQbCCOm/TOXUN1caDnZkpeXKoHpOa4Ql/IY2JQn48whlYH+C0rsh4IgRBX
TmtVBzLGzKgTtTt/Wxv0vkVrQtEEcZQ1y1YZ8zRfByWollw4b7O1HIbg7j1LOY/k
SGPf377JnYTILEIKF9ys3d2q22TLXPREbn6+MVaoooDmlaUpWO5sM3wgvNXw+4Sj
I/6J1fVvMy46CdOCwfJ/x0B37iB3LV1ZIiq7QJJsDNu/9kzwHOBpBjw/SlmPRm5B
yz4socIQtiswAETSZ5URPik9xZtqcZZvydumcKpSjzVD98iu9tY=
=v2t8
-----END PGP SIGNATURE-----

--BSM3hf3au0I54JDH--


--===============1387832672996918267==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

--===============1387832672996918267==--

